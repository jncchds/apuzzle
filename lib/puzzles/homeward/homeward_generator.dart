import 'dart:math';

import '../../core/difficulty.dart';
import 'homeward_model.dart';
import 'homeward_solver.dart';

/// Most pets on a board (one symbol each).
const homewardMaxPets = 6;

/// Pets, seats and spare fuel for a board of [rows] × [cols] at [d].
({int pets, int seats, int slack}) homewardShape(int rows, int cols, Difficulty d) {
  final s = min(rows, cols);
  return switch (d) {
    Difficulty.easy => (pets: max(2, s ~/ 2), seats: 3, slack: 4),
    Difficulty.medium => (pets: min(homewardMaxPets, s ~/ 2 + 1), seats: 3, slack: 2),
    _ => (pets: min(homewardMaxPets, s ~/ 2 + 2), seats: 2, slack: 0),
  };
}

/// A random town, then the fuel from its shortest plan. Medium and hard try
/// several towns and keep the one where heading for the nearest pet first
/// wastes the most fuel.
HomewardPuzzle generateHomeward(GenParams params) {
  final rows = params.size.rows, cols = params.size.cols;
  final rng = Random(params.seed);
  final shape = homewardShape(rows, cols, params.difficulty);
  final (tries, enough) = switch (params.difficulty) {
    Difficulty.easy => (1, 0),
    Difficulty.medium => (30, 8),
    _ => (60, 12),
  };
  HomewardPuzzle? best;
  var bestGap = -1;
  for (var t = 0; t < tries; t++) {
    final town = homewardTown(rows, cols, shape.pets, shape.seats, rng);
    final solver = HomewardSolver(town);
    final opt = solver.best();
    final gap = tries == 1 ? 0 : solver.greedy() - opt;
    if (gap > bestGap) {
      bestGap = gap;
      best = _withFuel(town, opt, shape.slack);
    }
    if (gap >= enough) break;
  }
  return best!;
}

HomewardPuzzle _withFuel(HomewardPuzzle p, int best, int slack) => HomewardPuzzle(
  rows: p.rows,
  cols: p.cols,
  roads: p.roads,
  start: p.start,
  pets: p.pets,
  homes: p.homes,
  seats: p.seats,
  limit: best + slack,
  best: best,
);

/// Roads: a random spanning tree plus about half of the other roads, so
/// there are loops to choose from. Then the car, pets and homes on distinct
/// crossings, no pet right next to its home. [HomewardPuzzle.limit]
/// and [HomewardPuzzle.best] are left 0.
HomewardPuzzle homewardTown(int rows, int cols, int pets, int seats, Random rng, {double extra = 0.5}) {
  final n = rows * cols;
  final roads = List<int>.filled(n, 0);
  final seen = List<bool>.filled(n, false);
  final first = rng.nextInt(n);
  seen[first] = true;
  final active = [first];
  while (active.isNotEmpty) {
    final k = rng.nextDouble() < 0.5 ? active.length - 1 : rng.nextInt(active.length);
    final i = active[k];
    final options = [
      for (final d in roadDirs)
        if (roadStep(i, d, rows, cols) case final j? when !seen[j]) (d, j),
    ];
    if (options.isEmpty) {
      active.removeAt(k);
      continue;
    }
    final (d, j) = options[rng.nextInt(options.length)];
    roads[i] |= d;
    roads[j] |= roadOpposite(d);
    seen[j] = true;
    active.add(j);
  }
  for (var i = 0; i < n; i++) {
    for (final d in [rE, rS]) {
      final j = roadStep(i, d, rows, cols);
      if (j == null || roads[i] & d != 0 || rng.nextDouble() >= extra) continue;
      roads[i] |= d;
      roads[j] |= roadOpposite(d);
    }
  }
  while (true) {
    final spots = List.generate(n, (i) => i)..shuffle(rng);
    final start = spots[0];
    final petAt = spots.sublist(1, 1 + pets), homes = spots.sublist(1 + pets, 1 + 2 * pets);
    var ok = true;
    for (var k = 0; k < pets && ok; k++) {
      final a = petAt[k], b = homes[k];
      if (a == b + 1 && a % cols != 0 || b == a + 1 && b % cols != 0 || (a - b).abs() == cols) ok = false;
    }
    if (!ok) continue;
    return HomewardPuzzle(
      rows: rows,
      cols: cols,
      roads: roads,
      start: start,
      pets: petAt,
      homes: homes,
      seats: seats,
      limit: 0,
      best: 0,
    );
  }
}
