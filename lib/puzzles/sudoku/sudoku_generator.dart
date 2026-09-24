import 'dart:math';

import '../../core/difficulty.dart';
import 'sudoku_model.dart';
import 'sudoku_solver.dart';

/// Random full grid → remove symmetric pairs of givens while the puzzle stays
/// solvable with the logic tier of the difficulty (or merely unique for expert).
SudokuPuzzle generateSudoku(GenParams params) {
  final n = params.size.rows;
  final rng = Random(params.seed);
  final d = params.difficulty;
  final solver = SudokuSolver(n);
  final cells = n * n;
  SudokuPuzzle? fallback;

  bool ok(List<int> g) => switch (d) {
        Difficulty.easy || Difficulty.medium => solver.solveLogic(List.of(g), 1),
        Difficulty.hard => solver.solveLogic(List.of(g), 2),
        Difficulty.expert => solver.countSolutions(g) == 1,
      };

  final keep = d == Difficulty.easy ? (cells * 0.47).round() : 0;
  final attempts = n <= 4 ? 3 : 12;

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
    final needsMore = switch (d) {
      Difficulty.hard => n >= 6 && solver.solveLogic(List.of(g), 1),
      Difficulty.expert => n >= 9 && solver.solveLogic(List.of(g), 2),
      _ => false,
    };
    if (!needsMore) return puzzle;
    fallback ??= puzzle;
  }
  return fallback!;
}
