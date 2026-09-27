import 'dart:math';

import '../../core/difficulty.dart';
import '../../core/grid_graph.dart';
import 'plots_model.dart';
import 'plots_solver.dart';

/// Random plots (no two of the same size side by side) → every cell given →
/// drop givens while logic at the difficulty's tier still solves the board.
PlotsPuzzle generatePlots(GenParams params) {
  final rows = params.size.rows, cols = params.size.cols, n = rows * cols;
  final rng = Random(params.seed);
  final d = params.difficulty;
  final tier = d == Difficulty.hard ? 2 : 1;
  final maxValue = switch (d) {
    Difficulty.easy => 5,
    Difficulty.medium => 6,
    _ => 7,
  };
  final weights = switch (d) {
    Difficulty.easy => const [0.3, 1.0, 1.2, 1.2, 1.0],
    Difficulty.medium => const [0.3, 0.8, 1.0, 1.2, 1.2, 0.8],
    _ => const [0.2, 0.6, 0.8, 1.0, 1.2, 1.0, 0.8],
  };
  PlotsPuzzle? fallback;

  for (var attempt = 0; attempt < 40; attempt++) {
    final plots = _plots(rows, cols, rng, maxValue, weights);
    if (plots == null) continue;
    final sizes = <int, int>{};
    for (final r in plots) {
      sizes[r] = (sizes[r] ?? 0) + 1;
    }
    final sol = [for (final r in plots) sizes[r]! - 1];
    final solver = PlotsSolver(rows, cols, maxValue);
    final givens = <int?>[...sol];
    bool solvable() => solver.solves(givens, 1) || (tier > 1 && solver.solves(givens, tier));
    final keep = switch (d) {
      Difficulty.easy => 0.15,
      _ => 0.0,
    };
    for (final i in [for (var i = 0; i < n; i++) i]..shuffle(rng)) {
      if (rng.nextDouble() < keep) continue;
      final g = givens[i];
      givens[i] = null;
      if (!solvable()) givens[i] = g;
    }
    final puzzle = PlotsPuzzle(rows: rows, cols: cols, maxValue: maxValue, givens: givens, solution: sol);
    if (tier > 1 && solver.solves(givens, tier - 1)) {
      fallback ??= puzzle;
      if (attempt < 20) continue;
    }
    return puzzle;
  }
  return fallback ?? generatePlots(params.withSeed(params.seed + 7919));
}

/// A random split into plots of 1..[maxValue] cells where no two plots of
/// the same size share a side (they'd read as one). Each plot grows from the
/// most walled-in free cell and keeps the longest part of its growth that
/// doesn't clash; a cell with no room joins a neighbouring plot. Plot ids
/// per cell, or null when stuck.
List<int>? _plots(int rows, int cols, Random rng, int maxValue, List<double> weights) {
  final n = rows * cols;
  final nb = orthNeighbors(rows, cols);
  final plots = List<int>.filled(n, -1);
  final sizes = <int>[];
  final total = weights.fold(0.0, (a, b) => a + b);
  int free(int i) => nb[i].where((j) => plots[j] < 0).length;
  int drawSize() {
    var t = rng.nextDouble() * total;
    for (var k = 0; k < weights.length; k++) {
      t -= weights[k];
      if (t <= 0) return k + 1;
    }
    return weights.length;
  }

  /// Whether [cells] as plot [id] of their count touch another plot that size.
  bool clashes(Iterable<int> cells, int id, int size) =>
      cells.any((i) => nb[i].any((j) => plots[j] >= 0 && plots[j] != id && sizes[plots[j]] == size));

  while (true) {
    var start = -1, best = 99;
    for (final i in [
      for (var i = 0; i < n; i++)
        if (plots[i] < 0) i,
    ]..shuffle(rng)) {
      final f = free(i);
      if (f < best) {
        best = f;
        start = i;
      }
    }
    if (start < 0) return plots;
    final id = sizes.length;
    final target = drawSize();
    final order = [start];
    plots[start] = id;
    while (order.length < target) {
      final frontier = {
        for (final c in order)
          for (final j in nb[c])
            if (plots[j] < 0) j,
      }.toList();
      if (frontier.isEmpty) break;
      frontier.sort((a, b) => free(a).compareTo(free(b)));
      final pick = rng.nextDouble() < 0.5 ? frontier.first : frontier[rng.nextInt(frontier.length)];
      plots[pick] = id;
      order.add(pick);
    }
    // Every prefix of the growth order is connected: keep the longest one
    // that doesn't clash.
    var keep = order.length;
    while (keep > 0 && clashes(order.take(keep), id, keep)) {
      keep--;
    }
    for (final c in order.skip(keep)) {
      plots[c] = -1;
    }
    if (keep > 0) {
      sizes.add(keep);
      continue;
    }
    // Join a neighbouring plot, which grows by one.
    final joins =
        {
          for (final j in nb[start])
            if (plots[j] >= 0) plots[j],
        }.where((r) {
          final s = sizes[r] + 1;
          if (s > maxValue) return false;
          final cells = [
            start,
            for (var i = 0; i < n; i++)
              if (plots[i] == r) i,
          ];
          return !clashes(cells, r, s);
        }).toList();
    if (joins.isEmpty) return null;
    final r = joins[rng.nextInt(joins.length)];
    plots[start] = r;
    sizes[r]++;
  }
}
