import '../../core/grid.dart';

/// Numberlink: join every pair of equal dots with a path through
/// neighbouring cells. Paths never cross or branch, and together they fill
/// the whole grid.
class LinksPuzzle {
  const LinksPuzzle({required this.rows, required this.cols, required this.paths});

  final int rows;
  final int cols;

  /// Solution: one path per pair, from one dot to the other (cell indices).
  final List<List<int>> paths;

  GridSize get size => GridSize(rows, cols);
  int get pairs => paths.length;

  /// Pair of the dot on each cell, or -1.
  List<int> get dots => _dots[this] ??= () {
        final d = List<int>.filled(rows * cols, -1);
        for (var k = 0; k < paths.length; k++) {
          d[paths[k].first] = k;
          d[paths[k].last] = k;
        }
        return d;
      }();
  static final _dots = Expando<List<int>>();

  Map<String, dynamic> toJson() => {'rows': rows, 'cols': cols, 'paths': paths};

  factory LinksPuzzle.fromJson(Map<String, dynamic> j) => LinksPuzzle(
        rows: j['rows'] as int,
        cols: j['cols'] as int,
        paths: [for (final p in j['paths'] as List) (p as List).cast<int>()],
      );
}

/// The player's paths, one per pair (empty, or starting at one of its dots).
class LinksState {
  const LinksState(this.paths);

  final List<List<int>> paths;

  Map<String, dynamic> toJson() => {'paths': paths};
  factory LinksState.fromJson(Map<String, dynamic> j) =>
      LinksState([for (final p in j['paths'] as List) (p as List).cast<int>()]);
}

bool linksAdjacent(int a, int b, int cols) {
  final ra = a ~/ cols, ca = a % cols, rb = b ~/ cols, cb = b % cols;
  return (ra - rb).abs() + (ca - cb).abs() == 1;
}

/// Whether [path] joins the two dots of pair [k].
bool linksJoined(LinksPuzzle p, List<int> path, int k) =>
    path.length >= 2 && p.dots[path.first] == k && p.dots[path.last] == k && path.first != path.last;

/// Whether every pair is joined and the paths fill the grid without overlap.
bool linksValid(LinksPuzzle p, List<List<int>> paths) {
  final used = List<bool>.filled(p.rows * p.cols, false);
  for (var k = 0; k < p.pairs; k++) {
    final path = paths[k];
    if (!linksJoined(p, path, k)) return false;
    for (var i = 0; i < path.length; i++) {
      if (used[path[i]]) return false;
      used[path[i]] = true;
      if (i > 0 && !linksAdjacent(path[i - 1], path[i], p.cols)) return false;
      if (i > 0 && i < path.length - 1 && p.dots[path[i]] >= 0) return false;
    }
  }
  return !used.contains(false);
}
