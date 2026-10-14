import 'dart:math';

import '../../core/difficulty.dart';
import '../../core/grid_graph.dart';
import '../../core/latin_square.dart';
import 'cages_model.dart';
import 'cages_solver.dart';

/// Logic tier of a difficulty: cage fills and singles, + pairs and digits a
/// cage must put into a line, + probing.
int cagesTier(Difficulty d) => switch (d) {
  Difficulty.easy => 1,
  Difficulty.medium => 2,
  _ => 3,
};

/// Cage sizes 1, 2, 3… by weight.
List<int> _sizeWeights(Difficulty d, int n) => switch (d) {
  Difficulty.easy => const [1, 6, 4],
  Difficulty.medium => const [1, 6, 5, 2],
  _ => n >= 6 ? const [0, 5, 5, 3, 1] : const [0, 6, 5, 3],
};

/// Easy boards only add and take away.
bool _allOps(Difficulty d) => d != Difficulty.easy;

int _pick(List<int> weights, Random rng) {
  var r = rng.nextInt(weights.fold(0, (a, b) => a + b));
  for (var k = 0; k < weights.length; k++) {
    r -= weights[k];
    if (r < 0) return k;
  }
  return weights.length - 1;
}

/// An operation for a cage holding [v] (1..n): a two-cell cage prefers a
/// division (when it comes out even) or a difference.
Cage _cage(List<int> cells, List<int> solution, bool allOps, Random rng) {
  cells.sort();
  final v = [for (final i in cells) solution[i] + 1];
  final CageOp op;
  if (cells.length == 1) {
    op = CageOp.none;
  } else if (cells.length == 2) {
    final div = allOps && cageTarget(CageOp.div, v) != null;
    final ops = [
      if (div) ...[CageOp.div, CageOp.div, CageOp.div],
      CageOp.sub,
      CageOp.sub,
      CageOp.sub,
      CageOp.add,
      if (allOps) CageOp.mul,
    ];
    op = ops[rng.nextInt(ops.length)];
  } else {
    op = allOps && rng.nextInt(2) == 0 ? CageOp.mul : CageOp.add;
  }
  return Cage(cells, op, cageTarget(op, v)!);
}

/// Cuts the grid into connected cages of random sizes.
List<List<int>> _partition(int n, List<List<int>> nb, List<int> weights, Random rng) {
  final of = List.filled(n * n, -1);
  final cages = <List<int>>[];
  for (final i in [for (var i = 0; i < n * n; i++) i]..shuffle(rng)) {
    if (of[i] >= 0) continue;
    final size = _pick(weights, rng) + 1;
    final cells = [i];
    of[i] = cages.length;
    while (cells.length < size) {
      final open = {
        for (final c in cells)
          for (final j in nb[c])
            if (of[j] < 0) j,
      }.toList();
      if (open.isEmpty) break;
      final j = open[rng.nextInt(open.length)];
      of[j] = cages.length;
      cells.add(j);
    }
    cages.add(cells);
  }
  return cages;
}

/// Random Latin square → random cages and operations → cells split off as
/// one-cell cages where the tier's logic stalls → one-cell cages merged back
/// into a neighbour while the tier still solves the board. Medium and hard
/// prefer boards the tier below can't finish.
CagesPuzzle generateCages(GenParams params) {
  final n = params.size.rows;
  final rng = Random(params.seed);
  final tier = cagesTier(params.difficulty);
  final weights = _sizeWeights(params.difficulty, n);
  final maxSize = weights.length;
  final allOps = _allOps(params.difficulty);
  final sq = LatinSquare.of(n);
  final nb = orthNeighbors(n, n);
  final empty = List<int?>.filled(n * n, null);
  CagesPuzzle? fallback;

  for (var attempt = 0; attempt < 40; attempt++) {
    final solution = sq.random(rng);
    final cages = [for (final cells in _partition(n, nb, weights, rng)) _cage(cells, solution, allOps, rng)];

    while (true) {
      final c = sq.start(empty);
      if (CagesSolver(n, cages).solve(c, tier)) break;
      final open = [
        for (var i = 0; i < c.length; i++)
          if (!LatinSquare.single(c[i])) i,
      ];
      final i = open[rng.nextInt(open.length)];
      final x = cages.indexWhere((cage) => cage.cells.contains(i));
      final rest = cages[x].cells.where((j) => j != i).toList();
      cages
        ..removeAt(x)
        ..add(_cage([i], solution, allOps, rng));
      for (final part in components(nb, rest.contains)) {
        cages.add(_cage(part, solution, allOps, rng));
      }
    }

    bool solves(List<Cage> cages, int tier) => CagesSolver(n, cages).solve(sq.start(empty), tier);

    for (final lone in [
      for (final cage in cages)
        if (cage.cells.length == 1) cage,
    ]..shuffle(rng)) {
      if (!cages.contains(lone)) continue;
      final i = lone.cells.first;
      final near = {
        for (final j in nb[i])
          for (final cage in cages)
            if (cage.cells.contains(j) && cage.cells.length < maxSize) cage,
      }.toList()..shuffle(rng);
      for (final other in near) {
        final merged = _cage([...other.cells, i], solution, allOps, rng);
        final next = [
          for (final cage in cages)
            if (cage != lone && cage != other) cage,
          merged,
        ];
        if (solves(next, tier)) {
          cages
            ..clear()
            ..addAll(next);
          break;
        }
      }
    }
    cages.sort((a, b) => a.cells.first - b.cells.first);
    final puzzle = CagesPuzzle(n: n, cages: cages, givens: empty, solution: solution);
    if (tier == 1 || n < 5 || !solves(cages, tier - 1)) return puzzle;
    fallback ??= puzzle;
  }
  return fallback!;
}
