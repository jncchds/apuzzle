import '../../core/difficulty.dart';
import '../../core/grid.dart';
import '../../core/tutorial.dart';
import '../../l10n/l10n.dart';
import 'totals_generator.dart';
import 'totals_model.dart';

/// A board from rows of `#` (clue cells) and digits (cells to fill).
TotalsPuzzle totalsBoard(List<String> rows) => TotalsPuzzle(
  rows: rows.length,
  cols: rows.first.length,
  digits: [for (final ch in rows.join().split('')) ch == '#' ? -1 : int.parse(ch) - 1],
);

TutorialStep _step(Tr text, List<String> rows) {
  final p = totalsBoard(rows);
  return TutorialStep(
    text: text,
    puzzle: p,
    focus: {
      for (var i = 0; i < p.digits.length; i++)
        if (!p.isBlock(i)) p.size.pos(i),
    },
  );
}

final List<TutorialStep> totalsTutorial = [
  // 3 across and 4 down from the corner: 1 + 2 and 1 + 3 share the 1.
  _step((l) => l.tutTotals1, ['###', '#12', '#34']),
  // 4 in two cells is 1 + 3, never 2 + 2.
  _step((l) => l.tutTotals2, ['###', '#31', '#12']),
  // 24 down is 7 + 8 + 9, 7 down is 1 + 2 + 4.
  _step((l) => l.tutTotals3, ['####', '#892', '#681', '#974']),
  TutorialStep.generated(
    text: (l) => l.tutTotals4,
    make: () => generateTotals(const GenParams(size: GridSize.square(6), difficulty: Difficulty.easy, seed: 3)),
  ),
];

final List<TutorialStep> totalsStrategies = [
  TutorialStep.generated(text: (l) => l.tutTotalsS1, make: () => generateTotals(totalsStrategyParams[0])),
  TutorialStep.generated(text: (l) => l.tutTotalsS2, make: () => generateTotals(totalsStrategyParams[1])),
  TutorialStep.generated(text: (l) => l.tutTotalsS3, make: () => generateTotals(totalsStrategyParams[2])),
];

/// The strategy boards: each needs the tier it teaches (checked in tests).
const totalsStrategyParams = [
  GenParams(size: GridSize.square(7), difficulty: Difficulty.easy, seed: 1),
  GenParams(size: GridSize.square(7), difficulty: Difficulty.medium, seed: 1),
  GenParams(size: GridSize.square(7), difficulty: Difficulty.hard, seed: 1),
];
