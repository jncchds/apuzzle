import 'dart:math';

import '../../core/difficulty.dart';
import 'parcels_model.dart';
import 'parcels_solver.dart';

int parcelsTier(Difficulty d) => switch (d) {
  Difficulty.easy => 1,
  Difficulty.medium => 2,
  _ => 3,
};

/// A random split of the board into regions of [k] cells (the region of
/// every cell), or null when it paints itself into a corner. Each region
/// starts at the free cell with the fewest free neighbours and grows at
/// random; it is kept only while every free area left holds whole regions.
List<int>? parcelsLayout(ParcelsGeo geo, int k, Random rng) {
  final n = geo.n;
  final region = List<int>.filled(n, -1);
  int freeAround(int i) => geo.links[i].where((l) => region[l.$1] < 0).length;

  bool areasFit() {
    final seen = List<bool>.filled(n, false);
    for (var s = 0; s < n; s++) {
      if (region[s] >= 0 || seen[s]) continue;
      seen[s] = true;
      final queue = [s];
      for (var q = 0; q < queue.length; q++) {
        for (final (j, _) in geo.links[queue[q]]) {
          if (region[j] < 0 && !seen[j]) {
            seen[j] = true;
            queue.add(j);
          }
        }
      }
      if (queue.length % k != 0) return false;
    }
    return true;
  }

  for (var id = 0; id < n ~/ k; id++) {
    var fewest = 5;
    final starts = <int>[];
    for (var i = 0; i < n; i++) {
      if (region[i] >= 0) continue;
      final f = freeAround(i);
      if (f < fewest) {
        fewest = f;
        starts.clear();
      }
      if (f == fewest) starts.add(i);
    }
    final start = starts[rng.nextInt(starts.length)];
    var placed = false;
    for (var tries = 0; tries < 40 && !placed; tries++) {
      final cells = [start];
      region[start] = id;
      while (cells.length < k) {
        final options = <int>[];
        for (final i in cells) {
          for (final (j, _) in geo.links[i]) {
            if (region[j] < 0) options.add(j);
          }
        }
        if (options.isEmpty) break;
        // Cells next to several of the region come up more often: rounder.
        final j = options[rng.nextInt(options.length)];
        region[j] = id;
        cells.add(j);
      }
      if (cells.length == k && areasFit()) {
        placed = true;
      } else {
        for (final i in cells) {
          region[i] = -1;
        }
      }
    }
    if (!placed) return null;
  }
  return region;
}

/// Cuts the cells of regions [r1] and [r2] in two new connected regions of
/// [k] cells at random; false if that found no other cut.
bool parcelsResplit(ParcelsGeo geo, int k, List<int> region, int r1, int r2, Random rng) {
  final cells = [
    for (var i = 0; i < geo.n; i++)
      if (region[i] == r1 || region[i] == r2) i,
  ];
  final inUnion = {...cells};
  for (var tries = 0; tries < 24; tries++) {
    final start = cells[rng.nextInt(cells.length)];
    final part = <int>{start};
    while (part.length < k) {
      final options = [
        for (final i in part)
          for (final (j, _) in geo.links[i])
            if (inUnion.contains(j) && !part.contains(j)) j,
      ];
      if (options.isEmpty) break;
      part.add(options[rng.nextInt(options.length)]);
    }
    if (part.length < k) continue;
    // The same cut as before?
    final firstRegion = region[part.first];
    if (part.every((i) => region[i] == firstRegion)) continue;
    // The rest must be one piece.
    final rest = inUnion.difference(part);
    final seen = <int>{rest.first};
    final queue = [rest.first];
    for (var q = 0; q < queue.length; q++) {
      for (final (j, _) in geo.links[queue[q]]) {
        if (rest.contains(j) && seen.add(j)) queue.add(j);
      }
    }
    if (seen.length != rest.length) continue;
    for (final i in part) {
      region[i] = r1;
    }
    for (final i in rest) {
      region[i] = r2;
    }
    return true;
  }
  return false;
}

/// The edges [tier] leaves open on the board of [region] with every number
/// shown.
List<int> _stuck(ParcelsGeo geo, int k, List<int> region, int tier) {
  final p = ParcelsPuzzle(rows: geo.rows, cols: geo.cols, k: k, clues: parcelsCounts(geo, region), regions: region);
  final s = ParcelsSolver(p);
  final st = s.start();
  s.solve(st, tier);
  return [
    for (final e in geo.inner)
      if (st[e] == -1) e,
  ];
}

/// A local search on [region]: two regions by an edge [tier] can't settle
/// (with every number shown) are cut anew, kept while no more edges stay
/// open. True once the tier settles every edge.
bool parcelsRepair(ParcelsGeo geo, int k, List<int> region, int tier, Random rng, int steps) {
  var open = _stuck(geo, k, region, tier);
  for (var step = 0; step < steps && open.isNotEmpty; step++) {
    final (a, b) = geo.cellsOf[open[rng.nextInt(open.length)]];
    final r1 = region[a];
    var r2 = region[b];
    if (r1 == r2) {
      final others = [
        for (var i = 0; i < geo.n; i++)
          if (region[i] == r1)
            for (final (j, _) in geo.links[i])
              if (region[j] != r1) region[j],
      ];
      if (others.isEmpty) continue;
      r2 = others[rng.nextInt(others.length)];
    }
    final old = List.of(region);
    if (!parcelsResplit(geo, k, region, r1, r2, rng)) continue;
    final next = _stuck(geo, k, region, tier);
    if (next.length <= open.length) {
      open = next;
    } else {
      region.setAll(0, old);
    }
  }
  return open.isEmpty;
}

/// Random regions, repaired until the tier settles them with every number
/// shown ([parcelsRepair]), numbers stripped in random
/// order while the difficulty's tier still solves the board (hard strips
/// with tier 2 first, then tries a few more with probing). Medium keeps the
/// board the tier below gets least far on, of a few tries; medium and hard
/// look on (up to [_attempts] layouts) until the tier below can't finish.
ParcelsPuzzle generateParcels(GenParams params) {
  final rows = params.size.rows, cols = params.size.cols;
  final k = parcelsRegionSize(rows, cols);
  final geo = ParcelsGeo.of(rows, cols);
  final rng = Random(params.seed);
  final tier = parcelsTier(params.difficulty);
  final tries = tier == 2 ? (geo.n > 64 ? 1 : 4) : 1;
  ParcelsPuzzle? best;
  var bestOpen = -1;
  for (var attempt = 0; attempt < _attempts && (best == null || attempt < tries || bestOpen == 0); attempt++) {
    final regions = parcelsLayout(geo, k, rng);
    if (regions == null || !parcelsRepair(geo, k, regions, min(tier, 2), rng, geo.n * 2)) continue;
    final clues = <int?>[...parcelsCounts(geo, regions)];
    ParcelsPuzzle board() => ParcelsPuzzle(rows: rows, cols: cols, k: k, clues: List.of(clues), regions: regions);
    bool solves(int t) {
      final s = ParcelsSolver(board());
      return s.solve(s.start(), t);
    }

    final order = [for (var i = 0; i < geo.n; i++) i]..shuffle(rng);
    for (final i in order) {
      final was = clues[i];
      clues[i] = null;
      if (!solves(min(tier, 2))) clues[i] = was;
    }
    if (tier == 1) return board();
    var open = 0;
    if (tier == 3) {
      // Probing costs: try a few numbers only, and stop once a few more go
      // (tier 2 can't finish the board then).
      var tried = 0;
      for (final i in order.reversed) {
        final was = clues[i];
        if (was == null) continue;
        if (++tried > (geo.n > 64 ? 5 : 8) || open >= 3) break;
        clues[i] = null;
        // A second solution fails fast; probing a board that has one is slow.
        final s = ParcelsSolver(board());
        if (s.countSolutions(s.start()) == 1 && solves(3)) {
          open++;
        } else {
          clues[i] = was;
        }
      }
    } else {
      final s = ParcelsSolver(board());
      final st = s.start();
      s.solve(st, 1);
      open = st.where((x) => x == -1).length;
    }
    if (open > bestOpen) {
      best = board();
      bestOpen = open;
    }
    if (tier == 3 && open > 0) break;
  }
  return best ?? generateParcels(params.withSeed(params.seed + 1));
}

const _attempts = 60;
