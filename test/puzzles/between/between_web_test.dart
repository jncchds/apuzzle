import 'package:apuzzle/core/difficulty.dart';
import 'package:apuzzle/core/grid.dart';
import 'package:apuzzle/puzzles/between/between_generator.dart';
import 'package:apuzzle/puzzles/between/between_model.dart';
import 'package:apuzzle/puzzles/between/between_solver.dart';
import 'package:flutter_test/flutter_test.dart';

// No dart:io here, so this also runs on the web (`flutter test --platform
// chrome <this file>`), where ints are JS numbers.
void main() {
  for (final (n, d) in [(6, Difficulty.easy), (7, Difficulty.medium), (8, Difficulty.hard)]) {
    test('between ${n}x$n ${d.name} generates a valid, unique board at its tier', () {
      final p = generateBetween(GenParams(size: GridSize.square(n), difficulty: d, seed: 7));
      expect(betweenConflicts(p, p.solution), isEmpty);
      final s = BetweenSolver(n, p.clues);
      expect(s.grade(p.givens), betweenTier(d));
      expect(s.countSolutions(s.start(p.givens)), 1);
    });
  }
}
