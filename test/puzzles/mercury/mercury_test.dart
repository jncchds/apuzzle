import 'package:apuzzle/core/difficulty.dart';
import 'package:apuzzle/core/grid.dart';
import 'package:apuzzle/puzzles/mercury/mercury_generator.dart';
import 'package:apuzzle/puzzles/mercury/mercury_model.dart';
import 'package:apuzzle/puzzles/mercury/mercury_solver.dart';
import 'package:apuzzle/puzzles/mercury/mercury_tutorial.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/timing.dart';

void main() {
  // An L-shaped tube from the bulb at the bottom left, round the corner to
  // the top right, and two short tubes filling up from the bottom.
  final p = mercuryBoard('RRx|UXx|UUU');

  test('the board parser takes tubes, levels and counts from the letters', () {
    expect(p.tubes.map((t) => t.join(',')).toSet(), {'6,3,0,1,2', '7,4', '8,5'});
    expect(p.levels[p.tubeOf[6]], 4);
    expect(p.rowCounts, [2, 2, 3]);
    expect(p.colCounts, [3, 3, 1]);
    expect([for (var i = 0; i < 9; i++) p.solutionAt(i)].join(), '001001000');
  });

  test('conflicts: mercury past an empty cell of its tube, and counts', () {
    List<int> board(String s) => [
      for (final ch in s.replaceAll('|', '').split('')) ch == 'M' ? mercuryFull : (ch == '.' ? mercuryEmpty : -1),
    ];
    expect(mercuryConflicts(p, board('MM.|MM.|MMM'), complete: true), isEmpty);
    // Mercury past a gap: the bulb's neighbour is empty but the corner is filled.
    expect(mercuryConflicts(p, board('M--|.--|---'), complete: false), {0, 3});
    // Too much in column C, too many empty cells in row 3.
    expect(mercuryConflicts(p, board('--M|--M|-..'), complete: false), containsAll([2, 5, 7, 8]));
    // Not complete: missing mercury isn't flagged until then.
    expect(mercuryConflicts(p, board('---|---|M--'), complete: false), isEmpty);
    // Complete: unmarked cells count as empty.
    expect(mercuryConflicts(p, board('MM-|MM-|MMM'), complete: true), isEmpty);
  });

  test('the tutorial boards are unique and need tier 1 only', () {
    for (final b in ['dDX|dDU|xxU', 'RRx|UXx|UUU', 'xLd|xld|Rxx']) {
      final q = mercuryBoard(b), s = MercurySolver.of(q);
      expect(s.grade(s.start()), 1, reason: b);
      expect(s.countSolutions(s.start()), 1, reason: b);
    }
  });

  test('thinking ahead is needed on the third lesson', () {
    final q = mercuryBoard('xLd|xld|Rxx');
    final s = MercurySolver.of(q, disabled: {MercuryRule.tooMuch, MercuryRule.tooLittle});
    expect(s.solve(s.start(), 2), isFalse);
  });

  test('strategy boards need their technique', () {
    final q = mercuryBoard(mercuryPairBoard), s = MercurySolver.of(q);
    expect(s.grade(s.start()), 2);
    expect(s.countSolutions(s.start()), 1);
    for (final params in mercuryStrategyParams) {
      final q = generateMercury(params);
      final s = MercurySolver.of(q);
      expect(s.grade(mercuryStart(s, q)), mercuryTier(params.difficulty));
    }
  });

  test('tubes cover the grid, each at least two cells long', () {
    for (var seed = 1; seed <= 20; seed++) {
      final q = generateMercury(GenParams(size: const GridSize.square(7), difficulty: Difficulty.easy, seed: seed));
      final cells = [for (final t in q.tubes) ...t]..sort();
      expect(cells, [for (var i = 0; i < 49; i++) i]);
      expect(q.tubes.where((t) => t.length < 2), isEmpty);
      for (final t in q.tubes) {
        for (var k = 1; k < t.length; k++) {
          final a = t[k - 1], b = t[k];
          expect((a ~/ 7 - b ~/ 7).abs() + (a % 7 - b % 7).abs(), 1);
        }
      }
    }
  });

  for (final n in [5, 6, 7, 8, 9, 10]) {
    for (final d in [Difficulty.easy, Difficulty.medium, Difficulty.hard]) {
      test('mercury ${n}x$n ${d.name}: valid, unique, tiered, deterministic', () {
        final info = <String>[];
        final tier = mercuryTier(d);
        for (var seed = 1; seed <= 4; seed++) {
          final params = GenParams(size: GridSize.square(n), difficulty: d, seed: seed);
          final sw = Stopwatch()..start();
          final p = generateMercury(params);
          sw.stop();
          final v = [for (var i = 0; i < n * n; i++) p.solutionAt(i)];
          expect(mercuryConflicts(p, v, complete: true), isEmpty);
          final s = MercurySolver.of(p);
          final grade = s.grade(mercuryStart(s, p));
          expect(grade, lessThanOrEqualTo(tier));
          final st = mercuryStart(s, p);
          expect(s.solve(st, tier), isTrue);
          expect(st, v);
          expect(s.countSolutions(mercuryStart(s, p)), 1);
          if (seed == 1) expect(generateMercury(params).toJson(), p.toJson(), reason: 'not deterministic');
          expect(MercuryPuzzle.fromJson(p.toJson()).toJson(), p.toJson());
          expect(sw.elapsedMilliseconds, lessThan(timeLimit(3000)));
          info.add(
            '${sw.elapsedMilliseconds}ms grade $grade tubes ${p.tubes.length} givens ${p.givens.length} hidden ${[...p.rowCounts, ...p.colCounts].where((c) => c == null).length}',
          );
        }
        // ignore: avoid_print
        print('mercury $n ${d.name}: $info');
      });
    }
  }
}
