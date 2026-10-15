import 'dart:math';

import 'package:apuzzle/core/difficulty.dart';
import 'package:apuzzle/core/grid.dart';
import 'package:apuzzle/puzzles/pebbles/pebbles_generator.dart';
import 'package:apuzzle/puzzles/pebbles/pebbles_model.dart';
import 'package:apuzzle/puzzles/pebbles/pebbles_solver.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/timing.dart';

void main() {
  test('conflicts: four of a kind, and groups cut off on a full board', () {
    // # # o
    // # # o
    // o o #
    final values = [0, 0, 1, 0, 0, 1, 1, 1, 0];
    expect(pebblesConflicts(3, values), containsAll([0, 1, 3, 4, 8]));
    expect(pebblesConflicts(3, [0, 0, 1, 0, 1, 1, 0, -1, -1]), isEmpty);
    expect(pebblesConflicts(3, [0, 0, 1, 0, 1, 1, 0, 0, 1]), isEmpty);
  });

  test('solver rules: block, edge, checker', () {
    final s = PebblesSolver(4);
    // Three filled in the top-left block: the fourth is hollow.
    final st = List.filled(16, -1)
      ..[0] = 0
      ..[1] = 0
      ..[4] = 0;
    expect(s.propagate(st, 1), isTrue);
    expect(st[5], pebbleHollow);
    // Filled at both ends of the top row, hollow on the bottom edge: the
    // top row between them is filled.
    final edge = List.filled(16, -1)
      ..[0] = 0
      ..[3] = 0
      ..[13] = 1;
    expect(s.propagate(edge, 2), isTrue);
    expect([edge[1], edge[2]], [0, 0]);
    // A filled diagonal and one hollow cell: the last is filled.
    final checker = List.filled(16, -1)
      ..[5] = 0
      ..[10] = 0
      ..[6] = 1;
    expect(s.propagate(checker, 2), isTrue);
    expect(checker[9], pebbleFilled);
  });

  test('layouts are valid', () {
    for (var n = 4; n <= 10; n++) {
      final f = pebblesLayout(n, Random(n));
      expect(pebblesConflicts(n, [for (final x in f) x ? 0 : 1]), isEmpty);
    }
  });

  for (final n in [5, 6, 7, 8, 9, 10]) {
    for (final d in [Difficulty.easy, Difficulty.medium, Difficulty.hard]) {
      test('pebbles ${n}x$n ${d.name}: valid, unique, tiered, deterministic', () {
        final info = <String>[];
        final tier = pebblesTier(d);
        for (var seed = 1; seed <= 4; seed++) {
          final params = GenParams(size: GridSize.square(n), difficulty: d, seed: seed);
          final sw = Stopwatch()..start();
          final p = generatePebbles(params);
          sw.stop();
          final solution = [for (final f in p.filled) f ? pebbleFilled : pebbleHollow];
          expect(pebblesConflicts(n, solution), isEmpty);
          final s = PebblesSolver(n);
          final st = s.start(p);
          final grade = s.grade(st);
          expect(grade, lessThanOrEqualTo(tier));
          expect(s.solve(st, tier), isTrue);
          expect(st, solution);
          expect(s.countSolutions(s.start(p)), 1);
          if (seed == 1) expect(generatePebbles(params).toJson(), p.toJson(), reason: 'not deterministic');
          expect(PebblesPuzzle.fromJson(p.toJson()).toJson(), p.toJson());
          expect(sw.elapsedMilliseconds, lessThan(timeLimit(4000)));
          info.add('${sw.elapsedMilliseconds}ms grade $grade givens ${p.givens.length}');
        }
        // ignore: avoid_print
        print('pebbles $n ${d.name}: $info');
      });
    }
  }
}
