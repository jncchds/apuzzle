import 'package:apuzzle/core/difficulty.dart';
import 'package:apuzzle/core/grid.dart';
import 'package:apuzzle/puzzles/poles/poles_generator.dart';
import 'package:apuzzle/puzzles/poles/poles_model.dart';
import 'package:apuzzle/puzzles/poles/poles_solver.dart';
import 'package:apuzzle/puzzles/poles/poles_tutorial.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/timing.dart';

bool _solves(PolesPuzzle p, int tier, [Set<PolesRule> off = const {}]) {
  final s = PolesSolver.of(p, disabled: off);
  return s.solve(polesStart(s, p), tier);
}

void main() {
  // Dominoes: A1–A2, B1–C1, B2–C2.
  final p = polesBoard('abb|acc', '+-+|-+-');
  // Values, with a space for an empty cell.
  List<int> board(String s) => [for (final ch in s.replaceAll('|', '').split('')) '+-.'.indexOf(ch)];

  test('boards from strings: dominoes and counts', () {
    expect(p.mate, [3, 2, 1, 0, 5, 4]);
    expect(p.plus, [2, 1, 1, 1, 1]);
    expect(p.minus, [1, 2, 1, 1, 1]);
    expect(p.charged, 6);
  });

  test('json round trip', () {
    final q = PolesPuzzle.fromJson(p.toJson());
    expect(q.mate, p.mate);
    expect(q.solution, p.solution);
    expect(q.plus, p.plus);
    expect(q.minus, p.minus);
  });

  test('conflicts: like ends, dominoes and counts', () {
    expect(polesConflicts(p, board('+-+|-+-'), complete: true), isEmpty);
    // Two − side by side in different dominoes.
    expect(polesConflicts(p, board(' - | - '), complete: false), {1, 4});
    // A domino with + at both ends.
    expect(polesConflicts(p, board('+  |+  '), complete: false), {0, 3});
    // A charged end across from a blank.
    expect(polesConflicts(p, board(' +.|   '), complete: false), {1, 2});
    // Too many + in a row (it needs 1 in row 2).
    expect(polesConflicts(p, board('   |+ +'), complete: false), containsAll([3, 5]));
    // Not complete: an open domino isn't flagged; complete: it is.
    expect(polesConflicts(p, board('+  |   '), complete: false), isEmpty);
    expect(polesConflicts(p, board('+  |   '), complete: true), contains(0));
  });

  test('tutorial boards need their rule', () {
    const blanks = {PolesRule.chargedDone, PolesRule.chargedNeed};
    for (final step in polesTutorial.take(3)) {
      final q = step.puzzle as PolesPuzzle;
      final s = PolesSolver.of(q);
      expect(s.countSolutions(polesStart(s, q)), 1);
      expect(_solves(q, 1), isTrue);
    }
    final [one, two, three, ...] = [for (final s in polesTutorial) s.puzzle as PolesPuzzle];
    expect(_solves(one, 1, {PolesRule.repel, ...blanks}), isTrue, reason: 'counts and dominoes alone');
    expect(_solves(two, 1, {PolesRule.repel}), isFalse, reason: 'like ends never touch');
    expect(_solves(three, 1, blanks), isFalse, reason: 'charged cells per line');
    final s1 = polesStrategies.first.puzzle as PolesPuzzle;
    expect(_solves(s1, 1), isFalse);
    expect(_solves(s1, 2), isTrue);
    final s2 = generatePoles(polesStrategyParams);
    final s = PolesSolver.of(s2);
    expect(s.grade(polesStart(s, s2)), 3);
  });

  for (final size in const [
    GridSize.square(6),
    GridSize(7, 6),
    GridSize.square(8),
    GridSize(9, 8),
    GridSize.square(10),
  ]) {
    for (final d in [Difficulty.easy, Difficulty.medium, Difficulty.hard]) {
      test('poles ${size.label} ${d.name}: valid, unique, tiered, deterministic', () {
        final tier = polesTier(d);
        for (var seed = 1; seed <= 3; seed++) {
          final params = GenParams(size: size, difficulty: d, seed: seed);
          final sw = Stopwatch()..start();
          final q = generatePoles(params);
          sw.stop();
          expect(sw.elapsedMilliseconds, lessThan(timeLimit(4000)));
          expect(q.rows * q.cols, size.cellCount);
          for (var i = 0; i < q.mate.length; i++) {
            expect(q.mate[q.mate[i]], i);
          }
          expect(polesConflicts(q, q.solution, complete: true), isEmpty);
          final s = PolesSolver.of(q);
          expect(s.countSolutions(polesStart(s, q)), 1);
          expect(s.grade(polesStart(s, q)), tier);
          expect(generatePoles(params).toJson(), q.toJson());
        }
      });
    }
  }
}
