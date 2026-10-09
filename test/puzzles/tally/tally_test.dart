import 'package:apuzzle/core/difficulty.dart';
import 'package:apuzzle/core/grid.dart';
import 'package:apuzzle/puzzles/tally/tally_generator.dart';
import 'package:apuzzle/puzzles/tally/tally_model.dart';
import 'package:apuzzle/puzzles/tally/tally_solver.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  for (final n in [5, 6, 7, 8, 9]) {
    for (final d in [Difficulty.easy, Difficulty.medium, Difficulty.hard]) {
      test('tally ${n}x$n ${d.name}: valid, unique, tiered, deterministic', () {
        final info = <String>[];
        final tier = switch (d) {
          Difficulty.easy => 1,
          Difficulty.medium => 2,
          _ => 3,
        };
        for (var seed = 1; seed <= 4; seed++) {
          final params = GenParams(size: GridSize.square(n), difficulty: d, seed: seed);
          final sw = Stopwatch()..start();
          final p = generateTally(params);
          sw.stop();
          expect(tallySums(p, [for (final k in p.kept) !k]), isTrue);
          expect([...p.rowTargets, ...p.colTargets], everyElement(greaterThan(0)));
          final s = TallySolver.of(p);
          final st = s.start(givens: p.givens, kept: p.kept);
          final grade = s.grade(st);
          expect(grade, lessThanOrEqualTo(tier));
          expect(s.solve(st, tier), isTrue);
          expect([for (final x in st) x == tallyKeep], p.kept);
          expect(
            s.countSolutions(
              from: s.start(givens: p.givens, kept: p.kept),
            ),
            1,
          );
          expect(generateTally(params).toJson(), p.toJson());
          expect(TallyPuzzle.fromJson(p.toJson()).toJson(), p.toJson());
          expect(sw.elapsedMilliseconds, lessThan(3000));
          info.add('${sw.elapsedMilliseconds}ms grade $grade givens ${p.givens.length}');
        }
        // ignore: avoid_print
        print('tally $n ${d.name}: $info');
      });
    }
  }
}
