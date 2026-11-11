import '../../core/grid.dart';
import '../../core/grid_graph.dart';
import '../../core/value_grid.dart';
import '../inlay/inlay_model.dart' show Cell, cellsKey, orientCells;

const int quarryShade = 0;
const int quarryKeep = 1;

/// Explain texts name a stone with [valTok] of this plus its index; the chip
/// draws its shape.
const quarryPieceToken = 100;

/// One stone of the set: a letter (for code and tests) and its cells.
class QuarryShape {
  const QuarryShape(this.letter, this.rows);

  final String letter;

  /// The shape row by row, `#` for a cell.
  final List<String> rows;

  List<Cell> get cells => [
    for (var r = 0; r < rows.length; r++)
      for (var c = 0; c < rows[r].length; c++)
        if (rows[r][c] == '#') (r, c),
  ];

  int get size => cells.length;
}

/// Every stone a board may use: trominoes, tetrominoes and pentominoes.
/// Puzzles keep indices into this list, so it only ever grows at the end.
const quarryShapes = [
  QuarryShape('I', ['###']),
  QuarryShape('V', ['##', '#.']),
  QuarryShape('I', ['####']),
  QuarryShape('O', ['##', '##']),
  QuarryShape('T', ['###', '.#.']),
  QuarryShape('S', ['.##', '##.']),
  QuarryShape('L', ['###', '#..']),
  QuarryShape('F', ['.##', '##.', '.#.']),
  QuarryShape('I', ['#####']),
  QuarryShape('L', ['####', '#...']),
  QuarryShape('N', ['##..', '.###']),
  QuarryShape('P', ['###', '##.']),
  QuarryShape('T', ['###', '.#.', '.#.']),
  QuarryShape('U', ['#.#', '###']),
  QuarryShape('V', ['###', '#..', '#..']),
  QuarryShape('W', ['#..', '##.', '.##']),
  QuarryShape('X', ['.#.', '###', '.#.']),
  QuarryShape('Y', ['####', '.#..']),
  QuarryShape('Z', ['##.', '.#.', '.##']),
];

final _keys = <String, String>{};

/// The same key for [cells] in any position, turn or mirror image.
String quarryShapeKey(List<Cell> cells) {
  final raw = cellsKey(orientCells(cells, 0));
  return _keys[raw] ??= ([for (var o = 0; o < 8; o++) cellsKey(orientCells(cells, o))]..sort()).first;
}

/// The distinct orientations of [cells] (1 to 8), each from (0, 0).
List<List<Cell>> quarryOrientations(List<Cell> cells) {
  final seen = <String>{};
  return [
    for (var o = 0; o < 8; o++)
      if (seen.add(cellsKey(orientCells(cells, o)))) orientCells(cells, o),
  ];
}

/// How a stone is drawn in the tray and in texts: no taller than wide.
List<Cell> quarryShown(int shape) {
  final options = [
    for (final o in quarryOrientations(quarryShapes[shape].cells))
      if (_height(o) <= _width(o)) o,
  ]..sort((a, b) => cellsKey(a).compareTo(cellsKey(b)));
  return options.first;
}

int _width(List<Cell> cells) => cells.fold(0, (m, c) => c.$2 + 1 > m ? c.$2 + 1 : m);
int _height(List<Cell> cells) => cells.fold(0, (m, c) => c.$1 + 1 > m ? c.$1 + 1 : m);

/// (rows, columns) of [cells]' bounding box.
(int, int) quarryExtent(List<Cell> cells) => (_height(cells), _width(cells));

/// Quarry: cut every stone of the set out of the grid as shaded cells, each
/// once, turned or mirrored freely. Stones never touch along a side
/// (corners are fine), filled circles are stone, hollow circles stay, and
/// the cells left form one area.
class QuarryPuzzle implements ValueGridPuzzle {
  const QuarryPuzzle({required this.n, required this.pieces, required this.clues, required this.shaded});

  final int n;

  /// The stones, as indices into [quarryShapes] (no shape twice), biggest
  /// first.
  final List<int> pieces;

  /// [quarryShade] for a filled circle, [quarryKeep] for a hollow one, null
  /// for none. Circles are givens.
  final List<int?> clues;

  /// Solution.
  final List<bool> shaded;

  @override
  GridSize get size => GridSize.square(n);
  @override
  int? givenAt(int index) => clues[index];
  @override
  int solutionAt(int index) => shaded[index] ? quarryShade : quarryKeep;

  int get shadedCount => pieces.fold(0, (s, k) => s + quarryShapes[k].size);

  int get maxPiece => pieces.fold(0, (s, k) => quarryShapes[k].size > s ? quarryShapes[k].size : s);

  Map<String, dynamic> toJson() => {
    'n': n,
    'pieces': pieces,
    'clues': {
      for (var i = 0; i < clues.length; i++)
        if (clues[i] != null) '$i': clues[i],
    },
    'shaded': [
      for (var i = 0; i < shaded.length; i++)
        if (shaded[i]) i,
    ],
  };

  factory QuarryPuzzle.fromJson(Map<String, dynamic> j) {
    final n = j['n'] as int;
    final shaded = List<bool>.filled(n * n, false);
    for (final i in (j['shaded'] as List).cast<int>()) {
      shaded[i] = true;
    }
    final clues = List<int?>.filled(n * n, null);
    for (final e in (j['clues'] as Map).entries) {
      clues[int.parse(e.key as String)] = e.value as int;
    }
    return QuarryPuzzle(n: n, pieces: (j['pieces'] as List).cast<int>(), clues: clues, shaded: shaded);
  }
}

/// [area] (flat indices on an n-wide grid) as piece cells.
List<Cell> quarryCellsOf(int n, List<int> area) => [for (final i in area) (i ~/ n, i % n)];

/// The stone of [p] whose shape [area] has, or -1.
int quarryPieceOf(QuarryPuzzle p, List<int> area) {
  if (area.length > p.maxPiece) return -1;
  final key = quarryShapeKey(quarryCellsOf(p.n, area));
  for (var k = 0; k < p.pieces.length; k++) {
    if (quarryShapes[p.pieces[k]].size == area.length && quarryShapeKey(quarryShapes[p.pieces[k]].cells) == key) {
      return k;
    }
  }
  return -1;
}

/// Whether some turn or mirror image of [big] holds the shape [small].
bool quarryContains(List<Cell> big, List<Cell> small) {
  final (r0, c0) = small.first;
  for (final o in quarryOrientations(big)) {
    final cells = o.toSet();
    for (final (r, c) in o) {
      if (small.every((s) => cells.contains((s.$1 - r0 + r, s.$2 - c0 + c)))) return true;
    }
  }
  return false;
}

/// The stone of [p] that the shaded [area] surely is, or -1: it has that
/// shape, and either no bigger stone of the set holds the shape or [closed]
/// (no cell beside it can still be shaded).
int quarryFinished(QuarryPuzzle p, List<int> area, {required bool closed}) {
  final k = quarryPieceOf(p, area);
  if (k < 0 || closed) return k;
  final cells = quarryCellsOf(p.n, area);
  for (final other in p.pieces) {
    if (quarryShapes[other].size > area.length && quarryContains(quarryShapes[other].cells, cells)) return -1;
  }
  return k;
}

/// Whether [shaded] solves [p].
bool quarryValid(QuarryPuzzle p, List<bool> shaded) {
  if (quarryConflicts(p, shaded, complete: true).isNotEmpty) return false;
  final nb = orthNeighbors(p.n, p.n);
  final groups = components(nb, (i) => shaded[i]);
  if (groups.length != p.pieces.length) return false;
  for (var i = 0; i < shaded.length; i++) {
    if (p.clues[i] != null && (p.clues[i] == quarryShade) != shaded[i]) return false;
  }
  return true;
}

/// Cells breaking a rule. With [complete], the board counts as finished
/// (cells not shaded stay): shaded areas that aren't a stone of the set, or
/// a stone used twice, and of the cells left cut apart, all but the biggest
/// piece. Otherwise only what more cells can't mend: shaded areas bigger
/// than every stone, and shaded areas closed off by [kept] cells and the
/// edge that aren't a stone, or a stone used twice.
Set<int> quarryConflicts(QuarryPuzzle p, List<bool> shaded, {List<bool>? kept, required bool complete}) {
  final n = p.n;
  final nb = orthNeighbors(n, n);
  final bad = <int>{};
  final used = <int>{};
  for (final g in components(nb, (i) => shaded[i])) {
    if (g.length > p.maxPiece) {
      bad.addAll(g);
      continue;
    }
    final closed =
        complete || g.every((i) => nb[i].every((j) => shaded[j] || kept?[j] == true || p.clues[j] == quarryKeep));
    if (!closed) continue;
    final k = quarryPieceOf(p, g);
    if (k < 0 || !used.add(k)) bad.addAll(g);
  }
  if (complete) {
    final open = components(nb, (i) => !shaded[i]);
    if (open.length > 1) {
      open.sort((a, b) => b.length - a.length);
      for (final piece in open.skip(1)) {
        bad.addAll(piece);
      }
    }
  }
  return bad;
}
