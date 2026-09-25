import '../../core/difficulty.dart';
import '../../core/grid.dart';
import '../../core/tutorial.dart';
import 'mines_generator.dart';
import 'mines_model.dart';

/// A board from rows of * (mine), o (open at the start) and . (closed).
MinesPuzzle _board(List<String> rows) {
  final cells = rows.join().split('');
  return MinesPuzzle(
    rows: rows.length,
    cols: rows.first.length,
    mines: [for (final ch in cells) ch == '*'],
    opened: [for (final ch in cells) ch == 'o'],
  );
}

MinesState _flagged(MinesPuzzle p, int cell) =>
    MinesState(open: List.of(p.opened), flags: List.filled(p.mines.length, false)..[cell] = true);

final _flag = _board(['*oo', 'ooo', 'ooo']);
final _chord = _board(['*..', '.o.', '...']);

final List<TutorialStep> minesTutorial = [
  TutorialStep(
    text: (l) => l.tutMines1,
    puzzle: _flag,
    focus: {const Pos(0, 0)},
    done: (s) => (s as MinesState).flags[0],
    answer: _flagged(_flag, 0),
  ),
  TutorialStep(text: (l) => l.tutMines2, puzzle: _chord, state: _flagged(_chord, 0), focus: {const Pos(1, 1)}),
  TutorialStep(text: (l) => l.tutMines3, puzzle: _board(['*...', '....', '....', '....']), focus: {const Pos(3, 3)}),
  TutorialStep.generated(
    text: (l) => l.tutMines4,
    make: () => generateMines(const GenParams(size: GridSize.square(6), difficulty: Difficulty.easy, seed: 4)),
  ),
];
