import '../../core/difficulty.dart';
import '../../core/grid.dart';
import '../../core/tutorial.dart';
import 'inlay_generator.dart';
import 'inlay_model.dart';

/// A board drawn as text: one letter per piece ('A' is piece 0, 'B' piece 1
/// …) where it lies in the cover, '.' outside the shape. Piece k waits in
/// the tray in orientation [shown][k] (0 = as it lies).
InlayPuzzle inlayBoard(List<String> map, {List<int> shown = const [], bool flip = false}) {
  final rows = map.length, cols = map.first.length;
  final flat = map.join();
  final letters = (flat.replaceAll('.', '').split('').toSet().toList()..sort());
  return inlayPuzzleOf(
    rows,
    cols,
    [for (final ch in flat.split('')) ch != '.'],
    [
      for (final ch in letters)
        [
          for (var i = 0; i < flat.length; i++)
            if (flat[i] == ch) i,
        ],
    ],
    [for (var k = 0; k < letters.length; k++) k < shown.length ? shown[k] : 0],
    flip: flip,
  );
}

final List<TutorialStep> inlayTutorial = [
  TutorialStep(
    text: (l) => l.tutInlay1,
    puzzle: inlayBoard(['AAB', 'ACB', 'CCB']),
  ),
  TutorialStep(
    text: (l) => l.tutInlay2,
    puzzle: inlayBoard(['AABB', 'ACCB', 'ACCB'], shown: [1, 3]),
  ),
  TutorialStep(
    text: (l) => l.tutInlay3,
    puzzle: inlayBoard(['AAAB', 'CCBB', 'CCCB']),
    // The bar lies along the bottom, where it leaves no room for the rest.
    state: const InlayState([0, 0, 0], [8, -1, -1]),
    focus: {const Pos(2, 0), const Pos(2, 1), const Pos(2, 2)},
  ),
  TutorialStep(
    text: (l) => l.tutInlay4,
    puzzle: inlayBoard(['AA.B', '.AAB', '..BB'], shown: [4], flip: true),
  ),
  TutorialStep.generated(
    text: (l) => l.tutInlay5,
    make: () => generateInlay(const GenParams(size: GridSize.square(5), difficulty: Difficulty.easy, seed: 1)),
  ),
];

final List<TutorialStep> inlayStrategies = [
  TutorialStep(
    text: (l) => l.tutInlayS1,
    puzzle: inlayBoard(['AAA..', '.BAC.', 'BBDCC', 'BDDDC'], shown: [2, 1, 3, 2]),
    focus: {const Pos(0, 0)},
  ),
  TutorialStep.generated(
    text: (l) => l.tutInlayS2,
    make: () => generateInlay(const GenParams(size: GridSize.square(6), difficulty: Difficulty.hard, seed: 1)),
  ),
];
