import '../../core/difficulty.dart';
import '../../core/grid.dart';
import '../../core/tutorial.dart';
import 'mosaic_model.dart';
import 'mosaic_type.dart';

/// A board from rows of color digits, with the greedy plan's length (plus
/// [slack]) as the move limit.
MosaicPuzzle _board(List<String> rows, {int colors = 3, int slack = 0}) {
  final start = [for (final ch in rows.join().split('')) int.parse(ch)];
  final plan = floodSolve(start, rows.length, rows.first.length, colors);
  return MosaicPuzzle(
    rows: rows.length,
    cols: rows.first.length,
    colors: colors,
    start: start,
    limit: plan.length + slack,
    plan: plan,
  );
}

final List<TutorialStep> mosaicTutorial = [
  TutorialStep(text: (l) => l.tutMosaic1, puzzle: _board(['012', '112', '222'], slack: 1), focus: {const Pos(0, 0)}),
  TutorialStep(text: (l) => l.tutMosaic2, puzzle: _board(['0012', '1112', '2202', '0222', '1100'])),
  TutorialStep.generated(
    text: (l) => l.tutMosaic3,
    make: () => const MosaicType().generate(const GenParams(size: GridSize.square(6), difficulty: Difficulty.easy, seed: 5)),
  ),
];
