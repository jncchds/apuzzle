import '../../core/lattice_loop.dart';
import 'rails_model.dart';

/// Knowledge as one list: per edge (-1 unknown, 0 no track, 1 track), then per
/// cell (-1 unknown, 0 empty, 1 on the track).
/// Tier 1: piece rules (0 or 2 ends per cell), row/column counts and no loops
/// or early closing of the track. Tier 2: + probing.
class RailsSolver {
  RailsSolver(this.p) : g = p.lattice, n = p.rows * p.cols;

  final RailsPuzzle p;
  final LatticeLoop g;
  final int n;
  bool _changed = false;

  int get _ec => g.edgeCount;

  List<int> initial() {
    final st = List<int>.filled(_ec + n, -1);
    for (var i = 0; i < n; i++) {
      if (!p.given[i]) continue;
      st[_ec + i] = 1;
      for (final e in g.incident[i]) {
        st[e] = p.lines[e] ? 1 : 0;
      }
    }
    return st;
  }

  bool _set(List<int> st, int k, int v) {
    if (st[k] == v) return true;
    if (st[k] != -1) return false;
    st[k] = v;
    _changed = true;
    return true;
  }

  bool propagate(List<int> st) {
    do {
      _changed = false;
      if (!_pieces(st) || !_counts(st)) return false;
      if (!_changed && !_connect(st)) return false;
    } while (_changed);
    return true;
  }

  bool _pieces(List<int> st) {
    for (var i = 0; i < n; i++) {
      var lines = p.stubs(i), open = 0;
      for (final e in g.incident[i]) {
        if (st[e] == 1) lines++;
        if (st[e] == -1) open++;
      }
      if (lines > 2) return false;
      if (lines > 0 && !_set(st, _ec + i, 1)) return false;
      if (lines + open < 2) {
        if (lines > 0 || !_set(st, _ec + i, 0)) return false;
      }
      if (open == 0) continue;
      final used = st[_ec + i];
      if (used == 0 || lines == 2) {
        for (final e in g.incident[i]) {
          if (st[e] == -1) _set(st, e, 0);
        }
      } else if (used == 1 && lines + open == 2) {
        for (final e in g.incident[i]) {
          if (st[e] == -1) _set(st, e, 1);
        }
      }
    }
    return true;
  }

  bool _counts(List<int> st) {
    bool line(List<int> cells, int want) {
      var yes = 0, open = 0;
      for (final i in cells) {
        if (st[_ec + i] == 1) yes++;
        if (st[_ec + i] == -1) open++;
      }
      if (yes > want || yes + open < want) return false;
      if (open == 0) return true;
      if (yes == want || yes + open == want) {
        for (final i in cells) {
          if (st[_ec + i] == -1) _set(st, _ec + i, yes == want ? 0 : 1);
        }
      }
      return true;
    }

    for (var r = 0; r < p.rows; r++) {
      if (!line([for (var c = 0; c < p.cols; c++) r * p.cols + c], p.rowCounts[r])) return false;
    }
    for (var c = 0; c < p.cols; c++) {
      if (!line([for (var r = 0; r < p.rows; r++) r * p.cols + c], p.colCounts[c])) return false;
    }
    return true;
  }

  /// No loops, and the track only closes (entry joined to exit) when it's done.
  /// The stubs meet in an "outside" node [n], so the finished track is a loop
  /// through it.
  bool _connect(List<int> st) {
    final parent = List<int>.generate(n + 1, (i) => i);
    int find(int x) {
      while (parent[x] != x) {
        x = parent[x] = parent[parent[x]];
      }
      return x;
    }

    parent[find(p.entry)] = find(n);
    parent[find(p.exit)] = find(n);
    var closed = false;
    for (var e = 0; e < _ec; e++) {
      if (st[e] != 1) continue;
      final (a, b) = g.ends(e);
      final ra = find(a), rb = find(b);
      if (ra == rb) {
        if (ra != find(n)) return false; // a loop apart from the track
        closed = true;
      } else {
        parent[ra] = rb;
      }
    }
    // Cells on the part joined to the outside.
    final out = find(n);
    var outCells = 0;
    var otherLines = false;
    for (var i = 0; i < n; i++) {
      if (find(i) == out) {
        outCells++;
      } else if (g.incident[i].any((e) => st[e] == 1)) {
        otherLines = true;
      }
    }
    if (closed) {
      // The track is complete: nothing else is on it.
      if (otherLines || outCells != p.length) return false;
      for (var k = 0; k < st.length; k++) {
        if (st[k] == -1) _set(st, k, k < _ec ? 0 : (find(k - _ec) == out ? 1 : 0));
      }
      return true;
    }
    for (var e = 0; e < _ec; e++) {
      if (st[e] != -1) continue;
      final (a, b) = g.ends(e);
      final ra = find(a);
      if (ra != find(b)) continue;
      // Closing a loop apart from the track, or finishing it too early.
      if (ra != out || otherLines || outCells != p.length) _set(st, e, 0);
    }
    return true;
  }

  bool solved(List<int> st) => !st.contains(-1);

  List<bool> linesOf(List<int> st) => [for (var e = 0; e < _ec; e++) st[e] == 1];

  /// Fills in [st] using logic up to [tier]; true if it gets fully determined.
  bool solve(List<int> st, int tier) {
    if (!propagate(st)) return false;
    if (tier >= 2) {
      var progress = true;
      while (progress && !solved(st)) {
        progress = false;
        for (var k = 0; k < st.length; k++) {
          if (st[k] != -1) continue;
          for (final v in const [1, 0]) {
            final t = List.of(st)..[k] = v;
            if (!propagate(t)) {
              st[k] = 1 - v;
              if (!propagate(st)) return false;
              progress = true;
              break;
            }
          }
        }
      }
    }
    return solved(st) && railsValid(p, linesOf(st));
  }

  int countSolutions(List<int> st, {int limit = 2}) {
    final t = List.of(st);
    if (!propagate(t)) return 0;
    // Branch next to the track first (keeps the search local).
    var pick = -1;
    for (var e = 0; e < _ec && pick < 0; e++) {
      if (t[e] != -1) continue;
      final (a, b) = g.ends(e);
      if ([...g.incident[a], ...g.incident[b]].any((f) => t[f] == 1)) pick = e;
    }
    if (pick < 0) pick = t.indexOf(-1);
    if (pick < 0) return railsValid(p, linesOf(t)) ? 1 : 0;
    var total = 0;
    for (final v in const [1, 0]) {
      if (total >= limit) break;
      total += countSolutions(List.of(t)..[pick] = v, limit: limit - total);
    }
    return total;
  }
}
