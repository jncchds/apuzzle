import '../../core/difficulty.dart';
import '../../core/grid.dart';
import '../../core/tutorial.dart';
import 'shikaku_generator.dart';
import 'shikaku_model.dart';

/// A board from its rectangles, each with the cell (row, column) showing its area.
ShikakuPuzzle _board(int rows, int cols, List<(CellRect, int, int)> rects) {
  final clues = List<int?>.filled(rows * cols, null);
  for (final (rect, r, c) in rects) {
    clues[r * cols + c] = rect.area;
  }
  return ShikakuPuzzle(rows: rows, cols: cols, clues: clues, solution: [for (final (rect, _, _) in rects) rect]);
}

final List<TutorialStep> shikakuTutorial = [
  TutorialStep(
    text: (l) => l.tutShikaku1,
    puzzle: _board(2, 3, [(const CellRect(0, 0, 1, 1), 0, 1), (const CellRect(0, 2, 1, 2), 1, 2)]),
  ),
  TutorialStep(
    text: (l) => l.tutShikaku2,
    puzzle: _board(3, 3, [
      (const CellRect(0, 0, 0, 1), 0, 0),
      (const CellRect(0, 2, 0, 2), 0, 2),
      (const CellRect(1, 0, 2, 2), 2, 1),
    ]),
    focus: {const Pos(0, 2)},
  ),
  TutorialStep.generated(
    text: (l) => l.tutShikaku3,
    make: () => generateShikaku(const GenParams(size: GridSize.square(5), difficulty: Difficulty.easy, seed: 2)),
  ),
];
