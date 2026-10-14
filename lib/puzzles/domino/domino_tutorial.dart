import '../../core/difficulty.dart';
import '../../core/grid.dart';
import '../../core/lattice_loop.dart';
import '../../core/tutorial.dart';
import 'domino_generator.dart';
import 'domino_model.dart';
import 'domino_solver.dart';

/// A board from rows of digits; its one solution comes from the solver.
DominoPuzzle _board(List<String> rows) {
  final nums = [
    for (final row in rows)
      for (final ch in row.split('')) int.parse(ch),
  ];
  final s = DominoSolver(rows.length, rows.first.length, nums);
  final st = s.start();
  s.solve(st, 3);
  return DominoPuzzle(rows: rows.length, cols: rows.first.length, nums: nums, lines: [for (final x in st) x == 1]);
}

/// [p]'s marks with dominoes from cell [a] to cell [b] (as (row, column)).
LoopMarks _with(DominoPuzzle p, List<((int, int), (int, int))> dominoes) {
  final g = p.lattice;
  final marks = List<int>.filled(g.edgeCount, 0);
  for (final ((r0, c0), (r1, c1)) in dominoes) {
    marks[g.between(r0 * p.cols + c0, r1 * p.cols + c1)] = 1;
  }
  return LoopMarks(marks);
}

// Two 0s side by side only in the middle of the top rows.
final _onlySpot = _board(['201', '201', '110', '022']);
// With the 2–2 placed, the top-left 0 has one neighbour left.
final _onlyWay = _board(['012', '200', '202', '111']);
// The 2–3 at the bottom rules out the two 2–3s in the top corner.
final _used = _board(['2302', '2310', '0120', '3203', '1113']);

final List<TutorialStep> dominoTutorial = [
  TutorialStep(text: (l) => l.tutDomino1, puzzle: _board(['10', '01', '01'])),
  TutorialStep(text: (l) => l.tutDomino2, puzzle: _onlySpot, focus: {const Pos(0, 1), const Pos(1, 1)}),
  TutorialStep(
    text: (l) => l.tutDomino3,
    puzzle: _onlyWay,
    state: _with(_onlyWay, [((1, 0), (2, 0))]),
    focus: {const Pos(0, 0)},
  ),
  TutorialStep(
    text: (l) => l.tutDomino4,
    puzzle: _used,
    state: _with(_used, [((3, 0), (3, 1))]),
    focus: {const Pos(0, 0), const Pos(0, 1), const Pos(1, 0), const Pos(1, 1)},
  ),
  TutorialStep.generated(
    text: (l) => l.tutDomino5,
    make: () => generateDomino(const GenParams(size: GridSize(5, 4), difficulty: Difficulty.easy, seed: 1)),
  ),
];

/// The generated strategy board: hard, so it needs probing.
const dominoStrategyParams = GenParams(size: GridSize(6, 5), difficulty: Difficulty.hard, seed: 1);

final List<TutorialStep> dominoStrategies = [
  // Every 3–3 left covers the cell in row 4, column D.
  TutorialStep(
    text: (l) => l.tutDominoS1,
    puzzle: _board(['2130', '0120', '0121', '2133', '3023']),
    focus: {const Pos(3, 3)},
  ),
  // The cell in row 4, column A can only be in a 1–3.
  TutorialStep(
    text: (l) => l.tutDominoS2,
    puzzle: _board(['3300', '2230', '1130', '3112', '0122']),
    focus: {const Pos(3, 0)},
  ),
  TutorialStep.generated(text: (l) => l.tutDominoS3, make: () => generateDomino(dominoStrategyParams)),
];
