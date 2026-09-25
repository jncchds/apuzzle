import '../../core/difficulty.dart';
import '../../core/grid.dart';
import '../../core/tutorial.dart';
import 'pop_generator.dart';
import 'pop_model.dart';

/// A board from rows of color digits. [plan] lists one starting cell (row,
/// column) of each group to pop, in order.
PopPuzzle _board(List<String> rows, List<(int, int)> plan, {PopGoal goal = PopGoal.clear, int target = 0}) {
  final cols = rows.first.length;
  final start = [for (final ch in rows.join().split('')) int.parse(ch)];
  return PopPuzzle(
    rows: rows.length,
    cols: cols,
    colors: start.reduce((a, b) => a > b ? a : b) + 1,
    mode: PopMode.standard,
    goal: goal,
    start: start,
    reserve: const [],
    target: target,
    plan: [for (final (r, c) in plan) r * cols + c],
  );
}

final List<TutorialStep> popTutorial = [
  TutorialStep(text: (l) => l.tutPop1, puzzle: _board(['100', '100'], [(0, 1), (0, 0)])),
  TutorialStep(
    text: (l) => l.tutPop2,
    puzzle: _board(['01', '11', '00'], [(0, 1), (2, 0)]),
    focus: {const Pos(0, 1), const Pos(1, 0), const Pos(1, 1)},
  ),
  TutorialStep(text: (l) => l.tutPop3, puzzle: _board(['2112', '0110'], [(0, 1), (1, 0), (0, 0)])),
  TutorialStep(
    text: (l) => l.tutPop4,
    puzzle: _board(['220', '010', '010'], [(0, 0), (1, 1), (1, 0)], goal: PopGoal.target, target: 20),
  ),
  TutorialStep.generated(
    text: (l) => l.tutPop5,
    look: true,
    make: () => generatePop(
      const GenParams(size: GridSize.square(6), difficulty: Difficulty.easy, seed: 2),
      PopMode.mega,
      PopGoal.free,
    ),
  ),
];
