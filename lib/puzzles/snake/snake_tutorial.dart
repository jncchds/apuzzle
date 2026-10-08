import '../../core/difficulty.dart';
import '../../core/grid.dart';
import '../../core/tutorial.dart';
import 'snake_generator.dart';
import 'snake_model.dart';

/// A slow tutorial board: eat [target] apples.
SnakePuzzle _board(int rows, int cols, List<int> body, SnakeDir dir, int food, int target) => SnakePuzzle(
  rows: rows,
  cols: cols,
  goal: SnakeGoal.target,
  target: target,
  seed: 7,
  stepMs: 330,
  start: body,
  dir: dir,
  food: food,
);

final List<TutorialStep> snakeTutorial = [
  TutorialStep(text: (l) => l.tutSnake1, puzzle: _board(5, 5, [11, 10], SnakeDir.right, 3, 1)),
  TutorialStep(text: (l) => l.tutSnake2, puzzle: _board(6, 6, [20, 19, 18], SnakeDir.right, 10, 3)),
  TutorialStep.generated(
    text: (l) => l.tutSnake3,
    make: () {
      final p = generateSnake(
        const GenParams(size: GridSize.square(8), difficulty: Difficulty.easy, seed: 11),
        SnakeGoal.target,
      );
      return _board(p.rows, p.cols, p.start, p.dir, p.food, 5);
    },
  ),
];

final List<TutorialStep> snakeStrategies = [
  // A long snake across the top two rows, its head at the left wall.
  TutorialStep(
    text: (l) => l.tutSnakeS1,
    puzzle: _board(6, 6, [6, 7, 8, 9, 10, 11, 5, 4, 3, 2, 1, 0], SnakeDir.left, 28, 3),
  ),
];
