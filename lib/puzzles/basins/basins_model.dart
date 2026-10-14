import '../../core/grid.dart';
import '../../core/value_grid.dart';

const int basinsWater = 0;
const int basinsDry = 1;

/// Basins: the grid is cut into basins; fill some cells with water so that
/// every basin's water lies level, from its bottom up to one height across
/// the whole basin, and every row and column holds the water count beside it.
class BasinsPuzzle implements ValueGridPuzzle {
  BasinsPuzzle({
    required this.rows,
    required this.cols,
    required this.regions,
    required this.water,
    required this.rowCounts,
    required this.colCounts,
    this.givens = const [],
  });

  final int rows;
  final int cols;

  /// Basin id per cell.
  final List<int> regions;

  /// Solution.
  final List<bool> water;

  /// Water cells per row/column, null where the count is hidden.
  final List<int?> rowCounts;
  final List<int?> colCounts;

  /// Cells shown from the start.
  final List<int> givens;

  int get regionCount => regions.reduce((a, b) => a > b ? a : b) + 1;
  int get waterCells => water.where((w) => w).length;

  @override
  GridSize get size => GridSize(rows, cols);
  @override
  int? givenAt(int index) => givens.contains(index) ? solutionAt(index) : null;
  @override
  int solutionAt(int index) => water[index] ? basinsWater : basinsDry;

  Map<String, dynamic> toJson() => {
    'rows': rows,
    'cols': cols,
    'regions': regions,
    'water': [
      for (var i = 0; i < water.length; i++)
        if (water[i]) i,
    ],
    'rc': rowCounts,
    'cc': colCounts,
    if (givens.isNotEmpty) 'given': givens,
  };

  factory BasinsPuzzle.fromJson(Map<String, dynamic> j) {
    final rows = j['rows'] as int, cols = j['cols'] as int;
    final water = List<bool>.filled(rows * cols, false);
    for (final i in (j['water'] as List).cast<int>()) {
      water[i] = true;
    }
    return BasinsPuzzle(
      rows: rows,
      cols: cols,
      regions: (j['regions'] as List).cast<int>(),
      water: water,
      rowCounts: (j['rc'] as List).cast<int?>(),
      colCounts: (j['cc'] as List).cast<int?>(),
      givens: ((j['given'] as List?) ?? const []).cast<int>(),
    );
  }
}

/// Rows first, then columns.
List<List<int>> basinsLines(int rows, int cols) => [
  for (var r = 0; r < rows; r++) [for (var c = 0; c < cols; c++) r * cols + c],
  for (var c = 0; c < cols; c++) [for (var r = 0; r < rows; r++) r * cols + c],
];

/// For every cell, the other cells of its basin that hold water when it does
/// (as low or lower: same row or below), and those dry when it is (as high or higher).
(List<List<int>>, List<List<int>>) basinsLevels(int cols, List<int> regions) {
  final below = List.generate(regions.length, (_) => <int>[]);
  final above = List.generate(regions.length, (_) => <int>[]);
  for (var i = 0; i < regions.length; i++) {
    for (var j = 0; j < regions.length; j++) {
      if (i == j || regions[i] != regions[j]) continue;
      if (j ~/ cols >= i ~/ cols) below[i].add(j);
      if (j ~/ cols <= i ~/ cols) above[i].add(j);
    }
  }
  return (below, above);
}

/// Cells breaking a rule on a board of values (-1 empty). Before the board
/// is [complete] only what more input can't fix is flagged: water above a
/// dry cell of its basin (or beside one in the same row), and lines with too
/// much water (the water is flagged) or too few cells left for their count
/// (the dry cells are). Once complete, empty
/// cells count as dry.
Set<int> basinsConflicts(BasinsPuzzle p, List<int> v, {required bool complete}) {
  final bad = <int>{};
  final (below, _) = basinsLevels(p.cols, p.regions);
  bool dry(int i) => v[i] == basinsDry || (complete && v[i] != basinsWater);
  for (var i = 0; i < v.length; i++) {
    if (v[i] != basinsWater) continue;
    for (final j in below[i]) {
      if (dry(j)) bad.addAll([i, j]);
    }
  }
  final lines = basinsLines(p.rows, p.cols);
  for (var li = 0; li < lines.length; li++) {
    final want = li < p.rows ? p.rowCounts[li] : p.colCounts[li - p.rows];
    if (want == null) continue;
    final wet = lines[li].where((i) => v[i] == basinsWater);
    final dryCells = lines[li].where(dry);
    if (wet.length > want) bad.addAll(wet);
    if (lines[li].length - dryCells.length < want) bad.addAll(dryCells);
  }
  return bad;
}
