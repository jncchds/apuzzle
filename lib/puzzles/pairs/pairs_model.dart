import '../../core/grid.dart';
import '../../core/grid_graph.dart';
import '../../core/value_grid.dart';

const int pairsShade = 0;
const int pairsDot = 1;

/// Norinori: shade exactly two cells in every region so that every shaded
/// cell touches exactly one other shaded cell (the shading is all dominoes).
class PairsPuzzle implements ValueGridPuzzle {
  const PairsPuzzle({required this.n, required this.regions, required this.shaded});

  final int n;

  /// Region id per cell.
  final List<int> regions;

  /// Solution.
  final List<bool> shaded;

  int get regionCount => regions.reduce((a, b) => a > b ? a : b) + 1;

  @override
  GridSize get size => GridSize.square(n);
  @override
  int? givenAt(int index) => null;
  @override
  int solutionAt(int index) => shaded[index] ? pairsShade : pairsDot;

  Map<String, dynamic> toJson() => {
    'n': n,
    'regions': regions,
    'shaded': [
      for (var i = 0; i < shaded.length; i++)
        if (shaded[i]) i,
    ],
  };

  factory PairsPuzzle.fromJson(Map<String, dynamic> j) {
    final n = j['n'] as int;
    final shaded = List<bool>.filled(n * n, false);
    for (final i in (j['shaded'] as List).cast<int>()) {
      shaded[i] = true;
    }
    return PairsPuzzle(n: n, regions: (j['regions'] as List).cast<int>(), shaded: shaded);
  }
}

/// Cells breaking a rule: regions with more than two shaded cells, shaded
/// cells touching two others. With [complete] also regions without exactly
/// two and shaded cells touching none.
Set<int> pairsConflicts(int n, List<int> regions, List<bool> shaded, {required bool complete}) {
  final nb = orthNeighbors(n, n);
  final bad = <int>{};
  final count = <int, List<int>>{};
  for (var i = 0; i < shaded.length; i++) {
    if (shaded[i]) (count[regions[i]] ??= []).add(i);
  }
  for (final cells in count.values) {
    if (cells.length > 2) bad.addAll(cells);
  }
  for (var i = 0; i < shaded.length; i++) {
    if (!shaded[i]) continue;
    final touching = nb[i].where((j) => shaded[j]).length;
    if (touching > 1 || (complete && touching == 0)) bad.add(i);
  }
  if (complete) {
    for (var i = 0; i < shaded.length; i++) {
      if ((count[regions[i]]?.length ?? 0) < 2) bad.add(i);
    }
  }
  return bad;
}
