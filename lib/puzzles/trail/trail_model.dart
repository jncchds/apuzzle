import '../../core/grid.dart';

class TrailPuzzle {
  const TrailPuzzle({required this.rows, required this.cols, required this.numbers, required this.solution});

  final int rows;
  final int cols;

  /// Waypoint number (1..K) per cell, null elsewhere.
  final List<int?> numbers;

  /// Hamiltonian path (cell indices) from 1 to K.
  final List<int> solution;

  GridSize get size => GridSize(rows, cols);
  int get lastNumber => numbers.fold(0, (a, b) => b != null && b > a ? b : a);
  int get startCell => numbers.indexOf(1);

  Map<String, dynamic> toJson() => {'rows': rows, 'cols': cols, 'numbers': numbers, 'solution': solution};
  factory TrailPuzzle.fromJson(Map<String, dynamic> j) => TrailPuzzle(
        rows: j['rows'] as int,
        cols: j['cols'] as int,
        numbers: (j['numbers'] as List).cast<int?>(),
        solution: (j['solution'] as List).cast<int>(),
      );
}

class TrailState {
  const TrailState(this.path);
  final List<int> path;

  Map<String, dynamic> toJson() => {'path': path};
  factory TrailState.fromJson(Map<String, dynamic> j) => TrailState((j['path'] as List).cast<int>());
}

bool trailAdjacent(int a, int b, int cols) {
  final ra = a ~/ cols, ca = a % cols, rb = b ~/ cols, cb = b % cols;
  return (ra - rb).abs() + (ca - cb).abs() == 1;
}

/// Next number the path must reach (1-based), given the path so far.
int trailNextNumber(TrailPuzzle p, List<int> path) {
  var next = 1;
  for (final i in path) {
    if (p.numbers[i] == next) next++;
  }
  return next;
}

bool trailValid(TrailPuzzle p, List<int> path) {
  final n = p.rows * p.cols;
  if (path.length != n || path.toSet().length != n) return false;
  for (var k = 1; k < path.length; k++) {
    if (!trailAdjacent(path[k - 1], path[k], p.cols)) return false;
  }
  var next = 1;
  for (final i in path) {
    final v = p.numbers[i];
    if (v == null) continue;
    if (v != next) return false;
    next++;
  }
  return path.first == p.startCell && p.numbers[path.last] == p.lastNumber;
}
