import '../../core/grid.dart';
import '../../core/latin_square.dart';

/// A sign between two neighbouring cells: [lo] holds the smaller number.
class Sign {
  const Sign(this.lo, this.hi);

  final int lo;
  final int hi;

  List<int> toJson() => [lo, hi];

  @override
  bool operator ==(Object other) => other is Sign && other.lo == lo && other.hi == hi;
  @override
  int get hashCode => lo * 1000 + hi;
}

/// Every sign a solved grid [g] shows between neighbouring cells.
List<Sign> allSigns(int n, List<int> g) => [
  for (var i = 0; i < n * n; i++) ...[
    if (i % n < n - 1) g[i] < g[i + 1] ? Sign(i, i + 1) : Sign(i + 1, i),
    if (i ~/ n < n - 1) g[i] < g[i + n] ? Sign(i, i + n) : Sign(i + n, i),
  ],
];

/// A Latin square of 1..n (digits 0..n-1) with signs between some
/// neighbouring cells and a few given digits.
class SignsPuzzle implements LatinPuzzle {
  const SignsPuzzle({required this.n, required this.signs, required this.givens, required this.solution});

  @override
  final int n;
  final List<Sign> signs;
  final List<int?> givens;
  final List<int> solution;

  @override
  GridSize get size => GridSize.square(n);
  @override
  int? givenAt(int index) => givens[index];
  @override
  int solutionAt(int index) => solution[index];

  Map<String, dynamic> toJson() => {
    'n': n,
    'signs': [for (final s in signs) s.toJson()],
    'givens': givens,
    'solution': solution,
  };

  factory SignsPuzzle.fromJson(Map<String, dynamic> j) => SignsPuzzle(
    n: j['n'] as int,
    signs: [for (final s in j['signs'] as List) Sign((s as List)[0] as int, s[1] as int)],
    givens: (j['givens'] as List).cast<int?>(),
    solution: (j['solution'] as List).cast<int>(),
  );
}

/// Cells breaking a rule in [g] (-1 = empty): a digit twice in a line, or two
/// filled cells the wrong way round a sign.
Set<int> signsConflicts(SignsPuzzle p, List<int> g) {
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
  for (final s in p.signs) {
    if (g[s.lo] >= 0 && g[s.hi] >= 0 && g[s.lo] >= g[s.hi]) bad.addAll([s.lo, s.hi]);
  }
  return bad;
}
