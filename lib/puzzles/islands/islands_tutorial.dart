import '../../core/difficulty.dart';
import '../../core/grid.dart';
import '../../core/tutorial.dart';
import '../../core/value_grid.dart';
import 'islands_generator.dart';
import 'islands_model.dart';

/// A board from rows of ~ (sea), . (land) and digits (land showing its
/// island's size).
IslandsPuzzle _board(List<String> rows) {
  final cells = rows.join().split('');
  return IslandsPuzzle(
    rows: rows.length,
    cols: rows.first.length,
    clues: [for (final ch in cells) int.tryParse(ch)],
    sea: [for (final ch in cells) ch == '~'],
  );
}

/// The puzzle's start with [sea] cells already shaded.
ValueGrid _withSea(IslandsPuzzle p, List<Pos> sea) {
  var s = ValueGrid.fromGivens(p.size, p.givenAt);
  for (final q in sea) {
    s = s.set(q, const CellValue(value: islandsSea));
  }
  return s;
}

final _one = _board(['~~~', '~1~', '~~~']);
final _between = _board(['1~1', '~~~', '~1~']);
final _three = _board(['3.~', '~.~', '~~~']);

final List<TutorialStep> islandsTutorial = [
  TutorialStep(text: (l) => l.tutIslands1, puzzle: _one),
  TutorialStep(
    text: (l) => l.tutIslands2,
    puzzle: _between,
    focus: {const Pos(0, 1)},
    done: (s) => (s as ValueGrid).valueAt(const Pos(0, 1)) == islandsSea,
    answer: _withSea(_between, const [Pos(0, 1)]),
  ),
  TutorialStep(text: (l) => l.tutIslands3, puzzle: _three, state: _withSea(_three, const [Pos(1, 0)])),
  TutorialStep.generated(
    text: (l) => l.tutIslands4,
    make: () => generateIslands(const GenParams(size: GridSize.square(5), difficulty: Difficulty.easy, seed: 3)),
  ),
];
