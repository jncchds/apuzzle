import 'package:apuzzle/core/difficulty.dart';
import 'package:apuzzle/core/grid.dart';
import 'package:apuzzle/core/grid_graph.dart';
import 'package:apuzzle/puzzles/pairs/pairs_generator.dart';
import 'package:apuzzle/puzzles/pairs/pairs_model.dart';
import 'package:apuzzle/puzzles/pairs/pairs_solver.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  for (final n in [5, 6, 8, 10]) {
    for (final d in [Difficulty.easy, Difficulty.medium, Difficulty.hard]) {
      test('pairs ${n}x$n ${d.name}: valid, unique, tiered, deterministic', () {
        final info = <String>[];
        final tier = switch (d) {
          Difficulty.easy => 1,
          Difficulty.medium => 2,
          _ => 3,
        };
        for (var seed = 1; seed <= 4; seed++) {
          final params = GenParams(size: GridSize.square(n), difficulty: d, seed: seed);
          final sw = Stopwatch()..start();
          final p = generatePairs(params);
          sw.stop();
          expect(pairsConflicts(n, p.regions, p.shaded, complete: true), isEmpty);
          final nb = orthNeighbors(n, n);
          for (var r = 0; r < p.regionCount; r++) {
            expect(components(nb, (i) => p.regions[i] == r).length, 1, reason: 'region $r split');
          }
          final s = PairsSolver(n, p.regions);
          final st = s.start();
          expect(s.solve(st, tier), isTrue);
          expect([for (final x in st) x == 1], p.shaded);
          if (n <= 8) expect(s.countSolutions(), 1);
          expect(generatePairs(params).toJson(), p.toJson());
          expect(PairsPuzzle.fromJson(p.toJson()).toJson(), p.toJson());
          expect(sw.elapsedMilliseconds, lessThan(3000));
          info.add('${sw.elapsedMilliseconds}ms regions ${p.regionCount} grade ${s.grade()}');
        }
        // ignore: avoid_print
        print('pairs $n ${d.name}: $info');
      });
    }
  }
}
