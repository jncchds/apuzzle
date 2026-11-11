import 'package:apuzzle/core/difficulty.dart';
import 'package:apuzzle/core/grid.dart';
import 'package:apuzzle/puzzles/quarry/quarry_generator.dart';
import 'package:apuzzle/puzzles/quarry/quarry_model.dart';
import 'package:apuzzle/puzzles/quarry/quarry_solver.dart';
import 'package:flutter_test/flutter_test.dart';

// No dart:io here, so this also runs on the web (`flutter test --platform
// chrome <this file>`), where ints are JS numbers.
void main() {
  for (final (n, d) in [(6, Difficulty.easy), (7, Difficulty.medium), (8, Difficulty.hard)]) {
    test('quarry ${n}x$n ${d.name} generates a valid, unique board at its tier', () {
      final p = generateQuarry(GenParams(size: GridSize.square(n), difficulty: d, seed: 7));
      expect(quarryValid(p, p.shaded), isTrue);
      final s = QuarrySolver(p);
      expect(s.grade(), quarryTier(d));
      expect(s.countSolutions(), 1);
    });
  }
}
