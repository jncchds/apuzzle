import '../../core/difficulty.dart';
import '../../core/grid.dart';
import '../../core/tutorial.dart';
import 'tally_generator.dart';
import 'tally_model.dart';

/// A board from rows of digits, a * after each one that stays.
TallyPuzzle _board(List<String> rows) {
  final cells = [for (final row in rows) ...row.split(' ')];
  return TallyPuzzle(
    rows: rows.length,
    cols: cells.length ~/ rows.length,
    digits: [for (final c in cells) int.parse(c[0])],
    kept: [for (final c in cells) c.endsWith('*')],
  );
}

final List<TutorialStep> tallyTutorial = [
  TutorialStep(text: (l) => l.tutTally1, puzzle: _board(['7 7 2*', '3* 3* 1*', '2 3* 6'])),
  TutorialStep(
    text: (l) => l.tutTally2,
    puzzle: _board(['1 8 6*', '7* 7* 8', '6 4* 6*']),
    focus: {const Pos(0, 1)},
  ),
  TutorialStep(
    text: (l) => l.tutTally3,
    puzzle: _board(['8* 3 4*', '5* 8 7*', '8 9* 9']),
    focus: {const Pos(0, 0), const Pos(0, 2)},
  ),
  TutorialStep.generated(
    text: (l) => l.tutTally4,
    make: () => generateTally(const GenParams(size: GridSize.square(5), difficulty: Difficulty.easy, seed: 4)),
  ),
];

final List<TutorialStep> tallyStrategies = [
  // Medium boards need every way to make a sum (checked: grade 2).
  TutorialStep.generated(
    text: (l) => l.tutTallyS1,
    make: () => generateTally(const GenParams(size: GridSize.square(5), difficulty: Difficulty.medium, seed: 1)),
  ),
  // Hard boards need probing (checked: grade 3).
  TutorialStep.generated(
    text: (l) => l.tutTallyS2,
    make: () => generateTally(const GenParams(size: GridSize.square(7), difficulty: Difficulty.hard, seed: 1)),
  ),
];
