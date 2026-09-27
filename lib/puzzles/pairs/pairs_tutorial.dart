import '../../core/difficulty.dart';
import '../../core/grid.dart';
import '../../core/tutorial.dart';
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

final List<TutorialStep> pairsTutorial = [
  TutorialStep(
    text: (l) => l.tutPairs1,
    puzzle: _board(['A# A. B# B#', 'A# A. C. C.', 'A. D# D. C#', 'A. D# D. C#']),
    focus: {const Pos(0, 2), const Pos(0, 3)},
  ),
  TutorialStep(
    text: (l) => l.tutPairs2,
    puzzle: _board(['A# A# A. A.', 'B. B. C# C#', 'B# D. D. D.', 'B# D. D# D#']),
  ),
  TutorialStep.generated(
    text: (l) => l.tutPairs3,
    make: () => generatePairs(const GenParams(size: GridSize.square(6), difficulty: Difficulty.easy, seed: 3)),
  ),
];
