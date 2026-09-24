import 'package:apuzzle/core/difficulty.dart';
import 'package:apuzzle/core/grid.dart';
import 'package:apuzzle/puzzles/sudoku/sudoku_generator.dart';
import 'package:apuzzle/puzzles/sudoku/sudoku_model.dart';
import 'package:apuzzle/puzzles/sudoku/sudoku_solver.dart';
import 'package:flutter_test/flutter_test.dart';

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
          if (d != Difficulty.expert) {
            final tier = d == Difficulty.hard ? 2 : 1;
            final lg = List.of(g);
            expect(solver.solveLogic(lg, tier), isTrue, reason: 'not solvable at tier $tier');
            expect(lg, p.solution);
          }
          expect(generateSudoku(params).toJson(), p.toJson(), reason: 'not deterministic');
          expect(sw.elapsedMilliseconds, lessThan(8000), reason: 'too slow');
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
}
