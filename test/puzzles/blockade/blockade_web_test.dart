import 'package:apuzzle/core/difficulty.dart';
import 'package:apuzzle/core/grid.dart';
import 'package:apuzzle/puzzles/blockade/blockade_generator.dart';
import 'package:apuzzle/puzzles/blockade/blockade_solver.dart';
import 'package:flutter_test/flutter_test.dart';

// No dart:io here, so this also runs on the web, where the generator once
// started its best score at `-1 << 30` (positive there) and never kept a board
// (`flutter test --platform chrome <this file>`).
void main() {
  for (final (n, d) in [(6, Difficulty.easy), (7, Difficulty.medium), (8, Difficulty.hard)]) {
    test('blockade ${n}x$n ${d.name} generates a sea whose fastest passage fits the limit', () {
      final p = generateBlockade(GenParams(size: GridSize.square(n), difficulty: d, seed: 7));
      expect(p.patrols, isNotEmpty);
      expect(BlockadeSolver(p).best(), p.best);
      expect(p.best, lessThanOrEqualTo(p.limit));
    });
  }
}
