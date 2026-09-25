import '../../core/difficulty.dart';
import '../../core/grid.dart';
import '../../core/tutorial.dart';
import '../../core/value_grid.dart';
import 'lamps_generator.dart';
import 'lamps_model.dart';

/// A board from rows of # (wall), digits (numbered wall), L (lamp) and . (open).
LampsPuzzle _board(List<String> rows) {
  final cells = rows.join().split('');
  return LampsPuzzle(
    rows: rows.length,
    cols: rows.first.length,
    walls: [for (final ch in cells) ch == '#' || int.tryParse(ch) != null],
    numbers: [for (final ch in cells) int.tryParse(ch)],
    lamps: [for (final ch in cells) ch == 'L'],
  );
}

final _zero = _board(['L..', '.0.', '..L']);

final List<TutorialStep> lampsTutorial = [
  TutorialStep(text: (l) => l.tutLamps1, puzzle: _board(['.L.', '#.#', 'L..']), openEnded: true),
  TutorialStep(text: (l) => l.tutLamps2, puzzle: _board(['L3L', '.L.'])),
  TutorialStep(
    text: (l) => l.tutLamps3,
    puzzle: _zero,
    state: ValueGrid.fromGivens(_zero.size, _zero.givenAt).set(const Pos(0, 0), const CellValue(value: lampsLamp, given: true)),
  ),
  TutorialStep.generated(
    text: (l) => l.tutLamps4,
    make: () => generateLamps(const GenParams(size: GridSize.square(5), difficulty: Difficulty.easy, seed: 2)),
  ),
];
