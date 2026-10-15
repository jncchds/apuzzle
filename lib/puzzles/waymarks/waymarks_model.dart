import '../../core/grid.dart';

/// Arrow directions, clockwise from up: (row step, column step).
const List<(int, int)> waymarksDirs = [(-1, 0), (-1, 1), (0, 1), (1, 1), (1, 0), (1, -1), (0, -1), (-1, -1)];

/// Waymarks: every cell holds an arrow (the last one a goal instead).
/// Number the cells 1, 2, … so that each arrow points, any distance along
/// its line, at the cell with the next number. Some numbers are shown, the
/// first and the last always.
class WaymarksPuzzle {
  WaymarksPuzzle({required this.n, required this.path, required this.shown})
    : assert(path.length == n * n),
      assert(shown.first && shown.last);

  final int n;

  /// Solution: the cells in number order (path[k] holds number k + 1).
  final List<int> path;

  /// Whether number k + 1 is shown.
  final List<bool> shown;

  GridSize get size => GridSize.square(n);
  int get cells => n * n;

  /// Solution number of each cell (1-based).
  late final List<int> number = () {
    final out = List<int>.filled(cells, 0);
    for (var k = 0; k < cells; k++) {
      out[path[k]] = k + 1;
    }
    return out;
  }();

  /// The shown number of each cell, or 0.
  late final List<int> given = [for (var i = 0; i < cells; i++) shown[number[i] - 1] ? number[i] : 0];

  /// The arrow of each cell (an index into [waymarksDirs]), -1 for the last.
  late final List<int> dir = () {
    final out = List<int>.filled(cells, -1);
    for (var k = 0; k + 1 < cells; k++) {
      out[path[k]] = waymarksDirOf(n, path[k], path[k + 1]);
    }
    return out;
  }();

  /// The cells each arrow points at, nearest first.
  late final List<List<int>> targets = [for (var i = 0; i < cells; i++) waymarksRay(n, i, dir[i])];

  /// The cells whose arrows point at each cell.
  late final List<List<int>> sources = () {
    final out = [for (var i = 0; i < cells; i++) <int>[]];
    for (var i = 0; i < cells; i++) {
      for (final j in targets[i]) {
        out[j].add(i);
      }
    }
    return out;
  }();

  /// Whether [a]'s arrow points at [b].
  bool points(int a, int b) => targets[a].contains(b);

  Map<String, dynamic> toJson() => {
    'n': n,
    'path': path,
    'shown': [
      for (var k = 0; k < cells; k++)
        if (shown[k]) k + 1,
    ],
  };

  factory WaymarksPuzzle.fromJson(Map<String, dynamic> j) {
    final n = j['n'] as int;
    final shown = (j['shown'] as List).cast<int>().toSet();
    return WaymarksPuzzle(
      n: n,
      path: (j['path'] as List).cast<int>(),
      shown: [for (var k = 1; k <= n * n; k++) shown.contains(k)],
    );
  }
}

/// The direction from [a] to [b] (on one line), or -1.
int waymarksDirOf(int n, int a, int b) {
  final dr = b ~/ n - a ~/ n, dc = b % n - a % n;
  if (dr == 0 && dc == 0) return -1;
  if (dr != 0 && dc != 0 && dr.abs() != dc.abs()) return -1;
  return waymarksDirs.indexOf((dr.sign, dc.sign));
}

/// The cells from [i] along direction [d] to the edge, nearest first.
List<int> waymarksRay(int n, int i, int d) {
  if (d < 0) return const [];
  final (dr, dc) = waymarksDirs[d];
  final out = <int>[];
  var r = i ~/ n + dr, c = i % n + dc;
  while (r >= 0 && c >= 0 && r < n && c < n) {
    out.add(r * n + c);
    r += dr;
    c += dc;
  }
  return out;
}

/// The player's links: the cell each cell leads on to, or -1.
class WaymarksState {
  const WaymarksState(this.next);

  final List<int> next;

  int get links => next.where((j) => j >= 0).length;

  Map<String, dynamic> toJson() => {'next': next};
  factory WaymarksState.fromJson(Map<String, dynamic> j) => WaymarksState((j['next'] as List).cast<int>());
}

/// [s] with [a] leading on to [b] (their old links there dropped), or null
/// if [a]'s arrow doesn't point at [b] or the link would close a loop.
WaymarksState? waymarksLink(WaymarksPuzzle p, WaymarksState s, int a, int b) {
  if (!p.points(a, b) || s.next[a] == b) return null;
  // A loop: following the links from b comes back to a.
  for (var j = b, steps = 0; j >= 0 && steps <= p.cells; j = s.next[j], steps++) {
    if (j == a) return null;
  }
  final next = List.of(s.next);
  for (var i = 0; i < next.length; i++) {
    if (next[i] == b) next[i] = -1;
  }
  next[a] = b;
  return WaymarksState(next);
}

/// [s] without the links into and out of [a].
WaymarksState waymarksCut(WaymarksState s, int a) =>
    WaymarksState([for (var i = 0; i < s.next.length; i++) i == a || s.next[i] == a ? -1 : s.next[i]]);

/// A run of linked cells, first to last, and the number of its first cell
/// if one of its cells shows a number (else null: it gets a letter).
class WaymarksChain {
  const WaymarksChain(this.cells, this.start);

  final List<int> cells;
  final int? start;
}

/// The chains of [s] (single cells included), in reading order of their
/// first cells. Cells on a loop (only from a bad saved state) are left out.
List<WaymarksChain> waymarksChains(WaymarksPuzzle p, WaymarksState s) {
  final hasPrev = List<bool>.filled(p.cells, false);
  for (final j in s.next) {
    if (j >= 0) hasPrev[j] = true;
  }
  final out = <WaymarksChain>[];
  for (var h = 0; h < p.cells; h++) {
    if (hasPrev[h]) continue;
    final cells = <int>[];
    for (var j = h; j >= 0 && cells.length < p.cells; j = s.next[j]) {
      cells.add(j);
    }
    int? start;
    for (var k = 0; k < cells.length && start == null; k++) {
      if (p.given[cells[k]] > 0) start = p.given[cells[k]] - k;
    }
    out.add(WaymarksChain(cells, start));
  }
  return out;
}

/// Cells whose shown number disagrees with the chain they are in (another
/// shown number, or a number off 1..N), and cells on a loop.
Set<int> waymarksConflicts(WaymarksPuzzle p, WaymarksState s) {
  final out = <int>{};
  final seen = List<bool>.filled(p.cells, false);
  for (final ch in waymarksChains(p, s)) {
    for (final i in ch.cells) {
      seen[i] = true;
    }
    final start = ch.start;
    if (start == null) continue;
    final bad = start < 1 || start + ch.cells.length - 1 > p.cells;
    for (var k = 0; k < ch.cells.length; k++) {
      final g = p.given[ch.cells[k]];
      if (g > 0 && (bad || g != start + k)) out.add(ch.cells[k]);
    }
  }
  for (var i = 0; i < p.cells; i++) {
    if (!seen[i]) out.add(i);
  }
  return out;
}

/// Whether the links make one chain through every cell.
bool waymarksComplete(WaymarksPuzzle p, WaymarksState s) => s.links == p.cells - 1 && waymarksChains(p, s).length == 1;

/// Whether the links make one chain through every cell, following the
/// arrows, that agrees with every shown number.
bool waymarksSolved(WaymarksPuzzle p, WaymarksState s) {
  if (!waymarksComplete(p, s)) return false;
  for (var i = 0; i < p.cells; i++) {
    if (s.next[i] >= 0 && !p.points(i, s.next[i])) return false;
  }
  final ch = waymarksChains(p, s).single;
  return ch.start == 1 && waymarksConflicts(p, s).isEmpty;
}
