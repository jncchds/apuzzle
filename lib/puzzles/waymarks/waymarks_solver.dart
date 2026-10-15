import 'dart:typed_data';

import '../../core/explain.dart';
import 'waymarks_model.dart';

/// What a traced [WaymarksSolver.propagate] records ([Fact.rule]). Link
/// facts have an edge as slot (1 = linked, 0 = ruled out); number facts the
/// slot [WaymarksSolver.numberSlot] of a cell, the count of numbers left as
/// value, and the numbers it can still be (1-based) as args.
enum WaymarksRule {
  onlyOut,
  onlyIn,
  taken,
  consecutive,
  apart,
  numberOn,
  loop,
  before,
  after,
  used,
  noFit,
  failStuck,
  failNoPrev,
  failNumber,
  failLoop,
  failLink,
}

/// What a solver knows: per edge -1 open, 0 ruled out, 1 linked; per cell a
/// bit set of the numbers (0-based) it can still hold, and the number it
/// surely holds (or -1); per number the cell that holds it (or -1).
class WaymarksKnow {
  WaymarksKnow(this.edge, this.pos, this.fixed, this.holder);

  WaymarksKnow.copy(WaymarksKnow o)
    : edge = Int8List.fromList(o.edge),
      pos = Int32List.fromList(o.pos),
      fixed = Int16List.fromList(o.fixed),
      holder = Int16List.fromList(o.holder);

  final Int8List edge;
  final Int32List pos;
  final Int16List fixed;
  final Int16List holder;
}

const int _bits = 30;
const int _mask = (1 << _bits) - 1;

/// Waymarks logic on links between a cell and the cells its arrow points at.
/// Tier 1: a cell with one way on or one way in takes it; numbers one apart
/// are linked, others not; numbers run along links; no loops.
/// Tier 2: + the numbers a cell can hold: one more than a cell that can lead
/// to it, one less than a cell it can lead to, none taken elsewhere; a link
/// whose cells can't be one apart is ruled out.
/// Tier 3: + probing links.
class WaymarksSolver {
  WaymarksSolver(this.p, {this.disabled = const {}}) : cells = p.cells, w = (p.cells + _bits - 1) ~/ _bits {
    for (var c = 0; c < cells; c++) {
      for (final d in p.targets[c]) {
        outE[c].add(from.length);
        inE[d].add(from.length);
        from.add(c);
        to.add(d);
      }
    }
  }

  final WaymarksPuzzle p;
  final int cells;

  /// Rules left out (tests check that a board needs a rule).
  final Set<WaymarksRule> disabled;

  /// Words per cell in [WaymarksKnow.pos].
  final int w;
  final List<int> from = [];
  final List<int> to = [];
  late final List<List<int>> outE = [for (var i = 0; i < cells; i++) <int>[]];
  late final List<List<int>> inE = [for (var i = 0; i < cells; i++) <int>[]];

  int get edges => from.length;

  /// The trace slot of cell [c]'s numbers.
  int numberSlot(int c) => edges + c;

  /// The edge from [a] to [b], or -1.
  int edgeOf(int a, int b) {
    for (final e in outE[a]) {
      if (to[e] == b) return e;
    }
    return -1;
  }

  bool has(WaymarksKnow k, int c, int x) => (k.pos[c * w + x ~/ _bits] >> (x % _bits)) & 1 == 1;

  /// The numbers (0-based) cell [c] can still hold.
  List<int> numbers(WaymarksKnow k, int c) => [
    for (var x = 0; x < cells; x++)
      if (has(k, c, x)) x,
  ];

  /// What the board says by itself: the shown numbers.
  WaymarksKnow start() {
    final k = WaymarksKnow(
      Int8List(edges)..fillRange(0, edges, -1),
      Int32List(cells * w),
      Int16List(cells)..fillRange(0, cells, -1),
      Int16List(cells)..fillRange(0, cells, -1),
    );
    final free = Int32List(w);
    for (var x = 0; x < cells; x++) {
      if (!p.shown[x]) free[x ~/ _bits] |= 1 << (x % _bits);
    }
    for (var c = 0; c < cells; c++) {
      final g = p.given[c];
      if (g > 0) {
        k.pos[c * w + (g - 1) ~/ _bits] = 1 << ((g - 1) % _bits);
        k.fixed[c] = g - 1;
        k.holder[g - 1] = c;
      } else {
        k.pos.setRange(c * w, c * w + w, free);
      }
    }
    // Nothing comes before 1.
    for (final e in inE[p.path.first]) {
      k.edge[e] = 0;
    }
    return k;
  }

  /// [k] with the links of [next] (only links that agree with the solution
  /// should be given): linked cells take their numbers along, quietly.
  void seedLinks(WaymarksKnow k, List<int> next) {
    for (var c = 0; c < cells; c++) {
      final e = next[c] < 0 ? -1 : edgeOf(c, next[c]);
      if (e < 0) continue;
      for (final o in outE[c]) {
        k.edge[o] = o == e ? 1 : 0;
      }
      for (final o in inE[next[c]]) {
        if (o != e) k.edge[o] = 0;
      }
    }
    var changed = true;
    while (changed) {
      changed = false;
      for (var c = 0; c < cells; c++) {
        final d = next[c];
        if (d < 0 || edgeOf(c, d) < 0) continue;
        if (k.fixed[c] >= 0 && k.fixed[d] < 0 && k.fixed[c] + 1 < cells && k.holder[k.fixed[c] + 1] < 0) {
          _fix(k, d, k.fixed[c] + 1);
          changed = true;
        } else if (k.fixed[d] > 0 && k.fixed[c] < 0 && k.holder[k.fixed[d] - 1] < 0) {
          _fix(k, c, k.fixed[d] - 1);
          changed = true;
        }
      }
    }
  }

  void _fix(WaymarksKnow k, int c, int x) {
    k.pos.fillRange(c * w, c * w + w, 0);
    k.pos[c * w + x ~/ _bits] = 1 << (x % _bits);
    k.fixed[c] = x;
    k.holder[x] = c;
  }

  /// Applies logic up to [tier] (1 or 2) in place; false on a contradiction.
  /// With [t], every deduction is recorded (see [WaymarksRule]).
  bool propagate(WaymarksKnow k, [int tier = 2, ExplainTrace? t]) {
    var ok = true;
    var changed = true;

    void fail(WaymarksRule rule, List<int> premises, [List<int> args = const []]) {
      ok = false;
      t?.fail(rule.index, premises: premises, args: args);
    }

    void link(int e, int v, WaymarksRule rule, List<int> premises, [List<int> args = const []]) {
      if (!ok || k.edge[e] == v || disabled.contains(rule)) return;
      if (k.edge[e] != -1) {
        // Both ways at once: the reasons clash on this link.
        fail(WaymarksRule.failLink, [e, ...premises], [from[e], to[e]]);
        return;
      }
      if (v == 1) {
        // A cell leads on to one cell and is reached from one.
        for (final o in [...outE[from[e]], ...inE[to[e]]]) {
          if (k.edge[o] == 1) {
            fail(WaymarksRule.failLink, [o, ...premises], [from[e], to[e]]);
            return;
          }
        }
      }
      k.edge[e] = v;
      changed = true;
      t?.fact(e, v, rule.index, premises: premises, args: args);
    }

    /// Cell [c] holds number [x]: false (recorded) if it can't.
    void fix(int c, int x, WaymarksRule rule, List<int> premises) {
      if (!ok || k.fixed[c] == x || disabled.contains(rule)) return;
      if (x < 0 || x >= cells || !has(k, c, x) || k.holder[x] >= 0) {
        fail(
          WaymarksRule.failNumber,
          [numberSlot(c), ...premises, if (x >= 0 && x < cells && k.holder[x] >= 0) numberSlot(k.holder[x])],
          [c],
        );
        return;
      }
      _fix(k, c, x);
      changed = true;
      t?.fact(numberSlot(c), 1, rule.index, premises: premises, args: [x + 1]);
    }

    while (changed && ok) {
      changed = false;
      _basic(k, t != null, link, fix, fail);
      if (!ok || changed || tier < 2) continue;
      _numbers(k, t, () => changed = true, fail);
      if (!ok || changed) continue;
      for (var e = 0; e < edges && ok; e++) {
        if (k.edge[e] != -1) continue;
        final c = from[e], d = to[e];
        if (!_fits(k, c, d)) link(e, 0, WaymarksRule.noFit, [numberSlot(c), numberSlot(d)], [c, d]);
      }
    }
    return ok;
  }

  /// Whether some number of [c] has the next one possible at [d].
  bool _fits(WaymarksKnow k, int c, int d) {
    for (var i = 0; i < w; i++) {
      // Bits of d shifted down one: d's number x + 1 lines up with c's x.
      final down = (k.pos[d * w + i] >> 1) | (i + 1 < w ? (k.pos[d * w + i + 1] & 1) << (_bits - 1) : 0);
      if (k.pos[c * w + i] & down != 0) return true;
    }
    return false;
  }

  void _basic(
    WaymarksKnow k,
    bool trace,
    void Function(int, int, WaymarksRule, List<int>, [List<int>]) link,
    void Function(int, int, WaymarksRule, List<int>) fix,
    void Function(WaymarksRule, List<int>, [List<int>]) fail,
  ) {
    // Links taken: the other ways out of and into their cells are closed.
    for (var e = 0; e < edges; e++) {
      if (k.edge[e] != 1) continue;
      for (final o in outE[from[e]]) {
        if (o != e) link(o, 0, WaymarksRule.taken, [e], [from[e], to[e]]);
      }
      for (final o in inE[to[e]]) {
        if (o != e) link(o, 0, WaymarksRule.taken, [e], [from[e], to[e]]);
      }
    }
    // One way on, one way in.
    for (var c = 0; c < cells; c++) {
      if (p.dir[c] >= 0) {
        final live = [
          for (final e in outE[c])
            if (k.edge[e] != 0) e,
        ];
        if (live.isEmpty) {
          fail(WaymarksRule.failStuck, outE[c], [c]);
          return;
        }
        if (live.length == 1 && k.edge[live.single] == -1) {
          link(
            live.single,
            1,
            WaymarksRule.onlyOut,
            [
              for (final e in outE[c])
                if (e != live.single) e,
            ],
            [c, to[live.single]],
          );
        }
      }
      if (c != p.path.first && k.fixed[c] != 0) {
        final live = [
          for (final e in inE[c])
            if (k.edge[e] != 0) e,
        ];
        if (live.isEmpty) {
          fail(WaymarksRule.failNoPrev, inE[c], [c]);
          return;
        }
        if (live.length == 1 && k.edge[live.single] == -1) {
          link(
            live.single,
            1,
            WaymarksRule.onlyIn,
            [
              for (final e in inE[c])
                if (e != live.single) e,
            ],
            [from[live.single], c],
          );
        }
      }
    }
    // Known numbers: one apart is a link, anything else isn't; numbers run
    // along links.
    for (var e = 0; e < edges; e++) {
      final c = from[e], d = to[e];
      final a = k.fixed[c], b = k.fixed[d];
      if (k.edge[e] == -1 && a >= 0 && b >= 0) {
        link(
          e,
          b == a + 1 ? 1 : 0,
          b == a + 1 ? WaymarksRule.consecutive : WaymarksRule.apart,
          [
            numberSlot(c),
            numberSlot(d),
          ],
          [c, d, a + 1, b + 1],
        );
      } else if (k.edge[e] == 1 && a >= 0 && b < 0) {
        fix(d, a + 1, WaymarksRule.numberOn, [e, numberSlot(c)]);
      } else if (k.edge[e] == 1 && b >= 0 && a < 0) {
        fix(c, b - 1, WaymarksRule.numberOn, [e, numberSlot(d)]);
      }
    }
    // Loops: a cell can't lead back to the first cell of its own chain.
    final prev = Int32List(cells)..fillRange(0, cells, -1);
    final next = Int32List(cells)..fillRange(0, cells, -1);
    for (var e = 0; e < edges; e++) {
      if (k.edge[e] == 1) {
        prev[to[e]] = e;
        next[from[e]] = to[e];
      }
    }
    final head = Int32List(cells)..fillRange(0, cells, -1);
    for (var h = 0; h < cells; h++) {
      if (prev[h] >= 0) continue;
      for (var j = h; j >= 0; j = next[j]) {
        head[j] = h;
      }
    }
    for (var c = 0; c < cells; c++) {
      if (head[c] < 0) {
        // On a loop: every cell of it has a link in.
        fail(WaymarksRule.failLoop, [prev[c]], [c]);
        return;
      }
    }
    for (var c = 0; c < cells; c++) {
      for (final e in outE[c]) {
        if (to[e] != head[c] || k.edge[e] != -1) continue;
        link(e, 0, WaymarksRule.loop, trace ? [for (var j = c; prev[j] >= 0; j = from[prev[j]]) prev[j]] : const [], [
          c,
          head[c],
        ]);
      }
    }
  }

  /// Tier 2: narrows each cell's numbers by its neighbours along the arrows
  /// and the numbers held elsewhere.
  void _numbers(
    WaymarksKnow k,
    ExplainTrace? t,
    void Function() changed,
    void Function(WaymarksRule, List<int>, [List<int>]) fail,
  ) {
    final keep = Int32List(w);
    // Numbers some cell surely holds.
    final held = Int32List(w);
    for (var x = 0; x < cells; x++) {
      if (k.holder[x] >= 0) held[x ~/ _bits] |= 1 << (x % _bits);
    }
    for (var c = 0; c < cells; c++) {
      for (final rule in const [WaymarksRule.before, WaymarksRule.after, WaymarksRule.used]) {
        if (disabled.contains(rule)) continue;
        final premises = <int>[];
        keep.fillRange(0, w, 0);
        switch (rule) {
          case WaymarksRule.before:
            // One more than a cell that can lead here (or 1, with nothing before).
            if (!inE[c].any((e) => k.edge[e] == 1)) keep[0] |= 1;
            for (final e in inE[c]) {
              if (k.edge[e] == 0) {
                if (t != null) premises.add(e);
                continue;
              }
              final b = from[e];
              if (t != null) premises.add(numberSlot(b));
              for (var i = 0; i < w; i++) {
                keep[i] |= ((k.pos[b * w + i] << 1) & _mask) | (i > 0 ? k.pos[b * w + i - 1] >> (_bits - 1) : 0);
              }
            }
          case WaymarksRule.after:
            // One less than a cell it can lead to (or the last, without an arrow).
            if (p.dir[c] < 0) keep[(cells - 1) ~/ _bits] |= 1 << ((cells - 1) % _bits);
            for (final e in outE[c]) {
              if (k.edge[e] == 0) {
                if (t != null) premises.add(e);
                continue;
              }
              final d = to[e];
              if (t != null) premises.add(numberSlot(d));
              for (var i = 0; i < w; i++) {
                keep[i] |= (k.pos[d * w + i] >> 1) | (i + 1 < w ? (k.pos[d * w + i + 1] & 1) << (_bits - 1) : 0);
              }
            }
          default:
            // Numbers other cells surely hold.
            for (var i = 0; i < w; i++) {
              keep[i] = _mask & ~held[i];
            }
            final own = k.fixed[c];
            if (own >= 0) keep[own ~/ _bits] |= 1 << (own % _bits);
            if (t != null) {
              for (var x = 0; x < cells; x++) {
                final h = k.holder[x];
                if (h >= 0 && h != c && has(k, c, x)) premises.add(numberSlot(h));
              }
            }
        }
        var lost = false, left = 0;
        for (var i = 0; i < w; i++) {
          final old = k.pos[c * w + i], now = old & keep[i];
          if (now != old) lost = true;
          left += _count(now);
        }
        if (!lost) continue;
        for (var i = 0; i < w; i++) {
          k.pos[c * w + i] &= keep[i];
        }
        changed();
        if (left == 0) {
          fail(WaymarksRule.failNumber, [numberSlot(c), ...premises], [c]);
          return;
        }
        t?.fact(
          numberSlot(c),
          left,
          rule.index,
          premises: [numberSlot(c), ...premises],
          args: [
            for (final x in numbers(k, c)) x + 1,
          ],
        );
        if (left == 1) {
          final x = numbers(k, c).single;
          if (k.holder[x] >= 0 && k.holder[x] != c) {
            fail(WaymarksRule.failNumber, [numberSlot(c), numberSlot(k.holder[x])], [c]);
            return;
          }
          k.fixed[c] = x;
          k.holder[x] = c;
          held[x ~/ _bits] |= 1 << (x % _bits);
        }
        // Traced, one change at a time: the caller reruns the easier rules
        // first, so explanations stay short.
        if (t != null) return;
        break;
      }
    }
  }

  static int _count(int v) {
    var n = 0;
    while (v != 0) {
      v &= v - 1;
      n++;
    }
    return n;
  }

  /// Cells still without a link on (the last cell needs none).
  int open(WaymarksKnow k) {
    var n = 0;
    for (var c = 0; c < cells; c++) {
      if (p.dir[c] >= 0 && !outE[c].any((e) => k.edge[e] == 1)) n++;
    }
    return n;
  }

  /// Logic up to [tier] (3 probes links with tier 2) in place.
  bool solve(WaymarksKnow k, int tier) {
    if (!propagate(k, tier < 3 ? tier : 2)) return false;
    if (tier < 3) return true;
    var progress = true;
    while (progress && open(k) > 0) {
      progress = false;
      for (var e = 0; e < edges; e++) {
        if (k.edge[e] != -1) continue;
        for (final v in const [1]) {
          final kk = WaymarksKnow.copy(k);
          kk.edge[e] = v;
          if (!propagate(kk)) {
            k.edge[e] = 1 - v;
            if (!propagate(k)) return false;
            progress = true;
            break;
          }
        }
      }
    }
    return true;
  }

  /// Cells [tier] leaves without a link on, or cells + 1 on a contradiction.
  int slack(int tier, [WaymarksKnow? from]) {
    final k = from == null ? start() : WaymarksKnow.copy(from);
    if (!solve(k, tier)) return cells + 1;
    return open(k);
  }

  /// Lowest tier (1..3) that solves the board, or 4.
  int grade() {
    for (var t = 1; t <= 3; t++) {
      if (slack(t) == 0) return t;
    }
    return 4;
  }

  /// The links of a solved [k]: the cell each cell leads on to, or -1.
  List<int> nextOf(WaymarksKnow k) {
    final next = List<int>.filled(cells, -1);
    for (var e = 0; e < edges; e++) {
      if (k.edge[e] == 1) next[from[e]] = to[e];
    }
    return next;
  }

  /// Number of solutions (up to [limit]), or -1 if the search gets too big.
  int countSolutions({int limit = 2, int budget = 100000}) {
    var nodes = 0, total = 0;
    void rec(WaymarksKnow k) {
      if (total >= limit || ++nodes > budget) return;
      if (!propagate(k)) return;
      // Branch on the cell with the fewest ways on.
      var best = -1, bestLive = 1 << 20;
      for (var c = 0; c < cells; c++) {
        if (p.dir[c] < 0 || outE[c].any((e) => k.edge[e] == 1)) continue;
        final live = outE[c].where((e) => k.edge[e] == -1).length;
        if (live < bestLive) (best, bestLive) = (c, live);
      }
      if (best < 0) {
        total++;
        return;
      }
      for (final e in outE[best]) {
        if (k.edge[e] != -1) continue;
        rec(WaymarksKnow.copy(k)..edge[e] = 1);
      }
    }

    rec(start());
    return nodes > budget ? -1 : total;
  }
}
