import 'package:apuzzle/core/difficulty.dart';
import 'package:apuzzle/core/grid.dart';
import 'package:apuzzle/puzzles/lookout/lookout_generator.dart';
import 'package:apuzzle/puzzles/lookout/lookout_model.dart';
import 'package:apuzzle/puzzles/lookout/lookout_solver.dart';
import 'package:apuzzle/puzzles/lookout/lookout_tutorial.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/timing.dart';

void main() {
  test('a number sees along its row and column up to shaded cells', () {
    final p = lookoutBoard('2#.|.4.|#2#');
    expect(lookoutSeen(3, 4, (j) => !p.shaded[j]), 4);
    expect(lookoutSeen(3, 0, (j) => !p.shaded[j]), 2);
    expect(lookoutSeen(3, 4, (j) => true), 5);
  });

  test('conflicts: touching, too many or too few seen, cut-off cells', () {
    final p = lookoutBoard('2#.|.4.|#2#');
    expect(lookoutConflicts(p, p.shaded, complete: true), isEmpty);
    // Nothing shaded: every number sees too many.
    final none = List.filled(9, false);
    expect(lookoutConflicts(p, none, complete: false), containsAll([0, 4, 7]));
    // Before the board is complete only dotted cells count as staying.
    expect(lookoutConflicts(p, none, kept: List.filled(9, false), complete: false), isEmpty);
    // Two shaded side by side, and the corner 2 sees too few.
    final touch = List.of(p.shaded)..[2] = true;
    expect(lookoutConflicts(p, touch, complete: false), containsAll([1, 2]));
    // A shaded cell walls in the corner.
    final cut = lookoutBoard('5.3|4.#|.#.');
    expect(lookoutConflicts(cut, cut.shaded, complete: true), {8});
  });

  test('solver: views that must reach, views that must stop, every way to split a view', () {
    final p = lookoutBoard('#.2|.4#|.5.');
    final s = LookoutSolver(p);
    final st = s.start();
    expect(s.propagate(st, 1), isTrue);
    expect(st, [for (final x in p.shaded) x ? lookoutShade : lookoutKeep]);
    // The 2 can't stop its view on the 3: tier 1 gets stuck, tier 2 solves it.
    final ways = lookoutBoard('3#2|...|..#');
    final w = LookoutSolver(ways);
    expect(w.slack(1), greaterThan(0));
    final st2 = w.start();
    expect(w.propagate(st2, 2), isTrue);
    expect(st2, [for (final x in ways.shaded) x ? lookoutShade : lookoutKeep]);
  });

  for (final n in [5, 6, 7, 8, 9, 10]) {
    for (final d in [Difficulty.easy, Difficulty.medium, Difficulty.hard]) {
      test('lookout ${n}x$n ${d.name}: valid, unique, tiered, deterministic', () {
        final info = <String>[];
        final tier = lookoutTier(d);
        for (var seed = 1; seed <= 4; seed++) {
          final params = GenParams(size: GridSize.square(n), difficulty: d, seed: seed);
          final sw = Stopwatch()..start();
          final p = generateLookout(params);
          sw.stop();
          expect(lookoutConflicts(p, p.shaded, complete: true), isEmpty);
          final s = LookoutSolver(p);
          final grade = s.grade();
          expect(grade, tier);
          final st = s.start();
          expect(s.solve(st, tier), isTrue);
          expect([for (final x in st) x == lookoutShade], p.shaded);
          expect(s.countSolutions(), 1);
          if (seed == 1) expect(generateLookout(params).toJson(), p.toJson(), reason: 'not deterministic');
          expect(LookoutPuzzle.fromJson(p.toJson()).toJson(), p.toJson());
          expect(sw.elapsedMilliseconds, lessThan(timeLimit(2000)));
          info.add('${sw.elapsedMilliseconds}ms numbers ${p.clues.where((c) => c != null).length}');
        }
        // ignore: avoid_print
        print('lookout $n ${d.name}: $info');
      });
    }
  }

  test('strategy boards need their technique', () {
    for (final params in lookoutStrategyParams) {
      final p = generateLookout(params);
      final s = LookoutSolver(p);
      expect(s.grade(), lookoutTier(params.difficulty));
    }
  });
}
