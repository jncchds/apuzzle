import 'dart:math';

import 'sudoku_model.dart';

int _pop(int x) {
  var c = 0;
  while (x != 0) {
    x &= x - 1;
    c++;
  }
  return c;
}

int _low(int x) => (x & -x).bitLength - 1;

/// Bitmask candidate solver.
///
/// Tiers (for grading):
///  1. naked + hidden singles
///  2. + locked candidates (pointing / claiming) + naked pairs
/// All tiers are sound, so a full logical solve implies uniqueness.
class SudokuSolver {
  SudokuSolver(this.n)
      : geo = SudokuGeometry.of(n),
        full = (1 << n) - 1;

  final int n;
  final SudokuGeometry geo;
  final int full;

  /// Candidates for [g] (-1 = empty), or null on immediate contradiction.
  List<int>? _candidates(List<int> g) {
    final cand = List<int>.filled(g.length, 0);
    for (var i = 0; i < g.length; i++) {
      if (g[i] >= 0) continue;
      var m = full;
      for (final p in geo.peers[i]) {
        if (g[p] >= 0) m &= ~(1 << g[p]);
      }
      if (m == 0) return null;
      cand[i] = m;
    }
    return cand;
  }

  bool _assign(List<int> g, List<int> cand, int i, int d) {
    g[i] = d;
    cand[i] = 0;
    final bit = 1 << d;
    for (final p in geo.peers[i]) {
      if (g[p] == d) return false;
      if (g[p] < 0 && cand[p] & bit != 0) {
        cand[p] &= ~bit;
        if (cand[p] == 0) return false;
      }
    }
    return true;
  }

  /// Solves in place with deductions up to [tier]; true if fully solved.
  bool solveLogic(List<int> g, int tier) {
    final cand = _candidates(g);
    if (cand == null) return false;
    while (true) {
      var progress = false;
      // naked singles
      for (var i = 0; i < g.length; i++) {
        if (g[i] < 0 && _pop(cand[i]) == 1) {
          if (!_assign(g, cand, i, _low(cand[i]))) return false;
          progress = true;
        }
      }
      // hidden singles
      for (final u in geo.units) {
        for (var d = 0; d < n; d++) {
          final bit = 1 << d;
          var where = -1, count = 0, placed = false;
          for (final i in u) {
            if (g[i] == d) {
              placed = true;
              break;
            }
            if (g[i] < 0 && cand[i] & bit != 0) {
              count++;
              where = i;
            }
          }
          if (placed) continue;
          if (count == 0) return false;
          if (count == 1) {
            if (!_assign(g, cand, where, d)) return false;
            progress = true;
          }
        }
      }
      if (progress) continue;
      if (!g.contains(-1)) return true;
      if (tier < 2) return false;

      // locked candidates: box/line intersections
      for (var bu = 2 * n; bu < 3 * n; bu++) {
        final boxCells = geo.units[bu];
        for (var d = 0; d < n; d++) {
          final bit = 1 << d;
          final cells = [for (final i in boxCells) if (g[i] < 0 && cand[i] & bit != 0) i];
          if (cells.isEmpty) continue;
          for (final lineKind in const [0, 1]) {
            final line = geo.unitsOf[cells.first][lineKind];
            if (cells.every((i) => geo.unitsOf[i][lineKind] == line)) {
              for (final j in geo.units[line]) {
                if (g[j] < 0 && !boxCells.contains(j) && cand[j] & bit != 0) {
                  cand[j] &= ~bit;
                  if (cand[j] == 0) return false;
                  progress = true;
                }
              }
            }
          }
        }
      }
      for (var lu = 0; lu < 2 * n; lu++) {
        final lineCells = geo.units[lu];
        for (var d = 0; d < n; d++) {
          final bit = 1 << d;
          final cells = [for (final i in lineCells) if (g[i] < 0 && cand[i] & bit != 0) i];
          if (cells.isEmpty) continue;
          final b = geo.unitsOf[cells.first][2];
          if (cells.every((i) => geo.unitsOf[i][2] == b)) {
            for (final j in geo.units[b]) {
              if (g[j] < 0 && !lineCells.contains(j) && cand[j] & bit != 0) {
                cand[j] &= ~bit;
                if (cand[j] == 0) return false;
                progress = true;
              }
            }
          }
        }
      }
      // naked pairs
      for (final u in geo.units) {
        for (var a = 0; a < u.length; a++) {
          final ia = u[a];
          if (g[ia] >= 0 || _pop(cand[ia]) != 2) continue;
          for (var b = a + 1; b < u.length; b++) {
            final ib = u[b];
            if (g[ib] >= 0 || cand[ib] != cand[ia]) continue;
            for (final j in u) {
              if (j == ia || j == ib || g[j] >= 0) continue;
              if (cand[j] & cand[ia] != 0) {
                cand[j] &= ~cand[ia];
                if (cand[j] == 0) return false;
                progress = true;
              }
            }
          }
        }
      }
      if (!progress) return false;
    }
  }

  /// Number of solutions up to [limit].
  int countSolutions(List<int> g, {int limit = 2}) {
    final cand = _candidates(g);
    if (cand == null) return 0;
    return _count(List.of(g), cand, limit);
  }

  int _count(List<int> g, List<int> cand, int limit) {
    var best = -1, bestPop = 99;
    for (var i = 0; i < g.length; i++) {
      if (g[i] >= 0) continue;
      final p = _pop(cand[i]);
      if (p == 0) return 0;
      if (p < bestPop) {
        bestPop = p;
        best = i;
        if (p == 1) break;
      }
    }
    if (best < 0) return 1;
    var total = 0;
    var m = cand[best];
    while (m != 0 && total < limit) {
      final d = _low(m);
      m &= m - 1;
      final g2 = List.of(g), c2 = List.of(cand);
      if (_assign(g2, c2, best, d)) total += _count(g2, c2, limit - total);
    }
    return total;
  }

  /// Random complete grid.
  List<int> randomSolution(Random rng) {
    final g = List.filled(n * n, -1);
    final cand = _candidates(g)!;
    return _fill(g, cand, rng)!;
  }

  List<int>? _fill(List<int> g, List<int> cand, Random rng) {
    var best = -1, bestPop = 99;
    for (var i = 0; i < g.length; i++) {
      if (g[i] >= 0) continue;
      final p = _pop(cand[i]);
      if (p == 0) return null;
      if (p < bestPop) {
        bestPop = p;
        best = i;
      }
    }
    if (best < 0) return g;
    final digits = [for (var d = 0; d < n; d++) if (cand[best] & (1 << d) != 0) d]..shuffle(rng);
    for (final d in digits) {
      final g2 = List.of(g), c2 = List.of(cand);
      if (!_assign(g2, c2, best, d)) continue;
      final r = _fill(g2, c2, rng);
      if (r != null) return r;
    }
    return null;
  }
}
