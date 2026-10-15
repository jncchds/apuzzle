import 'dart:math';

import '../../core/explain.dart';
import '../../core/grid_graph.dart';
import 'pebbles_model.dart';

/// What a traced [PebblesSolver.propagate] records ([Fact.rule]); [Fact.value]
/// is [pebbleFilled] or [pebbleHollow]. Args name the other cells a rule is
/// about.
enum PebblesRule {
  block,
  enclosed,
  exit,
  edge,
  checker,
  cut,
  failBlock,
  failClosed,
  failEdge,
  failChecker,
  failApart,
}

/// Pebbles logic on cell states: -1 undecided, [pebbleFilled], [pebbleHollow].
/// Tier 1: three of a kind in a 2×2 block make the fourth the other kind, a
/// cell walled in by one kind is that kind, and a group with one way out
/// takes it. Tier 2: + the edge holds one run of each kind, no 2×2 block
/// alternates, and a cell that would cut a kind apart is that kind. Tier 3:
/// + probing.
class PebblesSolver {
  PebblesSolver(this.n) : nb = orthNeighbors(n, n), ring = pebbleRing(n), blocks = pebbleBlocks(n).toList();

  final int n;
  final List<List<int>> nb;
  final List<int> ring;
  final List<int> blocks;

  List<int> start(PebblesPuzzle p, [List<int>? givens]) {
    final st = List<int>.filled(n * n, -1);
    for (final i in givens ?? p.givens) {
      st[i] = p.solutionAt(i);
    }
    return st;
  }

  /// Applies logic up to [tier] (1 or 2) in place; false on a contradiction.
  /// With [t], every deduction is recorded (see [PebblesRule]).
  bool propagate(List<int> st, [int tier = 2, ExplainTrace? t]) {
    var changed = true;
    void set(int i, int v, PebblesRule rule, List<int> premises, [List<int> args = const []]) {
      if (st[i] != -1) return;
      st[i] = v;
      changed = true;
      t?.fact(i, v, rule.index, premises: premises, args: args);
    }

    final count = [0, 0];
    while (changed) {
      changed = false;
      // Three of a kind in a block.
      for (final i in blocks) {
        final b = [i, i + 1, i + n + 1, i + n];
        for (final v in const [pebbleFilled, pebbleHollow]) {
          final same = b.where((j) => st[j] == v).length;
          if (same == 4) {
            t?.fail(PebblesRule.failBlock.index, premises: b, args: [i]);
            return false;
          }
          if (same == 3) {
            final open = b.firstWhere((j) => st[j] != v);
            if (st[open] == -1) {
              final others = [
                for (final j in b)
                  if (j != open) j,
              ];
              set(open, 1 - v, PebblesRule.block, others, others);
            }
          }
        }
      }
      if (changed) continue;
      count[0] = st.where((x) => x == 0).length;
      count[1] = st.where((x) => x == 1).length;
      // A cell walled in by one kind is that kind.
      for (var i = 0; i < n * n; i++) {
        if (st[i] != -1) continue;
        final v = st[nb[i].first];
        if (v == -1 || count[1 - v] == 0 || nb[i].any((j) => st[j] != v)) continue;
        set(i, v, PebblesRule.enclosed, nb[i]);
      }
      if (changed) continue;
      // A group with one way out takes it.
      for (final v in const [pebbleFilled, pebbleHollow]) {
        for (final group in components(nb, (i) => st[i] == v)) {
          if (group.length == count[v]) continue;
          final exits = {
            for (final i in group)
              for (final j in nb[i])
                if (st[j] == -1) j,
          };
          if (exits.isEmpty) {
            t?.fail(PebblesRule.failClosed.index, premises: _around(st, group), args: [group.first]);
            return false;
          }
          if (exits.length == 1) {
            set(exits.first, v, PebblesRule.exit, _around(st, group), [group.first]);
            break;
          }
        }
        if (changed) break;
      }
      if (changed) continue;
      if (tier < 2) continue;
      // No block alternates: a diagonal of one kind and one other cell of
      // the other kind make the last cell the diagonal's kind.
      for (final i in blocks) {
        final diagonals = [
          [i, i + n + 1, i + 1, i + n],
          [i + 1, i + n, i, i + n + 1],
        ];
        for (final [a, b, c, d] in diagonals) {
          final v = st[a];
          if (v == -1 || st[b] != v) continue;
          if (st[c] == 1 - v && st[d] == 1 - v) {
            t?.fail(PebblesRule.failChecker.index, premises: [a, b, c, d], args: [i]);
            return false;
          }
          if (st[c] == 1 - v && st[d] == -1) set(d, v, PebblesRule.checker, [a, b, c], [a, b, c]);
          if (st[d] == 1 - v && st[c] == -1) set(c, v, PebblesRule.checker, [a, b, d], [a, b, d]);
        }
      }
      if (changed) continue;
      if (!_edge(st, set, t)) return false;
      if (changed) continue;
      for (final v in const [pebbleFilled, pebbleHollow]) {
        if (!_cuts(st, v, set, t)) return false;
        if (changed) break;
      }
    }
    return true;
  }

  /// The group's stones and the cells walling it in.
  List<int> _around(List<int> st, List<int> group) => [
    ...group,
    ...{
      for (final i in group)
        for (final j in nb[i])
          if (st[j] != -1 && st[j] != st[i]) j,
    },
  ];

  /// The edge holds one run of each kind: once both kinds show on it, the
  /// gap between two stones of a kind (with no other kind between) is that
  /// kind.
  bool _edge(
    List<int> st,
    void Function(int, int, PebblesRule, List<int>, [List<int>]) set,
    ExplainTrace? t,
  ) {
    final known = [
      for (var k = 0; k < ring.length; k++)
        if (st[ring[k]] != -1) k,
    ];
    if (known.length < 2) return true;
    var changes = 0;
    for (var a = 0; a < known.length; a++) {
      if (st[ring[known[a]]] != st[ring[known[(a + 1) % known.length]]]) changes++;
    }
    if (changes == 0) return true;
    final premises = [for (final k in known) ring[k]];
    if (changes > 2) {
      // Four stones alternating round the edge.
      final alt = <int>[];
      for (final k in known) {
        if (alt.isEmpty || st[ring[k]] != st[alt.last]) alt.add(ring[k]);
      }
      if (st[alt.first] == st[alt.last]) alt.removeLast();
      t?.fail(PebblesRule.failEdge.index, premises: premises, args: alt.take(4).toList());
      return false;
    }
    for (var a = 0; a < known.length; a++) {
      final from = known[a], to = known[(a + 1) % known.length];
      final v = st[ring[from]];
      if (st[ring[to]] != v) continue;
      final other = premises.firstWhere((j) => st[j] != v);
      for (var k = (from + 1) % ring.length; k != to; k = (k + 1) % ring.length) {
        set(ring[k], v, PebblesRule.edge, premises, [ring[from], ring[to], other]);
      }
    }
    return true;
  }

  /// Checks that the stones of kind [v] can still meet, and makes [v] every
  /// open cell without which they couldn't.
  bool _cuts(
    List<int> st,
    int v,
    void Function(int, int, PebblesRule, List<int>, [List<int>]) set,
    ExplainTrace? t,
  ) {
    final root = st.indexOf(v);
    if (root < 0) return true;
    final disc = List<int>.filled(n * n, -1), low = List<int>.filled(n * n, 0), sub = List<int>.filled(n * n, 0);
    final forced = <int>[];
    var time = 0;
    void dfs(int u, int parent) {
      disc[u] = low[u] = time++;
      sub[u] = st[u] == v ? 1 : 0;
      for (final w in nb[u]) {
        if (st[w] == 1 - v) continue;
        if (disc[w] < 0) {
          dfs(w, u);
          sub[u] += sub[w];
          low[u] = min(low[u], low[w]);
          if (low[w] >= disc[u] && sub[w] > 0 && st[u] == -1) forced.add(u);
        } else if (w != parent) {
          low[u] = min(low[u], disc[w]);
        }
      }
    }

    dfs(root, -1);
    List<int> decided() => [
      for (var i = 0; i < n * n; i++)
        if (st[i] != -1) i,
    ];
    for (var i = 0; i < n * n; i++) {
      if (st[i] == v && disc[i] < 0) {
        t?.fail(PebblesRule.failApart.index, premises: decided(), args: [root, i]);
        return false;
      }
    }
    final premises = t == null || forced.isEmpty ? const <int>[] : decided();
    for (final u in forced) {
      set(u, v, PebblesRule.cut, premises);
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
          for (final v in const [pebbleFilled, pebbleHollow]) {
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
  int slack(int tier, List<int> st0) {
    final st = List.of(st0);
    if (!solve(st, tier)) return st.length + 1;
    return st.where((x) => x == -1).length;
  }

  /// Lowest tier (1..3) that solves the board from [st0], or 4.
  int grade(List<int> st0) {
    for (var t = 1; t <= 3; t++) {
      if (slack(t, st0) == 0) return t;
    }
    return 4;
  }

  /// Number of solutions (up to [limit]), or -1 if the search gets too big.
  int countSolutions(List<int> from, {int limit = 2, int budget = 100000}) {
    var nodes = 0, total = 0;
    void rec(List<int> st) {
      if (total >= limit || ++nodes > budget) return;
      if (!propagate(st)) return;
      final i = st.indexOf(-1);
      if (i < 0) {
        total++;
        return;
      }
      for (final v in const [pebbleFilled, pebbleHollow]) {
        rec(List.of(st)..[i] = v);
      }
    }

    rec(List.of(from));
    return nodes > budget ? -1 : total;
  }
}
