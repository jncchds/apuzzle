import '../../core/grid.dart';
import '../../core/value_grid.dart';

/// Clue cell: given color + number of *empty* neighbours (8-neighbourhood)
/// that must end up in the same color.
class HuesPuzzle implements ValueGridPuzzle {
  const HuesPuzzle({required this.rows, required this.cols, required this.colors, required this.clues, required this.solution});

  final int rows;
  final int cols;
  final int colors;

  /// Number for clue cells, null for cells the player colors.
  final List<int?> clues;
  final List<int> solution;

  @override
  GridSize get size => GridSize(rows, cols);
  @override
  int? givenAt(int index) => clues[index] == null ? null : solution[index];
  @override
  int solutionAt(int index) => solution[index];

  Map<String, dynamic> toJson() => {'rows': rows, 'cols': cols, 'colors': colors, 'clues': clues, 'solution': solution};
  factory HuesPuzzle.fromJson(Map<String, dynamic> j) => HuesPuzzle(
        rows: j['rows'] as int,
        cols: j['cols'] as int,
        colors: j['colors'] as int,
        clues: (j['clues'] as List).cast<int?>(),
        solution: (j['solution'] as List).cast<int>(),
      );
}

List<List<int>> huesNeighbors(int rows, int cols) => List.generate(rows * cols, (i) {
      final r = i ~/ cols, c = i % cols;
      return [
        for (var dr = -1; dr <= 1; dr++)
          for (var dc = -1; dc <= 1; dc++)
            if ((dr != 0 || dc != 0) && r + dr >= 0 && r + dr < rows && c + dc >= 0 && c + dc < cols) (r + dr) * cols + c + dc,
      ];
    });

/// Clue number for cell [i] given which cells are clues and the coloring.
int huesCount(List<List<int>> nb, List<bool> isClue, List<int> colorOf, int i) =>
    nb[i].where((j) => !isClue[j] && colorOf[j] == colorOf[i]).length;

/// Clue cells whose number is already impossible (-1 = uncolored).
Set<int> huesConflicts(HuesPuzzle p, List<int> g) {
  final nb = huesNeighbors(p.rows, p.cols);
  final bad = <int>{};
  for (var i = 0; i < g.length; i++) {
    final m = p.clues[i];
    if (m == null) continue;
    var same = 0, open = 0;
    for (final j in nb[i]) {
      if (p.clues[j] != null) continue;
      if (g[j] < 0) {
        open++;
      } else if (g[j] == p.solution[i]) {
        same++;
      }
    }
    if (same > m || same + open < m) bad.add(i);
  }
  return bad;
}
