import 'dart:math';

import '../../core/difficulty.dart';
import '../../core/grid_graph.dart';
import 'glades_model.dart';
import 'glades_solver.dart';

int gladesTier(Difficulty d) => switch (d) {
  Difficulty.easy => 1,
  Difficulty.medium => 2,
  _ => 3,
};

/// A random layout (unshaded rectangles that never touch side by side, no
/// all-shaded 2×2 block, the rectangles joined through corners), a number in
/// a random cell of each rectangle, then a local search moving numbers
/// inside their rectangles while the tier gets further, and where it still
/// stalls the layout is changed there: an undecided unshaded cell splits its
/// rectangle with a shaded line, or an undecided shaded cell becomes a
/// one-cell area. Medium and hard keep the best of several boards by how
/// far the tier below gets.
GladesPuzzle generateGlades(GenParams params) {
  final n = params.size.rows, cells = n * n;
  final rng = Random(params.seed);
  final tier = gladesTier(params.difficulty);
  final nb = orthNeighbors(n, n);
  final maxArea = switch (params.difficulty) {
    Difficulty.easy => 6,
    Difficulty.medium => 8,
    _ => 9,
  };
  final tries = switch (params.difficulty) {
    Difficulty.easy => 1,
    Difficulty.medium => 6,
    _ => 8,
  };
  GladesPuzzle? best;
  var bestScore = 0, scored = 0;

  for (var attempt = 0; attempt < 60; attempt++) {
    final shaded = gladesLayout(n, rng, maxArea);
    var areas = components(nb, (i) => !shaded[i]);
    var spot = [for (final a in areas) a[rng.nextInt(a.length)]];

    GladesPuzzle board() {
      final clues = List<int?>.filled(cells, null);
      for (var k = 0; k < areas.length; k++) {
        clues[spot[k]] = areas[k].length;
      }
      return GladesPuzzle(n: n, clues: clues, shaded: List.of(shaded));
    }

    List<int> solveAt(int t) {
      final s = GladesSolver(board());
      final st = s.start();
      if (!s.solve(st, t)) return List.filled(cells, -1);
      return st;
    }

    int open(List<int> st) => st.where((v) => v == -1).length;

    // Move numbers inside their areas while the tier gets no further behind,
    // preferring areas near undecided cells.
    var cur = solveAt(tier);
    var left = open(cur);
    for (var step = 0; step < 40 && left > 0; step++) {
      final near = [
        for (var k = 0; k < areas.length; k++)
          if (areas[k].length > 1 && areas[k].any((i) => cur[i] < 0 || nb[i].any((j) => cur[j] < 0))) k,
      ];
      if (near.isEmpty) break;
      final k = near[rng.nextInt(near.length)];
      final old = spot[k];
      spot[k] = areas[k][rng.nextInt(areas[k].length)];
      final st = solveAt(tier);
      final got = open(st);
      if (got <= left) {
        left = got;
        cur = st;
      } else {
        spot[k] = old;
      }
    }

    // Where the tier still stalls, change the layout there.
    var repairs = 0;
    while (left > 0 && repairs < n) {
      final options = [
        for (var i = 0; i < cells; i++)
          if (cur[i] == -1) i,
      ]..shuffle(rng);
      var done = false;
      for (final u in options) {
        final next = _repair(n, nb, shaded, u, rng);
        if (next == null) continue;
        final oldSpots = spot.toSet();
        for (var i = 0; i < cells; i++) {
          shaded[i] = next[i];
        }
        areas = components(nb, (i) => !shaded[i]);
        spot = [
          for (final a in areas) a.firstWhere(oldSpots.contains, orElse: () => a[rng.nextInt(a.length)]),
        ];
        done = true;
        break;
      }
      if (!done) break;
      repairs++;
      cur = solveAt(tier);
      left = open(cur);
    }
    if (left > 0 || areas.length < cells ~/ 8) continue;

    // Hard: move numbers so the tier below gets stuck further back while
    // the tier still solves the board.
    if (tier == 3) {
      var behind = GladesSolver(board()).slack(2);
      for (var step = 0; step < 24 && behind < cells ~/ 3; step++) {
        final k = rng.nextInt(areas.length);
        if (areas[k].length == 1) continue;
        final old = spot[k];
        spot[k] = areas[k][rng.nextInt(areas[k].length)];
        if (spot[k] == old) continue;
        final s = GladesSolver(board());
        final got = s.slack(2);
        if (got >= behind && (got == 0 || s.slack(3) == 0)) {
          behind = got;
        } else {
          spot[k] = old;
        }
      }
    }

    final puzzle = board();
    if (tier == 1) return puzzle;
    // Score: the tier below should get stuck, the further behind the better.
    final below = GladesSolver(puzzle).slack(tier - 1);
    final score = 1 + (below > 0 ? 1000 : 0) + min(below, cells ~/ 3) * 4;
    if (best == null || score > bestScore) (best, bestScore) = (puzzle, score);
    if (below > 0 && (below >= cells ~/ 3 || ++scored >= tries)) break;
  }
  return best ?? generateGlades(params.withSeed(params.seed + 1));
}

/// The layout with cell [u] changed so the logic has more to go on, or null
/// when that breaks a rule: an unshaded [u] shades the row or column through
/// it within its rectangle (splitting or shrinking it), a shaded [u] with
/// no unshaded side neighbour becomes a one-cell area.
List<bool>? _repair(int n, List<List<int>> nb, List<bool> shaded, int u, Random rng) {
  final next = List.of(shaded);
  if (shaded[u]) {
    if (nb[u].any((j) => !shaded[j])) return null;
    next[u] = false;
  } else {
    final area = components(nb, (i) => !shaded[i]).firstWhere((a) => a.contains(u));
    final (x0, y0, x1, y1) = gladesBox(n, area);
    final ux = u % n, uy = u ~/ n;
    final lines = [
      if (x1 > x0) [for (var x = x0; x <= x1; x++) uy * n + x],
      if (y1 > y0) [for (var y = y0; y <= y1; y++) y * n + ux],
    ]..shuffle(rng);
    if (lines.isEmpty) return null;
    for (final line in lines) {
      final trial = List.of(shaded);
      for (final i in line) {
        trial[i] = true;
      }
      if (gladesLayoutOk(n, trial)) return trial;
    }
    return null;
  }
  return gladesLayoutOk(n, next) ? next : null;
}

/// Whether [shaded] is a valid layout: some unshaded cell, unshaded areas
/// are rectangles, no all-shaded 2×2 block, and the unshaded cells joined
/// through sides and corners.
bool gladesLayoutOk(int n, List<bool> shaded) {
  if (!shaded.contains(false)) return false;
  if (gladesPools(n, shaded).isNotEmpty) return false;
  final nb = orthNeighbors(n, n);
  if (!components(nb, (i) => !shaded[i]).every((a) => gladesIsRect(n, a))) return false;
  return components(kingNeighbors(n, n), (i) => !shaded[i]).length == 1;
}

/// A random valid layout with areas of at most [maxArea] cells (sides up to
/// 4). It starts from single cells on every other square, all touching at
/// corners, and walks through valid layouts: a move opens a rectangle,
/// shades the rectangles it overlaps or touches side by side, then plugs
/// every all-shaded 2×2 block with a single cell. Moves that leave a block
/// it can't plug or cut the unshaded cells apart are undone; moves that add
/// areas are mostly undone too, so the areas grow.
List<bool> gladesLayout(int n, Random rng, int maxArea) {
  final cells = n * n;
  final nb = orthNeighbors(n, n);
  final kb = kingNeighbors(n, n);
  final shaded = List<bool>.filled(cells, true);
  final owner = List<int>.filled(cells, -1);
  var rects = <int, List<int>>{};
  var nextId = 0;
  void open(List<int> r) {
    final id = nextId++;
    rects[id] = r;
    for (final i in r) {
      owner[i] = id;
      shaded[i] = false;
    }
  }

  void close(int id) {
    for (final i in rects.remove(id)!) {
      owner[i] = -1;
      shaded[i] = true;
    }
  }

  final parity = rng.nextInt(2);
  for (var i = 0; i < cells; i++) {
    if ((i % n + i ~/ n) % 2 == parity) open([i]);
  }
  final moves = 150 * n;
  final target = cells ~/ 6;
  int score() => rects.values.where((r) => r.length == 1).length + max(0, target - rects.length) * 3;
  for (var step = 0; step < moves; step++) {
    final w = 1 + rng.nextInt(4), h = 1 + rng.nextInt(4);
    if (w * h > maxArea || w * h == 1 || w > n || h > n) continue;
    final x0 = rng.nextInt(n - w + 1), y0 = rng.nextInt(n - h + 1);
    final r = [
      for (var y = y0; y < y0 + h; y++)
        for (var x = x0; x < x0 + w; x++) y * n + x,
    ];
    final savedShaded = List.of(shaded), savedOwner = List.of(owner), savedRects = Map.of(rects);
    final before = score();
    final away = <int>{
      for (final i in r) ...[
        if (owner[i] >= 0) owner[i],
        for (final j in nb[i])
          if (owner[j] >= 0) owner[j],
      ],
    };
    away.forEach(close);
    open(r);
    var ok = true;
    while (ok) {
      final pools = gladesPools(n, shaded);
      if (pools.isEmpty) break;
      final b = pools[rng.nextInt(pools.length)];
      final free = [
        for (final i in [b, b + 1, b + n, b + n + 1])
          if (nb[i].every((j) => shaded[j])) i,
      ];
      if (free.isEmpty) {
        ok = false;
      } else {
        open([free[rng.nextInt(free.length)]]);
      }
    }
    if (ok) ok = components(kb, (i) => !shaded[i]).length == 1;
    if (ok && score() > before && rng.nextInt(6) > 0) ok = false;
    if (!ok) {
      shaded.setAll(0, savedShaded);
      owner.setAll(0, savedOwner);
      rects = savedRects;
    }
  }
  return shaded;
}
