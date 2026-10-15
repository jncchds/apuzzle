import '../../core/difficulty.dart';
import '../../core/grid.dart';
import '../../core/tutorial.dart';
import 'lookout_generator.dart';
import 'lookout_model.dart';

/// A board from rows separated by |: `#` is shaded, a digit is a number
/// (its count of seen cells), `.` any other cell that stays.
LookoutPuzzle lookoutBoard(String board) {
  final rows = board.split('|');
  final cells = rows.join().split('');
  return LookoutPuzzle(
    n: rows.length,
    clues: [for (final ch in cells) int.tryParse(ch)],
    shaded: [for (final ch in cells) ch == '#'],
  );
}

final List<TutorialStep> lookoutTutorial = [
  // The bottom 2 already sees the 4 above it: its view stops everywhere else.
  TutorialStep(
    text: (l) => l.tutLookout1,
    puzzle: lookoutBoard('2#.|.4.|#2#'),
    focus: {const Pos(2, 1), const Pos(1, 1)},
  ),
  // The 5 can see at most five cells, so it sees all of them.
  TutorialStep(
    text: (l) => l.tutLookout2,
    puzzle: lookoutBoard('#.2|.4#|.5.'),
    focus: {const Pos(2, 1), const Pos(2, 0), const Pos(2, 2), const Pos(1, 1), const Pos(0, 1)},
  ),
  // Once the cell under the 3 is shaded, the bottom-right corner's only way
  // out is the cell left of it.
  TutorialStep(
    text: (l) => l.tutLookout3,
    puzzle: lookoutBoard('5.3|4.#|...'),
    focus: {const Pos(2, 2), const Pos(2, 1)},
  ),
  TutorialStep.generated(
    text: (l) => l.tutLookout4,
    make: () => generateLookout(const GenParams(size: GridSize.square(5), difficulty: Difficulty.easy, seed: 1)),
  ),
];

/// Generated strategy boards: medium needs every way to split a view or
/// cuts, hard needs probing.
const lookoutStrategyParams = [
  GenParams(size: GridSize.square(6), difficulty: Difficulty.medium, seed: 1),
  GenParams(size: GridSize.square(7), difficulty: Difficulty.hard, seed: 1),
];

final List<TutorialStep> lookoutStrategies = [
  // The 2 sees one more cell; its view can't stop on the 3, so it goes down.
  TutorialStep(
    text: (l) => l.tutLookoutS1,
    puzzle: lookoutBoard('3#2|...|..#'),
    focus: {const Pos(0, 2), const Pos(0, 1), const Pos(0, 0), const Pos(1, 2)},
  ),
  TutorialStep.generated(text: (l) => l.tutLookoutS2, make: () => generateLookout(lookoutStrategyParams[0])),
  TutorialStep.generated(text: (l) => l.tutLookoutS3, make: () => generateLookout(lookoutStrategyParams[1])),
];
