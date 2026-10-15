import 'package:apuzzle/core/difficulty.dart';
import 'package:apuzzle/core/grid.dart';
import 'package:apuzzle/puzzles/chambers/chambers_generator.dart';
import 'package:apuzzle/puzzles/chambers/chambers_model.dart';
import 'package:apuzzle/puzzles/chambers/chambers_solver.dart';
import 'package:apuzzle/puzzles/chambers/chambers_tutorial.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/timing.dart';

void main() {
  test('runs across two borders', () {
    // Rooms: a a b | a a b | c d b: the bottom row crosses c|d|b.
    final p = chambersBoard('aab|aab|cdB');
    expect([for (final s in chambersSpans(3, p.roomOf)) s.join(',')], ['6,7,8']);
  });

  test('conflicts: touching, counts, long runs and cut-off cells', () {
    final p = chambersBoard('aab|aab|cdB');
    expect(chambersConflicts(p, p.shaded, complete: true), isEmpty);
    // Nothing shaded: the bottom row is one long run and room b is short.
    final none = List.filled(9, false);
    expect(chambersConflicts(p, none, complete: false), containsAll([6, 7, 8]));
    // Before the board is complete only dotted cells count as staying.
    expect(chambersConflicts(p, none, kept: List.filled(9, false), complete: false), isEmpty);
    // Two shaded side by side, and room a holds one too many.
    final touch = List.of(p.shaded)..[0] = true;
    touch[1] = true;
    expect(chambersConflicts(p, touch, complete: false), containsAll([0, 1]));
    // A shaded cell walls in the corner.
    final cut = chambersBoard('aBc|Ddc|ddE');
    expect(chambersConflicts(cut, cut.shaded, complete: true), {0});
  });

  test('solver: a run with one open cell left, every way to shade a room', () {
    final p = chambersBoard('aab|aab|cdB');
    final s = ChambersSolver(p);
    final st = s.start();
    expect(s.propagate(st, 1), isTrue);
    expect(st[8], chambersShade);
    // A room of three in a column holding 2: its two ends.
    final ways = chambersBoard('aabC|aAbc|aabC|ddde', hidden: 'be');
    final w = ChambersSolver(ways);
    expect(w.slack(1), greaterThan(0));
    final st2 = w.start();
    expect(w.propagate(st2, 2), isTrue);
    expect(st2, [for (final x in ways.shaded) x ? chambersShade : chambersKeep]);
  });

  for (final n in [5, 6, 7, 8, 9, 10]) {
    for (final d in [Difficulty.easy, Difficulty.medium, Difficulty.hard]) {
      test('chambers ${n}x$n ${d.name}: valid, unique, tiered, deterministic', () {
        final info = <String>[];
        final tier = chambersTier(d);
        for (var seed = 1; seed <= 4; seed++) {
          final params = GenParams(size: GridSize.square(n), difficulty: d, seed: seed);
          final sw = Stopwatch()..start();
          final p = generateChambers(params);
          sw.stop();
          expect(chambersConflicts(p, p.shaded, complete: true), isEmpty);
          final s = ChambersSolver(p);
          final st = s.start(givens: p.givens);
          final grade = s.grade(st);
          expect(grade, lessThanOrEqualTo(tier));
          expect(s.solve(st, tier), isTrue);
          expect([for (final x in st) x == chambersShade], p.shaded);
          expect(s.countSolutions(from: s.start(givens: p.givens)), 1);
          if (seed == 1) expect(generateChambers(params).toJson(), p.toJson(), reason: 'not deterministic');
          expect(ChambersPuzzle.fromJson(p.toJson()).toJson(), p.toJson());
          expect(sw.elapsedMilliseconds, lessThan(timeLimit(3000)));
          info.add('${sw.elapsedMilliseconds}ms grade $grade givens ${p.givens.length} rooms ${p.rooms.length}');
        }
        // ignore: avoid_print
        print('chambers $n ${d.name}: $info');
      });
    }
  }

  test('strategy boards need their technique', () {
    for (final params in chambersStrategyParams) {
      final p = generateChambers(params);
      final s = ChambersSolver(p);
      expect(s.grade(s.start(givens: p.givens)), chambersTier(params.difficulty));
    }
  });
}
