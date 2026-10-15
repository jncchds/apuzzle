import 'dart:math';

import '../../core/explain.dart';
import '../../core/grid_graph.dart';
import 'chambers_model.dart';

/// What a traced [ChambersSolver.propagate] records ([Fact.rule]); [Fact.value]
/// is [chambersShade] or [chambersKeep]. Args name the cells or the room
/// (and its number) a rule is about.
enum ChambersRule {
  touch,
  full,
  need,
  span,
  walled,
  ways,
  cut,
  failTouch,
  failMany,
  failFew,
  failSpan,
  failWalled,
  failWays,
  failApart,
}

/// Chambers logic on cell states: -1 undecided, [chambersShade], [chambersKeep].
/// Tier 1: a shaded cell keeps its neighbours, a room with all its shaded
/// cells keeps the rest (one with just enough open cells shades them), a run
/// across two borders with one open cell left shades it, and a cell that
/// would wall in a neighbour stays. Tier 2: + every way to shade a room's
/// cells (no two touching, every run across two borders through it broken)
/// and cells whose shading would cut the cells left apart. Tier 3: + probing.
class ChambersSolver {
  ChambersSolver(this.p) : n = p.n, nb = orthNeighbors(p.n, p.n), spans = chambersSpans(p.n, p.roomOf) {
    roomCells = [for (final r in p.rooms) r.cells(n)];
    spansOf = List.generate(p.rooms.length, (_) => <int>[]);
    for (var s = 0; s < spans.length; s++) {
      for (final k in {for (final i in spans[s]) p.roomOf[i]}) {
        spansOf[k].add(s);
      }
    }
  }

  final ChambersPuzzle p;
  final int n;
  final List<List<int>> nb;
  final List<List<int>> spans;
  late final List<List<int>> roomCells;

  /// Spans through each room.
  late final List<List<int>> spansOf;

  List<int> start({List<int> givens = const []}) {
    final st = List<int>.filled(n * n, -1);
    for (final i in givens) {
      st[i] = p.shaded[i] ? chambersShade : chambersKeep;
    }
    return st;
  }

  /// Applies logic up to [tier] (1 or 2) in place; false on a contradiction.
  /// With [t], every deduction is recorded (see [ChambersRule]).
  bool propagate(List<int> st, [int tier = 2, ExplainTrace? t]) {
    var changed = true;
    void set(int i, int v, ChambersRule rule, List<int> premises, [List<int> args = const []]) {
      if (st[i] != -1) return;
      st[i] = v;
      changed = true;
      t?.fact(i, v, rule.index, premises: premises, args: args);
    }

    while (changed) {
      changed = false;
      for (var i = 0; i < n * n; i++) {
        if (st[i] != chambersShade) continue;
        for (final j in nb[i]) {
          if (st[j] == chambersShade) {
            t?.fail(ChambersRule.failTouch.index, premises: [i, j], args: [i, j]);
            return false;
          }
          set(j, chambersKeep, ChambersRule.touch, [i], [i]);
        }
      }
      for (var k = 0; k < p.rooms.length; k++) {
        final want = p.clues[k];
        if (want == null) continue;
        final cells = roomCells[k];
        var dark = 0, open = 0;
        for (final i in cells) {
          if (st[i] == chambersShade) dark++;
          if (st[i] == -1) open++;
        }
        if (dark > want) {
          t?.fail(ChambersRule.failMany.index, premises: cells, args: [k, want]);
          return false;
        }
        if (dark + open < want) {
          t?.fail(ChambersRule.failFew.index, premises: cells, args: [k, want]);
          return false;
        }
        if (open == 0) continue;
        if (dark == want) {
          for (final i in cells) {
            set(i, chambersKeep, ChambersRule.full, cells, [k, want]);
          }
        } else if (dark + open == want) {
          for (final i in cells) {
            set(i, chambersShade, ChambersRule.need, cells, [k, want]);
          }
        }
      }
      for (final span in spans) {
        var open = -1, opens = 0;
        for (final i in span) {
          if (st[i] == chambersShade) {
            opens = -1;
            break;
          }
          if (st[i] == -1) {
            open = i;
            opens++;
          }
        }
        if (opens == 0) {
          t?.fail(ChambersRule.failSpan.index, premises: span, args: [span.first, span.last]);
          return false;
        }
        if (opens == 1) set(open, chambersShade, ChambersRule.span, span, [span.first, span.last]);
      }
      if (changed) continue;
      // A cell left with one way out keeps it.
      for (var y = 0; y < n * n; y++) {
        if (st[y] == chambersShade) continue;
        final exits = [
          for (final j in nb[y])
            if (st[j] != chambersShade) j,
        ];
        if (exits.isEmpty) {
          t?.fail(ChambersRule.failWalled.index, premises: [y, ...nb[y]], args: [y]);
          return false;
        }
        if (exits.length == 1 && st[exits.first] == -1) {
          set(exits.first, chambersKeep, ChambersRule.walled, [y, ...nb[y]], [y]);
        }
      }
      if (changed) continue;
      if (tier >= 2) {
        for (var k = 0; k < p.rooms.length && !changed; k++) {
          if (!_ways(st, k, set, t)) return false;
        }
        if (changed) continue;
      }
      if (tier >= 2 || !st.contains(-1)) {
        if (!_cuts(st, tier >= 2, set, t)) return false;
      }
    }
    return true;
  }

  /// Every way to shade the open cells of room [k] up to its number, with
  /// no two touching and every run across two borders through it broken;
  /// cells that all of them shade or all keep are set.
  bool _ways(List<int> st, int k, void Function(int, int, ChambersRule, List<int>, [List<int>]) set, ExplainTrace? t) {
    final want = p.clues[k];
    if (want == null) return true;
    final cells = roomCells[k];
    final open = [
      for (final i in cells)
        if (st[i] == -1) i,
    ];
    if (open.isEmpty) return true;
    final need = want - cells.where((i) => st[i] == chambersShade).length;
    final at = {for (var j = 0; j < open.length; j++) open[j]: j};
    // Runs that only this room's open cells can still break, as bit masks.
    final musts = <int>[];
    final used = <int>[];
    for (final s in spansOf[k]) {
      var mask = 0, outside = true;
      for (final i in spans[s]) {
        final j = at[i];
        if (j != null) {
          mask |= 1 << j;
        } else if (st[i] != chambersKeep) {
          outside = false;
          break;
        }
      }
      if (outside && mask != 0) {
        musts.add(mask);
        used.addAll(spans[s]);
      }
    }
    final touch = [
      for (final i in open)
        [
          for (final j in nb[i])
            if (at[j] != null) at[j]!,
        ].fold(0, (m, j) => m | 1 << j),
    ];
    var all = -1, none = -1, ways = 0, nodes = 0;
    void rec(int j, int chosen, int left) {
      if (++nodes > 50000) return;
      if (left == 0) {
        for (final m in musts) {
          if (m & chosen == 0) return;
        }
        ways++;
        all &= chosen;
        none &= ~chosen;
        return;
      }
      if (open.length - j < left) return;
      if (touch[j] & chosen == 0) rec(j + 1, chosen | 1 << j, left - 1);
      rec(j + 1, chosen, left);
    }

    rec(0, 0, need);
    if (nodes > 50000) return true;
    final premises = t == null ? const <int>[] : [...cells, ...used, for (final i in cells) ...nb[i]];
    if (ways == 0) {
      t?.fail(ChambersRule.failWays.index, premises: premises, args: [k, want]);
      return false;
    }
    for (var j = 0; j < open.length; j++) {
      if (all & 1 << j != 0) set(open[j], chambersShade, ChambersRule.ways, premises, [k, want]);
      if (none & 1 << j != 0) set(open[j], chambersKeep, ChambersRule.ways, premises, [k, want]);
    }
    return true;
  }

  /// Checks that the kept cells can still meet; with [force], keeps every
  /// open cell whose shading would part them.
  bool _cuts(
    List<int> st,
    bool force,
    void Function(int, int, ChambersRule, List<int>, [List<int>]) set,
    ExplainTrace? t,
  ) {
    final root = st.indexOf(chambersKeep);
    if (root < 0) return true;
    final disc = List<int>.filled(n * n, -1), low = List<int>.filled(n * n, 0), sub = List<int>.filled(n * n, 0);
    final forced = <int>[];
    var time = 0;
    void dfs(int u, int parent) {
      disc[u] = low[u] = time++;
      sub[u] = st[u] == chambersKeep ? 1 : 0;
      for (final v in nb[u]) {
        if (st[v] == chambersShade) continue;
        if (disc[v] < 0) {
          dfs(v, u);
          sub[u] += sub[v];
          low[u] = min(low[u], low[v]);
          if (low[v] >= disc[u] && sub[v] > 0 && st[u] == -1) forced.add(u);
        } else if (v != parent) {
          low[u] = min(low[u], disc[v]);
        }
      }
    }

    dfs(root, -1);
    List<int> decided() => [
      for (var i = 0; i < n * n; i++)
        if (st[i] != -1) i,
    ];
    for (var i = 0; i < n * n; i++) {
      if (st[i] == chambersKeep && disc[i] < 0) {
        t?.fail(ChambersRule.failApart.index, premises: decided(), args: [root, i]);
        return false;
      }
    }
    if (force && forced.isNotEmpty) {
      final premises = t == null ? const <int>[] : decided();
      for (final u in forced) {
        set(u, chambersKeep, ChambersRule.cut, premises);
      }
    }
    return true;
  }

  /// Solves in place with logic up to [tier]; false on a contradiction.
  bool solve(List<int> st, int tier) {
    if (!propagate(st, tier.clamp(1, 2))) return false;
    if (tier >= 3) {
      var progress = true;
      while (progress && st.contains(-1)) {
        progress = false;
        for (var i = 0; i < st.length; i++) {
          if (st[i] != -1) continue;
          for (final v in const [chambersShade, chambersKeep]) {
            if (!propagate(List.of(st)..[i] = v)) {
              st[i] = 1 - v;
              if (!propagate(st)) return false;
              progress = true;
              break;
            }
          }
        }
      }
    }
    return true;
  }

  /// Cells logic up to [tier] leaves open from [st0] (all cells + 1 on a
  /// contradiction).
  int slack(int tier, [List<int>? st0]) {
    final st = st0 == null ? start() : List.of(st0);
    if (!solve(st, tier)) return st.length + 1;
    return st.where((x) => x == -1).length;
  }

  /// Lowest tier (1..3) that solves the board from [st0], or 4.
  int grade([List<int>? st0]) {
    for (var t = 1; t <= 3; t++) {
      if (slack(t, st0) == 0) return t;
    }
    return 4;
  }

  /// Number of solutions (up to [limit]), or -1 if the search gets too big.
  int countSolutions({int limit = 2, List<int>? from, int budget = 100000}) {
    var nodes = 0, total = 0;
    void rec(List<int> st) {
      if (total >= limit || ++nodes > budget) return;
      if (!propagate(st)) return;
      final i = st.indexOf(-1);
      if (i < 0) {
        total++;
        return;
      }
      for (final v in const [chambersShade, chambersKeep]) {
        rec(List.of(st)..[i] = v);
      }
    }

    rec(from == null ? start() : List.of(from));
    return nodes > budget ? -1 : total;
  }
}
