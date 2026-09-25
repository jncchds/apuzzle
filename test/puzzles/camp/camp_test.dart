import 'package:apuzzle/core/difficulty.dart';
import 'package:apuzzle/core/grid.dart';
import 'package:apuzzle/puzzles/camp/camp_generator.dart';
import 'package:apuzzle/puzzles/camp/camp_model.dart';
import 'package:apuzzle/puzzles/camp/camp_solver.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  for (final n in [5, 7, 8, 10]) {
    for (final d in [Difficulty.easy, Difficulty.medium, Difficulty.hard]) {
      test('camp ${n}x$n ${d.name}: valid, unique, tiered, deterministic', () {
        final info = <String>[];
        for (var seed = 1; seed <= 4; seed++) {
          final params = GenParams(size: GridSize.square(n), difficulty: d, seed: seed);
          final sw = Stopwatch()..start();
          final p = generateCamp(params);
          sw.stop();
          expect(campConflicts(p, p.tents, complete: true), isEmpty);
          expect(p.tents.where((t) => t).length, p.treeCount);
          final s = CampSolver(p.rows, p.cols, p.trees, p.rowCounts, p.colCounts);
          expect(s.countSolutions(s.initial(givenTents: p.givenTents)), 1);
          final st = s.initial(givenTents: p.givenTents);
          expect(s.solve(st, d == Difficulty.easy ? 1 : 2), isTrue);
          for (var i = 0; i < n * n; i++) {
            if (!p.trees[i]) expect(st[i] == campTent, p.tents[i]);
          }
          expect(generateCamp(params).toJson(), p.toJson());
          expect(sw.elapsedMilliseconds, lessThan(3000));
          final hidden = [...p.rowCounts, ...p.colCounts].where((c) => c == null).length;
          info.add('${sw.elapsedMilliseconds}ms t${p.treeCount} g${p.givenTents.length} h$hidden');
        }
        // ignore: avoid_print
        print('camp $n ${d.name}: $info');
      });
    }
  }
}
