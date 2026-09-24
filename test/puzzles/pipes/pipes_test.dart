import 'package:apuzzle/core/difficulty.dart';
import 'package:apuzzle/core/grid.dart';
import 'package:apuzzle/puzzles/pipes/pipes_generator.dart';
import 'package:apuzzle/puzzles/pipes/pipes_model.dart';
import 'package:apuzzle/puzzles/pipes/pipes_type.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const type = PipesType();
  for (final n in [4, 7, 11]) {
    for (final d in [Difficulty.easy, Difficulty.medium, Difficulty.hard]) {
      test('pipes ${n}x$n ${d.name}: tree solution valid, starts unsolved, deterministic', () {
        for (var seed = 1; seed <= 5; seed++) {
          final params = GenParams(size: GridSize.square(n), difficulty: d, seed: seed);
          final p = generatePipes(params);
          expect(pipesSolved(p, p.masks), isTrue, reason: 'solution is not a spanning tree');
          expect(p.masks.every((m) => m != 0), isTrue);
          expect(type.isSolved(p, type.initialState(p)), isFalse);
          for (var i = 0; i < p.masks.length; i++) {
            if (p.locked[i]) expect(p.start[i] % 4, 0);
          }
          expect(generatePipes(params).toJson(), p.toJson());
        }
      });
    }
  }

  test('hints solve the puzzle', () {
    final p = generatePipes(const GenParams(size: GridSize.square(6), difficulty: Difficulty.hard, seed: 4));
    var s = type.initialState(p);
    var guard = 0;
    while (!type.isSolved(p, s) && guard++ < 100) {
      s = type.hint(p, s)!.state;
    }
    expect(type.isSolved(p, s), isTrue);
  });

  test('rotateMask', () {
    expect(rotateMask(dN, 1), dE);
    expect(rotateMask(dN | dE, 1), dE | dS);
    expect(rotateMask(dW, 1), dN);
    expect(rotateMask(dN | dS, 2), dN | dS);
  });
}
