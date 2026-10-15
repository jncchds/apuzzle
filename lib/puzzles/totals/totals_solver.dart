import '../../core/explain.dart';
import 'totals_model.dart';

/// What a traced [TotalsSolver.propagate] records ([Fact.rule]).
/// Eliminations carry the removed digits as [Fact.value] (a mask),
/// placements the digit.
/// - [ruledOut]: a placed digit can't come again in its run (args: run);
/// - [naked]: the last digit left in a cell;
/// - [combo]: the digit sets that make the run's sum (holding its placed
///   digits, each digit with a cell that can take it) have no such digit
///   (args: run, union of the sets' open digits);
/// - [must]: every such set holds the digit and one cell of the run can
///   take it (args: run);
/// - [fill]: no way to fill the run with different digits making its sum
///   puts these digits here (args: run);
/// - [failEmpty]: a cell has no digit left (args: cell);
/// - [failRun]: the run can't make its sum (args: run).
enum TotalsRule { ruledOut, naked, combo, must, fill, failEmpty, failRun }

bool _single(int m) => m != 0 && m & (m - 1) == 0;

int _count(int m) {
  var k = 0;
  for (; m != 0; m &= m - 1) {
    k++;
  }
  return k;
}

/// The digits 0..8 of a mask.
List<int> totalsDigits(int m) => [
  for (var d = 0; d < 9; d++)
    if (m & (1 << d) != 0) d,
];

/// Every set of [k] different digits 1..9 adding up to [sum], as masks (bit
/// d for digit d + 1).
List<int> totalsCombos(int k, int sum) => _combos[k * 64 + sum] ??= [
  for (var m = 1; m < 512; m++)
    if (_count(m) == k && totalsDigits(m).fold(0, (s, d) => s + d + 1) == sum) m,
];
final _combos = <int, List<int>>{};

/// Candidate logic on a mask per cell (bit d: digit d + 1, 0 for clue
/// cells). Tier 1: placed digits, last digits, and the digit sets that make
/// each run's sum ([TotalsRule.combo], [TotalsRule.must]). Tier 2: + every
/// way to fill a run with different digits ([TotalsRule.fill]). Tier 3: +
/// probing. All sound, so a full solve proves the solution unique.
class TotalsSolver {
  TotalsSolver(this.p);

  final TotalsPuzzle p;

  List<int> start([Iterable<int>? givens]) {
    final c = [for (var i = 0; i < p.digits.length; i++) p.isBlock(i) ? 0 : totalsFull];
    for (final i in givens ?? p.givens) {
      c[i] = 1 << p.digits[i];
    }
    return c;
  }

  bool solved(List<int> c) {
    for (var i = 0; i < c.length; i++) {
      if (!p.isBlock(i) && !_single(c[i])) return false;
    }
    return true;
  }

  /// White cells [c] hasn't settled.
  int open(List<int> c) {
    var k = 0;
    for (var i = 0; i < c.length; i++) {
      if (!p.isBlock(i) && !_single(c[i])) k++;
    }
    return k;
  }

  /// The digits (0..8) of a solved [c], -1 for clue cells.
  List<int> values(List<int> c) => [for (var i = 0; i < c.length; i++) p.isBlock(i) ? -1 : c[i].bitLength - 1];

  /// Rules out [mask] in cell [i]; a cell left with one digit records
  /// [TotalsRule.naked]. False if nothing is left.
  bool _remove(List<int> c, int i, int mask, TotalsRule rule, ExplainTrace? t, List<int> premises, List<int> args) {
    final gone = c[i] & mask;
    if (gone == 0) return true;
    c[i] &= ~mask;
    if (t != null) {
      t.fact(i, gone, rule.index, premises: premises, args: args);
      if (_single(c[i])) t.fact(i, c[i].bitLength - 1, TotalsRule.naked.index, premises: [i]);
      if (c[i] == 0) t.fail(TotalsRule.failEmpty.index, premises: [i], args: [i]);
    }
    return c[i] != 0;
  }

  /// Placed digits ruled out in their runs, until nothing changes.
  bool _placed(List<int> c, ExplainTrace? t) {
    var changed = true;
    while (changed) {
      changed = false;
      for (var x = 0; x < p.runs.length; x++) {
        final cells = p.runs[x].cells;
        for (final i in cells) {
          final m = c[i];
          if (!_single(m)) continue;
          for (final j in cells) {
            if (j == i || c[j] & m == 0) continue;
            changed = true;
            if (!_remove(c, j, m, TotalsRule.ruledOut, t, [i], [x])) return false;
          }
        }
      }
    }
    return true;
  }

  /// The digit sets that can still make run [x]'s sum, as their digits not
  /// yet placed (none on a contradiction).
  List<int> _sets(List<int> c, int x) {
    final run = p.runs[x];
    var placed = 0, union = 0;
    final open = <int>[];
    for (final i in run.cells) {
      if (_single(c[i])) {
        placed |= c[i];
      } else {
        open.add(c[i]);
        union |= c[i];
      }
    }
    final sets = <int>[];
    for (final combo in totalsCombos(run.cells.length, run.sum)) {
      if (combo & placed != placed) continue;
      final rest = combo & ~placed;
      if (rest & ~union != 0 || open.any((m) => m & rest == 0)) continue;
      sets.add(rest);
    }
    return sets;
  }

  /// Every way to fill the open cells of run [x] with the digits of one of
  /// [sets]: the digits each open cell can take (in the run's order).
  List<int> _fills(List<int> c, int x, List<int> sets) {
    final open = [
      for (final i in p.runs[x].cells)
        if (!_single(c[i])) c[i],
    ];
    final can = List.filled(open.length, 0), fill = List.filled(open.length, 0);
    void go(int a, int left) {
      if (a == open.length) {
        for (var b = 0; b < open.length; b++) {
          can[b] |= fill[b];
        }
        return;
      }
      for (var m = open[a] & left; m != 0; m &= m - 1) {
        fill[a] = m & -m;
        go(a + 1, left & ~fill[a]);
      }
    }

    for (final s in sets) {
      go(0, s);
    }
    return can;
  }

  /// Applies the rules of [tier] (1 or 2) in place until nothing changes;
  /// false on a contradiction. With [t], every deduction is recorded.
  bool propagate(List<int> c, int tier, [ExplainTrace? t]) {
    final runs = p.runs;
    // The masks each run was last looked at with, per rule level: unchanged
    // runs are skipped.
    final seen = [List<List<int>?>.filled(runs.length, null), List<List<int>?>.filled(runs.length, null)];
    bool fresh(int level, int x) {
      final cells = runs[x].cells, last = seen[level][x];
      if (last != null) {
        var same = true;
        for (var a = 0; a < cells.length && same; a++) {
          same = last[a] == c[cells[a]];
        }
        if (same) return false;
      }
      seen[level][x] = [for (final i in cells) c[i]];
      return true;
    }

    while (true) {
      if (!_placed(c, t)) return false;
      var changed = false;
      for (var x = 0; x < runs.length; x++) {
        if (!fresh(0, x)) continue;
        final cells = runs[x].cells;
        final sets = _sets(c, x);
        if (sets.isEmpty) {
          t?.fail(TotalsRule.failRun.index, premises: cells, args: [x]);
          return false;
        }
        var union = 0, all = totalsFull;
        for (final s in sets) {
          union |= s;
          all &= s;
        }
        for (final i in cells) {
          if (_single(c[i]) || c[i] & ~union == 0) continue;
          changed = true;
          if (!_remove(c, i, ~union & totalsFull, TotalsRule.combo, t, cells, [x, union])) return false;
        }
        for (final d in totalsDigits(all)) {
          final bit = 1 << d;
          var spots = 0, at = -1;
          for (final i in cells) {
            if (c[i] & bit != 0) {
              spots++;
              at = i;
            }
          }
          if (spots != 1 || c[at] == bit) continue;
          c[at] = bit;
          t?.fact(at, d, TotalsRule.must.index, premises: cells, args: [x]);
          changed = true;
          break;
        }
      }
      if (changed) continue;
      if (tier < 2) return true;
      for (var x = 0; x < runs.length; x++) {
        if (!fresh(1, x)) continue;
        final cells = runs[x].cells;
        final can = _fills(c, x, _sets(c, x));
        if (can.isEmpty) continue;
        if (can.every((m) => m == 0)) {
          t?.fail(TotalsRule.failRun.index, premises: cells, args: [x]);
          return false;
        }
        var a = 0;
        for (final i in cells) {
          if (_single(c[i])) continue;
          final gone = c[i] & ~can[a++];
          if (gone == 0) continue;
          changed = true;
          if (!_remove(c, i, gone, TotalsRule.fill, t, cells, [x])) return false;
        }
      }
      if (!changed) return true;
    }
  }

  /// Rules out every digit of a cell with at most [most] candidates that
  /// tier 2 (on a copy, with the digit placed) refutes, until nothing
  /// changes. False on a contradiction.
  bool probe(List<int> c, {int most = 3}) {
    if (!propagate(c, 2)) return false;
    var changed = true;
    while (changed && !solved(c)) {
      changed = false;
      for (var want = 2; want <= most && !changed; want++) {
        for (var i = 0; i < c.length && !changed; i++) {
          if (_count(c[i]) != want) continue;
          for (final d in totalsDigits(c[i])) {
            if (propagate(List.of(c)..[i] = 1 << d, 2)) continue;
            c[i] &= ~(1 << d);
            changed = true;
          }
        }
      }
      if (changed && !propagate(c, 2)) return false;
    }
    return true;
  }

  /// Solves [c] in place with the rules up to [tier] (3 probes); true if
  /// every cell is known.
  bool solve(List<int> c, int tier) {
    final ok = tier >= 3 ? probe(c) : propagate(c, tier);
    return ok && solved(c);
  }

  /// The easiest tier that solves the board from [c], or 4 if none does.
  int grade(List<int> c) {
    for (var tier = 1; tier <= 3; tier++) {
      if (solve(List.of(c), tier)) return tier;
    }
    return 4;
  }

  /// Number of solutions from [c], up to [limit].
  int countSolutions(List<int> c, {int limit = 2}) {
    final work = List.of(c);
    if (!propagate(work, 2)) return 0;
    var best = -1, fewest = 10;
    for (var i = 0; i < work.length; i++) {
      final k = _count(work[i]);
      if (k > 1 && k < fewest) {
        fewest = k;
        best = i;
      }
    }
    if (best < 0) return 1;
    var total = 0;
    for (final d in totalsDigits(work[best])) {
      total += countSolutions(List.of(work)..[best] = 1 << d, limit: limit - total);
      if (total >= limit) break;
    }
    return total;
  }
}
