import '../../core/grid.dart';
import '../../core/value_grid.dart';

const int kDot = 0;
const int kKing = 1;

class KingsPuzzle implements ValueGridPuzzle {
  const KingsPuzzle({required this.n, required this.regions, required this.solution});

  final int n;

  /// Region id per cell (0..n-1).
  final List<int> regions;

  /// Column of the king in each row.
  final List<int> solution;

  @override
  GridSize get size => GridSize.square(n);
  @override
  int? givenAt(int index) => null;
  @override
  int solutionAt(int index) => solution[index ~/ n] == index % n ? kKing : kDot;

  Map<String, dynamic> toJson() => {'n': n, 'regions': regions, 'solution': solution};
  factory KingsPuzzle.fromJson(Map<String, dynamic> j) => KingsPuzzle(
        n: j['n'] as int,
        regions: (j['regions'] as List).cast<int>(),
        solution: (j['solution'] as List).cast<int>(),
      );
}

/// Kings that break a rule (flat indices). [kings] = flat indices of kings.
Set<int> kingsConflicts(int n, List<int> regions, List<int> kings) {
  final bad = <int>{};
  for (var a = 0; a < kings.length; a++) {
    for (var b = a + 1; b < kings.length; b++) {
      final i = kings[a], j = kings[b];
      final ri = i ~/ n, ci = i % n, rj = j ~/ n, cj = j % n;
      final touching = (ri - rj).abs() <= 1 && (ci - cj).abs() <= 1;
      if (ri == rj || ci == cj || regions[i] == regions[j] || touching) bad.addAll([i, j]);
    }
  }
  return bad;
}
