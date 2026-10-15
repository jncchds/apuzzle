import 'dart:math';

import '../../core/difficulty.dart';
import 'glide_model.dart';
import 'glide_solver.dart';

/// Extra moves a move limit allows, as a share of the best way out.
double glideSlack(Difficulty d) => switch (d) {
  Difficulty.easy => 1.0,
  Difficulty.medium => 0.5,
  _ => 0.25,
};

/// The move limit for a best way out of [best] moves.
int glideLimit(int best, Difficulty d) => best + (best * glideSlack(d)).ceil();

/// Nodes the exact search may visit before the board settles for a shorter
/// way out than the strategy's.
const glideNodeCap = 1500000;

/// A board mixed by the difficulty: easy and medium walk the gap at random
/// (2 and 3 moves per cell, never straight back), hard deals a random
/// arrangement that can be solved (fixing the parity by swapping two tiles).
/// The plan is the shortest of the walk taken back, the strategy and, on
/// 3×3 or after an easy walk, the exact fewest moves (within a node cap).
GlidePuzzle generateGlide({
  required int rows,
  required int cols,
  required Difficulty difficulty,
  required int seed,
  bool limited = false,
  bool colors = false,
}) {
  final rng = Random(seed);
  final n = rows * cols;
  final solved = [for (var i = 1; i < n; i++) i, 0];
  var tiles = solved;
  String? back;
  if (difficulty == Difficulty.hard) {
    do {
      tiles = List.of(solved)..shuffle(rng);
      if (!glideSolvable(rows, cols, tiles)) {
        final a = tiles.indexWhere((t) => t != 0);
        final b = tiles.indexWhere((t) => t != 0, a + 1);
        final t = tiles[a];
        tiles[a] = tiles[b];
        tiles[b] = t;
      }
    } while (glideSorted(tiles));
  } else {
    final length = n * (difficulty == Difficulty.easy ? 2 : 3);
    final walk = StringBuffer();
    var gap = n - 1;
    String? last;
    while (walk.length < length || glideSorted(tiles)) {
      final options = [
        for (final d in glideDirs.split(''))
          if (glideStep(rows, cols, gap, d) >= 0 && (last == null || d != glideOpposite(last))) d,
      ];
      final d = options[rng.nextInt(options.length)];
      gap = glideStep(rows, cols, gap, d);
      walk.write(d);
      last = d;
      tiles = glideApply(rows, cols, tiles, d);
    }
    back = glideCancel(glideReverse(walk.toString()));
  }
  final solver = GlideSolver.of(rows, cols);
  var plan = solver.solve(tiles);
  if (back != null && back.length < plan.length) plan = back;
  var optimal = n <= 9;
  if (!optimal && difficulty == Difficulty.easy) {
    final exact = solver.optimal(tiles, nodeCap: glideNodeCap);
    if (exact != null) {
      plan = exact;
      optimal = true;
    }
  }
  return GlidePuzzle(
    rows: rows,
    cols: cols,
    start: tiles,
    plan: plan,
    optimal: optimal,
    limit: limited ? glideLimit(plan.length, difficulty) : null,
    colors: colors,
  );
}
