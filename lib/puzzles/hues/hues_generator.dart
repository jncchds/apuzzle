import 'dart:math';

import '../../core/difficulty.dart';
import 'hues_model.dart';
import 'hues_solver.dart';

const int huesColorCount = 3;

/// Random coloring → start with every cell a clue → turn clues into empty
/// cells (recomputing numbers) while still solvable at the difficulty's tier.
HuesPuzzle generateHues(GenParams params) {
  final rows = params.size.rows, cols = params.size.cols, n = rows * cols;
  final rng = Random(params.seed);
  final d = params.difficulty;
  const k = huesColorCount;
  final tier = d.index >= Difficulty.hard.index ? 2 : 1;
  final maxEmpty = d == Difficulty.easy ? (n * 0.36).round() : n;
  final nb = huesNeighbors(rows, cols);
  HuesPuzzle? fallback;

  for (var attempt = 0; attempt < 8; attempt++) {
    // Clustered random coloring.
    final color = List.generate(n, (_) => rng.nextInt(k));
    for (var pass = 0; pass < 2; pass++) {
      for (final i in [for (var i = 0; i < n; i++) i]..shuffle(rng)) {
        if (rng.nextDouble() < 0.45) color[i] = color[nb[i][rng.nextInt(nb[i].length)]];
      }
    }

    final isClue = List<bool>.filled(n, true);
    var empties = 0;

    bool solvable(int t) {
      final nums = [for (var i = 0; i < n; i++) isClue[i] ? huesCount(nb, isClue, color, i) : null];
      final s = HuesSolver(rows: rows, cols: cols, colors: k, clueNum: nums, clueColor: color);
      return s.solveLogic(s.initialDomains(), t);
    }

    for (final i in [for (var i = 0; i < n; i++) i]..shuffle(rng)) {
      if (empties >= maxEmpty) break;
      isClue[i] = false;
      if (solvable(tier)) {
        empties++;
      } else {
        isClue[i] = true;
      }
    }

    final clues = [for (var i = 0; i < n; i++) isClue[i] ? huesCount(nb, isClue, color, i) : null];
    final puzzle = HuesPuzzle(rows: rows, cols: cols, colors: k, clues: clues, solution: color);
    if (empties == 0) continue;
    if (tier == 2 && solvable(1)) {
      fallback ??= puzzle;
      continue;
    }
    return puzzle;
  }
  return fallback ?? generateHues(params.withSeed(params.seed + 1));
}
