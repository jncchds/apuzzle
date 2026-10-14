import 'dart:math';

import '../../core/difficulty.dart';
import '../../core/latin_square.dart';
import 'signs_model.dart';
import 'signs_solver.dart';

/// Logic tier of a difficulty: sign bounds and singles, + runs of signs and
/// pairs, + probing.
int signsTier(Difficulty d) => switch (d) {
  Difficulty.easy => 1,
  Difficulty.medium => 2,
  _ => 3,
};

/// Random Latin square → every sign → digits given where the tier's logic
/// stalls → givens, then signs, taken away while the tier still solves it
/// (easy boards get some signs back). Medium and hard prefer boards the tier
/// below can't finish.
SignsPuzzle generateSigns(GenParams params) {
  final n = params.size.rows;
  final rng = Random(params.seed);
  final tier = signsTier(params.difficulty);
  final sq = LatinSquare.of(n);
  SignsPuzzle? fallback;

  bool solves(List<Sign> signs, List<int?> givens, int tier) => SignsSolver(n, signs).solve(sq.start(givens), tier);

  // Hard boards are built without probing first (much cheaper), then
  // stripped further with it: whatever the first pass could do without stays
  // removable.
  final phases = [if (tier == 3) 2, tier];

  for (var attempt = 0; attempt < 8; attempt++) {
    final solution = sq.random(rng);
    final signs = allSigns(n, solution);
    final givens = List<int?>.filled(n * n, null);
    final full = SignsSolver(n, signs);
    while (true) {
      final c = sq.start(givens);
      if (full.solve(c, phases.first)) break;
      final open = [
        for (var i = 0; i < c.length; i++)
          if (!LatinSquare.single(c[i])) i,
      ];
      final i = open[rng.nextInt(open.length)];
      givens[i] = solution[i];
    }
    final dropped = <Sign>[];
    for (final t in phases) {
      for (final i in [for (var i = 0; i < n * n; i++) i]..shuffle(rng)) {
        if (givens[i] == null) continue;
        givens[i] = null;
        if (!solves(signs, givens, t)) givens[i] = solution[i];
      }
      for (final s in [...signs]..shuffle(rng)) {
        signs.remove(s);
        if (solves(signs, givens, t)) {
          dropped.add(s);
        } else {
          signs.add(s);
        }
      }
    }
    // Easy boards keep a few more signs than they need.
    if (tier == 1) signs.addAll(dropped.take(n));
    signs.sort((a, b) => a.lo != b.lo ? a.lo - b.lo : a.hi - b.hi);
    final puzzle = SignsPuzzle(n: n, signs: signs, givens: givens, solution: solution);
    if (tier == 1 || n < 5 || !solves(signs, givens, tier - 1)) return puzzle;
    fallback ??= puzzle;
  }
  return fallback!;
}
