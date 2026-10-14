import '../../core/difficulty.dart';
import '../../core/grid.dart';
import '../../core/tutorial.dart';
import 'basins_generator.dart';
import 'basins_model.dart';

/// A board from rows separated by |: a letter per cell names its basin,
/// upper case holds water, lower case stays dry. The counts follow from it.
BasinsPuzzle basinsBoard(String board) {
  final rows = board.split('|');
  final r = rows.length, c = rows.first.length;
  final cells = rows.join().split('');
  final ids = <String, int>{};
  final regions = [for (final ch in cells) ids.putIfAbsent(ch.toLowerCase(), () => ids.length)];
  final water = [for (final ch in cells) ch != ch.toLowerCase()];
  int count(Iterable<int> at) => at.where((i) => water[i]).length;
  return BasinsPuzzle(
    rows: r,
    cols: c,
    regions: regions,
    water: water,
    rowCounts: [
      for (var y = 0; y < r; y++) count([for (var x = 0; x < c; x++) y * c + x]),
    ],
    colCounts: [
      for (var x = 0; x < c; x++) count([for (var y = 0; y < r; y++) y * c + x]),
    ],
  );
}

final List<TutorialStep> basinsTutorial = [
  // Three tall basins: the column counts say how high each one fills.
  TutorialStep(text: (l) => l.tutBasins1, puzzle: basinsBoard('abC|AbC|AbC')),
  // A wide basin fills its whole width at once.
  TutorialStep(
    text: (l) => l.tutBasins2,
    puzzle: basinsBoard('aaa|bbC|BBC'),
    focus: {const Pos(1, 0), const Pos(1, 1), const Pos(2, 0), const Pos(2, 1)},
  ),
  // Water in the top-left cell would fill two cells of column A.
  TutorialStep(
    text: (l) => l.tutBasins3,
    puzzle: basinsBoard('cDa|Cba|BBA'),
    focus: {const Pos(0, 0), const Pos(1, 0)},
  ),
  TutorialStep.generated(
    text: (l) => l.tutBasins4,
    make: () => generateBasins(const GenParams(size: GridSize.square(6), difficulty: Difficulty.easy, seed: 2)),
  ),
];

/// Generated strategy boards: medium needs every level of a basin, hard needs probing.
const basinsStrategyParams = [
  GenParams(size: GridSize.square(7), difficulty: Difficulty.medium, seed: 2),
  GenParams(size: GridSize.square(7), difficulty: Difficulty.hard, seed: 2),
];

final List<TutorialStep> basinsStrategies = [
  // Rows whose count only some sets of their basins' pieces make.
  TutorialStep(text: (l) => l.tutBasinsS1, puzzle: basinsBoard('bbbaa|bgbAA|GGBBd|CFFed|CCCED')),
  TutorialStep.generated(text: (l) => l.tutBasinsS2, make: () => generateBasins(basinsStrategyParams[0])),
  TutorialStep.generated(text: (l) => l.tutBasinsS3, make: () => generateBasins(basinsStrategyParams[1])),
];
