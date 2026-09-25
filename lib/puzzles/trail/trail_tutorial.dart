import '../../core/difficulty.dart';
import '../../core/grid.dart';
import '../../core/tutorial.dart';
import 'trail_generator.dart';
import 'trail_model.dart';

/// A 3×3 board from its path (cells as row * 3 + column) and the cells
/// showing the numbers 1, 2, ….
TrailPuzzle _board(List<int> path, List<int> numbered) => TrailPuzzle(
      rows: 3,
      cols: 3,
      numbers: [for (var i = 0; i < 9; i++) numbered.contains(i) ? numbered.indexOf(i) + 1 : null],
      solution: path,
    );

final List<TutorialStep> trailTutorial = [
  TutorialStep(text: (l) => l.tutTrail1, puzzle: _board([0, 1, 2, 5, 4, 3, 6, 7, 8], [0, 8])),
  TutorialStep(text: (l) => l.tutTrail2, puzzle: _board([0, 1, 2, 5, 8, 7, 4, 3, 6], [0, 2, 8, 6])),
  TutorialStep.generated(
    text: (l) => l.tutTrail3,
    make: () => generateTrail(const GenParams(size: GridSize.square(5), difficulty: Difficulty.easy, seed: 3)),
  ),
];
