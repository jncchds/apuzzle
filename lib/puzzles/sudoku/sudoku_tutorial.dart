import '../../core/grid.dart';
import '../../core/tutorial.dart';
import '../../core/value_grid.dart';
import '../../l10n/l10n.dart';
import 'sudoku_model.dart';

/// A 4×4 board from rows of digits (given) and letters a–d (a cell to fill
/// with 1–4).
SudokuPuzzle _board(List<String> rows) {
  final cells = rows.join().split('');
  int value(String ch) => '1234'.contains(ch) ? int.parse(ch) - 1 : 'abcd'.indexOf(ch);
  return SudokuPuzzle(
    n: 4,
    givens: [for (final ch in cells) '1234'.contains(ch) ? value(ch) : null],
    solution: [for (final ch in cells) value(ch)],
  );
}

Set<Pos> _open(SudokuPuzzle p) => {for (var i = 0; i < 16; i++) if (p.givens[i] == null) p.size.pos(i)};

TutorialStep _step(Tr text, List<String> rows) {
  final p = _board(rows);
  return TutorialStep(text: text, puzzle: p, focus: _open(p));
}

// Solution of the small steps:
// 1 2 3 4
// 3 4 1 2
// 2 1 4 3
// 4 3 2 1
final _full = _board(['1bc4', 'cd1b', 'b1dc', 'd32a']);

final List<TutorialStep> sudokuTutorial = [
  _step((l) => l.tutSudoku1, ['12c4', '3412', '2143', '4321']),
  _step((l) => l.tutSudoku2, ['1234', 'cd12', '2143', '4321']),
  _step((l) => l.tutSudoku3, ['1234', '3412', '21dc', '43ba']),
  () {
    // Pencil marks: the second cell of the second row can still be 2 or 4.
    const cell = Pos(1, 1);
    final start = ValueGrid.fromGivens(_full.size, _full.givenAt);
    bool done(Object s) => (s as ValueGrid).at(cell).marks.length == 2 && s.at(cell).marks.containsAll(const [1, 3]);
    return TutorialStep(
      text: (l) => l.tutSudoku4,
      puzzle: _full,
      focus: {cell},
      done: done,
      answer: start.set(cell, const CellValue(marks: {1, 3})),
    );
  }(),
  TutorialStep(text: (l) => l.tutSudoku5, puzzle: _full),
];
