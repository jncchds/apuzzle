import '../../core/difficulty.dart';
import '../../core/grid.dart';
import '../../core/tutorial.dart';
import '../../l10n/l10n.dart';
import 'pockets_generator.dart';
import 'pockets_model.dart';

/// A board from its solution, its pockets (a letter per cell) and the shown
/// digits ('.' for a cell to fill), each as rows joined by '|'.
PocketsPuzzle pocketsBoard(String solution, String pockets, String shown) {
  final digits = solution.replaceAll('|', '').split('');
  final letters = pockets.replaceAll('|', '').split('');
  final seen = shown.replaceAll('|', '').split('');
  final n = solution.indexOf('|');
  final values = [for (final ch in digits) int.parse(ch) - 1];
  final cells = <String, List<int>>{};
  for (var i = 0; i < letters.length; i++) {
    cells.putIfAbsent(letters[i], () => []).add(i);
  }
  return PocketsPuzzle(
    n: n,
    pockets: [for (final c in cells.values) Pocket(c, c.fold(0, (s, i) => s + values[i] + 1))]
      ..sort((a, b) => a.cells.first - b.cells.first),
    givens: [for (final ch in seen) ch == '.' ? null : int.parse(ch) - 1],
    solution: values,
  );
}

TutorialStep _step(Tr text, String pockets, String shown) {
  final p = pocketsBoard('1234|3412|2143|4321', pockets, shown);
  return TutorialStep(
    text: text,
    puzzle: p,
    focus: {
      for (var i = 0; i < p.givens.length; i++)
        if (p.givens[i] == null) p.size.pos(i),
    },
  );
}

final List<TutorialStep> pocketsTutorial = [
  // 3 in two cells is 1 + 2, 7 is 3 + 4; the columns tell which goes where.
  _step((l) => l.tutPockets1, 'aabb|ccdd|effg|ehhg', '....|3412|2143|4321'),
  // Three cells of a 4 × 4 leave one digit out: 6 is 1 + 2 + 3, 8 is 1 + 3 + 4.
  _step((l) => l.tutPockets2, 'aabb|accc|eedd|fffd', '..34|.412|21..|432.'),
  TutorialStep.generated(
    text: (l) => l.tutPockets3,
    make: () => generatePockets(const GenParams(size: GridSize.square(4), difficulty: Difficulty.easy, seed: 1)),
  ),
  TutorialStep.generated(
    text: (l) => l.tutPockets4,
    make: () => generatePockets(const GenParams(size: GridSize.square(6), difficulty: Difficulty.easy, seed: 1)),
  ),
];

final List<TutorialStep> pocketsStrategies = [
  TutorialStep.generated(text: (l) => l.tutPocketsS1, make: () => generatePockets(pocketsStrategyParams[0])),
  TutorialStep.generated(text: (l) => l.tutPocketsS2, make: () => generatePockets(pocketsStrategyParams[1])),
  TutorialStep.generated(text: (l) => l.tutPocketsS3, make: () => generatePockets(pocketsStrategyParams[2])),
];

/// The strategy boards: each needs the tier it teaches, and the first two
/// need their technique first (checked in tests).
const pocketsStrategyParams = [
  GenParams(size: GridSize.square(6), difficulty: Difficulty.medium, seed: 1),
  GenParams(size: GridSize.square(6), difficulty: Difficulty.medium, seed: 4),
  GenParams(size: GridSize.square(6), difficulty: Difficulty.hard, seed: 1),
];
