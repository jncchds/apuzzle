import '../../core/difficulty.dart';
import '../../core/grid.dart';
import '../../core/tutorial.dart';
import 'mercury_generator.dart';
import 'mercury_model.dart';

/// A board from rows separated by |: every cell names the way on to the next
/// cell of its tube (r, l, u, d), or x at a tube's tip; a tube starts at the
/// cell nothing leads into. Upper case cells are filled. The counts follow.
MercuryPuzzle mercuryBoard(String board) {
  final rows = board.split('|');
  final r = rows.length, c = rows.first.length;
  final cells = rows.join().split('');
  int? next(int i) => switch (cells[i].toLowerCase()) {
    'r' => i + 1,
    'l' => i - 1,
    'u' => i - c,
    'd' => i + c,
    _ => null,
  };
  final into = <int>{for (var i = 0; i < cells.length; i++) ?next(i)};
  final tubes = <List<int>>[];
  for (var i = 0; i < cells.length; i++) {
    if (into.contains(i)) continue;
    final tube = [i];
    for (var j = next(i); j != null; j = next(j)) {
      tube.add(j);
    }
    tubes.add(tube);
  }
  final levels = [for (final t in tubes) t.where((i) => cells[i] != cells[i].toLowerCase()).length];
  final counts = mercuryCounts(r, c, tubes, levels);
  return MercuryPuzzle(
    rows: r,
    cols: c,
    tubes: tubes,
    levels: levels,
    rowCounts: counts.sublist(0, r),
    colCounts: counts.sublist(r),
  );
}

final List<TutorialStep> mercuryTutorial = [
  // Straight tubes, bulbs at either end: the counts settle them.
  TutorialStep(text: (l) => l.tutMercury1, puzzle: mercuryBoard('dDX|dDU|xxU')),
  // A tube round a bend fills from its bulb all the same.
  TutorialStep(
    text: (l) => l.tutMercury2,
    puzzle: mercuryBoard('RRx|UXx|UUU'),
    focus: {const Pos(2, 0), const Pos(1, 0), const Pos(0, 0), const Pos(0, 1), const Pos(0, 2)},
  ),
  // Leaving the top bulb empty would empty two cells of row 1.
  TutorialStep(
    text: (l) => l.tutMercury3,
    puzzle: mercuryBoard('xLd|xld|Rxx'),
    focus: {const Pos(0, 0), const Pos(0, 1)},
  ),
  TutorialStep.generated(
    text: (l) => l.tutMercury4,
    make: () => generateMercury(const GenParams(size: GridSize.square(5), difficulty: Difficulty.easy, seed: 1)),
  ),
];

/// Generated strategy boards: medium needs two lines counted together, hard needs probing.
const mercuryStrategyParams = [
  GenParams(size: GridSize.square(6), difficulty: Difficulty.medium, seed: 1),
  GenParams(size: GridSize.square(6), difficulty: Difficulty.hard, seed: 1),
];

/// Columns D and E share three tubes: needs two lines counted together.
const mercuryPairBoard = 'RXxlL|rxRRX|uXLrd|XLxLx';

final List<TutorialStep> mercuryStrategies = [
  TutorialStep(
    text: (l) => l.tutMercuryS1,
    puzzle: mercuryBoard(mercuryPairBoard),
    focus: {
      for (var r = 0; r < 4; r++) ...[Pos(r, 3), Pos(r, 4)],
    },
  ),
  TutorialStep.generated(text: (l) => l.tutMercuryS2, make: () => generateMercury(mercuryStrategyParams[0])),
  TutorialStep.generated(text: (l) => l.tutMercuryS3, make: () => generateMercury(mercuryStrategyParams[1])),
];
