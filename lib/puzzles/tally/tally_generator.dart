import 'dart:math';

import '../../core/difficulty.dart';
import 'tally_model.dart';
import 'tally_solver.dart';

/// Random digits and a random keep/cross pattern, then a local search: where
/// the difficulty's tier gets stuck, an open cell gets a new digit or
/// changes sides, kept when the logic gets no further behind. Medium and
/// hard then push away from the tier below the same way. Cells still open
/// at the end are shown from the start.
TallyPuzzle generateTally(GenParams params) {
  final rows = params.size.rows, cols = params.size.cols, n = rows * cols;
  final rng = Random(params.seed);
  final tier = switch (params.difficulty) {
    Difficulty.easy => 1,
    Difficulty.medium => 2,
    _ => 3,
  };
  // The hardest board so far, when none needs the whole tier (small boards).
  TallyPuzzle? fallback;
  var fallbackGrade = 0;

  for (var attempt = 0; attempt < 24; attempt++) {
    final digits = [for (var i = 0; i < n; i++) 1 + rng.nextInt(9)];
    final keepShare = 0.5 + rng.nextDouble() * 0.12;
    final kept = [for (var i = 0; i < n; i++) rng.nextDouble() < keepShare];
    // Every line keeps a digit (a sum of 0 is no puzzle).
    int keptInRow(int i) => [for (var c = 0; c < cols; c++) kept[i ~/ cols * cols + c]].where((k) => k).length;
    int keptInCol(int i) => [for (var r = 0; r < rows; r++) kept[r * cols + i % cols]].where((k) => k).length;
    bool lonely(int i) => keptInRow(i) == 1 || keptInCol(i) == 1;
    for (var i = 0; i < n; i++) {
      if (keptInRow(i) == 0 || keptInCol(i) == 0) kept[i] = true;
    }
    TallyPuzzle board() => TallyPuzzle(rows: rows, cols: cols, digits: List.of(digits), kept: List.of(kept));
    List<int> stuck(int t) {
      final s = TallySolver.of(board());
      final st = s.start();
      s.solve(st, t);
      return [
        for (var i = 0; i < n; i++)
          if (st[i] == -1) i,
      ];
    }

    // Changes cell [i] (a new digit or the other side); returns the undo.
    void Function() mutate(int i) {
      final d = digits[i], k = kept[i];
      if (rng.nextInt(3) == 0 && !(k && lonely(i))) {
        kept[i] = !k;
      } else {
        digits[i] = 1 + (d + rng.nextInt(8)) % 9;
      }
      return () {
        digits[i] = d;
        kept[i] = k;
      };
    }

    var open = stuck(tier);
    for (var step = 0; step < n * 4 && open.isNotEmpty; step++) {
      final undo = mutate(open[rng.nextInt(open.length)]);
      final next = stuck(tier);
      if (next.length <= open.length) {
        open = next;
      } else {
        undo();
      }
    }
    if (open.isNotEmpty && attempt < 4) continue;

    // Harder: make the tier below get stuck, keeping the tier itself happy.
    if (tier > 1 && open.isEmpty) {
      var below = stuck(tier - 1).length;
      for (var step = 0; step < n * 2 && below < max(3, n ~/ 6); step++) {
        final undo = mutate(rng.nextInt(n));
        final b = stuck(tier - 1).length;
        if (b >= below && stuck(tier).isEmpty) {
          below = b;
        } else {
          undo();
        }
      }
    }

    final givens = <int>[];
    while (true) {
      final s = TallySolver.of(board());
      final st = s.start(givens: givens, kept: kept);
      s.solve(st, tier);
      final left = [
        for (var i = 0; i < n; i++)
          if (st[i] == -1) i,
      ];
      if (left.isEmpty) break;
      givens.add(left[rng.nextInt(left.length)]);
    }
    final puzzle = TallyPuzzle(rows: rows, cols: cols, digits: digits, kept: kept, givens: givens..sort());
    if (tier > 1) {
      final s = TallySolver.of(puzzle);
      final grade = s.grade(s.start(givens: puzzle.givens, kept: kept));
      if (grade < tier) {
        if (grade > fallbackGrade) (fallback, fallbackGrade) = (puzzle, grade);
        continue;
      }
    }
    return puzzle;
  }
  return fallback ?? generateTally(params.withSeed(params.seed + 1));
}
