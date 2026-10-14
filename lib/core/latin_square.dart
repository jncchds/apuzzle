import 'dart:math';

import 'explain.dart';
import 'grid.dart';
import 'value_grid.dart';
import 'value_grid_explain.dart';

/// What [LatinSquare.propagate] records ([Fact.rule]). A type's own rules
/// take the ids from [latinRuleCount] up. Eliminations ([ruledOut], [pair])
/// carry the removed bits as [Fact.value], placements ([naked], [hidden]) the
/// digit.
enum LatinRule { ruledOut, naked, hidden, pair, failEmpty, failNoPlace }

/// The first rule id a type can use for its own rules.
const int latinRuleCount = 6;

/// An n×n grid where every row and column holds each digit once. Knowledge is
/// a candidate mask per cell (bit d: digit d), solved where one bit is left.
/// Lines are rows 0..n-1, then columns n..2n-1.
class LatinSquare {
  LatinSquare(this.n) : full = (1 << n) - 1 {
    for (var r = 0; r < n; r++) {
      lines.add([for (var c = 0; c < n; c++) r * n + c]);
    }
    for (var c = 0; c < n; c++) {
      lines.add([for (var r = 0; r < n; r++) r * n + c]);
    }
  }

  final int n;
  final int full;
  final List<List<int>> lines = [];

  static final _cache = <int, LatinSquare>{};
  static LatinSquare of(int n) => _cache.putIfAbsent(n, () => LatinSquare(n));

  int get cells => n * n;
  int rowOf(int i) => i ~/ n;
  int colOf(int i) => n + i % n;

  static bool single(int m) => m != 0 && m & (m - 1) == 0;
  static int digitOf(int m) => m.bitLength - 1;
  static int count(int m) {
    var k = 0;
    for (; m != 0; m &= m - 1) {
      k++;
    }
    return k;
  }

  static List<int> digits(int m) => [
    for (var d = 0; m >> d != 0; d++)
      if (m & (1 << d) != 0) d,
  ];

  /// Candidates with the [givens] (digit or null per cell) placed.
  List<int> start(List<int?> givens) => [for (final g in givens) g == null ? full : 1 << g];

  bool solved(List<int> c) => c.every(single);

  /// The digits of a solved [c].
  List<int> values(List<int> c) => [for (final m in c) digitOf(m)];

  /// Rules out [mask] in cell [i] by [rule] (recording [premises] and [args]);
  /// a cell left with one digit records [LatinRule.naked]. False if nothing
  /// is left.
  bool remove(
    List<int> c,
    int i,
    int mask,
    int rule, {
    ExplainTrace? t,
    List<int> premises = const [],
    List<int> args = const [],
  }) {
    final gone = c[i] & mask;
    if (gone == 0) return true;
    c[i] &= ~mask;
    if (t != null) {
      t.fact(i, gone, rule, premises: premises, args: args);
      if (single(c[i])) t.fact(i, digitOf(c[i]), LatinRule.naked.index, premises: [i]);
      if (c[i] == 0) t.fail(LatinRule.failEmpty.index, premises: [i], args: [i]);
    }
    return c[i] != 0;
  }

  /// Applies the row and column rules until nothing changes: a placed digit
  /// is ruled out in its lines, a digit with one spot left in a line goes
  /// there, and with [pairs] two cells of a line holding the same two digits
  /// rule them out elsewhere in the line. False on a contradiction.
  bool propagate(List<int> c, {bool pairs = false, ExplainTrace? t}) {
    var changed = true;
    while (changed) {
      changed = false;
      for (var i = 0; i < c.length; i++) {
        final m = c[i];
        if (m == 0) {
          t?.fail(LatinRule.failEmpty.index, premises: [i], args: [i]);
          return false;
        }
        if (!single(m)) continue;
        for (final u in [rowOf(i), colOf(i)]) {
          for (final j in lines[u]) {
            if (j == i || c[j] & m == 0) continue;
            changed = true;
            if (!remove(c, j, m, LatinRule.ruledOut.index, t: t, premises: [i])) return false;
          }
        }
      }
      for (var u = 0; u < lines.length; u++) {
        final line = lines[u];
        for (var d = 0; d < n; d++) {
          final bit = 1 << d;
          var spots = 0, at = -1;
          for (final i in line) {
            if (c[i] & bit != 0) {
              spots++;
              at = i;
            }
          }
          if (spots == 0) {
            t?.fail(LatinRule.failNoPlace.index, premises: line, args: [d, u]);
            return false;
          }
          if (spots == 1 && c[at] != bit) {
            c[at] = bit;
            t?.fact(at, d, LatinRule.hidden.index, premises: line, args: [u]);
            changed = true;
          }
        }
        if (!pairs) continue;
        for (var a = 0; a < n; a++) {
          final m = c[line[a]];
          if (count(m) != 2) continue;
          for (var b = a + 1; b < n; b++) {
            if (c[line[b]] != m) continue;
            for (final j in line) {
              if (j == line[a] || j == line[b] || c[j] & m == 0) continue;
              changed = true;
              final ok = remove(
                c,
                j,
                m,
                LatinRule.pair.index,
                t: t,
                premises: [line[a], line[b]],
                args: [u, line[a], line[b], m],
              );
              if (!ok) return false;
            }
          }
        }
      }
    }
    return true;
  }

  /// Every way to fill a line whose cells allow [masks] with distinct digits
  /// that [accept] takes, as one mask per cell of the digits used there (all
  /// zero if there is none). [prefix] can cut a partial fill short: it gets
  /// the digits so far and returns false when no fill can start like that.
  List<int> lineFills(
    List<int> masks,
    bool Function(List<int> fill) accept, {
    bool Function(List<int> fill, int length)? prefix,
  }) {
    final k = masks.length;
    final union = List.filled(k, 0);
    final fill = List.filled(k, 0);
    void go(int at, int used) {
      if (at == k) {
        if (!accept(fill)) return;
        for (var i = 0; i < k; i++) {
          union[i] |= 1 << fill[i];
        }
        return;
      }
      for (var m = masks[at] & ~used; m != 0; m &= m - 1) {
        final d = digitOf(m & -m);
        fill[at] = d;
        if (prefix != null && !prefix(fill, at + 1)) continue;
        go(at + 1, used | (1 << d));
      }
    }

    go(0, 0);
    return union;
  }

  /// Number of solutions of [c] up to [limit], where [propagate] applies the
  /// type's rules (and the Latin ones) in place and returns false on a
  /// contradiction.
  int countSolutions(List<int> c, bool Function(List<int> c) propagate, {int limit = 2}) {
    final work = List.of(c);
    if (!propagate(work)) return 0;
    var best = -1, fewest = n + 1;
    for (var i = 0; i < work.length; i++) {
      final k = count(work[i]);
      if (k > 1 && k < fewest) {
        fewest = k;
        best = i;
      }
    }
    if (best < 0) return 1;
    var total = 0;
    for (final d in digits(work[best])) {
      final next = List.of(work)..[best] = 1 << d;
      total += countSolutions(next, propagate, limit: limit - total);
      if (total >= limit) break;
    }
    return total;
  }

  /// Rules out every candidate of a cell with at most [most] candidates that
  /// [propagate] (on a copy, with it placed) refutes, until nothing changes.
  /// False on a contradiction.
  bool probe(List<int> c, bool Function(List<int> c) propagate, {int most = 3}) {
    if (!propagate(c)) return false;
    var changed = true;
    while (changed && !solved(c)) {
      changed = false;
      for (var want = 2; want <= most && !changed; want++) {
        for (var i = 0; i < c.length && !changed; i++) {
          if (count(c[i]) != want) continue;
          for (final d in digits(c[i])) {
            if (propagate(List.of(c)..[i] = 1 << d)) continue;
            c[i] &= ~(1 << d);
            changed = true;
          }
        }
      }
      if (changed && !propagate(c)) return false;
    }
    return true;
  }

  /// A random Latin square (a digit per cell).
  List<int> random(Random rng) {
    while (true) {
      final c = List.filled(cells, full);
      if (_fill(c, rng)) return values(c);
    }
  }

  bool _fill(List<int> c, Random rng, [int budget = 2000]) {
    var steps = 0;
    bool go(List<int> c) {
      if (++steps > budget || !propagate(c)) return false;
      var best = -1, fewest = n + 1;
      for (var i = 0; i < c.length; i++) {
        final k = count(c[i]);
        if (k > 1 && k < fewest) {
          fewest = k;
          best = i;
        }
      }
      if (best < 0) return true;
      for (final d in digits(c[best])..shuffle(rng)) {
        final next = List.of(c)..[best] = 1 << d;
        if (go(next)) {
          c.setAll(0, next);
          return true;
        }
      }
      return false;
    }

    return go(c);
  }
}

/// A puzzle on a Latin square: one digit per cell, given or to find.
abstract class LatinPuzzle implements ValueGridPuzzle {
  int get n;
}

/// [MaskGridExplainer] for Latin-square puzzles: the knowledge is
/// [LatinSquare] candidates seeded from the board's correct entries, and the
/// Latin rules have their texts here. Types add their rules from
/// [latinRuleCount] up and describe them in [describeRule].
abstract class LatinExplainer<P extends LatinPuzzle> extends MaskGridExplainer<P> {
  const LatinExplainer();

  /// The type's own rules that place a digit.
  Set<int> get placingTypeRules => const {};

  /// Text for one of the type's own rules (ids from [latinRuleCount] up).
  ExplainLine? describeRule(P p, Fact f);

  @override
  int get lastCandidateRule => LatinRule.naked.index;

  @override
  Set<int> get placingRules => {LatinRule.naked.index, LatinRule.hidden.index, ...placingTypeRules};

  @override
  List<int> seed(P p, ValueGrid s) => LatinSquare.of(p.n).start([for (final v in knownValues(p, s)) v < 0 ? null : v]);

  @override
  ExplainLine? describe(P p, Fact f) {
    final sq = LatinSquare.of(p.n);
    final pos = p.size.pos;
    String cell(int i) => cellTok(pos(i));
    Set<Pos> cells(Iterable<int> idx) => {for (final i in idx) pos(i)};
    String line(int u) => u < p.n ? rowTok(u) : colTok(u - p.n);
    final at = f.slot >= 0 ? cell(f.slot) : '';
    final me = {if (f.slot >= 0) pos(f.slot)};
    final a = f.args;
    switch (f.rule) {
      case ruleAssume:
        return ExplainLine((l) => l.exSuppose(at, valTok(f.value)), me);
      case ruleRefuted:
        return ExplainLine((l) => l.exRefuted(at, valTok(f.value)), me);
    }
    if (f.rule >= latinRuleCount) return describeRule(p, f);
    switch (LatinRule.values[f.rule]) {
      case LatinRule.ruledOut:
        return null;
      case LatinRule.naked:
        return ExplainLine((l) => l.exLatinNaked(at, valTok(f.value)), {
          ...me,
          ...cells(sq.lines[sq.rowOf(f.slot)]),
          ...cells(sq.lines[sq.colOf(f.slot)]),
        });
      case LatinRule.hidden:
        final u = a[0];
        return ExplainLine(
          (l) => u < p.n
              ? l.exLatinHiddenRow(at, valTok(f.value), line(u))
              : l.exLatinHiddenCol(at, valTok(f.value), line(u)),
          cells(sq.lines[u]),
        );
      case LatinRule.pair:
        final u = a[0], ds = LatinSquare.digits(a[3]);
        final c1 = cell(a[1]), c2 = cell(a[2]), d1 = valTok(ds[0]), d2 = valTok(ds[1]);
        return ExplainLine(
          (l) => u < p.n ? l.exLatinPairRow(c1, c2, d1, d2, line(u)) : l.exLatinPairCol(c1, c2, d1, d2, line(u)),
          cells(sq.lines[u]),
        );
      case LatinRule.failEmpty:
        return ExplainLine((l) => l.exLatinFailEmpty(cell(a[0])), {pos(a[0])});
      case LatinRule.failNoPlace:
        final d = valTok(a[0]), u = a[1];
        return ExplainLine(
          (l) => u < p.n ? l.exLatinFailNoPlaceRow(d, line(u)) : l.exLatinFailNoPlaceCol(d, line(u)),
          cells(sq.lines[u]),
        );
    }
  }
}
