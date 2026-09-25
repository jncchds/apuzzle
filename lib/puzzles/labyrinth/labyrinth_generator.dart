import 'dart:math';

import '../../core/difficulty.dart';
import 'labyrinth_model.dart';

/// A perfect maze from the "growing tree" algorithm. The chance of carving on
/// from the newest cell sets the style: 0 gives Prim-like mazes with many short,
/// obvious dead ends; near 1 gives long winding corridors whose dead ends run
/// deep. Hard keeps the candidate whose way out passes the most junctions.
LabyrinthPuzzle generateLabyrinth(GenParams params) {
  final rng = Random(params.seed);
  final (newest, tries) = switch (params.difficulty) {
    Difficulty.easy => (0.0, 1),
    Difficulty.medium => (0.5, 1),
    _ => (0.9, 4),
  };
  LabyrinthPuzzle? best;
  var bestScore = -1;
  for (var t = 0; t < tries; t++) {
    final p = _carve(params.size.rows, params.size.cols, newest, rng);
    final score = _junctions(p);
    if (score > bestScore) {
      best = p;
      bestScore = score;
    }
  }
  return best!;
}

LabyrinthPuzzle _carve(int rows, int cols, double newest, Random rng) {
  final n = rows * cols;
  final open = List<int>.filled(n, 0);
  final seen = List<bool>.filled(n, false);
  final first = rng.nextInt(n);
  seen[first] = true;
  final active = <int>[first];
  while (active.isNotEmpty) {
    final k = rng.nextDouble() < newest ? active.length - 1 : rng.nextInt(active.length);
    final i = active[k];
    final options = [
      for (final d in dirs)
        if (neighbor(i, d, rows, cols) case final j? when !seen[j]) (d, j),
    ];
    if (options.isEmpty) {
      active.removeAt(k);
      continue;
    }
    final (d, j) = options[rng.nextInt(options.length)];
    open[i] |= d;
    open[j] |= opposite(d);
    seen[j] = true;
    active.add(j);
  }
  return LabyrinthPuzzle(rows: rows, cols: cols, open: open, solution: _wayOut(rows, cols, open));
}

/// The unique way from the top-left to the bottom-right cell.
List<int> _wayOut(int rows, int cols, List<int> open) {
  final n = rows * cols;
  final parent = List<int>.filled(n, -1)..[0] = 0;
  final queue = <int>[0];
  for (var q = 0; q < queue.length; q++) {
    final i = queue[q];
    for (final d in dirs) {
      if (open[i] & d == 0) continue;
      final j = neighbor(i, d, rows, cols)!;
      if (parent[j] >= 0) continue;
      parent[j] = i;
      queue.add(j);
    }
  }
  final path = <int>[n - 1];
  while (path.last != 0) {
    path.add(parent[path.last]);
  }
  return path.reversed.toList();
}

/// Decision points on the way out (cells with a side passage).
int _junctions(LabyrinthPuzzle p) => p.solution.where((i) => exits(p, i) > 2).length;
