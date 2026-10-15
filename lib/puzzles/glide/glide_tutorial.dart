import '../../core/difficulty.dart';
import '../../core/grid.dart';
import '../../core/tutorial.dart';
import 'glide_model.dart';
import 'glide_solver.dart';
import 'glide_type.dart';

/// A board of [tiles] (row by row, 0 for the gap) with no move limit; its
/// plan is the solver's way out (the fewest moves on 3×3).
GlidePuzzle glideBoard(int rows, int cols, List<int> tiles) {
  assert(glideSolvable(rows, cols, tiles));
  return GlidePuzzle(
    rows: rows,
    cols: cols,
    start: tiles,
    plan: GlideSolver.of(rows, cols).solve(tiles),
    optimal: rows * cols <= 9,
  );
}

/// The board that the gap moves [walk] leave from order.
GlidePuzzle glideWalked(int rows, int cols, String walk) =>
    glideBoard(rows, cols, glideApply(rows, cols, [for (var i = 1; i < rows * cols; i++) i, 0], walk));

final List<TutorialStep> glideTutorial = [
  TutorialStep(
    text: (l) => l.tutGlide1,
    puzzle: glideBoard(3, 3, const [1, 2, 3, 4, 5, 6, 7, 0, 8]),
    focus: {const Pos(2, 2)},
  ),
  TutorialStep(
    text: (l) => l.tutGlide2,
    puzzle: glideBoard(3, 3, const [1, 2, 3, 4, 5, 6, 0, 7, 8]),
    focus: {const Pos(2, 2)},
  ),
  TutorialStep(
    text: (l) => l.tutGlide3,
    puzzle: glideBoard(3, 3, const [1, 2, 0, 4, 5, 3, 7, 8, 6]),
    focus: {const Pos(1, 2)},
  ),
  TutorialStep(text: (l) => l.tutGlide4, puzzle: glideWalked(3, 3, 'ullurdrd')),
  TutorialStep.generated(
    text: (l) => l.tutGlide5,
    make: () => const GlideType().generate(
      const GenParams(size: GridSize.square(3), difficulty: Difficulty.easy, seed: 4, options: {'goal': 'moves'}),
    ),
  ),
];

final List<TutorialStep> glideStrategies = [
  // Only the top two rows are mixed: place the top one, then the rest is small.
  TutorialStep(text: (l) => l.tutGlideS1, puzzle: glideWalked(4, 4, 'uuullldrrrulldlurdrrdd')),
  // 1, 2 and 3 are home, but 4 can't get in past 3 without moving it.
  TutorialStep(
    text: (l) => l.tutGlideS2,
    puzzle: glideBoard(4, 4, const [1, 2, 3, 8, 5, 6, 4, 7, 9, 10, 11, 12, 13, 14, 15, 0]),
    focus: {const Pos(1, 2)},
  ),
  TutorialStep.generated(
    text: (l) => l.tutGlideS3,
    make: () => const GlideType().generate(
      const GenParams(size: GridSize.square(4), difficulty: Difficulty.hard, seed: 6),
    ),
  ),
];
