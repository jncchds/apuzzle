import '../../core/grid.dart';
import '../../core/latin_square.dart';

/// Sides of the board, as [sideTok] numbers them: clues above the columns,
/// below them, left of the rows and right of them.
const int skylineTop = 0, skylineBottom = 1, skylineLeft = 2, skylineRight = 3;

/// Cells of the line seen from clue [k] of [side], nearest first.
List<int> skylineLine(int n, int side, int k) => switch (side) {
  skylineTop => [for (var r = 0; r < n; r++) r * n + k],
  skylineBottom => [for (var r = n - 1; r >= 0; r--) r * n + k],
  skylineLeft => [for (var c = 0; c < n; c++) k * n + c],
  _ => [for (var c = n - 1; c >= 0; c--) k * n + c],
};

/// How many towers of [heights] (in viewing order) can be seen: each one
/// taller than all before it.
int skylineVisible(Iterable<int> heights) {
  var seen = 0, top = -1;
  for (final h in heights) {
    if (h > top) {
      seen++;
      top = h;
    }
  }
  return seen;
}

/// Towers: a Latin square of heights 1..n (digits 0..n-1), with clues around
/// the board saying how many towers can be seen from there.
class SkylinePuzzle implements LatinPuzzle {
  const SkylinePuzzle({required this.n, required this.clues, required this.givens, required this.solution});

  @override
  final int n;

  /// Clue `side * n + k` (see [skylineTop]...), null where hidden.
  final List<int?> clues;

  /// Digits shown from the start (null elsewhere).
  final List<int?> givens;
  final List<int> solution;

  int? clue(int side, int k) => clues[side * n + k];

  @override
  GridSize get size => GridSize.square(n);
  @override
  int? givenAt(int index) => givens[index];
  @override
  int solutionAt(int index) => solution[index];

  Map<String, dynamic> toJson() => {'n': n, 'clues': clues, 'givens': givens, 'solution': solution};

  factory SkylinePuzzle.fromJson(Map<String, dynamic> j) => SkylinePuzzle(
    n: j['n'] as int,
    clues: (j['clues'] as List).cast<int?>(),
    givens: (j['givens'] as List).cast<int?>(),
    solution: (j['solution'] as List).cast<int>(),
  );
}

/// Every clue of the grid [g] (a digit per cell).
List<int> skylineClues(int n, List<int> g) => [
  for (var side = 0; side < 4; side++)
    for (var k = 0; k < n; k++) skylineVisible(skylineLine(n, side, k).map((i) => g[i])),
];

/// Cells breaking a rule in [g] (-1 = empty): a digit twice in a line, or a
/// full line whose towers don't match a clue.
Set<int> skylineConflicts(SkylinePuzzle p, List<int> g) {
  final n = p.n, sq = LatinSquare.of(n), bad = <int>{};
  for (final line in sq.lines) {
    final seen = <int, int>{};
    for (final i in line) {
      if (g[i] < 0) continue;
      final j = seen[g[i]];
      if (j != null) bad.addAll([i, j]);
      seen[g[i]] = i;
    }
  }
  for (var side = 0; side < 4; side++) {
    for (var k = 0; k < n; k++) {
      final want = p.clue(side, k);
      if (want == null) continue;
      final line = skylineLine(n, side, k);
      if (line.any((i) => g[i] < 0)) continue;
      if (skylineVisible(line.map((i) => g[i])) != want) bad.addAll(line);
    }
  }
  return bad;
}
