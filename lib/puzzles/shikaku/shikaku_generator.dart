import 'dart:math';

import '../../core/difficulty.dart';
import 'shikaku_model.dart';
import 'shikaku_solver.dart';

/// Random rectangle partition → one number per rectangle → move numbers
/// inside their rectangles until the solution is unique and graded.
ShikakuPuzzle generateShikaku(GenParams params) {
  final rows = params.size.rows, cols = params.size.cols;
  final rng = Random(params.seed);
  final d = params.difficulty;
  final maxArea = switch (d) {
    Difficulty.easy => 6,
    Difficulty.medium => 9,
    _ => 12,
  };
  final tier = d.index >= Difficulty.hard.index ? 2 : 1;
  ShikakuPuzzle? fallback;

  for (var attempt = 0; attempt < 60; attempt++) {
    final rects = _partition(rows, cols, maxArea, rng);
    final clueAt = [for (final r in rects) _randomCell(r, cols, rng)];

    for (var fix = 0; fix < 40; fix++) {
      final clues = List<int?>.filled(rows * cols, null);
      for (var k = 0; k < rects.length; k++) {
        clues[clueAt[k]] = rects[k].area;
      }
      final solver = ShikakuSolver(rows, cols, clues);
      final sols = solver.solutions();
      if (sols.length == 1) {
        final puzzle = ShikakuPuzzle(rows: rows, cols: cols, clues: clues, solution: rects);
        final byLogic = solver.solveLogic(tier) != null;
        final tooEasy = tier == 2 && solver.solveLogic(1) != null;
        if (byLogic && !tooEasy) return puzzle;
        if (byLogic) fallback ??= puzzle;
        break;
      }
      // Move the number of a rectangle that differs in the alternative.
      final alt = sols.firstWhere((s) => !s.toSet().containsAll(rects), orElse: () => sols.last);
      final differing = [
        for (var k = 0; k < rects.length; k++)
          if (!alt.contains(rects[k]) && rects[k].area > 1) k,
      ];
      if (differing.isEmpty) break;
      final k = differing[rng.nextInt(differing.length)];
      clueAt[k] = _randomCell(rects[k], cols, rng);
    }
  }
  return fallback ?? generateShikaku(params.withSeed(params.seed + 7919));
}

int _randomCell(CellRect r, int cols, Random rng) {
  final cells = r.cells(cols).toList();
  return cells[rng.nextInt(cells.length)];
}

List<CellRect> _partition(int rows, int cols, int maxArea, Random rng) {
  final used = List<bool>.filled(rows * cols, false);
  final rects = <CellRect>[];
  for (var i = 0; i < rows * cols; i++) {
    if (used[i]) continue;
    final r = i ~/ cols, c = i % cols;
    final shapes = <(int, int)>[];
    for (var h = 1; h <= rows - r; h++) {
      for (var w = 1; w <= cols - c; w++) {
        final a = h * w;
        if (a > maxArea || a < 2) continue;
        var free = true;
        for (var rr = r; rr < r + h && free; rr++) {
          for (var cc = c; cc < c + w && free; cc++) {
            if (used[rr * cols + cc]) free = false;
          }
        }
        if (free) shapes.add((h, w));
      }
    }
    // Weight towards mid-sized areas; very long thin strips are rarer.
    var (h, w) = (1, 1);
    if (shapes.isNotEmpty) {
      final weights = [
        for (final (sh, sw) in shapes) (sh * sw).toDouble() * (sh == 1 || sw == 1 ? 0.6 : 1.0),
      ];
      var t = rng.nextDouble() * weights.fold(0.0, (a, b) => a + b);
      for (var k = 0; k < shapes.length; k++) {
        t -= weights[k];
        if (t <= 0) {
          (h, w) = shapes[k];
          break;
        }
      }
      if (t > 0) (h, w) = shapes.last;
    }
    final rect = CellRect(r, c, r + h - 1, c + w - 1);
    for (final j in rect.cells(cols)) {
      used[j] = true;
    }
    rects.add(rect);
  }
  return rects;
}
