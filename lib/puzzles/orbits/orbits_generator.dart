import 'dart:math';

import '../../core/difficulty.dart';
import '../../core/grid_graph.dart';
import 'orbits_model.dart';
import 'orbits_solver.dart';

/// Random symmetric regions → a star in the middle of each → kept if logic
/// at the difficulty's tier solves the board (the solver is sound, so that
/// also proves the solution unique). Where logic stalls, a region with an
/// undecided cell is redrawn in smaller pieces: more stars, more to go on.
/// Of the boards that pass, one that needs its tier and has few one-cell
/// regions wins.
OrbitsPuzzle generateOrbits(GenParams params) {
  final rows = params.size.rows, cols = params.size.cols, n = rows * cols;
  final rng = Random(params.seed);
  final d = params.difficulty;
  final tier = switch (d) {
    Difficulty.easy => 1,
    Difficulty.medium => 2,
    _ => 3,
  };
  final maxSize = switch (d) {
    Difficulty.easy => 8,
    Difficulty.medium => 12,
    _ => 16,
  };
  // One-cell regions solve themselves: only a few are welcome.
  final fewOnes = max(2, n ~/ 12);
  OrbitsPuzzle? best;
  var bestScore = -1 << 30;

  // Small boards rarely need the harder tiers, and are quick to try.
  final attempts = n <= 49 ? 200 : 40;
  for (var attempt = 0; attempt < attempts; attempt++) {
    final region = List<int>.filled(n, -1);
    _fill(rows, cols, region, rng, maxSize);
    var puzzle = orbitsFromRegions(rows, cols, region);
    var grade = OrbitsSolver(puzzle.geo).grade();
    // Where the logic can't settle a cell, its region is redrawn in smaller pieces.
    for (var fix = 0; fix < 12 && (grade == 0 || grade > tier); fix++) {
      final solver = OrbitsSolver(puzzle.geo);
      final c = solver.start();
      solver.solve(c, tier);
      final open = [
        for (var i = 0; i < n; i++)
          if (solver.options(c, i) != 1) i,
      ];
      if (open.isEmpty) break;
      final id = region[open[rng.nextInt(open.length)]];
      final size = region.where((x) => x == id).length;
      for (var i = 0; i < n; i++) {
        if (region[i] == id) region[i] = -1;
      }
      _fill(rows, cols, region, rng, max(1, size ~/ 2), cap: size - 1);
      puzzle = orbitsFromRegions(rows, cols, region);
      grade = OrbitsSolver(puzzle.geo).grade();
    }
    if (grade == 0 || grade > tier) continue;
    final sizes = List<int>.filled(puzzle.stars.length, 0);
    for (final k in puzzle.solution) {
      sizes[k]++;
    }
    final ones = sizes.where((x) => x == 1).length;
    if (grade == tier && ones <= fewOnes) return puzzle;
    final score = grade * 1000 - max<int>(0, ones - fewOnes);
    if (score > bestScore) {
      best = puzzle;
      bestScore = score;
    }
  }
  return best ?? generateOrbits(params.withSeed(params.seed + 7919));
}

/// Fills the free cells (-1) of [region] with connected regions of up to
/// about [maxSize] cells, each symmetric under a half turn around its middle
/// and holding that middle, none bigger than [cap]. Ids are arbitrary.
void _fill(int rows, int cols, List<int> region, Random rng, int maxSize, {int cap = 1 << 30}) {
  final nb = orthNeighbors(rows, cols);
  var next = region.reduce(max) + 1;
  final points = [
    for (var y = 1; y < 2 * rows; y++)
      for (var x = 1; x < 2 * cols; x++) (y, x),
  ]..shuffle(rng);
  for (final (y, x) in points) {
    final core = [
      for (var r = (y - 1) >> 1; r <= y >> 1; r++)
        for (var c = (x - 1) >> 1; c <= x >> 1; c++) r * cols + c,
    ];
    if (core.length > cap || core.any((i) => region[i] >= 0)) continue;
    final id = next++;
    final cells = [...core];
    for (final i in core) {
      region[i] = id;
    }
    int twin(int i) {
      final r = y - 1 - i ~/ cols, c = x - 1 - i % cols;
      return r < 0 || c < 0 || r >= rows || c >= cols ? -1 : r * cols + c;
    }

    final want = min(core.length + rng.nextInt(maxSize), cap);
    while (cells.length + 2 <= want) {
      final grow = <int>{
        for (final i in cells)
          for (final j in nb[i])
            if (region[j] < 0 && twin(j) >= 0 && region[twin(j)] < 0) j,
      }.toList();
      if (grow.isEmpty) break;
      final i = grow[rng.nextInt(grow.length)];
      region[i] = id;
      region[twin(i)] = id;
      cells
        ..add(i)
        ..add(twin(i));
    }
  }
  _merge(rows, cols, region, rng, maxSize);
}

/// Joins small regions to a neighbour where the two together are symmetric,
/// so fewer one- and two-cell regions are left.
void _merge(int rows, int cols, List<int> region, Random rng, int maxSize) {
  final nb = orthNeighbors(rows, cols);
  for (var pass = 0; pass < 3; pass++) {
    final byId = <int, List<int>>{};
    for (var i = 0; i < region.length; i++) {
      (byId[region[i]] ??= []).add(i);
    }
    final small = [
      for (final e in byId.entries)
        if (e.value.length <= 2) e.key,
    ]..shuffle(rng);
    var merged = false;
    for (final id in small) {
      final cells = byId[id];
      if (cells == null) continue;
      final others = <int>{
        for (final i in cells)
          for (final j in nb[i])
            if (region[j] != id) region[j],
      }.toList()..shuffle(rng);
      for (final o in others) {
        final all = [...cells, ...byId[o]!];
        if (all.length > maxSize || !_symmetric(rows, cols, all)) continue;
        for (final i in cells) {
          region[i] = o;
        }
        byId[o] = all;
        byId.remove(id);
        merged = true;
        break;
      }
    }
    if (!merged) break;
  }
}

/// The middle of [cells]' bounding box, on the star lattice.
(int, int) _middle(int cols, List<int> cells) {
  var r0 = 1 << 30, r1 = -1, c0 = 1 << 30, c1 = -1;
  for (final i in cells) {
    r0 = min(r0, i ~/ cols);
    r1 = max(r1, i ~/ cols);
    c0 = min(c0, i % cols);
    c1 = max(c1, i % cols);
  }
  return (r0 + r1 + 1, c0 + c1 + 1);
}

bool _symmetric(int rows, int cols, List<int> cells) {
  final (y, x) = _middle(cols, cells);
  final set = cells.toSet();
  for (var r = (y - 1) >> 1; r <= y >> 1; r++) {
    for (var c = (x - 1) >> 1; c <= x >> 1; c++) {
      if (!set.contains(r * cols + c)) return false;
    }
  }
  return cells.every((i) => set.contains((y - 1 - i ~/ cols) * cols + x - 1 - i % cols));
}

/// The puzzle whose regions are [region] (symmetric ones): a star in
/// the middle of each, numbered in reading order.
OrbitsPuzzle orbitsFromRegions(int rows, int cols, List<int> region) {
  final byId = <int, List<int>>{};
  for (var i = 0; i < region.length; i++) {
    (byId[region[i]] ??= []).add(i);
  }
  final stars = <int, int>{
    for (final e in byId.entries) e.key: _middle(cols, e.value).$1 * 2 * cols + _middle(cols, e.value).$2,
  };
  final order = stars.values.toList()..sort();
  return OrbitsPuzzle(
    rows: rows,
    cols: cols,
    stars: order,
    solution: [for (final id in region) order.indexOf(stars[id]!)],
  );
}
