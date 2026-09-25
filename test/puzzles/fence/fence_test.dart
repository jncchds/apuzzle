import 'package:apuzzle/core/difficulty.dart';
import 'package:apuzzle/core/grid.dart';
import 'package:apuzzle/puzzles/fence/fence_generator.dart';
import 'package:apuzzle/puzzles/fence/fence_model.dart';
import 'package:apuzzle/puzzles/fence/fence_solver.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  for (final n in [5, 7, 8, 10]) {
    for (final d in [Difficulty.easy, Difficulty.medium, Difficulty.hard]) {
      test('fence ${n}x$n ${d.name}: valid, unique, tiered, deterministic', () {
        final info = <String>[];
        for (var seed = 1; seed <= 4; seed++) {
          final params = GenParams(size: GridSize.square(n), difficulty: d, seed: seed);
          final sw = Stopwatch()..start();
          final p = generateFence(params);
          sw.stop();
          final g = p.lattice;
          expect(g.isSingleLoop(p.lines), isTrue);
          expect(fenceBadCells(p, g, p.lines, complete: true), isEmpty);
          final s = FenceSolver(n, n, p.numbers);
          final st = s.initial();
          expect(s.solve(st, d == Difficulty.easy ? 1 : 2), isTrue);
          for (var e = 0; e < st.length; e++) {
            expect(st[e] == 1, p.lines[e]);
          }
          if (n <= 7) expect(s.countSolutions(s.initial()), 1);
          expect(generateFence(params).toJson(), p.toJson());
          expect(sw.elapsedMilliseconds, lessThan(3000));
          info.add('${sw.elapsedMilliseconds}ms #${p.numbers.where((x) => x != null).length}');
        }
        // ignore: avoid_print
        print('fence $n ${d.name}: $info');
      });
    }
  }
}
