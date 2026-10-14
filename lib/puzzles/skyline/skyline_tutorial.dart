import '../../core/difficulty.dart';
import '../../core/grid.dart';
import '../../core/tutorial.dart';
import '../../l10n/l10n.dart';
import 'skyline_generator.dart';
import 'skyline_model.dart';

/// A 4×4 board from rows of heights (given) and letters a–d (a cell to fill
/// with 1–4). [shown] picks the clues (top, bottom, left, right; x = shown).
SkylinePuzzle _board(List<String> rows, String shown) {
  final cells = rows.join().split('');
  int value(String ch) => '1234'.contains(ch) ? int.parse(ch) - 1 : 'abcd'.indexOf(ch);
  final solution = [for (final ch in cells) value(ch)];
  final clues = skylineClues(4, solution);
  return SkylinePuzzle(
    n: 4,
    clues: [for (var k = 0; k < 16; k++) shown[k] == 'x' ? clues[k] : null],
    givens: [for (final ch in cells) '1234'.contains(ch) ? value(ch) : null],
    solution: solution,
  );
}

Set<Pos> _open(SkylinePuzzle p) => {
  for (var i = 0; i < 16; i++)
    if (p.givens[i] == null) p.size.pos(i),
};

TutorialStep _step(Tr text, List<String> rows, String shown) {
  final p = _board(rows, shown);
  return TutorialStep(text: text, puzzle: p, focus: _open(p));
}

// Solution of the small steps:
// 2 1 4 3
// 4 3 2 1
// 1 4 3 2
// 3 2 1 4
final List<TutorialStep> skylineTutorial = [
  _step((l) => l.tutSkyline1, ['2a43', '4321', '1432', '3214'], 'xxxxxxxxxxxxxxxx'),
  // Latin rules allow 1 and 3 either way round; the clue picks one.
  _step((l) => l.tutSkyline2, ['2a4c', '4c2a', '1432', '3214'], '........x.......'),
  _step((l) => l.tutSkyline3, ['2143', 'dcba', '1432', '3214'], '.........x...x..'),
  TutorialStep.generated(
    text: (l) => l.tutSkyline4,
    make: () => generateSkyline(const GenParams(size: GridSize.square(5), difficulty: Difficulty.easy, seed: 2)),
  ),
];

final List<TutorialStep> skylineStrategies = [
  TutorialStep.generated(
    text: (l) => l.tutSkylineS1,
    make: () => generateSkyline(skylineStrategyParams[0]),
  ),
  TutorialStep.generated(
    text: (l) => l.tutSkylineS2,
    make: () => generateSkyline(skylineStrategyParams[1]),
  ),
  TutorialStep.generated(
    text: (l) => l.tutSkylineS3,
    make: () => generateSkyline(skylineStrategyParams[2]),
  ),
];

/// The strategy boards: each needs the tier it teaches (checked in tests).
const skylineStrategyParams = [
  GenParams(size: GridSize.square(5), difficulty: Difficulty.easy, seed: 3),
  GenParams(size: GridSize.square(6), difficulty: Difficulty.medium, seed: 1),
  GenParams(size: GridSize.square(6), difficulty: Difficulty.hard, seed: 1),
];
