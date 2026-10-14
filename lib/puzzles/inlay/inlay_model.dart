import '../../core/grid.dart';

/// A cell of a piece: row and column inside the piece's bounding box.
typedef Cell = (int, int);

/// [cells] turned by orientation [o]: mirrored left to right first if
/// o ≥ 4, then turned a quarter clockwise o % 4 times, moved so the bounding
/// box starts at (0, 0). Cells keep their order, so cell k of one
/// orientation is cell k of any other.
List<Cell> orientCells(List<Cell> cells, int o) {
  var out = [for (final (r, c) in cells) o >= 4 ? (r, -c) : (r, c)];
  for (var k = 0; k < o % 4; k++) {
    out = [for (final (r, c) in out) (c, -r)];
  }
  var r0 = 1 << 20, c0 = 1 << 20;
  for (final (r, c) in out) {
    if (r < r0) r0 = r;
    if (c < c0) c0 = c;
  }
  return [for (final (r, c) in out) (r - r0, c - c0)];
}

/// The orientation shown after a quarter turn clockwise of [o].
int turnOrientation(int o) => (o % 4 + 1) % 4 + (o & 4);

/// The orientation shown after mirroring [o] left to right.
int flipOrientation(int o) => (4 - o % 4) % 4 + (o >= 4 ? 0 : 4);

/// [cells] as a sorted key, the same for equal sets in any order.
String cellsKey(List<Cell> cells) {
  final keys = [for (final (r, c) in cells) r * 16 + c]..sort();
  return keys.join(',');
}

/// A target shape of cells inside a [rows] × [cols] grid ([shape], holes and
/// the outside are false) and the [pieces] (polyominoes, as shown in the tray
/// at the start) whose cells add up to it. Any way to cover the shape
/// exactly with all pieces wins. Mirroring pieces is allowed only if [flip].
/// [solution] is one cover: an orientation and a top-left cell per piece.
class InlayPuzzle {
  InlayPuzzle({
    required this.rows,
    required this.cols,
    required this.shape,
    required this.pieces,
    required this.flip,
    required this.solution,
  });

  final int rows;
  final int cols;
  final List<bool> shape;
  final List<List<Cell>> pieces;
  final bool flip;
  final List<(int, int)> solution;

  GridSize get size => GridSize(rows, cols);
  int get cells => rows * cols;
  late final int area = shape.where((x) => x).length;

  /// The orientations a piece may take (8 if [flip], else the 4 turns).
  int get orientations => flip ? 8 : 4;

  late final List<List<List<Cell>>> _oriented = [
    for (final p in pieces) [for (var o = 0; o < 8; o++) orientCells(p, o)],
  ];

  /// Piece [piece]'s cells in orientation [o].
  List<Cell> cellsOf(int piece, int o) => _oriented[piece][o];

  /// Rows and columns piece [piece] spans in orientation [o].
  (int, int) extent(int piece, int o) {
    var h = 0, w = 0;
    for (final (r, c) in cellsOf(piece, o)) {
      if (r + 1 > h) h = r + 1;
      if (c + 1 > w) w = c + 1;
    }
    return (h, w);
  }

  /// Grid cells covered by [piece] in orientation [o] with its bounding box
  /// at row [r], column [c], or null if a cell falls off the grid.
  List<int>? cover(int piece, int o, int r, int c) {
    final out = <int>[];
    for (final (dr, dc) in cellsOf(piece, o)) {
      final rr = r + dr, cc = c + dc;
      if (rr < 0 || cc < 0 || rr >= rows || cc >= cols) return null;
      out.add(rr * cols + cc);
    }
    return out;
  }

  Map<String, dynamic> toJson() => {
    'rows': rows,
    'cols': cols,
    'shape': [for (var r = 0; r < rows; r++) List.generate(cols, (c) => shape[r * cols + c] ? '#' : '.').join()],
    'pieces': [
      for (final p in pieces) [for (final (r, c) in p) r * 8 + c],
    ],
    'flip': flip,
    'solution': [
      for (final (o, at) in solution) [o, at],
    ],
  };

  factory InlayPuzzle.fromJson(Map<String, dynamic> j) => InlayPuzzle(
    rows: j['rows'] as int,
    cols: j['cols'] as int,
    shape: [
      for (final row in (j['shape'] as List).cast<String>())
        for (final ch in row.split('')) ch == '#',
    ],
    pieces: [
      for (final p in j['pieces'] as List) [for (final k in (p as List).cast<int>()) (k ~/ 8, k % 8)],
    ],
    flip: j['flip'] as bool,
    solution: [
      for (final s in j['solution'] as List) ((s as List)[0] as int, s[1] as int),
    ],
  );
}

/// Where every piece is: its orientation, and the grid cell of its bounding
/// box's top-left corner, or -1 while it waits in the tray.
class InlayState {
  const InlayState(this.orient, this.at);

  final List<int> orient;
  final List<int> at;

  bool placed(int piece) => at[piece] >= 0;

  InlayState withPiece(int piece, {int? orient, int? at}) => InlayState(
    [for (var i = 0; i < this.orient.length; i++) i == piece ? (orient ?? this.orient[i]) : this.orient[i]],
    [for (var i = 0; i < this.at.length; i++) i == piece ? (at ?? this.at[i]) : this.at[i]],
  );

  Map<String, dynamic> toJson() => {'o': orient, 'at': at};
  factory InlayState.fromJson(Map<String, dynamic> j) =>
      InlayState((j['o'] as List).cast<int>(), (j['at'] as List).cast<int>());
}

/// Grid cells piece [piece] covers in [s] (empty while in the tray).
List<int> pieceCells(InlayPuzzle p, InlayState s, int piece) {
  if (!s.placed(piece)) return const [];
  return p.cover(piece, s.orient[piece], s.at[piece] ~/ p.cols, s.at[piece] % p.cols) ?? const [];
}

/// The piece on every grid cell, or -1.
List<int> inlayOwners(InlayPuzzle p, InlayState s) {
  final owner = List.filled(p.cells, -1);
  for (var k = 0; k < p.pieces.length; k++) {
    for (final i in pieceCells(p, s, k)) {
      owner[i] = k;
    }
  }
  return owner;
}

/// Whether [piece] fits in orientation [o] at row [r], column [c]: every
/// cell on the shape, none on another piece of [s].
bool inlayFits(InlayPuzzle p, InlayState s, int piece, int o, int r, int c, {List<int>? owners}) {
  final cells = p.cover(piece, o, r, c);
  if (cells == null) return false;
  final owner = owners ?? inlayOwners(p, s);
  for (final i in cells) {
    if (!p.shape[i] || owner[i] != -1 && owner[i] != piece) return false;
  }
  return true;
}

/// Every piece on the board in an allowed orientation, together covering
/// the shape exactly.
bool inlaySolved(InlayPuzzle p, InlayState s) {
  final seen = List.filled(p.cells, false);
  for (var k = 0; k < p.pieces.length; k++) {
    if (!s.placed(k) || s.orient[k] >= p.orientations) return false;
    final cells = p.cover(k, s.orient[k], s.at[k] ~/ p.cols, s.at[k] % p.cols);
    if (cells == null) return false;
    for (final i in cells) {
      if (!p.shape[i] || seen[i]) return false;
      seen[i] = true;
    }
  }
  for (var i = 0; i < p.cells; i++) {
    if (p.shape[i] != seen[i]) return false;
  }
  return true;
}
