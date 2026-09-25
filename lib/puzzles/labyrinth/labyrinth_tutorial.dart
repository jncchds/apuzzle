import '../../core/difficulty.dart';
import '../../core/grid.dart';
import '../../core/tutorial.dart';
import 'labyrinth_generator.dart';

final List<TutorialStep> labyrinthTutorial = [
  TutorialStep.generated(
    text: (l) => l.tutLabyrinth1,
    make: () => generateLabyrinth(const GenParams(size: GridSize.square(4), difficulty: Difficulty.easy, seed: 1)),
  ),
  TutorialStep.generated(
    text: (l) => l.tutLabyrinth2,
    make: () => generateLabyrinth(const GenParams(size: GridSize.square(7), difficulty: Difficulty.hard, seed: 2)),
  ),
];
