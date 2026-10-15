import '../../core/grid.dart';
import '../../core/value_grid.dart';

const int mercuryFull = 0;
const int mercuryEmpty = 1;

/// Mercury: the grid is covered with tubes, straight or bent, each starting
/// at a round bulb. Fill each tube from its bulb up without gaps, to any
/// level from empty to full, so that every row and column holds the count
/// of filled cells beside it.
class MercuryPuzzle implements ValueGridPuzzle {
  MercuryPuzzle({
    required this.rows,
    required this.cols,
    required this.tubes,
    required this.levels,
    required this.rowCounts,
    required this.colCounts,
    this.givens = const [],
  }) : tubeOf = List.filled(rows * cols, -1),
       place = List.filled(rows * cols, 0) {
    for (var t = 0; t < tubes.length; t++) {
      for (var k = 0; k < tubes[t].length; k++) {
        tubeOf[tubes[t][k]] = t;
        place[tubes[t][k]] = k;
      }
    }
  }

  final int rows;
  final int cols;

  /// The cells of every tube, from its bulb to its tip.
  final List<List<int>> tubes;

  /// Solution: the filled cells of every tube, counted from the bulb.
  final List<int> levels;

  /// Filled cells per row/column, null where the count is hidden.
  final List<int?> rowCounts;
  final List<int?> colCounts;

  /// Cells shown from the start.
  final List<int> givens;

  /// The tube of every cell, and its place along it (0: the bulb).
  final List<int> tubeOf;
  final List<int> place;

  bool full(int i) => place[i] < levels[tubeOf[i]];
  int get filledCells => levels.fold(0, (a, b) => a + b);

  @override
  GridSize get size => GridSize(rows, cols);
  @override
  int? givenAt(int index) => givens.contains(index) ? solutionAt(index) : null;
  @override
  int solutionAt(int index) => full(index) ? mercuryFull : mercuryEmpty;

  Map<String, dynamic> toJson() => {
    'rows': rows,
    'cols': cols,
    'tubes': tubes,
    'levels': levels,
    'rc': rowCounts,
    'cc': colCounts,
    if (givens.isNotEmpty) 'given': givens,
  };

  factory MercuryPuzzle.fromJson(Map<String, dynamic> j) => MercuryPuzzle(
    rows: j['rows'] as int,
    cols: j['cols'] as int,
    tubes: [for (final t in j['tubes'] as List) (t as List).cast<int>()],
    levels: (j['levels'] as List).cast<int>(),
    rowCounts: (j['rc'] as List).cast<int?>(),
    colCounts: (j['cc'] as List).cast<int?>(),
    givens: ((j['given'] as List?) ?? const []).cast<int>(),
  );
}

/// Rows first, then columns.
List<List<int>> mercuryLines(int rows, int cols) => [
  for (var r = 0; r < rows; r++) [for (var c = 0; c < cols; c++) r * cols + c],
  for (var c = 0; c < cols; c++) [for (var r = 0; r < rows; r++) r * cols + c],
];

/// Filled cells per line ([mercuryLines]) of a solution.
List<int> mercuryCounts(int rows, int cols, List<List<int>> tubes, List<int> levels) {
  final counts = List.filled(rows + cols, 0);
  for (var t = 0; t < tubes.length; t++) {
    for (final i in tubes[t].take(levels[t])) {
      counts[i ~/ cols]++;
      counts[rows + i % cols]++;
    }
  }
  return counts;
}

/// Cells breaking a rule on a board of values (-1 empty). Before the board
/// is [complete] only what more input can't fix is flagged: a filled cell
/// past an empty one of its tube, and lines with too many filled cells (the
/// filled ones are flagged) or too few cells left for their count (the empty
/// ones are). Once complete, unmarked cells count as empty.
Set<int> mercuryConflicts(MercuryPuzzle p, List<int> v, {required bool complete}) {
  final bad = <int>{};
  bool empty(int i) => v[i] == mercuryEmpty || (complete && v[i] != mercuryFull);
  for (final tube in p.tubes) {
    for (var a = 0; a < tube.length; a++) {
      if (!empty(tube[a])) continue;
      for (var b = a + 1; b < tube.length; b++) {
        if (v[tube[b]] == mercuryFull) bad.addAll([tube[a], tube[b]]);
      }
    }
  }
  final lines = mercuryLines(p.rows, p.cols);
  for (var li = 0; li < lines.length; li++) {
    final want = li < p.rows ? p.rowCounts[li] : p.colCounts[li - p.rows];
    if (want == null) continue;
    final filled = lines[li].where((i) => v[i] == mercuryFull);
    final open = lines[li].where(empty);
    if (filled.length > want) bad.addAll(filled);
    if (lines[li].length - open.length < want) bad.addAll(open);
  }
  return bad;
}
