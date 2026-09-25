import 'dart:math';

import '../../core/difficulty.dart';
import '../../core/grid_graph.dart';
import 'lamps_model.dart';
import 'lamps_solver.dart';

/// Symmetric random walls → lamps on unlit cells until all is lit → number
/// every wall → drop numbers while the difficulty's tier still solves it.
LampsPuzzle generateLamps(GenParams params) {
  final rows = params.size.rows, cols = params.size.cols, n = rows * cols;
  final rng = Random(params.seed);
  final d = params.difficulty;
  final tier = d == Difficulty.easy ? 1 : 2;
  final nb = orthNeighbors(rows, cols);
  LampsPuzzle? fallback;

  for (var attempt = 0; attempt < 30; attempt++) {
    // Walls, symmetric under a half turn.
    final walls = List<bool>.filled(n, false);
    final share = (d == Difficulty.hard ? 0.12 : 0.16) + rng.nextDouble() * 0.08;
    for (var i = 0; i <= (n - 1) ~/ 2; i++) {
      if (rng.nextDouble() < share) walls[i] = walls[n - 1 - i] = true;
    }
    if (walls.every((w) => w) || !walls.contains(true)) continue;
    final sight = lampsSight(rows, cols, walls);
    final lamps = List<bool>.filled(n, false);
    final lit = List<bool>.filled(n, false);
    for (final i in [for (var i = 0; i < n; i++) i]..shuffle(rng)) {
      if (walls[i] || lit[i]) continue;
      lamps[i] = lit[i] = true;
      for (final j in sight[i]) {
        lit[j] = true;
      }
    }
    final numbers = [for (var i = 0; i < n; i++) walls[i] ? nb[i].where((j) => lamps[j]).length : null];
    bool solvable(int t) {
      final s = LampsSolver(rows, cols, walls, numbers);
      return s.solve(s.initial(), t);
    }

    if (!solvable(tier)) continue;
    // Easy and medium keep a few more numbers than the logic strictly needs.
    final keep = d == Difficulty.hard ? 0.0 : 0.25;
    for (final i in [for (var i = 0; i < n; i++) if (walls[i]) i]..shuffle(rng)) {
      if (rng.nextDouble() < keep) continue;
      final v = numbers[i];
      numbers[i] = null;
      if (!solvable(tier)) numbers[i] = v;
    }
    final puzzle = LampsPuzzle(rows: rows, cols: cols, walls: walls, numbers: numbers, lamps: lamps);
    if (tier == 2 && solvable(1)) {
      fallback ??= puzzle;
      continue;
    }
    return puzzle;
  }
  return fallback ?? generateLamps(params.withSeed(params.seed + 1));
}
