import '../../core/difficulty.dart';
import '../../core/grid.dart';
import '../../core/tutorial.dart';
import 'blocks_generator.dart';
import 'blocks_model.dart';

/// A board from rows of region letters, the solution's digits, and the
/// shown digits ('.' for an empty cell).
BlocksPuzzle _board(List<String> regions, List<String> solution, List<String> shown) {
  final cells = shown.join().split('');
  return BlocksPuzzle(
    rows: regions.length,
    cols: regions.first.length,
    regions: [for (final ch in regions.join().split('')) ch.codeUnitAt(0) - 'A'.codeUnitAt(0)],
    givens: [for (final ch in cells) ch == '.' ? null : int.parse(ch) - 1],
    solution: [for (final ch in solution.join().split('')) int.parse(ch) - 1],
  );
}

const _regions = ['AABB', 'CCBB', 'DCCB'];
const _solution = ['2121', '4354', '1213'];

final List<TutorialStep> blocksTutorial = [
  TutorialStep(
    text: (l) => l.tutBlocks1,
    puzzle: _board(_regions, _solution, ['2121', '43.4', '.213']),
    focus: {const Pos(1, 2), const Pos(2, 0)},
  ),
  TutorialStep(
    text: (l) => l.tutBlocks2,
    puzzle: _board(_regions, _solution, ['..21', '4354', '1..3']),
    focus: {const Pos(0, 0), const Pos(0, 1)},
  ),
  TutorialStep.generated(
    text: (l) => l.tutBlocks3,
    make: () => generateBlocks(const GenParams(size: GridSize.square(5), difficulty: Difficulty.easy, seed: 2)),
  ),
];
