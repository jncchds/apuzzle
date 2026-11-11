import 'dart:math';

import 'package:apuzzle/core/difficulty.dart';
import 'package:apuzzle/core/grid.dart';
import 'package:apuzzle/puzzles/slant/slant_generator.dart';
import 'package:apuzzle/puzzles/slant/slant_model.dart';
import 'package:apuzzle/puzzles/slant/slant_solver.dart';
import 'package:apuzzle/puzzles/slant/slant_tutorial.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/timing.dart';

void main() {
  test('layout: every cell filled, no loop', () {
    for (final n in [4, 7, 10]) {
      final v = slantLayout(n, n, Random(n))!;
      expect(v.every((x) => x == slBack || x == slFwd), isTrue);
      expect(slantLoopCells(SlantGeometry.of(n, n), v), isEmpty);
    }
  });

  test('conflicts flag loops and broken numbers', () {
    // A diamond round the centre corner of a 2×2 board: / \ over \ /.
    final g = SlantGeometry.of(2, 2);
    expect(slantLoopCells(g, [slFwd, slBack, slBack, slFwd]), {0, 1, 2, 3});
    expect(slantLoopCells(g, [slFwd, slBack, slBack, -1]), isEmpty);
    // A 0 on the top-left corner.
    final p = SlantPuzzle(
      rows: 2,
      cols: 2,
      clues: [0, -1, -1, -1, -1, -1, -1, -1, -1],
      solution: const [slFwd, slFwd, slFwd, slFwd],
    );
    expect(slantConflicts(p, [slBack, -1, -1, -1]), {0});
    expect(slantConflicts(p, [slFwd, slFwd, -1, -1]), isEmpty);
    expect(slantSolved(p, [slFwd, slFwd, slFwd, slFwd]), isTrue);
  });

  test('lesson boards need their technique', () {
    final pair = generateSlant(slantPairParams);
    expect(SlantSolver(pair).solveLogic(1), isNull, reason: 'tier 1 solves the pair board');
    expect(SlantSolver(pair).solveLogic(2), isNotNull);
    final probe = generateSlant(slantProbeParams);
    expect(SlantSolver(probe).grade(), 3);
  });

  for (final n in [4, 5, 6, 7, 8, 9, 10]) {
    for (final d in [Difficulty.easy, Difficulty.medium, Difficulty.hard]) {
      test('slant ${n}x$n ${d.name}: valid, unique, at its tier, deterministic', () {
        final grades = <int, int>{};
        var worst = 0, clues = 0, givens = 0;
        final seeds = n == 10 ? 2 : 4;
        for (var seed = 1; seed <= seeds; seed++) {
          final params = GenParams(size: GridSize.square(n), difficulty: d, seed: seed);
          final sw = Stopwatch()..start();
          final p = generateSlant(params);
          sw.stop();
          if (sw.elapsedMilliseconds > worst) worst = sw.elapsedMilliseconds;
          expect(slantSolved(p, p.solution), isTrue);
          final g = p.geo;
          for (var k = 0; k < g.corners; k++) {
            if (p.clues[k] < 0) continue;
            clues++;
            expect(g.cornerCells[k].where((e) => p.solution[e.$1] == e.$2).length, p.clues[k]);
          }
          givens += p.givens.length;
          final solver = SlantSolver(p);
          final sols = solver.solutions();
          expect(sols.length, 1);
          expect(sols.single, p.solution);
          final grade = solver.grade();
          grades[grade] = (grades[grade] ?? 0) + 1;
          expect(grade, lessThanOrEqualTo(slantTier(d)));
          expect(solver.solveLogic(grade), p.solution);
          if (seed == 1) expect(generateSlant(params).toJson(), p.toJson());
          expect(sw.elapsedMilliseconds, lessThan(timeLimit(6000)), reason: 'too slow (${sw.elapsedMilliseconds}ms)');
        }
        // ignore: avoid_print
        print('slant $n ${d.name}: grades $grades, clues ${clues / seeds}, givens $givens, worst ${worst}ms');
      });
    }
  }
}
