import 'package:apuzzle/core/difficulty.dart';
import 'package:apuzzle/core/grid.dart';
import 'package:apuzzle/puzzles/kings/kings_generator.dart';
import 'package:apuzzle/puzzles/kings/kings_model.dart';
import 'package:apuzzle/puzzles/kings/kings_solver.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  for (final n in [5, 6, 7, 8, 9, 10]) {
    for (final d in [Difficulty.easy, Difficulty.medium, Difficulty.hard]) {
      test('kings ${n}x$n ${d.name}: valid, unique, connected regions, deterministic', () {
        final gradeCounts = <int, int>{};
        for (var seed = 1; seed <= 4; seed++) {
          final params = GenParams(size: GridSize.square(n), difficulty: d, seed: seed);
          final sw = Stopwatch()..start();
          final p = generateKings(params);
          sw.stop();
          final kings = [for (var r = 0; r < n; r++) r * n + p.solution[r]];
          expect(kingsConflicts(n, p.regions, kings), isEmpty);
          expect(p.regions.toSet().length, n);
          for (var reg = 0; reg < n; reg++) {
            expect(_connected(n, p.regions, reg), isTrue, reason: 'region $reg split');
          }
          final solver = KingsSolver(n, p.regions);
          final sols = solver.solutions();
          expect(sols.length, 1);
          expect(sols.single, p.solution);
          final g = solver.grade();
          gradeCounts[g] = (gradeCounts[g] ?? 0) + 1;
          if (g <= 3) {
            final ks = solver.solveLogic(g)!..sort();
            expect(ks, kings..sort());
          }
          expect(generateKings(params).toJson(), p.toJson());
          expect(sw.elapsedMilliseconds, lessThan(8000), reason: 'too slow (${sw.elapsedMilliseconds}ms)');
        }
        // ignore: avoid_print
        print('grades $n ${d.name}: $gradeCounts');
      });
    }
  }
}

bool _connected(int n, List<int> regions, int reg) {
  final cells = [for (var i = 0; i < n * n; i++) if (regions[i] == reg) i];
  final seen = {cells.first};
  final stack = [cells.first];
  while (stack.isNotEmpty) {
    final i = stack.removeLast();
    final r = i ~/ n, c = i % n;
    for (final j in [if (r > 0) i - n, if (r < n - 1) i + n, if (c > 0) i - 1, if (c < n - 1) i + 1]) {
      if (regions[j] == reg && seen.add(j)) stack.add(j);
    }
  }
  return seen.length == cells.length;
}
