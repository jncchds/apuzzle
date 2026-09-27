import '../../core/difficulty.dart';
import '../../core/grid.dart';
import '../../core/tutorial.dart';
import '../../core/value_grid.dart';
import 'pairs_generator.dart';
import 'pairs_model.dart';

/// A board from rows of cells: a region letter, then # (shaded) or . each.
PairsPuzzle _board(List<String> rows) {
  final cells = [for (final row in rows) ...row.split(' ')];
  return PairsPuzzle(
    n: rows.length,
    regions: [for (final c in cells) c.codeUnitAt(0) - 'A'.codeUnitAt(0)],
    shaded: [for (final c in cells) c[1] == '#'],
  );
}

final _second = _board(['A# A# A. A.', 'B. B. C# C#', 'B# D. D. D.', 'B# D. D# D#']);

final List<TutorialStep> pairsTutorial = [
  TutorialStep(
    text: (l) => l.tutPairs1,
    puzzle: _board(['A# A. B# B#', 'A# A. C. C.', 'A. D# D. C#', 'A. D# D. C#']),
    focus: {const Pos(0, 2), const Pos(0, 3)},
  ),
  TutorialStep(
    text: (l) => l.tutPairs2,
    puzzle: _second,
    // The top pair is done; the cells next to it are the lesson.
    state: ValueGrid(_second.size, [
      for (var i = 0; i < 16; i++) i < 2 ? const CellValue(value: pairsShade) : const CellValue(),
    ]),
    focus: {const Pos(0, 2), const Pos(1, 0), const Pos(1, 1)},
  ),
  TutorialStep.generated(
    text: (l) => l.tutPairs3,
    make: () => generatePairs(const GenParams(size: GridSize.square(6), difficulty: Difficulty.easy, seed: 3)),
  ),
];

final List<TutorialStep> pairsStrategies = [
  // Medium boards need region-wide reasoning (checked: grade 2).
  TutorialStep.generated(
    text: (l) => l.tutPairsS1,
    make: () => generatePairs(const GenParams(size: GridSize.square(5), difficulty: Difficulty.medium, seed: 1)),
  ),
  // Hard boards need probing (checked: grade 3).
  TutorialStep.generated(
    text: (l) => l.tutPairsS2,
    make: () => generatePairs(const GenParams(size: GridSize.square(5), difficulty: Difficulty.hard, seed: 1)),
  ),
];
