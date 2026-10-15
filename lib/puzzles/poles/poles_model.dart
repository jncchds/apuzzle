import '../../core/grid.dart';
import '../../core/value_grid.dart';

/// Cell values: the + end of a charged domino, its − end, or blank.
const int polePlus = 0;
const int poleMinus = 1;
const int poleBlank = 2;

/// The value across the domino from a cell holding [v].
int poleOpposite(int v) => v == poleBlank ? poleBlank : 1 - v;

/// Poles: the grid is tiled with dominoes, each either charged (one + end and
/// one − end) or blank. Like ends never touch side by side. The numbers left
/// of and above the grid count the + cells of each row and column, the
/// numbers right of and below it the − cells; some may be hidden.
class PolesPuzzle implements ValueGridPuzzle {
  PolesPuzzle({
    required this.rows,
    required this.cols,
    required this.mate,
    required this.solution,
    required this.plus,
    required this.minus,
    this.givens = const [],
  });

  final int rows;
  final int cols;

  /// The other cell of each cell's domino.
  final List<int> mate;

  /// [polePlus], [poleMinus] or [poleBlank] per cell.
  final List<int> solution;

  /// + and − cells per line ([polesLines]: rows, then columns), null where hidden.
  final List<int?> plus;
  final List<int?> minus;

  /// Cells shown from the start.
  final List<int> givens;

  int get charged => solution.where((v) => v != poleBlank).length;

  @override
  GridSize get size => GridSize(rows, cols);
  @override
  int? givenAt(int index) => givens.contains(index) ? solution[index] : null;
  @override
  int solutionAt(int index) => solution[index];

  static const _dirs = 'RDLU';

  Map<String, dynamic> toJson() => {
    'rows': rows,
    'cols': cols,
    'tiles': [
      for (var i = 0; i < mate.length; i++)
        _dirs[mate[i] == i + 1
            ? 0
            : mate[i] == i + cols
            ? 1
            : mate[i] == i - 1
            ? 2
            : 3],
    ].join(),
    'v': [for (final v in solution) '+-.'[v]].join(),
    'p': plus,
    'm': minus,
    if (givens.isNotEmpty) 'given': givens,
  };

  factory PolesPuzzle.fromJson(Map<String, dynamic> j) {
    final rows = j['rows'] as int, cols = j['cols'] as int;
    final tiles = j['tiles'] as String, v = j['v'] as String;
    return PolesPuzzle(
      rows: rows,
      cols: cols,
      mate: [
        for (var i = 0; i < tiles.length; i++) i + [1, cols, -1, -cols][_dirs.indexOf(tiles[i])],
      ],
      solution: [for (final ch in v.split('')) '+-.'.indexOf(ch)],
      plus: (j['p'] as List).cast<int?>(),
      minus: (j['m'] as List).cast<int?>(),
      givens: ((j['given'] as List?) ?? const []).cast<int>(),
    );
  }
}

/// The lines of a board: rows (left to right), then columns (top to bottom).
List<List<int>> polesLines(int rows, int cols) => [
  for (var r = 0; r < rows; r++) [for (var c = 0; c < cols; c++) r * cols + c],
  for (var c = 0; c < cols; c++) [for (var r = 0; r < rows; r++) r * cols + c],
];

/// + and − counts of [values] per line.
(List<int>, List<int>) polesCounts(int rows, int cols, List<int> values) {
  final lines = polesLines(rows, cols);
  return (
    [for (final l in lines) l.where((i) => values[i] == polePlus).length],
    [for (final l in lines) l.where((i) => values[i] == poleMinus).length],
  );
}

/// Cells breaking a rule on a board of values (-1 empty). Before the board
/// is [complete] only what more input can't fix is flagged: like ends side
/// by side, a domino whose two ends don't go together, and lines with more
/// + or − cells (or blank ones) than they may hold.
Set<int> polesConflicts(PolesPuzzle p, List<int> v, {required bool complete}) {
  final rows = p.rows, cols = p.cols, bad = <int>{};
  for (var i = 0; i < v.length; i++) {
    if (v[i] < 0) continue;
    final r = i ~/ cols, c = i % cols;
    for (final j in [if (c + 1 < cols) i + 1, if (r + 1 < rows) i + cols]) {
      if (v[j] == v[i] && v[i] != poleBlank && p.mate[i] != j) bad.addAll([i, j]);
    }
    final m = p.mate[i];
    final mv = v[m] < 0 && complete ? poleBlank : v[m];
    final me = v[i];
    if (mv >= 0 && mv != poleOpposite(me)) bad.addAll([i, if (v[m] >= 0) m]);
  }
  final lines = polesLines(rows, cols);
  for (var li = 0; li < lines.length; li++) {
    final cells = lines[li];
    for (final (want, sign) in [(p.plus[li], polePlus), (p.minus[li], poleMinus)]) {
      if (want == null) continue;
      final have = [
        for (final i in cells)
          if (v[i] == sign) i,
      ];
      if (have.length > want || (complete && have.length != want)) bad.addAll(have.isEmpty ? cells : have);
    }
    if (p.plus[li] case final a?) {
      if (p.minus[li] case final b?) {
        final blank = [
          for (final i in cells)
            if (v[i] == poleBlank) i,
        ];
        if (blank.length > cells.length - a - b) bad.addAll(blank);
      }
    }
  }
  return bad;
}
