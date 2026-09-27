import 'package:apuzzle/core/difficulty.dart';
import 'package:apuzzle/core/grid.dart';
import 'package:apuzzle/puzzles/blocks/blocks_generator.dart';
import 'package:apuzzle/puzzles/blocks/blocks_model.dart';
import 'package:apuzzle/puzzles/blocks/blocks_solver.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  for (final n in [5, 6, 8, 10]) {
    for (final d in [Difficulty.easy, Difficulty.medium, Difficulty.hard]) {
      test('blocks ${n}x$n ${d.name}: valid, unique, tiered, deterministic', () {
        final info = <String>[];
        final tier = switch (d) {
          Difficulty.easy => 1,
          Difficulty.medium => 2,
          _ => 3,
        };
        for (var seed = 1; seed <= 4; seed++) {
          final params = GenParams(size: GridSize.square(n), difficulty: d, seed: seed);
          final sw = Stopwatch()..start();
          final p = generateBlocks(params);
          sw.stop();
          expect(blocksConflicts(n, n, p.regions, p.solution), isEmpty);
          final sizes = p.regionSizeAt;
          for (var i = 0; i < n * n; i++) {
            expect(p.solution[i], lessThan(sizes[i]));
            if (p.givens[i] != null) expect(p.givens[i], p.solution[i]);
          }
          final s = BlocksSolver(n, n, p.regions);
          final c = s.start(p.givens)!;
          expect(s.solve(c, tier), isTrue);
          expect([for (final m in c) BlocksSolver.valueOf(m)], p.solution);
          expect(s.countSolutions(s.start(p.givens)!), 1);
          expect(generateBlocks(params).toJson(), p.toJson());
          expect(BlocksPuzzle.fromJson(p.toJson()).toJson(), p.toJson());
          expect(sw.elapsedMilliseconds, lessThan(3000));
          final lower = tier > 1 && s.solves(p.givens, tier - 1);
          info.add('${sw.elapsedMilliseconds}ms givens ${p.givens.where((g) => g != null).length}${lower ? ' (easier)' : ''}');
        }
        // ignore: avoid_print
        print('blocks $n ${d.name}: $info');
      });
    }
  }
}
