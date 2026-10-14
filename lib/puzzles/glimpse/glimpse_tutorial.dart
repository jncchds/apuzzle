import '../../core/grid.dart';
import '../../core/recall.dart';
import '../../core/tutorial.dart';
import 'glimpse_type.dart';

final List<TutorialStep> glimpseTutorial = [
  // Three cells on a diagonal.
  TutorialStep(
    text: (l) => l.tutGlimpse1,
    puzzle: recallPractice(
      const GlimpseType(),
      const GridSize.square(3),
      fixed: const [
        [0, 4, 8],
      ],
    ),
  ),
  // Four scattered cells, then five.
  TutorialStep(
    text: (l) => l.tutGlimpse2,
    puzzle: recallPractice(
      const GlimpseType(),
      const GridSize.square(4),
      start: 4,
      fixed: const [
        [1, 6, 11, 12],
        [0, 3, 5, 10, 14],
      ],
    ),
  ),
  TutorialStep.generated(
    text: (l) => l.tutGlimpse3,
    make: () => recallPractice(const GlimpseType(), const GridSize.square(5), rounds: 3, start: 3, seed: 11),
  ),
];
