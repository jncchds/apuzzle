import 'dart:math';

import '../../core/difficulty.dart';
import '../../core/grid_graph.dart';
import 'blocks_model.dart';
import 'blocks_solver.dart';

/// Regions grown together with their numbers → drop givens while logic at
/// the difficulty's tier still solves the board. Harder levels retry until
/// the easier tier gets stuck.
BlocksPuzzle generateBlocks(GenParams params) {
  final rows = params.size.rows, cols = params.size.cols, n = rows * cols;
  final rng = Random(params.seed);
  final d = params.difficulty;
  final tier = switch (d) {
    Difficulty.easy => 1,
    Difficulty.medium => 2,
    _ => 3,
  };
  final weights = d == Difficulty.easy ? const [0.2, 0.6, 1.4, 2.0, 1.2] : const [0.15, 0.4, 1.0, 1.8, 2.6];
  BlocksPuzzle? fallback;

  for (var attempt = 0; attempt < 40; attempt++) {
    final filled = _growAndFill(rows, cols, rng, weights);
    if (filled == null) continue;
    final (regions, sol) = filled;
    final solver = BlocksSolver(rows, cols, regions);
    final givens = <int?>[...sol];
    // Tier-1 checks are much cheaper, so try them first.
    bool solvable() => solver.solves(givens, 1) || (tier > 1 && solver.solves(givens, tier));
    final keep = d == Difficulty.easy ? 0.12 : 0.0;
    for (final i in [for (var i = 0; i < n; i++) i]..shuffle(rng)) {
      if (rng.nextDouble() < keep) continue;
      final g = givens[i];
      givens[i] = null;
      if (!solvable()) givens[i] = g;
    }
    final puzzle = BlocksPuzzle(rows: rows, cols: cols, regions: regions, givens: givens, solution: sol);
    if (tier > 1 && solver.solves(givens, tier - 1)) {
      fallback ??= puzzle;
      if (attempt < 30) continue;
    }
    return puzzle;
  }
  return fallback ?? generateBlocks(params.withSeed(params.seed + 7919));
}

/// Regions and their numbers together: each new region grows from the most
/// walled-in free cell and gets numbers that don't touch equal ones placed
/// before. A cell with no room left joins a neighbouring region as its next
/// number. Returns (regions, values), or null when stuck.
(List<int>, List<int>)? _growAndFill(int rows, int cols, Random rng, List<double> weights) {
  final n = rows * cols;
  final regions = List<int>.filled(n, -1);
  final values = List<int>.filled(n, -1);
  final nb = orthNeighbors(rows, cols);
  final kn = kingNeighbors(rows, cols);
  final sizes = <int>[];
  final total = weights.fold(0.0, (a, b) => a + b);
  int free(int i) => nb[i].where((j) => regions[j] < 0).length;
  int drawSize() {
    var t = rng.nextDouble() * total;
    for (var k = 0; k < weights.length; k++) {
      t -= weights[k];
      if (t <= 0) return k + 1;
    }
    return weights.length;
  }

  bool fits(int i, int v) => kn[i].every((j) => values[j] != v);

  /// Numbers 0..k-1 for [cells], avoiding equal touching numbers.
  bool assign(List<int> cells, int k) {
    if (k == cells.length) return true;
    final i = cells[k];
    final order = [for (var v = 0; v < cells.length; v++) v]..shuffle(rng);
    for (final v in order) {
      if (!fits(i, v) || cells.take(k).any((c) => values[c] == v)) continue;
      values[i] = v;
      if (assign(cells, k + 1)) return true;
      values[i] = -1;
    }
    return false;
  }

  while (true) {
    var start = -1, best = 99;
    for (final i in [
      for (var i = 0; i < n; i++)
        if (regions[i] < 0) i,
    ]..shuffle(rng)) {
      final f = free(i);
      if (f < best) {
        best = f;
        start = i;
      }
    }
    if (start < 0) break;
    final id = sizes.length;
    var placed = false;
    for (var tries = 0; tries < 8 && !placed; tries++) {
      final target = max(1, drawSize() - tries ~/ 3);
      final cells = [start];
      regions[start] = id;
      while (cells.length < target) {
        final frontier = {
          for (final c in cells)
            for (final j in nb[c])
              if (regions[j] < 0) j,
        }.toList();
        if (frontier.isEmpty) break;
        frontier.sort((a, b) => free(a).compareTo(free(b)));
        final pick = rng.nextDouble() < 0.5 ? frontier.first : frontier[rng.nextInt(frontier.length)];
        regions[pick] = id;
        cells.add(pick);
      }
      if (assign(cells, 0)) {
        sizes.add(cells.length);
        placed = true;
      } else {
        for (final c in cells) {
          regions[c] = -1;
          values[c] = -1;
        }
      }
    }
    if (placed) continue;
    // Join a neighbouring region as its next number.
    final joins = [
      for (final j in nb[start])
        if (regions[j] >= 0 && sizes[regions[j]] < 6 && fits(start, sizes[regions[j]])) regions[j],
    ];
    if (joins.isEmpty) return null;
    final r = joins[rng.nextInt(joins.length)];
    regions[start] = r;
    values[start] = sizes[r]++;
  }
  // Renumber regions in reading order (ids of regions that never formed are gone).
  final remap = <int, int>{};
  return ([for (final r in regions) remap.putIfAbsent(r, () => remap.length)], values);
}
