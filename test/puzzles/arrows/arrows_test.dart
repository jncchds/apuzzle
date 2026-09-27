import 'package:apuzzle/core/difficulty.dart';
import 'package:apuzzle/core/grid.dart';
import 'package:apuzzle/puzzles/arrows/arrows_generator.dart';
import 'package:apuzzle/puzzles/arrows/arrows_model.dart';
import 'package:apuzzle/puzzles/arrows/arrows_solver.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  for (final n in [5, 6, 8, 10]) {
    for (final d in [Difficulty.easy, Difficulty.medium, Difficulty.hard]) {
      test('arrows ${n}x$n ${d.name}: valid, unique, tiered, deterministic', () {
        final info = <String>[];
        for (var seed = 1; seed <= 4; seed++) {
          final params = GenParams(size: GridSize.square(n), difficulty: d, seed: seed);
          final sw = Stopwatch()..start();
          final p = generateArrows(params);
          sw.stop();
          expect(arrowsValid(p, p.lines), isTrue);
          for (var i = 0; i < n * n; i++) {
            final onLoop = p.lattice.incident[i].any((e) => p.lines[e]);
            expect(p.shaded[i], !onLoop && !p.isClue(i));
          }
          final s = ArrowsSolver.of(p);
          final st = s.initial();
          expect(s.solve(st, d == Difficulty.easy ? 1 : 2), isTrue);
          expect(s.linesOf(st), p.lines);
          expect(s.shadedOf(st), p.shaded);
          if (n <= 6) expect(s.countSolutions(s.initial()), 1);
          expect(generateArrows(params).toJson(), p.toJson());
          expect(ArrowsPuzzle.fromJson(p.toJson()).toJson(), p.toJson());
          expect(sw.elapsedMilliseconds, lessThan(3000));
          info.add('${sw.elapsedMilliseconds}ms clues ${p.arrows.where((a) => a >= 0).length} t1 ${s.slack(1)}');
        }
        // ignore: avoid_print
        print('arrows $n ${d.name}: $info');
      });
    }
  }
}
