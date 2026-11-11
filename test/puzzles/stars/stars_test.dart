import 'dart:math';

import 'package:apuzzle/core/difficulty.dart';
import 'package:apuzzle/core/grid.dart';
import 'package:apuzzle/puzzles/stars/stars_generator.dart';
import 'package:apuzzle/puzzles/stars/stars_model.dart';
import 'package:apuzzle/puzzles/stars/stars_solver.dart';
import 'package:apuzzle/puzzles/stars/stars_tutorial.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/timing.dart';

void main() {
  test('stars layout: k per row and column, none touching', () {
    for (final n in [9, 10]) {
      final sol = starsLayout(n, 2, Random(n))!;
      expect(sol.length, 2 * n);
      expect(starsConflicts(n, 2, [for (var i = 0; i < n * n; i++) i], sol), isEmpty);
    }
  });

  test('conflicts flag touching stars and crowded lines', () {
    final regions = [for (var i = 0; i < 64; i++) i ~/ 8];
    expect(starsConflicts(8, 2, regions, [0, 9]), {0, 9});
    expect(starsConflicts(8, 2, regions, [0, 2, 4]), {0, 2, 4});
    expect(starsConflicts(8, 2, regions, [0, 2]), isEmpty);
  });

  test('lesson boards need their technique', () {
    StarsSolver solver(int seed, Difficulty d, {Set<StarsRule> off = const {}}) {
      final p = generateStars(GenParams(size: const GridSize.square(9), difficulty: d, seed: seed));
      return StarsSolver(p.n, p.regions, disabled: off);
    }

    for (final (seed, rule) in [(starsBandSeed, StarsRule.bandIn), (starsAttackSeed, StarsRule.attack)]) {
      expect(solver(seed, Difficulty.medium).solveLogic(1), isNull, reason: '$rule: tier 1 solves it');
      expect(solver(seed, Difficulty.medium).solveLogic(2), isNotNull, reason: '$rule: tier 2 stalls');
      expect(solver(seed, Difficulty.medium, off: {rule}).solveLogic(2), isNull, reason: '$rule not needed');
    }
    expect(solver(starsProbeSeed, Difficulty.hard).grade(), 3);
  });

  for (final n in [9, 10]) {
    for (final d in [Difficulty.easy, Difficulty.medium, Difficulty.hard]) {
      test('stars ${n}x$n ${d.name}: valid, unique, at its tier, deterministic', () {
        final grades = <int, int>{};
        var worst = 0;
        for (var seed = 1; seed <= 4; seed++) {
          final params = GenParams(size: GridSize.square(n), difficulty: d, seed: seed);
          final sw = Stopwatch()..start();
          final p = generateStars(params);
          sw.stop();
          if (sw.elapsedMilliseconds > worst) worst = sw.elapsedMilliseconds;
          expect(p.solution.length, 2 * n);
          expect(starsConflicts(n, 2, p.regions, p.solution), isEmpty);
          expect(p.regions.toSet().length, n);
          for (var reg = 0; reg < n; reg++) {
            expect(p.solution.where((i) => p.regions[i] == reg).length, 2, reason: 'region $reg');
            expect(_connected(n, p.regions, reg), isTrue, reason: 'region $reg split');
          }
          final solver = StarsSolver(n, p.regions);
          final sols = solver.solutions();
          expect(sols.length, 1);
          expect(sols.single, p.solution);
          final g = solver.grade();
          grades[g] = (grades[g] ?? 0) + 1;
          expect(g, lessThanOrEqualTo(3), reason: 'needs guessing');
          expect(solver.solveLogic(g), p.solution);
          if (seed == 1) expect(generateStars(params).toJson(), p.toJson());
          expect(sw.elapsedMilliseconds, lessThan(timeLimit(6000)), reason: 'too slow (${sw.elapsedMilliseconds}ms)');
        }
        // ignore: avoid_print
        print('stars $n ${d.name}: grades $grades, worst ${worst}ms');
      });
    }
  }
}

bool _connected(int n, List<int> regions, int reg) {
  final cells = [
    for (var i = 0; i < n * n; i++)
      if (regions[i] == reg) i,
  ];
  final seen = {cells.first};
  final stack = [cells.first];
  while (stack.isNotEmpty) {
    final i = stack.removeLast();
    final r = i ~/ n, c = i % n;
    for (final j in [if (r > 0) i - n, if (r < n - 1) i + n, if (c > 0) i - 1, if (c < n - 1) i + 1]) {
      if (regions[j] == reg && seen.add(j)) stack.add(j);
    }
  }
  return seen.length == cells.length;
}
