import '../../core/difficulty.dart';
import '../../core/grid.dart';
import '../../core/tutorial.dart';
import 'pebbles_generator.dart';
import 'pebbles_model.dart';

/// A board from rows separated by |: x a filled stone, o a hollow one, in
/// upper case when shown from the start.
PebblesPuzzle pebblesBoard(String board) {
  final rows = board.split('|');
  final cells = rows.join().split('');
  return PebblesPuzzle(
    n: rows.length,
    filled: [for (final ch in cells) ch.toLowerCase() == 'x'],
    givens: [
      for (var i = 0; i < cells.length; i++)
        if (cells[i] != cells[i].toLowerCase()) i,
    ],
  );
}

final List<TutorialStep> pebblesTutorial = [
  TutorialStep(text: (l) => l.tutPebbles1, puzzle: pebblesBoard('XXXX|XoOX|XOxX|OoOO')),
  // Three of a kind in a block: the bottom-left block makes A3 filled.
  TutorialStep(
    text: (l) => l.tutPebbles2,
    puzzle: pebblesBoard('XXXX|XOXo|xOxO|OOOO'),
    focus: {const Pos(2, 0), const Pos(3, 0), const Pos(3, 1), const Pos(2, 1)},
  ),
  // The hollow stone in the corner has one way out.
  TutorialStep(
    text: (l) => l.tutPebbles3,
    puzzle: pebblesBoard('XXXO|XOOO|XXXo|OooO'),
    focus: {const Pos(3, 0), const Pos(3, 1)},
  ),
  // B1 is walled in by filled stones.
  TutorialStep(
    text: (l) => l.tutPebbles4,
    puzzle: pebblesBoard('XxXX|OXOX|OXOX|oOoO'),
    focus: {const Pos(0, 1)},
  ),
  TutorialStep.generated(
    text: (l) => l.tutPebbles5,
    make: () => generatePebbles(const GenParams(size: GridSize.square(5), difficulty: Difficulty.easy, seed: 1)),
  ),
];

final List<TutorialStep> pebblesStrategies = [
  // Filled at A1 and D4, hollow at C4: the edge from A1 round to D4 is filled.
  TutorialStep(
    text: (l) => l.tutPebblesS1,
    puzzle: pebblesBoard('Xxxx|oXox|oxox|ooOX'),
    focus: {const Pos(0, 0), const Pos(3, 3), const Pos(3, 2)},
  ),
  // Once B3 is hollow, A3 and B4 are a filled diagonal beside it: A4 is filled.
  TutorialStep(
    text: (l) => l.tutPebblesS2,
    puzzle: pebblesBoard('Xoooo|xXxxo|XooOo|xXxxo|Ooooo'),
    focus: {const Pos(2, 0), const Pos(2, 1), const Pos(3, 0), const Pos(3, 1)},
  ),
  // The filled stones at C2 and D4 can only meet round the left side.
  TutorialStep(text: (l) => l.tutPebblesS3, puzzle: pebblesBoard('Ooooo|xxXxO|xOOOo|xxxXo|Ooooo')),
];
