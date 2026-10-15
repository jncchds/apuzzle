import '../../core/grid.dart';
import '../../core/value_grid.dart';

/// The board value of a clue cell (digits are 0..8 for 1..9).
const int totalsBlock = 9;

/// All nine digits as a candidate mask.
const int totalsFull = 511;

/// A run: the white cells right of or below a clue cell, up to the next clue
/// cell or the edge, with the sum they make.
class TotalsRun {
  const TotalsRun(this.clue, this.across, this.cells, this.sum);

  /// The clue cell that shows [sum].
  final int clue;
  final bool across;

  /// Left to right or top to bottom.
  final List<int> cells;
  final int sum;
}

/// A crossword of digits: white cells hold 1..9, each run of white cells
/// adds up to the clue before it and holds no digit twice. The clue cells
/// are the blocks: the sum across sits top right, the sum down bottom left.
class TotalsPuzzle implements ValueGridPuzzle {
  TotalsPuzzle({required this.rows, required this.cols, required this.digits, this.givens = const []})
    : runs = _runs(rows, cols, digits) {
    acrossOf = List.filled(digits.length, -1);
    downOf = List.filled(digits.length, -1);
    acrossFrom = List.filled(digits.length, -1);
    downFrom = List.filled(digits.length, -1);
    for (var x = 0; x < runs.length; x++) {
      final run = runs[x];
      for (final i in run.cells) {
        (run.across ? acrossOf : downOf)[i] = x;
      }
      (run.across ? acrossFrom : downFrom)[run.clue] = x;
    }
  }

  final int rows;
  final int cols;

  /// The solution: a digit 0..8 per white cell, -1 for a clue cell.
  final List<int> digits;

  /// White cells shown from the start, sorted (only some tutorial boards).
  final List<int> givens;

  final List<TotalsRun> runs;

  /// The run across and down through each white cell (-1 for clue cells).
  late final List<int> acrossOf, downOf;

  /// The runs a clue cell starts across and down (-1 for none).
  late final List<int> acrossFrom, downFrom;

  bool isBlock(int i) => digits[i] < 0;

  @override
  GridSize get size => GridSize(rows, cols);
  @override
  int? givenAt(int index) => isBlock(index)
      ? totalsBlock
      : givens.contains(index)
      ? digits[index]
      : null;
  @override
  int solutionAt(int index) => isBlock(index) ? totalsBlock : digits[index];

  static List<TotalsRun> _runs(int rows, int cols, List<int> digits) {
    final runs = <TotalsRun>[];
    void scan(int clue, int step, int count, bool across) {
      final cells = <int>[];
      for (var k = 1, i = clue + step; k < count && digits[i] >= 0; k++, i += step) {
        cells.add(i);
      }
      if (cells.isEmpty) return;
      runs.add(TotalsRun(clue, across, cells, cells.fold(0, (s, i) => s + digits[i] + 1)));
    }

    for (var i = 0; i < rows * cols; i++) {
      if (digits[i] >= 0) continue;
      scan(i, 1, cols - i % cols, true);
      scan(i, cols, rows - i ~/ cols, false);
    }
    return runs;
  }

  Map<String, dynamic> toJson() => {
    'r': rows,
    'c': cols,
    'd': [for (final d in digits) d < 0 ? '#' : '${d + 1}'].join(),
    'g': givens,
  };

  factory TotalsPuzzle.fromJson(Map<String, dynamic> j) => TotalsPuzzle(
    rows: j['r'] as int,
    cols: j['c'] as int,
    digits: [for (final ch in (j['d'] as String).split('')) ch == '#' ? -1 : int.parse(ch) - 1],
    givens: (j['g'] as List).cast<int>(),
  );
}

/// Whether [digits] (1..9, one per cell of [run], 0 for an empty cell) still
/// fit the run: no digit twice, and the sum not past the clue (or, once full,
/// exactly the clue). Only what more digits can't fix counts.
bool totalsRunFits(TotalsRun run, List<int> digits) {
  var seen = 0, sum = 0, empty = 0;
  for (final d in digits) {
    if (d == 0) {
      empty++;
      continue;
    }
    if (seen & (1 << d) != 0) return false;
    seen |= 1 << d;
    sum += d;
  }
  return empty == 0 ? sum == run.sum : sum + empty <= run.sum;
}

/// Cells breaking a rule in [values] (board values, -1 for empty): a digit
/// twice in a run, a run already past its sum, or a full run that misses it.
Set<int> totalsConflicts(TotalsPuzzle p, List<int> values) {
  final bad = <int>{};
  for (final run in p.runs) {
    final digits = [for (final i in run.cells) values[i] < 0 || values[i] >= totalsBlock ? 0 : values[i] + 1];
    if (totalsRunFits(run, digits)) continue;
    bad.addAll([
      for (final i in run.cells)
        if (values[i] >= 0) i,
    ]);
  }
  return bad;
}
