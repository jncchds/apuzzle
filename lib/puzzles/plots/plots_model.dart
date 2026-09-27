import '../../core/grid.dart';
import '../../core/grid_graph.dart';
import '../../core/value_grid.dart';

/// Fillomino: fill every cell with a number so that each group of equal
/// numbers joined side by side has exactly that many cells. Values are
/// 0-based (value v shows the number v + 1).
class PlotsPuzzle implements ValueGridPuzzle {
  const PlotsPuzzle({
    required this.rows,
    required this.cols,
    required this.maxValue,
    required this.givens,
    required this.solution,
  });

  final int rows;
  final int cols;

  /// Largest number on the palette (no plot is bigger).
  final int maxValue;

  /// Given value per cell, or null.
  final List<int?> givens;
  final List<int> solution;

  @override
  GridSize get size => GridSize(rows, cols);
  @override
  int? givenAt(int index) => givens[index];
  @override
  int solutionAt(int index) => solution[index];

  Map<String, dynamic> toJson() => {
    'rows': rows,
    'cols': cols,
    'max': maxValue,
    'givens': givens,
    'solution': solution,
  };

  factory PlotsPuzzle.fromJson(Map<String, dynamic> j) => PlotsPuzzle(
    rows: j['rows'] as int,
    cols: j['cols'] as int,
    maxValue: j['max'] as int,
    givens: (j['givens'] as List).cast<int?>(),
    solution: (j['solution'] as List).cast<int>(),
  );
}

/// Cells breaking a rule. [values] holds -1 for empty cells. A group is
/// wrong when it is too big, or too small with no empty cell next to it
/// (with [complete], when its size is off at all).
Set<int> plotsConflicts(int rows, int cols, List<int> values, {bool complete = false}) {
  final nb = orthNeighbors(rows, cols);
  final bad = <int>{};
  final seen = List<bool>.filled(values.length, false);
  for (var i = 0; i < values.length; i++) {
    final v = values[i];
    if (v < 0 || seen[i]) continue;
    final group = [i];
    seen[i] = true;
    var open = false;
    for (var k = 0; k < group.length; k++) {
      for (final j in nb[group[k]]) {
        if (values[j] < 0) open = true;
        if (values[j] == v && !seen[j]) {
          seen[j] = true;
          group.add(j);
        }
      }
    }
    final want = v + 1;
    if (group.length > want || (group.length < want && (complete || !open))) bad.addAll(group);
  }
  return bad;
}
