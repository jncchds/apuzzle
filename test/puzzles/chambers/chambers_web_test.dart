import 'package:apuzzle/core/difficulty.dart';
import 'package:apuzzle/core/grid.dart';
import 'package:apuzzle/puzzles/chambers/chambers_generator.dart';
import 'package:apuzzle/puzzles/chambers/chambers_model.dart';
import 'package:apuzzle/puzzles/chambers/chambers_solver.dart';
import 'package:flutter_test/flutter_test.dart';

// No dart:io here, so this also runs on the web, where the generator once
// started its best score at `-1 << 30` (positive there) and never kept a board
// (`flutter test --platform chrome <this file>`).
void main() {
  for (final (n, d) in [(6, Difficulty.easy), (8, Difficulty.medium), (9, Difficulty.hard)]) {
    test('chambers ${n}x$n ${d.name} generates a valid, unique board at its tier', () {
      final p = generateChambers(GenParams(size: GridSize.square(n), difficulty: d, seed: 7));
      expect(chambersConflicts(p, p.shaded, complete: true), isEmpty);
      final s = ChambersSolver(p);
      expect(s.grade(s.start(givens: p.givens)), lessThanOrEqualTo(chambersTier(d)));
      expect(s.countSolutions(from: s.start(givens: p.givens)), 1);
    });
  }
}
