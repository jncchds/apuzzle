import 'package:apuzzle/core/difficulty.dart';
import 'package:apuzzle/core/grid.dart';
import 'package:apuzzle/puzzles/plots/plots_generator.dart';
import 'package:apuzzle/puzzles/plots/plots_model.dart';
import 'package:apuzzle/puzzles/plots/plots_solver.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  for (final n in [5, 6, 8, 10]) {
    for (final d in [Difficulty.easy, Difficulty.medium, Difficulty.hard]) {
      test('plots ${n}x$n ${d.name}: valid, unique, tiered, deterministic', () {
        final info = <String>[];
        final tier = d == Difficulty.hard ? 2 : 1;
        for (var seed = 1; seed <= 4; seed++) {
          final params = GenParams(size: GridSize.square(n), difficulty: d, seed: seed);
          final sw = Stopwatch()..start();
          final p = generatePlots(params);
          sw.stop();
          expect(plotsConflicts(n, n, p.solution, complete: true), isEmpty);
          for (var i = 0; i < n * n; i++) {
            expect(p.solution[i], lessThan(p.maxValue));
            if (p.givens[i] != null) expect(p.givens[i], p.solution[i]);
          }
          final s = PlotsSolver(n, n, p.maxValue);
          final c = s.start(p.givens);
          expect(s.solve(c, tier), isTrue);
          expect([for (final m in c) PlotsSolver.valueOf(m)], p.solution);
          if (n <= 6) expect(s.countSolutions(s.start(p.givens)), 1);
          expect(generatePlots(params).toJson(), p.toJson());
          expect(PlotsPuzzle.fromJson(p.toJson()).toJson(), p.toJson());
          expect(sw.elapsedMilliseconds, lessThan(3000));
          final lower = tier > 1 && s.solves(p.givens, tier - 1);
          info.add(
            '${sw.elapsedMilliseconds}ms givens ${p.givens.where((g) => g != null).length}${lower ? ' (easier)' : ''}',
          );
        }
        // ignore: avoid_print
        print('plots $n ${d.name}: $info');
      });
    }
  }
}
