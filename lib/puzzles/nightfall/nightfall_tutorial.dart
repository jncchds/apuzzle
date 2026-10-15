import '../../core/difficulty.dart';
import '../../core/grid.dart';
import '../../core/tutorial.dart';
import 'nightfall_model.dart';
import 'nightfall_type.dart';

/// A board from rows of '#' (on) and '.' (off), with no move limit.
NightfallPuzzle nightfallBoard(List<String> rows) {
  final start = [for (final ch in rows.join().split('')) ch == '#'];
  final g = NightfallGeometry.of(rows.length, rows.first.length, false);
  final plan = g.fewest(start)!;
  return NightfallPuzzle(
    rows: rows.length,
    cols: rows.first.length,
    start: start,
    plan: [
      for (var i = 0; i < plan.length; i++)
        if (plan[i]) i,
    ],
  );
}

/// The [n]×[n] board that tapping [taps] (row, column) leaves lit.
NightfallPuzzle nightfallTapped(int n, List<(int, int)> taps) {
  final g = NightfallGeometry.of(n, n, false);
  final pressed = List.filled(n * n, false);
  for (final (r, c) in taps) {
    pressed[r * n + c] = true;
  }
  final lights = nightfallLights(g, List.filled(n * n, false), pressed);
  return nightfallBoard([
    for (var r = 0; r < n; r++) [for (var c = 0; c < n; c++) lights[r * n + c] ? '#' : '.'].join(),
  ]);
}

final List<TutorialStep> nightfallTutorial = [
  TutorialStep(text: (l) => l.tutNightfall1, puzzle: nightfallBoard(['.#.', '###', '.#.']), focus: {const Pos(1, 1)}),
  TutorialStep(text: (l) => l.tutNightfall2, puzzle: nightfallBoard(['##.', '#..', '...']), focus: {const Pos(0, 0)}),
  TutorialStep(text: (l) => l.tutNightfall3, puzzle: nightfallBoard(['#.#', '#.#', '#.#'])),
  TutorialStep.generated(
    text: (l) => l.tutNightfall4,
    make: () =>
        const NightfallType().generate(const GenParams(size: GridSize.square(5), difficulty: Difficulty.easy, seed: 3)),
  ),
];

final List<TutorialStep> nightfallStrategies = [
  // None of the taps is in the top row, so a chase finds them all.
  TutorialStep(text: (l) => l.tutNightfallS1, puzzle: nightfallTapped(5, [(1, 1), (2, 3), (3, 0), (4, 2)])),
  // The chase needs the top tap first: no way out leaves the top row alone.
  TutorialStep(
    text: (l) => l.tutNightfallS2,
    puzzle: nightfallTapped(5, [(0, 1), (2, 2), (3, 4)]),
    focus: {const Pos(0, 1)},
  ),
  TutorialStep.generated(
    text: (l) => l.tutNightfallS3,
    make: () => const NightfallType().generate(
      const GenParams(size: GridSize.square(6), difficulty: Difficulty.medium, seed: 7, options: {'goal': 'free'}),
    ),
  ),
];
