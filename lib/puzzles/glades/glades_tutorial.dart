import '../../core/difficulty.dart';
import '../../core/grid.dart';
import '../../core/tutorial.dart';
import 'glades_generator.dart';
import 'glades_model.dart';
import '../../core/explain.dart';
import 'glades_solver.dart';

/// A board from rows separated by `|`, cells by spaces: `#` is shaded, `.`
/// unshaded, an unshaded cell followed by its number (`.2`).
GladesPuzzle gladesBoard(String board) {
  final rows = board.split('|');
  final cells = [for (final r in rows) ...r.trim().split(' ')];
  return GladesPuzzle(
    n: rows.length,
    clues: [for (final c in cells) int.tryParse(c.substring(1))],
    shaded: [for (final c in cells) c.startsWith('#')],
  );
}

final List<TutorialStep> gladesTutorial = [
  // The 1s close themselves off; the 2 has one way to grow.
  TutorialStep(
    text: (l) => l.tutGlades1,
    puzzle: gladesBoard('# .1 # .1|# # . #|.1 # .2 #|# .1 # .1'),
    focus: {const Pos(0, 1), const Pos(2, 2), const Pos(1, 2)},
  ),
  // Three shaded cells of a 2×2 block keep the fourth.
  TutorialStep(
    text: (l) => l.tutGlades2,
    puzzle: gladesBoard('.1 # # .1 #|# .4 . # .3|# . . # .|# # # # .|. . . .4 #'),
    focus: {const Pos(4, 3), const Pos(4, 0)},
  ),
  // The corner 1s can only meet the rest through the middle.
  TutorialStep(
    text: (l) => l.tutGlades3,
    puzzle: gladesBoard('.1 # # .1|# . . #|# . .4 #|.1 # # .1'),
    focus: {const Pos(0, 0), const Pos(1, 1), const Pos(2, 2)},
  ),
  // A cell between two numbers would put both into one rectangle.
  TutorialStep(
    text: (l) => l.tutGlades4,
    puzzle: gladesBoard('. . .3 #|# # # .1|.1 # .1 #|# .1 # .1'),
    focus: {const Pos(0, 2), const Pos(1, 3)},
  ),
  TutorialStep.generated(
    text: (l) => l.tutGlades5,
    make: () => generateGlades(const GenParams(size: GridSize.square(5), difficulty: Difficulty.easy, seed: 1)),
  ),
];

/// Generated strategy boards: medium needs cuts, rectangles and cells no
/// number reaches, hard needs probing.
const gladesStrategyParams = [
  GenParams(size: GridSize.square(6), difficulty: Difficulty.medium, seed: 1),
  GenParams(size: GridSize.square(7), difficulty: Difficulty.hard, seed: 1),
];

/// The lesson board for every rectangle a number can be.
final gladesRectBoard = gladesBoard('# # .1 # #|# .1 # .2 .|.1 # # # #|# . . . .4|# # # # #');

final List<TutorialStep> gladesStrategies = [
  TutorialStep(
    text: (l) => l.tutGladesS1,
    teaches: {GladesRule.rectIn.index, GladesRule.rectOut.index},
    puzzle: gladesRectBoard,
    focus: {const Pos(3, 4)},
  ),
  TutorialStep.generated(
    text: (l) => l.tutGladesS2,
    teaches: {GladesRule.orphan.index, GladesRule.cut.index},
    make: () => generateGlades(gladesStrategyParams[0]),
  ),
  TutorialStep.generated(
    text: (l) => l.tutGladesS3,
    teaches: {ruleRefuted},
    make: () => generateGlades(gladesStrategyParams[1]),
  ),
];
