import 'dart:math';

import '../../core/grid_graph.dart';

/// Candidate logic for Suguru. Candidates are bit masks (bit v: value v).
/// Tier 1: singles (naked, and hidden per region) and the touching rule.
/// Tier 2: + pointing (every spot for a value in a region touches one outside
/// cell) and naked pairs. Tier 3: + probing.
class BlocksSolver {
  BlocksSolver(this.rows, this.cols, this.regions)
      : n = rows * cols,
        kn = kingNeighbors(rows, cols) {
    members = List.generate(regions.reduce(max) + 1, (_) => <int>[]);
    for (var i = 0; i < n; i++) {
      members[regions[i]].add(i);
    }
    kset = [for (final l in kn) l.toSet()];
  }

  final int rows;
  final int cols;
  final int n;
  final List<int> regions;
  final List<List<int>> kn;
  late final List<Set<int>> kset;
  late final List<List<int>> members;

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
  bool propagate(List<int> c, int tier) {
    var changed = true;
    bool remove(int i, int mask) {
      if (c[i] & mask == 0) return true;
      c[i] &= ~mask;
      changed = true;
      return c[i] != 0;
    }

    while (changed) {
      changed = false;
      for (var i = 0; i < n; i++) {
        final m = c[i];
        if (m == 0) return false;
        if (!single(m)) continue;
        for (final j in kn[i]) {
          if (!remove(j, m)) return false;
        }
        for (final j in members[regions[i]]) {
          if (j != i && !remove(j, m)) return false;
        }
      }
      for (final cells in members) {
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
          if (spots == 0) return false;
          if (spots == 1) {
            if (c[first] != bit) {
              c[first] = bit;
              changed = true;
            }
            continue;
          }
          if (tier < 2) continue;
          // Pointing: a cell outside the region touching every spot.
          for (final j in kn[first]) {
            if (regions[j] == regions[first] || c[j] & bit == 0) continue;
            if (cells.every((s) => c[s] & bit == 0 || kset[s].contains(j)) && !remove(j, bit)) return false;
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
                if (x != cells[a] && x != cells[b] && !remove(x, m)) return false;
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
  /// With [rng] the search order is random, and the first solution found is
  /// written to [found].
  int countSolutions(List<int> c, {int limit = 2, Random? rng, List<int>? found, int budget = 200000}) {
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
        if (total == 0 && found != null) found.setAll(0, [for (final m in cur) valueOf(m)]);
        total++;
        return;
      }
      final vals = [for (var v = 0; v < 8; v++) if (cur[pick] & (1 << v) != 0) v];
      if (rng != null) vals.shuffle(rng);
      for (final v in vals) {
        rec(List.of(cur)..[pick] = 1 << v);
      }
    }

    rec(List.of(c));
    return nodes > budget ? -1 : total;
  }
}
