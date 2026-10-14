import 'package:apuzzle/core/difficulty.dart';
import 'package:apuzzle/core/grid.dart';
import 'package:apuzzle/puzzles/domino/domino_generator.dart';
import 'package:apuzzle/puzzles/domino/domino_model.dart';
import 'package:apuzzle/puzzles/domino/domino_solver.dart';
import 'package:apuzzle/puzzles/domino/domino_tutorial.dart';
import 'package:apuzzle/core/lattice_loop.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/timing.dart';

void main() {
  test('a new domino takes its cells; a drag pairs cells up from the first', () {
    final g = LatticeLoop(1, 4);
    final empty = List.filled(g.edgeCount, 0);
    // A drag along the row: A–B, B–C, C–D become A–B and C–D.
    expect(dominoCommit(g, empty, [1, 1, 1]), [1, 0, 1]);
    // B–C replaces both.
    expect(dominoCommit(g, [1, 0, 1], [1, 1, 1]), [0, 1, 0]);
    // Crosses stay.
    expect(dominoCommit(g, [2, 0, 0], [2, 0, 1]), [2, 0, 1]);
  });

  test('conflicts: a cell in two dominoes, a pair placed twice', () {
    // 0 1 0 1 in a row: 0–1 twice.
    const p = DominoPuzzle(rows: 1, cols: 4, nums: [0, 1, 0, 1], lines: [true, false, true]);
    expect(dominoBad(p, [1, 0, 1]), {0, 1, 2, 3});
    // B is in both, and both are 0–1.
    expect(dominoBad(p, [1, 1, 0]), {0, 1, 2});
    expect(dominoCovered(p, [1, 0, 1]), isTrue);
    expect(dominoCovered(p, [1, 0, 0]), isFalse);
  });

  test('tutorial and strategy boards have one solution, and need their tier', () {
    for (final step in [...dominoTutorial, ...dominoStrategies]) {
      final p = step.puzzle as DominoPuzzle;
      final s = DominoSolver.of(p);
      expect(s.countSolutions(s.start()), 1);
      final marks = [for (final l in p.lines) l ? 1 : 0];
      expect(dominoCovered(p, marks) && dominoBad(p, marks).isEmpty, isTrue);
    }
    final grades = [
      for (final step in dominoStrategies)
        DominoSolver.of(step.puzzle as DominoPuzzle).grade(DominoSolver.of(step.puzzle as DominoPuzzle).start()),
    ];
    expect(grades, [2, 2, 3]);
  });

  for (final top in [3, 4, 5, 6, 7, 8, 9]) {
    for (final d in [Difficulty.easy, Difficulty.medium, Difficulty.hard]) {
      test('domino double-$top ${d.name}: valid, unique, tiered, deterministic', () {
        final info = <String>[];
        final tier = dominoTier(d);
        final size = GridSize(top + 2, top + 1);
        for (var seed = 1; seed <= 4; seed++) {
          final params = GenParams(size: size, difficulty: d, seed: seed);
          final sw = Stopwatch()..start();
          final p = generateDomino(params);
          sw.stop();
          final marks = [for (final l in p.lines) l ? 1 : 0];
          expect(dominoCovered(p, marks), isTrue);
          expect(dominoBad(p, marks), isEmpty);
          final s = DominoSolver.of(p);
          final grade = s.grade(s.start());
          expect(grade, lessThanOrEqualTo(tier));
          final st = s.start();
          expect(s.solve(st, tier), isTrue);
          expect([for (final x in st) x == 1], p.lines);
          expect(s.countSolutions(s.start()), 1);
          if (seed == 1) expect(generateDomino(params).toJson(), p.toJson(), reason: 'not deterministic');
          expect(DominoPuzzle.fromJson(p.toJson()).toJson(), p.toJson());
          expect(sw.elapsedMilliseconds, lessThan(timeLimit(3000)));
          info.add('${sw.elapsedMilliseconds}ms grade $grade');
        }
        // ignore: avoid_print
        print('domino $top ${d.name}: $info');
      });
    }
  }
}
