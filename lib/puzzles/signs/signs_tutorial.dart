import '../../core/difficulty.dart';
import '../../core/grid.dart';
import '../../core/tutorial.dart';
import '../../l10n/l10n.dart';
import 'signs_generator.dart';
import 'signs_model.dart';

/// A 4×4 board from rows of numbers (given) and letters a–d (a cell to fill
/// with 1–4), with signs between cells in a row ([across]: one string per
/// row, `<`, `>` or `.` per gap) and between rows ([down]: one string per
/// gap between rows, `^` = the upper cell is smaller, `v` = bigger, `.`).
SignsPuzzle _board(List<String> rows, {Map<int, String> across = const {}, Map<int, String> down = const {}}) {
  final cells = rows.join().split('');
  int value(String ch) => '1234'.contains(ch) ? int.parse(ch) - 1 : 'abcd'.indexOf(ch);
  final signs = <Sign>[];
  across.forEach((r, gaps) {
    for (var c = 0; c < 3; c++) {
      final i = r * 4 + c;
      if (gaps[c] == '<') signs.add(Sign(i, i + 1));
      if (gaps[c] == '>') signs.add(Sign(i + 1, i));
    }
  });
  down.forEach((r, gaps) {
    for (var c = 0; c < 4; c++) {
      final i = r * 4 + c;
      if (gaps[c] == '^') signs.add(Sign(i, i + 4));
      if (gaps[c] == 'v') signs.add(Sign(i + 4, i));
    }
  });
  return SignsPuzzle(
    n: 4,
    signs: signs,
    givens: [for (final ch in cells) '1234'.contains(ch) ? value(ch) : null],
    solution: [for (final ch in cells) value(ch)],
  );
}

TutorialStep _step(Tr text, SignsPuzzle p) => TutorialStep(
  text: text,
  puzzle: p,
  focus: {
    for (var i = 0; i < 16; i++)
      if (p.givens[i] == null) p.size.pos(i),
  },
);

// Solution of the small steps:
// 1 2 3 4
// 3 4 1 2
// 4 3 2 1
// 2 1 4 3
final List<TutorialStep> signsTutorial = [
  // Two squares of cells that rows and columns allow both ways; a sign picks one.
  _step((l) => l.tutSigns1, _board(['ab34', '34ab', '43ba', 'ba43'], across: {0: '<..'}, down: {1: '..^.'})),
  // The third row falls from left to right.
  _step((l) => l.tutSigns2, _board(['1234', '3412', 'dcba', 'badc'], across: {2: '>>>'})),
  // The second cell of the second row is bigger than both its neighbours.
  _step((l) => l.tutSigns3, _board(['abcd', 'cdab', '4321', '2143'], across: {1: '<><'})),
  TutorialStep.generated(text: (l) => l.tutSigns4, make: () => generateSigns(signsTutorialParams)),
];

const signsTutorialParams = GenParams(size: GridSize.square(5), difficulty: Difficulty.easy, seed: 1);

final List<TutorialStep> signsStrategies = [
  TutorialStep.generated(text: (l) => l.tutSignsS1, make: () => generateSigns(signsStrategyParams[0])),
  TutorialStep.generated(text: (l) => l.tutSignsS2, make: () => generateSigns(signsStrategyParams[1])),
  TutorialStep.generated(text: (l) => l.tutSignsS3, make: () => generateSigns(signsStrategyParams[2])),
];

/// The strategy boards: each needs the tier it teaches (checked in tests).
const signsStrategyParams = [
  GenParams(size: GridSize.square(5), difficulty: Difficulty.easy, seed: 2),
  GenParams(size: GridSize.square(6), difficulty: Difficulty.medium, seed: 1),
  GenParams(size: GridSize.square(6), difficulty: Difficulty.hard, seed: 1),
];
