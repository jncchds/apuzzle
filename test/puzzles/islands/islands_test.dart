import 'package:apuzzle/core/difficulty.dart';
import 'package:apuzzle/core/grid.dart';
import 'package:apuzzle/puzzles/islands/islands_generator.dart';
import 'package:apuzzle/puzzles/islands/islands_model.dart';
import 'package:apuzzle/puzzles/islands/islands_solver.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  for (final n in [5, 7, 8, 10]) {
    for (final d in [Difficulty.easy, Difficulty.medium, Difficulty.hard]) {
      test('islands ${n}x$n ${d.name}: valid, unique, tiered, deterministic', () {
        final info = <String>[];
        for (var seed = 1; seed <= 4; seed++) {
          final params = GenParams(size: GridSize.square(n), difficulty: d, seed: seed);
          final sw = Stopwatch()..start();
          final p = generateIslands(params);
          sw.stop();
          expect(islandsConflicts(n, n, p.clues, p.sea, complete: true), isEmpty);
          final s = IslandsSolver(n, n, p.clues);
          expect(s.countSolutions(s.initial()), 1);
          final st = s.initial();
          expect(s.solve(st, d == Difficulty.easy ? 1 : 2), isTrue);
          for (var i = 0; i < n * n; i++) {
            expect(st[i] == islandsSea, p.sea[i]);
          }
          expect(generateIslands(params).toJson(), p.toJson());
          expect(sw.elapsedMilliseconds, lessThan(4000));
          info.add('${sw.elapsedMilliseconds}ms k${p.clues.where((c) => c != null).length}');
        }
        // ignore: avoid_print
        print('islands $n ${d.name}: $info');
      });
    }
  }
}
