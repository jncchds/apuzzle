import 'package:apuzzle/core/difficulty.dart';
import 'package:apuzzle/core/grid.dart';
import 'package:apuzzle/puzzles/fleet/fleet_generator.dart';
import 'package:apuzzle/puzzles/fleet/fleet_model.dart';
import 'package:apuzzle/puzzles/fleet/fleet_solver.dart';
import 'package:apuzzle/puzzles/fleet/fleet_tutorial.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/timing.dart';

void main() {
  // S S . .
  // . . . S
  // . . . .
  final p = FleetPuzzle(
    rows: 3,
    cols: 4,
    ships: [true, true, false, false, false, false, false, true, false, false, false, false],
    rowCounts: [2, 1, 0],
    colCounts: [1, 1, 0, 1],
    givens: [0],
  );

  test('fleet and shapes come from the solution', () {
    expect(p.fleet, [2, 1]);
    expect(p.shapeOf(0), sideRight);
    expect(p.shapeOf(7), 0);
  });

  test('conflicts: touching, counts, lengths and shown pieces', () {
    List<int> board(String s) => [
      for (final ch in s.replaceAll('|', '').split('')) ch == 'S' ? fleetShip : (ch == '~' ? fleetWater : -1),
    ];
    expect(
      fleetConflicts(p, board('SS..|...S|....'), complete: true),
      isEmpty,
    );
    // Diagonal touch.
    expect(
      fleetConflicts(p, board('S...|.S..|....'), complete: false),
      containsAll([0, 5]),
    );
    // Water where the shown end piece goes on.
    expect(
      fleetConflicts(p, board('S~..|....|....'), complete: false),
      {0},
    );
    // A ship longer than the fleet's longest, and too many in row 1.
    expect(
      fleetConflicts(p, board('SSS.|....|....'), complete: false),
      containsAll([0, 1, 2]),
    );
    // Not complete: counts aren't flagged until then.
    expect(
      fleetConflicts(p, board('S...|....|....'), complete: false),
      isEmpty,
    );
  });

  test('strategy boards need their technique', () {
    for (final params in fleetStrategyParams) {
      final q = generateFleet(params);
      final s = FleetSolver.of(q);
      expect(s.grade(fleetStart(s, q)), fleetTier(params.difficulty));
    }
  });

  for (final n in [6, 7, 8, 9, 10]) {
    for (final d in [Difficulty.easy, Difficulty.medium, Difficulty.hard]) {
      test('fleet ${n}x$n ${d.name}: valid, unique, tiered, deterministic', () {
        final info = <String>[];
        final tier = fleetTier(d);
        for (var seed = 1; seed <= 4; seed++) {
          final params = GenParams(size: GridSize.square(n), difficulty: d, seed: seed);
          final sw = Stopwatch()..start();
          final p = generateFleet(params);
          sw.stop();
          expect(p.fleet, fleetFor(n, n));
          final v = [for (final s in p.ships) s ? fleetShip : fleetWater];
          expect(fleetConflicts(p, v, complete: true), isEmpty);
          final s = FleetSolver.of(p);
          final grade = s.grade(fleetStart(s, p));
          expect(grade, lessThanOrEqualTo(tier));
          final st = fleetStart(s, p);
          expect(s.solve(st, tier), isTrue);
          expect([for (final x in st) x == fleetShip], p.ships);
          expect(s.countSolutions(fleetStart(s, p)), 1);
          if (seed == 1) expect(generateFleet(params).toJson(), p.toJson(), reason: 'not deterministic');
          expect(FleetPuzzle.fromJson(p.toJson()).toJson(), p.toJson());
          expect(sw.elapsedMilliseconds, lessThan(timeLimit(3000)));
          info.add(
            '${sw.elapsedMilliseconds}ms grade $grade givens ${p.givens.length} hidden ${[...p.rowCounts, ...p.colCounts].where((c) => c == null).length}',
          );
        }
        // ignore: avoid_print
        print('fleet $n ${d.name}: $info');
      });
    }
  }
}
