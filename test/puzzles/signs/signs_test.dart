import 'package:apuzzle/core/difficulty.dart';
import 'package:apuzzle/core/grid.dart';
import 'package:apuzzle/core/latin_square.dart';
import 'package:apuzzle/puzzles/signs/signs_generator.dart';
import 'package:apuzzle/puzzles/signs/signs_model.dart';
import 'package:apuzzle/puzzles/signs/signs_solver.dart';
import 'package:apuzzle/puzzles/signs/signs_tutorial.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/timing.dart';

void main() {
  test('signs of a grid and conflicts', () {
    final g = [0, 1, 1, 0];
    expect(allSigns(2, g), [const Sign(0, 1), const Sign(0, 2), const Sign(3, 1), const Sign(3, 2)]);
    final p = SignsPuzzle(n: 2, signs: allSigns(2, g), givens: List.filled(4, null), solution: g);
    expect(signsConflicts(p, g), isEmpty);
    expect(signsConflicts(p, [1, 0, -1, -1]), {0, 1});
  });

  test('a cell smaller than both neighbours in a row needs two bigger numbers', () {
    // 4×4, row 0: a > b < c, everything else open.
    final s = SignsSolver(4, const [Sign(1, 0), Sign(1, 2)]);
    final c = s.start(List.filled(16, null));
    expect(s.propagate(c, 1), isTrue);
    expect(LatinSquare.digits(c[1]), [0, 1, 2]);
    expect(s.propagate(c, 2), isTrue);
    expect(LatinSquare.digits(c[1]), [0, 1]);
  });

  for (final n in [4, 5, 6, 7, 8, 9]) {
    for (final d in [Difficulty.easy, Difficulty.medium, Difficulty.hard]) {
      test('signs ${n}x$n ${d.name}: valid, unique, tiered, deterministic', () {
        final info = <String>[];
        for (var seed = 1; seed <= 4; seed++) {
          final params = GenParams(size: GridSize.square(n), difficulty: d, seed: seed);
          final sw = Stopwatch()..start();
          final p = generateSigns(params);
          sw.stop();
          expect(signsConflicts(p, p.solution), isEmpty);
          for (var i = 0; i < n * n; i++) {
            if (p.givens[i] != null) expect(p.givens[i], p.solution[i]);
          }
          for (final s in p.signs) {
            expect((s.lo - s.hi).abs() == 1 && s.lo ~/ n == s.hi ~/ n || (s.lo - s.hi).abs() == n, isTrue);
          }
          final s = SignsSolver(n, p.signs);
          expect(s.countSolutions(s.start(p.givens)), 1, reason: 'not unique');
          final tier = signsTier(d);
          final c = s.start(p.givens);
          expect(s.solve(c, tier), isTrue, reason: 'not solvable at tier $tier');
          expect(LatinSquare.of(n).values(c), p.solution);
          final below = tier > 1 && s.solve(s.start(p.givens), tier - 1);
          if (seed == 1) expect(generateSigns(params).toJson(), p.toJson(), reason: 'not deterministic');
          expect(sw.elapsedMilliseconds, lessThan(timeLimit(4000)), reason: 'too slow');
          final given = p.givens.where((g) => g != null).length;
          info.add('${sw.elapsedMilliseconds}ms s${p.signs.length} g$given${below ? ' easier' : ''}');
        }
        // ignore: avoid_print
        print('signs $n ${d.name}: $info');
      });
    }
  }

  test('strategy boards need the tier they teach', () {
    for (var k = 0; k < signsStrategyParams.length; k++) {
      final params = signsStrategyParams[k];
      final p = generateSigns(params);
      final s = SignsSolver(p.n, p.signs);
      final tier = signsTier(params.difficulty);
      expect(s.solve(s.start(p.givens), tier), isTrue, reason: 'lesson ${k + 1}');
      if (tier > 1) expect(s.solve(s.start(p.givens), tier - 1), isFalse, reason: 'lesson ${k + 1}');
    }
  });

  test('the third tutorial step needs runs of signs', () {
    final p = signsTutorial[2].puzzle as SignsPuzzle;
    final s = SignsSolver(p.n, p.signs);
    expect(s.solve(s.start(p.givens), 1), isFalse);
    expect(s.solve(s.start(p.givens), 2), isTrue);
  });
}
