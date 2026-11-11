import '../../core/grid.dart';
import '../../core/value_grid.dart';

const int sDot = 0;
const int sStar = 1;

/// Stars per row, column and region.
const int starsPerUnit = 2;

class StarsPuzzle implements ValueGridPuzzle {
  const StarsPuzzle({required this.n, required this.regions, required this.solution, this.k = starsPerUnit});

  final int n;

  /// Stars in every row, column and region.
  final int k;

  /// Region id per cell (0..n-1).
  final List<int> regions;

  /// Flat indices of the stars, in reading order.
  final List<int> solution;

  @override
  GridSize get size => GridSize.square(n);
  @override
  int? givenAt(int index) => null;
  @override
  int solutionAt(int index) => solution.contains(index) ? sStar : sDot;

  Map<String, dynamic> toJson() => {'n': n, 'k': k, 'regions': regions, 'solution': solution};
  factory StarsPuzzle.fromJson(Map<String, dynamic> j) => StarsPuzzle(
    n: j['n'] as int,
    k: j['k'] as int? ?? starsPerUnit,
    regions: (j['regions'] as List).cast<int>(),
    solution: (j['solution'] as List).cast<int>(),
  );
}

/// Stars that break a rule (flat indices): stars that touch another one, even
/// diagonally, and the stars of a row, column or region with more than [k].
Set<int> starsConflicts(int n, int k, List<int> regions, List<int> stars) {
  final bad = <int>{};
  for (var a = 0; a < stars.length; a++) {
    for (var b = a + 1; b < stars.length; b++) {
      final i = stars[a], j = stars[b];
      if ((i ~/ n - j ~/ n).abs() <= 1 && (i % n - j % n).abs() <= 1) bad.addAll([i, j]);
    }
  }
  for (final unitOf in <int Function(int)>[(i) => i ~/ n, (i) => i % n, (i) => regions[i]]) {
    final by = <int, List<int>>{};
    for (final s in stars) {
      (by[unitOf(s)] ??= []).add(s);
    }
    for (final g in by.values) {
      if (g.length > k) bad.addAll(g);
    }
  }
  return bad;
}
