import 'dart:math';

import '../../core/explain.dart';
import '../../core/grid_graph.dart';
import 'lookout_model.dart';

/// What a traced [LookoutSolver.propagate] records ([Fact.rule]); [Fact.value]
/// is [lookoutShade] or [lookoutKeep]. Args name the number's cell (and
/// its number) or the cells a rule is about.
enum LookoutRule {
  touch,
  reach,
  close,
  walled,
  ways,
  cut,
  failTouch,
  failMany,
  failFew,
  failWalled,
  failWays,
  failApart,
}

/// Lookout logic on cell states: -1 undecided, [lookoutShade], [lookoutKeep].
/// Tier 1: a shaded cell keeps its neighbours; a number that can't see
/// enough in the other directions sees at least that far in this one
/// (`reach`), and one that already sees all it may in a direction has its
/// view stopped there (`close`); a cell that would wall in a neighbour
/// stays. Tier 2: + every way to split a number's view among the four
/// directions (each view ending at the edge or at a cell that can be
/// shaded), and cells whose shading would cut the cells left apart.
/// Tier 3: + probing.
class LookoutSolver {
  LookoutSolver(this.p) : n = p.n, nb = orthNeighbors(p.n, p.n), rays = lookoutRaysOf(p.n) {
    numbers = [
      for (var i = 0; i < n * n; i++)
        if (p.clues[i] != null) i,
    ];
  }

  final LookoutPuzzle p;
  final int n;
  final List<List<int>> nb;
  final List<List<List<int>>> rays;
  late final List<int> numbers;

  List<int> start() {
    final st = List<int>.filled(n * n, -1);
    for (final i in numbers) {
      st[i] = lookoutKeep;
    }
    return st;
  }

  /// Applies logic up to [tier] (1 or 2) in place; false on a contradiction.
  /// With [t], every deduction is recorded (see [LookoutRule]).
  bool propagate(List<int> st, [int tier = 2, ExplainTrace? t]) {
    var changed = true;
    void set(int i, int v, LookoutRule rule, List<int> premises, [List<int> args = const []]) {
      if (st[i] != -1) return;
      st[i] = v;
      changed = true;
      t?.fact(i, v, rule.index, premises: premises, args: args);
    }

    while (changed) {
      changed = false;
      for (var i = 0; i < n * n; i++) {
        if (st[i] != lookoutShade) continue;
        for (final j in nb[i]) {
          if (st[j] == lookoutShade) {
            t?.fail(LookoutRule.failTouch.index, premises: [i, j], args: [i, j]);
            return false;
          }
          set(j, lookoutKeep, LookoutRule.touch, [i], [i]);
        }
      }
      for (final c in numbers) {
        if (!_bounds(st, c, set, t)) return false;
      }
      if (changed) continue;
      // A cell left with one way out keeps it.
      for (var y = 0; y < n * n; y++) {
        if (st[y] == lookoutShade) continue;
        final exits = [
          for (final j in nb[y])
            if (st[j] != lookoutShade) j,
        ];
        if (exits.isEmpty) {
          t?.fail(LookoutRule.failWalled.index, premises: [y, ...nb[y]], args: [y]);
          return false;
        }
        if (exits.length == 1 && st[exits.first] == -1) {
          set(exits.first, lookoutKeep, LookoutRule.walled, [y, ...nb[y]], [y]);
        }
      }
      if (changed) continue;
      if (tier >= 2) {
        for (final c in numbers) {
          if (!_ways(st, c, set, t)) return false;
          if (changed) break;
        }
        if (changed) continue;
      }
      if (tier >= 2 || !st.contains(-1)) {
        if (!_cuts(st, tier >= 2, set, t)) return false;
      }
    }
    return true;
  }

  /// The cells along each ray of [c] the view surely reaches (leading kept
  /// cells) and may reach (leading cells not shaded).
  (List<int>, List<int>) _reach(List<int> st, int c) {
    final lo = [0, 0, 0, 0], hi = [0, 0, 0, 0];
    for (var d = 0; d < 4; d++) {
      final ray = rays[c][d];
      var k = 0;
      while (k < ray.length && st[ray[k]] == lookoutKeep) {
        k++;
      }
      lo[d] = k;
      while (k < ray.length && st[ray[k]] != lookoutShade) {
        k++;
      }
      hi[d] = k;
    }
    return (lo, hi);
  }

  /// The cells a rule about [c] looks at: its view as far as it may reach,
  /// and the shaded cells that stop it.
  List<int> _view(List<int> st, int c, List<int> hi) => [
    c,
    for (var d = 0; d < 4; d++) ...rays[c][d].take(hi[d] + 1),
  ];

  bool _bounds(
    List<int> st,
    int c,
    void Function(int, int, LookoutRule, List<int>, [List<int>]) set,
    ExplainTrace? t,
  ) {
    final want = p.clues[c]! - 1;
    final (lo, hi) = _reach(st, c);
    final sumLo = lo.reduce((a, b) => a + b), sumHi = hi.reduce((a, b) => a + b);
    List<int> view() => t == null ? const [] : _view(st, c, hi);
    if (sumLo > want) {
      t?.fail(LookoutRule.failMany.index, premises: view(), args: [c, want + 1]);
      return false;
    }
    if (sumHi < want) {
      t?.fail(LookoutRule.failFew.index, premises: view(), args: [c, want + 1]);
      return false;
    }
    for (var d = 0; d < 4; d++) {
      final ray = rays[c][d];
      final need = want - (sumHi - hi[d]);
      if (need > lo[d]) {
        final premises = view();
        for (var k = lo[d]; k < need; k++) {
          set(ray[k], lookoutKeep, LookoutRule.reach, premises, [c, want + 1]);
        }
      }
      final cap = want - (sumLo - lo[d]);
      if (cap == lo[d] && lo[d] < ray.length && st[ray[lo[d]]] == -1) {
        set(ray[lo[d]], lookoutShade, LookoutRule.close, view(), [c, want + 1]);
      }
    }
    return true;
  }

  /// Every way to split the view of [c] among its four directions, each
  /// ending at the edge or at a cell that can still be shaded; cells every
  /// way sees stay, cells every way stops at are shaded.
  bool _ways(
    List<int> st,
    int c,
    void Function(int, int, LookoutRule, List<int>, [List<int>]) set,
    ExplainTrace? t,
  ) {
    final want = p.clues[c]! - 1;
    final (lo, hi) = _reach(st, c);
    final lengths = [
      for (var d = 0; d < 4; d++)
        [
          for (var k = lo[d]; k <= hi[d]; k++)
            if (k == rays[c][d].length || st[rays[c][d][k]] != lookoutKeep) k,
        ],
    ];
    final seen = List.generate(4, (_) => <int>{});
    void rec(int d, int left, List<int> pick) {
      if (d == 3) {
        if (!lengths[3].contains(left)) return;
        pick.add(left);
        for (var e = 0; e < 4; e++) {
          seen[e].add(pick[e]);
        }
        pick.removeLast();
        return;
      }
      for (final k in lengths[d]) {
        if (k > left) break;
        pick.add(k);
        rec(d + 1, left - k, pick);
        pick.removeLast();
      }
    }

    rec(0, want, []);
    final premises = t == null ? const <int>[] : _view(st, c, hi);
    if (seen[0].isEmpty) {
      t?.fail(LookoutRule.failWays.index, premises: premises, args: [c, want + 1]);
      return false;
    }
    for (var d = 0; d < 4; d++) {
      final ray = rays[c][d];
      final least = seen[d].reduce(min);
      for (var k = lo[d]; k < least; k++) {
        set(ray[k], lookoutKeep, LookoutRule.ways, premises, [c, want + 1]);
      }
      if (seen[d].length == 1 && least < ray.length) {
        set(ray[least], lookoutShade, LookoutRule.ways, premises, [c, want + 1]);
      }
    }
    return true;
  }

  /// Checks that the kept cells can still meet; with [force], keeps every
  /// open cell whose shading would part them.
  bool _cuts(
    List<int> st,
    bool force,
    void Function(int, int, LookoutRule, List<int>, [List<int>]) set,
    ExplainTrace? t,
  ) {
    final root = st.indexOf(lookoutKeep);
    if (root < 0) return true;
    final disc = List<int>.filled(n * n, -1), low = List<int>.filled(n * n, 0), sub = List<int>.filled(n * n, 0);
    final forced = <int>[];
    var time = 0;
    void dfs(int u, int parent) {
      disc[u] = low[u] = time++;
      sub[u] = st[u] == lookoutKeep ? 1 : 0;
      for (final v in nb[u]) {
        if (st[v] == lookoutShade) continue;
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
      if (st[i] == lookoutKeep && disc[i] < 0) {
        t?.fail(LookoutRule.failApart.index, premises: decided(), args: [root, i]);
        return false;
      }
    }
    if (force && forced.isNotEmpty) {
      final premises = t == null ? const <int>[] : decided();
      for (final u in forced) {
        set(u, lookoutKeep, LookoutRule.cut, premises);
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
          for (final v in const [lookoutShade, lookoutKeep]) {
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
      for (final v in const [lookoutShade, lookoutKeep]) {
        rec(List.of(st)..[i] = v);
      }
    }

    rec(from == null ? start() : List.of(from));
    return nodes > budget ? -1 : total;
  }
}
