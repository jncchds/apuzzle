import 'package:apuzzle/core/difficulty.dart';
import 'package:apuzzle/core/grid.dart';
import 'package:apuzzle/puzzles/rampart/rampart_generator.dart';
import 'package:apuzzle/puzzles/rampart/rampart_model.dart';
import 'package:apuzzle/puzzles/rampart/rampart_solver.dart';
import 'package:apuzzle/puzzles/rampart/rampart_tutorial.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/timing.dart';

void main() {
  test('runs round a ring', () {
    expect(rampartRuns(0), [0]);
    expect(rampartRuns(255), [8]);
    expect(rampartRuns(0x81), [2]); // first and last bits are neighbours
    expect(rampartRuns(0x0B), [2, 1]);
    expect(rampartRuns(0x55), [1, 1, 1, 1]);
    // A corner has three neighbours: a 3 can only be all of them.
    expect(rampartMasks(3, 0, [3]).length, 1);
    expect(rampartMasks(3, 4, [8]), [255]);
  });

  test('board strings and clues', () {
    final p = rampartBoard('###|#.(22)|###');
    expect(p.clues[5], [2, 2]);
    expect(p.shaded.where((x) => x).length, 7);
    expect(RampartPuzzle.fromJson(p.toJson()).toJson(), p.toJson());
  });

  test('conflicts: shaded clue, 2×2 blocks, clues, a wall in pieces', () {
    final p = rampartBoard('.#.|##2|#3.');
    expect(rampartConflicts(p, p.shaded, complete: true), isEmpty);
    // A full 2×2 block.
    final pool = List.of(p.shaded)..[0] = true;
    expect(rampartConflicts(p, pool, complete: false), containsAll([0, 1, 3, 4]));
    // Nothing shaded: every clue is wrong once the rest counts as staying.
    final none = List.filled(9, false);
    expect(rampartConflicts(p, none, complete: false), containsAll([5, 7]));
    // Before the board is complete only dotted cells count as staying.
    expect(rampartConflicts(p, none, kept: List.filled(9, false), complete: false), isEmpty);
    // Two parts of the wall.
    final split = rampartBoard('#.#|...|...');
    expect(rampartConflicts(split, split.shaded, complete: true), hasLength(1));
  });

  test('solver: clues, 2×2 blocks, a wall with one way out, shut-in runs', () {
    for (final b in ['.2#|.3#|0.#', '.#.|##2|#3.', '###|#.(22)|###']) {
      final p = rampartBoard(b);
      final s = RampartSolver(p);
      final st = s.start();
      expect(s.propagate(st, 1), isTrue, reason: b);
      expect(st, [for (final x in p.shaded) x ? rampartShade : rampartKeep], reason: b);
    }
    // The 1 1 only works once shut-in runs are ruled out: tier 1 gets stuck, tier 2 solves it.
    final ways = rampartBoard('.(11).|#.#|###');
    final w = RampartSolver(ways);
    expect(w.slack(1), greaterThan(0));
    expect(w.grade(), 2);
  });

  for (final n in [5, 6, 7, 8, 9, 10]) {
    for (final d in [Difficulty.easy, Difficulty.medium, Difficulty.hard]) {
      test('rampart ${n}x$n ${d.name}: valid, unique, tiered, deterministic', () {
        final info = <String>[];
        final tier = rampartTier(d);
        for (var seed = 1; seed <= 4; seed++) {
          final params = GenParams(size: GridSize.square(n), difficulty: d, seed: seed);
          final sw = Stopwatch()..start();
          final p = generateRampart(params);
          sw.stop();
          expect(rampartConflicts(p, p.shaded, complete: true), isEmpty);
          final s = RampartSolver(p);
          expect(s.grade(), tier);
          final st = s.start();
          expect(s.solve(st, tier), isTrue);
          expect([for (final x in st) x == rampartShade], p.shaded);
          expect(s.countSolutions(), 1);
          if (seed == 1) expect(generateRampart(params).toJson(), p.toJson(), reason: 'not deterministic');
          expect(RampartPuzzle.fromJson(p.toJson()).toJson(), p.toJson());
          expect(sw.elapsedMilliseconds, lessThan(timeLimit(3000)));
          info.add('${sw.elapsedMilliseconds}ms clues ${p.clues.where((c) => c != null).length}');
        }
        // ignore: avoid_print
        print('rampart $n ${d.name}: $info');
      });
    }
  }

  test('strategy boards need their technique', () {
    for (final params in rampartStrategyParams) {
      final p = generateRampart(params);
      expect(RampartSolver(p).grade(), rampartTier(params.difficulty));
    }
  });
}
