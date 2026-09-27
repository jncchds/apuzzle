import '../../core/difficulty.dart';
import '../../core/grid.dart';
import '../../core/tutorial.dart';
import 'camp_generator.dart';
import 'camp_model.dart';

/// A board from rows of T (tree), A (tent) and . (grass); [counts] shows the
/// row and column counts, [given] lists tents shown from the start.
CampPuzzle _board(List<String> rows, {bool counts = true, List<int> given = const []}) {
  final r = rows.length, c = rows.first.length;
  final cells = rows.join().split('');
  final tents = [for (final ch in cells) ch == 'A'];
  int count(Iterable<int> ids) => ids.where((i) => tents[i]).length;
  return CampPuzzle(
    rows: r,
    cols: c,
    trees: [for (final ch in cells) ch == 'T'],
    tents: tents,
    rowCounts: [for (var y = 0; y < r; y++) counts ? count([for (var x = 0; x < c; x++) y * c + x]) : null],
    colCounts: [for (var x = 0; x < c; x++) counts ? count([for (var y = 0; y < r; y++) y * c + x]) : null],
    givenTents: given,
  );
}

final List<TutorialStep> campTutorial = [
  TutorialStep(text: (l) => l.tutCamp1, puzzle: _board(['.A.', '.T.', '...'])),
  TutorialStep(
    text: (l) => l.tutCamp2,
    puzzle: _board(['A.A', 'T.T'], counts: false, given: [0]),
    focus: {const Pos(0, 2), const Pos(1, 1)},
  ),
  TutorialStep.generated(
    text: (l) => l.tutCamp3,
    make: () => generateCamp(const GenParams(size: GridSize.square(5), difficulty: Difficulty.easy, seed: 5)),
  ),
];

// Two tents in the top row's three cells can't touch, so they take both
// ends. Column counts are hidden so the row has to do the work.
const _ends = CampPuzzle(
  rows: 3,
  cols: 3,
  trees: [false, false, false, true, true, true, false, false, false],
  tents: [true, false, true, false, false, false, false, true, false],
  rowCounts: [2, 0, 1],
  colCounts: [null, null, null],
);

final List<TutorialStep> campStrategies = [
  TutorialStep(text: (l) => l.tutCampS1, puzzle: _ends, focus: {const Pos(0, 0), const Pos(0, 1), const Pos(0, 2)}),
  TutorialStep.generated(
    text: (l) => l.tutCampS2,
    make: () => generateCamp(const GenParams(size: GridSize.square(6), difficulty: Difficulty.hard, seed: 1)),
  ),
];
