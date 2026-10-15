import '../../core/grid.dart';
import '../../core/grid_graph.dart';
import '../../core/value_grid.dart';

const int rampartShade = 0;
const int rampartKeep = 1;

/// Rampart: shade cells so they form one connected wall with no 2×2 block
/// of shaded cells. A clue cell stays unshaded and lists the lengths of the
/// runs of shaded cells among its eight neighbours, read round the clue.
class RampartPuzzle implements ValueGridPuzzle {
  const RampartPuzzle({required this.n, required this.clues, required this.shaded});

  final int n;

  /// The runs of each clue, longest first ([0] for none), null where there is no clue.
  final List<List<int>?> clues;

  /// Solution.
  final List<bool> shaded;

  @override
  GridSize get size => GridSize.square(n);
  @override
  int? givenAt(int index) => clues[index] != null ? rampartKeep : null;
  @override
  int solutionAt(int index) => shaded[index] ? rampartShade : rampartKeep;

  Map<String, dynamic> toJson() => {
    'n': n,
    'clues': {
      for (var i = 0; i < clues.length; i++)
        if (clues[i] != null) '$i': clues[i]!.join(' '),
    },
    'shaded': [
      for (var i = 0; i < shaded.length; i++)
        if (shaded[i]) i,
    ],
  };

  factory RampartPuzzle.fromJson(Map<String, dynamic> j) {
    final n = j['n'] as int;
    final shaded = List<bool>.filled(n * n, false);
    for (final i in (j['shaded'] as List).cast<int>()) {
      shaded[i] = true;
    }
    final clues = List<List<int>?>.filled(n * n, null);
    for (final e in (j['clues'] as Map).entries) {
      clues[int.parse(e.key as String)] = [for (final s in (e.value as String).split(' ')) int.parse(s)];
    }
    return RampartPuzzle(n: n, clues: clues, shaded: shaded);
  }
}

const _ringSteps = [(-1, -1), (-1, 0), (-1, 1), (0, 1), (1, 1), (1, 0), (1, -1), (0, -1)];
final _rings = <int, List<List<int>>>{};

/// The eight neighbours of each cell in order round it, starting top-left
/// (-1 off the board; cached per size). Cells next to each other in the
/// ring touch side by side.
List<List<int>> rampartRingOf(int n) => _rings[n] ??= [
  for (var i = 0; i < n * n; i++)
    [
      for (final (dy, dx) in _ringSteps)
        if (i ~/ n + dy case final y when y >= 0 && y < n && i % n + dx >= 0 && i % n + dx < n)
          y * n + i % n + dx
        else
          -1,
    ],
];

/// The runs of set bits of an 8-bit ring [mask], longest first ([0] for none).
List<int> rampartRuns(int mask) {
  if (mask == 0) return const [0];
  if (mask == 255) return const [8];
  var start = 0;
  while (mask >> start & 1 == 0 || mask >> (start + 7) % 8 & 1 == 1) {
    start++;
  }
  final runs = <int>[];
  var run = 0;
  for (var k = 0; k < 8; k++) {
    if (mask >> (start + k) % 8 & 1 == 1) {
      run++;
    } else if (run > 0) {
      runs.add(run);
      run = 0;
    }
  }
  if (run > 0) runs.add(run);
  return runs..sort((a, b) => b.compareTo(a));
}

final _runKeys = List<String>.generate(256, (m) => rampartRuns(m).join(' '));

/// The ring masks of cell [i] that make [clue] (bits off the board clear).
List<int> rampartMasks(int n, int i, List<int> clue) {
  final ring = rampartRingOf(n)[i];
  var off = 0;
  for (var b = 0; b < 8; b++) {
    if (ring[b] < 0) off |= 1 << b;
  }
  final key = clue.join(' ');
  return [
    for (var m = 0; m < 256; m++)
      if (m & off == 0 && _runKeys[m] == key) m,
  ];
}

/// The ring mask of the cells round [i] that [test] holds for.
int rampartRingMask(int n, int i, bool Function(int) test) {
  final ring = rampartRingOf(n)[i];
  var mask = 0;
  for (var b = 0; b < 8; b++) {
    if (ring[b] >= 0 && test(ring[b])) mask |= 1 << b;
  }
  return mask;
}

/// The top-left cells of the 2×2 blocks.
Iterable<int> rampartBlocks(int n) sync* {
  for (var y = 0; y + 1 < n; y++) {
    for (var x = 0; x + 1 < n; x++) {
      yield y * n + x;
    }
  }
}

/// Cells breaking a rule when [shaded] cells are shaded and [kept] ones stay
/// (by default every cell not shaded; clue cells always stay): shaded clue
/// cells, fully shaded 2×2 blocks, clues no way of finishing can make. With
/// [complete], shaded cells cut off from the largest part of the wall by
/// cells that stay too.
Set<int> rampartConflicts(RampartPuzzle p, List<bool> shaded, {List<bool>? kept, required bool complete}) {
  final n = p.n;
  final stays = [for (var i = 0; i < n * n; i++) p.clues[i] != null || (kept == null ? !shaded[i] : kept[i])];
  final bad = <int>{};
  for (var i = 0; i < n * n; i++) {
    if (shaded[i] && p.clues[i] != null) bad.add(i);
  }
  for (final i in rampartBlocks(n)) {
    final block = [i, i + 1, i + n, i + n + 1];
    if (block.every((j) => shaded[j])) bad.addAll(block);
  }
  for (var i = 0; i < n * n; i++) {
    final clue = p.clues[i];
    if (clue == null) continue;
    final sh = rampartRingMask(n, i, (j) => shaded[j]), kp = rampartRingMask(n, i, (j) => stays[j] && !shaded[j]);
    if (!rampartMasks(n, i, clue).any((m) => m & sh == sh && m & kp == 0)) bad.add(i);
  }
  if (complete) {
    // Shaded cells that can't reach each other through cells that may still be shaded.
    final parts = [
      for (final part in components(orthNeighbors(n, n), (i) => shaded[i] || !stays[i]))
        [
          for (final i in part)
            if (shaded[i]) i,
        ],
    ].where((part) => part.isNotEmpty).toList()..sort((a, b) => a.length.compareTo(b.length));
    for (var k = 0; k + 1 < parts.length; k++) {
      bad.addAll(parts[k]);
    }
  }
  return bad;
}
