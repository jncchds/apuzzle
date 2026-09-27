import 'dart:math';

import '../../core/grid_graph.dart';

/// Norinori logic on cell states: -1 unknown, 0 unshaded, 1 shaded.
/// Tier 1: region counts and domino rules (a shaded cell with a partner
/// closes its other sides; one with a single way out takes it; a cell next
/// to two shaded cells, or with no room for a partner, stays unshaded).
/// Tier 2: + what every way to finish a region agrees on. Tier 3: + probing.
class PairsSolver {
  PairsSolver(this.n, this.regions) : nb = orthNeighbors(n, n) {
    members = List.generate(regions.reduce(max) + 1, (_) => <int>[]);
    for (var i = 0; i < n * n; i++) {
      if (regions[i] >= 0) members[regions[i]].add(i);
    }
  }

  final int n;
  final List<int> regions;
  final List<List<int>> nb;
  late final List<List<int>> members;

  /// Cells outside every region (-1, only while generating) stay unshaded.
  List<int> start() => [for (final r in regions) r < 0 ? 0 : -1];

  /// Applies logic up to [tier] (1 or 2) in place; false on a contradiction.
  bool propagate(List<int> st, [int tier = 2]) {
    var changed = true;
    bool set(int i, int v) {
      if (st[i] == v) return true;
      if (st[i] != -1) return false;
      st[i] = v;
      changed = true;
      return true;
    }

    while (changed) {
      changed = false;
      for (final cells in members) {
        var s = 0, u = 0;
        for (final i in cells) {
          if (st[i] == 1) s++;
          if (st[i] == -1) u++;
        }
        if (s > 2 || s + u < 2) return false;
        if (u == 0 || (s < 2 && s + u > 2)) continue;
        final v = s == 2 ? 0 : 1;
        for (final i in cells) {
          if (st[i] == -1) set(i, v);
        }
      }
      for (var i = 0; i < n * n; i++) {
        var sn = 0, un = 0, open = -1;
        for (final j in nb[i]) {
          if (st[j] == 1) sn++;
          if (st[j] == -1) {
            un++;
            open = j;
          }
        }
        if (st[i] == 1) {
          if (sn > 1 || sn + un == 0) return false;
          if (sn == 1) {
            for (final j in nb[i]) {
              if (st[j] == -1) set(j, 0);
            }
          } else if (un == 1) {
            set(open, 1);
          }
        } else if (st[i] == -1) {
          if (sn >= 2 || sn + un == 0) {
            set(i, 0);
          } else if (sn == 1) {
            // The shaded neighbour must have no partner yet.
            final j = nb[i].firstWhere((j) => st[j] == 1);
            if (nb[j].any((k) => k != i && st[k] == 1)) set(i, 0);
          }
        }
      }
      if (changed || tier < 2) continue;
      for (var r = 0; r < members.length; r++) {
        if (!_finishRegion(st, r, set)) return false;
      }
    }
    return true;
  }

  /// Tries every way to finish region [r]: a cell shaded in all of them is
  /// shaded, one shaded in none stays unshaded. False if there is no way.
  bool _finishRegion(List<int> st, int r, bool Function(int, int) set) {
    final cells = members[r];
    final open = [
      for (final i in cells)
        if (st[i] == -1) i,
    ];
    final need = 2 - cells.where((i) => st[i] == 1).length;
    if (open.isEmpty || need <= 0 || open.length > 12) return true;
    final around = {
      for (final i in cells) ...[i, ...nb[i]],
    };
    var always = (1 << open.length) - 1, ever = 0, ways = 0;
    void tryPick(int mask) {
      for (var k = 0; k < open.length; k++) {
        st[open[k]] = mask & (1 << k) != 0 ? 1 : 0;
      }
      var ok = true;
      for (final y in around) {
        if (st[y] != 1) continue;
        var sn = 0, un = 0;
        for (final j in nb[y]) {
          if (st[j] == 1) sn++;
          if (st[j] == -1) un++;
        }
        if (sn > 1 || sn + un == 0) {
          ok = false;
          break;
        }
      }
      if (ok) {
        ways++;
        always &= mask;
        ever |= mask;
      }
    }

    for (var a = 0; a < open.length; a++) {
      if (need == 1) {
        tryPick(1 << a);
        continue;
      }
      for (var b = a + 1; b < open.length; b++) {
        tryPick(1 << a | 1 << b);
      }
    }
    for (final i in open) {
      st[i] = -1;
    }
    if (ways == 0) return false;
    for (var k = 0; k < open.length; k++) {
      if (always & (1 << k) != 0) set(open[k], 1);
      if (ever & (1 << k) == 0) set(open[k], 0);
    }
    return true;
  }

  /// Solves in place with logic up to [tier]; false on a contradiction.
  bool solve(List<int> st, int tier) {
    if (!propagate(st, min(tier, 2))) return false;
    if (tier >= 3) {
      var progress = true;
      while (progress && st.contains(-1)) {
        progress = false;
        for (var i = 0; i < st.length; i++) {
          if (st[i] != -1) continue;
          for (final v in const [1, 0]) {
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

  /// Cells logic up to [tier] leaves open (n² + 1 on a contradiction).
  int slack(int tier) {
    final st = start();
    if (!solve(st, tier)) return n * n + 1;
    return st.where((x) => x == -1).length;
  }

  /// Lowest tier (1..3) that solves the board, or 4.
  int grade() {
    for (var t = 1; t <= 3; t++) {
      if (slack(t) == 0) return t;
    }
    return 4;
  }

  /// Number of solutions (up to [limit]), or -1 if the search gets too big.
  /// With [rng] the order is random and the first solution goes to [found];
  /// [all] collects every solution found.
  int countSolutions({int limit = 2, Random? rng, List<bool>? found, List<List<bool>>? all, int budget = 100000}) {
    var nodes = 0, total = 0;
    void rec(List<int> st) {
      if (total >= limit || ++nodes > budget) return;
      if (!propagate(st)) return;
      final open = [
        for (var i = 0; i < st.length; i++)
          if (st[i] == -1) i,
      ];
      if (open.isEmpty) {
        if (total == 0 && found != null) found.setAll(0, [for (final x in st) x == 1]);
        all?.add([for (final x in st) x == 1]);
        total++;
        return;
      }
      final pick = rng == null ? open.first : open[rng.nextInt(open.length)];
      for (final v in rng == null || rng.nextBool() ? const [1, 0] : const [0, 1]) {
        rec(List.of(st)..[pick] = v);
      }
    }

    rec(start());
    return nodes > budget ? -1 : total;
  }
}
