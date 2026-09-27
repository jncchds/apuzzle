import '../../core/difficulty.dart';
import '../../core/grid.dart';
import '../../core/tutorial.dart';
import 'links_generator.dart';
import 'links_model.dart';

final List<TutorialStep> linksTutorial = [
  TutorialStep(
    text: (l) => l.tutLinks1,
    puzzle: const LinksPuzzle(rows: 3, cols: 3, paths: [
      [0, 1, 2],
      [3, 4, 5],
      [6, 7, 8],
    ]),
  ),
  TutorialStep(
    text: (l) => l.tutLinks2,
    puzzle: const LinksPuzzle(rows: 4, cols: 4, paths: [
      [10, 6, 5, 4, 0, 1],
      [8, 12, 13, 9],
      [2, 3, 7, 11, 15, 14],
    ]),
  ),
  TutorialStep.generated(
    text: (l) => l.tutLinks3,
    make: () => generateLinks(const GenParams(size: GridSize.square(6), difficulty: Difficulty.easy, seed: 3)),
  ),
];

final List<TutorialStep> linksStrategies = [
  TutorialStep.generated(
    text: (l) => l.tutLinksS1,
    make: () => generateLinks(const GenParams(size: GridSize.square(5), difficulty: Difficulty.medium, seed: 1)),
  ),
  TutorialStep.generated(
    text: (l) => l.tutLinksS2,
    make: () => generateLinks(const GenParams(size: GridSize.square(7), difficulty: Difficulty.hard, seed: 1)),
  ),
];
