import '../../core/grid.dart';

/// Gap moves as letters: the gap goes up, down, left or right (the tile
/// there slides the other way). Plans and paths are strings of them.
const glideDirs = 'udlr';

/// A frame of numbered tiles 1..n−1 and one gap (0): slide tiles into the gap
/// until they read 1, 2, 3, … row by row with the gap at the end.
class GlidePuzzle {
  const GlidePuzzle({
    required this.rows,
    required this.cols,
    required this.start,
    required this.plan,
    this.optimal = false,
    this.limit,
    this.colors = false,
  });

  final int rows;
  final int cols;

  /// Tile per cell, 0 for the gap.
  final List<int> start;

  /// The shortest way out known (gap moves); the fewest when [optimal].
  final String plan;
  final bool optimal;

  /// Most moves allowed, or null for no limit.
  final int? limit;

  /// Tiles show a color gradient instead of numbers.
  final bool colors;

  GridSize get size => GridSize(rows, cols);
  int get best => plan.length;

  Map<String, dynamic> toJson() => {
    'rows': rows,
    'cols': cols,
    'start': start,
    'plan': plan,
    if (optimal) 'optimal': true,
    if (limit != null) 'limit': limit,
    if (colors) 'colors': true,
  };
  factory GlidePuzzle.fromJson(Map<String, dynamic> j) => GlidePuzzle(
    rows: j['rows'] as int,
    cols: j['cols'] as int,
    start: (j['start'] as List).cast<int>(),
    plan: j['plan'] as String,
    optimal: j['optimal'] as bool? ?? false,
    limit: j['limit'] as int?,
    colors: j['colors'] as bool? ?? false,
  );
}

/// The tiles and the gap moves made so far (one per tile moved).
class GlideState {
  const GlideState(this.tiles, this.path);

  final List<int> tiles;
  final String path;

  factory GlideState.initial(GlidePuzzle p) => GlideState(p.start, '');

  int get moves => path.length;
  int get gap => tiles.indexOf(0);
  bool get sorted => glideSorted(tiles);

  Map<String, dynamic> toJson() => {'tiles': tiles, 'path': path};
  factory GlideState.fromJson(Map<String, dynamic> j) =>
      GlideState((j['tiles'] as List).cast<int>(), j['path'] as String);
}

bool glideSorted(List<int> tiles) {
  for (var i = 0; i < tiles.length - 1; i++) {
    if (tiles[i] != i + 1) return false;
  }
  return true;
}

/// The cell next to [cell] in gap direction [d], or -1 off the board.
int glideStep(int rows, int cols, int cell, String d) {
  final r = cell ~/ cols, c = cell % cols;
  return switch (d) {
    'u' => r > 0 ? cell - cols : -1,
    'd' => r < rows - 1 ? cell + cols : -1,
    'l' => c > 0 ? cell - 1 : -1,
    _ => c < cols - 1 ? cell + 1 : -1,
  };
}

String glideOpposite(String d) => switch (d) {
  'u' => 'd',
  'd' => 'u',
  'l' => 'r',
  _ => 'l',
};

/// [tiles] after the gap moves [moves] (a move off the board is an error).
List<int> glideApply(int rows, int cols, List<int> tiles, String moves) {
  final t = List.of(tiles);
  var g = t.indexOf(0);
  for (var k = 0; k < moves.length; k++) {
    final n = glideStep(rows, cols, g, moves[k]);
    if (n < 0) throw ArgumentError('gap leaves the board');
    t[g] = t[n];
    t[n] = 0;
    g = n;
  }
  return t;
}

/// The moves that undo [moves].
String glideReverse(String moves) => [for (var k = moves.length - 1; k >= 0; k--) glideOpposite(moves[k])].join();

/// [moves] without moves that the next one takes straight back.
String glideCancel(String moves) {
  final out = <String>[];
  for (var k = 0; k < moves.length; k++) {
    if (out.isNotEmpty && out.last == glideOpposite(moves[k])) {
      out.removeLast();
    } else {
      out.add(moves[k]);
    }
  }
  return out.join();
}

/// Whether [tiles] can be slid into order: the inversions of the tiles, plus
/// on boards of even width the gap's rows above the bottom, must be even
/// (a sideways move keeps both, a move up or down changes both by an odd
/// number on even widths, by an even one on odd widths).
bool glideSolvable(int rows, int cols, List<int> tiles) {
  var inversions = 0;
  for (var i = 0; i < tiles.length; i++) {
    if (tiles[i] == 0) continue;
    for (var j = i + 1; j < tiles.length; j++) {
      if (tiles[j] != 0 && tiles[j] < tiles[i]) inversions++;
    }
  }
  final gapRow = tiles.indexOf(0) ~/ cols;
  return (inversions + (cols.isEven ? rows - 1 - gapRow : 0)).isEven;
}

/// [state] after the gap moves [d] (one tile slides into it).
GlideState glideMove(GlidePuzzle p, GlideState state, String d) =>
    GlideState(glideApply(p.rows, p.cols, state.tiles, d), state.path + d);

/// The gap moves that slide the tile at [cell], and every tile between it
/// and the gap, toward the gap; null when [cell] is not in the gap's row or
/// column (or is the gap).
String? glideLine(GlidePuzzle p, List<int> tiles, int cell) {
  final g = tiles.indexOf(0);
  final gr = g ~/ p.cols, gc = g % p.cols, r = cell ~/ p.cols, c = cell % p.cols;
  if (cell == g) return null;
  if (r == gr) return (c < gc ? 'l' : 'r') * (c - gc).abs();
  if (c == gc) return (r < gr ? 'u' : 'd') * (r - gr).abs();
  return null;
}

/// [state] after sliding the tile at [cell] (and those between) into the gap.
GlideState? glideSlide(GlidePuzzle p, GlideState state, int cell) {
  final moves = glideLine(p, state.tiles, cell);
  if (moves == null) return null;
  return GlideState(glideApply(p.rows, p.cols, state.tiles, moves), state.path + moves);
}
