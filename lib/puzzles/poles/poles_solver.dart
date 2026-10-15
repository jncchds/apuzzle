import 'dart:typed_data';

import '../../core/difficulty.dart';
import '../../core/explain.dart';
import 'poles_model.dart';

/// What a traced [PolesSolver.propagate] records ([Fact.rule]). Placing
/// rules ([partner], [lineNeed], [chargedDone], [last]) record the value
/// placed, the others ([Fact.value]) the value ruled out.
enum PolesRule {
  /// The other end of the domino is settled. Args: that cell.
  partner,

  /// The other end of the domino can't be the opposite value. Args: that cell.
  partnerOut,

  /// A neighbour holds the same pole. Args: that cell.
  repel,

  /// The line has all its cells of the value / just enough cells left for
  /// them. Args: line, count.
  lineDone,
  lineNeed,

  /// The line has all its charged cells (so this one is blank) / needs every
  /// cell that can still be charged. Args: line, + and − together.
  chargedDone,
  chargedNeed,

  /// One value is left.
  last,

  /// No way to fill the line that fits its counts puts the value here. Args: line.
  fill,

  failEmpty,
  failMany,
  failFew,
  failFill,
}

/// The logic tier a difficulty is built for: 1 dominoes, neighbours and
/// counts, 2 + every way to fill a line, 3 + probing.
int polesTier(Difficulty d) => switch (d) {
  Difficulty.easy => 1,
  Difficulty.medium => 2,
  _ => 3,
};

const int _all = 7;
const int _blankBit = 1 << poleBlank;
const int _charged = 1 << polePlus | 1 << poleMinus;

bool _single(int m) => m != 0 && m & (m - 1) == 0;
int _valueOf(int m) => m.bitLength - 1;

/// The values the other end of a domino may take when this end may be [m].
int _across(int m) => (m & 1) << 1 | (m & 2) >> 1 | (m & _blankBit);

/// Candidate masks per cell (bit v: value v).
class PolesSolver {
  PolesSolver(this.rows, this.cols, this.mate, this.plus, this.minus, {this.disabled = const {}})
    : lines = polesLines(rows, cols),
      _near = [
        for (var i = 0; i < rows * cols; i++)
          [
            if (i ~/ cols > 0 && mate[i] != i - cols) i - cols,
            if (i % cols < cols - 1 && mate[i] != i + 1) i + 1,
            if (i ~/ cols < rows - 1 && mate[i] != i + cols) i + cols,
            if (i % cols > 0 && mate[i] != i - 1) i - 1,
          ],
      ];

  factory PolesSolver.of(PolesPuzzle p, {Set<PolesRule> disabled = const {}}) =>
      PolesSolver(p.rows, p.cols, p.mate, p.plus, p.minus, disabled: disabled);

  final int rows;
  final int cols;
  final List<int> mate;
  final List<int?> plus;
  final List<int?> minus;
  final List<List<int>> lines;

  /// Rules left out (for tests that check a board needs a rule).
  final Set<PolesRule> disabled;

  /// Side neighbours of each cell outside its domino.
  final List<List<int>> _near;

  int? countOf(int line, int sign) => sign == polePlus ? plus[line] : minus[line];

  /// The start: every value possible, [given] (cell → value) settled.
  List<int> start([Map<int, int> given = const {}]) {
    final st = List.filled(rows * cols, _all);
    given.forEach((i, v) => st[i] = 1 << v);
    return st;
  }

  /// Applies the rules up to [tier] (1 or 2) until nothing changes. False on
  /// a contradiction. With [tr], every deduction is recorded (see [PolesRule]).
  bool propagate(List<int> st, int tier, [ExplainTrace? tr]) {
    var changed = true;

    // Rules [v] out of [i]; false when nothing is left.
    bool remove(int i, int v, PolesRule rule, List<int> premises, List<int> args) {
      final bit = 1 << v;
      if (st[i] & bit == 0) return true;
      st[i] &= ~bit;
      changed = true;
      if (tr != null) {
        tr.fact(i, v, rule.index, premises: premises, args: args);
        if (_single(st[i])) tr.fact(i, _valueOf(st[i]), PolesRule.last.index, premises: [i]);
        if (st[i] == 0) tr.fail(PolesRule.failEmpty.index, premises: [i], args: [i]);
      }
      return st[i] != 0;
    }

    // Settles [i] to [v]; false when [v] was ruled out.
    bool place(int i, int v, PolesRule rule, List<int> premises, List<int> args) {
      final bit = 1 << v;
      if (st[i] == bit) return true;
      if (st[i] & bit == 0) {
        tr?.fail(PolesRule.failEmpty.index, premises: [i, ...premises], args: [i]);
        return false;
      }
      st[i] = bit;
      changed = true;
      tr?.fact(i, v, rule.index, premises: premises, args: args);
      return true;
    }

    bool on(PolesRule r) => !disabled.contains(r);

    while (changed) {
      changed = false;

      // Dominoes and neighbours.
      for (var i = 0; i < st.length; i++) {
        final m = st[i];
        if (m == 0) {
          tr?.fail(PolesRule.failEmpty.index, premises: [i], args: [i]);
          return false;
        }
        final j = mate[i];
        if (on(PolesRule.partner) && _single(st[j])) {
          if (!place(i, poleOpposite(_valueOf(st[j])), PolesRule.partner, [j], [j])) return false;
        } else if (on(PolesRule.partnerOut)) {
          final allowed = _across(st[j]);
          for (var v = 0; v < 3; v++) {
            if (allowed & (1 << v) == 0 && !remove(i, v, PolesRule.partnerOut, [j], [j])) return false;
          }
        }
        if (_single(st[i]) && st[i] != _blankBit && on(PolesRule.repel)) {
          final v = _valueOf(st[i]);
          for (final k in _near[i]) {
            if (!remove(k, v, PolesRule.repel, [i], [i])) return false;
          }
        }
      }
      if (changed) continue;

      // Counts.
      for (var li = 0; li < lines.length; li++) {
        final cells = lines[li];
        for (final sign in const [polePlus, poleMinus]) {
          final want = countOf(li, sign);
          if (want == null) continue;
          final bit = 1 << sign;
          var sure = 0, can = 0;
          for (final i in cells) {
            if (st[i] == bit) sure++;
            if (st[i] & bit != 0) can++;
          }
          if (sure > want || can < want) {
            tr?.fail(
              (sure > want ? PolesRule.failMany : PolesRule.failFew).index,
              premises: cells,
              args: [li, sign, want],
            );
            return false;
          }
          if (sure == want && can > want && on(PolesRule.lineDone)) {
            for (final i in cells) {
              if (st[i] != bit && !remove(i, sign, PolesRule.lineDone, cells, [li, want])) return false;
            }
          } else if (can == want && sure < want && on(PolesRule.lineNeed)) {
            for (final i in cells) {
              if (st[i] & bit != 0 && !place(i, sign, PolesRule.lineNeed, cells, [li, want])) return false;
            }
          }
        }
        final a = plus[li], b = minus[li];
        if (a == null || b == null) continue;
        final want = a + b;
        var sure = 0, can = 0;
        for (final i in cells) {
          if (st[i] & _blankBit == 0) sure++;
          if (st[i] & _charged != 0) can++;
        }
        if (sure == want && can > want && on(PolesRule.chargedDone)) {
          for (final i in cells) {
            if (st[i] & _blankBit != 0 && st[i] != _blankBit) {
              if (!place(i, poleBlank, PolesRule.chargedDone, cells, [li, want])) return false;
            }
          }
        } else if (can == want && sure < want && on(PolesRule.chargedNeed)) {
          for (final i in cells) {
            if (st[i] & _charged != 0 && !remove(i, poleBlank, PolesRule.chargedNeed, cells, [li, want])) return false;
          }
        }
      }
      if (changed || tier < 2 || !on(PolesRule.fill)) continue;

      // Every way to fill a line.
      for (var li = 0; li < lines.length; li++) {
        if (plus[li] == null && minus[li] == null) continue;
        final cells = lines[li];
        if (cells.every((i) => _single(st[i]))) continue;
        final ok = _fills(st, cells, plus[li], minus[li]);
        if (ok == null) {
          tr?.fail(PolesRule.failFill.index, premises: cells, args: [li]);
          return false;
        }
        for (var k = 0; k < cells.length; k++) {
          final i = cells[k], gone = st[i] & ~ok[k];
          for (var v = 0; v < 3; v++) {
            if (gone & (1 << v) != 0 && !remove(i, v, PolesRule.fill, cells, [li])) return false;
          }
        }
        if (changed) break;
      }
    }
    return true;
  }

  /// The values each cell of a line takes in some way to fill the line that
  /// fits the counts ([a] +, [b] −; null: any), its dominoes and neighbours,
  /// or null if there is none.
  List<int>? _fills(List<int> st, List<int> cells, int? a, int? b) {
    final n = cells.length, w = n + 1;
    final ca = a ?? n, cb = b ?? n;
    // State after k cells: (+ so far, − so far, last value); the first cell
    // ignores the last value, so the start is state 0.
    int key(int p, int m, int v) => (p * w + m) * 3 + v;
    bool step(int k, int prev, int v) {
      if (st[cells[k]] & (1 << v) == 0) return false;
      if (k == 0) return true;
      if (mate[cells[k]] == cells[k - 1]) return v == poleOpposite(prev);
      return v == poleBlank || v != prev;
    }

    final size = w * w * 3;
    // Forward: states reachable after k cells.
    final fwd = List.generate(n + 1, (_) => Uint8List(size));
    fwd[0][0] = 1;
    for (var k = 0; k < n; k++) {
      final from = fwd[k], to = fwd[k + 1];
      for (var s = 0; s < size; s++) {
        if (from[s] == 0) continue;
        final p = s ~/ 3 ~/ w, m = s ~/ 3 % w, prev = s % 3;
        for (var v = 0; v < 3; v++) {
          if (!step(k, prev, v)) continue;
          final p2 = p + (v == polePlus ? 1 : 0), m2 = m + (v == poleMinus ? 1 : 0);
          if (p2 > ca || m2 > cb) continue;
          to[key(p2, m2, v)] = 1;
        }
      }
    }
    // Backward: states after k cells from which the line can be finished.
    final good = List.generate(n + 1, (_) => Uint8List(size));
    var any = false;
    for (var s = 0; s < size; s++) {
      if (fwd[n][s] == 0) continue;
      final p = s ~/ 3 ~/ w, m = s ~/ 3 % w;
      if ((a == null || p == a) && (b == null || m == b)) {
        good[n][s] = 1;
        any = true;
      }
    }
    if (!any) return null;
    final out = List.filled(n, 0);
    for (var k = n - 1; k >= 0; k--) {
      final from = fwd[k], next = good[k + 1], here = good[k];
      for (var s = 0; s < size; s++) {
        if (from[s] == 0) continue;
        final p = s ~/ 3 ~/ w, m = s ~/ 3 % w, prev = s % 3;
        for (var v = 0; v < 3; v++) {
          if (!step(k, prev, v)) continue;
          final p2 = p + (v == polePlus ? 1 : 0), m2 = m + (v == poleMinus ? 1 : 0);
          if (p2 > ca || m2 > cb || next[key(p2, m2, v)] == 0) continue;
          here[s] = 1;
          out[k] |= 1 << v;
        }
      }
    }
    return out;
  }

  bool solved(List<int> st) => st.every(_single);

  /// True if [st] gets fully determined using logic up to [tier] (3 probes).
  bool solve(List<int> st, int tier) {
    if (!propagate(st, tier < 2 ? 1 : 2)) return false;
    if (tier < 3) return solved(st);
    var progress = true;
    while (progress && !solved(st)) {
      progress = false;
      for (var i = 0; i < st.length; i++) {
        for (var v = 0; v < 3; v++) {
          if (_single(st[i]) || st[i] & (1 << v) == 0) continue;
          final t = List.of(st)..[i] = 1 << v;
          if (propagate(t, 2)) continue;
          st[i] &= ~(1 << v);
          if (!propagate(st, 2)) return false;
          progress = true;
        }
      }
    }
    return solved(st);
  }

  /// The lowest tier that solves [st] (4: none does).
  int grade(List<int> st) {
    for (var t = 1; t <= 3; t++) {
      if (solve(List.of(st), t)) return t;
    }
    return 4;
  }

  int countSolutions(List<int> st, {int limit = 2}) {
    final t = List.of(st);
    if (!propagate(t, 2)) return 0;
    final i = t.indexWhere((m) => !_single(m));
    if (i < 0) return 1;
    var total = 0;
    for (var v = 0; v < 3 && total < limit; v++) {
      if (t[i] & (1 << v) == 0) continue;
      total += countSolutions(List.of(t)..[i] = 1 << v, limit: limit - total);
    }
    return total;
  }
}

/// [PolesSolver.start] with the shown cells of [p].
List<int> polesStart(PolesSolver s, PolesPuzzle p) => s.start({for (final g in p.givens) g: p.solution[g]});

/// The settled values of [st] (-1 where open).
List<int> polesValues(List<int> st) => [for (final m in st) _single(m) ? _valueOf(m) : -1];
