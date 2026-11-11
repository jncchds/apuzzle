import 'package:apuzzle/core/difficulty.dart';
import 'package:apuzzle/core/grid.dart';
import 'package:apuzzle/puzzles/parcels/parcels_generator.dart';
import 'package:apuzzle/puzzles/parcels/parcels_model.dart';
import 'package:apuzzle/puzzles/parcels/parcels_solver.dart';
import 'package:apuzzle/puzzles/parcels/parcels_tutorial.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/timing.dart';

/// The solution's borders as marks (1 border, 0 open).
List<int> solutionMarks(ParcelsPuzzle p) => [for (final b in p.borders) b ? 1 : 0];

void main() {
  test('rules: sizes, numbers and borders inside a region', () {
    final p = parcelsBoard(['aabb', 'aabb'], ['#.#.', '....']);
    expect(p.k, 4);
    expect(p.clues.take(4).toList(), [2, null, 2, null]);
    final marks = solutionMarks(p);
    expect(parcelsComplete(p, marks), isTrue);
    expect(parcelsSolved(p, marks), isTrue);
    expect(parcelsBad(p, marks), isEmpty);

    // Two long rows: right sizes, but the corner 2 gets three borders (C1 has its 2).
    final g = p.geo;
    final rows = g.startMarks();
    for (var c = 0; c < 4; c++) {
      rows[g.sides[c][1]] = 1;
    }
    expect(parcelsComplete(p, rows), isTrue);
    expect(parcelsSolved(p, rows), isFalse);
    expect(parcelsBad(p, rows), {0});

    // A border sticking into a region.
    final stub = List.of(marks)..[g.sides[0][1]] = 1;
    expect(parcelsSolved(p, stub), isFalse);
    // Only the outline: one area of 8 cells.
    expect(parcelsComplete(p, g.startMarks()), isFalse);
    expect(parcelsBad(p, g.startMarks()), isEmpty);
  });

  test('tutorial and strategy boards have one solution and need their tier', () {
    final grades = <int>[];
    for (final step in [...parcelsTutorial, ...parcelsStrategies]) {
      final p = step.puzzle as ParcelsPuzzle;
      final s = ParcelsSolver(p);
      expect(s.countSolutions(s.start()), 1);
      expect(parcelsSolved(p, solutionMarks(p)), isTrue);
      grades.add(s.grade(s.start()));
    }
    expect(grades, [1, 1, 1, 1, 2, 3]);
  });

  test('the solver records why, and contradictions fail', () {
    final p = parcelsBoard(['aaab', 'cabb', 'cccb'], ['.#..', '....', '....']);
    final s = ParcelsSolver(p);
    final st = s.start();
    expect(s.solve(st, 1), isTrue);
    expect([for (final e in p.geo.inner) st[e] == 1], [for (final e in p.geo.inner) p.borders[e]]);
    // A border between the 1 and the cell below it is wrong.
    final bad = s.start()..[p.geo.sides[1][1]] = 1;
    expect(s.propagate(bad, 2), isFalse);
  });

  for (final n in [4, 5, 6, 8, 10]) {
    for (final d in [Difficulty.easy, Difficulty.medium, Difficulty.hard]) {
      test('parcels $n×$n ${d.name}: valid, unique, tiered, deterministic', () {
        final info = <String>[];
        final tier = parcelsTier(d);
        for (var seed = 1; seed <= 3; seed++) {
          final params = GenParams(size: GridSize.square(n), difficulty: d, seed: seed);
          final sw = Stopwatch()..start();
          final p = generateParcels(params);
          sw.stop();
          expect(p.k, parcelsRegionSize(n, n));
          expect(parcelsSolved(p, solutionMarks(p)), isTrue);
          final s = ParcelsSolver(p);
          final st = s.start();
          expect(s.solve(st, tier), isTrue);
          expect([for (final x in st) x == 1], p.borders);
          final grade = s.grade(s.start());
          expect(grade, lessThanOrEqualTo(tier));
          // Medium and hard need their tier (4×4 is too small to be hard).
          if (tier > 1 && n > 4) expect(grade, tier);
          expect(s.countSolutions(s.start()), 1);
          if (seed == 1) expect(generateParcels(params).toJson(), p.toJson(), reason: 'not deterministic');
          expect(ParcelsPuzzle.fromJson(p.toJson()).toJson(), p.toJson());
          expect(sw.elapsedMilliseconds, lessThan(timeLimit(5000)));
          info.add('${sw.elapsedMilliseconds}ms grade $grade clues ${p.clues.where((c) => c != null).length}');
        }
        // ignore: avoid_print
        print('parcels $n ${d.name}: $info');
      });
    }
  }
}
