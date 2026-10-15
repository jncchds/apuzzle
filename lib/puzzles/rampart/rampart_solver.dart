import 'dart:math';

import '../../core/explain.dart';
import '../../core/grid_graph.dart';
import 'rampart_model.dart';

/// What a traced [RampartSolver.propagate] records ([Fact.rule]); [Fact.value]
/// is [rampartShade] or [rampartKeep]. Args name the clue cell or a cell of
/// the part of the wall a rule is about.
enum RampartRule {
  clue,
  pool,
  escape,
  ways,
  cut,
  away,
  failClue,
  failPool,
  failShut,
  failWays,
  failApart,
}

/// Rampart logic on cell states: -1 undecided, [rampartShade], [rampartKeep].
/// Tier 1: cells every way of making a clue shades or keeps; the last cell
/// of a 2×2 block stays; a part of the wall with one way out takes it.
/// Tier 2: + ways of making a clue that would shade a 2×2 block or shut a
/// part of the wall in are ruled out, cells whose keeping would cut the
/// wall apart are shaded and cells the wall can't reach stay.
/// Tier 3: + probing.
class RampartSolver {
  RampartSolver(this.p) : n = p.n, nb = orthNeighbors(p.n, p.n), ring = rampartRingOf(p.n) {
    clueCells = [
      for (var i = 0; i < n * n; i++)
        if (p.clues[i] != null) i,
    ];
    masks = [for (final c in clueCells) rampartMasks(n, c, p.clues[c]!)];
    blocksOf = List.generate(n * n, (_) => <int>[]);
    for (final b in rampartBlocks(n)) {
      for (final j in [b, b + 1, b + n, b + n + 1]) {
        blocksOf[j].add(b);
      }
    }
  }

  final RampartPuzzle p;
  final int n;
  final List<List<int>> nb;
  final List<List<int>> ring;
  late final List<int> clueCells;
  late final List<List<int>> masks;

  /// The top-left cells of the 2×2 blocks holding each cell.
  late final List<List<int>> blocksOf;

  List<int> start() {
    final st = List<int>.filled(n * n, -1);
    for (final c in clueCells) {
      st[c] = rampartKeep;
    }
    return st;
  }

  /// Applies logic up to [tier] (1 or 2) in place; false on a contradiction.
  /// With [t], every deduction is recorded (see [RampartRule]).
  bool propagate(List<int> st, [int tier = 2, ExplainTrace? t]) {
    var changed = true;
    void set(int i, int v, RampartRule rule, List<int> premises, [List<int> args = const []]) {
      if (st[i] != -1) return;
      st[i] = v;
      changed = true;
      t?.fact(i, v, rule.index, premises: premises, args: args);
    }

    while (changed) {
      changed = false;
      for (final b in rampartBlocks(n)) {
        final block = [b, b + 1, b + n, b + n + 1];
        final open = block.where((j) => st[j] != rampartShade).toList();
        if (open.isEmpty) {
          t?.fail(RampartRule.failPool.index, premises: block, args: [b]);
          return false;
        }
        if (open.length == 1 && st[open.first] == -1) set(open.first, rampartKeep, RampartRule.pool, block, [b]);
      }
      for (var k = 0; k < clueCells.length; k++) {
        if (!_clue(st, k, false, set, t)) return false;
      }
      if (changed) continue;
      if (!_escape(st, set, t)) return false;
      if (changed) continue;
      if (tier >= 2) {
        for (var k = 0; k < clueCells.length; k++) {
          if (!_clue(st, k, true, set, t)) return false;
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

  /// Ways of making clue [k] that agree with the board (with [deep], also
  /// with no 2×2 block shaded and no part of the wall shut in); cells all
  /// of them shade are shaded, cells none of them shades stay.
  bool _clue(
    List<int> st,
    int k,
    bool deep,
    void Function(int, int, RampartRule, List<int>, [List<int>]) set,
    ExplainTrace? t,
  ) {
    final c = clueCells[k], r = ring[c];
    var sh = 0, kp = 0, open = 0;
    for (var b = 0; b < 8; b++) {
      final j = r[b];
      if (j < 0) continue;
      if (st[j] == rampartShade) {
        sh |= 1 << b;
      } else if (st[j] == rampartKeep) {
        kp |= 1 << b;
      } else {
        open |= 1 << b;
      }
    }
    if (open == 0 && masks[k].contains(sh)) return true;
    var all = 255, any = 0, count = 0;
    for (final m in masks[k]) {
      if (m & sh != sh || m & kp != 0) continue;
      if (deep && !_fits(st, c, m)) continue;
      all &= m;
      any |= m;
      count++;
    }
    List<int> premises() => [
      c,
      for (final j in r)
        if (j >= 0 && st[j] != -1) j,
    ];
    if (count == 0) {
      t?.fail((deep ? RampartRule.failWays : RampartRule.failClue).index, premises: premises(), args: [c]);
      return false;
    }
    final shade = all & open, keep = open & ~any;
    if (shade | keep == 0) return true;
    final why = t == null ? const <int>[] : premises();
    final rule = deep ? RampartRule.ways : RampartRule.clue;
    for (var b = 0; b < 8; b++) {
      if (shade >> b & 1 == 1) set(r[b], rampartShade, rule, why, [c]);
      if (keep >> b & 1 == 1) set(r[b], rampartKeep, rule, why, [c]);
    }
    return true;
  }

  /// Whether shading the ring cells of [c] in [m] (and keeping the rest)
  /// leaves no 2×2 block shaded and no part of the wall shut in while
  /// shaded cells lie beyond it.
  bool _fits(List<int> st, int c, int m) {
    final r = ring[c];
    int at(int j) {
      final b = r.indexOf(j);
      if (b < 0) return st[j];
      return m >> b & 1 == 1 ? rampartShade : rampartKeep;
    }

    for (var b = 0; b < 8; b++) {
      if (m >> b & 1 == 0 || st[r[b]] == rampartShade) continue;
      for (final q in blocksOf[r[b]]) {
        if (at(q) == rampartShade &&
            at(q + 1) == rampartShade &&
            at(q + n) == rampartShade &&
            at(q + n + 1) == rampartShade) {
          return false;
        }
      }
    }
    final group = <int>{};
    for (var b = 0; b < 8; b++) {
      if (m >> b & 1 == 0 || st[r[b]] == rampartShade || group.contains(r[b])) continue;
      // Grow the part of the wall this cell joins until it finds a way out.
      final seen = {r[b]}, stack = [r[b]];
      var exit = false;
      while (stack.isNotEmpty && !exit) {
        final u = stack.removeLast();
        for (final v in nb[u]) {
          final s = at(v);
          if (s == -1) {
            exit = true;
            break;
          }
          if (s == rampartShade && seen.add(v)) stack.add(v);
        }
      }
      if (exit) {
        group.addAll(seen);
        continue;
      }
      for (var j = 0; j < n * n; j++) {
        if (at(j) == rampartShade && !seen.contains(j)) return false;
      }
    }
    return true;
  }

  /// Parts of the wall: one shut in while others exist is a contradiction,
  /// one with a single way out takes it.
  bool _escape(List<int> st, void Function(int, int, RampartRule, List<int>, [List<int>]) set, ExplainTrace? t) {
    final parts = components(nb, (i) => st[i] == rampartShade);
    if (parts.length < 2) return true;
    for (final part in parts) {
      final exits = <int>{}, edge = <int>{};
      for (final u in part) {
        for (final v in nb[u]) {
          if (st[v] == -1) exits.add(v);
          if (st[v] == rampartKeep) edge.add(v);
        }
      }
      if (exits.length > 1) continue;
      final premises = t == null ? const <int>[] : [...part, ...edge];
      if (exits.isEmpty) {
        t?.fail(RampartRule.failShut.index, premises: premises, args: [part.first]);
        return false;
      }
      // The parts change once this one grows: look again next round.
      set(exits.first, rampartShade, RampartRule.escape, premises, [part.first]);
      return true;
    }
    return true;
  }

  /// Checks that the shaded cells can still meet; with [force], shades
  /// every open cell whose keeping would part them and keeps the cells the
  /// wall can't reach.
  bool _cuts(
    List<int> st,
    bool force,
    void Function(int, int, RampartRule, List<int>, [List<int>]) set,
    ExplainTrace? t,
  ) {
    final root = st.indexOf(rampartShade);
    if (root < 0) return true;
    final disc = List<int>.filled(n * n, -1), low = List<int>.filled(n * n, 0), sub = List<int>.filled(n * n, 0);
    final forced = <int>[];
    var time = 0;
    void dfs(int u, int parent) {
      disc[u] = low[u] = time++;
      sub[u] = st[u] == rampartShade ? 1 : 0;
      for (final v in nb[u]) {
        if (st[v] == rampartKeep) continue;
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
      if (st[i] == rampartShade && disc[i] < 0) {
        t?.fail(RampartRule.failApart.index, premises: decided(), args: [root, i]);
        return false;
      }
    }
    if (!force) return true;
    final premises = t == null ? const <int>[] : decided();
    for (final u in forced) {
      set(u, rampartShade, RampartRule.cut, premises, [root]);
    }
    for (var i = 0; i < n * n; i++) {
      if (st[i] == -1 && disc[i] < 0) set(i, rampartKeep, RampartRule.away, premises, [root]);
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
          for (final v in const [rampartShade, rampartKeep]) {
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
      for (final v in const [rampartShade, rampartKeep]) {
        rec(List.of(st)..[i] = v);
      }
    }

    rec(from == null ? start() : List.of(from));
    return nodes > budget ? -1 : total;
  }
}
