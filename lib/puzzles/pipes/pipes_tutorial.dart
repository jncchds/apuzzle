import '../../core/difficulty.dart';
import '../../core/grid.dart';
import '../../core/tutorial.dart';
import 'pipes_generator.dart';
import 'pipes_model.dart';

final List<TutorialStep> pipesTutorial = [
  TutorialStep(
    text: (l) => l.tutPipes1,
    puzzle: const PipesPuzzle(
      rows: 2,
      cols: 2,
      source: 0,
      masks: [dE | dS, dW, dN | dE, dW],
      start: [0, 2, 1, 3],
      locked: [true, false, false, false],
    ),
  ),
  TutorialStep(
    text: (l) => l.tutPipes2,
    puzzle: const PipesPuzzle(
      rows: 3,
      cols: 3,
      source: 4,
      masks: [dE, dE | dS | dW, dW, dE, dN | dE | dS | dW, dW, dE, dN | dE | dW, dW],
      start: [1, 2, 3, 2, 0, 1, 3, 1, 2],
      locked: [false, false, false, false, true, false, false, false, false],
    ),
  ),
  TutorialStep.generated(
    text: (l) => l.tutPipes3,
    make: () => generatePipes(const GenParams(size: GridSize.square(5), difficulty: Difficulty.easy, seed: 6)),
  ),
];
