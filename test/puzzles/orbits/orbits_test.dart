import 'package:apuzzle/core/difficulty.dart';
import 'package:apuzzle/core/grid.dart';
import 'package:apuzzle/puzzles/orbits/orbits_generator.dart';
import 'package:apuzzle/puzzles/orbits/orbits_model.dart';
import 'package:apuzzle/puzzles/orbits/orbits_solver.dart';
import 'package:apuzzle/puzzles/orbits/orbits_tutorial.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/timing.dart';

void main() {
  for (final n in [5, 6, 8, 10]) {
    for (final d in [Difficulty.easy, Difficulty.medium, Difficulty.hard]) {
      test('orbits ${n}x$n ${d.name}: valid, unique, tiered, deterministic', () {
        final info = <String>[];
        for (var seed = 1; seed <= 6; seed++) {
          final params = GenParams(size: GridSize.square(n), difficulty: d, seed: seed);
          final sw = Stopwatch()..start();
          final p = generateOrbits(params);
          sw.stop();
          final g = p.geo;
          expect(g.valid(p.solution), isTrue);
          // A star lies on its own region.
          for (var i = 0; i < g.n; i++) {
            if (g.home[i] >= 0) expect(p.solution[i], g.home[i]);
          }
          final s = OrbitsSolver(g);
          final c = s.start();
          expect(s.solve(c, d.index + 1), isTrue);
          expect(s.owners(c), p.solution);
          if (n <= 8) expect(s.countSolutions(), 1);
          if (seed == 1) expect(generateOrbits(params).toJson(), p.toJson());
          expect(OrbitsPuzzle.fromJson(p.toJson()).toJson(), p.toJson());
          expect(sw.elapsedMilliseconds, lessThan(timeLimit(3000)));
          info.add('${sw.elapsedMilliseconds}ms t${s.grade()} stars ${g.count}');
        }
        // ignore: avoid_print
        print('orbits $n ${d.name}: $info');
      });
    }
  }

  test('painting keeps regions symmetric', () {
    final p = generateOrbits(const GenParams(size: GridSize.square(6), difficulty: Difficulty.medium, seed: 2));
    final g = p.geo;
    var owner = g.initial();
    // Every cell given to every star that fits, in turn: twins follow, and the stars' own cells stay.
    for (var k = 0; k < g.count; k++) {
      for (var i = 0; i < g.n; i++) {
        owner = g.paint(owner, i, k) ?? owner;
        for (var j = 0; j < g.n; j++) {
          if (g.home[j] >= 0) expect(owner[j], g.home[j]);
          if (owner[j] >= 0) expect(owner[g.twin(j, owner[j])], owner[j]);
        }
      }
    }
    // Clearing a cell clears its twin, but never a star's own cell.
    final i = [for (var i = 0; i < g.n; i++) i].firstWhere((i) => g.home[i] < 0 && owner[i] >= 0);
    final twin = g.twin(i, owner[i]);
    final cleared = g.paint(owner, i, -1)!;
    expect(cleared[i], -1);
    expect(cleared[twin], -1);
    expect(g.paint(owner, g.core[0].first, -1), isNull);
  });

  test('a region in two pieces or without its twin is a conflict', () {
    final p = orbitsTutorial[1].puzzle as OrbitsPuzzle;
    final g = p.geo;
    expect(g.bad(p.solution), isEmpty);
    // Swap two cells of different regions: both lose their twins.
    final a = [for (var i = 0; i < g.n; i++) i].firstWhere((i) => g.home[i] < 0);
    final b = [for (var i = 0; i < g.n; i++) i].firstWhere((i) => g.home[i] < 0 && p.solution[i] != p.solution[a]);
    final owner = List.of(p.solution)
      ..[a] = p.solution[b]
      ..[b] = p.solution[a];
    expect(g.bad(owner), containsAll([a, b]));
    expect(g.valid(owner), isFalse);
  });

  test('tutorial boards have one solution, strategy boards need their technique', () {
    for (final step in orbitsTutorial.take(3)) {
      expect(OrbitsSolver((step.puzzle as OrbitsPuzzle).geo).countSolutions(), 1);
    }
    expect(OrbitsSolver((orbitsStrategies[0].puzzle as OrbitsPuzzle).geo).grade(), 2);
    expect(OrbitsSolver((orbitsStrategies[1].puzzle as OrbitsPuzzle).geo).grade(), 3);
  });
}
