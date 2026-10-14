import 'dart:math';

import '../../core/difficulty.dart';
import '../../core/grid_graph.dart';
import 'fleet_model.dart';
import 'fleet_solver.dart';

/// Ships of [fleet] at random places where they don't touch, or null when
/// one doesn't fit.
List<bool>? placeFleet(int rows, int cols, List<int> fleet, Random rng) {
  final ships = List.filled(rows * cols, false);
  final blocked = List.filled(rows * cols, false);
  final kn = kingNeighbors(rows, cols);
  for (final len in fleet) {
    final spots = <List<int>>[];
    for (var r = 0; r < rows; r++) {
      for (var c = 0; c < cols; c++) {
        for (final across in len == 1 ? const [true] : const [true, false]) {
          if (across ? c + len > cols : r + len > rows) continue;
          final cells = [for (var k = 0; k < len; k++) across ? r * cols + c + k : (r + k) * cols + c];
          if (cells.every((i) => !blocked[i])) spots.add(cells);
        }
      }
    }
    if (spots.isEmpty) return null;
    for (final i in spots[rng.nextInt(spots.length)]) {
      ships[i] = true;
      blocked[i] = true;
      for (final j in kn[i]) {
        blocked[j] = true;
      }
    }
  }
  return ships;
}

/// A random fleet and its counts; cells are shown where the difficulty's
/// tier gets stuck (mostly ship pieces, whose shape tells more), then shown
/// cells are taken back while the tier still solves the board. Hard boards
/// hide a few counts. Medium and hard prefer boards the tier below can't
/// finish.
FleetPuzzle generateFleet(GenParams params) {
  final rows = params.size.rows, cols = params.size.cols, n = rows * cols;
  final rng = Random(params.seed);
  final tier = fleetTier(params.difficulty);
  final fleet = fleetFor(rows, cols);
  FleetPuzzle? fallback;

  for (var attempt = 0; attempt < 16; attempt++) {
    List<bool>? ships;
    for (var k = 0; k < 50 && ships == null; k++) {
      ships = placeFleet(rows, cols, fleet, rng);
    }
    if (ships == null) continue;
    final layout = ships;
    List<int?> counts(List<List<int>> lines) => [for (final l in lines) l.where((i) => layout[i]).length];
    final lines = fleetLines(rows, cols);
    final rc = counts(lines.sublist(0, rows)), cc = counts(lines.sublist(rows));
    final given = <int>[];

    FleetPuzzle puzzle() => FleetPuzzle(
      rows: rows,
      cols: cols,
      ships: layout,
      rowCounts: rc,
      colCounts: cc,
      givens: List.of(given)..sort(),
    );
    List<int> attemptAt(int t) {
      final p = puzzle(), s = FleetSolver.of(p), st = fleetStart(s, p);
      s.solve(st, t);
      return st;
    }

    bool solvable(int t) => !attemptAt(t).contains(-1);

    while (true) {
      final st = attemptAt(tier);
      final open = [
        for (var i = 0; i < n; i++)
          if (st[i] == -1) i,
      ];
      if (open.isEmpty) break;
      final shipOpen = open.where((i) => layout[i]).toList();
      final pool = shipOpen.isNotEmpty && rng.nextDouble() < 0.8 ? shipOpen : open;
      given.add(pool[rng.nextInt(pool.length)]);
    }
    for (final g in List.of(given)..shuffle(rng)) {
      given.remove(g);
      if (!solvable(tier)) given.add(g);
    }
    if (params.difficulty == Difficulty.hard) {
      final hideMax = (rows + cols) ~/ 4;
      var hidden = 0;
      for (final k in [for (var k = 0; k < rows + cols; k++) k]..shuffle(rng)) {
        if (hidden >= hideMax) break;
        final list = k < rows ? rc : cc, at = k < rows ? k : k - rows;
        final keep = list[at];
        list[at] = null;
        if (solvable(tier)) {
          hidden++;
        } else {
          list[at] = keep;
        }
      }
    }
    final p = puzzle();
    if (tier >= 2 && solvable(tier - 1)) {
      fallback ??= p;
      continue;
    }
    return p;
  }
  return fallback ?? generateFleet(params.withSeed(params.seed + 1));
}
