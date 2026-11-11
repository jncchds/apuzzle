import '../../core/grid.dart';
import '../../core/value_grid.dart';

/// A diagonal from the top-left to the bottom-right corner (`\`).
const int slBack = 0;

/// A diagonal from the top-right to the bottom-left corner (`/`).
const int slFwd = 1;

/// Corners, cells and diagonals of a [rows]×[cols] board. Corners are the
/// lattice points, outer ones included: corner (r, c) has index
/// `r * (cols + 1) + c`.
class SlantGeometry {
  SlantGeometry._(this.rows, this.cols)
    : w = cols + 1,
      cornerCells = List.generate((rows + 1) * (cols + 1), (p) {
        final r = p ~/ (cols + 1), c = p % (cols + 1);
        return [
          // (cell, the value of its diagonal that touches the corner)
          if (r > 0 && c > 0) ((r - 1) * cols + c - 1, slBack),
          if (r > 0 && c < cols) ((r - 1) * cols + c, slFwd),
          if (r < rows && c > 0) (r * cols + c - 1, slFwd),
          if (r < rows && c < cols) (r * cols + c, slBack),
        ];
      }, growable: false);

  static final _cache = <int, SlantGeometry>{};

  factory SlantGeometry.of(int rows, int cols) => _cache[rows * 64 + cols] ??= SlantGeometry._(rows, cols);

  final int rows;
  final int cols;

  /// Corners per row of corners.
  final int w;

  /// Per corner, the up to four cells around it with the diagonal that
  /// touches it.
  final List<List<(int, int)>> cornerCells;

  int get corners => (rows + 1) * w;
  int get cells => rows * cols;

  /// The two corners the diagonal [v] of [cell] joins.
  (int, int) ends(int cell, int v) {
    final tl = (cell ~/ cols) * w + cell % cols;
    return v == slBack ? (tl, tl + w + 1) : (tl + 1, tl + w);
  }

  /// The cell next to [corner] that best names it in texts, and which of
  /// its corners it is (0 top-left, 1 top-right, 2 bottom-left, 3
  /// bottom-right).
  (Pos, int) cornerOf(int corner) {
    final r = corner ~/ w, c = corner % w;
    final cr = r < rows ? r : rows - 1, cc = c < cols ? c : cols - 1;
    return (Pos(cr, cc), (r > cr ? 2 : 0) + (c > cc ? 1 : 0));
  }
}

/// A board: a number 0–4 on some corners counts the diagonals touching
/// it, and the diagonals never close a loop.
class SlantPuzzle implements ValueGridPuzzle {
  const SlantPuzzle({
    required this.rows,
    required this.cols,
    required this.clues,
    required this.solution,
    this.givens = const [],
  });

  final int rows;
  final int cols;

  /// Per corner, its number or -1.
  final List<int> clues;

  /// Per cell, [slBack] or [slFwd].
  final List<int> solution;

  /// Cells shown from the start (only where logic would stall otherwise).
  final List<int> givens;

  SlantGeometry get geo => SlantGeometry.of(rows, cols);

  @override
  GridSize get size => GridSize(rows, cols);
  @override
  int? givenAt(int index) => givens.contains(index) ? solution[index] : null;
  @override
  int solutionAt(int index) => solution[index];

  Map<String, dynamic> toJson() => {
    'rows': rows,
    'cols': cols,
    'clues': clues,
    'solution': solution,
    if (givens.isNotEmpty) 'givens': givens,
  };

  factory SlantPuzzle.fromJson(Map<String, dynamic> j) => SlantPuzzle(
    rows: j['rows'] as int,
    cols: j['cols'] as int,
    clues: (j['clues'] as List).cast<int>(),
    solution: (j['solution'] as List).cast<int>(),
    givens: ((j['givens'] as List?) ?? const []).cast<int>(),
  );
}

/// Corner groups joined by diagonals.
class SlantForest {
  SlantForest(int corners) : _parent = List.generate(corners, (i) => i);

  SlantForest.copy(SlantForest o) : _parent = List.of(o._parent);

  final List<int> _parent;

  int find(int a) {
    while (_parent[a] != a) {
      _parent[a] = _parent[_parent[a]];
      a = _parent[a];
    }
    return a;
  }

  bool joined(int a, int b) => find(a) == find(b);

  /// Joins [a] and [b]; false when they were joined already (a loop).
  bool join(int a, int b) {
    final x = find(a), y = find(b);
    if (x == y) return false;
    _parent[x] = y;
    return true;
  }
}

/// The cells whose diagonals join corners [a] and [b], from [a] on, using
/// the diagonals in [values] (-1 none) but not that of [skip]; empty when
/// they aren't joined.
List<int> slantPath(SlantGeometry g, List<int> values, int a, int b, [int skip = -1]) {
  if (a == b) return const [];
  final via = List<int>.filled(g.corners, -2);
  via[a] = -1;
  final queue = [a];
  for (var q = 0; q < queue.length; q++) {
    final p = queue[q];
    for (final (cell, v) in g.cornerCells[p]) {
      if (cell == skip || values[cell] != v) continue;
      final (x, y) = g.ends(cell, v);
      final o = x == p ? y : x;
      if (via[o] != -2) continue;
      via[o] = cell;
      if (o == b) {
        final path = <int>[];
        var at = b;
        while (at != a) {
          final c = via[at];
          path.add(c);
          final (e1, e2) = g.ends(c, values[c]);
          at = e1 == at ? e2 : e1;
        }
        return path.reversed.toList();
      }
      queue.add(o);
    }
  }
  return const [];
}

/// Cells that break a rule: the cells around a number with too many (or,
/// once they are all filled, too few) diagonals touching it, and the cells
/// of every closed loop.
Set<int> slantConflicts(SlantPuzzle p, List<int> values) {
  final g = p.geo;
  final bad = <int>{};
  for (var k = 0; k < g.corners; k++) {
    final want = p.clues[k];
    if (want < 0) continue;
    var touch = 0, open = 0;
    for (final (cell, v) in g.cornerCells[k]) {
      if (values[cell] < 0) {
        open++;
      } else if (values[cell] == v) {
        touch++;
      }
    }
    if (touch > want || touch + open < want) {
      for (final (cell, _) in g.cornerCells[k]) {
        if (values[cell] >= 0) bad.add(cell);
      }
    }
  }
  bad.addAll(slantLoopCells(g, values));
  return bad;
}

/// The cells whose diagonals lie on a closed loop.
Set<int> slantLoopCells(SlantGeometry g, List<int> values) {
  final forest = SlantForest(g.corners);
  final closing = <int>[];
  for (var i = 0; i < g.cells; i++) {
    if (values[i] < 0) continue;
    final (a, b) = g.ends(i, values[i]);
    if (!forest.join(a, b)) closing.add(i);
  }
  final out = <int>{};
  for (final i in closing) {
    final (a, b) = g.ends(i, values[i]);
    out
      ..add(i)
      ..addAll(slantPath(g, values, a, b, i));
  }
  return out;
}

/// Whether [values] fills every cell, meets every number and has no loop.
bool slantSolved(SlantPuzzle p, List<int> values) => values.every((v) => v >= 0) && slantConflicts(p, values).isEmpty;
