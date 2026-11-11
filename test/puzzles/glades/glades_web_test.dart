import 'package:apuzzle/core/difficulty.dart';
import 'package:apuzzle/core/grid.dart';
import 'package:apuzzle/puzzles/glades/glades_generator.dart';
import 'package:apuzzle/puzzles/glades/glades_model.dart';
import 'package:apuzzle/puzzles/glades/glades_solver.dart';
import 'package:flutter_test/flutter_test.dart';

// No dart:io here, so this also runs on the web (`flutter test --platform
// chrome <this file>`), where ints are JS numbers.
void main() {
  for (final (n, d) in [(6, Difficulty.easy), (8, Difficulty.medium), (9, Difficulty.hard)]) {
    test('glades ${n}x$n ${d.name} generates a valid, unique board at its tier', () {
      final p = generateGlades(GenParams(size: GridSize.square(n), difficulty: d, seed: 7));
      expect(gladesValid(p, p.shaded), isTrue);
      final s = GladesSolver(p);
      expect(s.grade(), gladesTier(d));
      expect(s.countSolutions(), 1);
    });
  }
}
