import 'dart:math';

import '../../core/difficulty.dart';
import '../../core/latin_square.dart';
import 'skyline_model.dart';
import 'skyline_solver.dart';

/// Logic tier of a difficulty: clue bounds and singles, every way to fill a
/// line, probing.
int skylineTier(Difficulty d) => switch (d) {
  Difficulty.easy => 1,
  Difficulty.medium => 2,
  _ => 3,
};

/// Random Latin square → every clue → digits given where the tier's logic
/// stalls → givens, then clues, taken away while the tier still solves it.
/// Medium and hard prefer boards the tier below can't finish.
SkylinePuzzle generateSkyline(GenParams params) {
  final n = params.size.rows;
  final rng = Random(params.seed);
  final tier = skylineTier(params.difficulty);
  final sq = LatinSquare.of(n);
  SkylinePuzzle? fallback;

  bool solves(List<int?> clues, List<int?> givens, int tier) => SkylineSolver(n, clues).solve(sq.start(givens), tier);

  for (var attempt = 0; attempt < 8; attempt++) {
    final solution = sq.random(rng);
    final clues = <int?>[...skylineClues(n, solution)];
    final givens = List<int?>.filled(n * n, null);
    while (true) {
      final c = sq.start(givens);
      if (SkylineSolver(n, clues).solve(c, tier)) break;
      final open = [
        for (var i = 0; i < c.length; i++)
          if (!LatinSquare.single(c[i])) i,
      ];
      final i = open[rng.nextInt(open.length)];
      givens[i] = solution[i];
    }
    for (final i in [for (var i = 0; i < n * n; i++) i]..shuffle(rng)) {
      if (givens[i] == null) continue;
      givens[i] = null;
      if (!solves(clues, givens, tier)) givens[i] = solution[i];
    }
    // Easy boards keep a few more clues than they need.
    final spare = tier == 1 ? n ~/ 2 : 0;
    var dropped = 0;
    for (final k in [for (var k = 0; k < 4 * n; k++) k]..shuffle(rng)) {
      if (tier == 1 && dropped >= 4 * n - n * 2 - spare) break;
      final clue = clues[k];
      clues[k] = null;
      if (solves(clues, givens, tier)) {
        dropped++;
      } else {
        clues[k] = clue;
      }
    }
    final puzzle = SkylinePuzzle(n: n, clues: clues, givens: givens, solution: solution);
    if (tier == 1 || n < 5 || !solves(clues, givens, tier - 1)) return puzzle;
    fallback ??= puzzle;
  }
  return fallback!;
}
