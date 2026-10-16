import '../../core/grid.dart';
import '../../core/value_grid.dart';

/// The value of a cell outside the shape (a given, never drawn).
const int layersHole = 9;

/// Layers: every row and every column was painted once, in some order, with
/// its own color (lines 0..rows-1 are the rows, then the columns). A cell
/// shows the color of whichever of its row and column came last. Some cells
/// are shown; the player paints the rest. On hard boards some lines hide
/// their color.
class LayersPuzzle implements ValueGridPuzzle {
  const LayersPuzzle({
    required this.rows,
    required this.cols,
    required this.colors,
    required this.lineColors,
    required this.picture,
    required this.givens,
    this.hidden = const [],
  });

  final int rows;
  final int cols;

  /// How many colors the board uses.
  final int colors;

  /// The color of each line: rows first, then columns.
  final List<int> lineColors;

  /// The solution: a color per cell, [layersHole] outside the shape.
  final List<int> picture;

  /// Cells shown from the start, sorted.
  final List<int> givens;

  /// Lines whose color isn't shown, sorted.
  final List<int> hidden;

  int get lines => rows + cols;
  int get cells => rows * cols;

  bool isHole(int i) => picture[i] == layersHole;

  /// The row and column line of cell [i].
  (int, int) linesOf(int i) => (i ~/ cols, rows + i % cols);

  /// The cell where [a] and [b] (a row and a column, either way round) cross.
  int cellOf(int a, int b) => a < rows ? a * cols + b - rows : b * cols + a - rows;

  @override
  GridSize get size => GridSize(rows, cols);
  @override
  int? givenAt(int index) => isHole(index) || givens.contains(index) ? picture[index] : null;
  @override
  int solutionAt(int index) => picture[index];

  Map<String, dynamic> toJson() => {
    'r': rows,
    'c': cols,
    'k': colors,
    'lines': lineColors.join(),
    'pic': [for (final v in picture) v == layersHole ? '.' : '$v'].join(),
    'given': givens,
    if (hidden.isNotEmpty) 'hidden': hidden,
  };

  factory LayersPuzzle.fromJson(Map<String, dynamic> j) => LayersPuzzle(
    rows: j['r'] as int,
    cols: j['c'] as int,
    colors: j['k'] as int,
    lineColors: [for (final ch in (j['lines'] as String).split('')) int.parse(ch)],
    picture: [for (final ch in (j['pic'] as String).split('')) ch == '.' ? layersHole : int.parse(ch)],
    givens: (j['given'] as List).cast<int>(),
    hidden: ((j['hidden'] as List?) ?? const []).cast<int>(),
  );
}

/// The picture painting the lines in [order] (first to last) leaves.
List<int> layersPaint(int rows, int cols, List<int> lineColors, List<int> order, Set<int> holes) {
  final rank = List<int>.filled(rows + cols, 0);
  for (var t = 0; t < order.length; t++) {
    rank[order[t]] = t;
  }
  return [
    for (var i = 0; i < rows * cols; i++)
      if (holes.contains(i))
        layersHole
      else
        rank[i ~/ cols] > rank[rows + i % cols] ? lineColors[i ~/ cols] : lineColors[rows + i % cols],
  ];
}

/// Cells of [values] (-1 empty) that no painting order can give: a color
/// that is neither its row's nor its column's, a hidden line shown in two
/// colors where it must have come last, and cells whose stroke order would
/// go round in a circle.
Set<int> layersConflicts(LayersPuzzle p, List<int> values) {
  final bad = <int>{};
  final known = [for (var l = 0; l < p.lines; l++) p.hidden.contains(l) ? -1 : p.lineColors[l]];
  // The later line of each cell whose color says so.
  final later = <int, (int, int)>{};
  final shown = <int, Map<int, List<int>>>{};
  for (var i = 0; i < p.cells; i++) {
    final v = values[i];
    if (v < 0 || p.isHole(i)) continue;
    final (r, c) = p.linesOf(i);
    final kr = known[r], kc = known[c];
    if (kr >= 0 && kc >= 0) {
      if (v != kr && v != kc) {
        bad.add(i);
      } else if (kr != kc) {
        later[i] = v == kr ? (r, c) : (c, r);
      }
    } else if (kr >= 0 && v != kr) {
      later[i] = (c, r);
      ((shown[c] ??= {})[v] ??= []).add(i);
    } else if (kc >= 0 && v != kc) {
      later[i] = (r, c);
      ((shown[r] ??= {})[v] ??= []).add(i);
    }
  }
  for (final colors in shown.values) {
    if (colors.length > 1) {
      for (final cells in colors.values) {
        bad.addAll(cells);
      }
    }
  }
  // Cells whose two lines sit on one cycle of the order.
  final after = List<int>.filled(p.lines, 0);
  for (final (a, b) in later.values) {
    after[a] |= 1 << b;
  }
  final reach = List.of(after);
  for (var k = 0; k < p.lines; k++) {
    for (var a = 0; a < p.lines; a++) {
      if (reach[a] & (1 << k) != 0) reach[a] |= reach[k];
    }
  }
  for (final MapEntry(key: i, value: (a, b)) in later.entries) {
    if (reach[b] & (1 << a) != 0) bad.add(i);
  }
  return bad;
}
