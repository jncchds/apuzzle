import '../../core/tutorial.dart';
import 'merge_model.dart';

/// A 3×3 board from its tiles (row-major, 0 = empty) and the tile to build.
MergePuzzle _board(List<int> tiles, int target) =>
    MergePuzzle(rows: 3, cols: 3, goal: MergeGoal.target, target: target, seed: 7, start: tiles);

final List<TutorialStep> mergeTutorial = [
  TutorialStep(text: (l) => l.tutMerge1, puzzle: _board([2, 2, 0, 0, 0, 0, 0, 0, 0], 4)),
  TutorialStep(text: (l) => l.tutMerge2, puzzle: _board([4, 4, 8, 0, 0, 0, 0, 0, 0], 16)),
  TutorialStep(text: (l) => l.tutMerge3, puzzle: _board([16, 8, 4, 0, 0, 4, 0, 0, 0], 32)),
];
