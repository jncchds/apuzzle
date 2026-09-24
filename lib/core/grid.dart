import 'package:flutter/foundation.dart';

/// A cell position (row, column).
@immutable
class Pos {
  const Pos(this.r, this.c);

  final int r;
  final int c;

  @override
  bool operator ==(Object other) => other is Pos && other.r == r && other.c == c;

  @override
  int get hashCode => r * 4099 + c;

  @override
  String toString() => '($r,$c)';
}

/// Grid dimensions.
@immutable
class GridSize {
  const GridSize(this.rows, this.cols);
  const GridSize.square(int n)
      : rows = n,
        cols = n;

  final int rows;
  final int cols;

  int get cellCount => rows * cols;
  String get label => rows == cols ? '$rows×$rows' : '$cols×$rows';

  int index(Pos p) => p.r * cols + p.c;
  Pos pos(int index) => Pos(index ~/ cols, index % cols);
  bool contains(Pos p) => p.r >= 0 && p.c >= 0 && p.r < rows && p.c < cols;

  Iterable<Pos> get positions sync* {
    for (var r = 0; r < rows; r++) {
      for (var c = 0; c < cols; c++) {
        yield Pos(r, c);
      }
    }
  }

  Map<String, dynamic> toJson() => {'r': rows, 'c': cols};
  factory GridSize.fromJson(Map<String, dynamic> j) => GridSize(j['r'] as int, j['c'] as int);

  @override
  bool operator ==(Object other) => other is GridSize && other.rows == rows && other.cols == cols;

  @override
  int get hashCode => rows * 4099 + cols;
}
