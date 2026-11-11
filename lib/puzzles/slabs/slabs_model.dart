import '../../core/grid.dart';
import '../../core/grid_graph.dart';
import '../../core/value_grid.dart';

const int slabsShade = 0;
const int slabsKeep = 1;

/// Slabs: shade some cells so that every shaded area (cells joined side by
/// side) is a rectangle and every unshaded area is not. A number tells how
/// many cells the area holding it has, shaded or not.
class SlabsPuzzle implements ValueGridPuzzle {
  const SlabsPuzzle({required this.n, required this.clues, required this.shaded});

  final int n;

  /// The number in each cell, null where there is none.
  final List<int?> clues;

  /// Solution.
  final List<bool> shaded;

  @override
  GridSize get size => GridSize.square(n);
  @override
  int? givenAt(int index) => null;
  @override
  int solutionAt(int index) => shaded[index] ? slabsShade : slabsKeep;

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

  factory SlabsPuzzle.fromJson(Map<String, dynamic> j) {
    final n = j['n'] as int;
    final shaded = List<bool>.filled(n * n, false);
    for (final i in (j['shaded'] as List).cast<int>()) {
      shaded[i] = true;
    }
    final clues = List<int?>.filled(n * n, null);
    for (final e in (j['clues'] as Map).entries) {
      clues[int.parse(e.key as String)] = e.value as int;
    }
    return SlabsPuzzle(n: n, clues: clues, shaded: shaded);
  }
}

/// Whether [cells] (flat indices on an n-wide grid) fill their bounding box.
bool slabsIsRect(int n, List<int> cells) {
  var x0 = n, y0 = n, x1 = -1, y1 = -1;
  for (final i in cells) {
    final x = i % n, y = i ~/ n;
    if (x < x0) x0 = x;
    if (x > x1) x1 = x;
    if (y < y0) y0 = y;
    if (y > y1) y1 = y;
  }
  return (x1 - x0 + 1) * (y1 - y0 + 1) == cells.length;
}

/// The areas of a shading: cells joined side by side with the same shade.
List<List<int>> slabsAreas(int n, List<bool> shaded) {
  final nb = orthNeighbors(n, n);
  return [
    ...components(nb, (i) => shaded[i]),
    ...components(nb, (i) => !shaded[i]),
  ];
}

/// Whether [shaded] solves [p]: shaded areas are rectangles, unshaded ones
/// are not, and every number counts its area.
bool slabsValid(SlabsPuzzle p, List<bool> shaded) => slabsConflicts(p, shaded, complete: true).isEmpty;

/// Cells breaking a rule. With [complete], the board counts as finished
/// (cells not shaded are unshaded): every area is checked. Otherwise only
/// what can't be undone by filling more cells: shaded areas with two
/// numbers or more cells than their number, shaded cells whose rectangle
/// would take in a [kept] cell, and areas closed off by [kept] cells and
/// the edge that break a rule.
Set<int> slabsConflicts(SlabsPuzzle p, List<bool> shaded, {List<bool>? kept, required bool complete}) {
  final n = p.n;
  final nb = orthNeighbors(n, n);
  final bad = <int>{};
  bool wrongCount(List<int> area) {
    final nums = {
      for (final i in area)
        if (p.clues[i] != null) p.clues[i]!,
    };
    return nums.length > 1 || (nums.length == 1 && nums.first < area.length);
  }

  bool wrongExact(List<int> area) => area.any((i) => p.clues[i] != null && p.clues[i] != area.length);

  if (complete) {
    for (final area in components(nb, (i) => shaded[i])) {
      if (wrongExact(area) || !slabsIsRect(n, area)) bad.addAll(area);
    }
    for (final area in components(nb, (i) => !shaded[i])) {
      if (wrongExact(area) || slabsIsRect(n, area)) bad.addAll(area);
    }
    return bad;
  }
  final keep = kept ?? List<bool>.filled(n * n, false);
  for (final area in components(nb, (i) => shaded[i])) {
    final closed = area.every((i) => nb[i].every((j) => shaded[j] || keep[j]));
    if (wrongCount(area) || (closed && (wrongExact(area) || !slabsIsRect(n, area)))) {
      bad.addAll(area);
      continue;
    }
    // The rectangle round the area must hold no kept cell.
    var x0 = n, y0 = n, x1 = -1, y1 = -1;
    for (final i in area) {
      final x = i % n, y = i ~/ n;
      if (x < x0) x0 = x;
      if (x > x1) x1 = x;
      if (y < y0) y0 = y;
      if (y > y1) y1 = y;
    }
    for (var y = y0; y <= y1; y++) {
      for (var x = x0; x <= x1; x++) {
        if (keep[y * n + x]) bad.addAll(area);
      }
    }
  }
  for (final area in components(nb, (i) => keep[i])) {
    final closed = area.every((i) => nb[i].every((j) => shaded[j] || keep[j]));
    if (wrongCount(area) || (closed && (wrongExact(area) || slabsIsRect(n, area)))) bad.addAll(area);
  }
  return bad;
}
