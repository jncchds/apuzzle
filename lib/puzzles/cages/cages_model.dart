import '../../core/grid.dart';
import '../../core/latin_square.dart';

/// How a cage's numbers make its target: a lone cell holds it, the others
/// add, take away (two cells: bigger minus smaller), multiply or divide (two
/// cells: bigger over smaller).
enum CageOp {
  none(''),
  add('+'),
  sub('−'),
  mul('×'),
  div('÷');

  const CageOp(this.symbol);
  final String symbol;
}

/// A cage: its cells (ascending, so the first is the top-left one that shows
/// the clue), its operation and target.
class Cage {
  const Cage(this.cells, this.op, this.target);

  final List<int> cells;
  final CageOp op;
  final int target;

  /// The clue as shown: "12×", "3−", or just "4" for a lone cell.
  String get clue => '$target${op.symbol}';

  /// Whether [numbers] (1..n, one per cell) make the target.
  bool holds(List<int> numbers) => cageHolds(op, target, numbers);

  List<Object> toJson() => [cells, op.index, target];

  factory Cage.fromJson(List<dynamic> j) => Cage((j[0] as List).cast<int>(), CageOp.values[j[1] as int], j[2] as int);
}

bool cageHolds(CageOp op, int target, List<int> v) => switch (op) {
  CageOp.none => v[0] == target,
  CageOp.add => v.fold(0, (a, b) => a + b) == target,
  CageOp.mul => v.fold(1, (a, b) => a * b) == target,
  CageOp.sub => (v[0] - v[1]).abs() == target,
  CageOp.div => v[0] > v[1] ? v[0] == v[1] * target : v[1] == v[0] * target,
};

/// The target of [op] for [numbers] (1..n), or null for a division with a
/// remainder.
int? cageTarget(CageOp op, List<int> numbers) {
  switch (op) {
    case CageOp.none:
      return numbers[0];
    case CageOp.add:
      return numbers.fold<int>(0, (a, b) => a + b);
    case CageOp.mul:
      return numbers.fold<int>(1, (a, b) => a * b);
    case CageOp.sub:
      return (numbers[0] - numbers[1]).abs();
    case CageOp.div:
      final hi = numbers[0] > numbers[1] ? numbers[0] : numbers[1];
      final lo = numbers[0] > numbers[1] ? numbers[1] : numbers[0];
      return hi % lo == 0 ? hi ~/ lo : null;
  }
}

/// A Latin square of 1..n (digits 0..n-1) cut into cages, each with a target
/// its numbers must make with its operation.
class CagesPuzzle implements LatinPuzzle {
  CagesPuzzle({required this.n, required this.cages, required this.givens, required this.solution})
    : cageOf = _cageOf(n, cages);

  @override
  final int n;
  final List<Cage> cages;

  /// Digits shown from the start (null elsewhere): only the tutorial has any.
  final List<int?> givens;
  final List<int> solution;

  /// The cage index of every cell.
  final List<int> cageOf;

  static List<int> _cageOf(int n, List<Cage> cages) {
    final of = List.filled(n * n, -1);
    for (var x = 0; x < cages.length; x++) {
      for (final i in cages[x].cells) {
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
    'cages': [for (final c in cages) c.toJson()],
    'givens': givens,
    'solution': solution,
  };

  factory CagesPuzzle.fromJson(Map<String, dynamic> j) => CagesPuzzle(
    n: j['n'] as int,
    cages: [for (final c in j['cages'] as List) Cage.fromJson(c as List)],
    givens: (j['givens'] as List).cast<int?>(),
    solution: (j['solution'] as List).cast<int>(),
  );
}

/// Cells breaking a rule in [g] (-1 = empty): a digit twice in a line, or a
/// full cage whose numbers miss its target.
Set<int> cagesConflicts(CagesPuzzle p, List<int> g) {
  final sq = LatinSquare.of(p.n), bad = <int>{};
  for (final line in sq.lines) {
    final seen = <int, int>{};
    for (final i in line) {
      if (g[i] < 0) continue;
      final j = seen[g[i]];
      if (j != null) bad.addAll([i, j]);
      seen[g[i]] = i;
    }
  }
  for (final cage in p.cages) {
    if (cage.cells.any((i) => g[i] < 0)) continue;
    if (!cage.holds([for (final i in cage.cells) g[i] + 1])) bad.addAll(cage.cells);
  }
  return bad;
}
