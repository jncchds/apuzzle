import '../../core/grid.dart';

/// Inclusive cell rectangle.
class CellRect {
  const CellRect(this.r0, this.c0, this.r1, this.c1);

  factory CellRect.span(Pos a, Pos b) =>
      CellRect(a.r < b.r ? a.r : b.r, a.c < b.c ? a.c : b.c, a.r > b.r ? a.r : b.r, a.c > b.c ? a.c : b.c);

  final int r0, c0, r1, c1;

  int get area => (r1 - r0 + 1) * (c1 - c0 + 1);
  bool contains(int r, int c) => r >= r0 && r <= r1 && c >= c0 && c <= c1;
  bool overlaps(CellRect o) => r0 <= o.r1 && o.r0 <= r1 && c0 <= o.c1 && o.c0 <= c1;

  Iterable<int> cells(int cols) sync* {
    for (var r = r0; r <= r1; r++) {
      for (var c = c0; c <= c1; c++) {
        yield r * cols + c;
      }
    }
  }

  List<int> toJson() => [r0, c0, r1, c1];
  factory CellRect.fromJson(List j) => CellRect(j[0] as int, j[1] as int, j[2] as int, j[3] as int);

  @override
  bool operator ==(Object o) => o is CellRect && o.r0 == r0 && o.c0 == c0 && o.r1 == r1 && o.c1 == c1;
  @override
  int get hashCode => Object.hash(r0, c0, r1, c1);
}

class ShikakuPuzzle {
  const ShikakuPuzzle({required this.rows, required this.cols, required this.clues, required this.solution});

  final int rows;
  final int cols;

  /// Area number at clue cells, null elsewhere.
  final List<int?> clues;
  final List<CellRect> solution;

  GridSize get size => GridSize(rows, cols);

  Map<String, dynamic> toJson() => {
        'rows': rows,
        'cols': cols,
        'clues': clues,
        'solution': [for (final r in solution) r.toJson()],
      };
  factory ShikakuPuzzle.fromJson(Map<String, dynamic> j) => ShikakuPuzzle(
        rows: j['rows'] as int,
        cols: j['cols'] as int,
        clues: (j['clues'] as List).cast<int?>(),
        solution: [for (final r in j['solution'] as List) CellRect.fromJson(r as List)],
      );
}

class ShikakuState {
  const ShikakuState(this.rects);
  final List<CellRect> rects;

  Map<String, dynamic> toJson() => {'rects': [for (final r in rects) r.toJson()]};
  factory ShikakuState.fromJson(Map<String, dynamic> j) =>
      ShikakuState([for (final r in j['rects'] as List) CellRect.fromJson(r as List)]);
}

/// Rectangles that don't hold exactly one number equal to their area.
List<CellRect> shikakuBadRects(ShikakuPuzzle p, List<CellRect> rects) => [
      for (final rect in rects)
        if (() {
          final nums = [for (final i in rect.cells(p.cols)) if (p.clues[i] != null) p.clues[i]!];
          return nums.length != 1 || nums.single != rect.area;
        }())
          rect,
    ];
