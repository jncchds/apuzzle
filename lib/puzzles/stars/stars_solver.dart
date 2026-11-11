import '../../core/explain.dart';
import 'stars_model.dart';

/// What a traced [StarsSolver.propagate] records ([Fact.rule]): a star
/// ([sStar]) or a ruled-out cell ([sDot]) per fact.
///
/// Args: [touch] the star; [full], [fill], [squeeze], [attack] and
/// [failEmpty] the unit (rows 0..n-1, columns n..2n-1, regions from 2n);
/// [bandIn] and [bandOut] `[kind, first, last]` (kind 0 rows, 1 columns);
/// [failClash] the two stars; [failBand] like the bands.
enum StarsRule { touch, full, fill, squeeze, attack, bandIn, bandOut, failEmpty, failClash, failBand }

/// Solver for "k stars in every row, column and region, stars never touch,
/// not even diagonally".
///
/// Tiers:
///  1. stars rule out the cells around them, a unit with its stars rules out
///     the rest, a unit with just enough open cells takes them all, and a cell
///     every non-touching way to finish a unit uses is a star (`squeeze`);
///  2. + a star that would leave some unit too few places is ruled out
///     (`attack`), and band counting: when the regions lying wholly inside a
///     band of rows (or columns) are as many as its lines, they fill it and
///     the other regions get no star there; when the regions reaching into a
///     band are as many as its lines, they have no star outside it;
///  3. + probing (assume a star, run tier 2, reject on a contradiction).
///
/// Cells in region -1 belong to no region and can't hold a star.
class StarsSolver {
  StarsSolver(this.n, this.regions, {this.k = starsPerUnit, this.disabled = const {}}) {
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
    around = List.generate(n * n, (i) {
      final r = i ~/ n, c = i % n;
      return [
        for (var dr = -1; dr <= 1; dr++)
          for (var dc = -1; dc <= 1; dc++)
            if ((dr != 0 || dc != 0) && r + dr >= 0 && c + dc >= 0 && r + dr < n && c + dc < n) (r + dr) * n + c + dc,
      ];
    });
  }

  final int n;
  final int k;
  final List<int> regions;

  /// Rules left out, for tests and lesson checks ([StarsRule.squeeze],
  /// [StarsRule.attack], or [StarsRule.bandIn] for both band rules).
  final Set<StarsRule> disabled;
  final List<List<int>> units = [];
  late final List<List<int>> unitsOf;

  /// The up to 8 cells around each cell.
  late final List<List<int>> around;

  late final List<int> _row = [for (var i = 0; i < n * n; i++) i ~/ n];
  late final List<int> _col = [for (var i = 0; i < n * n; i++) i % n];

  bool touching(int i, int j) => (_row[i] - _row[j]).abs() <= 1 && (_col[i] - _col[j]).abs() <= 1;

  /// Fresh knowledge: every cell of a region is open.
  List<bool> startCand() => [for (final r in regions) r >= 0];

  /// The star cells if logic up to [tier] solves the board, else null.
  List<int>? solveLogic(int tier) {
    final cand = startCand();
    final star = List<bool>.filled(n * n, false);
    if (!_propagate(cand, star, tier)) return null;
    final stars = [
      for (var i = 0; i < n * n; i++)
        if (star[i]) i,
    ];
    return stars.length == k * n ? stars : null;
  }

  /// How far logic up to [tier] is from a full solve (0 = solved): stars it
  /// can't place, then open cells it leaves.
  int slack(int tier) {
    final cand = startCand();
    final star = List<bool>.filled(n * n, false);
    if (!_propagate(cand, star, tier)) return 1 << 28;
    final missing = k * n - star.where((s) => s).length;
    return missing == 0 ? 0 : missing * n * n + cand.where((c) => c).length;
  }

  /// Hardest tier needed (1..3), or 4 when guessing is required.
  int grade() {
    for (var t = 1; t <= 3; t++) {
      if (solveLogic(t) != null) return t;
    }
    return 4;
  }

  int _stars(List<bool> star, int u) {
    var s = 0;
    for (final i in units[u]) {
      if (star[i]) s++;
    }
    return s;
  }

  List<int> _open(List<bool> cand, int u) => [
    for (final i in units[u])
      if (cand[i]) i,
  ];

  /// Whether [need] pairwise non-touching cells can be picked from [open]
  /// (from [from] on).
  bool canHold(List<int> open, int need, [int from = 0]) {
    if (need <= 0) return true;
    if (open.length - from < need) return false;
    if (need == 1) return true;
    if (need == 2) {
      for (var a = from; a < open.length; a++) {
        for (var b = a + 1; b < open.length; b++) {
          if (!touching(open[a], open[b])) return true;
        }
      }
      return false;
    }
    for (var a = from; a <= open.length - need; a++) {
      final rest = [
        for (var b = a + 1; b < open.length; b++)
          if (!touching(open[a], open[b])) open[b],
      ];
      if (canHold(rest, need - 1)) return true;
    }
    return false;
  }

  /// Whether [need] non-touching cells of [open] stay open (in [cand]) and
  /// clear of cell [x].
  bool _holdsWithout(List<int> open, int need, List<bool> cand, int x) {
    bool ok(int j) => cand[j] && !touching(x, j);
    if (need == 1) return open.any(ok);
    if (need == 2) {
      for (var a = 0; a < open.length; a++) {
        if (!ok(open[a])) continue;
        for (var b = a + 1; b < open.length; b++) {
          if (ok(open[b]) && !touching(open[a], open[b])) return true;
        }
      }
      return false;
    }
    return canHold([
      for (final j in open)
        if (ok(j)) j,
    ], need);
  }

  /// An open cell that every non-touching pair of [open] holds, or -1 (also
  /// when there is no pair).
  int _inEveryPair(List<int> open) {
    var pairs = 0;
    final count = List<int>.filled(open.length, 0);
    for (var a = 0; a < open.length; a++) {
      for (var b = a + 1; b < open.length; b++) {
        if (touching(open[a], open[b])) continue;
        pairs++;
        count[a]++;
        count[b]++;
      }
    }
    if (pairs == 0) return -1;
    for (var a = 0; a < open.length; a++) {
      if (count[a] == pairs) return open[a];
    }
    return -1;
  }

  /// Places a star on [i] (also an assumption); false on a contradiction.
  bool place(List<bool> cand, List<bool> star, int i, [ExplainTrace? t]) {
    if (!cand[i]) return false;
    star[i] = true;
    cand[i] = false;
    for (final j in around[i]) {
      if (star[j]) {
        t?.fail(StarsRule.failClash.index, premises: [i, j], args: [i, j]);
        return false;
      }
      if (cand[j]) {
        t?.fact(j, sDot, StarsRule.touch.index, premises: [i], args: [i]);
        cand[j] = false;
      }
    }
    for (final u in unitsOf[i]) {
      if (_stars(star, u) < k) continue;
      final have = [
        for (final j in units[u])
          if (star[j]) j,
      ];
      for (final j in units[u]) {
        if (cand[j]) {
          t?.fact(j, sDot, StarsRule.full.index, premises: have, args: [u]);
          cand[j] = false;
        }
      }
    }
    return true;
  }

  /// Logic up to [tier] (1..3) in place; false on a contradiction. With [t],
  /// every deduction is recorded (see [StarsRule]).
  bool propagate(List<bool> cand, List<bool> star, int tier, [ExplainTrace? t]) => _propagate(cand, star, tier, t);

  bool _propagate(List<bool> cand, List<bool> star, int tier, [ExplainTrace? t, bool attack = true]) {
    while (true) {
      var progress = false;
      // Fill: a unit with just enough open cells.
      var total = 0;
      for (var u = 0; u < units.length; u++) {
        final have = _stars(star, u);
        if (u < n) total += have;
        final need = k - have;
        if (need <= 0) continue;
        var count = 0;
        for (final i in units[u]) {
          if (cand[i]) count++;
        }
        if (count > need) continue;
        final open = _open(cand, u);
        if (open.length < need) {
          t?.fail(StarsRule.failEmpty.index, premises: units[u], args: [u]);
          return false;
        }
        if (open.length == need) {
          for (final i in open) {
            if (!cand[i]) {
              t?.fail(StarsRule.failEmpty.index, premises: units[u], args: [u]);
              return false;
            }
            t?.fact(i, sStar, StarsRule.fill.index, premises: units[u], args: [u]);
            if (!place(cand, star, i, t)) return false;
          }
          progress = true;
        }
      }
      if (progress) continue;
      if (total == k * n) return true;

      // Squeeze: a cell every way to finish a unit uses.
      for (var u = 0; u < units.length && !progress && !disabled.contains(StarsRule.squeeze); u++) {
        final need = k - _stars(star, u);
        if (need < 2) continue;
        final open = _open(cand, u);
        if (!canHold(open, need)) {
          t?.fail(StarsRule.failEmpty.index, premises: units[u], args: [u]);
          return false;
        }
        // Pairs of open cells that don't touch, and how many hold each cell.
        final forced = need == 2 ? _inEveryPair(open) : -1;
        for (final i in need == 2 ? [if (forced >= 0) forced] : open) {
          if (need > 2) {
            final rest = [
              for (final j in open)
                if (j != i) j,
            ];
            if (canHold(rest, need)) continue;
          }
          t?.fact(i, sStar, StarsRule.squeeze.index, premises: units[u], args: [u]);
          if (!place(cand, star, i, t)) return false;
          progress = true;
          break;
        }
      }
      if (progress) continue;
      if (tier < 2) return true;

      // Attack: a star that would leave a unit too few places.
      final needs = [for (var u = 0; u < units.length; u++) k - _stars(star, u)];
      final opens = [for (var u = 0; u < units.length; u++) _open(cand, u)];
      final stamp = List<int>.filled(units.length, -1);
      for (var i = 0; i < n * n && attack && !disabled.contains(StarsRule.attack); i++) {
        if (!cand[i]) continue;
        cells:
        for (final g in [i, ...around[i]]) {
          for (final u in unitsOf[g]) {
            if (stamp[u] == i) continue;
            stamp[u] = i;
            final need = needs[u] - (unitsOf[i].contains(u) ? 1 : 0);
            if (need <= 0) continue;
            if (!_holdsWithout(opens[u], need, cand, i)) {
              t?.fact(i, sDot, StarsRule.attack.index, premises: units[u], args: [u]);
              cand[i] = false;
              progress = true;
              break cells;
            }
          }
        }
      }
      if (progress) continue;

      // Bands of rows or columns.
      final band = disabled.contains(StarsRule.bandIn) ? false : _bands(cand, star, t);
      if (band == null) return false;
      if (band) continue;
      if (tier < 3) return true;

      // Probing.
      for (var i = 0; i < n * n && !progress; i++) {
        if (!cand[i]) continue;
        final c2 = List.of(cand), s2 = List.of(star);
        if (!place(c2, s2, i) || !_propagate(c2, s2, 2)) {
          cand[i] = false;
          progress = true;
        }
      }
      if (!progress) return true;
    }
  }

  /// Band counting; true on progress, false for none, null on a
  /// contradiction.
  bool? _bands(List<bool> cand, List<bool> star, ExplainTrace? t) {
    // Lines (row or column, by kind) each region still uses.
    for (var kind = 0; kind < 2; kind++) {
      int line(int i) => kind == 0 ? i ~/ n : i % n;
      final lo = List<int>.filled(n, n), hi = List<int>.filled(n, -1);
      for (var i = 0; i < n * n; i++) {
        final reg = regions[i];
        if (reg < 0 || !(cand[i] || star[i])) continue;
        final l = line(i);
        if (l < lo[reg]) lo[reg] = l;
        if (l > hi[reg]) hi[reg] = l;
      }
      for (var a = 0; a < n; a++) {
        for (var b = a; b < n && b - a + 1 < n; b++) {
          final lines = b - a + 1;
          var nIn = 0, nReach = 0;
          for (var reg = 0; reg < n; reg++) {
            if (hi[reg] < 0) continue;
            if (lo[reg] >= a && hi[reg] <= b) nIn++;
            if (hi[reg] >= a && lo[reg] <= b) nReach++;
          }
          if (nIn < lines && nReach > lines) continue;
          final inside = <int>[], reaching = <int>[];
          for (var reg = 0; reg < n; reg++) {
            if (hi[reg] < 0) continue;
            if (lo[reg] >= a && hi[reg] <= b) inside.add(reg);
            if (hi[reg] >= a && lo[reg] <= b) reaching.add(reg);
          }
          List<int> cellsOf(List<int> regs) => [
            for (var i = 0; i < n * n; i++)
              if (regs.contains(regions[i])) i,
          ];
          if (inside.length > lines || reaching.length < lines) {
            final regs = inside.length > lines ? inside : reaching;
            t?.fail(StarsRule.failBand.index, premises: cellsOf(regs), args: [kind, a, b]);
            return null;
          }
          var progress = false;
          if (inside.length == lines) {
            List<int>? why;
            for (var i = 0; i < n * n; i++) {
              final l = line(i);
              if (!cand[i] || l < a || l > b || inside.contains(regions[i])) continue;
              t?.fact(i, sDot, StarsRule.bandIn.index, premises: why ??= cellsOf(inside), args: [kind, a, b]);
              cand[i] = false;
              progress = true;
            }
          }
          if (reaching.length == lines) {
            List<int>? why;
            for (var i = 0; i < n * n; i++) {
              final l = line(i);
              if (!cand[i] || (l >= a && l <= b) || !reaching.contains(regions[i])) continue;
              t?.fact(i, sDot, StarsRule.bandOut.index, premises: why ??= cellsOf(reaching), args: [kind, a, b]);
              cand[i] = false;
              progress = true;
            }
          }
          if (progress) return true;
        }
      }
    }
    return false;
  }

  /// Up to [limit] solutions, each as the star cells in reading order.
  List<List<int>> solutions({int limit = 2, int tier = 2}) {
    final out = <List<int>>[];
    void rec(List<bool> cand, List<bool> star) {
      if (out.length >= limit) return;
      // The attack rule costs more than the branches it saves here.
      if (!_propagate(cand, star, tier, null, false)) return;
      var best = -1, bestOpen = 1 << 30;
      for (var u = 0; u < units.length; u++) {
        if (_stars(star, u) >= k) continue;
        final open = _open(cand, u).length;
        if (open < bestOpen) {
          bestOpen = open;
          best = u;
        }
      }
      if (best < 0) {
        out.add([
          for (var i = 0; i < n * n; i++)
            if (star[i]) i,
        ]);
        return;
      }
      final i = units[best].firstWhere((j) => cand[j]);
      final c2 = List.of(cand), s2 = List.of(star);
      if (place(c2, s2, i)) rec(c2, s2);
      cand[i] = false;
      rec(cand, star);
    }

    rec(startCand(), List<bool>.filled(n * n, false));
    return out;
  }

  /// Number of solutions, up to [limit].
  int countSolutions({int limit = 2}) => solutions(limit: limit).length;
}
