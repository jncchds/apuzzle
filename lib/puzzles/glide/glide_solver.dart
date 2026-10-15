import 'dart:typed_data';

import 'glide_model.dart';

/// Solvers for one frame shape: exact IDA* (Manhattan distance plus linear
/// conflicts, with a node cap) and a row-and-column strategy that works on
/// any size: place the top row (or left column) tile by tile, the last two
/// tiles of the line together, until a 3×3 corner is left, then solve that
/// exactly.
class GlideSolver {
  GlideSolver._(this.rows, this.cols) : n = rows * cols {
    _next = [
      for (var cell = 0; cell < n; cell++) [for (final d in glideDirs.split('')) glideStep(rows, cols, cell, d)],
    ];
  }

  static final _cache = <int, GlideSolver>{};

  factory GlideSolver.of(int rows, int cols) => _cache.putIfAbsent(rows * 64 + cols, () => GlideSolver._(rows, cols));

  final int rows;
  final int cols;
  final int n;

  /// Neighbour cell per cell and direction (u, d, l, r), -1 off the board.
  late final List<List<int>> _next;

  static const _opposite = [1, 0, 3, 2];

  /// A short way out: the fewest moves on boards up to 9 cells, otherwise the
  /// shorter of the strategy's two orders (rows or columns first on ties).
  String solve(List<int> tiles) {
    if (n <= 9) return optimal(tiles)!;
    final a = strategy(tiles);
    if (rows != cols) return a;
    final b = strategy(tiles, rowsFirst: false);
    return b.length < a.length ? b : a;
  }

  // ---- IDA* ----

  late Uint8List _b;
  late List<bool> _locked;
  late Uint8List _path;
  late List<int> _rowLc;
  late List<int> _colLc;
  int _man = 0;
  int _lc = 0;
  int _nodes = 0;
  int _cap = 0;

  static const _found = -1;
  static const _aborted = -2;

  int _dist(int tile, int cell) {
    if (tile == 0) return 0;
    final g = tile - 1;
    return (g ~/ cols - cell ~/ cols).abs() + (g % cols - cell % cols).abs();
  }

  /// Twice the tiles to take out of a line so the rest of its tiles that
  /// belong in it are in order (2 × (count − longest increasing run)).
  static int _conflicts(List<int> goals) {
    if (goals.length < 2) return 0;
    final best = List.filled(goals.length, 1);
    var longest = 1;
    for (var i = 1; i < goals.length; i++) {
      for (var j = 0; j < i; j++) {
        if (goals[j] < goals[i] && best[j] + 1 > best[i]) best[i] = best[j] + 1;
      }
      if (best[i] > longest) longest = best[i];
    }
    return 2 * (goals.length - longest);
  }

  int _rowConflicts(int r) => _conflicts([
    for (var c = 0; c < cols; c++)
      if (_b[r * cols + c] != 0 && (_b[r * cols + c] - 1) ~/ cols == r) (_b[r * cols + c] - 1) % cols,
  ]);

  int _colConflicts(int c) => _conflicts([
    for (var r = 0; r < rows; r++)
      if (_b[r * cols + c] != 0 && (_b[r * cols + c] - 1) % cols == c) (_b[r * cols + c] - 1) ~/ cols,
  ]);

  /// The fewest gap moves that sort [tiles] without moving a tile on a
  /// [locked] cell, or null when that takes more than [nodeCap] nodes.
  String? optimal(List<int> tiles, {List<bool>? locked, int nodeCap = 1 << 30}) {
    _b = Uint8List.fromList(tiles);
    _locked = locked ?? List.filled(n, false);
    _man = 0;
    for (var i = 0; i < n; i++) {
      _man += _dist(_b[i], i);
    }
    _rowLc = [for (var r = 0; r < rows; r++) _rowConflicts(r)];
    _colLc = [for (var c = 0; c < cols; c++) _colConflicts(c)];
    _lc = _rowLc.fold(0, (a, b) => a + b) + _colLc.fold(0, (a, b) => a + b);
    _nodes = 0;
    _cap = nodeCap;
    _path = Uint8List(256);
    final gap = _b.indexOf(0);
    var bound = _man + _lc;
    while (true) {
      final t = _search(gap, 0, bound, -1);
      if (t == _found) {
        return glideCancel([for (var k = 0; k < _depth; k++) glideDirs[_path[k]]].join());
      }
      if (t == _aborted || t > 250) return null;
      bound = t;
    }
  }

  int _depth = 0;

  int _search(int gap, int cost, int bound, int prev) {
    final f = cost + _man + _lc;
    if (f > bound) return f;
    if (_man == 0) {
      _depth = cost;
      return _found;
    }
    if (++_nodes > _cap) return _aborted;
    var least = 1 << 30;
    final next = _next[gap];
    for (var d = 0; d < 4; d++) {
      if (prev >= 0 && d == _opposite[prev]) continue;
      final cell = next[d];
      if (cell < 0 || _locked[cell]) continue;
      final tile = _b[cell];
      final manBefore = _man, lcBefore = _lc;
      _man += _dist(tile, gap) - _dist(tile, cell);
      _b[gap] = tile;
      _b[cell] = 0;
      // A tile moving up or down changes which rows hold it; sideways, columns.
      final vertical = d < 2;
      final a = vertical ? cell ~/ cols : cell % cols, b = vertical ? gap ~/ cols : gap % cols;
      final lines = vertical ? _rowLc : _colLc;
      final oldA = lines[a], oldB = lines[b];
      lines[a] = vertical ? _rowConflicts(a) : _colConflicts(a);
      lines[b] = vertical ? _rowConflicts(b) : _colConflicts(b);
      _lc += lines[a] + lines[b] - oldA - oldB;
      _path[cost] = d;
      final t = _search(cell, cost + 1, bound, d);
      if (t == _found) return t;
      lines[a] = oldA;
      lines[b] = oldB;
      _b[cell] = tile;
      _b[gap] = 0;
      _man = manBefore;
      _lc = lcBefore;
      if (t == _aborted) return t;
      if (t < least) least = t;
    }
    return least;
  }

  // ---- Strategy ----

  /// A way out that places the top row or left column of what is left (the
  /// longer side first; [rowsFirst] on a square), tile by tile and the last
  /// two of the line together, until 3×3 is left, then the fewest moves.
  String strategy(List<int> tiles, {bool rowsFirst = true}) {
    final b = List.of(tiles);
    final locked = List.filled(n, false);
    final out = StringBuffer();
    var r0 = 0, c0 = 0;
    while (rows - r0 > 3 || cols - c0 > 3) {
      final h = rows - r0, w = cols - c0;
      final row = h > 3 && (w <= 3 || h > w || (h == w && rowsFirst));
      if (row) {
        for (var c = c0; c < cols - 2; c++) {
          _place(b, locked, out, [r0 * cols + c]);
        }
        _place(b, locked, out, [r0 * cols + cols - 2, r0 * cols + cols - 1]);
        r0++;
      } else {
        for (var r = r0; r < rows - 2; r++) {
          _place(b, locked, out, [r * cols + c0]);
        }
        _place(b, locked, out, [(rows - 2) * cols + c0, (rows - 1) * cols + c0]);
        c0++;
      }
    }
    out.write(optimal(b, locked: locked)!);
    return glideCancel(out.toString());
  }

  /// Brings the tiles that belong on [targets] (one or two cells) there by a
  /// breadth-first search over their spots and the gap's, never moving a
  /// locked tile; then locks them.
  void _place(List<int> b, List<bool> locked, StringBuffer out, List<int> targets) {
    final two = targets.length == 2;
    final t1 = targets[0], t2 = two ? targets[1] : 0;
    final p1 = b.indexOf(t1 + 1), p2 = two ? b.indexOf(t2 + 1) : 0;
    int code(int g, int a, int c) => g + n * (a + n * c);
    final size = two ? n * n * n : n * n;
    final prev = Int32List(size)..fillRange(0, size, -1);
    final dirs = Uint8List(size);
    final queue = Int32List(size);
    final start = code(b.indexOf(0), p1, p2);
    prev[start] = start;
    var head = 0, tail = 0;
    queue[tail++] = start;
    var goal = -1;
    while (head < tail) {
      final s = queue[head++];
      final g = s % n, a = (s ~/ n) % n, c = s ~/ (n * n);
      if (a == t1 && (!two || c == t2)) {
        goal = s;
        break;
      }
      for (var d = 0; d < 4; d++) {
        final cell = _next[g][d];
        if (cell < 0 || locked[cell]) continue;
        final na = cell == a ? g : a, nc = two && cell == c ? g : c;
        final ns = code(cell, na, nc);
        if (prev[ns] >= 0) continue;
        prev[ns] = s;
        dirs[ns] = d;
        queue[tail++] = ns;
      }
    }
    if (goal < 0) throw StateError('cannot place $targets');
    final moves = <String>[];
    for (var s = goal; s != start; s = prev[s]) {
      moves.add(glideDirs[dirs[s]]);
    }
    final way = moves.reversed.join();
    final after = glideApply(rows, cols, b, way);
    b.setAll(0, after);
    out.write(way);
    for (final t in targets) {
      locked[t] = true;
    }
  }
}
