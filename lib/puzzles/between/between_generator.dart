import 'dart:math';

import '../../core/difficulty.dart';
import 'between_model.dart';
import 'between_solver.dart';

/// Logic tier of a difficulty: singles and what the clues allow, every way
/// to fill a line, probing.
int betweenTier(Difficulty d) => switch (d) {
  Difficulty.easy => 1,
  Difficulty.medium => 2,
  _ => 3,
};

/// A random solution: two shaded cells and the digits 1..n−2 once in every
/// row and column.
List<int> betweenRandom(int n, Random rng) {
  final s = BetweenSolver(n, List.filled(2 * n, null));
  while (true) {
    var steps = 0;
    List<int>? go(List<int> c) {
      if (++steps > 4000 || !s.propagate(c, 1)) return null;
      var best = -1, fewest = n + 1;
      for (var i = 0; i < c.length; i++) {
        final k = _count(c[i]);
        if (k > 1 && k < fewest) {
          fewest = k;
          best = i;
        }
      }
      if (best < 0) return c;
      final options = [
        for (var v = 0; v < n - 1; v++)
          if (c[best] & (1 << v) != 0) v,
      ]..shuffle(rng);
      for (final v in options) {
        final done = go(List.of(c)..[best] = 1 << v);
        if (done != null) return done;
      }
      return null;
    }

    final done = go(s.start(List.filled(n * n, null)));
    if (done != null) return s.values(done);
  }
}

int _count(int m) {
  var k = 0;
  for (; m != 0; m &= m - 1) {
    k++;
  }
  return k;
}

/// Random solution → every clue → values given where the tier stalls →
/// givens, then clues, taken away while the tier still solves it. Medium
/// and hard keep the first board the tier below can't finish.
BetweenPuzzle generateBetween(GenParams params) {
  final n = params.size.rows;
  final rng = Random(params.seed);
  final tier = betweenTier(params.difficulty);
  BetweenPuzzle? fallback;
  var bestScore = 1 << 30;

  bool solves(List<int?> clues, List<int?> givens, int tier) {
    final s = BetweenSolver(n, clues);
    return s.solve(s.start(givens), tier);
  }

  final build = min(tier, 2);
  for (var attempt = 0; attempt < 12; attempt++) {
    final solution = betweenRandom(n, rng);
    final clues = <int?>[...betweenClues(n, solution)];
    final givens = List<int?>.filled(n * n, null);
    while (true) {
      final s = BetweenSolver(n, clues);
      final c = s.start(givens);
      if (s.solve(c, build)) break;
      final open = [
        for (var i = 0; i < c.length; i++)
          if (!BetweenSolver.single(c[i])) i,
      ];
      final i = open[rng.nextInt(open.length)];
      givens[i] = solution[i];
    }
    for (final i in [for (var i = 0; i < n * n; i++) i]..shuffle(rng)) {
      if (givens[i] == null) continue;
      givens[i] = null;
      if (!solves(clues, givens, build)) givens[i] = solution[i];
    }
    // Easy boards keep most clues.
    final drop = tier == 1 ? n ~/ 3 : 2 * n;
    var dropped = 0;
    for (final u in [for (var u = 0; u < 2 * n; u++) u]..shuffle(rng)) {
      if (dropped >= drop) break;
      final clue = clues[u];
      clues[u] = null;
      if (solves(clues, givens, build)) {
        dropped++;
      } else {
        clues[u] = clue;
      }
    }
    // Hard boards are built with tier 2, then a few more givens or clues go
    // while probing still solves them.
    if (tier == 3) {
      final items = [
        for (var i = 0; i < n * n; i++)
          if (givens[i] != null) i,
        for (var u = 0; u < 2 * n; u++)
          if (clues[u] != null) n * n + u,
      ]..shuffle(rng);
      final tries = n <= 6 ? items.length : 12 - n;
      for (final x in items.take(tries)) {
        if (x < n * n) {
          givens[x] = null;
          if (!solves(clues, givens, 3)) givens[x] = solution[x];
        } else {
          final clue = clues[x - n * n];
          clues[x - n * n] = null;
          if (!solves(clues, givens, 3)) clues[x - n * n] = clue;
        }
      }
    }
    final puzzle = BetweenPuzzle(n: n, clues: clues, givens: givens, solution: solution);
    final shown = givens.where((g) => g != null).length;
    final graded = tier == 1 || !solves(clues, givens, tier - 1);
    if (graded && shown <= n ~/ 2) return puzzle;
    final score = (graded ? 0 : 1000) + shown;
    if (score < bestScore) {
      fallback = puzzle;
      bestScore = score;
    }
  }
  return fallback!;
}
