import 'package:apuzzle/core/difficulty.dart';
import 'package:apuzzle/core/grid.dart';
import 'package:apuzzle/puzzles/links/links_generator.dart';
import 'package:apuzzle/puzzles/links/links_model.dart';
import 'package:apuzzle/puzzles/links/links_solver.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  for (final n in [5, 6, 8, 10]) {
    for (final d in [Difficulty.easy, Difficulty.medium, Difficulty.hard]) {
      test('links ${n}x$n ${d.name}: valid, unique, tiered, deterministic', () {
        final info = <String>[];
        for (var seed = 1; seed <= 4; seed++) {
          final params = GenParams(size: GridSize.square(n), difficulty: d, seed: seed);
          final sw = Stopwatch()..start();
          final p = generateLinks(params);
          sw.stop();
          expect(linksValid(p, p.paths), isTrue);
          for (final path in p.paths) {
            expect(path.length, greaterThanOrEqualTo(2));
          }
          final s = LinksSolver(n, n, p.dots);
          final st = s.start();
          expect(s.solve(st, d == Difficulty.easy ? 1 : 2), isTrue);
          expect(st, linksEdges(p));
          if (n <= 6) expect(s.countSolutions(), 1);
          expect(generateLinks(params).toJson(), p.toJson());
          expect(LinksPuzzle.fromJson(p.toJson()).toJson(), p.toJson());
          expect(sw.elapsedMilliseconds, lessThan(3000));
          final t1 = LinksSolver(n, n, p.dots).decide(1).where((x) => x == -1).length;
          info.add('${sw.elapsedMilliseconds}ms pairs ${p.pairs} t1-open $t1');
        }
        // ignore: avoid_print
        print('links $n ${d.name}: $info');
      });
    }
  }
}
