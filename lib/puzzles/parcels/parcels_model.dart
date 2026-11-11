import '../../core/grid.dart';
import '../../core/lattice_loop.dart';

/// The cells of every region on a [rows] × [cols] board.
int parcelsRegionSize(int rows, int cols) => rows * cols % 4 == 0 ? 4 : 5;

/// Where cells and their sides are on a corner lattice of (rows + 1) ×
/// (cols + 1) points: a side of a cell is an edge of the lattice.
class ParcelsGeo {
  ParcelsGeo._(this.rows, this.cols) : g = LatticeLoop(rows + 1, cols + 1) {
    final n = rows * cols;
    cellsOf = List.generate(g.edgeCount, (_) => (-1, -1));
    sides = List.generate(n, (_) => const <int>[]);
    links = List.generate(n, (_) => <(int, int)>[]);
    for (var r = 0; r < rows; r++) {
      for (var c = 0; c < cols; c++) {
        final i = r * cols + c;
        sides[i] = [g.h(r, c), g.h(r + 1, c), g.v(r, c), g.v(r, c + 1)];
        if (c + 1 < cols) {
          final e = g.v(r, c + 1);
          cellsOf[e] = (i, i + 1);
          links[i].add((i + 1, e));
          links[i + 1].add((i, e));
        }
        if (r + 1 < rows) {
          final e = g.h(r + 1, c);
          cellsOf[e] = (i, i + cols);
          links[i].add((i + cols, e));
          links[i + cols].add((i, e));
        }
      }
    }
    inner = [
      for (var e = 0; e < g.edgeCount; e++)
        if (cellsOf[e].$1 >= 0) e,
    ];
  }

  static final _cache = <int, ParcelsGeo>{};
  factory ParcelsGeo.of(int rows, int cols) => _cache[rows * 1000 + cols] ??= ParcelsGeo._(rows, cols);

  final int rows;
  final int cols;
  final LatticeLoop g;

  int get n => rows * cols;

  /// The two cells on either side of every edge, or (-1, -1) on the outline.
  late final List<(int, int)> cellsOf;

  /// Top, bottom, left and right side of every cell.
  late final List<List<int>> sides;

  /// Every cell's neighbours, with the edge between.
  late final List<List<(int, int)>> links;

  /// The edges between two cells (all but the outline).
  late final List<int> inner;

  bool isOutline(int e) => cellsOf[e].$1 < 0;

  /// Edge marks with the outline drawn (it is always a border).
  List<int> startMarks() => [for (var e = 0; e < g.edgeCount; e++) isOutline(e) ? 1 : 0];

  /// Groups of cells joined by edges that aren't borders ([border] per edge):
  /// the group of every cell, and the cells of every group.
  (List<int>, List<List<int>>) groups(bool Function(int e) border) {
    final of = List<int>.filled(n, -1);
    final all = <List<int>>[];
    for (var s = 0; s < n; s++) {
      if (of[s] >= 0) continue;
      final cells = [s];
      of[s] = all.length;
      for (var q = 0; q < cells.length; q++) {
        for (final (j, e) in links[cells[q]]) {
          if (of[j] < 0 && !border(e)) {
            of[j] = all.length;
            cells.add(j);
          }
        }
      }
      all.add(cells);
    }
    return (of, all);
  }
}

/// Divide the grid into regions of [k] cells each. A number tells how many
/// sides of its cell are borders (the outline counts).
class ParcelsPuzzle {
  const ParcelsPuzzle({
    required this.rows,
    required this.cols,
    required this.k,
    required this.clues,
    required this.regions,
  });

  final int rows;
  final int cols;

  /// Cells in every region.
  final int k;

  /// Per cell, null where there is no number.
  final List<int?> clues;

  /// Solution: the region of every cell.
  final List<int> regions;

  GridSize get size => GridSize(rows, cols);
  ParcelsGeo get geo => ParcelsGeo.of(rows, cols);
  LatticeLoop get lattice => geo.g;

  /// Solution borders, per lattice edge.
  List<bool> get borders => _borders[this] ??= [
    for (var e = 0; e < geo.g.edgeCount; e++)
      if (geo.cellsOf[e] case (final a, final b)) a < 0 || regions[a] != regions[b],
  ];
  static final _borders = Expando<List<bool>>();

  Map<String, dynamic> toJson() => {
    'rows': rows,
    'cols': cols,
    'k': k,
    'clues': [for (final c in clues) c ?? '.'].join(),
    'regions': regions,
  };

  factory ParcelsPuzzle.fromJson(Map<String, dynamic> j) => ParcelsPuzzle(
    rows: j['rows'] as int,
    cols: j['cols'] as int,
    k: j['k'] as int,
    clues: [for (final ch in (j['clues'] as String).split('')) ch == '.' ? null : int.parse(ch)],
    regions: (j['regions'] as List).cast<int>(),
  );
}

/// The border count of every cell in a layout of [regions].
List<int> parcelsCounts(ParcelsGeo geo, List<int> regions) => [
  for (var i = 0; i < geo.n; i++) 4 - geo.links[i].where((l) => regions[l.$1] == regions[i]).length,
];

/// Whether [marks] (1 border) split the board into regions of k cells, every
/// border between two regions and every number right.
bool parcelsSolved(ParcelsPuzzle p, List<int> marks) {
  final geo = p.geo;
  final (of, groups) = geo.groups((e) => marks[e] == 1);
  if (groups.any((g) => g.length != p.k)) return false;
  for (final e in geo.inner) {
    final (a, b) = geo.cellsOf[e];
    if (marks[e] == 1 && of[a] == of[b]) return false;
  }
  for (var i = 0; i < geo.n; i++) {
    if (p.clues[i] case final want? when geo.sides[i].where((e) => marks[e] == 1).length != want) return false;
  }
  return true;
}

/// Whether every region the borders make has k cells.
bool parcelsComplete(ParcelsPuzzle p, List<int> marks) =>
    p.geo.groups((e) => marks[e] == 1).$2.every((g) => g.length == p.k);

/// Cells that break a rule: numbers with too many borders (or too few once
/// every side is marked), areas closed off at the wrong size, pieces joined
/// by crosses that are too big, and borders inside such a piece.
Set<int> parcelsBad(ParcelsPuzzle p, List<int> marks) {
  final geo = p.geo;
  final bad = <int>{};
  for (var i = 0; i < geo.n; i++) {
    final want = p.clues[i];
    if (want == null) continue;
    final s = geo.sides[i];
    final b = s.where((e) => marks[e] == 1).length, x = s.where((e) => marks[e] == 2).length;
    if (b > want || 4 - x < want) bad.add(i);
  }
  for (final g in geo.groups((e) => marks[e] == 1).$2) {
    if (g.length < p.k || g.length % p.k != 0) bad.addAll(g);
  }
  final (of, joined) = geo.groups((e) => marks[e] != 2);
  for (final g in joined) {
    if (g.length > p.k) bad.addAll(g);
  }
  for (final e in geo.inner) {
    final (a, b) = geo.cellsOf[e];
    if (marks[e] == 1 && of[a] == of[b]) bad.addAll(joined[of[a]]);
  }
  return bad;
}
