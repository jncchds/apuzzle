import '../../core/grid.dart';
import '../../core/lattice_loop.dart';

/// Arrow directions: up, right, down, left.
const arrowDirs = [(-1, 0), (0, 1), (1, 0), (0, -1)];

/// Player marks on a cell.
const int arrowsEmpty = 0;
const int arrowsShade = 1;
const int arrowsDot = 2;

/// Yajilin: shade some cells (never two side by side) and draw one loop
/// through the centres of all the other cells. A clue cell is neither: its
/// number counts the shaded cells in its arrow's direction.
class ArrowsPuzzle {
  const ArrowsPuzzle({
    required this.rows,
    required this.cols,
    required this.arrows,
    required this.counts,
    required this.shaded,
    required this.lines,
  });

  final int rows;
  final int cols;

  /// Arrow direction (index into [arrowDirs]) of each clue cell, -1 elsewhere.
  final List<int> arrows;

  /// Shaded cells in the arrow's direction, per clue cell (0 elsewhere).
  final List<int> counts;

  /// Solution: shaded cells and the loop's edges (a [LatticeLoop] of
  /// rows × cols points).
  final List<bool> shaded;
  final List<bool> lines;

  GridSize get size => GridSize(rows, cols);
  bool isClue(int i) => arrows[i] >= 0;
  LatticeLoop get lattice => _lattices[this] ??= LatticeLoop(rows, cols);
  static final _lattices = Expando<LatticeLoop>();

  /// Cells from clue [i] to the edge in its arrow's direction, without clues.
  List<int> seen(int i) => arrowsRay(rows, cols, arrows, i);

  Map<String, dynamic> toJson() => {
    'rows': rows,
    'cols': cols,
    'arrows': arrows,
    'counts': counts,
    'shaded': [
      for (var i = 0; i < shaded.length; i++)
        if (shaded[i]) i,
    ],
    'lines': [
      for (var e = 0; e < lines.length; e++)
        if (lines[e]) e,
    ],
  };

  factory ArrowsPuzzle.fromJson(Map<String, dynamic> j) {
    final rows = j['rows'] as int, cols = j['cols'] as int;
    final shaded = List<bool>.filled(rows * cols, false);
    for (final i in (j['shaded'] as List).cast<int>()) {
      shaded[i] = true;
    }
    final lines = List<bool>.filled(LatticeLoop(rows, cols).edgeCount, false);
    for (final e in (j['lines'] as List).cast<int>()) {
      lines[e] = true;
    }
    return ArrowsPuzzle(
      rows: rows,
      cols: cols,
      arrows: (j['arrows'] as List).cast<int>(),
      counts: (j['counts'] as List).cast<int>(),
      shaded: shaded,
      lines: lines,
    );
  }
}

/// Cells from [i] to the edge in [arrows]'s direction at [i], skipping clues.
List<int> arrowsRay(int rows, int cols, List<int> arrows, int i) {
  final (dr, dc) = arrowDirs[arrows[i]];
  var r = i ~/ cols + dr, c = i % cols + dc;
  final out = <int>[];
  while (r >= 0 && c >= 0 && r < rows && c < cols) {
    if (arrows[r * cols + c] < 0) out.add(r * cols + c);
    r += dr;
    c += dc;
  }
  return out;
}

/// The player's lines (edge marks: 0 empty, 1 line, 2 cross) and cell marks.
class ArrowsState {
  const ArrowsState(this.marks, this.cells);

  final List<int> marks;
  final List<int> cells;

  List<bool> get lines => [for (final m in marks) m == 1];

  Map<String, dynamic> toJson() => {'m': marks, 'c': cells};
  factory ArrowsState.fromJson(Map<String, dynamic> j) =>
      ArrowsState((j['m'] as List).cast<int>(), (j['c'] as List).cast<int>());
}

/// Cells breaking a rule, given the [lines]; a non-clue cell the lines skip
/// counts as shaded. With [complete] (one closed loop) every rule is
/// checked; before that only lines through clue cells.
Set<int> arrowsBad(ArrowsPuzzle p, List<bool> lines, {required bool complete}) {
  final g = p.lattice;
  final n = p.rows * p.cols;
  final used = [for (var i = 0; i < n; i++) g.incident[i].any((e) => lines[e])];
  final bad = <int>{
    for (var i = 0; i < n; i++)
      if (p.isClue(i) && used[i]) i,
  };
  if (!complete) return bad;
  final shaded = [for (var i = 0; i < n; i++) !p.isClue(i) && !used[i]];
  for (var i = 0; i < n; i++) {
    if (!shaded[i]) continue;
    final r = i ~/ p.cols, c = i % p.cols;
    if (c + 1 < p.cols && shaded[i + 1]) bad.addAll([i, i + 1]);
    if (r + 1 < p.rows && shaded[i + p.cols]) bad.addAll([i, i + p.cols]);
  }
  for (var i = 0; i < n; i++) {
    if (p.isClue(i) && p.seen(i).where((j) => shaded[j]).length != p.counts[i]) bad.add(i);
  }
  return bad;
}

bool arrowsValid(ArrowsPuzzle p, List<bool> lines) =>
    p.lattice.isSingleLoop(lines) && arrowsBad(p, lines, complete: true).isEmpty;
