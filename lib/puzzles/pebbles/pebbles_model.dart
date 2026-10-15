import '../../core/grid.dart';
import '../../core/grid_graph.dart';
import '../../core/value_grid.dart';

const int pebbleFilled = 0;
const int pebbleHollow = 1;

/// Pebbles: a stone in every cell, filled or hollow. All filled stones form
/// one orthogonally connected group, all hollow ones another, and no 2×2
/// block holds four of a kind. Some stones are shown from the start.
class PebblesPuzzle implements ValueGridPuzzle {
  const PebblesPuzzle({required this.n, required this.filled, required this.givens});

  final int n;

  /// Solution: true for a filled stone.
  final List<bool> filled;

  /// Cells shown from the start, sorted.
  final List<int> givens;

  @override
  GridSize get size => GridSize.square(n);
  @override
  int? givenAt(int index) => givens.contains(index) ? solutionAt(index) : null;
  @override
  int solutionAt(int index) => filled[index] ? pebbleFilled : pebbleHollow;

  Map<String, dynamic> toJson() => {
    'n': n,
    'filled': [for (final f in filled) f ? '1' : '0'].join(),
    'given': givens,
  };

  factory PebblesPuzzle.fromJson(Map<String, dynamic> j) => PebblesPuzzle(
    n: j['n'] as int,
    filled: [for (final ch in (j['filled'] as String).split('')) ch == '1'],
    givens: (j['given'] as List).cast<int>(),
  );
}

/// The top-left cells of every 2×2 block.
Iterable<int> pebbleBlocks(int n) sync* {
  for (var r = 0; r + 1 < n; r++) {
    for (var c = 0; c + 1 < n; c++) {
      yield r * n + c;
    }
  }
}

/// The edge cells clockwise from the top-left corner.
List<int> pebbleRing(int n) => [
  for (var c = 0; c < n - 1; c++) c,
  for (var r = 0; r < n - 1; r++) r * n + n - 1,
  for (var c = n - 1; c > 0; c--) (n - 1) * n + c,
  for (var r = n - 1; r > 0; r--) r * n,
];

/// Cells breaking a rule in [values] (-1 for an empty cell): four of a kind
/// in a 2×2 block, and on a full board stones cut off from the largest group
/// of their kind.
Set<int> pebblesConflicts(int n, List<int> values) {
  final bad = <int>{};
  for (final i in pebbleBlocks(n)) {
    final block = [i, i + 1, i + n, i + n + 1];
    final v = values[i];
    if (v >= 0 && block.every((j) => values[j] == v)) bad.addAll(block);
  }
  if (!values.contains(-1)) {
    final nb = orthNeighbors(n, n);
    for (final v in const [pebbleFilled, pebbleHollow]) {
      final parts = components(nb, (i) => values[i] == v)..sort((a, b) => a.length.compareTo(b.length));
      for (final p in parts.take(parts.length - 1)) {
        bad.addAll(p);
      }
    }
  }
  return bad;
}
