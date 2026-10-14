import 'dart:math';

import '../../core/difficulty.dart';
import '../../core/grid_graph.dart';
import '../../core/latin_square.dart';
import 'solo_model.dart';
import 'solo_solver.dart';

int soloTier(Difficulty d) => switch (d) {
  Difficulty.easy => 1,
  Difficulty.medium => 2,
  _ => 3,
};

/// A random Latin square gives the numbers that stay; a random shading (no
/// two side by side, the rest in one piece) gets numbers copied from cells
/// left in their row or column. A local search then re-numbers or flips
/// cells the difficulty's tier can't settle, kept when the logic gets no
/// further behind (searching with the cheap tier 2 first on hard boards).
/// Medium and hard then push the tier below to stall the same way. Cells
/// still open at the end are shown from the start.
SoloPuzzle generateSolo(GenParams params) {
  final n = params.size.rows, cells = n * n;
  final rng = Random(params.seed);
  final tier = soloTier(params.difficulty);
  final nb = orthNeighbors(n, n);
  SoloPuzzle? fallback;
  var fallbackGrade = 0;

  for (var attempt = 0; attempt < 24; attempt++) {
    final latin = [for (final d in LatinSquare.of(n).random(rng)) d + 1];
    final digits = List.of(latin);
    final shaded = List<bool>.filled(cells, false);
    final maxShaded = (cells * 0.36).floor();

    bool connected() => components(nb, (i) => !shaded[i]).length == 1;
    bool canShade(int i) {
      if (shaded[i] || nb[i].any((j) => shaded[j])) return false;
      shaded[i] = true;
      final ok = connected();
      shaded[i] = false;
      return ok;
    }

    // A number for shaded cell [i]: one left in its row or column.
    void number(int i) {
      final r = i ~/ n, c = i % n;
      final options = {
        for (var k = 0; k < n; k++)
          if (!shaded[r * n + k]) digits[r * n + k],
        for (var k = 0; k < n; k++)
          if (!shaded[k * n + c]) digits[k * n + c],
      }.toList();
      digits[i] = options[rng.nextInt(options.length)];
    }

    // Shaded cells whose number no longer shows get a new one.
    void renumber() {
      final copies = soloCopies(n, digits);
      for (var i = 0; i < cells; i++) {
        if (shaded[i] && copies[i].every((j) => shaded[j])) number(i);
      }
    }

    final target = (cells * (0.28 + rng.nextDouble() * 0.06)).round();
    var count = 0;
    for (final i in [for (var i = 0; i < cells; i++) i]..shuffle(rng)) {
      if (count >= target) break;
      if (canShade(i)) {
        shaded[i] = true;
        count++;
      }
    }
    for (var i = 0; i < cells; i++) {
      if (shaded[i]) number(i);
    }

    List<int> stuck(int t) {
      final s = SoloSolver(n, digits);
      final st = s.start();
      if (!s.solve(st, t)) return [for (var i = 0; i < cells; i++) i];
      return [
        for (var i = 0; i < cells; i++)
          if (st[i] == -1) i,
      ];
    }

    // Changes cell [i] (a new number, or shaded/left); returns the undo.
    void Function() mutate(int i) {
      final d0 = List.of(digits), s0 = List.of(shaded);
      if (shaded[i]) {
        if (rng.nextInt(3) == 0) {
          shaded[i] = false;
          digits[i] = latin[i];
        } else {
          number(i);
        }
      } else if (count < maxShaded && canShade(i)) {
        shaded[i] = true;
        number(i);
        renumber();
      } else {
        final near = [
          for (final j in nb[i])
            if (shaded[j]) j,
        ];
        if (near.isNotEmpty) number(near[rng.nextInt(near.length)]);
      }
      return () {
        digits.setAll(0, d0);
        shaded.setAll(0, s0);
      };
    }

    int shadedCount() => shaded.where((s) => s).length;

    // Settle the board at [t] by changing stuck cells.
    List<int> settle(int t, List<int> open, int steps) {
      for (var step = 0; step < steps && open.isNotEmpty; step++) {
        final undo = mutate(open[rng.nextInt(open.length)]);
        count = shadedCount();
        final next = stuck(t);
        if (next.length <= open.length) {
          open = next;
        } else {
          undo();
          count = shadedCount();
        }
      }
      return open;
    }

    var open = settle(min(tier, 2), stuck(min(tier, 2)), cells * 4);
    if (tier == 3) open = stuck(3);
    if (open.isNotEmpty && attempt < 4) continue;

    // Harder: make the tier below get stuck, keeping the tier itself happy.
    if (tier > 1 && open.isEmpty) {
      var below = stuck(tier - 1).length;
      for (var step = 0; step < cells * 2 && below < max(3, cells ~/ 6); step++) {
        final undo = mutate(rng.nextInt(cells));
        count = shadedCount();
        final b = stuck(tier - 1).length;
        if (b >= below && stuck(tier).isEmpty) {
          below = b;
        } else {
          undo();
          count = shadedCount();
        }
      }
    }

    final givens = <int>[];
    while (true) {
      final s = SoloSolver(n, digits);
      final st = s.start(givens: givens, shaded: shaded);
      s.solve(st, tier);
      final left = [
        for (var i = 0; i < cells; i++)
          if (st[i] == -1) i,
      ];
      if (left.isEmpty) break;
      givens.add(left[rng.nextInt(left.length)]);
    }
    final puzzle = SoloPuzzle(n: n, digits: digits, shaded: shaded, givens: givens..sort());
    if (tier > 1) {
      final s = SoloSolver.of(puzzle);
      final grade = s.grade(s.start(givens: puzzle.givens, shaded: shaded));
      if (grade < tier) {
        if (grade > fallbackGrade) (fallback, fallbackGrade) = (puzzle, grade);
        continue;
      }
    }
    return puzzle;
  }
  return fallback ?? generateSolo(params.withSeed(params.seed + 1));
}
