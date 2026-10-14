import '../../core/grid.dart';
import '../../core/recall.dart';
import '../../core/tutorial.dart';
import 'vanish_type.dart';

final List<TutorialStep> vanishTutorial = [
  // 1 in the middle, 2 and 3 in opposite corners.
  TutorialStep(
    text: (l) => l.tutVanish1,
    puzzle: recallPractice(
      const VanishType(),
      const GridSize.square(3),
      fixed: const [
        [4, 0, 8],
      ],
    ),
  ),
  TutorialStep(
    text: (l) => l.tutVanish2,
    puzzle: recallPractice(
      const VanishType(),
      const GridSize.square(4),
      start: 4,
      fixed: const [
        [9, 2, 15, 4],
        [6, 12, 3, 0, 10],
      ],
    ),
  ),
  TutorialStep.generated(
    text: (l) => l.tutVanish3,
    make: () => recallPractice(const VanishType(), const GridSize.square(5), rounds: 3, start: 4, seed: 11),
  ),
];
