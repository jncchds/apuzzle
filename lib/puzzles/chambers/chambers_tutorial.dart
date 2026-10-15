import '../../core/difficulty.dart';
import '../../core/grid.dart';
import '../../core/tutorial.dart';
import 'chambers_generator.dart';
import 'chambers_model.dart';

/// A board from rows separated by |: a letter per cell names its room (a
/// rectangle), upper case is shaded. Rooms in [hidden] show no number.
ChambersPuzzle chambersBoard(String board, {String hidden = ''}) {
  final rows = board.split('|');
  final n = rows.length;
  final cells = rows.join().split('');
  final ids = <String, int>{};
  final at = <int, List<int>>{};
  for (var i = 0; i < cells.length; i++) {
    final k = ids.putIfAbsent(cells[i].toLowerCase(), () => ids.length);
    (at[k] ??= []).add(i);
  }
  final shaded = [for (final ch in cells) ch != ch.toLowerCase()];
  final rooms = [
    for (var k = 0; k < ids.length; k++)
      ChambersRoom(
        at[k]!.first ~/ n,
        at[k]!.first % n,
        at[k]!.last ~/ n - at[k]!.first ~/ n + 1,
        at[k]!.last % n - at[k]!.first % n + 1,
      ),
  ];
  return ChambersPuzzle(
    n: n,
    rooms: rooms,
    clues: [
      for (final e in ids.entries)
        if (hidden.contains(e.key)) null else at[e.value]!.where((i) => shaded[i]).length,
    ],
    shaded: shaded,
  );
}

final List<TutorialStep> chambersTutorial = [
  // A 0 room stays empty, a one-cell room with 1 is shaded, and its
  // neighbour stays, so the room above shades its top cell.
  TutorialStep(text: (l) => l.tutChambers1, puzzle: chambersBoard('aaB|aab|aaC')),
  // The bottom row runs through three rooms: the two 0 rooms can't break
  // it, so the third one does.
  TutorialStep(
    text: (l) => l.tutChambers2,
    puzzle: chambersBoard('aab|aab|cdB'),
    focus: {const Pos(2, 0), const Pos(2, 1), const Pos(2, 2)},
  ),
  // The top-left cell's only way out is the cell below it.
  TutorialStep(
    text: (l) => l.tutChambers3,
    puzzle: chambersBoard('aBc|ddc|DdE'),
    focus: {const Pos(0, 0), const Pos(1, 0)},
  ),
  TutorialStep.generated(
    text: (l) => l.tutChambers4,
    make: () => generateChambers(const GenParams(size: GridSize.square(5), difficulty: Difficulty.easy, seed: 1)),
  ),
];

/// Generated strategy boards: medium needs every way to shade a room or
/// cuts, hard needs probing.
const chambersStrategyParams = [
  GenParams(size: GridSize.square(6), difficulty: Difficulty.medium, seed: 1),
  GenParams(size: GridSize.square(7), difficulty: Difficulty.hard, seed: 1),
];

final List<TutorialStep> chambersStrategies = [
  // The right column room of three holds 2: only its two ends.
  TutorialStep(
    text: (l) => l.tutChambersS1,
    puzzle: chambersBoard('aabC|aAbc|aabC|ddde', hidden: 'be'),
    focus: {const Pos(0, 3), const Pos(1, 3), const Pos(2, 3)},
  ),
  TutorialStep.generated(text: (l) => l.tutChambersS2, make: () => generateChambers(chambersStrategyParams[0])),
  TutorialStep.generated(text: (l) => l.tutChambersS3, make: () => generateChambers(chambersStrategyParams[1])),
];
