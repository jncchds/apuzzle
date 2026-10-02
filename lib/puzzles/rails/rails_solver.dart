import '../../core/explain.dart';
import '../../core/lattice_loop.dart';
import 'rails_model.dart';

/// What a traced [RailsSolver.propagate] records ([Fact.rule]). Slots are
/// edges, then cells ([Fact.value] 1: track / on the track, 0: not). Cell
/// rules have the cell as arg, line rules the line (rows, then columns).
enum RailsRule {
  cellUsed,
  cellEmpty,
  pieceFull,
  pieceEmpty,
  pieceNeed,
  lineDone,
  lineNeed,
  trackDone,
  closeEarly,
  failBranch,
  failDeadEnd,
  failLineMany,
  failLineFew,
  failLoop,
  failClosed,
  failClash,
}

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

  // Tracing: where to record, and the rule behind the next [_set]s.
  ExplainTrace? _t;
  RailsRule _why = RailsRule.cellUsed;
  int _arg = -1;
  List<int>? _premises;

  void _because(RailsRule rule, int arg, [List<int>? premises]) {
    _why = rule;
    _arg = arg;
    _premises = premises;
  }

  /// The slots [rule] about [arg] looks at.
  List<int> premisesOf(RailsRule rule, int arg) => switch (rule) {
    RailsRule.lineDone || RailsRule.lineNeed || RailsRule.failLineMany || RailsRule.failLineFew => [
      for (final i in _line(arg)) _ec + i,
    ],
    _ when arg >= 0 => [...g.incident[arg], _ec + arg],
    _ => const [],
  };

  List<int> _line(int li) => li < p.rows
      ? [for (var c = 0; c < p.cols; c++) li * p.cols + c]
      : [for (var r = 0; r < p.rows; r++) r * p.cols + li - p.rows];

  bool _fail(RailsRule rule, int arg, [List<int>? premises]) {
    _t?.fail(rule.index, premises: premises ?? premisesOf(rule, arg), args: [arg]);
    return false;
  }

  bool _set(List<int> st, int k, int v) {
    if (st[k] == v) return true;
    if (st[k] != -1) return _fail(RailsRule.failClash, k, [k, ...(_premises ?? premisesOf(_why, _arg))]);
    st[k] = v;
    _changed = true;
    _t?.fact(k, v, _why.index, premises: _premises ?? premisesOf(_why, _arg), args: [_arg]);
    return true;
  }

  /// Applies tier-1 logic until nothing changes; false on a contradiction.
  /// With [t], every deduction is recorded (see [RailsRule]).
  bool propagate(List<int> st, [ExplainTrace? t]) {
    final outer = _t;
    _t = t;
    try {
      do {
        _changed = false;
        if (!_pieces(st) || !_counts(st)) return false;
        if (!_changed && !_connect(st)) return false;
      } while (_changed);
      return true;
    } finally {
      _t = outer;
    }
  }

  bool _pieces(List<int> st) {
    for (var i = 0; i < n; i++) {
      var lines = p.stubs(i), open = 0;
      for (final e in g.incident[i]) {
        if (st[e] == 1) lines++;
        if (st[e] == -1) open++;
      }
      if (lines > 2) return _fail(RailsRule.failBranch, i);
      _because(RailsRule.cellUsed, i);
      if (lines > 0 && !_set(st, _ec + i, 1)) return false;
      if (lines + open < 2) {
        if (lines > 0) return _fail(RailsRule.failDeadEnd, i);
        _because(RailsRule.cellEmpty, i);
        if (!_set(st, _ec + i, 0)) return false;
      }
      if (open == 0) continue;
      final used = st[_ec + i];
      if (used == 0 || lines == 2) {
        _because(lines == 2 ? RailsRule.pieceFull : RailsRule.pieceEmpty, i);
        for (final e in g.incident[i]) {
          if (st[e] == -1) _set(st, e, 0);
        }
      } else if (used == 1 && lines + open == 2) {
        _because(RailsRule.pieceNeed, i);
        for (final e in g.incident[i]) {
          if (st[e] == -1) _set(st, e, 1);
        }
      }
    }
    return true;
  }

  bool _counts(List<int> st) {
    bool line(List<int> cells, int want, int li) {
      var yes = 0, open = 0;
      for (final i in cells) {
        if (st[_ec + i] == 1) yes++;
        if (st[_ec + i] == -1) open++;
      }
      if (yes > want || yes + open < want) {
        return _fail(yes > want ? RailsRule.failLineMany : RailsRule.failLineFew, li);
      }
      if (open == 0) return true;
      if (yes == want || yes + open == want) {
        _because(yes == want ? RailsRule.lineDone : RailsRule.lineNeed, li);
        for (final i in cells) {
          if (st[_ec + i] == -1) _set(st, _ec + i, yes == want ? 0 : 1);
        }
      }
      return true;
    }

    for (var r = 0; r < p.rows; r++) {
      if (!line([for (var c = 0; c < p.cols; c++) r * p.cols + c], p.rowCounts[r], r)) return false;
    }
    for (var c = 0; c < p.cols; c++) {
      if (!line([for (var r = 0; r < p.rows; r++) r * p.cols + c], p.colCounts[c], p.rows + c)) return false;
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
        if (ra != find(n)) return _fail(RailsRule.failLoop, -1, _drawn(st)); // a loop apart from the track
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
      if (otherLines || outCells != p.length) return _fail(RailsRule.failClosed, -1, _drawn(st));
      _because(RailsRule.trackDone, -1, _t == null ? null : _drawn(st));
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
      if (ra != out || otherLines || outCells != p.length) {
        _because(RailsRule.closeEarly, -1, _t == null ? null : _drawn(st));
        _set(st, e, 0);
      }
    }
    return true;
  }

  /// Edges with track (premises of the whole-track rules).
  List<int> _drawn(List<int> st) => [
    for (var e = 0; e < _ec; e++)
      if (st[e] == 1) e,
  ];

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
