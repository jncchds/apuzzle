import '../../core/difficulty.dart';
import '../../core/grid.dart';
import '../../core/tutorial.dart';
import 'slabs_generator.dart';
import 'slabs_model.dart';
import '../../core/explain.dart';
import 'slabs_solver.dart';

/// A board from rows separated by `|`, cells by spaces: `#` is shaded, `.`
/// unshaded, either one followed by its number (`#2`, `.5`).
SlabsPuzzle slabsBoard(String board) {
  final rows = board.split('|');
  final cells = [for (final r in rows) ...r.trim().split(' ')];
  return SlabsPuzzle(
    n: rows.length,
    clues: [for (final c in cells) int.tryParse(c.substring(1))],
    shaded: [for (final c in cells) c.startsWith('#')],
  );
}

final List<TutorialStep> slabsTutorial = [
  // Both 2s are shaded; the cell between them would join them into three.
  TutorialStep(
    text: (l) => l.tutSlabs1,
    puzzle: slabsBoard('#2 # .|. . .|#2 # .'),
    focus: {const Pos(0, 0), const Pos(2, 0), const Pos(1, 0)},
  ),
  // The two 2s side by side are one full area: the cells round them stay.
  TutorialStep(
    text: (l) => l.tutSlabs2,
    puzzle: slabsBoard('#2 #2 .|. . .|. # #2'),
    focus: {const Pos(0, 0), const Pos(0, 1)},
  ),
  // The corners beside the 1 would be unshaded squares on their own.
  TutorialStep(
    text: (l) => l.tutSlabs3,
    puzzle: slabsBoard('. #1 .|. . .|# # #3'),
    focus: {const Pos(0, 1), const Pos(0, 0), const Pos(0, 2)},
  ),
  TutorialStep.generated(
    text: (l) => l.tutSlabs4,
    make: () => generateSlabs(const GenParams(size: GridSize.square(5), difficulty: Difficulty.easy, seed: 1)),
  ),
];

/// Generated strategy boards: medium needs rectangles and reach, hard needs
/// probing.
const slabsStrategyParams = [
  GenParams(size: GridSize.square(6), difficulty: Difficulty.medium, seed: 1),
  GenParams(size: GridSize.square(7), difficulty: Difficulty.hard, seed: 1),
];

final List<TutorialStep> slabsStrategies = [
  // No rectangle of 7 cells fits a 4×4 board, so the 7 stays unshaded.
  TutorialStep(
    text: (l) => l.tutSlabsS1,
    teaches: {SlabsRule.noRect.index, SlabsRule.rectIn.index, SlabsRule.rectOut.index},
    puzzle: slabsBoard('. . . .|. # # #3|# . . .7|. . . .'),
    focus: {const Pos(2, 3), const Pos(1, 3)},
  ),
  TutorialStep.generated(
    text: (l) => l.tutSlabsS2,
    teaches: {SlabsRule.reach.index, SlabsRule.reachAll.index},
    make: () => generateSlabs(slabsStrategyParams[0]),
  ),
  TutorialStep.generated(
    text: (l) => l.tutSlabsS3,
    teaches: {ruleRefuted},
    make: () => generateSlabs(slabsStrategyParams[1]),
  ),
];
