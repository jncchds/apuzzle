/// Neighbour lists and connectivity helpers for flat (r * cols + c) grids.
library;

import 'dart:math';

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
        if ((dr != 0 || dc != 0) && r + dr >= 0 && r + dr < rows && c + dc >= 0 && c + dc < cols)
          (r + dr) * cols + c + dc,
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

/// A random path through every cell: backbite moves from a serpentine.
List<int> randomHamiltonianPath(int rows, int cols, Random rng) {
  var path = <int>[
    for (var r = 0; r < rows; r++)
      for (var k = 0; k < cols; k++) r * cols + (r.isEven ? k : cols - 1 - k),
  ];
  List<int> neighbors(int i) {
    final r = i ~/ cols, c = i % cols;
    return [if (r > 0) i - cols, if (r < rows - 1) i + cols, if (c > 0) i - 1, if (c < cols - 1) i + 1];
  }

  final steps = rows * cols * 40;
  final pos = List<int>.filled(rows * cols, 0);
  for (var s = 0; s < steps; s++) {
    if (rng.nextBool()) path = path.reversed.toList();
    for (var k = 0; k < path.length; k++) {
      pos[path[k]] = k;
    }
    final endCell = path.last;
    final opts = [
      for (final x in neighbors(endCell))
        if (pos[x] != path.length - 2) x,
    ];
    if (opts.isEmpty) continue;
    final x = opts[rng.nextInt(opts.length)];
    final i = pos[x];
    // p0..pi, pL, pL-1, ..., p(i+1)
    path = [...path.sublist(0, i + 1), ...path.sublist(i + 1).reversed];
  }
  return path;
}
