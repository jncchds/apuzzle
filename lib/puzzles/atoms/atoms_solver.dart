import 'atoms_model.dart';

/// Interval solver: every edge has [lo, hi] bonds (0..2).
///  Tier 1: island sums + crossings.
///  Tier 2: + probing single edge values (tier-1 propagation).
///  Tier 3: + probing with connectivity contradictions (a closed sub-network,
///          or a potential network that is already disconnected).
/// All rules are sound, so a logical solve implies uniqueness.
class AtomsSolver {
  AtomsSolver(this.p)
      : cross = atomCrossings(p.cols, p.islands, p.edges),
        edgesOf = List.generate(p.islands.length, (_) => <int>[]) {
    for (var e = 0; e < p.edges.length; e++) {
      edgesOf[p.edges[e].a].add(e);
      edgesOf[p.edges[e].b].add(e);
    }
  }

  final AtomsPuzzle p;
  final List<List<int>> cross;
  final List<List<int>> edgesOf;

  List<int> initialLo() => List.filled(p.edges.length, 0);
  List<int> initialHi() => [
        for (final e in p.edges) [2, p.numbers[e.a], p.numbers[e.b]].reduce((a, b) => a < b ? a : b),
      ];

  bool _propagate(List<int> lo, List<int> hi, bool conn) {
    var changed = true;
    while (changed) {
      changed = false;
      for (var k = 0; k < p.islands.length; k++) {
        var sLo = 0, sHi = 0;
        for (final e in edgesOf[k]) {
          sLo += lo[e];
          sHi += hi[e];
        }
        final num = p.numbers[k];
        if (sLo > num || sHi < num) return false;
        for (final e in edgesOf[k]) {
          final newLo = num - (sHi - hi[e]);
          final newHi = num - (sLo - lo[e]);
          if (newLo > lo[e]) {
            lo[e] = newLo;
            changed = true;
          }
          if (newHi < hi[e]) {
            hi[e] = newHi;
            changed = true;
          }
          if (lo[e] > hi[e]) return false;
        }
      }
      for (var e = 0; e < p.edges.length; e++) {
        if (lo[e] == 0) continue;
        for (final f in cross[e]) {
          if (lo[f] > 0) return false;
          if (hi[f] > 0) {
            hi[f] = 0;
            changed = true;
          }
        }
      }
      if (conn && !changed && !_connectivityOk(lo, hi)) return false;
    }
    return true;
  }

  bool _connectivityOk(List<int> lo, List<int> hi) {
    final n = p.islands.length;
    if (!_connected(n, (e) => hi[e] > 0)) return false;
    final comp = _components(n, (e) => lo[e] > 0);
    final compCount = comp.reduce((a, b) => a > b ? a : b) + 1;
    if (compCount == 1) return true;
    final closed = List<bool>.filled(compCount, true);
    for (var k = 0; k < n; k++) {
      var sum = 0;
      for (final e in edgesOf[k]) {
        sum += lo[e];
        if (hi[e] > lo[e]) closed[comp[k]] = false;
      }
      if (sum != p.numbers[k]) closed[comp[k]] = false;
    }
    return !closed.contains(true);
  }

  List<int> _components(int n, bool Function(int e) use) {
    final comp = List<int>.filled(n, -1);
    var c = 0;
    for (var s = 0; s < n; s++) {
      if (comp[s] >= 0) continue;
      final stack = [s];
      comp[s] = c;
      while (stack.isNotEmpty) {
        final k = stack.removeLast();
        for (final e in edgesOf[k]) {
          if (!use(e)) continue;
          final o = p.edges[e].a == k ? p.edges[e].b : p.edges[e].a;
          if (comp[o] < 0) {
            comp[o] = c;
            stack.add(o);
          }
        }
      }
      c++;
    }
    return comp;
  }

  bool _connected(int n, bool Function(int e) use) => !_components(n, use).any((c) => c != 0);

  /// Bond counts if solved by logic up to [tier], else null.
  List<int>? solveLogic(int tier) {
    final lo = initialLo(), hi = initialHi();
    final conn = tier >= 3;
    if (!_propagate(lo, hi, conn)) return null;
    if (tier >= 2) {
      var progress = true;
      while (progress && !_fixed(lo, hi)) {
        progress = false;
        for (var e = 0; e < p.edges.length && !progress; e++) {
          if (lo[e] == hi[e]) continue;
          for (var v = lo[e]; v <= hi[e]; v++) {
            final l2 = List.of(lo)..[e] = v, h2 = List.of(hi)..[e] = v;
            if (!_propagate(l2, h2, conn)) {
              if (v == lo[e]) {
                lo[e]++;
              } else if (v == hi[e]) {
                hi[e]--;
              } else {
                continue; // middle value impossible: can't express as interval
              }
              if (!_propagate(lo, hi, conn)) return null;
              progress = true;
              break;
            }
          }
        }
      }
    }
    if (!_fixed(lo, hi)) return null;
    return atomsSolved(p, lo) ? lo : null;
  }

  bool _fixed(List<int> lo, List<int> hi) {
    for (var e = 0; e < lo.length; e++) {
      if (lo[e] != hi[e]) return false;
    }
    return true;
  }

  /// Up to [limit] solutions.
  List<List<int>> solutions({int limit = 2, int budget = 200000}) {
    final out = <List<int>>[];
    var nodes = 0;
    void rec(List<int> lo, List<int> hi) {
      if (out.length >= limit || ++nodes > budget) return;
      if (!_propagate(lo, hi, true)) return;
      var e = -1;
      for (var x = 0; x < lo.length; x++) {
        if (lo[x] != hi[x]) {
          e = x;
          break;
        }
      }
      if (e < 0) {
        if (atomsSolved(p, lo)) out.add(List.of(lo));
        return;
      }
      for (var v = hi[e]; v >= lo[e]; v--) {
        rec(List.of(lo)..[e] = v, List.of(hi)..[e] = v);
        if (out.length >= limit) return;
      }
    }

    rec(initialLo(), initialHi());
    if (nodes > budget && out.length == 1) out.add(out.first); // unknown → ambiguous
    return out;
  }

  int grade() {
    for (var t = 1; t <= 3; t++) {
      if (solveLogic(t) != null) return t;
    }
    return 4;
  }
}
