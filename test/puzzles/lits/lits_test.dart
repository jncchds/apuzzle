import 'package:apuzzle/core/difficulty.dart';
import 'package:apuzzle/core/grid.dart';
import 'package:apuzzle/puzzles/lits/lits_generator.dart';
import 'package:apuzzle/puzzles/lits/lits_model.dart';
import 'package:apuzzle/puzzles/lits/lits_solver.dart';
import 'package:apuzzle/puzzles/lits/lits_type.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('classify', () {
    // 5 columns
    expect(classify([0, 1, 2, 3], 5), Tetro.i);
    expect(classify([0, 5, 10, 15], 5), Tetro.i);
    expect(classify([0, 1, 2, 6], 5), Tetro.t);
    expect(classify([0, 5, 10, 11], 5), Tetro.l);
    expect(classify([0, 1, 2, 5], 5), Tetro.l);
    expect(classify([1, 2, 5, 6], 5), Tetro.s);
    expect(classify([0, 5, 6, 11], 5), Tetro.s);
    expect(classify([0, 1, 5, 6], 5), isNull);
    expect(classify([3, 4, 5, 6], 5), isNull); // wraps around
  });

  const type = LitsType();
  for (final n in [5, 6, 7]) {
    for (final d in [Difficulty.easy, Difficulty.medium, Difficulty.hard]) {
      test('lits ${n}x$n ${d.name}: valid, unique, deterministic', () {
        final regionCounts = <int>[];
        for (var seed = 1; seed <= 3; seed++) {
          final params = GenParams(size: GridSize.square(n), difficulty: d, seed: seed);
          final sw = Stopwatch()..start();
          final p = generateLits(params);
          sw.stop();
          expect(litsConflicts(n, p.regions, p.shaded, complete: true), isEmpty);
          final solver = LitsSolver(n, p.regions);
          final sols = solver.solutions(budget: 3000000);
          expect(sols.length, 1);
          expect(sols.single, p.shaded);
          expect(generateLits(params).toJson(), p.toJson());
          expect(sw.elapsedMilliseconds, lessThan(8000), reason: '${sw.elapsedMilliseconds}ms');
          regionCounts.add(p.regionCount);
        }
        // ignore: avoid_print
        print('lits $n ${d.name} regions: $regionCounts');
      });
    }
  }

  test('hints solve', () {
    final p = generateLits(const GenParams(size: GridSize.square(6), difficulty: Difficulty.medium, seed: 1));
    var s = type.initialState(p);
    var guard = 0;
    while (!type.isSolved(p, s) && guard++ < 100) {
      s = type.hint(p, s)!.state;
    }
    expect(type.isSolved(p, s), isTrue);
  });
}
