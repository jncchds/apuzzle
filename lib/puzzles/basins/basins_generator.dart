import 'dart:math';

import '../../core/difficulty.dart';
import '../../core/grid_graph.dart';
import 'basins_model.dart';
import 'basins_solver.dart';

/// Random basins grown from random seeds, each cut in a random direction of
/// growth so tall and wide ones both show up.
List<int> randomBasins(int rows, int cols, int count, Random rng) {
  final n = rows * cols, on = orthNeighbors(rows, cols);
  final regions = List.filled(n, -1);
  final cells = [for (var i = 0; i < n; i++) i]..shuffle(rng);
  for (var k = 0; k < count; k++) {
    regions[cells[k]] = k;
  }
  final size = List.filled(count, 1);
  // Each basin leans across or down.
  final across = [for (var k = 0; k < count; k++) rng.nextDouble() * 2];
  var left = n - count;
  while (left > 0) {
    final options = <(int, int, double)>[];
    for (var i = 0; i < n; i++) {
      if (regions[i] >= 0) continue;
      for (final j in on[i]) {
        final k = regions[j];
        if (k < 0) continue;
        final side = (i - j).abs() == 1;
        options.add((i, k, ((side ? across[k] : 2 - across[k]) + 0.2) / pow(size[k], 1.5)));
      }
    }
    var t = rng.nextDouble() * options.fold(0.0, (a, o) => a + o.$3);
    var pick = options.last;
    for (final o in options) {
      t -= o.$3;
      if (t <= 0) {
        pick = o;
        break;
      }
    }
    regions[pick.$1] = pick.$2;
    size[pick.$2]++;
    left--;
  }
  return regions;
}

/// Water at a random level in every basin.
List<bool> randomLevels(int cols, List<int> regions, Random rng) {
  final count = regions.reduce(max) + 1;
  final water = List.filled(regions.length, false);
  for (var k = 0; k < count; k++) {
    _setLevel(cols, regions, water, k, rng);
  }
  return water;
}

/// A new random level for basin [k] (another one where it can).
void _setLevel(int cols, List<int> regions, List<bool> water, int k, Random rng) {
  final cells = [
    for (var i = 0; i < regions.length; i++)
      if (regions[i] == k) i,
  ];
  final heights = {for (final i in cells) i ~/ cols}.toList()..sort();
  final now = heights.where((h) => cells.any((i) => i ~/ cols == h && water[i])).length;
  var level = rng.nextInt(heights.length + 1);
  if (level == now && heights.isNotEmpty) level = (level + 1 + rng.nextInt(heights.length)) % (heights.length + 1);
  // Level = how many of the lowest heights hold water.
  final top = level == 0 ? 1 << 30 : heights[heights.length - level];
  for (final i in cells) {
    water[i] = i ~/ cols >= top;
  }
}

/// Random basins at random levels, then a local search: where the
/// difficulty's tier gets stuck, a stuck cell's basin gets a new level or
/// the cell moves to a neighbouring basin, kept when the logic gets no
/// further behind. Medium and hard then push away from the tier below the
/// same way, with many more attempts (small boards rarely need the whole
/// tier). Hard hides a few counts. Cells still open at the end are shown
/// from the start.
BasinsPuzzle generateBasins(GenParams params) {
  final rows = params.size.rows, cols = params.size.cols, n = rows * cols;
  final rng = Random(params.seed);
  final tier = basinsTier(params.difficulty);
  final on = orthNeighbors(rows, cols);
  BasinsPuzzle? fallback;
  var fallbackGrade = 0;

  for (var attempt = 0; attempt < (tier > 1 ? 160 : 16); attempt++) {
    final regions = randomBasins(rows, cols, (n / (4 + rng.nextDouble() * 1.5)).round(), rng);
    final water = randomLevels(cols, regions, rng);
    List<int?> rc = const [], cc = const [];
    void recount() {
      final lines = basinsLines(rows, cols);
      rc = [for (final l in lines.sublist(0, rows)) l.where((i) => water[i]).length];
      cc = [for (final l in lines.sublist(rows)) l.where((i) => water[i]).length];
    }

    recount();
    BasinsPuzzle board([List<int> givens = const []]) => BasinsPuzzle(
      rows: rows,
      cols: cols,
      regions: List.of(regions),
      water: List.of(water),
      rowCounts: List.of(rc),
      colCounts: List.of(cc),
      givens: givens,
    );
    List<int> stuck(int t) {
      final p = board(), s = BasinsSolver.of(p), st = s.start();
      s.solve(st, t);
      return [
        for (var i = 0; i < n; i++)
          if (st[i] == -1) i,
      ];
    }

    // Changes around cell [i]; returns the undo.
    void Function() mutate(int i) {
      final oldRegions = List.of(regions), oldWater = List.of(water);
      final from = regions[i];
      final to = [
        for (final j in on[i])
          if (regions[j] != from) regions[j],
      ];
      if (to.isNotEmpty && rng.nextInt(2) == 0 && _canLeave(regions, on, i)) {
        regions[i] = to[rng.nextInt(to.length)];
        // The basin it joins keeps its level.
        final level = [
          for (var j = 0; j < n; j++)
            if (regions[j] == regions[i] && j != i && water[j]) j ~/ cols,
        ];
        water[i] = level.isNotEmpty && i ~/ cols >= level.reduce(min);
        _settle(cols, regions, water, from);
      } else {
        _setLevel(cols, regions, water, from, rng);
      }
      recount();
      return () {
        regions.setAll(0, oldRegions);
        water.setAll(0, oldWater);
        recount();
      };
    }

    var open = stuck(tier);
    for (var step = 0; step < n * 3 && open.isNotEmpty; step++) {
      final undo = mutate(open[rng.nextInt(open.length)]);
      final next = stuck(tier);
      if (next.length <= open.length) {
        open = next;
      } else {
        undo();
      }
    }
    if (open.length > n ~/ 10 && attempt < 8) continue;

    // Harder: make the tier below get stuck, keeping the tier itself happy.
    if (tier > 1 && open.isEmpty) {
      var below = stuck(tier - 1).length;
      for (var step = 0; step < n * 6 && below < max(4, n ~/ 5); step++) {
        final undo = mutate(rng.nextInt(n));
        final b = stuck(tier - 1).length;
        if (b >= below && stuck(tier).isEmpty) {
          below = b;
        } else {
          undo();
        }
      }
    }

    // Region ids from 0 in reading order.
    final ids = <int, int>{};
    for (var i = 0; i < n; i++) {
      regions[i] = ids.putIfAbsent(regions[i], () => ids.length);
    }

    bool solvable(List<int> givens) {
      final p = board(givens), s = BasinsSolver.of(p), st = basinsStart(s, p);
      return s.solve(st, tier);
    }

    final givens = <int>[];
    while (true) {
      final p = board(givens), s = BasinsSolver.of(p), st = basinsStart(s, p);
      s.solve(st, tier);
      final left = [
        for (var i = 0; i < n; i++)
          if (st[i] == -1) i,
      ];
      if (left.isEmpty) break;
      final wet = left.where((i) => water[i]).toList();
      final pool = wet.isNotEmpty && rng.nextBool() ? wet : left;
      givens.add(pool[rng.nextInt(pool.length)]);
    }
    for (final g in List.of(givens)..shuffle(rng)) {
      givens.remove(g);
      if (!solvable(givens)) givens.add(g);
    }
    if (params.difficulty == Difficulty.hard) {
      final hideMax = (rows + cols) ~/ 5;
      var hidden = 0, tries = 0;
      for (final k in [for (var k = 0; k < rows + cols; k++) k]..shuffle(rng)) {
        if (hidden >= hideMax || tries++ >= 2 * hideMax) break;
        final list = k < rows ? rc : cc, at = k < rows ? k : k - rows;
        final keep = list[at];
        list[at] = null;
        if (solvable(givens)) {
          hidden++;
        } else {
          list[at] = keep;
        }
      }
    }
    final puzzle = board(givens..sort());
    if (tier > 1) {
      final s = BasinsSolver.of(puzzle);
      final grade = s.grade(basinsStart(s, puzzle));
      if (grade < tier) {
        if (grade > fallbackGrade) (fallback, fallbackGrade) = (puzzle, grade);
        continue;
      }
    }
    return puzzle;
  }
  return fallback ?? generateBasins(params.withSeed(params.seed + 1));
}

/// Whether cell [i] can leave its basin: the rest stays one piece.
bool _canLeave(List<int> regions, List<List<int>> on, int i) {
  final k = regions[i];
  final rest = [
    for (var j = 0; j < regions.length; j++)
      if (regions[j] == k && j != i) j,
  ];
  if (rest.isEmpty) return false;
  final seen = {rest.first};
  final queue = [rest.first];
  while (queue.isNotEmpty) {
    final c = queue.removeLast();
    for (final d in on[c]) {
      if (d != i && regions[d] == k && seen.add(d)) queue.add(d);
    }
  }
  return seen.length == rest.length;
}

/// Basin [k]'s water level made whole again: every cell as low as its highest wet cell holds water.
void _settle(int cols, List<int> regions, List<bool> water, int k) {
  final wet = [
    for (var i = 0; i < regions.length; i++)
      if (regions[i] == k && water[i]) i ~/ cols,
  ];
  if (wet.isEmpty) return;
  final top = wet.reduce(min);
  for (var i = 0; i < regions.length; i++) {
    if (regions[i] == k) water[i] = i ~/ cols >= top;
  }
}
