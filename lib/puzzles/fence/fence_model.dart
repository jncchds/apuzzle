import '../../core/grid.dart';
import '../../core/lattice_loop.dart';

/// Slitherlink: one loop along the grid lines; a number tells how many sides
/// of its cell the loop uses.
class FencePuzzle {
  const FencePuzzle({required this.rows, required this.cols, required this.numbers, required this.lines});

  final int rows;
  final int cols;

  /// Per cell, null where there is no number.
  final List<int?> numbers;

  /// Solution, per lattice edge (see [LatticeLoop] with rows + 1 × cols + 1 points).
  final List<bool> lines;

  GridSize get size => GridSize(rows, cols);
  LatticeLoop get lattice => _lattices[this] ??= LatticeLoop(rows + 1, cols + 1);
  static final _lattices = Expando<LatticeLoop>();

  Map<String, dynamic> toJson() => {
        'rows': rows,
        'cols': cols,
        'numbers': numbers,
        'lines': [for (var e = 0; e < lines.length; e++) if (lines[e]) e],
      };

  factory FencePuzzle.fromJson(Map<String, dynamic> j) {
    final rows = j['rows'] as int, cols = j['cols'] as int;
    final lines = List<bool>.filled(LatticeLoop(rows + 1, cols + 1).edgeCount, false);
    for (final e in (j['lines'] as List).cast<int>()) {
      lines[e] = true;
    }
    return FencePuzzle(rows: rows, cols: cols, numbers: (j['numbers'] as List).cast<int?>(), lines: lines);
  }
}

/// The four sides of cell (r, c).
List<int> fenceSides(LatticeLoop g, int r, int c) => [g.h(r, c), g.h(r + 1, c), g.v(r, c), g.v(r, c + 1)];

/// Numbered cells whose count of drawn sides is wrong ([complete]) or too high.
Set<int> fenceBadCells(FencePuzzle p, LatticeLoop g, List<bool> lines, {required bool complete}) => {
      for (var i = 0; i < p.numbers.length; i++)
        if (p.numbers[i] case final want?)
          if (fenceSides(g, i ~/ p.cols, i % p.cols).where((e) => lines[e]).length case final have
              when have > want || (complete && have != want))
            i,
    };
