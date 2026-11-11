import 'package:apuzzle/core/difficulty.dart';
import 'package:apuzzle/core/grid.dart';
import 'package:apuzzle/puzzles/slabs/slabs_generator.dart';
import 'package:apuzzle/puzzles/slabs/slabs_model.dart';
import 'package:apuzzle/puzzles/slabs/slabs_solver.dart';
import 'package:flutter_test/flutter_test.dart';

// No dart:io here, so this also runs on the web (`flutter test --platform
// chrome <this file>`), where ints are JS numbers.
void main() {
  for (final (n, d) in [(6, Difficulty.easy), (7, Difficulty.medium), (8, Difficulty.hard)]) {
    test('slabs ${n}x$n ${d.name} generates a valid, unique board at its tier', () {
      final p = generateSlabs(GenParams(size: GridSize.square(n), difficulty: d, seed: 7));
      expect(slabsValid(p, p.shaded), isTrue);
      final s = SlabsSolver(p);
      expect(s.grade(), slabsTier(d));
      expect(s.countSolutions(), 1);
    });
  }
}
