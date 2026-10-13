import 'dart:typed_data';

import '../../core/explain.dart';
import 'orbits_model.dart';

/// What a traced [OrbitsSolver.propagate] records ([Fact.rule]). A slot is
/// a cell and a star (`cell * count + star`), the value the star. [twinOut]
/// and [reach] rule the star out, [only], [twin] and [bridge] give the cell
/// to it, and [taken] rules out the other stars of a cell just given away.
/// Args: [twinOut] and [twin] the twin cell, [bridge] the cell that would be
/// cut off, [failEmpty] the cell.
enum OrbitsRule { twinOut, reach, only, twin, bridge, taken, failEmpty }

/// Candidate logic for Tentai Show. Knowledge is one flag per (cell, star):
/// whether the cell may still belong to the star.
/// Tier 1: a cell and its twin go together, a cell needs a way to its star
/// through cells that may join it, and a cell with one star left takes it.
/// Tier 2: + a cell is its star's if a cell of that star would be cut off
/// without it. Tier 3: + probing.
class OrbitsSolver {
  OrbitsSolver(this.g) : n = g.n, count = g.count;

  final OrbitsGeometry g;
  final int n;
  final int count;

  /// Everything the stars' places allow, with [owner]'s cells decided.
  Uint8List start([List<int>? owner]) {
    final c = Uint8List(n * count);
    for (var i = 0; i < n; i++) {
      final own = owner == null ? g.home[i] : owner[i];
      for (var k = 0; k < count; k++) {
        if ((own < 0 || own == k) && g.fits(i, k)) c[i * count + k] = 1;
      }
    }
    return c;
  }

  int options(Uint8List c, int i) {
    var m = 0;
    for (var k = i * count, end = k + count; k < end; k++) {
      m += c[k];
    }
    return m;
  }

  /// The star of [i] if it is decided, else -1.
  int starOf(Uint8List c, int i) {
    var found = -1;
    for (var k = 0; k < count; k++) {
      if (c[i * count + k] == 0) continue;
      if (found >= 0) return -1;
      found = k;
    }
    return found;
  }

  bool solved(Uint8List c) {
    for (var i = 0; i < n; i++) {
      if (options(c, i) != 1) return false;
    }
    return true;
  }

  List<int> owners(Uint8List c) => [for (var i = 0; i < n; i++) starOf(c, i)];

  /// Gives [i] to star [k]. With [t], recorded as [rule] (a rule index).
  void decide(
    Uint8List c,
    int i,
    int k, [
    ExplainTrace? t,
    int rule = 0,
    List<int> premises = const [],
    List<int> args = const [],
  ]) {
    if (t != null) {
      t.fact(i * count + k, k, rule, premises: premises, args: args);
      for (var o = 0; o < count; o++) {
        if (o == k || c[i * count + o] == 0) continue;
        t.fact(i * count + o, o, OrbitsRule.taken.index, premises: [i * count + k]);
      }
    }
    c.fillRange(i * count, (i + 1) * count, 0);
    c[i * count + k] = 1;
  }

  /// Every slot of cell [i], but the one of star [except].
  List<int> slots(int i, [int except = -1]) => [
    for (var k = 0; k < count; k++)
      if (k != except) i * count + k,
  ];

  /// Applies the logic of [tier] (1 or 2) in place; false on a
  /// contradiction. With [t], every deduction is recorded (see [OrbitsRule]).
  bool propagate(Uint8List c, int tier, [ExplainTrace? t]) {
    final mark = Int32List(n);
    var stamp = 0;
    var failed = false;

    // Rules star [k] out of cell [i].
    void drop(int i, int k, OrbitsRule rule, List<int> premises, List<int> args) {
      c[i * count + k] = 0;
      final left = options(c, i);
      if (t != null) {
        t.fact(i * count + k, k, rule.index, premises: premises, args: args);
        final one = left == 1 ? starOf(c, i) : -1;
        if (left == 1) t.fact(i * count + one, one, OrbitsRule.only.index, premises: slots(i, one));
        if (left == 0) t.fail(OrbitsRule.failEmpty.index, premises: slots(i), args: [i]);
      }
      if (left == 0) failed = true;
    }

    // Marks the cells star [k] can reach from its own, not through [skip]
    // cells. Returns them.
    List<int> reach(int k, int skipA, int skipB) {
      stamp++;
      final queue = <int>[];
      for (final i in g.core[k]) {
        if (c[i * count + k] != 0) {
          mark[i] = stamp;
          queue.add(i);
        }
      }
      for (var q = 0; q < queue.length; q++) {
        for (final j in g.nb[queue[q]]) {
          if (mark[j] != stamp && j != skipA && j != skipB && c[j * count + k] != 0) {
            mark[j] = stamp;
            queue.add(j);
          }
        }
      }
      return queue;
    }

    // The slots that stopped the last [reach] of star [k].
    List<int> border(List<int> reached, int k) => {
      for (final i in reached)
        for (final j in g.nb[i])
          if (mark[j] != stamp) j * count + k,
    }.toList();

    for (var i = 0; i < n; i++) {
      if (options(c, i) == 0) {
        t?.fail(OrbitsRule.failEmpty.index, premises: slots(i), args: [i]);
        return false;
      }
    }

    var changed = true;
    while (changed) {
      changed = false;
      // A cell and its twin go together.
      for (var i = 0; i < n; i++) {
        final one = starOf(c, i);
        for (var k = 0; k < count; k++) {
          final j = g.twin(i, k);
          if (j < 0) continue;
          if (c[i * count + k] != 0 && c[j * count + k] == 0) {
            drop(i, k, OrbitsRule.twinOut, [j * count + k], [j]);
            if (failed) return false;
            changed = true;
          }
        }
        if (one >= 0 && c[i * count + one] != 0) {
          final j = g.twin(i, one);
          if (options(c, j) > 1) {
            decide(c, j, one, t, OrbitsRule.twin.index, t == null ? const [] : slots(i), [i]);
            changed = true;
          }
        }
      }
      if (changed) continue;
      // A cell needs a way to its star.
      for (var k = 0; k < count; k++) {
        final reached = reach(k, -1, -1);
        List<int>? walls;
        for (var i = 0; i < n; i++) {
          if (mark[i] == stamp || c[i * count + k] == 0) continue;
          if (t != null) walls ??= border(reached, k);
          drop(i, k, OrbitsRule.reach, walls ?? const [], const []);
          if (failed) return false;
          changed = true;
        }
      }
      if (changed || tier < 2) continue;
      // A cell without which a cell of its star would be cut off.
      for (var k = 0; k < count && !changed; k++) {
        final mine = [
          for (var i = 0; i < n; i++)
            if (g.home[i] != k && c[i * count + k] != 0 && options(c, i) == 1) i,
        ];
        if (mine.isEmpty) continue;
        final open = [
          for (final i in reach(k, -1, -1))
            if (options(c, i) > 1) i,
        ];
        for (final i in open) {
          if (options(c, i) == 1) continue;
          final reached = reach(k, i, g.twin(i, k));
          final lost = mine.where((x) => mark[x] != stamp).firstOrNull;
          if (lost == null) continue;
          final premises = t == null
              ? const <int>[]
              : [
                  for (final x in mine) ...slots(x),
                  ...border(reached, k)
                    ..remove(i * count + k)
                    ..remove(g.twin(i, k) * count + k),
                ];
          decide(c, i, k, t, OrbitsRule.bridge.index, premises, [lost]);
          changed = true;
        }
      }
    }
    return true;
  }

  /// Solves in place with logic up to [tier]; true if every cell is decided.
  bool solve(Uint8List c, int tier) {
    if (!propagate(c, tier < 2 ? 1 : 2)) return false;
    if (tier < 3) return solved(c);
    var progress = true;
    while (progress && !solved(c)) {
      progress = false;
      for (var want = 2; want <= count && !progress; want++) {
        for (var i = 0; i < n; i++) {
          if (options(c, i) != want) continue;
          for (var k = 0; k < count; k++) {
            if (c[i * count + k] == 0) continue;
            final probe = Uint8List.fromList(c);
            decide(probe, i, k);
            if (propagate(probe, 2)) continue;
            c[i * count + k] = 0;
            if (!propagate(c, 2)) return false;
            progress = true;
          }
        }
      }
    }
    return solved(c);
  }

  /// The lowest tier (1 to 3) that solves the board, or 0 if none does.
  int grade() {
    for (var tier = 1; tier <= 3; tier++) {
      if (solve(start(), tier)) return tier;
    }
    return 0;
  }

  /// Number of solutions (up to [limit]), or -1 if the search gets too big.
  int countSolutions({int limit = 2, int budget = 20000}) {
    var nodes = 0, total = 0;
    void rec(Uint8List cur) {
      if (total >= limit || ++nodes > budget) return;
      if (!propagate(cur, 2)) return;
      var pick = -1, best = 1 << 30;
      for (var i = 0; i < n; i++) {
        final m = options(cur, i);
        if (m > 1 && m < best) {
          best = m;
          pick = i;
        }
      }
      if (pick < 0) {
        total++;
        return;
      }
      for (var k = 0; k < count; k++) {
        if (cur[pick * count + k] == 0) continue;
        final next = Uint8List.fromList(cur);
        decide(next, pick, k);
        rec(next);
      }
    }

    rec(start());
    return nodes > budget ? -1 : total;
  }
}
