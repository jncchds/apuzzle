import '../../core/difficulty.dart';
import '../../core/grid.dart';
import '../../core/lattice_loop.dart';
import '../../core/tutorial.dart';
import 'rails_generator.dart';
import 'rails_model.dart';

/// A board whose track runs through [track] (cells as row * cols + column,
/// entry first), showing the pieces of the [given] cells.
RailsPuzzle _board(int rows, int cols, List<int> track, {List<int> given = const []}) {
  final g = LatticeLoop(rows, cols);
  final lines = List<bool>.filled(g.edgeCount, false);
  for (var k = 1; k < track.length; k++) {
    lines[g.between(track[k - 1], track[k])] = true;
  }
  return RailsPuzzle(
    rows: rows,
    cols: cols,
    entry: track.first,
    exit: track.last,
    rowCounts: [for (var r = 0; r < rows; r++) track.where((i) => i ~/ cols == r).length],
    colCounts: [for (var c = 0; c < cols; c++) track.where((i) => i % cols == c).length],
    given: [for (var i = 0; i < rows * cols; i++) given.contains(i)],
    lines: lines,
  );
}

final List<TutorialStep> railsTutorial = [
  TutorialStep(text: (l) => l.tutRails1, puzzle: _board(3, 3, [0, 1, 4, 7])),
  TutorialStep(
    text: (l) => l.tutRails2,
    puzzle: _board(4, 4, [4, 5, 1, 2, 6, 10, 14], given: [1]),
    focus: {const Pos(0, 1)},
  ),
  TutorialStep.generated(
    text: (l) => l.tutRails3,
    make: () => generateRails(const GenParams(size: GridSize.square(5), difficulty: Difficulty.easy, seed: 1)),
  ),
];
