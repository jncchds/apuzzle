import '../../core/difficulty.dart';
import '../../core/grid.dart';
import '../../core/tutorial.dart';
import 'homeward_generator.dart';
import 'homeward_model.dart';
import 'homeward_solver.dart';

/// A town with every road but those in [cut] (pairs of neighbouring
/// crossings), fuel = the shortest plan + [slack].
HomewardPuzzle _town(
  int rows,
  int cols, {
  required int start,
  required List<int> pets,
  required List<int> homes,
  required int seats,
  int slack = 0,
  List<(int, int)> cut = const [],
}) {
  final roads = List<int>.filled(rows * cols, 0);
  for (var i = 0; i < rows * cols; i++) {
    for (final d in roadDirs) {
      final j = roadStep(i, d, rows, cols);
      if (j != null && !cut.contains((i, j)) && !cut.contains((j, i))) roads[i] |= d;
    }
  }
  final draft = HomewardPuzzle(
    rows: rows,
    cols: cols,
    roads: roads,
    start: start,
    pets: pets,
    homes: homes,
    seats: seats,
    limit: 0,
    best: 0,
  );
  final best = HomewardSolver(draft).best();
  return HomewardPuzzle(
    rows: rows,
    cols: cols,
    roads: roads,
    start: start,
    pets: pets,
    homes: homes,
    seats: seats,
    limit: best + slack,
    best: best,
  );
}

final List<TutorialStep> homewardTutorial = [
  TutorialStep(
    text: (l) => l.tutHomeward1,
    puzzle: _town(3, 4, start: 4, pets: [2], homes: [11], seats: 1, slack: 2, cut: [(1, 2), (9, 10), (6, 10)]),
    focus: {const Pos(1, 0), const Pos(0, 2), const Pos(2, 3)},
  ),
  TutorialStep(
    text: (l) => l.tutHomeward2,
    puzzle: _town(3, 5, start: 1, pets: [2, 0], homes: [9, 7], seats: 1, slack: 2),
  ),
  TutorialStep(
    text: (l) => l.tutHomeward3,
    puzzle: _town(3, 5, start: 7, pets: [6, 2], homes: [3, 4], seats: 2),
  ),
  TutorialStep.generated(
    text: (l) => l.tutHomeward4,
    make: () => generateHomeward(const GenParams(size: GridSize.square(5), difficulty: Difficulty.easy, seed: 1)),
  ),
];

final List<TutorialStep> homewardStrategies = [
  TutorialStep(
    text: (l) => l.tutHomewardS1,
    puzzle: _town(4, 5, start: 5, pets: [1, 15, 9], homes: [14, 3, 12], seats: 2),
  ),
  TutorialStep.generated(
    text: (l) => l.tutHomewardS2,
    make: () => generateHomeward(const GenParams(size: GridSize.square(7), difficulty: Difficulty.hard, seed: 1)),
  ),
];
