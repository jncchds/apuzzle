import 'dart:math';

import 'package:apuzzle/core/difficulty.dart';
import 'package:apuzzle/core/grid.dart';
import 'package:apuzzle/core/latin_square.dart';
import 'package:apuzzle/puzzles/skyline/skyline_generator.dart';
import 'package:apuzzle/puzzles/skyline/skyline_model.dart';
import 'package:apuzzle/puzzles/skyline/skyline_solver.dart';
import 'package:apuzzle/puzzles/skyline/skyline_tutorial.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/timing.dart';

void main() {
  test('latin rule ids leave room after the shared rules', () {
    expect(latinRuleCount, LatinRule.values.length);
  });

  test('visible towers', () {
    expect(skylineVisible([0, 1, 2, 3]), 4);
    expect(skylineVisible([3, 0, 1, 2]), 1);
    expect(skylineVisible([1, 0, 3, 2]), 2);
  });

  test('random latin squares are latin and deterministic', () {
    for (final n in [4, 6, 8]) {
      final sq = LatinSquare.of(n);
      final g = sq.random(Random(n));
      for (final line in sq.lines) {
        expect({for (final i in line) g[i]}.length, n);
      }
      expect(sq.random(Random(n)), g);
    }
  });

  for (final n in [4, 5, 6, 7]) {
    for (final d in [Difficulty.easy, Difficulty.medium, Difficulty.hard]) {
      test('skyline ${n}x$n ${d.name}: valid, unique, tiered, deterministic', () {
        final info = <String>[];
        for (var seed = 1; seed <= 4; seed++) {
          final params = GenParams(size: GridSize.square(n), difficulty: d, seed: seed);
          final sw = Stopwatch()..start();
          final p = generateSkyline(params);
          sw.stop();
          expect(skylineConflicts(p, p.solution), isEmpty);
          for (var i = 0; i < n * n; i++) {
            if (p.givens[i] != null) expect(p.givens[i], p.solution[i]);
          }
          final s = SkylineSolver(n, p.clues);
          expect(s.countSolutions(s.start(p.givens)), 1, reason: 'not unique');
          final tier = skylineTier(d);
          final c = s.start(p.givens);
          expect(s.solve(c, tier), isTrue, reason: 'not solvable at tier $tier');
          expect(LatinSquare.of(n).values(c), p.solution);
          final below = tier > 1 && s.solve(s.start(p.givens), tier - 1);
          if (seed == 1) expect(generateSkyline(params).toJson(), p.toJson(), reason: 'not deterministic');
          expect(sw.elapsedMilliseconds, lessThan(timeLimit(4000)), reason: 'too slow');
          final clues = p.clues.where((c) => c != null).length;
          final givens = p.givens.where((g) => g != null).length;
          info.add('${sw.elapsedMilliseconds}ms c$clues g$givens${below ? ' easier' : ''}');
        }
        // ignore: avoid_print
        print('skyline $n ${d.name}: $info');
      });
    }
  }

  test('strategy boards need the tier they teach', () {
    for (var k = 0; k < skylineStrategyParams.length; k++) {
      final params = skylineStrategyParams[k];
      final p = generateSkyline(params);
      final s = SkylineSolver(p.n, p.clues);
      final tier = skylineTier(params.difficulty);
      expect(s.solve(s.start(p.givens), tier), isTrue, reason: 'lesson ${k + 1}');
      if (tier > 1) expect(s.solve(s.start(p.givens), tier - 1), isFalse, reason: 'lesson ${k + 1}');
    }
  });
}
