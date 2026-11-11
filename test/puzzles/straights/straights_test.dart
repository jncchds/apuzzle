import 'package:apuzzle/core/difficulty.dart';
import 'package:apuzzle/core/grid.dart';
import 'package:apuzzle/puzzles/straights/straights_generator.dart';
import 'package:apuzzle/puzzles/straights/straights_model.dart';
import 'package:apuzzle/puzzles/straights/straights_solver.dart';
import 'package:apuzzle/puzzles/straights/straights_tutorial.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/timing.dart';

void main() {
  test('rules: numbers once per line, runs of consecutive numbers', () {
    final p = straightsBoard(straightsTutorialBoards[1]);
    expect(p.runs.length, 8);
    expect(straightsConflicts(p, p.solution), isEmpty);
    // The wall's 4 again in its row.
    final again = List.of(p.solution)..[1] = 3;
    expect(straightsConflicts(p, again), contains(1));
    // A full run that isn't consecutive (1, 2, 4 in the top row's run).
    final gap = List.of(p.solution)
      ..[3] = 3
      ..[7] = 2;
    expect(straightsConflicts(p, gap), containsAll([1, 2, 3]));
    // Numbers already too far apart for their run, with cells still open.
    final apart = List.filled(16, -1)
      ..[0] = straightsBlock
      ..[1] = 0
      ..[3] = 3;
    expect(straightsConflicts(p, apart), containsAll([1, 2, 3]));
    final open = List.of(p.solution)..[2] = -1;
    expect(straightsConflicts(p, open), isEmpty);
    expect(straightsIsStraight([3, 1, 2]), isTrue);
    expect(straightsIsStraight([3, 1, 4]), isFalse);
    expect(straightsIsStraight([2, 2]), isFalse);
  });

  test('tutorial boards need the rule they teach', () {
    final steps = [for (final rows in straightsTutorialBoards) straightsBoard(rows)];
    for (final p in steps) {
      final s = StraightsSolver(p);
      expect(straightsConflicts(p, p.solution), isEmpty);
      expect(s.grade(p.givens), 1);
      final c = s.start(p.givens);
      expect(s.solve(c, 1), isTrue);
      expect(s.values(c), p.solution);
      expect(s.countSolutions(s.start(p.givens)), 1);
    }
    // Without the wall's number the second board has more than one solution.
    final p = steps[1];
    final bare = StraightsPuzzle(
      n: p.n,
      dark: p.dark,
      clues: List.filled(p.n * p.n, null),
      givens: p.givens,
      solution: p.solution,
    );
    expect(StraightsSolver(bare).countSolutions(StraightsSolver(bare).start(bare.givens)), 2);
    // The third needs the numbers every stretch of a run uses.
    final off = StraightsSolver(steps[2], disabled: {StraightsRule.sure, StraightsRule.hidden});
    expect(off.solve(off.start(steps[2].givens), 1), isFalse);
    for (final (k, params) in straightsStrategyParams.indexed) {
      final q = generateStraights(params);
      expect(StraightsSolver(q).grade(q.givens), k + 2);
    }
  });

  for (final n in [5, 6, 7, 8, 9]) {
    for (final d in [Difficulty.easy, Difficulty.medium, Difficulty.hard]) {
      test('straights ${n}x$n ${d.name}: valid, unique, tiered, deterministic', () {
        final info = <String>[];
        final tier = straightsTier(d);
        for (var seed = 1; seed <= 4; seed++) {
          final params = GenParams(size: GridSize.square(n), difficulty: d, seed: seed);
          final sw = Stopwatch()..start();
          final p = generateStraights(params);
          sw.stop();
          expect(straightsConflicts(p, p.solution), isEmpty);
          for (final run in p.runs) {
            expect(straightsIsStraight([for (final i in run.cells) p.solution[i]]), isTrue);
          }
          final s = StraightsSolver(p);
          expect(s.grade(p.givens), tier);
          final c = s.start(p.givens);
          expect(s.solve(c, tier), isTrue);
          expect(s.values(c), p.solution);
          expect(s.countSolutions(s.start(p.givens)), 1);
          if (seed == 1) expect(generateStraights(params).toJson(), p.toJson(), reason: 'not deterministic');
          expect(StraightsPuzzle.fromJson(p.toJson()).toJson(), p.toJson());
          expect(sw.elapsedMilliseconds, lessThan(timeLimit(4000)));
          info.add(
            '${sw.elapsedMilliseconds}ms givens ${p.givens.where((g) => g != null).length} '
            'dark ${p.dark.where((x) => x).length} numbers ${p.clues.where((c) => c != null).length}',
          );
        }
        // ignore: avoid_print
        print('straights $n ${d.name}: $info');
      }, timeout: const Timeout(Duration(minutes: 3)));
    }
  }
}
