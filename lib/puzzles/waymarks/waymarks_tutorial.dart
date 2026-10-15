import '../../core/difficulty.dart';
import '../../core/grid.dart';
import '../../core/tutorial.dart';
import 'waymarks_generator.dart';
import 'waymarks_model.dart';

/// A board from its path (cells as row * n + column, in number order) and
/// the numbers shown (1 and the last are added).
WaymarksPuzzle waymarksBoard(int n, List<int> path, List<int> shown) => WaymarksPuzzle(
  n: n,
  path: path,
  shown: [for (var x = 1; x <= n * n; x++) x == 1 || x == n * n || shown.contains(x)],
);

/// The generated boards of the strategy lessons (pinned seeds that need
/// their tier).
const List<GenParams> waymarksStrategyParams = [
  GenParams(size: GridSize.square(6), difficulty: Difficulty.hard, seed: 1),
];

final List<TutorialStep> waymarksTutorial = [
  TutorialStep(text: (l) => l.tutWaymarks1, puzzle: waymarksBoard(3, [7, 1, 5, 3, 0, 8, 6, 2, 4], const [])),
  TutorialStep(
    text: (l) => l.tutWaymarks2,
    puzzle: waymarksBoard(4, [11, 3, 15, 7, 13, 14, 2, 1, 0, 10, 8, 12, 6, 4, 9, 5], const []),
  ),
  TutorialStep(
    text: (l) => l.tutWaymarks3,
    puzzle: waymarksBoard(4, [11, 1, 3, 0, 15, 12, 8, 2, 14, 13, 9, 10, 5, 7, 6, 4], const [12, 13]),
  ),
  TutorialStep(
    text: (l) => l.tutWaymarks4,
    puzzle: waymarksBoard(4, [6, 3, 11, 7, 15, 14, 12, 4, 9, 1, 13, 10, 8, 0, 5, 2], const []),
  ),
  TutorialStep.generated(
    text: (l) => l.tutWaymarks5,
    make: () => generateWaymarks(const GenParams(size: GridSize.square(5), difficulty: Difficulty.easy, seed: 3)),
  ),
];

final List<TutorialStep> waymarksStrategies = [
  TutorialStep(
    text: (l) => l.tutWaymarksS1,
    puzzle: waymarksBoard(4, [11, 7, 3, 15, 12, 0, 1, 13, 8, 4, 14, 2, 10, 6, 5, 9], const [13]),
  ),
  TutorialStep(
    text: (l) => l.tutWaymarksS2,
    puzzle: waymarksBoard(4, [10, 2, 14, 11, 7, 6, 1, 3, 15, 0, 12, 13, 5, 9, 4, 8], const [4]),
  ),
  for (final params in waymarksStrategyParams)
    TutorialStep.generated(text: (l) => l.tutWaymarksS3, make: () => generateWaymarks(params)),
];
