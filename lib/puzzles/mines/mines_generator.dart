import 'dart:math';

import '../../core/difficulty.dart';
import '../../core/grid_graph.dart';
import 'mines_model.dart';
import 'mines_solver.dart';

int minesTier(Difficulty d) => switch (d) {
      Difficulty.easy => 1,
      Difficulty.medium => 2,
      _ => 3,
    };

/// Random mines around a safe start → play it with the difficulty's logic →
/// wherever that gets stuck, open one more safe cell at the start. Of a few
/// layouts, keeps the one that gives away the least (extra cells weigh most).
MinesPuzzle generateMines(GenParams params) {
  final rows = params.size.rows, cols = params.size.cols, n = rows * cols;
  final rng = Random(params.seed);
  final d = params.difficulty;
  final tier = minesTier(d);
  final share = switch (d) {
    Difficulty.easy => 0.13,
    Difficulty.medium => 0.16,
    _ => 0.19,
  };
  final kn = kingNeighbors(rows, cols);
  MinesPuzzle? best;
  var bestScore = 1 << 30;
  final extraWeight = max(4, n ~/ 8);

  for (var attempt = 0; attempt < 6; attempt++) {
    final start = (rows ~/ 4 + rng.nextInt((rows + 1) ~/ 2)) * cols + cols ~/ 4 + rng.nextInt((cols + 1) ~/ 2);
    final safe = {start, ...kn[start]};
    final mines = List<bool>.filled(n, false);
    final spots = [for (var i = 0; i < n; i++) if (!safe.contains(i)) i]..shuffle(rng);
    for (final i in spots.take((n * share).round())) {
      mines[i] = true;
    }
    final p0 = MinesPuzzle(rows: rows, cols: cols, mines: mines, opened: List.filled(n, false));
    final counts = mineCounts(p0);
    final solver = MinesSolver(rows, cols, counts, p0.mineCount);

    final open = List<bool>.filled(n, false);
    final seeds = [start];
    openCells(open, seeds, mines, counts, kn);
    final k = solver.knowledge(open);
    var extra = 0;
    while (!minesCleared(p0, open) && extra * extraWeight < bestScore) {
      solver.deduce(open, k, tier);
      final fresh = [for (var i = 0; i < n; i++) if (k[i] == 0 && !open[i]) i];
      if (fresh.isEmpty) {
        // Stuck: open a safe cell next to the known area (or anywhere).
        final edge = [for (var i = 0; i < n; i++) if (!open[i] && !mines[i] && kn[i].any((j) => open[j])) i];
        final pool = edge.isNotEmpty ? edge : [for (var i = 0; i < n; i++) if (!open[i] && !mines[i]) i];
        final g = pool[rng.nextInt(pool.length)];
        seeds.add(g);
        fresh.add(g);
        extra++;
      }
      openCells(open, fresh, mines, counts, kn);
      for (var i = 0; i < n; i++) {
        if (open[i]) k[i] = 0;
      }
    }
    if (!minesCleared(p0, open)) continue;
    final opened = List<bool>.filled(n, false);
    openCells(opened, seeds, mines, counts, kn);
    final score = extra * extraWeight + opened.where((o) => o).length;
    if (score < bestScore) {
      best = MinesPuzzle(rows: rows, cols: cols, mines: mines, opened: opened);
      bestScore = score;
    }
  }
  return best!;
}
