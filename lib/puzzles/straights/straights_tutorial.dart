import '../../core/difficulty.dart';
import '../../core/grid.dart';
import '../../core/tutorial.dart';
import '../../l10n/l10n.dart';
import 'straights_generator.dart';
import 'straights_model.dart';
import '../../core/explain.dart';
import 'straights_solver.dart';

/// A board from rows of cells: `#` a wall, `A`–`I` a wall with the number
/// 1–9, digits given numbers, letters `a`–`i` the numbers 1–9 to fill in.
StraightsPuzzle straightsBoard(List<String> rows) {
  final n = rows.length;
  final cells = rows.join().split('');
  const lower = 'abcdefghi', upper = 'ABCDEFGHI';
  return StraightsPuzzle(
    n: n,
    dark: [for (final ch in cells) ch == '#' || upper.contains(ch)],
    clues: [for (final ch in cells) upper.contains(ch) ? upper.indexOf(ch) : null],
    givens: [for (final ch in cells) '123456789'.contains(ch) ? int.parse(ch) - 1 : null],
    solution: [
      for (final ch in cells)
        if (ch == '#' || upper.contains(ch))
          straightsBlock
        else if (lower.contains(ch))
          lower.indexOf(ch)
        else
          int.parse(ch) - 1,
    ],
  );
}

Set<Pos> _open(StraightsPuzzle p) => {
  for (var i = 0; i < p.givens.length; i++)
    if (!p.dark[i] && p.givens[i] == null) p.size.pos(i),
};

TutorialStep _step(Tr text, List<String> rows) {
  final p = straightsBoard(rows);
  return TutorialStep(text: text, puzzle: p, focus: _open(p));
}

/// The hand-made tutorial boards (checked in tests for the rule each needs).
const straightsTutorialBoards = [
  // Runs of consecutive numbers, none twice in a row or column.
  ['#3b4', 'a432', '21dc', 'cb1#'],
  // A wall's number counts for its row and column.
  ['Dabc', 'a23d', '3dab', 'bcd#'],
  // Numbers every stretch of a run uses can't be elsewhere in the line.
  ['#2ca#', 'bad3#', 'ce1bd', 'Adbec', '#cedB'],
];

final List<TutorialStep> straightsTutorial = [
  _step((l) => l.tutStraights1, straightsTutorialBoards[0]),
  _step((l) => l.tutStraights2, straightsTutorialBoards[1]),
  _step((l) => l.tutStraights3, straightsTutorialBoards[2]),
  TutorialStep.generated(
    text: (l) => l.tutStraights4,
    make: () => generateStraights(const GenParams(size: GridSize.square(5), difficulty: Difficulty.easy, seed: 2)),
  ),
];

final List<TutorialStep> straightsStrategies = [
  TutorialStep.generated(
    text: (l) => l.tutStraightsS1,
    teaches: {StraightsRule.subset.index, StraightsRule.fill.index},
    make: () => generateStraights(straightsStrategyParams[0]),
  ),
  TutorialStep.generated(
    text: (l) => l.tutStraightsS2,
    teaches: {ruleRefuted},
    make: () => generateStraights(straightsStrategyParams[1]),
  ),
];

/// The strategy boards: each needs the tier it teaches (checked in tests).
const straightsStrategyParams = [
  GenParams(size: GridSize.square(6), difficulty: Difficulty.medium, seed: 1),
  GenParams(size: GridSize.square(6), difficulty: Difficulty.hard, seed: 1),
];
