import 'package:apuzzle/core/difficulty.dart';
import 'package:apuzzle/core/grid.dart';
import 'package:apuzzle/puzzles/trail/trail_generator.dart';
import 'package:apuzzle/puzzles/trail/trail_model.dart';
import 'package:apuzzle/puzzles/trail/trail_solver.dart';
import 'package:apuzzle/puzzles/trail/trail_type.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const type = TrailType();
  for (final n in [4, 5, 6, 7]) {
    for (final d in [Difficulty.easy, Difficulty.medium, Difficulty.hard]) {
      test('trail ${n}x$n ${d.name}: valid, unique, deterministic', () {
        final counts = <int>[];
        for (var seed = 1; seed <= 3; seed++) {
          final params = GenParams(size: GridSize.square(n), difficulty: d, seed: seed);
          final sw = Stopwatch()..start();
          final p = generateTrail(params);
          sw.stop();
          expect(trailValid(p, p.solution), isTrue);
          final sols = TrailSolver(n, n, p.numbers).solutions();
          expect(sols.length, 1);
          expect(sols.single, p.solution);
          expect(generateTrail(params).toJson(), p.toJson());
          expect(sw.elapsedMilliseconds, lessThan(10000), reason: '${sw.elapsedMilliseconds}ms');
          counts.add(p.lastNumber);
        }
        // ignore: avoid_print
        print('trail $n ${d.name} numbers: $counts');
      });
    }
  }

  test('hints complete the path', () {
    final p = generateTrail(const GenParams(size: GridSize.square(5), difficulty: Difficulty.medium, seed: 3));
    var s = type.initialState(p);
    var guard = 0;
    while (!type.isSolved(p, s) && guard++ < 100) {
      s = type.hint(p, s)!.state;
    }
    expect(type.isSolved(p, s), isTrue);
  });
}
