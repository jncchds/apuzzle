/// Solver for "one king per row, column and region, kings never touch".
///
/// Tiers:
///  1. placements forced by a row/column/region with a single candidate,
///     plus elimination around placed kings;
///  2. + line/region confinement (all candidates of a unit in one line/region)
///     and "attack" elimination (a cell whose king would empty another unit);
///  3. + probing (assume a king, propagate tier 2, reject on contradiction).
///
/// Cells in region -1 belong to no region and can't hold a king; the generator
/// uses them while it grows regions around the solution.
class KingsSolver {
  KingsSolver(this.n, this.regions) {
    for (var r = 0; r < n; r++) {
      units.add([for (var c = 0; c < n; c++) r * n + c]);
    }
    for (var c = 0; c < n; c++) {
      units.add([for (var r = 0; r < n; r++) r * n + c]);
    }
    final byRegion = List.generate(n, (_) => <int>[]);
    for (var i = 0; i < n * n; i++) {
      if (regions[i] >= 0) byRegion[regions[i]].add(i);
    }
    units.addAll(byRegion);
    unitsOf = List.generate(n * n, (i) => [i ~/ n, n + i % n, if (regions[i] >= 0) 2 * n + regions[i]]);
    attacked = List.generate(n * n, (i) {
      final s = <int>{};
      for (final u in unitsOf[i]) {
        s.addAll(units[u]);
      }
      final r = i ~/ n, c = i % n;
      for (var dr = -1; dr <= 1; dr++) {
        for (var dc = -1; dc <= 1; dc++) {
          final rr = r + dr, cc = c + dc;
          if (rr >= 0 && cc >= 0 && rr < n && cc < n) s.add(rr * n + cc);
        }
      }
      s.remove(i);
      return s.toList();
    });
  }

  final int n;
  final List<int> regions;
  final List<List<int>> units = [];
  late final List<List<int>> unitsOf;
  late final List<List<int>> attacked;

  /// Returns the set of king cells if solved by logic up to [tier], else null.
  List<int>? solveLogic(int tier, {List<bool>? startCand}) {
    final cand = startCand ?? [for (final r in regions) r >= 0];
    final king = List<bool>.filled(n * n, false);
    if (!_propagate(cand, king, tier)) return null;
    final kings = [for (var i = 0; i < n * n; i++) if (king[i]) i];
    return kings.length == n ? kings : null;
  }

  /// How far logic up to [tier] is from a full solve (0 = solved): kings it
  /// can't place, then candidate cells it leaves open.
  int slack(int tier) {
    final cand = [for (final r in regions) r >= 0];
    final king = List<bool>.filled(n * n, false);
    _propagate(cand, king, tier);
    final missing = n - king.where((k) => k).length;
    return missing == 0 ? 0 : missing * n * n + cand.where((c) => c).length;
  }

  bool _place(List<bool> cand, List<bool> king, int i) {
    if (!cand[i]) return false;
    king[i] = true;
    cand[i] = false;
    for (final j in attacked[i]) {
      if (king[j]) return false;
      cand[j] = false;
    }
    return true;
  }

  bool _unitHasKing(List<bool> king, int u) => units[u].any((i) => king[i]);

  /// Applies logic up to [tier] in place. False only on a contradiction; a
  /// stall returns true with kings still missing.
  bool _propagate(List<bool> cand, List<bool> king, int tier) {
    while (true) {
      var progress = false;
      for (var u = 0; u < units.length; u++) {
        if (_unitHasKing(king, u)) continue;
        var count = 0, where = -1;
        for (final i in units[u]) {
          if (cand[i]) {
            count++;
            where = i;
          }
        }
        if (count == 0) return false;
        if (count == 1) {
          if (!_place(cand, king, where)) return false;
          progress = true;
        }
      }
      if (progress) continue;
      if (king.where((k) => k).length == n) return true;
      if (tier < 2) return true; // stalled

      // Confinement: all candidates of a unit inside another unit.
      for (var u = 0; u < units.length && !progress; u++) {
        if (_unitHasKing(king, u)) continue;
        final cs = [for (final i in units[u]) if (cand[i]) i];
        if (cs.isEmpty) return false;
        for (var kind = 0; kind < 3; kind++) {
          final other = unitsOf[cs.first][kind];
          if (other == u || !cs.every((i) => unitsOf[i][kind] == other)) continue;
          for (final j in units[other]) {
            if (cand[j] && !units[u].contains(j)) {
              cand[j] = false;
              progress = true;
            }
          }
        }
      }
      if (progress) continue;

      // Attack elimination.
      for (var i = 0; i < n * n && !progress; i++) {
        if (!cand[i]) continue;
        final hit = {...attacked[i], i};
        for (var u = 0; u < units.length; u++) {
          if (unitsOf[i].contains(u) || _unitHasKing(king, u)) continue;
          if (units[u].every((j) => !cand[j] || hit.contains(j))) {
            cand[i] = false;
            progress = true;
            break;
          }
        }
      }
      if (progress) continue;
      if (tier < 3) return true;

      // Probing.
      for (var i = 0; i < n * n && !progress; i++) {
        if (!cand[i]) continue;
        final c2 = List.of(cand), k2 = List.of(king);
        if (!_place(c2, k2, i) || !_propagate(c2, k2, 2)) {
          cand[i] = false;
          progress = true;
        }
      }
      if (!progress) return true;
    }
  }

  /// Up to [limit] solutions, each as a list of king columns per row.
  List<List<int>> solutions({int limit = 2}) {
    final out = <List<int>>[];
    final cols = List<int>.filled(n, -1);
    final usedCol = List<bool>.filled(n, false);
    final usedReg = List<bool>.filled(n, false);
    void rec(int r) {
      if (out.length >= limit) return;
      if (r == n) {
        out.add(List.of(cols));
        return;
      }
      for (var c = 0; c < n; c++) {
        if (usedCol[c]) continue;
        final reg = regions[r * n + c];
        if (reg < 0 || usedReg[reg]) continue;
        if (r > 0 && (cols[r - 1] - c).abs() <= 1) continue;
        cols[r] = c;
        usedCol[c] = true;
        usedReg[reg] = true;
        rec(r + 1);
        usedCol[c] = false;
        usedReg[reg] = false;
        if (out.length >= limit) return;
      }
    }

    rec(0);
    return out;
  }

  /// Hardest tier needed (1..3), or 4 when guessing is required.
  int grade() {
    for (var t = 1; t <= 3; t++) {
      if (solveLogic(t) != null) return t;
    }
    return 4;
  }
}
