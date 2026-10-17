import 'package:apuzzle/core/difficulty.dart';
import 'package:apuzzle/core/grid.dart';
import 'package:apuzzle/puzzles/lookout/lookout_generator.dart';
import 'package:apuzzle/puzzles/lookout/lookout_model.dart';
import 'package:apuzzle/puzzles/lookout/lookout_solver.dart';
import 'package:flutter_test/flutter_test.dart';

// No dart:io here, so this also runs on the web, where the generator once
// started its best score at `-1 << 30` (positive there) and never kept a board
// (`flutter test --platform chrome <this file>`).
void main() {
  for (final (n, d) in [(6, Difficulty.easy), (8, Difficulty.medium), (9, Difficulty.hard)]) {
    test('lookout ${n}x$n ${d.name} generates a valid, unique board at its tier', () {
      final p = generateLookout(GenParams(size: GridSize.square(n), difficulty: d, seed: 7));
      expect(lookoutConflicts(p, p.shaded, complete: true), isEmpty);
      final s = LookoutSolver(p);
      expect(s.grade(), lookoutTier(d));
      expect(s.countSolutions(), 1);
    });
  }
}
