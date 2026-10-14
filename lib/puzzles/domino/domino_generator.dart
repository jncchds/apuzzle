import 'dart:math';

import '../../core/difficulty.dart';
import '../../core/lattice_loop.dart';
import 'domino_model.dart';
import 'domino_solver.dart';

int dominoTier(Difficulty d) => switch (d) {
  Difficulty.easy => 1,
  Difficulty.medium => 2,
  _ => 3,
};

/// The set's highest number for a grid of [rows] × [cols] (rows = top + 2).
int dominoTop(int rows, int cols) => min(rows, cols) - 1;

/// A random tiling of the grid (each cell's partner): cells paired in reading
/// order, then many random turns of two parallel dominoes in a 2×2 square.
List<int> randomTiling(int rows, int cols, Random rng) {
  final n = rows * cols;
  final mate = List<int>.filled(n, -1);
  bool fill(int i) {
    while (i < n && mate[i] >= 0) {
      i++;
    }
    if (i == n) return true;
    final c = i % cols;
    final options = [if (c + 1 < cols && mate[i + 1] < 0) i + 1, if (i + cols < n) i + cols]..shuffle(rng);
    for (final j in options) {
      mate[i] = j;
      mate[j] = i;
      if (fill(i + 1)) return true;
      mate[i] = -1;
      mate[j] = -1;
    }
    return false;
  }

  fill(0);
  for (var step = 0; step < n * 12; step++) {
    final r = rng.nextInt(rows - 1), c = rng.nextInt(cols - 1);
    final a = r * cols + c, b = a + 1, d = a + cols, e = d + 1;
    final flat = mate[a] == b && mate[d] == e, upright = mate[a] == d && mate[b] == e;
    if (!flat && !upright) continue;
    for (final (x, y) in flat ? [(a, d), (b, e)] : [(a, b), (d, e)]) {
      mate[x] = y;
      mate[y] = x;
    }
  }
  return mate;
}

/// A random tiling gets the set's dominoes in random order and turns. A
/// local search then swaps dominoes that hold cells the difficulty's tier
/// can't settle, kept while the logic gets no further behind; medium and
/// hard then push the tier below to stall the same way.
DominoPuzzle generateDomino(GenParams params) {
  final rows = params.size.rows, cols = params.size.cols, n = rows * cols;
  final rng = Random(params.seed);
  final tier = dominoTier(params.difficulty);
  final top = dominoTop(rows, cols);
  final g = LatticeLoop(rows, cols);

  for (var attempt = 0; attempt < 12; attempt++) {
    final mate = randomTiling(rows, cols, rng);
    final tiles = [
      for (var i = 0; i < n; i++)
        if (mate[i] > i) (i, mate[i]),
    ];
    final set = [
      for (var b = 0; b <= top; b++)
        for (var a = 0; a <= b; a++) (a, b),
    ]..shuffle(rng);
    final nums = List<int>.filled(n, 0);
    final tileOf = List<int>.filled(n, 0);
    void put(int t, (int, int) pair) {
      final (x, y) = rng.nextBool() ? pair : (pair.$2, pair.$1);
      nums[tiles[t].$1] = x;
      nums[tiles[t].$2] = y;
    }

    for (var t = 0; t < tiles.length; t++) {
      put(t, set[t]);
      tileOf[tiles[t].$1] = t;
      tileOf[tiles[t].$2] = t;
    }

    List<int> stuck(int t) {
      final s = DominoSolver(rows, cols, nums);
      final st = s.start();
      s.solve(st, t);
      return [
        for (var i = 0; i < n; i++)
          if (s.lineAt(st, i) < 0) i,
      ];
    }

    // Swaps the dominoes of tile [t] and another one; returns the undo.
    void Function() mutate(int t) {
      final old = List.of(nums);
      var u = rng.nextInt(tiles.length - 1);
      if (u >= t) u++;
      final pt = (nums[tiles[t].$1], nums[tiles[t].$2]), pu = (nums[tiles[u].$1], nums[tiles[u].$2]);
      put(t, pu);
      put(u, pt);
      return () => nums.setAll(0, old);
    }

    List<int> settle(int t, List<int> open, int steps) {
      for (var step = 0; step < steps && open.isNotEmpty; step++) {
        final undo = mutate(tileOf[open[rng.nextInt(open.length)]]);
        final next = stuck(t);
        if (next.length <= open.length) {
          open = next;
        } else {
          undo();
        }
      }
      return open;
    }

    var open = settle(min(tier, 2), stuck(min(tier, 2)), n * 3);
    if (tier == 3 && open.isNotEmpty) open = settle(3, stuck(3), n);
    if (open.isNotEmpty) continue;

    // Harder: make the tier below get stuck, keeping the tier itself happy.
    if (tier > 1) {
      var below = stuck(tier - 1).length;
      final want = max(4, n ~/ 4);
      for (var step = 0; step < n * 2 && below < want; step++) {
        final undo = mutate(rng.nextInt(tiles.length));
        final b = stuck(tier - 1).length;
        if (b >= below && stuck(tier).isEmpty) {
          below = b;
        } else {
          undo();
        }
      }
      if (below == 0) continue;
    }

    final lines = List<bool>.filled(g.edgeCount, false);
    for (final (a, b) in tiles) {
      lines[g.between(a, b)] = true;
    }
    return DominoPuzzle(rows: rows, cols: cols, nums: nums, lines: lines);
  }
  return generateDomino(params.withSeed(params.seed + 1));
}
