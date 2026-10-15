import '../../core/grid.dart';

/// A board of lights: [start] says which are on. Tapping a cell flips it and
/// its side neighbours (across the edges too when [wrap]); every light must
/// end up off.
class NightfallPuzzle {
  const NightfallPuzzle({
    required this.rows,
    required this.cols,
    required this.start,
    required this.plan,
    this.wrap = false,
    this.limit,
  });

  final int rows;
  final int cols;
  final bool wrap;
  final List<bool> start;

  /// A fewest-taps solution: the cells to tap (each once, in any order).
  final List<int> plan;

  /// Most taps allowed, or null for no limit.
  final int? limit;

  GridSize get size => GridSize(rows, cols);
  int get best => plan.length;

  Map<String, dynamic> toJson() => {
    'rows': rows,
    'cols': cols,
    if (wrap) 'wrap': true,
    'start': bitsToString(start),
    'plan': plan,
    if (limit != null) 'limit': limit,
  };
  factory NightfallPuzzle.fromJson(Map<String, dynamic> j) => NightfallPuzzle(
    rows: j['rows'] as int,
    cols: j['cols'] as int,
    wrap: j['wrap'] as bool? ?? false,
    start: bitsFromString(j['start'] as String),
    plan: (j['plan'] as List).cast<int>(),
    limit: j['limit'] as int?,
  );
}

/// The lights, the cells tapped an odd number of times, and the taps so far.
class NightfallState {
  const NightfallState(this.on, this.pressed, this.moves);

  final List<bool> on;
  final List<bool> pressed;
  final int moves;

  factory NightfallState.initial(NightfallPuzzle p) => NightfallState(p.start, List.filled(p.start.length, false), 0);

  bool get dark => !on.contains(true);
  int get lit => on.where((b) => b).length;

  Map<String, dynamic> toJson() => {'on': bitsToString(on), 'pressed': bitsToString(pressed), 'moves': moves};
  factory NightfallState.fromJson(Map<String, dynamic> j) => NightfallState(
    bitsFromString(j['on'] as String),
    bitsFromString(j['pressed'] as String),
    j['moves'] as int,
  );
}

String bitsToString(List<bool> bits) => bits.map((b) => b ? '1' : '0').join();
List<bool> bitsFromString(String s) => [for (var i = 0; i < s.length; i++) s.codeUnitAt(i) == 0x31];

/// [state] after tapping cell [i] (one more move).
NightfallState nightfallTap(NightfallPuzzle p, NightfallState state, int i) {
  final on = List.of(state.on);
  for (final j in NightfallGeometry.of(p.rows, p.cols, p.wrap).flips[i]) {
    on[j] = !on[j];
  }
  final pressed = List.of(state.pressed);
  pressed[i] = !pressed[i];
  return NightfallState(on, pressed, state.moves + 1);
}

/// The lights that tapping each cell of [taps] once leaves on [start].
List<bool> nightfallLights(NightfallGeometry g, List<bool> start, List<bool> taps) {
  final on = List.of(start);
  for (var i = 0; i < taps.length; i++) {
    if (!taps[i]) continue;
    for (final j in g.flips[i]) {
      on[j] = !on[j];
    }
  }
  return on;
}

/// Kernels larger than this are not searched exhaustively for the fewest taps.
const _maxEnumerated = 16;

/// The linear algebra of one board shape over GF(2): tapping is adding the
/// tap's flip pattern, so a board is solved by the taps x with A·x = lights,
/// where A is symmetric (cell i flips cell j iff j flips i). One Gaussian
/// elimination of [A | I] per shape (cached) answers every board of it.
class NightfallGeometry {
  NightfallGeometry._(this.rows, this.cols, this.wrap) : flips = _flips(rows, cols, wrap) {
    _eliminate();
  }

  static final _cache = <String, NightfallGeometry>{};

  factory NightfallGeometry.of(int rows, int cols, bool wrap) =>
      _cache.putIfAbsent('$rows,$cols,$wrap', () => NightfallGeometry._(rows, cols, wrap));

  final int rows;
  final int cols;
  final bool wrap;

  /// The cells tapping each cell flips, itself first.
  final List<List<int>> flips;

  int get cellCount => rows * cols;

  /// Rows of the reduced matrix: pivot column per row (rank rows).
  late final List<int> _pivots;

  /// Row i of the transform T (so that the reduced system is R·x = T·b).
  late final List<List<int>> _transform;

  /// Taps that change nothing (a basis of the kernel of A).
  late final List<List<bool>> kernel;

  static List<List<int>> _flips(int rows, int cols, bool wrap) => [
    for (var r = 0; r < rows; r++)
      for (var c = 0; c < cols; c++)
        {
          r * cols + c,
          for (final (dr, dc) in const [(-1, 0), (1, 0), (0, -1), (0, 1)])
            if (wrap)
              ((r + dr) % rows) * cols + (c + dc) % cols
            else if (r + dr >= 0 && r + dr < rows && c + dc >= 0 && c + dc < cols)
              (r + dr) * cols + c + dc,
        }.toList(),
  ];

  void _eliminate() {
    final n = cellCount;
    // Rows as bool lists [A | I]; boards stay at 100 cells, so this is cheap.
    final m = [
      for (var i = 0; i < n; i++) [for (var j = 0; j < 2 * n; j++) j == n + i || (j < n && flips[i].contains(j))],
    ];
    final pivots = <int>[];
    var rank = 0;
    for (var col = 0; col < n && rank < n; col++) {
      var p = rank;
      while (p < n && !m[p][col]) {
        p++;
      }
      if (p == n) continue;
      final t = m[p];
      m[p] = m[rank];
      m[rank] = t;
      for (var q = 0; q < n; q++) {
        if (q == rank || !m[q][col]) continue;
        final row = m[q];
        for (var j = col; j < 2 * n; j++) {
          if (t[j]) row[j] = !row[j];
        }
      }
      pivots.add(col);
      rank++;
    }
    _pivots = pivots;
    final isPivot = List.filled(n, false);
    for (final p in pivots) {
      isPivot[p] = true;
    }
    final free = [
      for (var j = 0; j < n; j++)
        if (!isPivot[j]) j,
    ];
    _transform = [
      for (var i = 0; i < n; i++)
        [
          for (var j = 0; j < n; j++)
            if (m[i][n + j]) j,
        ],
    ];
    kernel = [
      for (final f in free)
        () {
          final v = List.filled(n, false)..[f] = true;
          for (var i = 0; i < rank; i++) {
            if (m[i][f]) v[pivots[i]] = true;
          }
          return v;
        }(),
    ];
  }

  /// Some taps that put out [lights], or null when no taps can.
  List<bool>? solve(List<bool> lights) {
    final n = cellCount;
    bool y(int i) {
      var v = false;
      for (final j in _transform[i]) {
        if (lights[j]) v = !v;
      }
      return v;
    }

    for (var i = _pivots.length; i < n; i++) {
      if (y(i)) return null;
    }
    final x = List.filled(n, false);
    for (var i = 0; i < _pivots.length; i++) {
      x[_pivots[i]] = y(i);
    }
    return x;
  }

  bool solvable(List<bool> lights) => solve(lights) != null;

  /// The taps that put out [lights] with the fewest taps (ties: the most
  /// cells of [keep]), or null when none can. Among those with at most
  /// [within] taps when given, the one keeping the most of [keep] instead.
  List<bool>? fewest(List<bool> lights, {List<bool>? keep, int? within}) {
    final x = solve(lights);
    if (x == null) return null;
    final n = cellCount;
    int weight(List<bool> v) => v.where((b) => b).length;
    int kept(List<bool> v) {
      if (keep == null) return 0;
      var k = 0;
      for (var i = 0; i < n; i++) {
        if (v[i] && keep[i]) k++;
      }
      return k;
    }

    bool better(List<bool> a, List<bool> b) {
      final wa = weight(a), wb = weight(b);
      if (within != null) {
        final okA = wa <= within, okB = wb <= within;
        if (okA != okB) return okA;
        if (okA && kept(a) != kept(b)) return kept(a) > kept(b);
      }
      if (wa != wb) return wa < wb;
      return kept(a) > kept(b);
    }

    var best = x;
    if (kernel.length <= _maxEnumerated) {
      // Gray code: each step adds one kernel vector.
      final cur = List.of(x);
      for (var g = 1; g < 1 << kernel.length; g++) {
        var bit = 0;
        while ((g >> bit) & 1 == 0) {
          bit++;
        }
        final k = kernel[bit];
        for (var i = 0; i < n; i++) {
          if (k[i]) cur[i] = !cur[i];
        }
        if (better(cur, best)) best = List.of(cur);
      }
    } else {
      // Too many: improve one kernel vector at a time while it helps.
      var improved = true;
      while (improved) {
        improved = false;
        for (final k in kernel) {
          final cand = [for (var i = 0; i < n; i++) best[i] != k[i]];
          if (better(cand, best)) {
            best = cand;
            improved = true;
          }
        }
      }
    }
    return best;
  }
}
