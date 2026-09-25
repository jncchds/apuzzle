/// Neighbour lists and connectivity helpers for flat (r * cols + c) grids.
library;

/// Orthogonal neighbours of every cell.
List<List<int>> orthNeighbors(int rows, int cols) => List.generate(rows * cols, (i) {
      final r = i ~/ cols, c = i % cols;
      return [
        if (r > 0) i - cols,
        if (c + 1 < cols) i + 1,
        if (r + 1 < rows) i + cols,
        if (c > 0) i - 1,
      ];
    });

/// All 8 neighbours of every cell.
List<List<int>> kingNeighbors(int rows, int cols) => List.generate(rows * cols, (i) {
      final r = i ~/ cols, c = i % cols;
      return [
        for (var dr = -1; dr <= 1; dr++)
          for (var dc = -1; dc <= 1; dc++)
            if ((dr != 0 || dc != 0) && r + dr >= 0 && r + dr < rows && c + dc >= 0 && c + dc < cols) (r + dr) * cols + c + dc,
      ];
    });

/// Connected components of the cells where [inside] holds (lists of indices).
List<List<int>> components(List<List<int>> nb, bool Function(int) inside) {
  final seen = List<bool>.filled(nb.length, false);
  final out = <List<int>>[];
  for (var i = 0; i < nb.length; i++) {
    if (seen[i] || !inside(i)) continue;
    final comp = [i];
    seen[i] = true;
    for (var k = 0; k < comp.length; k++) {
      for (final j in nb[comp[k]]) {
        if (!seen[j] && inside(j)) {
          seen[j] = true;
          comp.add(j);
        }
      }
    }
    out.add(comp);
  }
  return out;
}
