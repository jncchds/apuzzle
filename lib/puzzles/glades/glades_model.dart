import '../../core/grid.dart';
import '../../core/grid_graph.dart';
import '../../core/value_grid.dart';

const int gladesShade = 0;
const int gladesKeep = 1;

/// Glades: shade some cells so that every unshaded area (cells joined side
/// by side) is a rectangle holding exactly one number, its count of cells.
/// No 2×2 block is all shaded, and the unshaded areas form one network when
/// corner touches count. Shaded cells need not be connected.
class GladesPuzzle implements ValueGridPuzzle {
  const GladesPuzzle({required this.n, required this.clues, required this.shaded});

  final int n;

  /// The number in each cell, null where there is none. Numbered cells are
  /// unshaded givens.
  final List<int?> clues;

  /// Solution.
  final List<bool> shaded;

  @override
  GridSize get size => GridSize.square(n);
  @override
  int? givenAt(int index) => clues[index] != null ? gladesKeep : null;
  @override
  int solutionAt(int index) => shaded[index] ? gladesShade : gladesKeep;

  int get shadedCount => shaded.where((x) => x).length;

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

  factory GladesPuzzle.fromJson(Map<String, dynamic> j) {
    final n = j['n'] as int;
    final shaded = List<bool>.filled(n * n, false);
    for (final i in (j['shaded'] as List).cast<int>()) {
      shaded[i] = true;
    }
    final clues = List<int?>.filled(n * n, null);
    for (final e in (j['clues'] as Map).entries) {
      clues[int.parse(e.key as String)] = e.value as int;
    }
    return GladesPuzzle(n: n, clues: clues, shaded: shaded);
  }
}

/// The bounding box of [cells] (flat indices on an n-wide grid) as
/// (x0, y0, x1, y1).
(int, int, int, int) gladesBox(int n, Iterable<int> cells) {
  var x0 = n, y0 = n, x1 = -1, y1 = -1;
  for (final i in cells) {
    final x = i % n, y = i ~/ n;
    if (x < x0) x0 = x;
    if (x > x1) x1 = x;
    if (y < y0) y0 = y;
    if (y > y1) y1 = y;
  }
  return (x0, y0, x1, y1);
}

/// Whether [cells] fill their bounding box.
bool gladesIsRect(int n, List<int> cells) {
  final (x0, y0, x1, y1) = gladesBox(n, cells);
  return (x1 - x0 + 1) * (y1 - y0 + 1) == cells.length;
}

/// The top-left cells of 2×2 blocks that are all shaded.
List<int> gladesPools(int n, List<bool> shaded) => [
  for (var y = 0; y + 1 < n; y++)
    for (var x = 0; x + 1 < n; x++)
      if (shaded[y * n + x] && shaded[y * n + x + 1] && shaded[y * n + x + n] && shaded[y * n + x + n + 1]) y * n + x,
];

/// Whether [shaded] solves [p].
bool gladesValid(GladesPuzzle p, List<bool> shaded) => gladesConflicts(p, shaded, complete: true).isEmpty;

/// Cells breaking a rule. With [complete], the board counts as finished
/// (cells not shaded are unshaded): every rule is checked, and of unshaded
/// cells cut apart, all but the biggest piece are flagged. Otherwise only
/// what filling more cells can't mend: all-shaded 2×2 blocks, and areas of
/// [kept] cells (numbers included) with two numbers, more cells than their
/// number, a shaded cell in the rectangle around them, or closed off by
/// shaded cells and the edge with a wrong size, shape or no number.
Set<int> gladesConflicts(GladesPuzzle p, List<bool> shaded, {List<bool>? kept, required bool complete}) {
  final n = p.n;
  final nb = orthNeighbors(n, n);
  final bad = <int>{};
  for (final i in gladesPools(n, shaded)) {
    bad.addAll([i, i + 1, i + n, i + n + 1]);
  }
  List<int> numsOf(List<int> area) => [
    for (final i in area)
      if (p.clues[i] != null) p.clues[i]!,
  ];
  if (complete) {
    final open = components(nb, (i) => !shaded[i]);
    for (final area in open) {
      final nums = numsOf(area);
      if (nums.length != 1 || nums.first != area.length || !gladesIsRect(n, area)) bad.addAll(area);
    }
    final pieces = components(kingNeighbors(n, n), (i) => !shaded[i]);
    if (pieces.length > 1) {
      pieces.sort((a, b) => b.length - a.length);
      for (final piece in pieces.skip(1)) {
        bad.addAll(piece);
      }
    }
    return bad;
  }
  final keep = [for (var i = 0; i < n * n; i++) !shaded[i] && (p.clues[i] != null || (kept != null && kept[i]))];
  for (final area in components(nb, (i) => keep[i])) {
    final nums = numsOf(area);
    var wrong = nums.toSet().length > 1 || (nums.isNotEmpty && nums.first < area.length);
    final (x0, y0, x1, y1) = gladesBox(n, area);
    for (var y = y0; y <= y1 && !wrong; y++) {
      for (var x = x0; x <= x1; x++) {
        if (shaded[y * n + x]) wrong = true;
      }
    }
    final closed = area.every((i) => nb[i].every((j) => shaded[j] || keep[j]));
    if (closed && (nums.length != 1 || nums.first != area.length || !gladesIsRect(n, area))) wrong = true;
    if (wrong) bad.addAll(area);
  }
  return bad;
}
