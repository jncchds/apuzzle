import 'package:apuzzle/core/difficulty.dart';
import 'package:apuzzle/core/grid.dart';
import 'package:apuzzle/puzzles/mambo/mambo_generator.dart';
import 'package:apuzzle/puzzles/mambo/mambo_model.dart';
import 'package:apuzzle/puzzles/mambo/mambo_solver.dart';
import 'package:apuzzle/puzzles/mambo/mambo_type.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const sizes = [4, 6, 8, 10];

  for (final n in sizes) {
    for (final d in [Difficulty.easy, Difficulty.medium, Difficulty.hard]) {
      test('generator ${n}x$n ${d.name}: valid, unique, deterministic', () {
        for (var seed = 1; seed <= (n >= 10 ? 3 : 8); seed++) {
          final params = GenParams(size: GridSize.square(n), difficulty: d, seed: seed);
          final sw = Stopwatch()..start();
          final p = generateMambo(params);
          sw.stop();

          expect(mamboConflicts(n, p.solution, p.edges), isEmpty, reason: 'solution breaks rules');
          for (var i = 0; i < n * n; i++) {
            if (p.givens[i] != null) expect(p.givens[i], p.solution[i]);
          }
          final g = [for (final v in p.givens) v ?? -1];
          expect(MamboSolver(n, p.edges).countSolutions(g), 1, reason: 'not unique (seed $seed)');

          // Solvable by the logic tier of its difficulty.
          final tier = d.index >= Difficulty.hard.index ? 2 : 1;
          final lg = List.of(g);
          expect(MamboSolver(n, p.edges).solveLogic(lg, tier), isTrue);
          expect(lg, p.solution);

          final again = generateMambo(params);
          expect(again.toJson(), p.toJson(), reason: 'not deterministic');
          expect(sw.elapsedMilliseconds, lessThan(8000), reason: 'too slow');
        }
      });
    }
  }

  test('easy keeps more clues than medium', () {
    var easy = 0, medium = 0;
    for (var seed = 1; seed <= 5; seed++) {
      int clues(MamboPuzzle p) => p.givens.where((v) => v != null).length + p.edges.length;
      easy += clues(generateMambo(GenParams(size: const GridSize.square(6), difficulty: Difficulty.easy, seed: seed)));
      medium += clues(generateMambo(GenParams(size: const GridSize.square(6), difficulty: Difficulty.medium, seed: seed)));
    }
    expect(easy, greaterThan(medium));
  });

  test('conflicts and isSolved', () {
    const type = MamboType();
    final p = generateMambo(const GenParams(size: GridSize.square(6), difficulty: Difficulty.medium, seed: 42));
    var s = type.initialState(p);
    expect(type.isSolved(p, s), isFalse);
    for (var i = 0; i < 36; i++) {
      final pos = p.size.pos(i);
      s = s.set(pos, s.at(pos).withValue(p.solution[i]));
    }
    expect(type.isSolved(p, s), isTrue);
    expect(type.conflicts(p, s), isEmpty);

    // Break a row: flip one cell.
    final pos = p.size.pos(0);
    s = s.set(pos, s.at(pos).withValue(1 - p.solution[0]));
    expect(type.isSolved(p, s), isFalse);
    expect(type.conflicts(p, s), isNotEmpty);
  });

  test('json roundtrip', () {
    const type = MamboType();
    final p = generateMambo(const GenParams(size: GridSize.square(8), difficulty: Difficulty.hard, seed: 3));
    expect(type.decodePuzzle(type.encodePuzzle(p)).toJson(), p.toJson());
    final s = type.initialState(p);
    expect(type.encodeState(type.decodeState(type.encodeState(s))), type.encodeState(s));
  });
}
