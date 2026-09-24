import 'dart:math';

import '../../core/difficulty.dart';
import 'shikaku_model.dart';
import 'shikaku_solver.dart';

/// Random rectangle partition with one number per rectangle, then a local
/// search that moves numbers inside their rectangles:
///  1. until logic at the difficulty's tier solves the puzzle (the solver is
///     sound, so that also proves uniqueness);
///  2. for hard, further moves that keep it solvable at tier 2 until tier 1
///     alone gets stuck.
/// A new partition is drawn only if the search runs out of budget.
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
  final budget = rows * cols * 4;
  ShikakuPuzzle? fallback;

  for (var attempt = 0; attempt < 20; attempt++) {
    final rects = _partition(rows, cols, maxArea, rng);
    final clueAt = [for (final r in rects) _randomCell(r, cols, rng)];
    final movable = [for (var k = 0; k < rects.length; k++) if (rects[k].area > 1) k];
    if (movable.isEmpty) continue;

    ShikakuSolver solver() {
      final clues = List<int?>.filled(rows * cols, null);
      for (var k = 0; k < rects.length; k++) {
        clues[clueAt[k]] = rects[k].area;
      }
      return ShikakuSolver(rows, cols, clues);
    }

    /// Moves a random number within its rectangle; returns the undo.
    void Function() move() {
      final k = movable[rng.nextInt(movable.length)];
      final old = clueAt[k];
      clueAt[k] = _randomCell(rects[k], cols, rng);
      return () => clueAt[k] = old;
    }

    // 1. Solvable at the tier.
    var cost = solver().slack(tier);
    for (var it = 0; it < budget && cost > 0; it++) {
      final undo = move();
      final c = solver().slack(tier);
      if (c <= cost) {
        cost = c;
      } else {
        undo();
      }
    }
    if (cost > 0) continue;

    // 2. Hard: tier 1 alone must get stuck.
    if (tier == 2) {
      var easy = solver().slack(1);
      for (var it = 0; it < budget && easy == 0; it++) {
        final undo = move();
        final s = solver();
        final e = s.slack(1);
        if (e >= easy && s.slack(2) == 0) {
          easy = e;
        } else {
          undo();
        }
      }
      if (easy == 0) {
        fallback ??= ShikakuPuzzle(rows: rows, cols: cols, clues: solver().clues, solution: rects);
        continue;
      }
    }
    return ShikakuPuzzle(rows: rows, cols: cols, clues: solver().clues, solution: rects);
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
