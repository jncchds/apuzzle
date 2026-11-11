import '../../core/grid.dart';
import '../../core/value_grid.dart';

/// The board value of a dark cell (digits are 0..n−1 for 1..n).
const int straightsBlock = 9;

/// Lines are rows 0..n-1, then columns n..2n-1.
List<List<int>> straightsLines(int n) => [
  for (var r = 0; r < n; r++) [for (var c = 0; c < n; c++) r * n + c],
  for (var c = 0; c < n; c++) [for (var r = 0; r < n; r++) r * n + c],
];

/// A run: open cells side by side in line [line], between dark cells or the
/// edge. Its numbers must be consecutive, in any order.
class StraightsRun {
  const StraightsRun(this.line, this.cells);

  final int line;

  /// In order along the line.
  final List<int> cells;
}

/// Every run of the grid with dark cells [dark]: rows first, then columns.
List<StraightsRun> straightsRuns(int n, List<bool> dark) {
  final runs = <StraightsRun>[];
  final lines = straightsLines(n);
  for (var u = 0; u < lines.length; u++) {
    var cells = <int>[];
    for (final i in lines[u]) {
      if (dark[i]) {
        if (cells.isNotEmpty) runs.add(StraightsRun(u, cells));
        cells = [];
      } else {
        cells.add(i);
      }
    }
    if (cells.isNotEmpty) runs.add(StraightsRun(u, cells));
  }
  return runs;
}

/// An n×n grid with dark cells, some of them holding a number. Open cells
/// get the numbers 1..n, none twice in a row or column (dark cells' numbers
/// count too), and every run of open cells holds consecutive numbers.
class StraightsPuzzle implements ValueGridPuzzle {
  StraightsPuzzle({
    required this.n,
    required this.dark,
    required this.clues,
    required this.givens,
    required this.solution,
  }) : runs = straightsRuns(n, dark) {
    runOf = [List.filled(n * n, -1), List.filled(n * n, -1)];
    for (var x = 0; x < runs.length; x++) {
      for (final i in runs[x].cells) {
        runOf[runs[x].line < n ? 0 : 1][i] = x;
      }
    }
  }

  final int n;

  /// Whether each cell is dark.
  final List<bool> dark;

  /// The number (0..n−1) on a dark cell, null where none.
  final List<int?> clues;

  /// Open cells shown from the start (null elsewhere).
  final List<int?> givens;

  /// A digit 0..n−1 per open cell, [straightsBlock] on dark cells.
  final List<int> solution;

  final List<StraightsRun> runs;

  /// The run across ([0]) and down ([1]) through each open cell (-1 on dark
  /// cells).
  late final List<List<int>> runOf;

  @override
  GridSize get size => GridSize.square(n);
  @override
  int? givenAt(int index) => dark[index] ? straightsBlock : givens[index];
  @override
  int solutionAt(int index) => solution[index];

  Map<String, dynamic> toJson() => {
    'n': n,
    'dark': [for (final d in dark) d ? 1 : 0],
    'clues': clues,
    'givens': givens,
    'solution': solution,
  };

  factory StraightsPuzzle.fromJson(Map<String, dynamic> j) => StraightsPuzzle(
    n: j['n'] as int,
    dark: [for (final d in j['dark'] as List) d == 1],
    clues: (j['clues'] as List).cast<int?>(),
    givens: (j['givens'] as List).cast<int?>(),
    solution: (j['solution'] as List).cast<int>(),
  );
}

/// Whether [digits] (all filled) are consecutive and different.
bool straightsIsStraight(List<int> digits) {
  if (digits.isEmpty) return true;
  var lo = digits[0], hi = digits[0], mask = 0;
  for (final d in digits) {
    if (mask & (1 << d) != 0) return false;
    mask |= 1 << d;
    if (d < lo) lo = d;
    if (d > hi) hi = d;
  }
  return hi - lo == digits.length - 1;
}

/// Open cells breaking a rule in [g] (-1 = empty, [straightsBlock] dark): a
/// number twice in a line (or the number of a dark cell there), or a run
/// whose numbers can't be consecutive any more (already too far apart, or
/// full and not consecutive).
Set<int> straightsConflicts(StraightsPuzzle p, List<int> g) {
  final bad = <int>{};
  for (final line in straightsLines(p.n)) {
    final seen = <int, int>{};
    for (final i in line) {
      final v = p.dark[i] ? p.clues[i] : (g[i] < 0 || g[i] >= p.n ? null : g[i]);
      if (v == null) continue;
      final j = seen[v];
      if (j != null) {
        if (!p.dark[i]) bad.add(i);
        if (!p.dark[j]) bad.add(j);
      }
      seen[v] = i;
    }
  }
  for (final run in p.runs) {
    final filled = [
      for (final i in run.cells)
        if (g[i] >= 0 && g[i] < p.n) g[i],
    ];
    if (filled.isEmpty) continue;
    var lo = filled[0], hi = filled[0];
    for (final d in filled) {
      if (d < lo) lo = d;
      if (d > hi) hi = d;
    }
    final full = filled.length == run.cells.length;
    if (hi - lo >= run.cells.length || (full && !straightsIsStraight(filled))) bad.addAll(run.cells);
  }
  return bad;
}
