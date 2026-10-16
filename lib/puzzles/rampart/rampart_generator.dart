import 'dart:math';

import '../../core/difficulty.dart';
import '../../core/grid_graph.dart';
import 'rampart_model.dart';
import 'rampart_solver.dart';

int rampartTier(Difficulty d) => switch (d) {
  Difficulty.easy => 1,
  Difficulty.medium => 2,
  _ => 3,
};

/// A random wall (connected, no 2×2 block), a clue on every cell left,
/// then clues taken away in random order while the difficulty's tier still
/// solves the board (on hard first with tier 2, then with probing). Medium
/// and hard keep the best of several boards by how far the tier below gets.
RampartPuzzle generateRampart(GenParams params) {
  final n = params.size.rows, cells = n * n;
  final rng = Random(params.seed);
  final tier = rampartTier(params.difficulty);
  final nb = orthNeighbors(n, n);
  final tries = switch (params.difficulty) {
    Difficulty.easy => 1,
    Difficulty.medium => 12,
    _ => 30,
  };
  // No `-1 << 30` sentinel: on the web shifts give unsigned 32-bit results,
  // so it would be positive and no board would ever beat it.
  RampartPuzzle? best;
  var bestScore = 0;

  for (var attempt = 0; attempt < tries; attempt++) {
    final shaded = _wall(n, nb, rng);
    final clues = <List<int>?>[
      for (var i = 0; i < cells; i++) shaded[i] ? null : rampartRuns(rampartRingMask(n, i, (j) => shaded[j])),
    ];
    RampartPuzzle board() => RampartPuzzle(n: n, clues: List.of(clues), shaded: shaded);
    bool solves(int t) => RampartSolver(board()).slack(t) == 0;

    final order = [
      for (var i = 0; i < cells; i++)
        if (clues[i] != null) i,
    ]..shuffle(rng);
    for (final t in {min(tier, 2), tier}) {
      for (final i in order) {
        final keep = clues[i];
        if (keep == null) continue;
        clues[i] = null;
        if (!solves(t)) clues[i] = keep;
      }
    }
    final puzzle = board();
    if (tier == 1) return puzzle;
    // Score: the tier below should get stuck, the further behind the better.
    final below = RampartSolver(puzzle).slack(tier - 1);
    final score = (below > 0 ? 1000 : 0) + min(below, cells ~/ 3) * 4;
    if (best == null || score > bestScore) (best, bestScore) = (puzzle, score);
    if (below >= cells ~/ 3) break;
  }
  return best!;
}

/// Grows a wall from a random cell, one random cell next to it at a time,
/// never filling a 2×2 block, up to about half the board.
List<bool> _wall(int n, List<List<int>> nb, Random rng) {
  final shaded = List<bool>.filled(n * n, false);
  final target = (n * n * (0.48 + rng.nextDouble() * 0.08)).round();
  bool pool(int i) {
    final y = i ~/ n, x = i % n;
    for (final (dy, dx) in const [(0, 0), (0, -1), (-1, 0), (-1, -1)]) {
      final ty = y + dy, tx = x + dx;
      if (ty < 0 || tx < 0 || ty + 1 >= n || tx + 1 >= n) continue;
      final b = ty * n + tx;
      if ([b, b + 1, b + n, b + n + 1].every((j) => j == i || shaded[j])) return true;
    }
    return false;
  }

  shaded[rng.nextInt(n * n)] = true;
  var count = 1;
  while (count < target) {
    final frontier = <int>[
      for (var i = 0; i < n * n; i++)
        if (!shaded[i] && nb[i].any((j) => shaded[j]) && !pool(i)) i,
    ];
    if (frontier.isEmpty) break;
    // Prefer cells touching the wall on one side only, so it winds.
    final thin = frontier.where((i) => nb[i].where((j) => shaded[j]).length == 1).toList();
    final from = thin.isNotEmpty && rng.nextInt(4) > 0 ? thin : frontier;
    shaded[from[rng.nextInt(from.length)]] = true;
    count++;
  }
  return shaded;
}
