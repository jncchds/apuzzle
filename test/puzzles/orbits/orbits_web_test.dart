import 'package:apuzzle/core/difficulty.dart';
import 'package:apuzzle/core/grid.dart';
import 'package:apuzzle/puzzles/orbits/orbits_generator.dart';
import 'package:apuzzle/puzzles/orbits/orbits_solver.dart';
import 'package:flutter_test/flutter_test.dart';

// No dart:io here, so this also runs on the web, where the generator once
// started its best score at `-1 << 30` (positive there) and never kept a board
// (`flutter test --platform chrome <this file>`).
void main() {
  for (final (n, d) in [(6, Difficulty.easy), (8, Difficulty.medium), (8, Difficulty.hard)]) {
    test('orbits ${n}x$n ${d.name} generates a valid, unique board at its tier', () {
      final p = generateOrbits(GenParams(size: GridSize.square(n), difficulty: d, seed: 7));
      final g = p.geo;
      expect(g.valid(p.solution), isTrue);
      final s = OrbitsSolver(g);
      final c = s.start();
      expect(s.solve(c, d.index + 1), isTrue);
      expect(s.owners(c), p.solution);
      expect(s.countSolutions(), 1);
    });
  }
}
