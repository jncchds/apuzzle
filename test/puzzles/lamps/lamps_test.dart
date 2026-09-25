import 'package:apuzzle/core/difficulty.dart';
import 'package:apuzzle/core/grid.dart';
import 'package:apuzzle/puzzles/lamps/lamps_generator.dart';
import 'package:apuzzle/puzzles/lamps/lamps_model.dart';
import 'package:apuzzle/puzzles/lamps/lamps_solver.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  for (final n in [5, 7, 8, 10]) {
    for (final d in [Difficulty.easy, Difficulty.medium, Difficulty.hard]) {
      test('lamps ${n}x$n ${d.name}: valid, unique, tiered, deterministic', () {
        final info = <String>[];
        for (var seed = 1; seed <= 4; seed++) {
          final params = GenParams(size: GridSize.square(n), difficulty: d, seed: seed);
          final sw = Stopwatch()..start();
          final p = generateLamps(params);
          sw.stop();
          expect(lampsConflicts(p, p.lamps, complete: true), isEmpty);
          final s = LampsSolver(n, n, p.walls, p.numbers);
          expect(s.countSolutions(s.initial()), 1);
          final st = s.initial();
          expect(s.solve(st, d == Difficulty.easy ? 1 : 2), isTrue);
          for (var i = 0; i < n * n; i++) {
            if (!p.walls[i]) expect(st[i] == lampsLamp, p.lamps[i]);
          }
          expect(generateLamps(params).toJson(), p.toJson());
          expect(sw.elapsedMilliseconds, lessThan(3000));
          info.add('${sw.elapsedMilliseconds}ms w${p.walls.where((w) => w).length} '
              '#${p.numbers.where((x) => x != null).length}');
        }
        // ignore: avoid_print
        print('lamps $n ${d.name}: $info');
      });
    }
  }
}
