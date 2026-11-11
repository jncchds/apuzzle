import 'dart:math';

import '../../core/difficulty.dart';
import 'slant_model.dart';
import 'slant_solver.dart';

/// The logic tier a difficulty aims for.
int slantTier(Difficulty d) => switch (d) {
  Difficulty.easy => 1,
  Difficulty.medium => 2,
  _ => 3,
};

/// Random diagonals with no loop: cells in random order, each a random
/// diagonal, or the other one where that would close a loop.
List<int>? slantLayout(int rows, int cols, Random rng) {
  final g = SlantGeometry.of(rows, cols);
  final order = List.generate(g.cells, (i) => i)..shuffle(rng);
  final v = List<int>.filled(g.cells, -1);
  final forest = SlantForest(g.corners);
  for (final i in order) {
    final first = rng.nextInt(2);
    var placed = false;
    for (final val in [first, 1 - first]) {
      final (a, b) = g.ends(i, val);
      if (forest.joined(a, b)) continue;
      forest.join(a, b);
      v[i] = val;
      placed = true;
      break;
    }
    if (!placed) return null;
  }
  return v;
}

/// Every corner's number for [v].
List<int> slantClues(SlantGeometry g, List<int> v) => [
  for (var k = 0; k < g.corners; k++) g.cornerCells[k].where((e) => v[e.$1] == e.$2).length,
];

/// Random loop-free diagonals with every number shown, cells shown where
/// the tier still stalls, then numbers (and those cells) taken away in
/// random order while logic up to the tier solves the board (hard first
/// strips at tier 2, then with probing). Medium and hard keep the first of a
/// few boards the tier below can't finish, else the one it gets least far
/// with.
SlantPuzzle generateSlant(GenParams params) {
  final rows = params.size.rows, cols = params.size.cols;
  final rng = Random(params.seed);
  final target = slantTier(params.difficulty);
  final g = SlantGeometry.of(rows, cols);
  final tries = switch (params.difficulty) {
    Difficulty.easy => 1,
    Difficulty.medium => 8,
    _ => 16,
  };

  SlantPuzzle? best;
  var bestScore = -1;
  for (var attempt = 0; attempt < tries || best == null; attempt++) {
    final sol = slantLayout(rows, cols, rng);
    if (sol == null) continue;
    final clues = slantClues(g, sol);
    final givens = <int>[];
    SlantPuzzle make() => SlantPuzzle(rows: rows, cols: cols, clues: clues, solution: sol, givens: List.of(givens));
    bool solves(int tier) => SlantSolver(make()).solveLogic(tier) != null;

    // Show cells where even every number leaves the tier stuck.
    while (!solves(target)) {
      final v = SlantSolver(make()).start();
      SlantSolver(make()).propagate(v, target);
      final open = [
        for (var i = 0; i < g.cells; i++)
          if (v[i] < 0) i,
      ];
      givens.add(open[rng.nextInt(open.length)]);
    }
    for (final tier in [if (target == 3) 2, target]) {
      final order = [
        for (var k = 0; k < g.corners; k++)
          if (clues[k] >= 0) k,
      ]..shuffle(rng);
      for (final k in order) {
        final keep = clues[k];
        clues[k] = -1;
        if (!solves(tier)) clues[k] = keep;
      }
    }
    for (final i in List.of(givens)..shuffle(rng)) {
      givens.remove(i);
      if (!solves(target)) givens.add(i);
    }
    final puzzle = make();
    if (target == 1) return puzzle;
    final slack = SlantSolver(puzzle).slack(target - 1);
    if (slack > bestScore) {
      bestScore = slack;
      best = puzzle;
    }
    if (slack > 0) break;
  }
  return best!;
}
