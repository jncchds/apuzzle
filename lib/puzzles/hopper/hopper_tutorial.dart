import '../../core/grid.dart';
import '../../core/recall.dart';
import '../../core/tutorial.dart';
import 'hopper_type.dart';

final List<TutorialStep> hopperTutorial = [
  // Three hops down the diagonal.
  TutorialStep(
    text: (l) => l.tutHopper1,
    puzzle: recallPractice(
      const HopperType(),
      const GridSize.square(3),
      fixed: const [
        [0, 4, 8],
      ],
    ),
  ),
  // Pads that come up twice.
  TutorialStep(
    text: (l) => l.tutHopper2,
    puzzle: recallPractice(
      const HopperType(),
      const GridSize.square(3),
      start: 3,
      fixed: const [
        [1, 7, 1],
        [3, 5, 4, 3],
      ],
    ),
  ),
  // Backwards.
  TutorialStep(
    text: (l) => l.tutHopper3,
    puzzle: recallPractice(
      const HopperType(),
      const GridSize.square(3),
      variant: 'rev',
      fixed: const [
        [0, 2, 8],
      ],
    ),
  ),
  TutorialStep.generated(
    text: (l) => l.tutHopper4,
    make: () => recallPractice(const HopperType(), const GridSize.square(4), rounds: 3, start: 3, seed: 11),
  ),
];
