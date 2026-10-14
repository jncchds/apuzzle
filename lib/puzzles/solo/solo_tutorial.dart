import '../../core/difficulty.dart';
import '../../core/grid.dart';
import '../../core/tutorial.dart';
import '../../core/value_grid.dart';
import 'solo_generator.dart';
import 'solo_model.dart';

/// A board from rows of numbers, a # after each shaded one.
SoloPuzzle _board(List<String> rows) {
  final cells = [for (final row in rows) ...row.split(' ')];
  return SoloPuzzle(
    n: rows.length,
    digits: [for (final c in cells) int.parse(c[0])],
    shaded: [for (final c in cells) c.endsWith('#')],
  );
}

final _first = _board(['1# 1 2', '2 2# 1', '1 2 3']);
final _touch = _board(['1# 2 1 2#', '2 4 3 1', '4 1 2 3', '1 3 4 1#']);

final List<TutorialStep> soloTutorial = [
  TutorialStep(text: (l) => l.tutSolo1, puzzle: _first),
  TutorialStep(
    text: (l) => l.tutSolo2,
    puzzle: _touch,
    state: ValueGrid.fromGivens(
      _touch.size,
      _touch.givenAt,
    ).set(const Pos(0, 0), const CellValue(value: soloShade)),
    focus: {const Pos(0, 1), const Pos(1, 0)},
  ),
  // 2 1 2 down the right column: the middle 1 stays.
  TutorialStep(
    text: (l) => l.tutSolo3,
    puzzle: _board(['1 2 2#', '2 1# 1', '3 1 2']),
    focus: {const Pos(1, 2)},
  ),
  // Once the top 1 beside it is shaded, the top-left 1's only way out is
  // the 2 below it, so that 2 stays and the bottom-left 2 is shaded.
  TutorialStep(
    text: (l) => l.tutSolo4,
    puzzle: _board(['1 1# 3', '2 3 1', '2# 1 2']),
    focus: {const Pos(0, 0), const Pos(1, 0)},
  ),
  TutorialStep.generated(
    text: (l) => l.tutSolo5,
    make: () => generateSolo(const GenParams(size: GridSize.square(5), difficulty: Difficulty.easy, seed: 3)),
  ),
];

/// Generated strategy boards: medium needs cuts, hard needs probing.
const soloStrategyParams = [
  GenParams(size: GridSize.square(6), difficulty: Difficulty.medium, seed: 1),
  GenParams(size: GridSize.square(7), difficulty: Difficulty.hard, seed: 1),
];

final List<TutorialStep> soloStrategies = [
  // 4 4 side by side in the top row: the first 4 is shaded.
  TutorialStep(
    text: (l) => l.tutSoloS1,
    puzzle: _board(['4# 3 4 4#', '1 4# 3 4', '4 1 2 4#', '1# 4 1 2']),
    focus: {const Pos(0, 0)},
  ),
  TutorialStep.generated(text: (l) => l.tutSoloS2, make: () => generateSolo(soloStrategyParams[0])),
  TutorialStep.generated(text: (l) => l.tutSoloS3, make: () => generateSolo(soloStrategyParams[1])),
];
