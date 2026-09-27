import '../../core/grid.dart';
import '../../core/grid_graph.dart';
import '../../core/value_grid.dart';

/// Suguru: every region of k cells holds the numbers 1..k once each, and
/// equal numbers never touch, not even diagonally. Values are 0-based
/// (value v shows the number v + 1).
class BlocksPuzzle implements ValueGridPuzzle {
  const BlocksPuzzle({
    required this.rows,
    required this.cols,
    required this.regions,
    required this.givens,
    required this.solution,
  });

  final int rows;
  final int cols;

  /// Region id per cell.
  final List<int> regions;

  /// Given value per cell, or null.
  final List<int?> givens;
  final List<int> solution;

  @override
  GridSize get size => GridSize(rows, cols);
  @override
  int? givenAt(int index) => givens[index];
  @override
  int solutionAt(int index) => solution[index];

  /// Size of the region of every cell.
  List<int> get regionSizeAt {
    final s = <int, int>{};
    for (final r in regions) {
      s[r] = (s[r] ?? 0) + 1;
    }
    return [for (final r in regions) s[r]!];
  }

  int get maxRegion => regionSizeAt.reduce((a, b) => a > b ? a : b);

  Map<String, dynamic> toJson() => {
    'rows': rows,
    'cols': cols,
    'regions': regions,
    'givens': givens,
    'solution': solution,
  };

  factory BlocksPuzzle.fromJson(Map<String, dynamic> j) => BlocksPuzzle(
    rows: j['rows'] as int,
    cols: j['cols'] as int,
    regions: (j['regions'] as List).cast<int>(),
    givens: (j['givens'] as List).cast<int?>(),
    solution: (j['solution'] as List).cast<int>(),
  );
}

/// Cells breaking a rule. [values] holds -1 for empty cells.
Set<int> blocksConflicts(int rows, int cols, List<int> regions, List<int> values) {
  final sizes = <int, int>{};
  for (final r in regions) {
    sizes[r] = (sizes[r] ?? 0) + 1;
  }
  final kn = kingNeighbors(rows, cols);
  final bad = <int>{};
  final seen = <(int, int), int>{};
  for (var i = 0; i < values.length; i++) {
    final v = values[i];
    if (v < 0) continue;
    if (v >= sizes[regions[i]]!) bad.add(i);
    for (final j in kn[i]) {
      if (values[j] == v) bad.addAll([i, j]);
    }
    final other = seen[(regions[i], v)];
    if (other != null) bad.addAll([i, other]);
    seen[(regions[i], v)] = i;
  }
  return bad;
}
