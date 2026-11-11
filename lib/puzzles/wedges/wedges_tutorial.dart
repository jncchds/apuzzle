import '../../core/difficulty.dart';
import '../../core/grid.dart';
import '../../core/tutorial.dart';
import 'wedges_generator.dart';
import 'wedges_model.dart';
import '../../core/explain.dart';
import 'wedges_solver.dart';

const _wedgeChars = '◤◥◢◣';

/// A board from rows of cells: `#` a wall, a digit a numbered wall, `.` an
/// open cell without a wedge, and `◤ ◥ ◢ ◣` the wedge a cell holds.
WedgesPuzzle wedgesBoard(List<String> rows) {
  final cells = rows.join().split('');
  return WedgesPuzzle(
    rows: rows.length,
    cols: rows.first.length,
    clues: [
      for (final ch in cells) ch == '#' ? wedgesPlain : int.tryParse(ch) ?? wedgesOpen,
    ],
    solution: [
      for (final ch in cells)
        ch == '#' || int.tryParse(ch) != null
            ? wedgeWall
            : ch == '.'
            ? wedgeDot
            : _wedgeChars.indexOf(ch),
    ],
  );
}

Set<Pos> _open(WedgesPuzzle p) => {
  for (var i = 0; i < p.rows * p.cols; i++)
    if (!p.isWall(i)) p.size.pos(i),
};

final _diamond = wedgesBoard(['#1##', '#◤◥#', '#◣◢#', '####']);

final _zero = wedgesBoard(['#01###', '#.◤◥.#', '#.◣◢.#', '######']);

final _leaning = wedgesBoard(['#1#0#', '#◤◥.#', '#◣.◥#', '#.◣◢#', '#####']);

final List<TutorialStep> wedgesTutorial = [
  // A number counts wedges; one wedge forces the whole diamond.
  TutorialStep(text: (l) => l.tutWedges1, puzzle: _diamond, focus: _open(_diamond)),
  // A 0 keeps its cell open; the diamond goes beside it.
  TutorialStep(text: (l) => l.tutWedges2, puzzle: _zero, focus: _open(_zero)),
  // A leaning rectangle, longer one way than the other.
  TutorialStep(text: (l) => l.tutWedges3, puzzle: _leaning, focus: _open(_leaning)),
  TutorialStep.generated(
    text: (l) => l.tutWedges4,
    make: () => generateWedges(const GenParams(size: GridSize.square(5), difficulty: Difficulty.easy, seed: 6)),
  ),
];

/// Pinned strategy boards (checked in the tests): a 6×6 medium board that
/// needs points or walls read together, and a 7×7 hard board that needs
/// probing.
const wedgesPairParams = GenParams(size: GridSize.square(6), difficulty: Difficulty.medium, seed: 1);
const wedgesProbeParams = GenParams(size: GridSize.square(7), difficulty: Difficulty.hard, seed: 3);

final List<TutorialStep> wedgesStrategies = [
  TutorialStep.generated(
    text: (l) => l.tutWedgesS1,
    teaches: {WedgesRule.pair.index, WedgesRule.ring.index},
    make: () => generateWedges(wedgesPairParams),
  ),
  TutorialStep.generated(
    text: (l) => l.tutWedgesS2,
    teaches: {ruleRefuted},
    make: () => generateWedges(wedgesProbeParams),
  ),
];
