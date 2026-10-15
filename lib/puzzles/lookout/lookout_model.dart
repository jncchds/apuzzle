import '../../core/grid.dart';
import '../../core/grid_graph.dart';
import '../../core/value_grid.dart';

const int lookoutShade = 0;
const int lookoutKeep = 1;

/// Lookout: shade some cells so that every number sees that many cells in
/// its row and column, itself included, up to the shaded cells or the
/// edge. Numbered cells stay, shaded cells never touch side by side, and
/// the cells left form one area.
class LookoutPuzzle implements ValueGridPuzzle {
  const LookoutPuzzle({required this.n, required this.clues, required this.shaded});

  final int n;

  /// The number in each cell, null where there is none.
  final List<int?> clues;

  /// Solution.
  final List<bool> shaded;

  @override
  GridSize get size => GridSize.square(n);
  @override
  int? givenAt(int index) => clues[index] != null ? lookoutKeep : null;
  @override
  int solutionAt(int index) => shaded[index] ? lookoutShade : lookoutKeep;

  Map<String, dynamic> toJson() => {
    'n': n,
    'clues': {
      for (var i = 0; i < clues.length; i++)
        if (clues[i] != null) '$i': clues[i],
    },
    'shaded': [
      for (var i = 0; i < shaded.length; i++)
        if (shaded[i]) i,
    ],
  };

  factory LookoutPuzzle.fromJson(Map<String, dynamic> j) {
    final n = j['n'] as int;
    final shaded = List<bool>.filled(n * n, false);
    for (final i in (j['shaded'] as List).cast<int>()) {
      shaded[i] = true;
    }
    final clues = List<int?>.filled(n * n, null);
    for (final e in (j['clues'] as Map).entries) {
      clues[int.parse(e.key as String)] = e.value as int;
    }
    return LookoutPuzzle(n: n, clues: clues, shaded: shaded);
  }
}

final _rays = <int, List<List<List<int>>>>{};

/// The cells each cell looks along, nearest first: up, right, down, left
/// (cached per size).
List<List<List<int>>> lookoutRaysOf(int n) => _rays[n] ??= [
  for (var i = 0; i < n * n; i++)
    [
      [for (var y = i ~/ n - 1; y >= 0; y--) y * n + i % n],
      [for (var x = i % n + 1; x < n; x++) i ~/ n * n + x],
      [for (var y = i ~/ n + 1; y < n; y++) y * n + i % n],
      [for (var x = i % n - 1; x >= 0; x--) i ~/ n * n + x],
    ],
];

/// The cells [i] sees, itself included, when [open] says which cells let the view through.
int lookoutSeen(int n, int i, bool Function(int) open) {
  var seen = 1;
  for (final ray in lookoutRaysOf(n)[i]) {
    for (final j in ray) {
      if (!open(j)) break;
      seen++;
    }
  }
  return seen;
}

/// Cells breaking a rule when [shaded] cells are shaded and [kept] ones stay
/// (by default every cell not shaded; numbers always stay): shaded cells
/// touching or on a number, numbers that see too many cells for sure or
/// can't see enough. With [complete], cells cut off from the largest
/// unshaded area too.
Set<int> lookoutConflicts(LookoutPuzzle p, List<bool> shaded, {List<bool>? kept, required bool complete}) {
  final n = p.n;
  final stays = [for (var i = 0; i < n * n; i++) p.clues[i] != null || (kept == null ? !shaded[i] : kept[i])];
  final bad = <int>{};
  final nb = orthNeighbors(n, n);
  for (var i = 0; i < n * n; i++) {
    if (!shaded[i]) continue;
    if (p.clues[i] != null) bad.add(i);
    for (final j in nb[i]) {
      if (shaded[j]) bad.add(i);
    }
  }
  for (var i = 0; i < n * n; i++) {
    final want = p.clues[i];
    if (want == null) continue;
    if (lookoutSeen(n, i, (j) => stays[j]) > want || lookoutSeen(n, i, (j) => !shaded[j]) < want) bad.add(i);
  }
  if (complete) {
    final parts = components(nb, (i) => !shaded[i])..sort((a, b) => a.length.compareTo(b.length));
    for (final part in parts.take(parts.length - 1)) {
      bad.addAll(part);
    }
  }
  return bad;
}
