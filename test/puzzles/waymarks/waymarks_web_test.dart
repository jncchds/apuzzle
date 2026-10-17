import 'package:apuzzle/core/difficulty.dart';
import 'package:apuzzle/core/grid.dart';
import 'package:apuzzle/puzzles/waymarks/waymarks_explain.dart';
import 'package:apuzzle/puzzles/waymarks/waymarks_generator.dart';
import 'package:apuzzle/puzzles/waymarks/waymarks_model.dart';
import 'package:apuzzle/puzzles/waymarks/waymarks_solver.dart';
import 'package:flutter_test/flutter_test.dart';

// No dart:io here, so this also runs on the web, where the generator once
// started its best score at `-1 << 30` (positive there) and never kept a board
// (`flutter test --platform chrome <this file>`).
void main() {
  for (final (n, d) in [(5, Difficulty.easy), (6, Difficulty.medium), (7, Difficulty.hard)]) {
    test('waymarks ${n}x$n ${d.name} generates a valid, unique board at its tier', () {
      final p = generateWaymarks(GenParams(size: GridSize.square(n), difficulty: d, seed: 7));
      expect(waymarksSolved(p, WaymarksState(WaymarksExplainer.solutionNext(p))), isTrue);
      final s = WaymarksSolver(p);
      expect(s.grade(), waymarksTier(d));
      expect(s.countSolutions(), 1);
    });
  }
}
