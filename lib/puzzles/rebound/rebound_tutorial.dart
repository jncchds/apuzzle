import '../../core/grid.dart';
import '../../core/recall.dart';
import '../../core/tutorial.dart';
import 'rebound_type.dart';

final List<TutorialStep> reboundTutorial = [
  // In from the left on the second row, up off one bumper and out at the top.
  TutorialStep(
    text: (l) => l.tutRebound1,
    puzzle: recallPractice(
      const ReboundType(),
      const GridSize.square(4),
      fixed: const [
        [13, 12],
      ],
    ),
  ),
  // Down, right and up again, past a bumper it never meets.
  TutorialStep(
    text: (l) => l.tutRebound2,
    puzzle: recallPractice(
      const ReboundType(),
      const GridSize.square(4),
      start: 3,
      fixed: const [
        [0, 17, 22, 4],
      ],
    ),
  ),
  TutorialStep.generated(
    text: (l) => l.tutRebound3,
    make: () => recallPractice(const ReboundType(), const GridSize.square(5), rounds: 3, start: 2, seed: 11),
  ),
];
