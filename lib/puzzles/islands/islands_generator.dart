import 'dart:math';

import '../../core/difficulty.dart';
import '../../core/grid_graph.dart';
import 'islands_model.dart';
import 'islands_solver.dart';

/// Random islands in a connected sea without pools → a number in each island
/// → move numbers inside their islands, then patch the layout where the
/// difficulty's tier still stalls.
IslandsPuzzle generateIslands(GenParams params) {
  final rows = params.size.rows, cols = params.size.cols, n = rows * cols;
  final rng = Random(params.seed);
  final d = params.difficulty;
  final tier = d == Difficulty.easy ? 1 : 2;
  final maxIsland = switch (d) {
    Difficulty.easy => 4,
    Difficulty.medium => 6,
    _ => n >= 81 ? 8 : 7,
  };
  final nb = orthNeighbors(rows, cols);
  final maxRepairs = max(2, n ~/ 12);
  IslandsPuzzle? fallback;

  for (var attempt = 0; attempt < 40; attempt++) {
    final sea = _layout(rows, cols, nb, rng, maxIsland, 0.4 + rng.nextDouble() * 0.08);
    if (sea == null) continue;
    final islands = components(nb, (i) => !sea[i]);
    final spot = [for (final isl in islands) isl[rng.nextInt(isl.length)]];

    List<int?> cluesFor() {
      final c = List<int?>.filled(n, null);
      for (var k = 0; k < islands.length; k++) {
        c[spot[k]] = islands[k].length;
      }
      return c;
    }

    List<int> solveAt(int t) {
      final s = IslandsSolver(rows, cols, cluesFor());
      final st = s.initial();
      s.solve(st, t);
      return st;
    }

    // Local search: move numbers inside their islands while that helps
    // (scored with the cheap tier-1 logic), preferring islands next to
    // undecided cells.
    var cur = solveAt(1);
    var best = cur.where((v) => v >= 0).length;
    for (var step = 0; step < 80 && best < n; step++) {
      final near = [
        for (var k = 0; k < islands.length; k++)
          if (islands[k].length > 1 && islands[k].any((i) => cur[i] < 0 || nb[i].any((j) => cur[j] < 0))) k,
      ];
      if (near.isEmpty) break;
      final k = near[rng.nextInt(near.length)];
      final old = spot[k];
      spot[k] = islands[k][rng.nextInt(islands[k].length)];
      final st = solveAt(1);
      final got = st.where((v) => v >= 0).length;
      if (got >= best) {
        best = got;
        cur = st;
      } else {
        spot[k] = old;
      }
    }

    // Where the logic still stalls, change the layout there: an undecided
    // piece of sea becomes a one-cell island, or an undecided land cell
    // becomes sea (splitting its island; new pieces get their own numbers).
    var repairs = 0;
    while (true) {
      final st = solveAt(tier);
      if (!st.contains(-1)) break;
      final spots = spot.toSet();
      final options = [
        for (var i = 0; i < n; i++)
          if (st[i] == -1 &&
              (sea[i]
                  ? nb[i].every((j) => sea[j]) && _seaConnectedWithout(sea, nb, i)
                  : !spots.contains(i) && nb[i].any((j) => sea[j]) && !_poolWith(sea, rows, cols, i)))
            i,
      ];
      if (options.isEmpty || repairs >= maxRepairs) {
        repairs = -1;
        break;
      }
      // Splitting an island beats adding a one-cell island.
      final splits = [for (final i in options) if (!sea[i]) i];
      final pool = splits.isNotEmpty ? splits : options;
      final u = pool[rng.nextInt(pool.length)];
      sea[u] = !sea[u];
      final comps = components(nb, (i) => !sea[i]);
      islands
        ..clear()
        ..addAll(comps);
      spot
        ..clear()
        ..addAll([
          for (final c in comps) c.firstWhere(spots.contains, orElse: () => c.contains(u) ? u : c[rng.nextInt(c.length)]),
        ]);
      repairs++;
    }
    if (repairs < 0) continue;

    final puzzle = IslandsPuzzle(rows: rows, cols: cols, clues: cluesFor(), sea: sea);
    if (tier == 2 && !solveAt(1).contains(-1)) {
      fallback ??= puzzle;
      continue;
    }
    return puzzle;
  }
  return fallback ?? generateIslands(params.withSeed(params.seed + 1));
}

/// Sea mask with land islands of at most [maxIsland] cells, a connected sea
/// and no 2×2 pools, or null if the random build got stuck.
List<bool>? _layout(int rows, int cols, List<List<int>> nb, Random rng, int maxIsland, double landShare) {
  final n = rows * cols;
  final sea = List<bool>.filled(n, true);
  var land = 0;

  int islandSizeWith(int i) {
    final seen = <int>{i};
    final queue = [i];
    for (var q = 0; q < queue.length; q++) {
      for (final j in nb[queue[q]]) {
        if (!sea[j] && seen.add(j)) queue.add(j);
      }
    }
    return queue.length;
  }

  bool tryLand(int i) {
    if (!sea[i]) return false;
    if (islandSizeWith(i) > maxIsland) return false;
    if (!_seaConnectedWithout(sea, nb, i)) return false;
    sea[i] = false;
    land++;
    return true;
  }

  List<List<int>> pools() => [
        for (var r = 0; r + 1 < rows; r++)
          for (var c = 0; c + 1 < cols; c++)
            if ([r * cols + c, r * cols + c + 1, (r + 1) * cols + c, (r + 1) * cols + c + 1].every((k) => sea[k]))
              [r * cols + c, r * cols + c + 1, (r + 1) * cols + c, (r + 1) * cols + c + 1],
      ];

  // Break every pool.
  while (true) {
    final ps = pools();
    if (ps.isEmpty) break;
    final block = ps[rng.nextInt(ps.length)]..shuffle(rng);
    if (!block.any(tryLand)) return null;
  }
  // Grow islands towards the wanted land share.
  final target = (n * landShare).round();
  for (var pass = 0; pass < 3 && land < target; pass++) {
    for (final i in [for (var i = 0; i < n; i++) i]..shuffle(rng)) {
      if (land >= target) break;
      if (!sea[i]) continue;
      final nearLand = nb[i].any((j) => !sea[j]);
      if (!nearLand && rng.nextDouble() < 0.7) continue;
      tryLand(i);
    }
  }
  // Give one-cell islands a second cell where possible.
  for (final i in [for (var i = 0; i < n; i++) i]..shuffle(rng)) {
    if (sea[i] || nb[i].any((j) => !sea[j])) continue;
    for (final j in [...nb[i]]..shuffle(rng)) {
      if (tryLand(j)) break;
    }
  }
  return sea;
}

/// Whether the sea stays in one piece if cell [i] becomes land.
bool _seaConnectedWithout(List<bool> sea, List<List<int>> nb, int i) {
  final n = sea.length;
  var start = -1, total = 0;
  for (var k = 0; k < n; k++) {
    if (sea[k] && k != i) {
      total++;
      if (start < 0) start = k;
    }
  }
  if (start < 0) return false;
  final seen = List<bool>.filled(n, false)..[start] = true;
  final queue = [start];
  for (var q = 0; q < queue.length; q++) {
    for (final j in nb[queue[q]]) {
      if (j != i && sea[j] && !seen[j]) {
        seen[j] = true;
        queue.add(j);
      }
    }
  }
  return queue.length == total;
}

/// Whether making cell [i] sea would complete a 2×2 pool.
bool _poolWith(List<bool> sea, int rows, int cols, int i) {
  final r = i ~/ cols, c = i % cols;
  for (final (dr, dc) in const [(-1, -1), (-1, 0), (0, -1), (0, 0)]) {
    final r0 = r + dr, c0 = c + dc;
    if (r0 < 0 || c0 < 0 || r0 + 1 >= rows || c0 + 1 >= cols) continue;
    final block = [r0 * cols + c0, r0 * cols + c0 + 1, (r0 + 1) * cols + c0, (r0 + 1) * cols + c0 + 1];
    if (block.every((k) => k == i || sea[k])) return true;
  }
  return false;
}
