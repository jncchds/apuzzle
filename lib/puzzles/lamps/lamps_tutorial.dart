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

// The corner can only be lit from itself or its two neighbours, and the 0
// rules those out. Then the 1 has one free side left.
final _corner = _board(['L.1L', '.0..', '#.L.']);

final List<TutorialStep> lampsStrategies = [
  TutorialStep(text: (l) => l.tutLampsS1, puzzle: _corner, focus: {const Pos(0, 0)}),
  TutorialStep.generated(
    text: (l) => l.tutLampsS2,
    make: () => generateLamps(const GenParams(size: GridSize.square(6), difficulty: Difficulty.hard, seed: 1)),
  ),
];
