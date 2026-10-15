import '../../core/grid.dart';
import '../../core/grid_graph.dart';
import '../../core/value_grid.dart';

const int chambersShade = 0;
const int chambersKeep = 1;

/// A rectangular room: top-left cell and size.
class ChambersRoom {
  const ChambersRoom(this.r, this.c, this.h, this.w);

  final int r, c, h, w;

  int get area => h * w;

  List<int> cells(int n) => [
    for (var y = r; y < r + h; y++)
      for (var x = c; x < c + w; x++) y * n + x,
  ];

  List<int> toJson() => [r, c, h, w];
}

/// Chambers: the grid is cut into rectangular rooms. Shade some cells so
/// that a room with a number holds that many shaded cells, shaded cells
/// never touch side by side, the cells left form one area, and no straight
/// run of cells left crosses two room borders.
class ChambersPuzzle implements ValueGridPuzzle {
  ChambersPuzzle({
    required this.n,
    required this.rooms,
    required this.clues,
    required this.shaded,
    this.givens = const [],
  }) : roomOf = chambersRoomOf(n, rooms);

  final int n;
  final List<ChambersRoom> rooms;

  /// Shaded cells per room, null where the room shows no number.
  final List<int?> clues;

  /// Solution.
  final List<bool> shaded;

  /// Cells shown from the start (where the logic needed help).
  final List<int> givens;

  /// Room index per cell.
  final List<int> roomOf;

  @override
  GridSize get size => GridSize.square(n);
  @override
  int? givenAt(int index) => givens.contains(index) ? solutionAt(index) : null;
  @override
  int solutionAt(int index) => shaded[index] ? chambersShade : chambersKeep;

  Map<String, dynamic> toJson() => {
    'n': n,
    'rooms': [for (final r in rooms) r.toJson()],
    'clues': clues,
    'shaded': [
      for (var i = 0; i < shaded.length; i++)
        if (shaded[i]) i,
    ],
    if (givens.isNotEmpty) 'given': givens,
  };

  factory ChambersPuzzle.fromJson(Map<String, dynamic> j) {
    final n = j['n'] as int;
    final shaded = List<bool>.filled(n * n, false);
    for (final i in (j['shaded'] as List).cast<int>()) {
      shaded[i] = true;
    }
    return ChambersPuzzle(
      n: n,
      rooms: [
        for (final r in (j['rooms'] as List).cast<List>())
          ChambersRoom(r[0] as int, r[1] as int, r[2] as int, r[3] as int),
      ],
      clues: (j['clues'] as List).cast<int?>(),
      shaded: shaded,
      givens: ((j['given'] as List?) ?? const []).cast<int>(),
    );
  }
}

List<int> chambersRoomOf(int n, List<ChambersRoom> rooms) {
  final of = List<int>.filled(n * n, -1);
  for (var k = 0; k < rooms.length; k++) {
    for (final i in rooms[k].cells(n)) {
      of[i] = k;
    }
  }
  return of;
}

/// The shortest straight runs that cross two room borders: from the last
/// cell before one border to the first cell after the next one in the same
/// row or column. Each needs a shaded cell.
List<List<int>> chambersSpans(int n, List<int> roomOf) {
  final spans = <List<int>>[];
  for (var line = 0; line < 2 * n; line++) {
    final cells = [for (var k = 0; k < n; k++) line < n ? line * n + k : k * n + line - n];
    // Border b lies between cells b - 1 and b.
    final borders = [
      for (var b = 1; b < n; b++)
        if (roomOf[cells[b - 1]] != roomOf[cells[b]]) b,
    ];
    for (var k = 0; k + 1 < borders.length; k++) {
      spans.add(cells.sublist(borders[k] - 1, borders[k + 1] + 1));
    }
  }
  return spans;
}

/// Cells breaking a rule when [shaded] cells are shaded and [kept] ones stay
/// (by default every cell not shaded): shaded cells touching, rooms with
/// more shaded cells than their number (or too few cells left for it), and
/// runs of kept cells across two room borders. With [complete], cells cut
/// off from the largest unshaded area too.
Set<int> chambersConflicts(ChambersPuzzle p, List<bool> shaded, {List<bool>? kept, required bool complete}) {
  final n = p.n;
  final stays = kept ?? [for (final s in shaded) !s];
  final bad = <int>{};
  final nb = orthNeighbors(n, n);
  for (var i = 0; i < n * n; i++) {
    if (!shaded[i]) continue;
    for (final j in nb[i]) {
      if (shaded[j]) bad.add(i);
    }
  }
  for (var k = 0; k < p.rooms.length; k++) {
    final want = p.clues[k];
    if (want == null) continue;
    final cells = p.rooms[k].cells(n);
    final dark = cells.where((i) => shaded[i]).toList();
    final light = cells.where((i) => stays[i]).toList();
    if (dark.length > want) bad.addAll(dark);
    if (light.length > cells.length - want) bad.addAll(light);
  }
  for (final span in chambersSpans(n, p.roomOf)) {
    if (span.every((i) => stays[i])) bad.addAll(span);
  }
  if (complete) {
    final parts = components(nb, (i) => !shaded[i])..sort((a, b) => a.length.compareTo(b.length));
    for (final part in parts.take(parts.length - 1)) {
      bad.addAll(part);
    }
  }
  return bad;
}
