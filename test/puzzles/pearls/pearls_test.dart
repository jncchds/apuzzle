import 'package:apuzzle/core/difficulty.dart';
import 'package:apuzzle/core/grid.dart';
import 'package:apuzzle/puzzles/pearls/pearls_generator.dart';
import 'package:apuzzle/puzzles/pearls/pearls_model.dart';
import 'package:apuzzle/puzzles/pearls/pearls_solver.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  for (final n in [5, 7, 8, 10]) {
    for (final d in [Difficulty.easy, Difficulty.medium, Difficulty.hard]) {
      test('pearls ${n}x$n ${d.name}: valid, unique, tiered, deterministic', () {
        final info = <String>[];
        for (var seed = 1; seed <= 4; seed++) {
          final params = GenParams(size: GridSize.square(n), difficulty: d, seed: seed);
          final sw = Stopwatch()..start();
          final p = generatePearls(params);
          sw.stop();
          final g = p.lattice;
          expect(g.isSingleLoop(p.lines), isTrue);
          expect(pearlsBad(p, g, p.lines, complete: true), isEmpty);
          final s = PearlsSolver(n, n, p.pearls);
          final st = s.initial();
          expect(s.solve(st, d == Difficulty.easy ? 1 : 2), isTrue);
          for (var e = 0; e < st.length; e++) {
            expect(st[e] == 1, p.lines[e]);
          }
          if (n <= 7) expect(s.countSolutions(s.initial()), 1);
          expect(generatePearls(params).toJson(), p.toJson());
          expect(sw.elapsedMilliseconds, lessThan(3000));
          info.add('${sw.elapsedMilliseconds}ms #${p.pearls.where((x) => x != pearlNone).length}');
        }
        // ignore: avoid_print
        print('pearls $n ${d.name}: $info');
      });
    }
  }
}
