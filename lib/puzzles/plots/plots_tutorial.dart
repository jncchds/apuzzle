import '../../core/difficulty.dart';
import '../../core/grid.dart';
import '../../core/tutorial.dart';
import 'plots_generator.dart';
import 'plots_model.dart';

/// A board from the solution's digits and the shown ones ('.' for empty).
PlotsPuzzle _board(List<String> solution, List<String> shown) => PlotsPuzzle(
      rows: solution.length,
      cols: solution.first.length,
      maxValue: 4,
      givens: [for (final ch in shown.join().split('')) ch == '.' ? null : int.parse(ch) - 1],
      solution: [for (final ch in solution.join().split('')) int.parse(ch) - 1],
    );

final List<TutorialStep> plotsTutorial = [
  TutorialStep(
    text: (l) => l.tutPlots1,
    puzzle: _board(['333', '122', '333'], ['3..', '12.', '..3']),
    focus: {const Pos(0, 0)},
  ),
  TutorialStep(
    text: (l) => l.tutPlots2,
    puzzle: _board(['221', '312', '332'], ['22.', '.12', '3..']),
    focus: {const Pos(0, 2)},
  ),
  TutorialStep.generated(
    text: (l) => l.tutPlots3,
    make: () => generatePlots(const GenParams(size: GridSize.square(5), difficulty: Difficulty.easy, seed: 2)),
  ),
];
