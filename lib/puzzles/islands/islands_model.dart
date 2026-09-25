import '../../core/grid.dart';
import '../../core/grid_graph.dart';
import '../../core/value_grid.dart';

const int islandsSea = 0;
const int islandsLand = 1;

/// Nurikabe: every island holds one number equal to its size, the sea is
/// connected and has no 2×2 pools.
class IslandsPuzzle implements ValueGridPuzzle {
  const IslandsPuzzle({required this.rows, required this.cols, required this.clues, required this.sea});

  final int rows;
  final int cols;

  /// Island size at one cell of each island, null elsewhere.
  final List<int?> clues;

  /// Solution.
  final List<bool> sea;

  @override
  GridSize get size => GridSize(rows, cols);
  @override
  int? givenAt(int index) => clues[index] == null ? null : islandsLand;
  @override
  int solutionAt(int index) => sea[index] ? islandsSea : islandsLand;

  Map<String, dynamic> toJson() => {
        'rows': rows,
        'cols': cols,
        'clues': clues,
        'sea': [for (var i = 0; i < sea.length; i++) if (sea[i]) i],
      };

  factory IslandsPuzzle.fromJson(Map<String, dynamic> j) {
    final rows = j['rows'] as int, cols = j['cols'] as int;
    final sea = List<bool>.filled(rows * cols, false);
    for (final i in (j['sea'] as List).cast<int>()) {
      sea[i] = true;
    }
    return IslandsPuzzle(rows: rows, cols: cols, clues: (j['clues'] as List).cast<int?>(), sea: sea);
  }
}

/// Cells breaking a rule. [sea] marks shaded cells (unshaded = land). With
/// [complete], sea connectivity and island sizes are checked too.
Set<int> islandsConflicts(int rows, int cols, List<int?> clues, List<bool> sea, {required bool complete}) {
  final nb = orthNeighbors(rows, cols);
  final bad = <int>{};
  for (var r = 0; r + 1 < rows; r++) {
    for (var c = 0; c + 1 < cols; c++) {
      final block = [r * cols + c, r * cols + c + 1, (r + 1) * cols + c, (r + 1) * cols + c + 1];
      if (block.every((i) => sea[i])) bad.addAll(block);
    }
  }
  for (var i = 0; i < sea.length; i++) {
    if (sea[i] && clues[i] != null) bad.add(i);
  }
  if (!complete) return bad;
  for (final comp in components(nb, (i) => !sea[i])) {
    final nums = [for (final i in comp) if (clues[i] != null) i];
    if (nums.length != 1 || clues[nums.first] != comp.length) bad.addAll(nums.isEmpty ? comp : nums);
  }
  final seas = components(nb, (i) => sea[i]);
  if (seas.length > 1) {
    seas.sort((a, b) => a.length.compareTo(b.length));
    for (final s in seas.sublist(0, seas.length - 1)) {
      bad.addAll(s);
    }
  }
  return bad;
}
