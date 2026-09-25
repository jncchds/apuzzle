import 'dart:math';

import '../../core/difficulty.dart';
import '../../core/lattice_loop.dart';
import 'fence_model.dart';
import 'fence_solver.dart';

/// Random region → its outline is the loop → number every cell → drop
/// numbers while the difficulty's tier still solves it.
FencePuzzle generateFence(GenParams params) {
  final rows = params.size.rows, cols = params.size.cols, n = rows * cols;
  final rng = Random(params.seed);
  final d = params.difficulty;
  final tier = d == Difficulty.easy ? 1 : 2;
  final g = LatticeLoop(rows + 1, cols + 1);
  FencePuzzle? fallback;

  for (var attempt = 0; attempt < 20; attempt++) {
    final region = randomLoopRegion(rows, cols, rng, 0.4 + rng.nextDouble() * 0.2);
    final lines = g.boundary(region);
    final numbers = <int?>[
      for (var i = 0; i < n; i++) fenceSides(g, i ~/ cols, i % cols).where((e) => lines[e]).length,
    ];
    bool solvesAt(int t) {
      final s = FenceSolver(rows, cols, numbers);
      return s.solve(s.initial(), t);
    }

    // Tier-1 logic is much cheaper, so try it first.
    bool solvable(int t) => solvesAt(1) || (t > 1 && solvesAt(t));

    if (!solvable(tier)) continue;
    // Easy and medium keep some numbers the logic doesn't strictly need.
    final keep = switch (d) {
      Difficulty.easy => 0.3,
      Difficulty.medium => 0.15,
      _ => 0.0,
    };
    for (final i in [for (var i = 0; i < n; i++) i]..shuffle(rng)) {
      if (rng.nextDouble() < keep) continue;
      final v = numbers[i];
      numbers[i] = null;
      if (!solvable(tier)) numbers[i] = v;
    }
    final puzzle = FencePuzzle(rows: rows, cols: cols, numbers: numbers, lines: lines);
    if (tier == 2 && solvesAt(1)) {
      fallback ??= puzzle;
      continue;
    }
    return puzzle;
  }
  return fallback ?? generateFence(params.withSeed(params.seed + 1));
}
