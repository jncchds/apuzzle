import 'dart:typed_data';

import '../../core/grid.dart';
import '../../core/value_grid.dart';

/// A wedge (half a cell, cut corner to corner) filling the top-left corner.
const int wedgeTL = 0;

/// A wedge filling the top-right corner.
const int wedgeTR = 1;

/// A wedge filling the bottom-right corner.
const int wedgeBR = 2;

/// A wedge filling the bottom-left corner.
const int wedgeBL = 3;

/// An open cell without a wedge (a note: the board needn't show it).
const int wedgeDot = 4;

/// A wall.
const int wedgeWall = 5;

/// Whether [v] is one of the four wedges.
bool isWedge(int v) => v >= 0 && v < 4;

/// No number on a wall ([WedgesPuzzle.clues]).
const int wedgesPlain = -1;

/// Not a wall ([WedgesPuzzle.clues]).
const int wedgesOpen = -2;

/// Whether the sector of a cell next to one of its corners is open. [v] is
/// the cell's value, [k] the corner (0 top-left, 1 top-right, 2
/// bottom-right, 3 bottom-left) and [horizontal] says which of the two
/// sectors at that corner: the one along the cell's top or bottom side, or
/// the one along its left or right side.
bool _sectorOpen(int v, int k, bool horizontal) {
  if (v == wedgeWall) return false;
  if (v == wedgeDot) return true;
  if (v == k) return false;
  if (v == (k + 2) % 4) return true;
  // The diagonal runs through the corner, and the wedge holds the sector on
  // its own side: along the top or bottom side when the wedge's corner shares
  // that side with this one (corners 0, 1 share the top, 3, 2 the bottom).
  final horizontalPair = (v < 2) == (k < 2);
  return horizontalPair ? !horizontal : horizontal;
}

/// Whether a lattice point with these four cells around it (values, walls
/// and the outside as [wedgeWall]) leaves every open area there a square
/// corner, a straight side or no corner at all: going round the point in
/// eight sectors of 45°, every run of open sectors is 2, 4 or all 8 long.
bool _pointOk(int nw, int ne, int se, int sw) {
  final s = [
    _sectorOpen(ne, 3, false),
    _sectorOpen(ne, 3, true),
    _sectorOpen(se, 0, true),
    _sectorOpen(se, 0, false),
    _sectorOpen(sw, 1, false),
    _sectorOpen(sw, 1, true),
    _sectorOpen(nw, 2, true),
    _sectorOpen(nw, 2, false),
  ];
  final start = s.indexOf(false);
  if (start < 0) return true;
  var run = 0;
  for (var j = 1; j <= 8; j++) {
    if (s[(start + j) % 8]) {
      run++;
    } else {
      if (run != 0 && run != 2 && run != 4) return false;
      run = 0;
    }
  }
  return true;
}

/// [_pointOk] for every combination: index `((nw * 6 + ne) * 6 + se) * 6 + sw`.
final Uint8List wedgesPointTable = () {
  final t = Uint8List(1296);
  for (var a = 0; a < 6; a++) {
    for (var b = 0; b < 6; b++) {
      for (var c = 0; c < 6; c++) {
        for (var d = 0; d < 6; d++) {
          t[((a * 6 + b) * 6 + c) * 6 + d] = _pointOk(a, b, c, d) ? 1 : 0;
        }
      }
    }
  }
  return t;
}();

/// Lattice points and cells of a [rows]×[cols] board. Point (r, c) has
/// index `r * (cols + 1) + c`.
class WedgesGeometry {
  WedgesGeometry._(this.rows, this.cols)
    : w = cols + 1,
      pointCells = List.generate((rows + 1) * (cols + 1), (p) {
        final r = p ~/ (cols + 1), c = p % (cols + 1);
        int at(int rr, int cc) => rr >= 0 && rr < rows && cc >= 0 && cc < cols ? rr * cols + cc : -1;
        return [at(r - 1, c - 1), at(r - 1, c), at(r, c), at(r, c - 1)];
      }, growable: false),
      cellPoints = List.generate(rows * cols, (i) {
        final r = i ~/ cols, c = i % cols, w = cols + 1;
        return [r * w + c, r * w + c + 1, (r + 1) * w + c + 1, (r + 1) * w + c];
      }, growable: false),
      sides = List.generate(rows * cols, (i) {
        final r = i ~/ cols, c = i % cols;
        return [
          if (r > 0) i - cols,
          if (c < cols - 1) i + 1,
          if (r < rows - 1) i + cols,
          if (c > 0) i - 1,
        ];
      }, growable: false);

  static final _cache = <int, WedgesGeometry>{};

  factory WedgesGeometry.of(int rows, int cols) => _cache[rows * 64 + cols] ??= WedgesGeometry._(rows, cols);

  final int rows;
  final int cols;

  /// Points per row of points.
  final int w;

  /// Per point, the cells around it: north-west, north-east, south-east,
  /// south-west (-1 off the board).
  final List<List<int>> pointCells;

  /// Per cell, its corners: top-left, top-right, bottom-right, bottom-left.
  final List<List<int>> cellPoints;

  /// Per cell, the cells beside it.
  final List<List<int>> sides;

  int get points => (rows + 1) * w;
  int get cells => rows * cols;

  /// The cell next to [point] that best names it in texts, and which of its
  /// corners it is (0 top-left, 1 top-right, 2 bottom-left, 3 bottom-right,
  /// as [cornerTok] takes it).
  (Pos, int) cornerOf(int point) {
    final r = point ~/ w, c = point % w;
    final cr = r < rows ? r : rows - 1, cc = c < cols ? c : cols - 1;
    return (Pos(cr, cc), (r > cr ? 2 : 0) + (c > cc ? 1 : 0));
  }

  /// Whether the cells around [point] are fine with [values] (-1 unknown:
  /// fine if some value of the unknown cells makes it so; walls and the
  /// outside as [wedgeWall]).
  bool pointFits(int point, List<int> values) {
    final cs = pointCells[point];
    final opts = [
      for (final i in cs)
        if (i < 0)
          const [wedgeWall]
        else if (values[i] < 0)
          const [wedgeTL, wedgeTR, wedgeBR, wedgeBL, wedgeDot]
        else
          [values[i]],
    ];
    for (final a in opts[0]) {
      for (final b in opts[1]) {
        for (final c in opts[2]) {
          for (final d in opts[3]) {
            if (wedgesPointTable[((a * 6 + b) * 6 + c) * 6 + d] == 1) return true;
          }
        }
      }
    }
    return false;
  }
}

/// A board: walls, some with a number counting the wedges beside them.
/// Wedges go into some open cells so that every open area left is a
/// rectangle, upright or turned 45°.
class WedgesPuzzle implements ValueGridPuzzle {
  const WedgesPuzzle({
    required this.rows,
    required this.cols,
    required this.clues,
    required this.solution,
    this.givens = const [],
  });

  final int rows;
  final int cols;

  /// Per cell: [wedgesOpen], [wedgesPlain] (a wall without a number) or the
  /// wall's number.
  final List<int> clues;

  /// Per cell, a wedge, [wedgeDot] or [wedgeWall].
  final List<int> solution;

  /// Open cells shown from the start (only where logic would stall otherwise).
  final List<int> givens;

  WedgesGeometry get geo => WedgesGeometry.of(rows, cols);

  bool isWall(int i) => clues[i] != wedgesOpen;

  @override
  GridSize get size => GridSize(rows, cols);
  @override
  int? givenAt(int index) => isWall(index) || givens.contains(index) ? solution[index] : null;
  @override
  int solutionAt(int index) => solution[index];

  int get wedges => solution.where(isWedge).length;

  Map<String, dynamic> toJson() => {
    'rows': rows,
    'cols': cols,
    'clues': clues,
    'solution': solution,
    if (givens.isNotEmpty) 'givens': givens,
  };

  factory WedgesPuzzle.fromJson(Map<String, dynamic> j) => WedgesPuzzle(
    rows: j['rows'] as int,
    cols: j['cols'] as int,
    clues: (j['clues'] as List).cast<int>(),
    solution: (j['solution'] as List).cast<int>(),
    givens: ((j['givens'] as List?) ?? const []).cast<int>(),
  );
}

/// The wedges beside wall [i] in [values].
int wedgesAround(WedgesGeometry g, List<int> values, int i) => g.sides[i].where((j) => isWedge(values[j])).length;

/// Cells that break a rule, with -1 (unknown) for empty cells: the cells
/// around a point that no filling of its unknown cells makes fine, and
/// numbered walls with too many wedges beside them, or too few even if every
/// unknown neighbour got one. With [complete], unknown cells count as having
/// no wedge.
Set<int> wedgesConflicts(WedgesPuzzle p, List<int> values, {bool complete = false}) {
  final g = p.geo;
  final v = [
    for (var i = 0; i < values.length; i++)
      if (p.isWall(i)) wedgeWall else if (values[i] < 0 && complete) wedgeDot else values[i],
  ];
  final bad = <int>{};
  for (var k = 0; k < g.points; k++) {
    if (!g.pointFits(k, v)) {
      for (final i in g.pointCells[k]) {
        if (i >= 0 && !p.isWall(i) && v[i] >= 0) bad.add(i);
      }
    }
  }
  for (var i = 0; i < g.cells; i++) {
    final want = p.clues[i];
    if (want < 0) continue;
    final have = wedgesAround(g, v, i);
    final open = g.sides[i].where((j) => v[j] < 0).length;
    if (have > want || have + open < want) bad.add(i);
  }
  return bad;
}

/// Whether [values] (-1 = no wedge) meets every rule.
bool wedgesSolved(WedgesPuzzle p, List<int> values) => wedgesConflicts(p, values, complete: true).isEmpty;
