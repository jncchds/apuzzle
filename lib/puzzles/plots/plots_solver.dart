import 'dart:math';

import '../../core/explain.dart';
import '../../core/grid_graph.dart';

/// What a traced [PlotsSolver.propagate] records ([Fact.rule]). Eliminations
/// ([closed], [merge], [room]) carry the removed bit as [Fact.value],
/// placements ([exit], [only]) the value. Group rules have the group's
/// first cell and value as args.
enum PlotsRule { closed, exit, merge, room, only, failEmpty, failBig, failShut, failRoom }

/// Candidate logic for Fillomino. Candidates are bit masks (bit v: the
/// number v + 1). Tier 1: finished groups close their borders, a group with
/// one way out takes it, a group (or a cell's would-be group) must be able
/// to reach its size, and a cell may not join groups into one too big.
/// Tier 2: + probing cells with up to three candidates.
class PlotsSolver {
  PlotsSolver(this.rows, this.cols, this.maxValue) : n = rows * cols, nb = orthNeighbors(rows, cols);

  final int rows;
  final int cols;
  final int maxValue;
  final int n;
  final List<List<int>> nb;

  List<int> start(List<int?> givens) => [for (final g in givens) g == null ? (1 << maxValue) - 1 : 1 << g];

  static bool single(int m) => m != 0 && m & (m - 1) == 0;
  static int valueOf(int m) => m.bitLength - 1;
  static int bits(int m) {
    var k = 0;
    while (m != 0) {
      m &= m - 1;
      k++;
    }
    return k;
  }

  /// Cells reachable from [from] through cells that may hold [v], counting
  /// up to [cap].
  int _reach(List<int> c, List<int> from, int v, int cap, List<int> mark, int stamp) {
    final bit = 1 << v;
    final queue = [for (final i in from) i];
    for (final i in queue) {
      mark[i] = stamp;
    }
    for (var k = 0; k < queue.length && queue.length < cap; k++) {
      for (final j in nb[queue[k]]) {
        if (mark[j] != stamp && c[j] & bit != 0) {
          mark[j] = stamp;
          queue.add(j);
        }
      }
    }
    return queue.length;
  }

  /// Applies tier-1 logic in place; false on a contradiction. With [t],
  /// every deduction is recorded (see [PlotsRule]).
  bool propagate(List<int> c, [ExplainTrace? t]) {
    final group = List<int>.filled(n, -1);
    final mark = List<int>.filled(n, 0);
    var stamp = 0;
    var changed = true;
    // A group and the cells around it, as premises.
    List<int> around(List<int> g) => {
      ...g,
      for (final i in g) ...nb[i],
    }.toList();
    // The cells the last [_reach] marked, and their neighbours.
    List<int> reached() => {
      for (var i = 0; i < n; i++)
        if (mark[i] == stamp) ...[i, ...nb[i]],
    }.toList();
    // Records that [bit] left [j], and what that leaves.
    void ruledOut(int j, int bit, PlotsRule rule, List<int> premises, List<int> args) {
      t!.fact(j, bit, rule.index, premises: premises, args: args);
      if (single(c[j])) t.fact(j, valueOf(c[j]), PlotsRule.only.index, premises: [j]);
      if (c[j] == 0) t.fail(PlotsRule.failEmpty.index, premises: [j], args: [j]);
    }

    while (changed) {
      changed = false;
      for (var i = 0; i < n; i++) {
        if (c[i] == 0) {
          t?.fail(PlotsRule.failEmpty.index, premises: [i], args: [i]);
          return false;
        }
      }
      // Groups of decided cells.
      group.fillRange(0, n, -1);
      final groups = <List<int>>[];
      for (var i = 0; i < n; i++) {
        if (group[i] >= 0 || !single(c[i])) continue;
        final m = c[i];
        final g = [i];
        group[i] = groups.length;
        for (var k = 0; k < g.length; k++) {
          for (final j in nb[g[k]]) {
            if (group[j] < 0 && c[j] == m) {
              group[j] = groups.length;
              g.add(j);
            }
          }
        }
        groups.add(g);
      }
      for (final g in groups) {
        final v = valueOf(c[g.first]), want = v + 1, bit = 1 << v;
        if (g.length > want) {
          t?.fail(PlotsRule.failBig.index, premises: g, args: [g.first, v]);
          return false;
        }
        final exits = <int>{
          for (final i in g)
            for (final j in nb[i])
              if (!single(c[j]) && c[j] & bit != 0) j,
        };
        if (g.length == want) {
          for (final j in exits) {
            c[j] &= ~bit;
            if (t != null) ruledOut(j, bit, PlotsRule.closed, g, [g.first, v]);
            changed = true;
            if (c[j] == 0) return false;
          }
        } else if (exits.isEmpty) {
          t?.fail(PlotsRule.failShut.index, premises: around(g), args: [g.first, v]);
          return false;
        } else if (exits.length == 1) {
          c[exits.first] = bit;
          t?.fact(exits.first, v, PlotsRule.exit.index, premises: around(g), args: [g.first, v]);
          changed = true;
        } else if (_reach(c, g, v, want, mark, ++stamp) < want) {
          t?.fail(PlotsRule.failRoom.index, premises: reached(), args: [g.first, v]);
          return false;
        }
        // Decided cells change the groups: regroup first.
        if (changed) break;
      }
      if (changed) continue;
      for (var i = 0; i < n; i++) {
        final m = c[i];
        if (single(m)) continue;
        for (var v = 0; v < maxValue; v++) {
          final bit = 1 << v;
          if (m & bit == 0) continue;
          // Joining the neighbouring groups of v must not overshoot.
          var size = 1;
          final joined = <int>{};
          for (final j in nb[i]) {
            if (group[j] >= 0 && c[j] == bit && joined.add(group[j])) size += groups[group[j]].length;
          }
          if (size > v + 1) {
            c[i] &= ~bit;
            if (t != null) ruledOut(i, bit, PlotsRule.merge, [i, for (final k in joined) ...groups[k]], [v]);
            changed = true;
          } else if (_reach(c, [i], v, v + 1, mark, ++stamp) < v + 1) {
            c[i] &= ~bit;
            if (t != null) ruledOut(i, bit, PlotsRule.room, reached(), [v]);
            changed = true;
          }
        }
        if (c[i] == 0) return false;
      }
    }
    return true;
  }

  bool solved(List<int> c) => c.every(single);

  /// Solves in place with logic up to [tier]; true if every cell is decided.
  bool solve(List<int> c, int tier) {
    if (!propagate(c)) return false;
    if (tier >= 2) {
      var progress = true;
      while (progress && !solved(c)) {
        progress = false;
        for (var i = 0; i < n; i++) {
          // Cells with few candidates are where contradictions show up.
          if (single(c[i]) || bits(c[i]) > 3) continue;
          for (var v = 0; v < maxValue; v++) {
            final bit = 1 << v;
            if (c[i] & bit == 0) continue;
            final t = List.of(c)..[i] = bit;
            if (!propagate(t)) {
              c[i] &= ~bit;
              if (!propagate(c)) return false;
              progress = true;
            }
          }
        }
      }
    }
    return solved(c);
  }

  bool solves(List<int?> givens, int tier) => solve(start(givens), tier);

  /// Number of solutions (up to [limit]), or -1 if the search gets too big.
  int countSolutions(List<int> c, {int limit = 2, int budget = 100000}) {
    var nodes = 0;
    var total = 0;
    void rec(List<int> cur) {
      if (total >= limit || ++nodes > budget) return;
      if (!propagate(cur)) return;
      var pick = -1, best = 99;
      for (var i = 0; i < n; i++) {
        final b = bits(cur[i]);
        if (b > 1 && b < best) {
          best = b;
          pick = i;
        }
      }
      if (pick < 0) {
        total++;
        return;
      }
      for (var v = 0; v < maxValue; v++) {
        if (cur[pick] & (1 << v) != 0) rec(List.of(cur)..[pick] = 1 << v);
      }
    }

    rec(List.of(c));
    return nodes > budget ? -1 : min(total, limit);
  }
}
