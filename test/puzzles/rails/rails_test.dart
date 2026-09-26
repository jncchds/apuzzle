import 'package:apuzzle/core/difficulty.dart';
import 'package:apuzzle/core/grid.dart';
import 'package:apuzzle/puzzles/rails/rails_generator.dart';
import 'package:apuzzle/puzzles/rails/rails_model.dart';
import 'package:apuzzle/puzzles/rails/rails_solver.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  for (final n in [5, 7, 8, 10]) {
    for (final d in [Difficulty.easy, Difficulty.medium, Difficulty.hard]) {
      test('rails ${n}x$n ${d.name}: valid, unique, tiered, deterministic', () {
        final info = <String>[];
        for (var seed = 1; seed <= 4; seed++) {
          final params = GenParams(size: GridSize.square(n), difficulty: d, seed: seed);
          final sw = Stopwatch()..start();
          final p = generateRails(params);
          sw.stop();
          expect(railsValid(p, p.lines), isTrue);
          expect(p.entry % n, 0);
          expect(p.exit ~/ n, n - 1);
          final s = RailsSolver(p);
          final st = s.initial();
          expect(s.solve(st, d == Difficulty.easy ? 1 : 2), isTrue);
          expect(s.linesOf(st), p.lines);
          if (n <= 7) expect(s.countSolutions(s.initial()), 1);
          expect(generateRails(params).toJson(), p.toJson());
          expect(RailsPuzzle.fromJson(p.toJson()).toJson(), p.toJson());
          expect(sw.elapsedMilliseconds, lessThan(3000));
          info.add('${sw.elapsedMilliseconds}ms len ${p.length} given ${p.given.where((x) => x).length}');
        }
        // ignore: avoid_print
        print('rails $n ${d.name}: $info');
      });
    }
  }
}
