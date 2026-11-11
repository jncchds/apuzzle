import 'package:apuzzle/core/difficulty.dart';
import 'package:apuzzle/core/grid.dart';
import 'package:apuzzle/puzzles/slabs/slabs_generator.dart';
import 'package:apuzzle/puzzles/slabs/slabs_model.dart';
import 'package:apuzzle/puzzles/slabs/slabs_solver.dart';
import 'package:apuzzle/puzzles/slabs/slabs_tutorial.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/timing.dart';

List<int> _states(SlabsPuzzle p) => [for (final x in p.shaded) x ? slabsShade : slabsKeep];

void main() {
  test('rules: shaded rectangles, unshaded non-rectangles, numbers count their area', () {
    final p = slabsBoard('#2 # .|. . .|#2 # .');
    expect(slabsValid(p, p.shaded), isTrue);
    // A shaded L is not a rectangle.
    final l = List.of(p.shaded)..[3] = true;
    expect(slabsConflicts(p, l, complete: true), containsAll([0, 1, 3, 6, 7]));
    // Nothing shaded: one unshaded square of nine, and the 2s are wrong.
    expect(slabsValid(p, List.filled(9, false)), isFalse);
    // An unshaded rectangle: the bottom row shaded leaves two rows of three.
    final rows = slabsBoard('. . .|. . .|# # #');
    expect(slabsConflicts(rows, rows.shaded, complete: true), containsAll([0, 5]));
    // Before the board is complete only sure mistakes count.
    expect(slabsConflicts(p, List.filled(9, false), complete: false), isEmpty);
    final big = List.filled(9, false)
      ..[0] = true
      ..[1] = true
      ..[2] = true;
    expect(slabsConflicts(p, big, complete: false), containsAll([0, 1, 2]));
    // A shaded diagonal whose rectangle holds a dotted cell.
    final kept = List.filled(9, false)..[1] = true;
    final diag = List.filled(9, false)
      ..[0] = true
      ..[3] = true
      ..[4] = true;
    expect(slabsConflicts(p, diag, kept: kept, complete: false), containsAll([0, 3, 4]));
  });

  test('solver: small numbers, joins, ways out, rectangles that fit', () {
    for (final board in ['#2 # .|. . .|#2 # .', '#2 #2 .|. . .|. # #2', '. #1 .|. . .|# # #3']) {
      final p = slabsBoard(board);
      final s = SlabsSolver(p);
      final st = s.start();
      expect(s.propagate(st, 1), isTrue, reason: board);
      expect(st, _states(p), reason: board);
      expect(s.countSolutions(), 1, reason: board);
    }
    // A 7 can't be a shaded rectangle on 4×4: tier 1 gets stuck, tier 2 solves it.
    final p = slabsBoard('. . . .|. # # #3|# . . .7|. . . .');
    final s = SlabsSolver(p);
    expect(s.slack(1), greaterThan(0));
    final st = s.start();
    expect(s.propagate(st, 2), isTrue);
    expect(st, _states(p));
    expect(s.countSolutions(), 1);
  });

  for (final n in [5, 6, 7, 8, 9, 10]) {
    for (final d in [Difficulty.easy, Difficulty.medium, Difficulty.hard]) {
      test('slabs ${n}x$n ${d.name}: valid, unique, tiered, deterministic', () {
        final info = <String>[];
        final tier = slabsTier(d);
        for (var seed = 1; seed <= 4; seed++) {
          final params = GenParams(size: GridSize.square(n), difficulty: d, seed: seed);
          final sw = Stopwatch()..start();
          final p = generateSlabs(params);
          sw.stop();
          expect(slabsValid(p, p.shaded), isTrue);
          final s = SlabsSolver(p);
          expect(s.grade(), tier);
          final st = s.start();
          expect(s.solve(st, tier), isTrue);
          expect(st, _states(p));
          expect(s.countSolutions(), 1);
          if (seed == 1) expect(generateSlabs(params).toJson(), p.toJson(), reason: 'not deterministic');
          expect(SlabsPuzzle.fromJson(p.toJson()).toJson(), p.toJson());
          expect(sw.elapsedMilliseconds, lessThan(timeLimit(2000)));
          info.add('${sw.elapsedMilliseconds}ms numbers ${p.clues.where((c) => c != null).length}');
        }
        // ignore: avoid_print
        print('slabs $n ${d.name}: $info');
      });
    }
  }

  test('strategy boards need their technique', () {
    for (final params in slabsStrategyParams) {
      expect(SlabsSolver(generateSlabs(params)).grade(), slabsTier(params.difficulty));
    }
  });
}
