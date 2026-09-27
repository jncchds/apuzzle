import '../../core/difficulty.dart';
import '../../core/grid.dart';
import '../../core/tutorial.dart';
import 'arrows_generator.dart';
import 'arrows_model.dart';

// Clue in the middle (0 shaded above): the loop runs round the edge.
final _ring = ArrowsPuzzle.fromJson(const {
  'rows': 3,
  'cols': 3,
  'arrows': [-1, -1, -1, -1, 0, -1, -1, -1, -1],
  'counts': [0, 0, 0, 0, 0, 0, 0, 0, 0],
  'shaded': <int>[],
  'lines': [0, 1, 4, 5, 6, 8, 9, 11],
});

// Two "1 to the right" clues; each points at the one shaded cell.
final _shades = ArrowsPuzzle.fromJson(const {
  'rows': 4,
  'cols': 4,
  'arrows': [-1, -1, -1, -1, -1, 1, -1, -1, -1, -1, -1, -1, -1, -1, 1, -1],
  'counts': [0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0],
  'shaded': [6, 15],
  'lines': [0, 1, 2, 7, 8, 9, 12, 15, 16, 19, 20, 21],
});

final List<TutorialStep> arrowsTutorial = [
  TutorialStep(text: (l) => l.tutArrows1, puzzle: _ring, focus: {const Pos(1, 1)}),
  TutorialStep(text: (l) => l.tutArrows2, puzzle: _shades, focus: {const Pos(1, 1), const Pos(3, 2)}),
  TutorialStep.generated(
    text: (l) => l.tutArrows3,
    make: () => generateArrows(const GenParams(size: GridSize.square(6), difficulty: Difficulty.easy, seed: 3)),
  ),
];

final List<TutorialStep> arrowsStrategies = [
  // Seed 7: the middle row's "2 to the right" has exactly three free cells
  // (the top row's has two, around a clue).
  TutorialStep.generated(
    text: (l) => l.tutArrowsS1,
    make: () => generateArrows(const GenParams(size: GridSize.square(5), difficulty: Difficulty.easy, seed: 7)),
    focus: {for (var c = 2; c < 5; c++) Pos(2, c)},
  ),
  TutorialStep.generated(
    text: (l) => l.tutArrowsS2,
    make: () => generateArrows(const GenParams(size: GridSize.square(6), difficulty: Difficulty.hard, seed: 1)),
  ),
];
