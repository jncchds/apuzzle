import '../../core/explain.dart';
import 'parcels_model.dart';

/// Deductions of [ParcelsSolver], recorded in explain traces. Slots are
/// lattice edges; value 1 is a border, 0 no border (the two cells share a
/// region).
enum ParcelsRule {
  /// The number has all its borders: the other sides are open (args: cell).
  clueDone,

  /// The number needs every side still open (args: cell).
  clueNeed,

  /// Both cells are in one piece already (args: a cell, the other).
  samePiece,

  /// The piece has k cells: closed all round (args: its cells...).
  pieceFull,

  /// A border can't end inside the board: at a point with one border and
  /// one open edge, that edge carries it on (args: point, the border).
  goOn,

  /// At a point whose other edges are no borders, the edge can't be the only
  /// one (args: point).
  noEnd,

  /// The two pieces together would have more than k cells (args: their
  /// size together, then the cells of the first piece, -1, the second's).
  tooBig,

  /// The piece is too small and has one way out (args: its cells...).
  oneWayOut,

  /// Every region of k cells the piece can grow into has the edge as a
  /// border, or inside (args: the piece's cells...).
  everyWay,

  /// A number gets too many borders, or too few (args: cell).
  failClue,

  /// A piece has more than k cells (args: its cells...).
  failBig,

  /// A border ends inside the board (args: point).
  failEnd,

  /// A border runs inside one piece (args: a cell, the other).
  failInside,

  /// An area closed off by borders isn't a whole number of regions (args:
  /// its size, then its cells...).
  failArea,

  /// The piece can't grow into a region of k cells (args: its cells...).
  failNoWay,
}

/// Knowledge per lattice edge: -1 open, 0 no border, 1 border (the outline is
/// a border from the start). A piece is a group of cells joined by edges
/// known to be no border. Tiers:
/// 1 = numbers (all borders there, or every open side needed), borders
/// never end inside the board (at a point inside, never just one), cells of one
/// piece share a region, a piece of k cells is closed, two pieces too big
/// together are split, a piece with one way out takes it, and an area
/// closed off must hold whole regions;
/// and every way to grow a piece into a region of k cells (connected, whole
/// pieces, numbers inside exactly right) for pieces with at most [fewWays]
/// of them: edges that are borders in all of them, or inside all of them;
/// 2 = + the same for pieces with any number of ways;
/// 3 = + probing (assume an edge, refute it with tier 2).
class ParcelsSolver {
  ParcelsSolver(this.p) : geo = p.geo;

  final ParcelsPuzzle p;
  final ParcelsGeo geo;

  int get k => p.k;

  /// Tier 1 only looks at pieces with this many ways to grow, or fewer.
  static const fewWays = 8;

  /// Lattice points inside the board (four edges, none on the outline).
  late final List<int> _points = [
    for (var r = 1; r < geo.rows; r++)
      for (var c = 1; c < geo.cols; c++) r * (geo.cols + 1) + c,
  ];

  List<int> start() => [for (var e = 0; e < geo.g.edgeCount; e++) geo.isOutline(e) ? 1 : -1];

  List<int> _cellArgs(List<int> cells) => [...cells]..sort();

  /// Sets edge [e] to [v]; false when it is the other already.
  bool _set(
    List<int> st,
    int e,
    int v,
    ExplainTrace? t,
    ParcelsRule rule, {
    List<int> premises = const [],
    List<int> args = const [],
  }) {
    if (st[e] == v) return true;
    if (st[e] != -1) return false;
    st[e] = v;
    t?.fact(e, v, rule.index, premises: premises, args: args);
    return true;
  }

  bool _fail(ExplainTrace? t, ParcelsRule rule, {List<int> premises = const [], List<int> args = const []}) {
    t?.fail(rule.index, premises: premises, args: args);
    return false;
  }

  /// Pieces: the piece of every cell and the cells of every piece.
  (List<int>, List<List<int>>) pieces(List<int> st) => geo.groups((e) => st[e] != 0);

  /// The no-border edges inside [cells] (what makes them one piece).
  List<int> _joins(List<int> st, List<int> cells) => [
    for (final i in cells)
      for (final (j, e) in geo.links[i])
        if (i < j && st[e] == 0) e,
  ];

  /// The no-border edges on the way from cell [a] to cell [b] in one piece.
  List<int> _path(List<int> st, int a, int b) {
    final from = <int, (int, int)>{a: (-1, -1)};
    final queue = [a];
    for (var q = 0; q < queue.length && !from.containsKey(b); q++) {
      for (final (j, e) in geo.links[queue[q]]) {
        if (st[e] == 0 && !from.containsKey(j)) {
          from[j] = (queue[q], e);
          queue.add(j);
        }
      }
    }
    final out = <int>[];
    for (var x = b; x != a && from.containsKey(x);) {
      final (prev, e) = from[x]!;
      out.add(e);
      x = prev;
    }
    return out;
  }

  /// Tier 1 until nothing changes; false on a contradiction.
  bool _basic(List<int> st, ExplainTrace? t) {
    for (var changed = true; changed;) {
      changed = false;
      // Numbers.
      for (var i = 0; i < geo.n; i++) {
        final want = p.clues[i];
        if (want == null) continue;
        final s = geo.sides[i];
        var b = 0, open = 0;
        for (final e in s) {
          if (st[e] == 1) b++;
          if (st[e] == -1) open++;
        }
        final known = [
          for (final e in s)
            if (st[e] != -1) e,
        ];
        if (b > want || b + open < want) return _fail(t, ParcelsRule.failClue, premises: known, args: [i]);
        if (open == 0) continue;
        final v = b == want ? 0 : (b + open == want ? 1 : -1);
        if (v < 0) continue;
        for (final e in s) {
          if (st[e] == -1) {
            _set(st, e, v, t, v == 0 ? ParcelsRule.clueDone : ParcelsRule.clueNeed, premises: known, args: [i]);
          }
        }
        changed = true;
      }
      if (changed) continue;

      // Points inside the board: never just one border.
      for (final pt in _points) {
        final es = geo.g.incident[pt];
        var b = 0, open = 0, at = -1, line = -1;
        for (final e in es) {
          if (st[e] == 1) {
            b++;
            line = e;
          }
          if (st[e] == -1) {
            open++;
            at = e;
          }
        }
        if (open > 1 || b > 1) continue;
        final others = [
          for (final e in es)
            if (e != at) e,
        ];
        if (open == 0) {
          if (b == 1) return _fail(t, ParcelsRule.failEnd, premises: others, args: [pt]);
          continue;
        }
        if (b == 1) {
          _set(st, at, 1, t, ParcelsRule.goOn, premises: others, args: [pt, line]);
        } else {
          _set(st, at, 0, t, ParcelsRule.noEnd, premises: others, args: [pt]);
        }
        changed = true;
      }
      if (changed) continue;

      // Pieces.
      final (of, all) = pieces(st);
      for (final cells in all) {
        if (cells.length > k) {
          return _fail(t, ParcelsRule.failBig, premises: _joins(st, cells), args: _cellArgs(cells));
        }
        final out = <int>[];
        for (final i in cells) {
          for (final (j, e) in geo.links[i]) {
            if (of[j] == of[i]) {
              if (i > j || st[e] == 0) continue;
              final path = _path(st, i, j);
              if (st[e] == 1) {
                return _fail(t, ParcelsRule.failInside, premises: [e, ...path], args: [i, j]);
              }
              _set(st, e, 0, t, ParcelsRule.samePiece, premises: path, args: [i, j]);
              changed = true;
            } else if (st[e] == -1) {
              out.add(e);
            }
          }
        }
        if (changed) break;
        if (cells.length == k) {
          if (out.isEmpty) continue;
          final why = _joins(st, cells);
          for (final e in out) {
            _set(st, e, 1, t, ParcelsRule.pieceFull, premises: why, args: _cellArgs(cells));
          }
          changed = true;
          break;
        }
        if (out.length == 1) {
          final why = [..._joins(st, cells), for (final i in cells) ...geo.sides[i].where((e) => st[e] == 1)];
          _set(st, out.first, 0, t, ParcelsRule.oneWayOut, premises: why, args: _cellArgs(cells));
          changed = true;
          break;
        }
      }
      if (changed) continue;
      for (final e in geo.inner) {
        if (st[e] != -1) continue;
        final (a, b) = geo.cellsOf[e];
        final pa = all[of[a]], pb = all[of[b]];
        if (pa.length + pb.length <= k) continue;
        _set(
          st,
          e,
          1,
          t,
          ParcelsRule.tooBig,
          premises: [..._joins(st, pa), ..._joins(st, pb)],
          args: [pa.length + pb.length, ..._cellArgs(pa), -1, ..._cellArgs(pb)],
        );
        changed = true;
      }
      if (changed) continue;

      // Areas closed off by borders.
      for (final area in geo.groups((e) => st[e] == 1).$2) {
        if (area.length % k == 0) continue;
        final rim = {
          for (final i in area)
            for (final e in geo.sides[i])
              if (st[e] == 1 && !geo.isOutline(e)) e,
        }.toList();
        return _fail(t, ParcelsRule.failArea, premises: rim, args: [area.length, ..._cellArgs(area)]);
      }
    }
    return true;
  }

  /// Counts every region of k cells that piece [piece] can grow into
  /// (connected, whole pieces, no border inside, numbers inside exactly
  /// right), and per open edge in [inside] / [rim] how many of them have it
  /// inside or as a border. -1 past [cap] regions.
  int countWays(
    List<int> st,
    List<int> of,
    List<List<int>> all,
    int piece,
    List<int> inside,
    List<int> rim, {
    int cap = 6000,
  }) {
    final inRegion = List<bool>.filled(geo.n, false);
    final members = <int>[];
    final seen = <int>{piece};
    // How many of every cell's sides lie inside the region.
    final insideSides = List<int>.filled(geo.n, 0);
    var ways = 0;

    bool tooMany(int x) => p.clues[x] != null && insideSides[x] > 4 - p.clues[x]!;

    bool add(int q) {
      var ok = true;
      for (final i in all[q]) {
        inRegion[i] = true;
        members.add(i);
      }
      for (final i in all[q]) {
        for (final (j, e) in geo.links[i]) {
          if (!inRegion[j]) continue;
          insideSides[i]++;
          if (of[j] != q) {
            insideSides[j]++;
            if (st[e] == 1 || tooMany(j)) ok = false;
          }
        }
        if (tooMany(i)) ok = false;
      }
      return ok;
    }

    void remove(int q) {
      for (final i in all[q]) {
        for (final (j, _) in geo.links[i]) {
          if (!inRegion[j]) continue;
          insideSides[i]--;
          if (of[j] != q) insideSides[j]--;
        }
      }
      for (final i in all[q]) {
        inRegion[i] = false;
      }
      members.length -= all[q].length;
    }

    void found() {
      for (final i in members) {
        if (p.clues[i] case final want? when insideSides[i] != 4 - want) return;
      }
      ways++;
      for (final i in members) {
        for (final (j, e) in geo.links[i]) {
          if (st[e] != -1) continue;
          if (!inRegion[j]) {
            rim[e]++;
          } else if (i < j) {
            inside[e]++;
          }
        }
      }
    }

    // Redelmeier's enumeration over pieces: each set of pieces once.
    void grow(List<int> untried) {
      if (members.length == k) {
        found();
        return;
      }
      for (var x = 0; x < untried.length && ways <= cap; x++) {
        final q = untried[x];
        if (members.length + all[q].length > k) continue;
        final rest = untried.sublist(x + 1);
        final added = <int>[];
        if (add(q)) {
          for (final i in all[q]) {
            for (final (j, e) in geo.links[i]) {
              final r = of[j];
              if (st[e] != 1 && !inRegion[j] && seen.add(r)) {
                added.add(r);
                rest.add(r);
              }
            }
          }
          grow(rest);
          seen.removeAll(added);
        }
        remove(q);
      }
    }

    if (!add(piece)) return 0;
    final untried = <int>[];
    for (final i in all[piece]) {
      for (final (j, e) in geo.links[i]) {
        if (st[e] != 1 && !inRegion[j] && seen.add(of[j])) untried.add(of[j]);
      }
    }
    grow(untried);
    return ways > cap ? -1 : ways;
  }

  /// Tier 2: one pass over the pieces; null on a contradiction, else whether
  /// anything changed.
  bool? _everyWay(List<int> st, int cap, ExplainTrace? t) {
    final (of, all) = pieces(st);
    // Biggest pieces first: they have the fewest ways.
    final order = [for (var q = 0; q < all.length; q++) q]..sort((a, b) => all[b].length.compareTo(all[a].length));
    var changed = false;
    final inside = List<int>.filled(st.length, 0), rim = List<int>.filled(st.length, 0);
    for (final q in order) {
      final cells = all[q];
      if (cells.length >= k) continue;
      inside.fillRange(0, inside.length, 0);
      rim.fillRange(0, rim.length, 0);
      final ways = countWays(st, of, all, q, inside, rim, cap: cap);
      if (ways < 0) continue;
      if (ways == 0) {
        _fail(t, ParcelsRule.failNoWay, premises: _near(st, cells), args: _cellArgs(cells));
        return null;
      }
      List<int>? why;
      for (var e = 0; e < st.length; e++) {
        if (st[e] != -1) continue;
        final v = inside[e] == ways ? 0 : (rim[e] == ways ? 1 : -1);
        if (v < 0) continue;
        why ??= _near(st, cells);
        _set(st, e, v, t, ParcelsRule.everyWay, premises: why, args: _cellArgs(cells));
        changed = true;
      }
    }
    return changed;
  }

  /// Known edges within k − 1 steps of [cells]: what limits their regions.
  List<int> _near(List<int> st, List<int> cells) {
    final dist = <int, int>{for (final i in cells) i: 0};
    final queue = [...cells];
    for (var q = 0; q < queue.length; q++) {
      final d = dist[queue[q]]!;
      if (d >= k - cells.length) continue;
      for (final (j, e) in geo.links[queue[q]]) {
        if (st[e] != 1 && !dist.containsKey(j)) {
          dist[j] = d + 1;
          queue.add(j);
        }
      }
    }
    return {
      for (final i in dist.keys)
        for (final e in geo.sides[i])
          if (st[e] != -1 && !geo.isOutline(e)) e,
    }.toList();
  }

  /// Applies the rules of [tier] (1 or 2) until nothing changes; false on a
  /// contradiction.
  bool propagate(List<int> st, int tier, [ExplainTrace? t]) {
    while (true) {
      if (!_basic(st, t)) return false;
      final r = _everyWay(st, tier < 2 ? fewWays : 6000, t);
      if (r == null) return false;
      if (!r) return true;
    }
  }

  bool solved(List<int> st) => !st.contains(-1);

  /// Solves with [tier] (3 probes); true when every edge is known.
  bool solve(List<int> st, int tier) {
    if (!propagate(st, tier.clamp(1, 2))) return false;
    if (tier < 3) return solved(st);
    var progress = true;
    while (progress && !solved(st)) {
      progress = false;
      // Refutations by tier 1 first: cheaper, and tier 2 finds them too.
      for (final inner in const [1, 2]) {
        for (var e = 0; e < st.length; e++) {
          if (st[e] != -1) continue;
          for (final v in const [1, 0]) {
            final copy = List.of(st)..[e] = v;
            if (!propagate(copy, inner)) {
              st[e] = 1 - v;
              if (!propagate(st, 2)) return false;
              progress = true;
              break;
            }
          }
        }
        if (progress) break;
      }
    }
    return solved(st);
  }

  /// The lowest tier that solves the board from [st], or 4 if none does.
  int grade(List<int> st) {
    for (var tier = 1; tier <= 3; tier++) {
      if (solve(List.of(st), tier)) return tier;
    }
    return 4;
  }

  /// Solutions from [st], up to [limit].
  int countSolutions(List<int> st, {int limit = 2}) {
    var found = 0;
    void dfs(List<int> s) {
      if (found >= limit || !propagate(s, 2)) return;
      final e = _branch(s);
      if (e < 0) {
        found++;
        return;
      }
      for (final v in const [1, 0]) {
        dfs(List.of(s)..[e] = v);
        if (found >= limit) return;
      }
    }

    dfs(List.of(st));
    return found;
  }

  /// An open edge of the smallest unfinished piece, or -1.
  int _branch(List<int> st) {
    final (_, all) = pieces(st);
    var best = -1, bestSize = 1 << 20;
    for (final cells in all) {
      if (cells.length >= bestSize) continue;
      for (final i in cells) {
        for (final e in geo.sides[i]) {
          if (st[e] == -1) {
            best = e;
            bestSize = cells.length;
            break;
          }
        }
        if (bestSize == cells.length) break;
      }
    }
    if (best >= 0) return best;
    return st.indexOf(-1);
  }
}
