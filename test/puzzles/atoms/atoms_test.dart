import 'package:apuzzle/core/difficulty.dart';
import 'package:apuzzle/core/grid.dart';
import 'package:apuzzle/puzzles/atoms/atoms_generator.dart';
import 'package:apuzzle/puzzles/atoms/atoms_model.dart';
import 'package:apuzzle/puzzles/atoms/atoms_solver.dart';
import 'package:apuzzle/puzzles/atoms/atoms_type.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const type = AtomsType();
  for (final n in [5, 7, 10]) {
    for (final d in [Difficulty.easy, Difficulty.medium, Difficulty.hard]) {
      test('atoms ${n}x$n ${d.name}: valid, unique, deterministic', () {
        final grades = <int>[];
        for (var seed = 1; seed <= 3; seed++) {
          final params = GenParams(size: GridSize.square(n), difficulty: d, seed: seed);
          final sw = Stopwatch()..start();
          final p = generateAtoms(params);
          sw.stop();
          expect(atomsSolved(p, p.solution), isTrue);
          final solver = AtomsSolver(p);
          final sols = solver.solutions(budget: 5000000);
          expect(sols.length, 1);
          expect(sols.single, p.solution);
          grades.add(solver.grade());
          expect(generateAtoms(params).toJson(), p.toJson());
          expect(sw.elapsedMilliseconds, lessThan(8000), reason: '${sw.elapsedMilliseconds}ms');
        }
        // ignore: avoid_print
        print('atoms $n ${d.name} grades: $grades');
      });
    }
  }

  test('hints solve', () {
    final p = generateAtoms(const GenParams(size: GridSize.square(7), difficulty: Difficulty.medium, seed: 2));
    var s = type.initialState(p);
    var guard = 0;
    while (!type.isSolved(p, s) && guard++ < 200) {
      s = type.hint(p, s)!.state;
    }
    expect(type.isSolved(p, s), isTrue);
  });
}
