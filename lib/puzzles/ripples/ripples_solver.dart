import 'dart:math';

import '../../core/explain.dart';
import 'ripples_model.dart';

/// What a traced [RipplesSolver.propagate] records ([Fact.rule]). Eliminations
/// ([echo], [region], [pointing], [pair]) carry the removed bits as
/// [Fact.value], placements ([naked], [hidden]) the value.
/// [alone] is a one-cell region (recorded by the explainer, not the solver).
enum RipplesRule { echo, region, pointing, pair, naked, hidden, alone, failEmpty, failNoPlace }

/// Candidate logic for Echoes. Candidates are bit masks (bit v: value v).
/// Tier 1: singles (naked, and hidden per region), placed numbers ruled out
/// in their region and within their reach along row and column. Tier 2: +
/// pointing (every spot for a value in a region is within reach of one
/// outside cell) and naked pairs in a region. Tier 3: + probing.
class RipplesSolver {
  RipplesSolver(this.rows, this.cols, this.regions) : n = rows * cols {
    members = List.generate(regions.reduce(max) + 1, (_) => <int>[]);
    for (var i = 0; i < n; i++) {
      members[regions[i]].add(i);
    }
    final top = members.fold(1, (a, m) => max(a, m.length)) - 1;
    reach = ripplesReach(rows, cols, top);
    reachSet = [
      for (final l in reach) [for (final cells in l) cells.toSet()],
    ];
  }

  final int rows;
  final int cols;
  final int n;
  final List<int> regions;
  late final List<List<int>> members;

  /// `reach[i][v]`: cells that can't hold v while i does (see [ripplesReach]).
  late final List<List<List<int>>> reach;
  late final List<List<Set<int>>> reachSet;

  /// Start candidates with the [givens] (value or null per cell) placed, or
  /// null if a given doesn't fit its region.
  List<int>? start(List<int?> givens) {
    final c = [for (var i = 0; i < n; i++) (1 << members[regions[i]].length) - 1];
    for (var i = 0; i < n; i++) {
      final g = givens[i];
      if (g == null) continue;
      if (c[i] & (1 << g) == 0) return null;
      c[i] = 1 << g;
    }
    return c;
  }

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

  /// Applies logic up to [tier] (1 or 2) in place; false on a contradiction.
  /// With [t], every deduction is recorded (see [RipplesRule]).
  bool propagate(List<int> c, int tier, [ExplainTrace? t]) {
    var changed = true;
    // Rules out [mask] in [i] by [rule]: from cell [x] (echo, region), region
    // [x] for value [y] (pointing), or the pair [x], [y].
    bool remove(int i, int mask, RipplesRule rule, int x, [int y = -1]) {
      if (c[i] & mask == 0) return true;
      final gone = c[i] & mask;
      c[i] &= ~mask;
      changed = true;
      if (t != null) {
        final (premises, args) = switch (rule) {
          RipplesRule.pointing => (members[x], [y, x]),
          RipplesRule.pair => ([x, y], [x, y, mask]),
          _ => ([x], [x]),
        };
        t.fact(i, gone, rule.index, premises: premises, args: args);
        if (single(c[i])) t.fact(i, valueOf(c[i]), RipplesRule.naked.index, premises: [i]);
        if (c[i] == 0) t.fail(RipplesRule.failEmpty.index, premises: [i], args: [i]);
      }
      return c[i] != 0;
    }

    while (changed) {
      changed = false;
      for (var i = 0; i < n; i++) {
        final m = c[i];
        if (m == 0) {
          t?.fail(RipplesRule.failEmpty.index, premises: [i], args: [i]);
          return false;
        }
        if (!single(m)) continue;
        for (final j in reach[i][valueOf(m)]) {
          if (!remove(j, m, RipplesRule.echo, i)) return false;
        }
        for (final j in members[regions[i]]) {
          if (j != i && !remove(j, m, RipplesRule.region, i)) return false;
        }
      }
      for (var r = 0; r < members.length; r++) {
        final cells = members[r];
        final k = cells.length;
        for (var v = 0; v < k; v++) {
          final bit = 1 << v;
          var spots = 0, first = -1;
          for (final i in cells) {
            if (c[i] & bit != 0) {
              spots++;
              if (first < 0) first = i;
            }
          }
          if (spots == 0) {
            t?.fail(RipplesRule.failNoPlace.index, premises: cells, args: [v, r]);
            return false;
          }
          if (spots == 1) {
            if (c[first] != bit) {
              c[first] = bit;
              t?.fact(first, v, RipplesRule.hidden.index, premises: cells, args: [r]);
              changed = true;
            }
            continue;
          }
          if (tier < 2) continue;
          // Pointing: a cell outside the region within reach of every spot.
          for (final j in reach[first][v]) {
            if (regions[j] == r || c[j] & bit == 0) continue;
            if (cells.every((s) => c[s] & bit == 0 || reachSet[s][v].contains(j)) &&
                !remove(j, bit, RipplesRule.pointing, r, v)) {
              return false;
            }
          }
        }
        if (tier >= 2) {
          // Naked pairs.
          for (var a = 0; a < k; a++) {
            final m = c[cells[a]];
            if (bits(m) != 2) continue;
            for (var b = a + 1; b < k; b++) {
              if (c[cells[b]] != m) continue;
              for (final x in cells) {
                if (x != cells[a] && x != cells[b] && !remove(x, m, RipplesRule.pair, cells[a], cells[b])) return false;
              }
            }
          }
        }
      }
    }
    return true;
  }

  bool solved(List<int> c) => c.every(single);

  /// Solves in place with logic up to [tier]; true if every cell is decided.
  bool solve(List<int> c, int tier) {
    if (!propagate(c, min(tier, 2))) return false;
    if (tier >= 3) {
      var progress = true;
      while (progress && !solved(c)) {
        progress = false;
        for (var i = 0; i < n; i++) {
          if (single(c[i])) continue;
          for (var v = 0; v < 8; v++) {
            final bit = 1 << v;
            if (c[i] & bit == 0) continue;
            final t = List.of(c)..[i] = bit;
            if (!propagate(t, 2)) {
              c[i] &= ~bit;
              if (!propagate(c, 2)) return false;
              progress = true;
            }
          }
        }
      }
    }
    return solved(c);
  }

  /// Whether logic up to [tier] solves the [givens].
  bool solves(List<int?> givens, int tier) {
    final c = start(givens);
    return c != null && solve(c, tier);
  }

  /// Number of solutions (up to [limit]), or -1 if the search gets too big.
  int countSolutions(List<int> c, {int limit = 2, int budget = 200000}) {
    var nodes = 0;
    var total = 0;
    void rec(List<int> cur) {
      if (total >= limit || ++nodes > budget) return;
      if (!propagate(cur, 1)) return;
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
      for (var v = 0; v < 8; v++) {
        if (cur[pick] & (1 << v) != 0) rec(List.of(cur)..[pick] = 1 << v);
      }
    }

    rec(List.of(c));
    return nodes > budget ? -1 : total;
  }
}
