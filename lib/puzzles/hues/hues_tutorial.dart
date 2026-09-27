import '../../core/difficulty.dart';
import '../../core/grid.dart';
import '../../core/tutorial.dart';
import '../../core/value_grid.dart';
import 'hues_generator.dart';
import 'hues_model.dart';

/// A board from rows of cells: a color letter (b blue, p pink, y yellow) for a
/// cell to paint, or the letter and a digit (e.g. "b3") for a clue. Clue
/// numbers are counted from the solution.
HuesPuzzle _board(List<List<String>> rows) {
  final r = rows.length, c = rows.first.length;
  final flat = rows.expand((row) => row).toList();
  final solution = [for (final s in flat) 'bpy'.indexOf(s[0])];
  final isClue = [for (final s in flat) s.length > 1];
  final nb = huesNeighbors(r, c);
  final clues = [for (var i = 0; i < flat.length; i++) isClue[i] ? huesCount(nb, isClue, solution, i) : null];
  for (var i = 0; i < flat.length; i++) {
    assert(!isClue[i] || clues[i] == int.parse(flat[i].substring(1)), 'clue $i should be ${clues[i]}');
  }
  return HuesPuzzle(rows: r, cols: c, colors: 4, clues: clues, solution: solution);
}

Set<Pos> _open(HuesPuzzle p) => {for (var i = 0; i < p.clues.length; i++) if (p.clues[i] == null) p.size.pos(i)};

final _small = _board([
  ['b3', 'b', 'p1'],
  ['b', 'b', 'p'],
]);

final _corners = _board([
  ['b3', 'b', 'y0'],
  ['b', 'b', 'p'],
  ['y0', 'p', 'p2'],
]);

final List<TutorialStep> huesTutorial = [
  TutorialStep(text: (l) => l.tutHues1, puzzle: _small, focus: _open(_small)),
  TutorialStep(text: (l) => l.tutHues2, puzzle: _corners, focus: _open(_corners)),
  TutorialStep.generated(
    text: (l) => l.tutHues3,
    make: () => generateHues(const GenParams(size: GridSize.square(5), difficulty: Difficulty.easy, seed: 3)),
  ),
];

// The two middle cells of the top rows touch the blue 0 and the pink 0, so
// only yellow is left for them (the rest is painted already).
final _zeros = _board([
  ['b0', 'y', 'p0'],
  ['p', 'y', 'b'],
  ['p1', 'y', 'b1'],
]);

final List<TutorialStep> huesStrategies = [
  TutorialStep(
    text: (l) => l.tutHuesS1,
    puzzle: _zeros,
    state: ValueGrid.fromGivens(_zeros.size, _zeros.givenAt)
        .set(const Pos(1, 0), const CellValue(value: 1))
        .set(const Pos(1, 2), const CellValue(value: 0))
        .set(const Pos(2, 1), const CellValue(value: 2)),
    focus: {const Pos(0, 1), const Pos(1, 1)},
  ),
  TutorialStep.generated(
    text: (l) => l.tutHuesS2,
    make: () => generateHues(const GenParams(size: GridSize.square(5), difficulty: Difficulty.hard, seed: 1)),
  ),
];
