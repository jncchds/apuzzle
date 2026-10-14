import '../../core/difficulty.dart';
import '../../core/grid.dart';
import '../../core/tutorial.dart';
import 'fleet_generator.dart';
import 'fleet_model.dart';

/// A board from rows of S (ship), . (water), G (ship shown from the start)
/// and ~ (water shown from the start); the counts and fleet follow from it.
FleetPuzzle _board(List<String> rows) {
  final r = rows.length, c = rows.first.length;
  final cells = rows.join().split('');
  final ships = [for (final ch in cells) ch == 'S' || ch == 'G'];
  int count(Iterable<int> ids) => ids.where((i) => ships[i]).length;
  return FleetPuzzle(
    rows: r,
    cols: c,
    ships: ships,
    rowCounts: [
      for (var y = 0; y < r; y++) count([for (var x = 0; x < c; x++) y * c + x]),
    ],
    colCounts: [
      for (var x = 0; x < c; x++) count([for (var y = 0; y < r; y++) y * c + x]),
    ],
    givens: [
      for (var i = 0; i < cells.length; i++)
        if (cells[i] == 'G' || cells[i] == '~') i,
    ],
  );
}

final List<TutorialStep> fleetTutorial = [
  // Three one-cell ships: the counts alone place them.
  TutorialStep(text: (l) => l.tutFleet1, puzzle: _board(['S..', '...', 'S.S'])),
  // Row 4 needs two ship cells that can't touch.
  TutorialStep(
    text: (l) => l.tutFleet2,
    puzzle: _board(['....', 'SSS.', '....', 'S.S.']),
    focus: {const Pos(3, 0), const Pos(3, 1), const Pos(3, 2), const Pos(3, 3)},
  ),
  // The shown end piece in the corner goes on downwards.
  TutorialStep(
    text: (l) => l.tutFleet3,
    puzzle: _board(['G...', 'S..S', 'S...', '....']),
    focus: {const Pos(0, 0), const Pos(1, 0)},
  ),
  TutorialStep.generated(
    text: (l) => l.tutFleet4,
    make: () => generateFleet(const GenParams(size: GridSize.square(6), difficulty: Difficulty.easy, seed: 2)),
  ),
];

/// Generated strategy boards: medium needs where the ships fit, hard needs probing.
const fleetStrategyParams = [
  GenParams(size: GridSize.square(6), difficulty: Difficulty.medium, seed: 1),
  GenParams(size: GridSize.square(7), difficulty: Difficulty.hard, seed: 1),
];

final List<TutorialStep> fleetStrategies = [
  TutorialStep.generated(text: (l) => l.tutFleetS1, make: () => generateFleet(fleetStrategyParams[0])),
  TutorialStep.generated(text: (l) => l.tutFleetS2, make: () => generateFleet(fleetStrategyParams[1])),
];
