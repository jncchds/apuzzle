import 'dart:math';

import '../../core/grid.dart';
import '../../core/lattice_loop.dart';

/// Index of the domino [a]–[b] (either way round) in a full set.
int dominoIndex(int a, int b) {
  final lo = min(a, b), hi = max(a, b);
  return hi * (hi + 1) ~/ 2 + lo;
}

/// Dominoes in a set from 0–0 to [top]–[top].
int dominoCount(int top) => (top + 1) * (top + 2) ~/ 2;

/// A full set of dominoes laid out on the grid with their outlines rubbed
/// off: split the numbers into dominoes so that every pair shows up once.
/// Dominoes are edges between neighbouring cell centres (a [LatticeLoop] of
/// rows × cols points); the player's marks are [LoopMarks] (1 domino, 2 cross).
class DominoPuzzle {
  const DominoPuzzle({required this.rows, required this.cols, required this.nums, required this.lines});

  final int rows;
  final int cols;

  /// The number in every cell.
  final List<int> nums;

  /// Solution: the edges joining the two halves of a domino.
  final List<bool> lines;

  GridSize get size => GridSize(rows, cols);
  LatticeLoop get lattice => _lattices[this] ??= LatticeLoop(rows, cols);
  static final _lattices = Expando<LatticeLoop>();

  /// The set's highest number.
  int get top => nums.reduce(max);

  /// The domino edge [e] would make.
  int pairAt(int e) {
    final (a, b) = lattice.ends(e);
    return dominoIndex(nums[a], nums[b]);
  }

  Map<String, dynamic> toJson() => {
    'rows': rows,
    'cols': cols,
    'nums': nums.join(),
    'lines': [
      for (var e = 0; e < lines.length; e++)
        if (lines[e]) e,
    ],
  };

  factory DominoPuzzle.fromJson(Map<String, dynamic> j) {
    final rows = j['rows'] as int, cols = j['cols'] as int;
    final lines = List<bool>.filled(LatticeLoop(rows, cols).edgeCount, false);
    for (final e in (j['lines'] as List).cast<int>()) {
      lines[e] = true;
    }
    return DominoPuzzle(
      rows: rows,
      cols: cols,
      nums: [for (final ch in (j['nums'] as String).split('')) int.parse(ch)],
      lines: lines,
    );
  }
}

/// Whether every cell is in exactly one domino.
bool dominoCovered(DominoPuzzle p, List<int> marks) {
  final g = p.lattice;
  for (var i = 0; i < g.vertexCount; i++) {
    if (g.incident[i].where((e) => marks[e] == 1).length != 1) return false;
  }
  return true;
}

/// Cells breaking a rule: in two dominoes at once, or in a domino whose pair
/// of numbers is placed more than once.
Set<int> dominoBad(DominoPuzzle p, List<int> marks) {
  final g = p.lattice;
  final bad = <int>{};
  for (var i = 0; i < g.vertexCount; i++) {
    if (g.incident[i].where((e) => marks[e] == 1).length > 1) bad.add(i);
  }
  final byPair = <int, List<int>>{};
  for (var e = 0; e < marks.length; e++) {
    if (marks[e] == 1) (byPair[p.pairAt(e)] ??= []).add(e);
  }
  for (final edges in byPair.values) {
    if (edges.length < 2) continue;
    for (final e in edges) {
      final (a, b) = g.ends(e);
      bad.addAll([a, b]);
    }
  }
  return bad;
}

/// [next] marks after an edit of [old]: a new domino takes its cells from
/// the dominoes that had them. New dominoes sharing a cell (a drag along a
/// row) pair the cells up from the first one.
List<int> dominoCommit(LatticeLoop g, List<int> old, List<int> next) {
  final out = List.of(next);
  final kept = <int>{};
  final taken = <int>{};
  for (var e = 0; e < next.length; e++) {
    if (next[e] != 1 || old[e] == 1) continue;
    final (a, b) = g.ends(e);
    if (taken.contains(a) || taken.contains(b)) {
      out[e] = old[e];
      continue;
    }
    kept.add(e);
    taken.addAll([a, b]);
  }
  for (var e = 0; e < out.length; e++) {
    if (out[e] != 1 || kept.contains(e)) continue;
    final (a, b) = g.ends(e);
    if (taken.contains(a) || taken.contains(b)) out[e] = 0;
  }
  return out;
}
