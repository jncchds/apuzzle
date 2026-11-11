import '../../core/grid.dart';
import '../../core/value_grid.dart';

/// The board value of a shaded cell; digits 1..n−2 are their own values.
const int betweenShade = 0;

/// Lines are rows 0..n-1, then columns n..2n-1.
List<List<int>> betweenLines(int n) => [
  for (var r = 0; r < n; r++) [for (var c = 0; c < n; c++) r * n + c],
  for (var c = 0; c < n; c++) [for (var r = 0; r < n; r++) r * n + c],
];

/// The sum of the digits between the two shaded cells of [values] (a line
/// in order), or null if it hasn't exactly two.
int? betweenSum(List<int> values) {
  final at = [
    for (var k = 0; k < values.length; k++)
      if (values[k] == betweenShade) k,
  ];
  if (at.length != 2) return null;
  var sum = 0;
  for (var k = at[0] + 1; k < at[1]; k++) {
    sum += values[k];
  }
  return sum;
}

/// Every row and column holds two shaded cells and the digits 1..n−2 once
/// each; a clue left of a row or above a column is the sum of the digits
/// between its two shaded cells.
class BetweenPuzzle implements ValueGridPuzzle {
  const BetweenPuzzle({required this.n, required this.clues, required this.givens, required this.solution});

  final int n;

  /// Clue of line u (rows, then columns), null where hidden.
  final List<int?> clues;

  /// Values shown from the start (null elsewhere).
  final List<int?> givens;

  /// A value per cell: [betweenShade] or a digit 1..n−2.
  final List<int> solution;

  @override
  GridSize get size => GridSize.square(n);
  @override
  int? givenAt(int index) => givens[index];
  @override
  int solutionAt(int index) => solution[index];

  Map<String, dynamic> toJson() => {'n': n, 'clues': clues, 'givens': givens, 'solution': solution};

  factory BetweenPuzzle.fromJson(Map<String, dynamic> j) => BetweenPuzzle(
    n: j['n'] as int,
    clues: (j['clues'] as List).cast<int?>(),
    givens: (j['givens'] as List).cast<int?>(),
    solution: (j['solution'] as List).cast<int>(),
  );
}

/// Every line's sum in the grid [g].
List<int> betweenClues(int n, List<int> g) => [
  for (final line in betweenLines(n)) betweenSum([for (final i in line) g[i]])!,
];

/// Cells breaking a rule in [g] (-1 = empty): a digit twice in a line, a
/// third shaded cell, or a line whose two shaded cells hold the wrong sum
/// between them (once the cells between are filled).
Set<int> betweenConflicts(BetweenPuzzle p, List<int> g) {
  final n = p.n, bad = <int>{};
  final lines = betweenLines(n);
  for (var u = 0; u < lines.length; u++) {
    final line = lines[u];
    final seen = <int, int>{};
    final shaded = <int>[];
    for (final i in line) {
      if (g[i] < 0) continue;
      if (g[i] == betweenShade) {
        shaded.add(i);
        continue;
      }
      final j = seen[g[i]];
      if (j != null) bad.addAll([i, j]);
      seen[g[i]] = i;
    }
    if (shaded.length > 2) bad.addAll(shaded);
    final want = p.clues[u];
    if (want == null || shaded.length != 2) continue;
    final a = line.indexOf(shaded[0]), b = line.indexOf(shaded[1]);
    final inside = line.sublist(a + 1, b);
    if (inside.any((i) => g[i] < 0)) continue;
    final sum = inside.fold(0, (s, i) => s + g[i]);
    if (sum != want) bad.addAll(line.sublist(a, b + 1));
  }
  return bad;
}
