import 'dart:math';

import '../../core/difficulty.dart';
import '../../core/grid_graph.dart';
import '../../core/region_search.dart';
import 'pairs_model.dart';
import 'pairs_solver.dart';

/// Random non-touching dominoes, each starting as its own region (so the
/// shading is forced) → cells join neighbouring regions one at a time, most
/// constrained first, only where logic still decides the whole board, so
/// the shading stays unique. Adding cells only adds freedom, so a rejected
/// (cell, region) pair is never retried. Medium grows with the region rule
/// and retries until the basic rules get stuck; hard then reshapes borders
/// until the region rule gets stuck too (probing still solves it).
PairsPuzzle generatePairs(GenParams params) {
  final n = params.size.rows;
  final rng = Random(params.seed);
  final d = params.difficulty;
  final tier = d == Difficulty.easy ? 1 : 2;
  PairsPuzzle? best;
  var bestGrade = 0;

  for (var attempt = 0; attempt < 24; attempt++) {
    final shaded = _dominoes(n, rng);
    final regions = _grow(n, shaded, tier, rng);
    if (regions == null) continue;
    if (d == Difficulty.hard) {
      final search = RegionSearch(n, regions, shaded, rng);
      search.harden(() => PairsSolver(n, regions).slack(3) == 0, () => PairsSolver(n, regions).slack(2), budget: 8 * n);
    }
    final puzzle = PairsPuzzle(n: n, regions: _renumber(regions), shaded: shaded);
    final grade = PairsSolver(n, regions).grade();
    final want = switch (d) {
      Difficulty.easy => 1,
      Difficulty.medium => 2,
      _ => 3,
    };
    if (grade == want) return puzzle;
    if (grade > bestGrade && grade <= want) {
      bestGrade = grade;
      best = puzzle;
    }
    // Hard falls back to the hardest board found after a few tries.
    if (d == Difficulty.hard && attempt >= 3 && best != null) return best;
  }
  return best ?? generatePairs(params.withSeed(params.seed + 104729));
}

/// Region ids in reading order.
List<int> _renumber(List<int> regions) {
  final map = <int, int>{};
  return [for (final r in regions) map.putIfAbsent(r, () => map.length)];
}

/// Greedy random dominoes that never touch side by side.
List<bool> _dominoes(int n, Random rng) {
  final nb = orthNeighbors(n, n);
  final shaded = List<bool>.filled(n * n, false);
  for (final i in [for (var i = 0; i < n * n; i++) i]..shuffle(rng)) {
    final dirs = [if (i % n + 1 < n) i + 1, if (i + n < n * n) i + n]..shuffle(rng);
    for (final j in dirs) {
      bool clear(int a, int b) => !shaded[a] && nb[a].every((k) => k == b || !shaded[k]);
      if (clear(i, j) && clear(j, i)) {
        shaded[i] = shaded[j] = true;
        break;
      }
    }
  }
  return shaded;
}

/// Grows a region from each domino, one cell at a time, keeping the board
/// solvable by logic up to [tier]. Smaller regions grow first. Where cells
/// are left that no region can take, the cells around one are freed and
/// the growth runs again. Null if that keeps failing.
List<int>? _grow(int n, List<bool> shaded, int tier, Random rng) {
  final nb = orthNeighbors(n, n);
  final regions = List<int>.filled(n * n, -1);
  var count = 0;
  for (var i = 0; i < n * n; i++) {
    if (!shaded[i] || regions[i] >= 0) continue;
    regions[i] = count;
    for (final j in nb[i]) {
      if (shaded[j]) regions[j] = count;
    }
    count++;
  }
  if (count < 2) return null;
  final size = List<int>.filled(count, 2);
  final rejected = <int>{};
  bool solvable() {
    final s = PairsSolver(n, regions);
    return s.slack(1) == 0 || (tier > 1 && s.slack(tier) == 0);
  }

  for (var round = 0; round < 30; round++) {
    if (round > 0) {
      // Stuck cells: free the cells around one and grow again from there.
      final left = [
        for (var i = 0; i < n * n; i++)
          if (regions[i] < 0) i,
      ];
      final x = left[rng.nextInt(left.length)];
      final xr = x ~/ n, xc = x % n;
      for (var i = 0; i < n * n; i++) {
        if (!shaded[i] && regions[i] >= 0 && (i ~/ n - xr).abs() <= 2 && (i % n - xc).abs() <= 2) regions[i] = -1;
      }
      // Keep only the part of each region still joined to its domino.
      final keep = List<bool>.filled(n * n, false);
      for (var i = 0; i < n * n; i++) {
        if (!shaded[i] || keep[i]) continue;
        final stack = [i];
        keep[i] = true;
        while (stack.isNotEmpty) {
          final a = stack.removeLast();
          for (final b in nb[a]) {
            if (!keep[b] && regions[b] == regions[i]) {
              keep[b] = true;
              stack.add(b);
            }
          }
        }
      }
      size.fillRange(0, count, 0);
      for (var i = 0; i < n * n; i++) {
        if (!keep[i]) regions[i] = -1;
        if (regions[i] >= 0) size[regions[i]]++;
      }
      // Fewer cells in play only removes freedom: rejections may pass now.
      rejected.clear();
    }
    _growFree(n, regions, size, count, rejected, nb, solvable, rng);
    if (!regions.contains(-1)) return regions;
  }
  return null;
}

void _growFree(
  int n,
  List<int> regions,
  List<int> size,
  int count,
  Set<int> rejected,
  List<List<int>> nb,
  bool Function() solvable,
  Random rng,
) {
  while (true) {
    final moves = <(int, int)>[
      for (var i = 0; i < n * n; i++)
        if (regions[i] < 0)
          for (final r in {
            for (final j in nb[i])
              if (regions[j] >= 0) regions[j],
          })
            if (!rejected.contains(i * count + r)) (i, r),
    ];
    if (moves.isEmpty) break;
    // Cells with the fewest regions left to join go first (a corner next to
    // one domino must not wait until its way out is gone); among those,
    // favour small regions so sizes stay balanced.
    final options = <int, int>{};
    for (final (i, _) in moves) {
      options[i] = (options[i] ?? 0) + 1;
    }
    final fewest = options.values.reduce(min);
    moves.retainWhere((m) => options[m.$1] == fewest);
    final weights = [for (final (_, r) in moves) 1 / (size[r] * size[r])];
    var t = rng.nextDouble() * weights.fold(0.0, (a, b) => a + b);
    var pick = moves.last;
    for (var k = 0; k < moves.length; k++) {
      t -= weights[k];
      if (t <= 0) {
        pick = moves[k];
        break;
      }
    }
    final (i, r) = pick;
    regions[i] = r;
    if (solvable()) {
      size[r]++;
    } else {
      regions[i] = -1;
      rejected.add(i * count + r);
    }
  }
}
