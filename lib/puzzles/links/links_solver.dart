import '../../core/lattice_loop.dart';
import 'links_model.dart';

/// Edge logic for Numberlink on the lattice of cell centres. Edge states:
/// -1 unknown, 0 no link, 1 link. Tier 1: degrees (1 at dots, 2 elsewhere,
/// since the paths fill the grid), no closed loops, and no link between
/// paths of different pairs. Tier 2: + probing.
class LinksSolver {
  LinksSolver(this.rows, this.cols, this.dots) : g = LatticeLoop(rows, cols);

  final int rows;
  final int cols;

  /// Pair of the dot on each cell, or -1.
  final List<int> dots;
  final LatticeLoop g;

  List<int> start() => List<int>.filled(g.edgeCount, -1);

  int _degree(int p) => dots[p] >= 0 ? 1 : 2;

  bool propagate(List<int> st) {
    final n = rows * cols;
    final parent = List<int>.filled(n, 0);
    final pair = List<int>.filled(n, -1);
    int find(int x) {
      while (parent[x] != x) {
        x = parent[x] = parent[parent[x]];
      }
      return x;
    }

    var changed = true;
    while (changed) {
      changed = false;
      bool set(int e, int v) {
        if (st[e] == v) return true;
        if (st[e] != -1) return false;
        st[e] = v;
        changed = true;
        return true;
      }

      for (var p = 0; p < n; p++) {
        var lines = 0, open = 0;
        for (final e in g.incident[p]) {
          if (st[e] == 1) lines++;
          if (st[e] == -1) open++;
        }
        final want = _degree(p);
        if (lines > want || lines + open < want) return false;
        if (open == 0) continue;
        if (lines == want) {
          for (final e in g.incident[p]) {
            if (st[e] == -1) set(e, 0);
          }
        } else if (lines + open == want) {
          for (final e in g.incident[p]) {
            if (st[e] == -1) set(e, 1);
          }
        }
      }
      // Paths so far: no loops, one pair each.
      for (var p = 0; p < n; p++) {
        parent[p] = p;
        pair[p] = dots[p];
      }
      for (var e = 0; e < g.edgeCount; e++) {
        if (st[e] != 1) continue;
        final (a, b) = g.ends(e);
        final ra = find(a), rb = find(b);
        if (ra == rb) return false;
        if (pair[ra] >= 0 && pair[rb] >= 0 && pair[ra] != pair[rb]) return false;
        parent[ra] = rb;
        if (pair[rb] < 0) pair[rb] = pair[ra];
      }
      for (var e = 0; e < g.edgeCount; e++) {
        if (st[e] != -1) continue;
        final (a, b) = g.ends(e);
        final ra = find(a), rb = find(b);
        if (ra == rb || (pair[ra] >= 0 && pair[rb] >= 0 && pair[ra] != pair[rb])) set(e, 0);
      }
    }
    return true;
  }

  bool solved(List<int> st) => !st.contains(-1);

  /// Solves in place with logic up to [tier]; true if every edge is decided.
  bool solve(List<int> st, int tier) {
    if (!propagate(st)) return false;
    if (tier >= 2) {
      var progress = true;
      while (progress && !solved(st)) {
        progress = false;
        for (var e = 0; e < st.length; e++) {
          if (st[e] != -1) continue;
          for (final v in const [1, 0]) {
            if (!propagate(List.of(st)..[e] = v)) {
              st[e] = 1 - v;
              if (!propagate(st)) return false;
              progress = true;
              break;
            }
          }
        }
      }
    }
    return solved(st);
  }

  /// Edge states after logic up to [tier] from scratch.
  List<int> decide(int tier) {
    final st = start();
    solve(st, tier);
    return st;
  }

  /// Number of solutions (up to [limit]), or -1 if the search gets too big.
  int countSolutions({int limit = 2, int budget = 100000}) {
    var nodes = 0, total = 0;
    void rec(List<int> st) {
      if (total >= limit || ++nodes > budget) return;
      if (!propagate(st)) return;
      // Branch next to drawn links first.
      var pick = -1;
      for (var e = 0; e < st.length && pick < 0; e++) {
        if (st[e] != -1) continue;
        final (a, b) = g.ends(e);
        if ([...g.incident[a], ...g.incident[b]].any((f) => st[f] == 1)) pick = e;
      }
      if (pick < 0) pick = st.indexOf(-1);
      if (pick < 0) {
        total++;
        return;
      }
      for (final v in const [1, 0]) {
        rec(List.of(st)..[pick] = v);
      }
    }

    rec(start());
    return nodes > budget ? -1 : total;
  }
}

/// The edges of a puzzle's solution paths.
List<int> linksEdges(LinksPuzzle p) {
  final g = LatticeLoop(p.rows, p.cols);
  final st = List<int>.filled(g.edgeCount, 0);
  for (final path in p.paths) {
    for (var k = 1; k < path.length; k++) {
      st[g.between(path[k - 1], path[k])] = 1;
    }
  }
  return st;
}
