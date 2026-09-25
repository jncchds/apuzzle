import 'dart:math';

import '../../core/difficulty.dart';
import '../../core/grid.dart';
import '../../core/tutorial.dart';
import 'blend_model.dart';
import 'blend_type.dart';

/// A board from rows of color digits whose move limit is the greedy plan's length.
BlendPuzzle _board(List<String> rows, {int colors = 3}) {
  final start = [for (final ch in rows.join().split('')) int.parse(ch)];
  final plan = blendSolve(start, rows.length, rows.first.length, colors, Random(0));
  return BlendPuzzle(rows: rows.length, cols: rows.first.length, colors: colors, start: start, limit: plan.length, plan: plan);
}

final List<TutorialStep> blendTutorial = [
  TutorialStep(text: (l) => l.tutBlend1, puzzle: _board(['000', '010', '000']), focus: {const Pos(1, 1)}),
  TutorialStep(text: (l) => l.tutBlend2, puzzle: _board(['010', '121', '010']), focus: {const Pos(1, 1)}),
  TutorialStep.generated(
    text: (l) => l.tutBlend3,
    make: () => const BlendType().generate(const GenParams(size: GridSize.square(5), difficulty: Difficulty.easy, seed: 4)),
  ),
];
