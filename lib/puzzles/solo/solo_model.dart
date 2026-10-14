import '../../core/grid.dart';
import '../../core/grid_graph.dart';
import '../../core/value_grid.dart';

const int soloShade = 0;
const int soloKeep = 1;

/// Solo: every cell holds a number. Shade some so that no number shows twice
/// in a row or column, shaded cells never touch side by side, the cells left
/// form one area, and every shaded number still shows in its row or column.
class SoloPuzzle implements ValueGridPuzzle {
  const SoloPuzzle({required this.n, required this.digits, required this.shaded, this.givens = const []});

  final int n;
  final List<int> digits;

  /// Solution.
  final List<bool> shaded;

  /// Cells shown from the start (where the logic needed help).
  final List<int> givens;

  @override
  GridSize get size => GridSize.square(n);
  @override
  int? givenAt(int index) => givens.contains(index) ? solutionAt(index) : null;
  @override
  int solutionAt(int index) => shaded[index] ? soloShade : soloKeep;

  Map<String, dynamic> toJson() => {
    'n': n,
    'digits': digits.join(),
    'shaded': [
      for (var i = 0; i < shaded.length; i++)
        if (shaded[i]) i,
    ],
    if (givens.isNotEmpty) 'given': givens,
  };

  factory SoloPuzzle.fromJson(Map<String, dynamic> j) {
    final n = j['n'] as int;
    final shaded = List<bool>.filled(n * n, false);
    for (final i in (j['shaded'] as List).cast<int>()) {
      shaded[i] = true;
    }
    return SoloPuzzle(
      n: n,
      digits: [for (final ch in (j['digits'] as String).split('')) int.parse(ch)],
      shaded: shaded,
      givens: ((j['given'] as List?) ?? const []).cast<int>(),
    );
  }
}

/// Other cells of [i]'s row and column holding the same digit.
List<List<int>> soloCopies(int n, List<int> digits) => List.generate(n * n, (i) {
  final r = i ~/ n, c = i % n;
  return [
    for (var k = 0; k < n; k++)
      if (k != c && digits[r * n + k] == digits[i]) r * n + k,
    for (var k = 0; k < n; k++)
      if (k != r && digits[k * n + c] == digits[i]) k * n + c,
  ];
});

/// Cells breaking a rule when [shaded] cells are shaded and [kept] ones stay
/// (by default every cell not shaded): the same number kept twice in a line,
/// shaded cells touching, and shaded numbers that can't show anywhere else
/// in their lines. With [complete], cells cut off from the largest unshaded
/// area too.
Set<int> soloConflicts(int n, List<int> digits, List<bool> shaded, {List<bool>? kept, required bool complete}) {
  final stays = kept ?? [for (final s in shaded) !s];
  final bad = <int>{};
  final copies = soloCopies(n, digits);
  final nb = orthNeighbors(n, n);
  for (var i = 0; i < n * n; i++) {
    if (shaded[i]) {
      for (final j in nb[i]) {
        if (shaded[j]) bad.add(i);
      }
      if (copies[i].every((j) => shaded[j])) bad.add(i);
    } else if (stays[i]) {
      for (final j in copies[i]) {
        if (stays[j]) bad.add(i);
      }
    }
  }
  if (complete) {
    final parts = components(nb, (i) => !shaded[i])..sort((a, b) => a.length.compareTo(b.length));
    for (final p in parts.take(parts.length - 1)) {
      bad.addAll(p);
    }
  }
  return bad;
}
