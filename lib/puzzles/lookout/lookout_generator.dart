import 'dart:math';

import '../../core/difficulty.dart';
import '../../core/grid_graph.dart';
import 'lookout_model.dart';
import 'lookout_solver.dart';

int lookoutTier(Difficulty d) => switch (d) {
  Difficulty.easy => 1,
  Difficulty.medium => 2,
  _ => 3,
};

/// Random shading (no two touching, the rest in one piece), a number on
/// every cell left, then numbers taken away in random order while the
/// difficulty's tier still solves the board (on hard first with tier 2,
/// then with probing). Medium and hard keep the best of several boards by
/// how far the tier below gets.
LookoutPuzzle generateLookout(GenParams params) {
  final n = params.size.rows, cells = n * n;
  final rng = Random(params.seed);
  final tier = lookoutTier(params.difficulty);
  final nb = orthNeighbors(n, n);
  final tries = switch (params.difficulty) {
    Difficulty.easy => 1,
    Difficulty.medium => 8,
    _ => 10,
  };
  LookoutPuzzle? best;
  var bestScore = -1 << 30;

  for (var attempt = 0; attempt < tries; attempt++) {
    final shaded = _shade(n, nb, rng);
    final clues = <int?>[for (var i = 0; i < cells; i++) shaded[i] ? null : lookoutSeen(n, i, (j) => !shaded[j])];
    LookoutPuzzle board() => LookoutPuzzle(n: n, clues: List.of(clues), shaded: shaded);
    bool solves(int t) {
      final s = LookoutSolver(board());
      return s.slack(t) == 0;
    }

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
    final below = LookoutSolver(puzzle).slack(tier - 1);
    final score = (below > 0 ? 1000 : 0) + min(below, cells ~/ 3) * 4;
    if (score > bestScore) (best, bestScore) = (puzzle, score);
    if (below >= cells ~/ 3) break;
  }
  return best!;
}

/// Shades random cells, none touching and the rest in one piece, up to
/// a fifth to a quarter of the board.
List<bool> _shade(int n, List<List<int>> nb, Random rng) {
  final shaded = List<bool>.filled(n * n, false);
  final target = (n * n * (0.2 + rng.nextDouble() * 0.06)).round();
  var count = 0;
  for (final i in [for (var i = 0; i < n * n; i++) i]..shuffle(rng)) {
    if (count >= target) break;
    if (nb[i].any((j) => shaded[j])) continue;
    shaded[i] = true;
    if (components(nb, (j) => !shaded[j]).length == 1) {
      count++;
    } else {
      shaded[i] = false;
    }
  }
  return shaded;
}
