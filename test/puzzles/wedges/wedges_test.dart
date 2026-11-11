import 'package:apuzzle/core/difficulty.dart';
import 'package:apuzzle/core/grid.dart';
import 'package:apuzzle/puzzles/wedges/wedges_generator.dart';
import 'package:apuzzle/puzzles/wedges/wedges_model.dart';
import 'package:apuzzle/puzzles/wedges/wedges_solver.dart';
import 'package:apuzzle/puzzles/wedges/wedges_tutorial.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/timing.dart';

bool _point(int nw, int ne, int se, int sw) => wedgesPointTable[((nw * 6 + ne) * 6 + se) * 6 + sw] == 1;

void main() {
  test('points: square corners, straight sides and diamonds pass, the rest fails', () {
    const o = wedgeDot, x = wedgeWall;
    expect(_point(o, o, o, o), isTrue, reason: 'inside an open area');
    expect(_point(x, x, o, x), isTrue, reason: 'a square corner');
    expect(_point(x, o, o, x), isTrue, reason: 'a straight side');
    expect(_point(o, o, o, x), isFalse, reason: 'a corner turning inwards');
    expect(_point(x, o, x, o), isTrue, reason: 'two areas touching at a point');
    // The middle of a 2×2 diamond: every cell's open corner points at it.
    expect(_point(wedgeTL, wedgeTR, wedgeBR, wedgeBL), isTrue);
    // The diamond's top tip: the two wedges above the middle meet there.
    expect(_point(x, x, wedgeTR, wedgeTL), isTrue);
    // A lone wedge by a wall leaves a 45° corner.
    expect(_point(x, x, wedgeTR, x), isFalse);
    expect(_point(x, x, wedgeTL, x), isTrue, reason: 'all closed');
  });

  test('conflicts and solved', () {
    final p = wedgesBoard(['#1##', '#◤◥#', '#◣◢#', '####']);
    expect(wedgesSolved(p, p.solution), isTrue);
    final empty = List.filled(16, -1);
    // Nothing placed: no conflict yet, but not solved either (the 1 is short).
    expect(wedgesConflicts(p, empty), isEmpty);
    expect(wedgesSolved(p, empty), isFalse);
    // One wedge alone: its corners can still be finished, but not with the rest open.
    final one = List.of(empty)..[5] = wedgeTL;
    expect(wedgesConflicts(p, one), isEmpty);
    expect(wedgesConflicts(p, one, complete: true), isNotEmpty);
    // A wrong wedge beside the 1 breaks its corner at once.
    final wrong = List.of(empty)..[5] = wedgeBR;
    expect(wedgesConflicts(p, wrong), contains(5));
  });

  test('lesson boards need their technique', () {
    final pair = generateWedges(wedgesPairParams);
    expect(WedgesSolver(pair).solveLogic(1), isNull, reason: 'tier 1 solves the pair board');
    expect(WedgesSolver(pair).solveLogic(2), isNotNull);
    final probe = generateWedges(wedgesProbeParams);
    expect(WedgesSolver(probe).grade(), 3);
  });

  for (final n in [5, 6, 7, 8, 9, 10]) {
    for (final d in [Difficulty.easy, Difficulty.medium, Difficulty.hard]) {
      test('wedges ${n}x$n ${d.name}: valid, unique, at its tier, deterministic', () {
        final grades = <int, int>{};
        var worst = 0, clues = 0, givens = 0;
        final seeds = n >= 9 ? 2 : 4;
        for (var seed = 1; seed <= seeds; seed++) {
          final params = GenParams(size: GridSize.square(n), difficulty: d, seed: seed);
          final sw = Stopwatch()..start();
          final p = generateWedges(params);
          sw.stop();
          if (sw.elapsedMilliseconds > worst) worst = sw.elapsedMilliseconds;
          expect(wedgesSolved(p, p.solution), isTrue);
          final g = p.geo;
          for (var i = 0; i < g.cells; i++) {
            if (p.clues[i] == wedgesOpen) {
              expect(p.solution[i], isNot(wedgeWall));
              continue;
            }
            expect(p.solution[i], wedgeWall);
            if (p.clues[i] < 0) continue;
            clues++;
            expect(wedgesAround(g, p.solution, i), p.clues[i]);
          }
          givens += p.givens.length;
          final solver = WedgesSolver(p);
          final sols = solver.solutions();
          expect(sols.length, 1);
          expect(sols.single, p.solution);
          final grade = solver.grade();
          grades[grade] = (grades[grade] ?? 0) + 1;
          expect(grade, lessThanOrEqualTo(wedgesTier(d)));
          expect(solver.solveLogic(grade), p.solution);
          if (seed == 1) expect(generateWedges(params).toJson(), p.toJson());
          expect(sw.elapsedMilliseconds, lessThan(timeLimit(6000)), reason: 'too slow (${sw.elapsedMilliseconds}ms)');
        }
        // ignore: avoid_print
        print('wedges $n ${d.name}: grades $grades, clues ${clues / seeds}, givens $givens, worst ${worst}ms');
      });
    }
  }
}
