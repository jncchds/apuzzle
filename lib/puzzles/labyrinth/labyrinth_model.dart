import '../../core/grid.dart';

/// Direction bits of an open passage: N=1, E=2, S=4, W=8.
const int dN = 1, dE = 2, dS = 4, dW = 8;
const dirs = [dN, dE, dS, dW];

int opposite(int d) => switch (d) { dN => dS, dE => dW, dS => dN, _ => dE };

class LabyrinthPuzzle {
  const LabyrinthPuzzle({required this.rows, required this.cols, required this.open, required this.solution});

  final int rows;
  final int cols;

  /// Open passages per cell (direction bits). A perfect maze: every cell is
  /// reachable and there is exactly one way between any two cells.
  final List<int> open;

  /// The way from [start] to [exit] (cell indices).
  final List<int> solution;

  GridSize get size => GridSize(rows, cols);
  int get start => 0;
  int get exit => rows * cols - 1;

  Map<String, dynamic> toJson() => {'rows': rows, 'cols': cols, 'open': open, 'solution': solution};
  factory LabyrinthPuzzle.fromJson(Map<String, dynamic> j) => LabyrinthPuzzle(
        rows: j['rows'] as int,
        cols: j['cols'] as int,
        open: (j['open'] as List).cast<int>(),
        solution: (j['solution'] as List).cast<int>(),
      );
}

/// The walked path, from the start to the player's current cell.
class LabyrinthState {
  const LabyrinthState(this.path);
  final List<int> path;

  Map<String, dynamic> toJson() => {'path': path};
  factory LabyrinthState.fromJson(Map<String, dynamic> j) => LabyrinthState((j['path'] as List).cast<int>());
}

int? neighbor(int i, int d, int rows, int cols) {
  final r = i ~/ cols, c = i % cols;
  return switch (d) {
    dN => r > 0 ? i - cols : null,
    dS => r < rows - 1 ? i + cols : null,
    dW => c > 0 ? i - 1 : null,
    _ => c < cols - 1 ? i + 1 : null,
  };
}

/// Whether there is an open passage between neighbouring cells [a] and [b].
bool passable(LabyrinthPuzzle p, int a, int b) {
  for (final d in dirs) {
    if (neighbor(a, d, p.rows, p.cols) == b) return p.open[a] & d != 0;
  }
  return false;
}

/// Cells after [from] up to [to] along a straight open corridor, or null if
/// [to] is not in the same row or column or a wall is in the way.
List<int>? corridor(LabyrinthPuzzle p, int from, int to) {
  if (from == to) return null;
  final fr = from ~/ p.cols, fc = from % p.cols, tr = to ~/ p.cols, tc = to % p.cols;
  if (fr != tr && fc != tc) return null;
  final step = fr == tr ? (tc > fc ? 1 : -1) : (tr > fr ? p.cols : -p.cols);
  final out = <int>[];
  for (var i = from; i != to; i += step) {
    if (!passable(p, i, i + step)) return null;
    out.add(i + step);
  }
  return out;
}

/// Number of open passages of cell [i].
int exits(LabyrinthPuzzle p, int i) => dirs.where((d) => p.open[i] & d != 0).length;

/// A walk from the start to the exit through open passages, never revisiting a cell.
bool labyrinthSolved(LabyrinthPuzzle p, List<int> path) {
  if (path.isEmpty || path.first != p.start || path.last != p.exit) return false;
  if (path.toSet().length != path.length) return false;
  for (var k = 1; k < path.length; k++) {
    if (!passable(p, path[k - 1], path[k])) return false;
  }
  return true;
}
