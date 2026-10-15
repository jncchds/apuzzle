import '../../core/grid.dart';
import '../../core/value_grid.dart';
import '../sudoku/sudoku_model.dart';

/// A pocket: its cells (ascending, so the first is the top-left one that
/// shows the sum) and the sum of their digits.
class Pocket {
  const Pocket(this.cells, this.sum);

  final List<int> cells;
  final int sum;

  List<Object> toJson() => [cells, sum];

  factory Pocket.fromJson(List<dynamic> j) => Pocket((j[0] as List).cast<int>(), j[1] as int);
}

/// A Sudoku (digits 0..n-1 for 1..n) whose grid is also cut into pockets:
/// the digits of a pocket add up to its sum and never repeat.
class PocketsPuzzle implements ValueGridPuzzle {
  PocketsPuzzle({required this.n, required this.pockets, required this.givens, required this.solution})
    : pocketOf = _pocketOf(n, pockets);

  final int n;
  final List<Pocket> pockets;

  /// Digits shown from the start (null elsewhere): only tutorials have any.
  final List<int?> givens;
  final List<int> solution;

  /// The pocket index of every cell.
  final List<int> pocketOf;

  static List<int> _pocketOf(int n, List<Pocket> pockets) {
    final of = List.filled(n * n, -1);
    for (var x = 0; x < pockets.length; x++) {
      for (final i in pockets[x].cells) {
        of[i] = x;
      }
    }
    return of;
  }

  @override
  GridSize get size => GridSize.square(n);
  @override
  int? givenAt(int index) => givens[index];
  @override
  int solutionAt(int index) => solution[index];

  Map<String, dynamic> toJson() => {
    'n': n,
    'pockets': [for (final p in pockets) p.toJson()],
    'givens': givens,
    'solution': solution,
  };

  factory PocketsPuzzle.fromJson(Map<String, dynamic> j) => PocketsPuzzle(
    n: j['n'] as int,
    pockets: [for (final p in j['pockets'] as List) Pocket.fromJson(p as List)],
    givens: (j['givens'] as List).cast<int?>(),
    solution: (j['solution'] as List).cast<int>(),
  );
}

/// Whether the digits of [pocket] in [g] (-1 = empty) add up to its sum.
bool pocketDone(Pocket pocket, List<int> g) {
  var sum = 0;
  for (final i in pocket.cells) {
    if (g[i] < 0) return false;
    sum += g[i] + 1;
  }
  return sum == pocket.sum;
}

/// Cells breaking a rule in [g] (-1 = empty): a digit twice in a row,
/// column, box or pocket, a pocket whose digits already pass its sum, or a
/// full pocket that misses it. Only what more digits can't fix.
Set<int> pocketsConflicts(PocketsPuzzle p, List<int> g) {
  final bad = sudokuConflicts(p.n, g);
  for (final pocket in p.pockets) {
    final seen = <int, int>{};
    var sum = 0, full = true;
    for (final i in pocket.cells) {
      if (g[i] < 0) {
        full = false;
        continue;
      }
      sum += g[i] + 1;
      final j = seen[g[i]];
      if (j != null) bad.addAll([i, j]);
      seen[g[i]] = i;
    }
    if (sum > pocket.sum || full && sum != pocket.sum) {
      bad.addAll([
        for (final i in pocket.cells)
          if (g[i] >= 0) i,
      ]);
    }
  }
  return bad;
}
