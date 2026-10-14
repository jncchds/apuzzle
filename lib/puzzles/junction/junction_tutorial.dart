import '../../core/difficulty.dart';
import '../../core/grid.dart';
import '../../core/tutorial.dart';
import 'junction_generator.dart';
import 'junction_model.dart';

/// A slow practice board on [rows]×[cols]: a depot and [paths] of track
/// (each starts at a cell already on the track), stations at [stations] in
/// symbol order, and the [trains] symbols in departure order. One wrong
/// station ends it.
JunctionPuzzle junctionPractice(
  int rows,
  int cols,
  int depot,
  List<List<int>> paths, {
  required List<int> stations,
  required List<int> trains,
  required List<int> start,
  int gap = 6,
}) {
  final parent = List.filled(rows * cols, junctionOff);
  parent[depot] = junctionDepot;
  for (final path in paths) {
    for (var k = 1; k < path.length; k++) {
      parent[path[k]] = path[k - 1];
    }
  }
  return JunctionPuzzle(
    rows: rows,
    cols: cols,
    goal: JunctionGoal.trains,
    trains: trains.length,
    ticks: 0,
    seed: 7,
    stepMs: 800,
    gapMin: gap,
    gapMax: gap,
    parent: parent,
    stations: stations,
    start: start,
    fixed: trains,
    perfect: true,
  );
}

final List<TutorialStep> junctionTutorial = [
  // One switch on 5×5: in from the left, up to one station or down to the other.
  TutorialStep(
    text: (l) => l.tutJunction1,
    puzzle: junctionPractice(
      5,
      5,
      10,
      const [
        [10, 11, 12, 7, 2, 3, 4],
        [12, 17, 22, 23, 24],
      ],
      stations: const [4, 24],
      trains: const [1, 0, 0],
      start: const [0],
    ),
  ),
  // Two switches on 5×7: the trunk runs on to one station, a branch down
  // before it and a branch up after it.
  TutorialStep(
    text: (l) => l.tutJunction2,
    puzzle: junctionPractice(
      5,
      7,
      14,
      const [
        [14, 15, 16, 17, 18, 19, 20],
        [16, 23, 30, 31, 32, 33, 34],
        [18, 11, 4, 5, 6],
      ],
      stations: const [20, 34, 6],
      trains: const [2, 1, 0, 2],
      start: const [0, 0],
      gap: 4,
    ),
  ),
  TutorialStep.generated(
    text: (l) => l.tutJunction3,
    make: () {
      final p = generateJunction(
        const GenParams(size: GridSize.square(7), difficulty: Difficulty.easy, seed: 11),
        JunctionGoal.trains,
      );
      return JunctionPuzzle(
        rows: p.rows,
        cols: p.cols,
        goal: JunctionGoal.trains,
        trains: 6,
        ticks: 0,
        seed: p.seed,
        stepMs: p.stepMs,
        gapMin: p.gapMin,
        gapMax: p.gapMax,
        parent: p.parent,
        stations: p.stations,
        start: p.start,
        perfect: true,
      );
    },
  ),
];
