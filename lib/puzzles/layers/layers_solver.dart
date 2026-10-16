import '../../core/explain.dart';
import 'layers_model.dart';

/// What a traced [LayersSolver.propagate] records ([Fact.rule]). A cell or
/// line fact's value is its color once one is left, else -1; an order fact
/// (line a was painted after line b) has value 1.
enum LayersRule {
  /// Both lines of the cell have one color. Args: row, column.
  same,

  /// The cell can only have its row's or its column's color (goes without saying).
  options,

  /// The cell's color isn't the earlier line's. Args: cell, later, earlier.
  seen,

  /// The later line's color covers the cell. Args: later, earlier.
  later,

  /// The later line has the cell's color. Args: cell, later, earlier.
  lineColor,

  /// a after b, b after c, c after d, read from three cells. Args: a, b, c, d.
  rectangle,

  /// a after b and b after c. Args: a, b, c.
  chain,

  /// The one color left after the others failed.
  only,
  failEmpty,
  failLine,

  /// a after b and b after a. Args: a, b.
  failCycle,
}

/// Layers logic on a flat list of knowledge: a color mask per cell (0 for
/// holes), a color mask per line, then per pair of lines (a, b) a 1 once a
/// is known to have been painted after b.
/// Tier 1: cells whose lines share a color, order read from cells, the
/// later line's color covering a cell, and rectangles (three cells whose
/// order runs a → b → c → d settle the cell of a and d). Tier 2: + hidden
/// line colors read from cells where the line came last, and the order
/// passed on along any chain, also through lines that never show it.
/// Tier 3: + probing.
class LayersSolver {
  LayersSolver(this.p) : n = p.cells, lines = p.lines;

  final LayersPuzzle p;
  final int n;
  final int lines;

  int get size => n + lines + lines * lines;
  int lineSlot(int l) => n + l;
  int orderSlot(int a, int b) => n + lines + a * lines + b;

  /// (a, b) of an order slot.
  (int, int) orderOf(int slot) => ((slot - n - lines) ~/ lines, (slot - n - lines) % lines);

  int get all => (1 << p.colors) - 1;

  /// Knowledge from the line colors and [values] (-1 empty; by default the givens).
  List<int> start([List<int>? values]) {
    final k = List<int>.filled(size, 0);
    for (var i = 0; i < n; i++) {
      final v = values?[i] ?? (p.givenAt(i) ?? -1);
      k[i] = p.isHole(i) ? 0 : (v >= 0 ? 1 << v : all);
    }
    for (var l = 0; l < lines; l++) {
      k[n + l] = p.hidden.contains(l) ? all : 1 << p.lineColors[l];
    }
    return k;
  }

  static bool single(int m) => m != 0 && m & (m - 1) == 0;
  static int colorOf(int m) => single(m) ? m.bitLength - 1 : -1;

  /// Applies logic up to [tier] (1 or 2) in place; false on a contradiction.
  bool propagate(List<int> k, [int tier = 2, ExplainTrace? t]) {
    var changed = true;
    void mask(int slot, int m, LayersRule rule, List<int> premises, [List<int> args = const []]) {
      if (k[slot] == m) return;
      k[slot] = m;
      changed = true;
      t?.fact(slot, colorOf(m), rule.index, premises: premises, args: args);
    }

    void order(int a, int b, LayersRule rule, List<int> premises, List<int> args) {
      final s = orderSlot(a, b);
      if (k[s] == 1) return;
      k[s] = 1;
      changed = true;
      t?.fact(s, 1, rule.index, premises: premises, args: args);
    }

    final after = List<int>.filled(lines, 0);
    while (changed) {
      changed = false;
      for (var i = 0; i < n; i++) {
        if (p.isHole(i)) continue;
        final (r, c) = p.linesOf(i);
        final rs = n + r, cs = n + c;
        if (k[i] == 0) {
          t?.fail(LayersRule.failEmpty.index, premises: [i, rs, cs], args: [i]);
          return false;
        }
        for (final (a, b) in [(r, c), (c, r)]) {
          if (k[orderSlot(a, b)] != 1) continue;
          if (k[orderSlot(b, a)] == 1) {
            t?.fail(LayersRule.failCycle.index, premises: [orderSlot(a, b), orderSlot(b, a)], args: [a, b]);
            return false;
          }
          final m = k[i], lm = k[n + a];
          mask(i, m & lm, LayersRule.later, [orderSlot(a, b), n + a], [a, b]);
          if (tier >= 2) mask(n + a, lm & m, LayersRule.lineColor, [orderSlot(a, b), i], [i, a, b]);
          if (k[i] == 0 || k[n + a] == 0) {
            t?.fail(LayersRule.failEmpty.index, premises: [i, n + a, orderSlot(a, b)], args: [i]);
            return false;
          }
        }
        if (k[orderSlot(r, c)] == 1 || k[orderSlot(c, r)] == 1) continue;
        final both = k[rs] | k[cs];
        if (single(both)) {
          mask(i, k[i] & both, LayersRule.same, [rs, cs], [r, c]);
        } else {
          mask(i, k[i] & both, LayersRule.options, [rs, cs]);
        }
        if (k[i] == 0) {
          t?.fail(LayersRule.failEmpty.index, premises: [i, rs, cs], args: [i]);
          return false;
        }
        if (k[i] & k[rs] == 0) order(c, r, LayersRule.seen, [i, rs], [i, c, r]);
        if (k[i] & k[cs] == 0) order(r, c, LayersRule.seen, [i, cs], [i, r, c]);
      }
      if (changed) continue;
      for (var l = 0; l < lines; l++) {
        if (k[n + l] == 0) {
          t?.fail(LayersRule.failLine.index, premises: [n + l], args: [l]);
          return false;
        }
      }
      for (var a = 0; a < lines; a++) {
        var bits = 0;
        final base = n + lines + a * lines;
        for (var b = 0; b < lines; b++) {
          if (k[base + b] == 1) bits |= 1 << b;
        }
        after[a] = bits;
      }
      if (tier < 2) {
        if (!_rectangles(k, after, mask)) return false;
      } else {
        if (!_chains(k, after, order, t)) return false;
      }
    }
    return true;
  }

  /// Tier 1: a after b, b after c and c after d (each read from a cell)
  /// settle the cell of a and d, if that shows on it.
  bool _rectangles(
    List<int> k,
    List<int> after,
    void Function(int, int, LayersRule, List<int>, [List<int>]) mask,
  ) {
    for (var a = 0; a < lines; a++) {
      for (var b = 0; b < lines; b++) {
        if (after[a] & (1 << b) == 0) continue;
        for (var c = 0; c < lines; c++) {
          if (after[b] & (1 << c) == 0) continue;
          for (var d = 0; d < lines; d++) {
            if (after[c] & (1 << d) == 0 || (d < p.rows) == (a < p.rows)) continue;
            final i = p.cellOf(a, d);
            if (p.isHole(i) || after[a] & (1 << d) != 0) continue;
            final m = k[i] & k[n + a];
            if (m == k[i]) continue;
            mask(i, m, LayersRule.rectangle, [orderSlot(a, b), orderSlot(b, c), orderSlot(c, d), n + a], [a, b, c, d]);
            return true;
          }
        }
      }
    }
    return true;
  }

  /// Tier 2: the order passed on along chains; false on a cycle.
  bool _chains(
    List<int> k,
    List<int> after,
    void Function(int, int, LayersRule, List<int>, List<int>) order,
    ExplainTrace? t,
  ) {
    for (var b = 0; b < lines; b++) {
      for (var a = 0; a < lines; a++) {
        if (after[a] & (1 << b) == 0) continue;
        var add = after[b] & ~after[a];
        while (add != 0) {
          final x = add.bitLength - 1;
          add &= ~(1 << x);
          if (x == a) {
            t?.fail(LayersRule.failCycle.index, premises: [orderSlot(a, b), orderSlot(b, a)], args: [a, b]);
            return false;
          }
          order(a, x, LayersRule.chain, [orderSlot(a, b), orderSlot(b, x)], [a, b, x]);
          after[a] |= 1 << x;
        }
      }
    }
    return true;
  }

  /// Slots worth probing: hidden line colors, then cells with two colors left.
  Iterable<int> open(List<int> k) sync* {
    for (var l = 0; l < lines; l++) {
      if (!single(k[n + l])) yield n + l;
    }
    for (var i = 0; i < n; i++) {
      if (k[i] != 0 && !single(k[i])) yield i;
    }
  }

  /// Solves in place with logic up to [tier]; false on a contradiction.
  bool solve(List<int> k, int tier) {
    if (!propagate(k, tier.clamp(1, 2))) return false;
    if (tier < 3) return true;
    var progress = true;
    while (progress && open(k).any((s) => s < n)) {
      progress = false;
      for (final s in open(k).toList()) {
        if (single(k[s])) continue;
        for (var v = 0; v < p.colors; v++) {
          if (k[s] & (1 << v) == 0) continue;
          final probe = List.of(k)..[s] = 1 << v;
          if (!propagate(probe)) {
            k[s] &= ~(1 << v);
            if (k[s] == 0 || !propagate(k)) return false;
            progress = true;
          }
        }
      }
    }
    return true;
  }

  /// Cells logic up to [tier] leaves open from [k0] (all cells + 1 on a
  /// contradiction).
  int slack(int tier, List<int> k0) {
    final k = List.of(k0);
    if (!solve(k, tier)) return n + 1;
    var open = 0;
    for (var i = 0; i < n; i++) {
      if (k[i] != 0 && !single(k[i])) open++;
    }
    return open;
  }

  /// Lowest tier (1..3) that solves the board from [k0], or 4.
  int grade(List<int> k0) {
    for (var t = 1; t <= 3; t++) {
      if (slack(t, k0) == 0) return t;
    }
    return 4;
  }

  /// Number of different pictures (up to [limit]), or -1 if the search gets
  /// too big.
  int countSolutions(List<int> from, {int limit = 2, int budget = 20000}) {
    var nodes = 0;
    final found = <String>{};
    void rec(List<int> k) {
      if (found.length >= limit || ++nodes > budget) return;
      if (!propagate(k)) return;
      final s = open(k).firstOrNull;
      if (s == null) {
        found.add(k.sublist(0, n).join(','));
        return;
      }
      for (var v = 0; v < p.colors; v++) {
        if (k[s] & (1 << v) != 0) rec(List.of(k)..[s] = 1 << v);
      }
    }

    rec(List.of(from));
    return nodes > budget ? -1 : found.length;
  }

  /// Whether some painting order (and colors for hidden lines) gives the
  /// full picture [values].
  bool valid(List<int> values) => countSolutions(start(values), limit: 1) == 1;
}
