import '../../core/grid_graph.dart';
import 'camp_model.dart';

const int _unk = -1;

/// Cell states: -1 unknown, [campGrass], [campTent] (tree cells hold [campTree]).
/// Tier 1: counts, no-touch, trees with one free neighbour, pairing checks.
/// Tier 2: + probing (try a value, refute it by propagation).
class CampSolver {
  CampSolver(this.rows, this.cols, this.trees, this.rowCounts, this.colCounts)
      : on = orthNeighbors(rows, cols),
        kn = kingNeighbors(rows, cols) {
    treeList = [for (var i = 0; i < trees.length; i++) if (trees[i]) i];
    lines = [
      for (var r = 0; r < rows; r++) ([for (var c = 0; c < cols; c++) r * cols + c], rowCounts[r]),
      for (var c = 0; c < cols; c++) ([for (var r = 0; r < rows; r++) r * cols + c], colCounts[c]),
    ];
  }

  final int rows;
  final int cols;
  final List<bool> trees;
  final List<int?> rowCounts;
  final List<int?> colCounts;
  final List<List<int>> on;
  final List<List<int>> kn;
  late final List<int> treeList;
  late final List<(List<int>, int?)> lines;

  List<int> initial({List<int> givenTents = const []}) {
    final st = [
      for (var i = 0; i < rows * cols; i++)
        trees[i]
            ? campTree
            : on[i].any((j) => trees[j])
                ? _unk
                : campGrass,
    ];
    for (final i in givenTents) {
      st[i] = campTent;
    }
    return st;
  }

  bool _set(List<int> st, int i, int v) {
    if (st[i] == v) return true;
    if (st[i] != _unk) return false;
    st[i] = v;
    return true;
  }

  /// Applies tier-1 rules until nothing changes. False on a contradiction.
  bool propagate(List<int> st) {
    var changed = true;
    while (changed) {
      changed = false;
      for (var i = 0; i < st.length; i++) {
        if (st[i] != campTent) continue;
        for (final j in kn[i]) {
          if (st[j] == campTent) return false;
          if (st[j] == _unk) {
            st[j] = campGrass;
            changed = true;
          }
        }
      }
      for (final (cells, want) in lines) {
        if (want == null) continue;
        var t = 0;
        final u = <int>[];
        for (final i in cells) {
          if (st[i] == campTent) t++;
          if (st[i] == _unk) u.add(i);
        }
        if (t > want || t + u.length < want) return false;
        if (u.isEmpty) continue;
        // At most ceil(len/2) tents fit in a run of free cells.
        var room = 0, run = 0;
        for (final i in cells) {
          if (st[i] == _unk) {
            run++;
          } else {
            room += (run + 1) ~/ 2;
            run = 0;
          }
        }
        room += (run + 1) ~/ 2;
        if (t + room < want) return false;
        if (t == want || t + u.length == want) {
          for (final i in u) {
            st[i] = t == want ? campGrass : campTent;
          }
          changed = true;
        }
      }
      var tents = 0, unknown = 0;
      for (final v in st) {
        if (v == campTent) tents++;
        if (v == _unk) unknown++;
      }
      if (tents > treeList.length || tents + unknown < treeList.length) return false;
      if (unknown > 0 && (tents == treeList.length || tents + unknown == treeList.length)) {
        for (var i = 0; i < st.length; i++) {
          if (st[i] == _unk) st[i] = tents == treeList.length ? campGrass : campTent;
        }
        changed = true;
        continue;
      }
      for (final t in treeList) {
        final free = [for (final j in on[t]) if (st[j] == campTent || st[j] == _unk) j];
        if (free.isEmpty) return false;
        if (free.length == 1 && st[free.first] == _unk) {
          st[free.first] = campTent;
          changed = true;
        }
      }
      for (var i = 0; i < st.length; i++) {
        if (st[i] == campTent && !on[i].any((j) => trees[j])) return false;
      }
      if (!changed && !_pairable(st)) return false;
    }
    return true;
  }

  /// Every tree can get its own tent, and every placed tent its own tree.
  /// (Two matchings saturating each side imply one saturating both.)
  bool _pairable(List<int> st) {
    final opts = [for (final t in treeList) [for (final j in on[t]) if (st[j] == campTent || st[j] == _unk) j]];
    if (maxMatching(opts, st.length).any((v) => v < 0)) return false;
    final tents = [for (var i = 0; i < st.length; i++) if (st[i] == campTent) i];
    final back = [for (final i in tents) [for (final j in on[i]) if (trees[j]) j]];
    return !maxMatching(back, st.length).any((v) => v < 0);
  }

  bool solved(List<int> st) => !st.contains(_unk);

  /// True if [st] gets fully determined using logic up to [tier].
  bool solve(List<int> st, int tier) {
    if (!propagate(st)) return false;
    if (tier >= 2) {
      var progress = true;
      while (progress && !solved(st)) {
        progress = false;
        for (var i = 0; i < st.length && !progress; i++) {
          if (st[i] != _unk) continue;
          for (final v in const [campTent, campGrass]) {
            final t = List.of(st);
            t[i] = v;
            if (!propagate(t)) {
              if (!_set(st, i, v == campTent ? campGrass : campTent) || !propagate(st)) return false;
              progress = true;
              break;
            }
          }
        }
      }
    }
    return solved(st);
  }

  int countSolutions(List<int> st, {int limit = 2}) {
    final t = List.of(st);
    if (!propagate(t)) return 0;
    final i = t.indexOf(_unk);
    if (i < 0) return 1;
    var total = 0;
    for (final v in const [campTent, campGrass]) {
      if (total >= limit) break;
      final u = List.of(t)..[i] = v;
      total += countSolutions(u, limit: limit - total);
    }
    return total;
  }
}
