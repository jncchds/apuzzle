import 'package:apuzzle/core/difficulty.dart';
import 'package:apuzzle/core/grid.dart';
import 'package:apuzzle/puzzles/sudoku/sudoku_generator.dart';
import 'package:apuzzle/puzzles/sudoku/sudoku_model.dart';
import 'package:apuzzle/puzzles/sudoku/sudoku_solver.dart';
import 'package:apuzzle/puzzles/sudoku/sudoku_tutorial.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/timing.dart';

void main() {
  for (final n in [4, 6, 9]) {
    for (final d in Difficulty.values) {
      test('sudoku ${n}x$n ${d.name}: valid, unique, tiered, deterministic', () {
        final seeds = n == 9 ? 4 : 6;
        for (var seed = 1; seed <= seeds; seed++) {
          final params = GenParams(size: GridSize.square(n), difficulty: d, seed: seed);
          final sw = Stopwatch()..start();
          final p = generateSudoku(params);
          sw.stop();
          expect(sudokuConflicts(n, p.solution), isEmpty);
          expect(p.solution.every((v) => v >= 0 && v < n), isTrue);
          final g = [for (final v in p.givens) v ?? -1];
          for (var i = 0; i < n * n; i++) {
            if (g[i] >= 0) expect(g[i], p.solution[i]);
          }
          final solver = SudokuSolver(n);
          expect(solver.countSolutions(g), 1, reason: 'not unique');
          final tier = sudokuTier(d);
          final lg = List.of(g);
          expect(solver.solveLogic(lg, tier), isTrue, reason: 'not solvable at tier $tier');
          expect(lg, p.solution);
          if (seed == 1) expect(generateSudoku(params).toJson(), p.toJson(), reason: 'not deterministic');
          expect(sw.elapsedMilliseconds, lessThan(timeLimit(8000)), reason: 'too slow');
        }
      });
    }
  }

  test('9x9 hard usually needs tier 2', () {
    var needs = 0;
    for (var seed = 1; seed <= 4; seed++) {
      final p = generateSudoku(GenParams(size: const GridSize.square(9), difficulty: Difficulty.hard, seed: seed));
      if (!SudokuSolver(9).solveLogic([for (final v in p.givens) v ?? -1], 1)) needs++;
    }
    expect(needs, greaterThanOrEqualTo(3));
  });

  test('9x9 expert usually needs tier 3', () {
    var needs = 0;
    for (var seed = 1; seed <= 4; seed++) {
      final p = generateSudoku(GenParams(size: const GridSize.square(9), difficulty: Difficulty.expert, seed: seed));
      if (!SudokuSolver(9).solveLogic([for (final v in p.givens) v ?? -1], 2)) needs++;
    }
    expect(needs, greaterThanOrEqualTo(3));
  });

  test('every rule is sound and finds something', () {
    // Each rule alone (on top of singles) on expert boards: never a wrong
    // digit, and every rule fires somewhere.
    final fired = <SudokuRule>{};
    for (var seed = 1; seed <= 12; seed++) {
      final p = generateSudoku(GenParams(size: const GridSize.square(9), difficulty: Difficulty.expert, seed: seed));
      final g0 = [for (final v in p.givens) v ?? -1];
      for (final rule in SudokuRule.values) {
        if (sudokuRuleTier(rule) < 2) continue;
        final solver = SudokuSolver(9, disabled: {...SudokuRule.values}..remove(rule));
        final g = List.of(g0);
        final cand = solver.candidates(g)!;
        expect(solver.propagate(g, cand, 1), isTrue);
        final before = List.of(cand);
        expect(solver.propagate(g, cand, 3), isTrue, reason: '$rule seed $seed');
        for (var i = 0; i < 81; i++) {
          if (g[i] >= 0) {
            expect(g[i], p.solution[i], reason: '$rule seed $seed');
          } else {
            expect(cand[i] & (1 << p.solution[i]), isNot(0), reason: '$rule seed $seed');
          }
        }
        if (g.where((v) => v < 0).length < before.where((m) => m != 0).length ||
            [for (var i = 0; i < 81; i++) g[i] < 0 && cand[i] != before[i]].contains(true)) {
          fired.add(rule);
        }
      }
    }
    expect(fired, {
      for (final r in SudokuRule.values)
        if (sudokuRuleTier(r) >= 2) r,
    });
  });

  test('strategy boards need their lesson', () {
    const fish = {SudokuRule.xWing, SudokuRule.swordfish, SudokuRule.xyWing, SudokuRule.xyzWing};
    const subsets = {SudokuRule.triple, SudokuRule.hiddenPair, SudokuRule.hiddenTriple};
    // (difficulty, rules the lesson may use are all but these, rules before it)
    final lessons = [
      (Difficulty.hard, {...fish, ...subsets}, {...SudokuRule.values}),
      (Difficulty.hard, {...fish, SudokuRule.triple, SudokuRule.hiddenTriple}, {...fish, ...subsets}),
      (Difficulty.expert, {SudokuRule.swordfish, SudokuRule.xyWing, SudokuRule.xyzWing}, fish),
      (Difficulty.expert, {SudokuRule.xWing, SudokuRule.swordfish, SudokuRule.xyzWing}, fish),
    ];
    for (var k = 0; k < lessons.length; k++) {
      final (d, off, below) = lessons[k];
      final p = generateSudoku(
        GenParams(size: const GridSize.square(9), difficulty: d, seed: sudokuLessonSeeds[k]),
      );
      final g = [for (final v in p.givens) v ?? -1];
      expect(SudokuSolver(9, disabled: off).solveLogic(List.of(g), 3), isTrue, reason: 'lesson ${k + 2} unsolved');
      expect(SudokuSolver(9, disabled: below).solveLogic(List.of(g), 3), isFalse, reason: 'lesson ${k + 2} too easy');
    }
  });
}
