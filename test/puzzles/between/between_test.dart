import 'package:apuzzle/core/difficulty.dart';
import 'package:apuzzle/core/grid.dart';
import 'package:apuzzle/puzzles/between/between_generator.dart';
import 'package:apuzzle/puzzles/between/between_model.dart';
import 'package:apuzzle/puzzles/between/between_solver.dart';
import 'package:apuzzle/puzzles/between/between_tutorial.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/timing.dart';

void main() {
  test('rules: two shaded cells, each number once, the sums between', () {
    final p = betweenBoard(['#12#3', '1#32#', '#2#31', '3#1#2', '23#1#'], 'xxxxxxxxxx');
    expect(p.clues, [3, 5, 2, 1, 1, 1, 2, 1, 5, 3]);
    expect(betweenConflicts(p, p.solution), isEmpty);
    // A number twice in a row.
    final twice = List.of(p.solution)..[1] = 2;
    expect(betweenConflicts(p, twice), containsAll([1, 2]));
    // A third shaded cell.
    final third = List.of(p.solution)..[4] = betweenShade;
    expect(betweenConflicts(p, third), containsAll([0, 3, 4]));
    // The wrong sum once the cells between are filled; nothing while open.
    final swapped = List.of(p.solution)
      ..[2] = 3
      ..[4] = 2;
    expect(betweenConflicts(p, swapped), containsAll([0, 1, 2, 3]));
    final open = List.of(p.solution)..[2] = -1;
    expect(betweenConflicts(p, open), isEmpty);
    expect(betweenSum([0, 0, 1, 2, 3]), 0);
    expect(betweenSum([0, 1, 2, 3, 0]), 6);
  });

  test('digit sets: every way to make a sum with some different numbers', () {
    int set(List<int> ds) => ds.fold(0, (m, d) => m | 1 << d);
    final c = BetweenCombos.of(5); // 1..5, a 7×7 board
    expect(c.list(2, 9), [
      set([4, 5]),
    ]);
    expect(c.list(3, 9).toSet(), {
      set([1, 3, 5]),
      set([2, 3, 4]),
    });
    expect(c.list(0, 0), [0]);
    expect(c.list(5, 15), [
      set([1, 2, 3, 4, 5]),
    ]);
    expect(c.list(1, 6), isEmpty);
    expect(c.gaps(5), 1 << 1 | 1 << 2);
  });

  test('tutorial boards need the rule they teach', () {
    final steps = [for (final s in betweenTutorial.take(3)) s.puzzle as BetweenPuzzle];
    for (final p in steps) {
      final s = BetweenSolver(p.n, p.clues);
      expect(s.grade(p.givens), 1);
      final c = s.start(p.givens);
      expect(s.solve(c, 1), isTrue);
      expect(s.values(c), p.solution);
      expect(s.countSolutions(s.start(p.givens)), 1);
    }
    bool solves(BetweenPuzzle p, Set<BetweenRule> off) {
      final s = BetweenSolver(p.n, p.clues, disabled: off);
      return s.solve(s.start(p.givens), 1);
    }

    expect(solves(steps[1], {BetweenRule.span}), isFalse);
    expect(solves(steps[2], {BetweenRule.sumOut, BetweenRule.sumIn}), isFalse);
    for (final (k, params) in betweenStrategyParams.indexed) {
      final p = generateBetween(params);
      expect(BetweenSolver(p.n, p.clues).grade(p.givens), k + 2);
    }
  });

  for (final n in [5, 6, 7, 8, 9]) {
    for (final d in [Difficulty.easy, Difficulty.medium, Difficulty.hard]) {
      test('between ${n}x$n ${d.name}: valid, unique, tiered, deterministic', () {
        final info = <String>[];
        final tier = betweenTier(d);
        for (var seed = 1; seed <= 4; seed++) {
          final params = GenParams(size: GridSize.square(n), difficulty: d, seed: seed);
          final sw = Stopwatch()..start();
          final p = generateBetween(params);
          sw.stop();
          expect(betweenConflicts(p, p.solution), isEmpty);
          expect(betweenClues(n, p.solution).length, 2 * n);
          final s = BetweenSolver(n, p.clues);
          expect(s.grade(p.givens), tier);
          final c = s.start(p.givens);
          expect(s.solve(c, tier), isTrue);
          expect(s.values(c), p.solution);
          expect(s.countSolutions(s.start(p.givens)), 1);
          if (seed == 1) expect(generateBetween(params).toJson(), p.toJson(), reason: 'not deterministic');
          expect(BetweenPuzzle.fromJson(p.toJson()).toJson(), p.toJson());
          expect(sw.elapsedMilliseconds, lessThan(timeLimit(4000)));
          info.add(
            '${sw.elapsedMilliseconds}ms givens ${p.givens.where((g) => g != null).length} '
            'clues ${p.clues.where((c) => c != null).length}',
          );
        }
        // ignore: avoid_print
        print('between $n ${d.name}: $info');
      }, timeout: const Timeout(Duration(minutes: 3)));
    }
  }
}
