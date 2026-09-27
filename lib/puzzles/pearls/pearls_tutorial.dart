import '../../core/difficulty.dart';
import '../../core/grid.dart';
import '../../core/lattice_loop.dart';
import '../../core/tutorial.dart';
import 'pearls_generator.dart';
import 'pearls_model.dart';

/// A board whose loop runs through [loop] (cells as row * cols + column, in
/// order) with pearls at the given cells.
PearlsPuzzle _board(int rows, int cols, List<int> loop, {List<int> black = const [], List<int> white = const []}) {
  final g = LatticeLoop(rows, cols);
  final lines = List<bool>.filled(g.edgeCount, false);
  for (var k = 0; k < loop.length; k++) {
    lines[g.between(loop[k], loop[(k + 1) % loop.length])] = true;
  }
  return PearlsPuzzle(
    rows: rows,
    cols: cols,
    pearls: [
      for (var i = 0; i < rows * cols; i++)
        black.contains(i)
            ? pearlBlack
            : white.contains(i)
            ? pearlWhite
            : pearlNone,
    ],
    lines: lines,
  );
}

const _ring = [0, 1, 2, 5, 8, 7, 6, 3];

final List<TutorialStep> pearlsTutorial = [
  TutorialStep(
    text: (l) => l.tutPearls1,
    puzzle: _board(3, 3, _ring, black: [0]),
  ),
  TutorialStep(
    text: (l) => l.tutPearls2,
    puzzle: _board(3, 3, _ring, white: [1, 3]),
  ),
  TutorialStep.generated(
    text: (l) => l.tutPearls3,
    make: () => generatePearls(const GenParams(size: GridSize.square(5), difficulty: Difficulty.easy, seed: 2)),
  ),
];

final List<TutorialStep> pearlsStrategies = [
  // Both black pearls are too close to two edges to turn toward them.
  TutorialStep(
    text: (l) => l.tutPearlsS1,
    puzzle: _board(4, 4, [5, 6, 7, 11, 15, 14, 13, 9], black: [5, 15]),
    focus: {const Pos(1, 1), const Pos(3, 3)},
  ),
  TutorialStep.generated(
    text: (l) => l.tutPearlsS2,
    make: () => generatePearls(const GenParams(size: GridSize.square(6), difficulty: Difficulty.hard, seed: 1)),
  ),
];
