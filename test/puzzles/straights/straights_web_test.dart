import 'package:apuzzle/core/difficulty.dart';
import 'package:apuzzle/core/grid.dart';
import 'package:apuzzle/puzzles/straights/straights_generator.dart';
import 'package:apuzzle/puzzles/straights/straights_model.dart';
import 'package:apuzzle/puzzles/straights/straights_solver.dart';
import 'package:flutter_test/flutter_test.dart';

// No dart:io here, so this also runs on the web (`flutter test --platform
// chrome <this file>`), where ints are JS numbers.
void main() {
  for (final (n, d) in [(6, Difficulty.easy), (7, Difficulty.medium), (8, Difficulty.hard)]) {
    test('straights ${n}x$n ${d.name} generates a valid, unique board at its tier', () {
      final p = generateStraights(GenParams(size: GridSize.square(n), difficulty: d, seed: 7));
      expect(straightsConflicts(p, p.solution), isEmpty);
      final s = StraightsSolver(p);
      expect(s.grade(p.givens), straightsTier(d));
      expect(s.countSolutions(s.start(p.givens)), 1);
    });
  }
}
