import '../../core/difficulty.dart';
import '../../core/grid.dart';
import '../../core/tutorial.dart';
import '../../l10n/l10n.dart';
import 'between_generator.dart';
import 'between_model.dart';

/// A board from rows of cells: `#` a shaded given, `x` a cell to shade,
/// digits given numbers, letters a–g the numbers 1–7 to fill in. [shown]
/// picks the clues (rows, then columns; `x` = shown).
BetweenPuzzle betweenBoard(List<String> rows, String shown) {
  final n = rows.length;
  final cells = rows.join().split('');
  int value(String ch) => switch (ch) {
    '#' || 'x' => betweenShade,
    _ when 'abcdefg'.contains(ch) => 'abcdefg'.indexOf(ch) + 1,
    _ => int.parse(ch),
  };
  final solution = [for (final ch in cells) value(ch)];
  final clues = betweenClues(n, solution);
  return BetweenPuzzle(
    n: n,
    clues: [for (var u = 0; u < 2 * n; u++) shown[u] == 'x' ? clues[u] : null],
    givens: [for (final ch in cells) ch == 'x' || 'abcdefg'.contains(ch) ? null : value(ch)],
    solution: solution,
  );
}

Set<Pos> _open(BetweenPuzzle p) => {
  for (var i = 0; i < p.givens.length; i++)
    if (p.givens[i] == null) p.size.pos(i),
};

TutorialStep _step(Tr text, List<String> rows, String shown) {
  final p = betweenBoard(rows, shown);
  return TutorialStep(text: text, puzzle: p, focus: _open(p));
}

// Solution of the first and third steps (the second has its own):
// # 1 2 # 3
// 1 # 3 2 #
// # 2 # 3 1
// 3 # 1 # 2
// 2 3 # 1 #
final List<TutorialStep> betweenTutorial = [
  // Every row and column: two shaded cells and 1, 2, 3 once.
  _step((l) => l.tutBetween1, ['#12#3', '1#c2#', '#2#31', '3#1#2', 'bcxax'], 'xxxxxxxxxx'),
  // A clue of 0 puts the shaded cells side by side, the largest one at the ends.
  _step((l) => l.tutBetween2, ['abcxx', 'xxac2', 'cx#ba', 'x1bxc', '2cxax'], 'xxx...x..x'),
  // With the shaded cells known, the clue says which numbers lie between.
  _step((l) => l.tutBetween3, ['#ab#c', '1#cb#', '#b#ca', '3#1#2', '23#1#'], 'x.x.......'),
  TutorialStep.generated(
    text: (l) => l.tutBetween4,
    make: () => generateBetween(const GenParams(size: GridSize.square(5), difficulty: Difficulty.easy, seed: 1)),
  ),
];

final List<TutorialStep> betweenStrategies = [
  TutorialStep.generated(text: (l) => l.tutBetweenS1, make: () => generateBetween(betweenStrategyParams[0])),
  TutorialStep.generated(text: (l) => l.tutBetweenS2, make: () => generateBetween(betweenStrategyParams[1])),
];

/// The strategy boards: each needs the tier it teaches (checked in tests).
const betweenStrategyParams = [
  GenParams(size: GridSize.square(6), difficulty: Difficulty.medium, seed: 1),
  GenParams(size: GridSize.square(6), difficulty: Difficulty.hard, seed: 1),
];
