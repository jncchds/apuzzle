import '../../core/difficulty.dart';
import '../../core/grid.dart';
import '../../core/grid_graph.dart';
import '../../core/tutorial.dart';
import 'quarry_generator.dart';
import 'quarry_model.dart';
import '../../core/explain.dart';
import 'quarry_solver.dart';

/// A board from rows separated by `|`: `#` stone, `.` empty, `@` stone with
/// a filled circle, `o` empty with a hollow circle. The tray holds the
/// stones the board shows.
QuarryPuzzle quarryBoard(String board) {
  final rows = board.split('|');
  final n = rows.length;
  final cells = rows.join().split('');
  final shaded = [for (final c in cells) c == '#' || c == '@'];
  final pieces = <int>[];
  for (final g in components(orthNeighbors(n, n), (i) => shaded[i])) {
    final key = quarryShapeKey(quarryCellsOf(n, g));
    pieces.add(quarryShapes.indexWhere((s) => s.size == g.length && quarryShapeKey(s.cells) == key));
  }
  pieces.sort((a, b) => quarryShapes[b].size - quarryShapes[a].size);
  return QuarryPuzzle(
    n: n,
    pieces: pieces,
    clues: [
      for (final c in cells)
        c == '@'
            ? quarryShade
            : c == 'o'
            ? quarryKeep
            : null,
    ],
    shaded: shaded,
  );
}

final List<TutorialStep> quarryTutorial = [
  // The only stone must cover the filled circle; the hollow one leaves it
  // one way to lie.
  TutorialStep(
    text: (l) => l.tutQuarry1,
    puzzle: quarryBoard('....|...o|.##@|....'),
    focus: {const Pos(2, 3), const Pos(1, 3)},
  ),
  // Stones never touch along a side.
  TutorialStep(
    text: (l) => l.tutQuarry2,
    puzzle: quarryBoard('..o..|.#@o.|.#.@#|...##|.o...'),
    focus: {const Pos(1, 2), const Pos(2, 3)},
  ),
  // The empty cells form one area: the walled-in corner is stone.
  TutorialStep(
    text: (l) => l.tutQuarry3,
    puzzle: quarryBoard('##@o.|..o..|....@|....@|...@#'),
    focus: {const Pos(4, 4)},
  ),
  // The hollow circle's last way out stays empty, so the T points down.
  TutorialStep(
    text: (l) => l.tutQuarry4,
    puzzle: quarryBoard('##@o.|.....|..@@@|...#.|.....'),
    focus: {const Pos(0, 3), const Pos(1, 3)},
  ),
  TutorialStep.generated(
    text: (l) => l.tutQuarry5,
    make: () => generateQuarry(const GenParams(size: GridSize.square(5), difficulty: Difficulty.easy, seed: 1)),
  ),
];

/// The lesson board where a stone must leave the others room.
final quarryRoomBoard = quarryBoard('..o.##|o#..#@|o@##..|.#o.o.|..o.#o|....#@');

/// The lesson board where shading a cell would cut the empty cells apart.
final quarryCutBoard = quarryBoard('o.....|#.#@.@|#.@.@#|#.#.#.|o.#...|......');

/// The generated board that needs probing.
const quarryProbeParams = GenParams(size: GridSize.square(7), difficulty: Difficulty.hard, seed: 1);

final List<TutorialStep> quarryStrategies = [
  TutorialStep(
    text: (l) => l.tutQuarryS1,
    teaches: {QuarryRule.room.index, QuarryRule.roomBeside.index},
    puzzle: quarryRoomBoard,
  ),
  TutorialStep(text: (l) => l.tutQuarryS2, teaches: {QuarryRule.cut.index}, puzzle: quarryCutBoard),
  TutorialStep.generated(
    text: (l) => l.tutQuarryS3,
    teaches: {ruleRefuted},
    make: () => generateQuarry(quarryProbeParams),
  ),
];
