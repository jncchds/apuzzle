import 'package:apuzzle/core/difficulty.dart';
import 'package:apuzzle/core/grid.dart';
import 'package:apuzzle/puzzles/hues/hues_generator.dart';
import 'package:apuzzle/puzzles/hues/hues_model.dart';
import 'package:apuzzle/puzzles/hues/hues_solver.dart';
import 'package:apuzzle/puzzles/hues/hues_type.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  for (final n in [5, 6, 7, 8, 9]) {
    for (final d in [Difficulty.easy, Difficulty.medium, Difficulty.hard]) {
      test('hues ${n}x$n ${d.name}: numbers consistent, unique, tiered, deterministic', () {
        final empties = <int>[];
        for (var seed = 1; seed <= 4; seed++) {
          final params = GenParams(size: GridSize.square(n), difficulty: d, seed: seed);
          final sw = Stopwatch()..start();
          final p = generateHues(params);
          sw.stop();
          final nb = huesNeighbors(n, n);
          final isClue = [for (final c in p.clues) c != null];
          for (var i = 0; i < n * n; i++) {
            if (isClue[i]) expect(p.clues[i], huesCount(nb, isClue, p.solution, i));
          }
          expect(huesConflicts(p, p.solution), isEmpty);
          final s = HuesSolver(rows: n, cols: n, colors: p.colors, clueNum: p.clues, clueColor: p.solution);
          expect(s.countSolutions(s.initialDomains()), 1);
          final tier = d.index >= Difficulty.hard.index ? 2 : 1;
          expect(s.solveLogic(s.initialDomains(), tier), isTrue);
          expect(generateHues(params).toJson(), p.toJson());
          expect(sw.elapsedMilliseconds, lessThan(8000));
          empties.add(isClue.where((c) => !c).length);
        }
        // ignore: avoid_print
        print('hues $n ${d.name} empties: $empties');
      });
    }
  }

  test('isSolved accepts the solution', () {
    const type = HuesType();
    final p = generateHues(const GenParams(size: GridSize.square(6), difficulty: Difficulty.medium, seed: 5));
    var s = type.initialState(p);
    for (var i = 0; i < 36; i++) {
      final pos = p.size.pos(i);
      s = s.set(pos, s.at(pos).withValue(p.solution[i]));
    }
    expect(type.isSolved(p, s), isTrue);
  });
}
