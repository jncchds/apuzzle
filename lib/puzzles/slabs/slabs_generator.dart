import 'dart:math';

import '../../core/difficulty.dart';
import '../../core/grid_graph.dart';
import 'slabs_model.dart';
import 'slabs_solver.dart';

int slabsTier(Difficulty d) => switch (d) {
  Difficulty.easy => 1,
  Difficulty.medium => 2,
  _ => 3,
};

/// A random layout (shaded rectangles that never touch side by side, the
/// unshaded areas none of them rectangles and not too big), the size of its
/// area on every cell, then numbers taken away in random order while the
/// difficulty's tier still solves the board (on hard first with tier 2,
/// then with probing). Medium and hard keep the best of several boards by
/// how far the tier below gets.
SlabsPuzzle generateSlabs(GenParams params) {
  final n = params.size.rows, cells = n * n;
  final rng = Random(params.seed);
  final tier = slabsTier(params.difficulty);
  final nb = orthNeighbors(n, n);
  final tries = switch (params.difficulty) {
    Difficulty.easy => 1,
    Difficulty.medium => 6,
    _ => 8,
  };
  // No `-1 << 30` sentinel: on the web shifts give unsigned 32-bit results.
  SlabsPuzzle? best;
  var bestScore = 0, scored = 0;

  for (var attempt = 0; attempt < 60; attempt++) {
    final shaded = slabsLayout(n, nb, rng);
    final clues = List<int?>.filled(cells, null);
    for (final area in slabsAreas(n, shaded)) {
      for (final i in area) {
        clues[i] = area.length;
      }
    }
    SlabsPuzzle board() => SlabsPuzzle(n: n, clues: List.of(clues), shaded: shaded);
    bool solves(int t) => SlabsSolver(board()).slack(t) == 0;
    if (!solves(tier)) continue;

    final order = [for (var i = 0; i < cells; i++) i]..shuffle(rng);
    for (final t in {min(tier, 2), tier}) {
      if (!solves(t)) continue;
      for (final i in order) {
        final keep = clues[i];
        if (keep == null) continue;
        clues[i] = null;
        if (!solves(t)) clues[i] = keep;
      }
    }
    final puzzle = board();
    if (tier == 1) return puzzle;
    // Score: the tier below should get stuck, the further behind the better.
    final below = SlabsSolver(puzzle).slack(tier - 1);
    final score = 1 + (below > 0 ? 1000 : 0) + min(below, cells ~/ 3) * 4;
    if (best == null || score > bestScore) (best, bestScore) = (puzzle, score);
    if (below >= cells ~/ 3 || ++scored >= tries) break;
  }
  return best ?? _fallback(n, nb, rng);
}

/// Never needed so far: a board with every number shown.
SlabsPuzzle _fallback(int n, List<List<int>> nb, Random rng) {
  final shaded = slabsLayout(n, nb, rng);
  final clues = List<int?>.filled(n * n, null);
  for (final area in slabsAreas(n, shaded)) {
    for (final i in area) {
      clues[i] = area.length;
    }
  }
  return SlabsPuzzle(n: n, clues: clues, shaded: shaded);
}

/// A valid shading: shaded rectangles (sides up to 3, at most 6 cells) that
/// never touch side by side, every unshaded area not a rectangle and at most
/// 1.5 [n] + 2 cells. A local search adds and takes away rectangles (often
/// next to or inside an unshaded area that breaks a rule) while the penalty
/// (rectangular or too big unshaded areas) gets no worse, and now and then
/// even when it does.
List<bool> slabsLayout(int n, List<List<int>> nb, Random rng) {
  final cap = n + n ~/ 2 + 2;
  while (true) {
    final shaded = List<bool>.filled(n * n, false);
    final rects = <List<int>>[];
    var bad = <List<int>>[];
    (int, List<List<int>>) penalty() {
      var pen = 0;
      final wrong = <List<int>>[];
      for (final area in components(nb, (i) => !shaded[i])) {
        final rect = slabsIsRect(n, area);
        if (rect) pen += 6;
        if (area.length > cap) pen += area.length - cap;
        if (rect || area.length > cap) wrong.add(area);
      }
      return (pen, wrong);
    }

    var (pen, _) = penalty();
    bad = penalty().$2;
    bool tryMove(List<int> r, bool add, bool bold) {
      for (final i in r) {
        shaded[i] = add;
      }
      final (next, wrong) = penalty();
      if (next <= pen || bold) {
        pen = next;
        bad = wrong;
        return true;
      }
      for (final i in r) {
        shaded[i] = !add;
      }
      return false;
    }

    void remove(int k, bool bold) {
      if (tryMove(rects[k], false, bold)) rects.removeAt(k);
    }

    void add(int x0, int y0, int w, int h, bool bold) {
      if (x0 < 0 || y0 < 0 || x0 + w > n || y0 + h > n) return;
      final r = [
        for (var y = y0; y < y0 + h; y++)
          for (var x = x0; x < x0 + w; x++) y * n + x,
      ];
      // Free, and touching no other shaded cell side by side.
      if (r.any((i) => shaded[i] || nb[i].any((j) => shaded[j] && !r.contains(j)))) return;
      if (tryMove(r, true, bold)) rects.add(r);
    }

    for (var step = 0; step < 300 * n && pen > 0; step++) {
      // Now and then a worse move, to get out of dead ends.
      final bold = rng.nextInt(20) == 0;
      final w = 1 + rng.nextInt(3), h = 1 + rng.nextInt(3);
      if (w * h > 6 || (w * h == 1 && rng.nextBool())) continue;
      if (bad.isNotEmpty && rng.nextBool()) {
        final area = bad[rng.nextInt(bad.length)];
        if (slabsIsRect(n, area)) {
          // Open up a rectangle beside it.
          final inArea = area.toSet();
          final near = [
            for (var k = 0; k < rects.length; k++)
              if (rects[k].any((i) => nb[i].any(inArea.contains))) k,
          ];
          if (near.isNotEmpty) remove(near[rng.nextInt(near.length)], bold);
        } else {
          // Cut into it.
          final c = area[rng.nextInt(area.length)];
          add(c % n - rng.nextInt(w), c ~/ n - rng.nextInt(h), w, h, bold);
        }
        continue;
      }
      if (rects.isNotEmpty && rng.nextInt(10) < 3) {
        remove(rng.nextInt(rects.length), bold);
      } else {
        add(rng.nextInt(n - w + 1), rng.nextInt(n - h + 1), w, h, bold);
      }
    }
    if (pen == 0) return shaded;
  }
}
