import 'dart:math';

import '../../core/explain.dart';
import '../../core/grid_graph.dart';
import 'solo_model.dart';

/// What a traced [SoloSolver.propagate] records ([Fact.rule]); [Fact.value]
/// is [soloShade] or [soloKeep]. Args name the other cells a rule is about.
enum SoloRule {
  unique,
  lastCopy,
  twice,
  touch,
  shows,
  between,
  pair,
  walled,
  cut,
  failTwice,
  failTouch,
  failLonely,
  failWalled,
  failApart,
}

/// Solo logic on cell states: -1 undecided, [soloShade], [soloKeep].
/// Tier 1: a number left in a line shades its copies, a shaded cell keeps
/// its neighbours, a number with no copy left stays, a shaded number's last
/// copy stays, A x A keeps x, A A shades every other A of the line, and a
/// cell that would wall in a neighbour stays. Tier 2: + a cell whose shading
/// would cut the unshaded cells apart stays. Tier 3: + probing.
class SoloSolver {
  SoloSolver(this.n, this.digits) : nb = orthNeighbors(n, n), copies = soloCopies(n, digits) {
    for (var line = 0; line < 2 * n; line++) {
      final cells = [for (var k = 0; k < n; k++) line < n ? line * n + k : k * n + line - n];
      for (var k = 0; k + 2 < n; k++) {
        if (digits[cells[k]] == digits[cells[k + 2]]) _between.add((cells[k + 1], cells[k], cells[k + 2]));
      }
      for (var k = 0; k + 1 < n; k++) {
        final a = cells[k], b = cells[k + 1];
        if (digits[a] != digits[b]) continue;
        for (final q in cells) {
          if (q != a && q != b && digits[q] == digits[a]) _pairs.add((q, a, b));
        }
      }
    }
  }

  factory SoloSolver.of(SoloPuzzle p) => SoloSolver(p.n, p.digits);

  final int n;
  final List<int> digits;
  final List<List<int>> nb;
  final List<List<int>> copies;

  /// (x, a, b): a and b hold the same number on either side of x.
  final _between = <(int, int, int)>[];

  /// (q, a, b): a and b are side by side with q's number, in q's line.
  final _pairs = <(int, int, int)>[];

  List<int> start({List<int> givens = const [], List<bool>? shaded}) {
    final st = List<int>.filled(n * n, -1);
    for (final i in givens) {
      st[i] = shaded![i] ? soloShade : soloKeep;
    }
    return st;
  }

  /// Applies logic up to [tier] (1 or 2) in place; false on a contradiction.
  /// With [t], every deduction is recorded (see [SoloRule]).
  bool propagate(List<int> st, [int tier = 2, ExplainTrace? t]) {
    var changed = true;
    void set(int i, int v, SoloRule rule, List<int> premises, [List<int> args = const []]) {
      if (st[i] != -1) return;
      st[i] = v;
      changed = true;
      t?.fact(i, v, rule.index, premises: premises, args: args);
    }

    while (changed) {
      changed = false;
      for (var i = 0; i < n * n; i++) {
        final v = st[i];
        if (v == soloKeep) {
          for (final j in copies[i]) {
            if (st[j] == soloKeep) {
              t?.fail(SoloRule.failTwice.index, premises: [i, j], args: [i, j]);
              return false;
            }
            set(j, soloShade, SoloRule.twice, [i], [i]);
          }
        } else if (v == soloShade) {
          for (final j in nb[i]) {
            if (st[j] == soloShade) {
              t?.fail(SoloRule.failTouch.index, premises: [i, j], args: [i, j]);
              return false;
            }
            set(j, soloKeep, SoloRule.touch, [i], [i]);
          }
          final open = [
            for (final j in copies[i])
              if (st[j] != soloShade) j,
          ];
          if (open.isEmpty) {
            t?.fail(SoloRule.failLonely.index, premises: [i, ...copies[i]], args: [i]);
            return false;
          }
          if (open.length == 1) set(open.first, soloKeep, SoloRule.shows, [i, ...copies[i]], [i]);
        } else if (copies[i].every((j) => st[j] == soloShade)) {
          set(i, soloKeep, copies[i].isEmpty ? SoloRule.unique : SoloRule.lastCopy, copies[i]);
        }
      }
      if (changed) continue;
      for (final (x, a, b) in _between) {
        if (st[x] == -1) set(x, soloKeep, SoloRule.between, [a, b], [a, b]);
      }
      for (final (q, a, b) in _pairs) {
        if (st[q] == -1) set(q, soloShade, SoloRule.pair, [a, b], [a, b]);
      }
      if (changed) continue;
      // A cell left with one way out keeps it.
      for (var y = 0; y < n * n; y++) {
        if (st[y] == soloShade) continue;
        final exits = [
          for (final j in nb[y])
            if (st[j] != soloShade) j,
        ];
        if (exits.isEmpty) {
          t?.fail(SoloRule.failWalled.index, premises: [y, ...nb[y]], args: [y]);
          return false;
        }
        if (exits.length == 1 && st[exits.first] == -1) {
          set(exits.first, soloKeep, SoloRule.walled, [y, ...nb[y]], [y]);
        }
      }
      if (changed) continue;
      if (tier >= 2 || !st.contains(-1)) {
        if (!_cuts(st, tier >= 2, set, t)) return false;
      }
    }
    return true;
  }

  /// Checks that the kept cells can still meet; with [force], keeps every
  /// open cell whose shading would part them.
  bool _cuts(
    List<int> st,
    bool force,
    void Function(int, int, SoloRule, List<int>, [List<int>]) set,
    ExplainTrace? t,
  ) {
    final root = st.indexOf(soloKeep);
    if (root < 0) return true;
    final disc = List<int>.filled(n * n, -1), low = List<int>.filled(n * n, 0), sub = List<int>.filled(n * n, 0);
    final forced = <int>[];
    var time = 0;
    void dfs(int u, int parent) {
      disc[u] = low[u] = time++;
      sub[u] = st[u] == soloKeep ? 1 : 0;
      for (final v in nb[u]) {
        if (st[v] == soloShade) continue;
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
      if (st[i] == soloKeep && disc[i] < 0) {
        t?.fail(SoloRule.failApart.index, premises: decided(), args: [root, i]);
        return false;
      }
    }
    if (force && forced.isNotEmpty) {
      final premises = t == null ? const <int>[] : decided();
      for (final u in forced) {
        set(u, soloKeep, SoloRule.cut, premises);
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
          for (final v in const [soloShade, soloKeep]) {
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
      for (final v in const [soloShade, soloKeep]) {
        rec(List.of(st)..[i] = v);
      }
    }

    rec(from == null ? start() : List.of(from));
    return nodes > budget ? -1 : total;
  }
}
