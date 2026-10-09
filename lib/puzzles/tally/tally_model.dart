import '../../core/grid.dart';
import '../../core/value_grid.dart';

const int tallyCross = 0;
const int tallyKeep = 1;

/// Tally: every cell holds a digit. Cross some out so the digits left in
/// each row and column add up to the number outside the grid.
class TallyPuzzle implements ValueGridPuzzle {
  const TallyPuzzle({
    required this.rows,
    required this.cols,
    required this.digits,
    required this.kept,
    this.givens = const [],
  });

  final int rows;
  final int cols;
  final List<int> digits;

  /// Solution: the cells that stay.
  final List<bool> kept;

  /// Cells shown from the start (where the logic needed help).
  final List<int> givens;

  @override
  GridSize get size => GridSize(rows, cols);

  /// Cell indices of row [r].
  List<int> rowCells(int r) => [for (var c = 0; c < cols; c++) r * cols + c];

  /// Cell indices of column [c].
  List<int> colCells(int c) => [for (var r = 0; r < rows; r++) r * cols + c];

  int _sum(List<int> cells) => cells.fold(0, (s, i) => kept[i] ? s + digits[i] : s);
  List<int> get rowTargets => [for (var r = 0; r < rows; r++) _sum(rowCells(r))];
  List<int> get colTargets => [for (var c = 0; c < cols; c++) _sum(colCells(c))];

  @override
  int? givenAt(int index) => givens.contains(index) ? solutionAt(index) : null;
  @override
  int solutionAt(int index) => kept[index] ? tallyKeep : tallyCross;

  Map<String, dynamic> toJson() => {
    'rows': rows,
    'cols': cols,
    'digits': digits.join(),
    'kept': [
      for (var i = 0; i < kept.length; i++)
        if (kept[i]) i,
    ],
    if (givens.isNotEmpty) 'given': givens,
  };

  factory TallyPuzzle.fromJson(Map<String, dynamic> j) {
    final rows = j['rows'] as int, cols = j['cols'] as int;
    final kept = List<bool>.filled(rows * cols, false);
    for (final i in (j['kept'] as List).cast<int>()) {
      kept[i] = true;
    }
    return TallyPuzzle(
      rows: rows,
      cols: cols,
      digits: [for (final ch in (j['digits'] as String).split('')) int.parse(ch)],
      kept: kept,
      givens: ((j['given'] as List?) ?? const []).cast<int>(),
    );
  }
}

/// Cells breaking a rule when crossed-out cells are [crossed] and kept ones
/// [kept] (undecided cells count as staying): kept cells of a line that
/// already adds up to too much, crossed cells of one that can't reach its
/// number any more.
Set<int> tallyConflicts(TallyPuzzle p, List<bool> crossed, List<bool> kept) {
  final bad = <int>{};
  final targets = [...p.rowTargets, ...p.colTargets];
  final lines = [for (var r = 0; r < p.rows; r++) p.rowCells(r), for (var c = 0; c < p.cols; c++) p.colCells(c)];
  for (var li = 0; li < lines.length; li++) {
    var sure = 0, most = 0;
    for (final i in lines[li]) {
      if (kept[i]) sure += p.digits[i];
      if (!crossed[i]) most += p.digits[i];
    }
    if (sure > targets[li]) bad.addAll(lines[li].where((i) => kept[i]));
    if (most < targets[li]) bad.addAll(lines[li].where((i) => crossed[i]));
  }
  return bad;
}

/// Whether the cells not crossed out add up to every number.
bool tallySums(TallyPuzzle p, List<bool> crossed) {
  int sum(List<int> cells) => cells.fold(0, (s, i) => crossed[i] ? s : s + p.digits[i]);
  final rt = p.rowTargets, ct = p.colTargets;
  for (var r = 0; r < p.rows; r++) {
    if (sum(p.rowCells(r)) != rt[r]) return false;
  }
  for (var c = 0; c < p.cols; c++) {
    if (sum(p.colCells(c)) != ct[c]) return false;
  }
  return true;
}
