import '../../core/difficulty.dart';
import '../../core/grid.dart';
import '../../core/tutorial.dart';
import 'slant_generator.dart';
import 'slant_model.dart';
import '../../core/explain.dart';
import 'slant_solver.dart';

/// A board from rows of diagonals (`\` or `/`, upper case none: `L` for a
/// shown `\`, `R` for a shown `/`) and rows of corners (a digit or `.`).
SlantPuzzle slantBoard(List<String> diagonals, List<String> corners) {
  final d = diagonals.join();
  return SlantPuzzle(
    rows: diagonals.length,
    cols: diagonals.first.length,
    clues: [for (final ch in corners.join().split('')) ch == '.' ? -1 : int.parse(ch)],
    solution: [for (final ch in d.split('')) ch == r'\' || ch == 'L' ? slBack : slFwd],
    givens: [
      for (var i = 0; i < d.length; i++)
        if (d[i] == 'L' || d[i] == 'R') i,
    ],
  );
}

Set<Pos> _all(SlantPuzzle p) => {
  for (var r = 0; r < p.rows; r++)
    for (var c = 0; c < p.cols; c++) Pos(r, c),
};

final _four = slantBoard([r'\/', r'/\'], ['...', '.4.', '...']);

final _zeros = slantBoard([r'\\/', r'/\\'], ['..0.', '0..0', '.0..']);

final _loop = slantBoard(['RL', r'L\'], ['...', '...', '...']);

final List<TutorialStep> slantTutorial = [
  // A 4 takes every cell around it.
  TutorialStep(text: (l) => l.tutSlant1, puzzle: _four, focus: _all(_four)),
  // Zeros turn their cells away.
  TutorialStep(text: (l) => l.tutSlant2, puzzle: _zeros, focus: _all(_zeros)),
  // Three sides of a diamond: the last cell goes the other way.
  TutorialStep(text: (l) => l.tutSlant3, puzzle: _loop, focus: {const Pos(1, 1)}),
  TutorialStep.generated(
    text: (l) => l.tutSlant4,
    make: () => generateSlant(const GenParams(size: GridSize.square(5), difficulty: Difficulty.easy, seed: 3)),
  ),
];

/// Pinned strategy boards (checked in the tests): a 6×6 medium board that
/// needs two neighbouring numbers read together, and a 6×6 hard board that
/// needs probing.
const slantPairParams = GenParams(size: GridSize.square(6), difficulty: Difficulty.medium, seed: 1);
const slantProbeParams = GenParams(size: GridSize.square(6), difficulty: Difficulty.hard, seed: 7);

final List<TutorialStep> slantStrategies = [
  TutorialStep.generated(
    text: (l) => l.tutSlantS1,
    teaches: {SlantRule.pair.index},
    make: () => generateSlant(slantPairParams),
  ),
  TutorialStep.generated(
    text: (l) => l.tutSlantS2,
    teaches: {ruleRefuted},
    make: () => generateSlant(slantProbeParams),
  ),
];
