import 'dart:math';

import 'mambo_model.dart';

/// Grid solver on flat lists (-1 = unknown, 0 = sun, 1 = moon).
///
/// Deduction tiers used for difficulty grading:
///  1. direct rules: pairs/gaps (no three in a row), full-count lines, edge clues;
///  2. probing: assume a value, propagate tier 1, reject on contradiction.
/// Both tiers are sound, so "solved by logic" implies a unique solution.
class MamboSolver {
  MamboSolver(this.n, this.edges)
      : half = n ~/ 2,
        lines = mamboLines(n);

  final int n;
  final int half;
  final List<MamboEdge> edges;
  final List<List<int>> lines;

  /// Tier-1 propagation in place. Returns false on contradiction.
  bool propagate(List<int> g) {
    var changed = true;
    while (changed) {
      changed = false;
      for (final line in lines) {
        var c0 = 0, c1 = 0;
        for (final i in line) {
          if (g[i] == 0) {
            c0++;
          } else if (g[i] == 1) {
            c1++;
          }
        }
        if (c0 > half || c1 > half) return false;
        if (c0 + c1 < n && (c0 == half || c1 == half)) {
          final fill = c0 == half ? 1 : 0;
          for (final i in line) {
            if (g[i] == -1) g[i] = fill;
          }
          changed = true;
        }
        for (var k = 0; k + 2 < n; k++) {
          final i0 = line[k], i1 = line[k + 1], i2 = line[k + 2];
          final a = g[i0], b = g[i1], c = g[i2];
          if (a != -1 && a == b && b == c) return false;
          if (a != -1 && a == b && c == -1) {
            g[i2] = 1 - a;
            changed = true;
          } else if (b != -1 && b == c && a == -1) {
            g[i0] = 1 - b;
            changed = true;
          } else if (a != -1 && a == c && b == -1) {
            g[i1] = 1 - a;
            changed = true;
          }
        }
      }
      for (final e in edges) {
        final va = g[e.a], vb = g[e.b];
        if (va != -1 && vb != -1) {
          if ((va == vb) != e.same) return false;
        } else if (va != -1) {
          g[e.b] = e.same ? va : 1 - va;
          changed = true;
        } else if (vb != -1) {
          g[e.a] = e.same ? vb : 1 - vb;
          changed = true;
        }
      }
    }
    return true;
  }

  /// Solves in place using deductions up to [tier]. Returns true when fully
  /// solved without guessing.
  bool solveLogic(List<int> g, int tier) {
    if (!propagate(g)) return false;
    if (tier < 2) return !g.contains(-1);
    var progress = true;
    while (progress && g.contains(-1)) {
      progress = false;
      for (var i = 0; i < g.length; i++) {
        if (g[i] != -1) continue;
        for (final v in const [0, 1]) {
          final t = List.of(g);
          t[i] = v;
          if (!propagate(t)) {
            g[i] = 1 - v;
            if (!propagate(g)) return false;
            progress = true;
            break;
          }
        }
      }
    }
    return !g.contains(-1);
  }

  /// Counts solutions up to [limit] (backtracking).
  int countSolutions(List<int> g, {int limit = 2}) {
    final t = List.of(g);
    if (!propagate(t)) return 0;
    final i = t.indexOf(-1);
    if (i < 0) return 1;
    var total = 0;
    for (final v in const [0, 1]) {
      final u = List.of(t);
      u[i] = v;
      total += countSolutions(u, limit: limit - total);
      if (total >= limit) break;
    }
    return total;
  }

  /// A uniformly-ish random complete valid grid.
  List<int>? randomSolution(Random rng, [List<int>? start]) {
    final t = List.of(start ?? List.filled(n * n, -1));
    if (!propagate(t)) return null;
    final empties = [for (var i = 0; i < t.length; i++) if (t[i] == -1) i];
    if (empties.isEmpty) return t;
    final i = empties[rng.nextInt(empties.length)];
    final first = rng.nextInt(2);
    for (final v in [first, 1 - first]) {
      final u = List.of(t);
      u[i] = v;
      final r = randomSolution(rng, u);
      if (r != null) return r;
    }
    return null;
  }
}
