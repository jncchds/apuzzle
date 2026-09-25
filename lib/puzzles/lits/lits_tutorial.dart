import '../../core/difficulty.dart';
import '../../core/grid.dart';
import '../../core/tutorial.dart';
import '../../core/value_grid.dart';
import 'lits_generator.dart';
import 'lits_model.dart';

// Top region: an I. Left: an L. Right: a T.
//   A A A A      # # # #
//   B B C C      # . # .
//   B B C C      # . # #
//   B B C C      # # # .
final _board = LitsPuzzle(
  n: 4,
  regions: [for (final ch in 'AAAABBCCBBCCBBCC'.split('')) ch.codeUnitAt(0) - 'A'.codeUnitAt(0)],
  shaded: [for (final ch in '####|#.#.|#.##|###.'.replaceAll('|', '').split('')) ch == '#'],
);

/// A state with the cells marked # shaded, the rest empty.
ValueGrid _state(String marks) => ValueGrid(_board.size, [
      for (final ch in marks.replaceAll('|', '').split('')) ch == '#' ? const CellValue(value: litsShade) : const CellValue(),
    ]);

final List<TutorialStep> litsTutorial = [
  TutorialStep(
    text: (l) => l.tutLits1,
    puzzle: _board,
    state: _state('....|#.#.|#.##|###.'),
    focus: {const Pos(0, 0), const Pos(0, 1), const Pos(0, 2), const Pos(0, 3)},
  ),
  TutorialStep(
    text: (l) => l.tutLits2,
    puzzle: _board,
    state: _state('####|#.#.|#.##|#.#.'),
    focus: {const Pos(1, 1), const Pos(2, 1), const Pos(3, 1)},
  ),
  TutorialStep.generated(
    text: (l) => l.tutLits3,
    make: () => generateLits(const GenParams(size: GridSize.square(5), difficulty: Difficulty.easy, seed: 2)),
  ),
];
