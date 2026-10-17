import 'dart:math';

import '../../core/difficulty.dart';
import 'sudoku_model.dart';
import 'sudoku_solver.dart';

/// The logic tier each difficulty is solvable at (see [SudokuSolver]).
int sudokuTier(Difficulty d) => switch (d) {
  Difficulty.easy || Difficulty.medium => 1,
  Difficulty.hard => 2,
  Difficulty.expert => 3,
};

/// Random full grid → remove symmetric pairs of givens while the puzzle stays
/// solvable with the logic tier of the difficulty; hard and expert keep the
/// first board that needs its tier.
///
/// Version 1 (until 2026-10-17): tier 2 had no triples or hidden subsets,
/// expert boards only had to be unique, and there were 12 tries.
SudokuPuzzle generateSudoku(GenParams params) {
  final n = params.size.rows;
  final rng = Random(params.seed);
  final d = params.difficulty;
  final v1 = (params.version ?? 2) == 1;
  final solver = SudokuSolver(
    n,
    disabled: v1 ? const {SudokuRule.triple, SudokuRule.hiddenPair, SudokuRule.hiddenTriple} : const {},
  );
  final cells = n * n;
  SudokuPuzzle? fallback;

  final tier = sudokuTier(d);
  bool ok(List<int> g) =>
      v1 && d == Difficulty.expert ? solver.countSolutions(g) == 1 : solver.solveLogic(List.of(g), tier);

  final keep = d == Difficulty.easy ? (cells * 0.47).round() : 0;
  // A board that needs its tier comes about one try in 10–20 (9×9 expert).
  final attempts = n <= 4 ? 3 : (tier >= 2 && !v1 ? 80 : 12);

  for (var attempt = 0; attempt < attempts; attempt++) {
    final solution = solver.randomSolution(rng);
    final g = List.of(solution);
    var count = cells;

    final order = [for (var i = 0; i < (cells + 1) ~/ 2; i++) i]..shuffle(rng);
    for (final i in order) {
      if (count <= keep) break;
      final j = cells - 1 - i;
      final vi = g[i], vj = g[j];
      g[i] = -1;
      g[j] = -1;
      if (ok(g)) {
        count -= i == j ? 1 : 2;
      } else {
        g[i] = vi;
        g[j] = vj;
      }
    }

    final puzzle = SudokuPuzzle(n: n, givens: [for (final v in g) v < 0 ? null : v], solution: solution);
    // Hard/expert should actually need their tier.
    final needsMore = tier >= 2 && n >= (v1 && tier == 3 ? 9 : 6) && solver.solveLogic(List.of(g), tier - 1);
    if (!needsMore) return puzzle;
    fallback ??= puzzle;
  }
  return fallback!;
}
