import 'dart:math';

import '../../core/difficulty.dart';
import '../../core/latin_square.dart';
import 'straights_model.dart';
import 'straights_solver.dart';

/// Logic tier of a difficulty: singles and the stretches each run can hold,
/// + pairs, triples and every way to fill a run, + probing.
int straightsTier(Difficulty d) => switch (d) {
  Difficulty.easy => 1,
  Difficulty.medium => 2,
  _ => 3,
};

/// Dark cells, symmetric under a half turn, about a fifth to a quarter of
/// the board.
List<bool> straightsLayout(int n, Random rng) {
  final dark = List.filled(n * n, false);
  final want = (n * n * (0.2 + rng.nextDouble() * 0.06)).round();
  var count = 0;
  while (count < want) {
    final i = rng.nextInt(n * n);
    final j = n * n - 1 - i;
    if (dark[i]) continue;
    dark[i] = dark[j] = true;
    count += i == j ? 1 : 2;
  }
  return dark;
}

/// A random filling of the open cells of [dark]: different numbers in every
/// line, consecutive in every run. Null if the search gives up.
List<int>? straightsFill(int n, List<bool> dark, Random rng) {
  final p = StraightsPuzzle(
    n: n,
    dark: dark,
    clues: List.filled(n * n, null),
    givens: List.filled(n * n, null),
    solution: List.filled(n * n, 0),
  );
  final s = StraightsSolver(p);
  var steps = 0;
  List<int>? go(List<int> c) {
    if (++steps > 3000 || !s.propagate(c, 1)) return null;
    var best = -1, fewest = n + 1;
    for (var i = 0; i < c.length; i++) {
      final k = LatinSquare.count(c[i]);
      if (k > 1 && k < fewest) {
        fewest = k;
        best = i;
      }
    }
    if (best < 0) return c;
    for (final d in LatinSquare.digits(c[best])..shuffle(rng)) {
      final done = go(List.of(c)..[best] = 1 << d);
      if (done != null) return done;
    }
    return null;
  }

  final done = go(s.start(List.filled(n * n, null)));
  return done == null ? null : s.values(done);
}

/// A number for every dark cell that can take one (none in its row or
/// column yet), in random order.
List<int?> _darkNumbers(int n, List<bool> dark, List<int> solution, Random rng) {
  final clues = List<int?>.filled(n * n, null);
  final used = List.filled(2 * n, 0);
  for (var i = 0; i < n * n; i++) {
    if (dark[i]) continue;
    used[i ~/ n] |= 1 << solution[i];
    used[n + i % n] |= 1 << solution[i];
  }
  for (final i in [for (var i = 0; i < n * n; i++) i]..shuffle(rng)) {
    if (!dark[i]) continue;
    final free = [
      for (var d = 0; d < n; d++)
        if ((used[i ~/ n] | used[n + i % n]) & (1 << d) == 0) d,
    ];
    if (free.isEmpty) continue;
    final d = free[rng.nextInt(free.length)];
    clues[i] = d;
    used[i ~/ n] |= 1 << d;
    used[n + i % n] |= 1 << d;
  }
  return clues;
}

/// Layout → filling → a number on every dark cell that can take one →
/// numbers given where the tier stalls → givens, then dark numbers, taken
/// away while the tier still solves it. Medium and hard keep the board with
/// the fewest givens that the tier below can't finish.
StraightsPuzzle generateStraights(GenParams params) {
  final n = params.size.rows;
  final rng = Random(params.seed);
  final tier = straightsTier(params.difficulty);
  final build = min(tier, 2);
  StraightsPuzzle? best;
  var bestScore = 1 << 30;
  // Small boards are quick to make but seldom need the higher tiers.
  final tries =
      switch (tier) {
        1 => 3,
        2 => 6,
        _ => 8,
      } *
      (n <= 6 ? 6 : 1);

  for (var attempt = 0; attempt < tries; attempt++) {
    final dark = straightsLayout(n, rng);
    final solution = straightsFill(n, dark, rng);
    if (solution == null) {
      attempt--;
      continue;
    }
    final clues = _darkNumbers(n, dark, solution, rng);
    final givens = List<int?>.filled(n * n, null);
    StraightsPuzzle make() =>
        StraightsPuzzle(n: n, dark: dark, clues: List.of(clues), givens: List.of(givens), solution: solution);
    bool solves(int tier) {
      final p = make();
      final s = StraightsSolver(p);
      return s.solve(s.start(givens), tier);
    }

    while (true) {
      final p = make();
      final s = StraightsSolver(p);
      final c = s.start(givens);
      if (s.solve(c, build)) break;
      final open = [
        for (var i = 0; i < c.length; i++)
          if (!dark[i] && !StraightsSolver.single(c[i])) i,
      ];
      final i = open[rng.nextInt(open.length)];
      givens[i] = solution[i];
    }
    for (final i in [for (var i = 0; i < n * n; i++) i]..shuffle(rng)) {
      if (givens[i] == null) continue;
      givens[i] = null;
      if (!solves(build)) givens[i] = solution[i];
    }
    for (final i in [for (var i = 0; i < n * n; i++) i]..shuffle(rng)) {
      final clue = clues[i];
      if (clue == null) continue;
      clues[i] = null;
      if (!solves(build)) clues[i] = clue;
    }
    if (tier == 3) {
      final items = [
        for (var i = 0; i < n * n; i++)
          if (givens[i] != null || clues[i] != null) i,
      ]..shuffle(rng);
      for (final i in items.take(n <= 7 ? items.length : 10)) {
        if (givens[i] case final g?) {
          givens[i] = null;
          if (!solves(3)) givens[i] = g;
        } else {
          final clue = clues[i];
          clues[i] = null;
          if (!solves(3)) clues[i] = clue;
        }
      }
    }
    final puzzle = make();
    final shown = givens.where((g) => g != null).length;
    final graded = tier == 1 || !solves(tier - 1);
    final score = (graded ? 0 : 1000) + shown;
    if (score < bestScore) {
      best = puzzle;
      bestScore = score;
    }
    if (graded && shown <= n ~/ 2 + 1) break;
  }
  return best!;
}
