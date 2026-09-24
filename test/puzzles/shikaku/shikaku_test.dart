import 'package:apuzzle/core/difficulty.dart';
import 'package:apuzzle/core/grid.dart';
import 'package:apuzzle/puzzles/shikaku/shikaku_generator.dart';
import 'package:apuzzle/puzzles/shikaku/shikaku_model.dart';
import 'package:apuzzle/puzzles/shikaku/shikaku_solver.dart';
import 'package:apuzzle/puzzles/shikaku/shikaku_type.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const type = ShikakuType();
  for (final n in [5, 7, 9, 12]) {
    for (final d in [Difficulty.easy, Difficulty.medium, Difficulty.hard]) {
      test('shikaku ${n}x$n ${d.name}: partition valid, unique, logic-solvable, deterministic', () {
        for (var seed = 1; seed <= 3; seed++) {
          final params = GenParams(size: GridSize.square(n), difficulty: d, seed: seed);
          final sw = Stopwatch()..start();
          final p = generateShikaku(params);
          sw.stop();
          expect(type.isSolved(p, ShikakuState(p.solution)), isTrue);
          final solver = ShikakuSolver(n, n, p.clues);
          expect(solver.solutions().length, 1);
          final tier = d.index >= Difficulty.hard.index ? 2 : 1;
          expect(solver.solveLogic(tier), isNotNull);
          expect(generateShikaku(params).toJson(), p.toJson());
          expect(sw.elapsedMilliseconds, lessThan(8000), reason: '${sw.elapsedMilliseconds}ms');
        }
      });
    }
  }

  test('placing overlapping rectangle replaces old ones; hints solve', () {
    final p = generateShikaku(const GenParams(size: GridSize.square(6), difficulty: Difficulty.medium, seed: 2));
    var s = type.initialState(p);
    var guard = 0;
    while (!type.isSolved(p, s) && guard++ < 200) {
      s = type.hint(p, s)!.state;
    }
    expect(type.isSolved(p, s), isTrue);
  });
}
