import '../../core/difficulty.dart';
import '../../core/grid.dart';
import '../../core/tutorial.dart';
import 'parcels_generator.dart';
import 'parcels_model.dart';

/// A board from region letters (one per cell) and a mask of the cells that
/// show their number ('#'); the numbers come from the regions.
ParcelsPuzzle parcelsBoard(List<String> regions, List<String> shown) {
  final rows = regions.length, cols = regions.first.length;
  final letters = regions.join().split('');
  final ids = <String, int>{};
  final region = [for (final ch in letters) ids.putIfAbsent(ch, () => ids.length)];
  final counts = parcelsCounts(ParcelsGeo.of(rows, cols), region);
  final mask = shown.join().split('');
  return ParcelsPuzzle(
    rows: rows,
    cols: cols,
    k: letters.length ~/ ids.length,
    clues: [for (var i = 0; i < letters.length; i++) mask[i] == '#' ? counts[i] : null],
    regions: region,
  );
}

// The 1 at the top has its one border, the outline: its region is the T.
final _one = parcelsBoard(['aaab', 'cabb', 'cccb'], ['.#..', '....', '....']);
// Two 1s on the sides; what is left closes, splits and finds its way out.
final _pieces = parcelsBoard(['aaab', 'cabb', 'ccdb', 'cddd'], ['....', '...#', '#...', '....']);
// The corner 2 takes B1 and A2; the 2 in C1 keeps that piece from going right.
final _ways = parcelsBoard(['aabb', 'aabb'], ['#.#.', '....']);

final List<TutorialStep> parcelsTutorial = [
  TutorialStep(text: (l) => l.tutParcels1, puzzle: _one, focus: {const Pos(0, 1)}),
  TutorialStep(text: (l) => l.tutParcels2, puzzle: _pieces, focus: {const Pos(1, 3), const Pos(2, 0)}),
  TutorialStep(text: (l) => l.tutParcels3, puzzle: _ways, focus: {const Pos(0, 0), const Pos(0, 2)}),
  TutorialStep.generated(
    text: (l) => l.tutParcels4,
    make: () => generateParcels(const GenParams(size: GridSize.square(4), difficulty: Difficulty.easy, seed: 1)),
  ),
];

/// Pinned strategy boards: medium (every way to grow a piece) and hard
/// (probing).
const parcelsWaysParams = GenParams(size: GridSize.square(5), difficulty: Difficulty.medium, seed: 3);
const parcelsProbeParams = GenParams(size: GridSize.square(6), difficulty: Difficulty.hard, seed: 1);

final List<TutorialStep> parcelsStrategies = [
  TutorialStep.generated(text: (l) => l.tutParcelsS1, make: () => generateParcels(parcelsWaysParams)),
  TutorialStep.generated(text: (l) => l.tutParcelsS2, make: () => generateParcels(parcelsProbeParams)),
];
