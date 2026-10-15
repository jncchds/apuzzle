import 'dart:math';

import '../../core/difficulty.dart';
import '../../core/grid_graph.dart';
import '../sudoku/sudoku_solver.dart';
import 'pockets_model.dart';
import 'pockets_solver.dart';

/// Logic tier of a difficulty: singles and pocket sums, + locked candidates,
/// pairs, every way to fill a pocket and the sums of whole regions, +
/// probing.
int pocketsTier(Difficulty d) => switch (d) {
  Difficulty.easy => 1,
  Difficulty.medium => 2,
  _ => 3,
};

/// Pocket sizes 1, 2, 3… by weight.
List<int> _sizeWeights(Difficulty d) => switch (d) {
  Difficulty.easy => const [0, 6, 5, 1],
  Difficulty.medium => const [0, 4, 6, 3, 1],
  _ => const [0, 3, 5, 4, 2, 1],
};

int _pick(List<int> weights, Random rng) {
  var r = rng.nextInt(weights.fold(0, (a, b) => a + b));
  for (var k = 0; k < weights.length; k++) {
    r -= weights[k];
    if (r < 0) return k;
  }
  return weights.length - 1;
}

Pocket _pocket(List<int> cells, List<int> solution) =>
    Pocket(cells..sort(), cells.fold(0, (s, i) => s + solution[i] + 1));

/// Cuts the grid into connected pockets of random sizes, never with a digit
/// twice in one.
List<List<int>> _partition(int n, List<int> solution, List<List<int>> nb, List<int> weights, Random rng) {
  final of = List.filled(n * n, -1);
  final pockets = <List<int>>[];
  for (final i in [for (var i = 0; i < n * n; i++) i]..shuffle(rng)) {
    if (of[i] >= 0) continue;
    final size = _pick(weights, rng) + 1;
    final cells = [i];
    var digits = 1 << solution[i];
    of[i] = pockets.length;
    while (cells.length < size) {
      final open = {
        for (final c in cells)
          for (final j in nb[c])
            if (of[j] < 0 && digits & (1 << solution[j]) == 0) j,
      }.toList();
      if (open.isEmpty) break;
      final j = open[rng.nextInt(open.length)];
      of[j] = pockets.length;
      digits |= 1 << solution[j];
      cells.add(j);
    }
    pockets.add(cells);
  }
  return pockets;
}

/// Random Sudoku solution → random pockets → cells split off as one-cell
/// pockets where the tier's logic stalls → one-cell pockets merged back into
/// a neighbour while the tier still solves the board → on medium and hard,
/// neighbouring pockets merged until the tier below gets stuck. The best of
/// a few tries: a board the tier below can't finish, then the fewest
/// one-cell pockets.
PocketsPuzzle generatePockets(GenParams params) {
  final n = params.size.rows;
  final rng = Random(params.seed);
  final tier = pocketsTier(params.difficulty);
  final weights = _sizeWeights(params.difficulty);
  final maxSize = weights.length;
  final nb = orthNeighbors(n, n);
  final empty = List<int?>.filled(n * n, null);
  final sudoku = SudokuSolver(n);
  PocketsPuzzle? best;
  var bestScore = 1 << 30;

  PocketsPuzzle board(List<int> solution, List<List<int>> pockets) => PocketsPuzzle(
    n: n,
    pockets: [for (final cells in pockets..sort((a, b) => a.first - b.first)) _pocket(cells, solution)],
    givens: empty,
    solution: solution,
  );

  // Small hard boards seldom need probing: they get more tries.
  final attempts = n <= 4 ? 4 : (n < 9 && tier == 3 ? 100 : 30);
  for (var attempt = 0; attempt < attempts; attempt++) {
    final solution = sudoku.randomSolution(rng);
    final pockets = [for (final cells in _partition(n, solution, nb, weights, rng)) cells..sort()];

    bool solves(List<List<int>> pockets, int tier) {
      final s = PocketsSolver(board(solution, [for (final p in pockets) List.of(p)]));
      return s.solve(s.start(), tier);
    }

    while (true) {
      final s = PocketsSolver(board(solution, [for (final p in pockets) List.of(p)]));
      final c = s.start();
      if (s.solve(c, tier)) break;
      final open = [
        for (var i = 0; i < c.length; i++)
          if (c[i] & (c[i] - 1) != 0) i,
      ];
      final i = open[rng.nextInt(open.length)];
      final x = pockets.indexWhere((cells) => cells.contains(i));
      final rest = pockets[x].where((j) => j != i).toList();
      pockets
        ..removeAt(x)
        ..add([i]);
      for (final part in components(nb, rest.contains)) {
        pockets.add(part..sort());
      }
    }

    for (final lone in [
      for (final cells in pockets)
        if (cells.length == 1) cells,
    ]..shuffle(rng)) {
      if (!pockets.contains(lone)) continue;
      final i = lone.first;
      final near = {
        for (final j in nb[i])
          for (final cells in pockets)
            if (cells.contains(j) && cells.length < maxSize && !cells.any((k) => solution[k] == solution[i])) cells,
      }.toList()..shuffle(rng);
      for (final other in near) {
        final next = [
          for (final cells in pockets)
            if (!identical(cells, lone) && !identical(cells, other)) cells,
          [...other, i]..sort(),
        ];
        if (solves(next, tier)) {
          pockets
            ..clear()
            ..addAll(next);
          break;
        }
      }
    }
    // Medium and hard: merge neighbouring pockets while the tier still
    // solves the board, until the tier below gets stuck.
    var easier = tier > 1 && n >= 6 && solves(pockets, tier - 1);
    for (var tries = 0; easier && tries < pockets.length * 2; tries++) {
      final a = pockets[rng.nextInt(pockets.length)];
      final near = {
        for (final i in a)
          for (final j in nb[i])
            for (final cells in pockets)
              if (!identical(cells, a) && cells.contains(j)) cells,
      }.toList();
      final b = near[rng.nextInt(near.length)];
      if (a.length + b.length > maxSize + 1) continue;
      final digits = {
        for (final i in [...a, ...b]) solution[i],
      };
      if (digits.length < a.length + b.length) continue;
      final next = [
        for (final cells in pockets)
          if (!identical(cells, a) && !identical(cells, b)) cells,
        [...a, ...b]..sort(),
      ];
      if (!solves(next, tier)) continue;
      pockets
        ..clear()
        ..addAll(next);
      easier = solves(pockets, tier - 1);
    }
    // Fewest one-cell pockets, and a board the tier below can't finish.
    final lone = pockets.where((cells) => cells.length == 1).length;
    final score = lone + (easier ? 100 : 0);
    if (score < bestScore) {
      bestScore = score;
      best = board(solution, pockets);
    }
    if (score == 0) break;
  }
  return best!;
}
