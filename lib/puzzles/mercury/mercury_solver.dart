import 'dart:math';

import '../../core/difficulty.dart';
import '../../core/explain.dart';
import 'mercury_model.dart';

/// What a traced [MercurySolver.propagate] records ([Fact.rule]); [Fact.value]
/// is [mercuryFull] or [mercuryEmpty].
enum MercuryRule {
  /// A filled cell fills its tube down to the bulb. Args: the filled cell.
  toBulb,

  /// An empty cell keeps its tube empty up to the tip. Args: the empty cell.
  pastEmpty,

  /// A line has all its filled cells / needs all its open cells. Args: line, count.
  lineDone,
  lineNeed,

  /// Filled here, a tube would fill more cells of a line than it has left.
  /// Args: line, cells it would fill there, filled cells the line still needs.
  tooMuch,

  /// Empty here, too many cells of a line would stay empty. Args: line,
  /// cells that would stay empty there, filled cells the line still needs.
  tooLittle,

  /// Two lines that share tubes, counted together: every level of this
  /// tube that leaves both counts reachable agrees here. Args: the two lines.
  pair,
  failOrder,
  failLineMany,
  failLineFew,
  failPair,
}

/// The logic tier a difficulty is built for: 1 filling down to the bulb and
/// counts, 2 + two lines that share tubes counted together, 3 + probing.
int mercuryTier(Difficulty d) => switch (d) {
  Difficulty.easy => 1,
  Difficulty.medium => 2,
  _ => 3,
};

const int _unk = -1;

/// Cell states: -1 unknown, [mercuryFull], [mercuryEmpty].
class MercurySolver {
  MercurySolver(this.rows, this.cols, this.tubes, this.rowCounts, this.colCounts, {this.disabled = const {}})
    : lines = mercuryLines(rows, cols),
      tubeOf = List.filled(rows * cols, -1),
      place = List.filled(rows * cols, 0) {
    for (var t = 0; t < tubes.length; t++) {
      for (var k = 0; k < tubes[t].length; k++) {
        tubeOf[tubes[t][k]] = t;
        place[tubes[t][k]] = k;
      }
    }
    // How many cells of a line the first L cells of a tube hold, per line, tube and L.
    inLine = List.generate(lines.length, (_) => <int, List<int>>{});
    for (var t = 0; t < tubes.length; t++) {
      for (final li in {for (final i in tubes[t]) ...linesOf(i)}) {
        final c = [0];
        for (final i in tubes[t]) {
          c.add(c.last + (linesOf(i).contains(li) ? 1 : 0));
        }
        inLine[li][t] = c;
      }
    }
    pairs = [
      for (var a = 0; a < lines.length; a++)
        for (var b = a + 1; b < lines.length; b++)
          if ([
                for (final t in inLine[a].keys)
                  if (inLine[b].containsKey(t)) t,
              ]
              case final shared when shared.length >= 2)
            (a, b, shared),
    ];
  }

  factory MercurySolver.of(MercuryPuzzle p, {Set<MercuryRule> disabled = const {}}) =>
      MercurySolver(p.rows, p.cols, p.tubes, p.rowCounts, p.colCounts, disabled: disabled);

  final int rows;
  final int cols;
  final List<List<int>> tubes;
  final List<int?> rowCounts;
  final List<int?> colCounts;
  final List<List<int>> lines;
  final List<int> tubeOf;
  final List<int> place;

  /// Per line, the cells of it the first L cells of each tube through it hold.
  late final List<Map<int, List<int>>> inLine;

  /// Lines that share two or more tubes, with those tubes.
  late final List<(int, int, List<int>)> pairs;

  /// Rules left out (for tests and tutorial boards that must need a rule).
  final Set<MercuryRule> disabled;

  int? countOf(int line) => line < rows ? rowCounts[line] : colCounts[line - rows];

  /// The lines through cell [i]: its row, then its column.
  List<int> linesOf(int i) => [i ~/ cols, rows + i % cols];

  /// The start: shown cells set from [given] (cell → value).
  List<int> start([Map<int, int> given = const {}]) {
    final st = List.filled(rows * cols, _unk);
    given.forEach((i, v) => st[i] = v);
    return st;
  }

  /// The levels tube [t] can still have: from the cells known filled (low)
  /// to the first cell known empty (high), both included.
  (int, int) range(List<int> st, int t) {
    var lo = 0, hi = tubes[t].length;
    for (var k = 0; k < tubes[t].length; k++) {
      final v = st[tubes[t][k]];
      if (v == mercuryFull) lo = k + 1;
      if (v == mercuryEmpty && k < hi) hi = k;
    }
    return (lo, hi);
  }

  /// Applies the rules up to [tier] (1 or 2) until nothing changes. False on
  /// a contradiction. With [tr], every deduction is recorded (see [MercuryRule]).
  bool propagate(List<int> st, int tier, [ExplainTrace? tr]) {
    bool on(MercuryRule r) => !disabled.contains(r);
    var changed = true;
    while (changed) {
      changed = false;

      // Down to the bulb, up to the tip.
      for (final tube in tubes) {
        var top = -1, low = tube.length;
        for (var k = 0; k < tube.length; k++) {
          if (st[tube[k]] == mercuryFull) top = k;
          if (st[tube[k]] == mercuryEmpty && k < low) low = k;
        }
        if (top > low) {
          tr?.fail(MercuryRule.failOrder.index, premises: [tube[top], tube[low]], args: [tube[top], tube[low]]);
          return false;
        }
        for (var k = 0; k < tube.length; k++) {
          final i = tube[k];
          if (st[i] != _unk) continue;
          if (k < top) {
            st[i] = mercuryFull;
            tr?.fact(i, mercuryFull, MercuryRule.toBulb.index, premises: [tube[top]], args: [tube[top]]);
            changed = true;
          } else if (k > low) {
            st[i] = mercuryEmpty;
            tr?.fact(i, mercuryEmpty, MercuryRule.pastEmpty.index, premises: [tube[low]], args: [tube[low]]);
            changed = true;
          }
        }
      }

      // Line counts.
      for (var li = 0; li < lines.length; li++) {
        final want = countOf(li);
        if (want == null) continue;
        final cells = lines[li];
        var t = 0;
        final u = <int>[];
        for (final i in cells) {
          if (st[i] == mercuryFull) t++;
          if (st[i] == _unk) u.add(i);
        }
        if (t > want || t + u.length < want) {
          tr?.fail(
            (t > want ? MercuryRule.failLineMany : MercuryRule.failLineFew).index,
            premises: cells,
            args: [li, want],
          );
          return false;
        }
        if (u.isEmpty || (t != want && t + u.length != want)) continue;
        for (final i in u) {
          st[i] = t == want ? mercuryEmpty : mercuryFull;
          tr?.fact(
            i,
            st[i],
            (t == want ? MercuryRule.lineDone : MercuryRule.lineNeed).index,
            premises: cells,
            args: [li, want],
          );
        }
        changed = true;
      }
      if (changed) continue;

      // What filling a cell (or leaving it empty) would do to a line.
      if (on(MercuryRule.tooMuch) || on(MercuryRule.tooLittle)) {
        final room = [for (var li = 0; li < lines.length; li++) _room(st, li)];
        final open = [for (final l in lines) l.where((i) => st[i] == _unk).length];
        final per = List.filled(lines.length, 0);
        final hit = <int>[];
        for (var x = 0; x < st.length; x++) {
          if (st[x] != _unk) continue;
          final tube = tubes[tubeOf[x]], k = place[x];
          for (final full in const [true, false]) {
            if (!on(full ? MercuryRule.tooMuch : MercuryRule.tooLittle)) continue;
            // Filled: x and the open cells toward the bulb fill; empty: x and the open cells toward the tip empty.
            for (var j = full ? 0 : k; j < (full ? k + 1 : tube.length); j++) {
              if (st[tube[j]] != _unk) continue;
              for (final li in linesOf(tube[j])) {
                if (per[li]++ == 0) hit.add(li);
              }
            }
            for (final li in hit) {
              final c = per[li], need = room[li];
              if (need == null || st[x] != _unk) continue;
              if (full ? c <= need : open[li] - c >= need) continue;
              st[x] = full ? mercuryEmpty : mercuryFull;
              tr?.fact(
                x,
                st[x],
                (full ? MercuryRule.tooMuch : MercuryRule.tooLittle).index,
                premises: lines[li],
                args: [li, c, need],
              );
              for (final l in linesOf(x)) {
                open[l]--;
                if (!full && room[l] != null) room[l] = room[l]! - 1;
              }
              changed = true;
            }
            for (final li in hit) {
              per[li] = 0;
            }
            hit.clear();
            if (st[x] != _unk) break;
          }
        }
      }
      if (changed || tier < 2) continue;

      // Two lines sharing tubes, counted together.
      if (!on(MercuryRule.pair)) continue;
      for (final (a, b, shared) in pairs) {
        final r = _pair(st, a, b, shared, tr);
        if (r == null) return false;
        if (r) {
          changed = true;
          break;
        }
      }
    }
    return true;
  }

  /// Sets the cells of tube [t] that every level in [mask] agrees on; true if any.
  bool _narrow(List<int> st, int t, int mask, void Function(int cell) record) {
    final lo = _lowest(mask), hi = mask.bitLength - 1;
    var any = false;
    final tube = tubes[t];
    for (var k = 0; k < tube.length; k++) {
      final i = tube[k];
      if (st[i] != _unk) continue;
      if (k < lo) {
        st[i] = mercuryFull;
      } else if (k >= hi) {
        st[i] = mercuryEmpty;
      } else {
        continue;
      }
      record(i);
      any = true;
    }
    return any;
  }

  static int _lowest(int mask) => (mask & -mask).bitLength - 1;

  /// Counts lines [a] and [b] together: the tubes through both give pairs of
  /// counts, the tubes through one of them a range. Each shared tube keeps
  /// the levels with which both counts stay reachable. True if a cell was
  /// set, null on a contradiction.
  bool? _pair(List<int> st, int a, int b, List<int> shared, ExplainTrace? tr) {
    final wa = countOf(a), wb = countOf(b);
    if (wa == null || wb == null) return false;
    // The range the tubes through only one of the lines give it.
    (int, int) single(int li, int other) {
      var lo = 0, hi = 0;
      for (final MapEntry(key: t, value: p) in inLine[li].entries) {
        if (inLine[other].containsKey(t)) continue;
        final (l, h) = range(st, t);
        lo += p[l];
        hi += p[h];
      }
      return (lo, hi);
    }

    final (loA, hiA) = single(a, b);
    final (loB, hiB) = single(b, a);
    final size = lines[a].length + 1;
    // Sets of count pairs: bit y of set[x] for the pair (x, y).
    List<int> add(List<int> set, int t) {
      final out = List.filled(size, 0);
      final (lo, hi) = range(st, t);
      final pa = inLine[a][t]!, pb = inLine[b][t]!;
      for (var l = lo; l <= hi; l++) {
        for (var x = 0; x + pa[l] < size; x++) {
          out[x + pa[l]] |= set[x] << pb[l];
        }
      }
      return out;
    }

    final n = shared.length;
    final start = List.filled(size, 0)..[0] = 1;
    final pre = [start], suf = List.filled(n + 1, start);
    for (var k = 0; k < n; k++) {
      pre.add(add(pre[k], shared[k]));
    }
    for (var k = n - 1; k >= 0; k--) {
      suf[k] = add(suf[k + 1], shared[k]);
    }
    var any = false;
    for (var k = 0; k < n; k++) {
      // The pairs the other shared tubes give.
      final others = List.filled(size, 0);
      for (var x = 0; x < size; x++) {
        for (var m = pre[k][x]; m != 0; m &= m - 1) {
          final y = _lowest(m);
          for (var z = 0; x + z < size; z++) {
            others[x + z] |= suf[k + 1][z] << y;
          }
        }
      }
      final t = shared[k];
      final (lo, hi) = range(st, t);
      final pa = inLine[a][t]!, pb = inLine[b][t]!;
      var mask = 0;
      for (var l = lo; l <= hi; l++) {
        // What's left for the others: wa - pa[l] minus the singles' range in a, same for b.
        final yLo = wb - pb[l] - hiB, yHi = wb - pb[l] - loB;
        if (yHi < 0) continue;
        final ys = ((1 << (yHi + 1)) - 1) & ~((1 << max(yLo, 0)) - 1);
        for (var x = max(0, wa - pa[l] - hiA); x <= wa - pa[l] - loA && x < size; x++) {
          if (others[x] & ys != 0) {
            mask |= 1 << l;
            break;
          }
        }
      }
      List<int> cells() => {...lines[a], ...lines[b]}.toList();
      if (mask == 0) {
        tr?.fail(MercuryRule.failPair.index, premises: cells(), args: [a, b]);
        return null;
      }
      if (_narrow(st, t, mask, (i) => tr?.fact(i, st[i], MercuryRule.pair.index, premises: cells(), args: [a, b]))) {
        any = true;
      }
    }
    return any;
  }

  /// Filled cells line [li] still needs, or null without a count.
  int? _room(List<int> st, int li) {
    final want = countOf(li);
    if (want == null) return null;
    return want - lines[li].where((i) => st[i] == mercuryFull).length;
  }

  bool solved(List<int> st) => !st.contains(_unk);

  /// True if [st] gets fully determined using logic up to [tier] (3 probes).
  bool solve(List<int> st, int tier) {
    final level = tier < 2 ? 1 : 2;
    if (!propagate(st, level)) return false;
    if (tier >= 3) {
      var progress = true;
      while (progress && !solved(st)) {
        progress = false;
        for (var i = 0; i < st.length; i++) {
          if (st[i] != _unk) continue;
          for (final v in const [mercuryFull, mercuryEmpty]) {
            final t = List.of(st)..[i] = v;
            if (propagate(t, 2)) continue;
            st[i] = 1 - v;
            if (!propagate(st, 2)) return false;
            progress = true;
            break;
          }
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
    final i = t.indexOf(_unk);
    if (i < 0) return 1;
    var total = 0;
    for (final v in const [mercuryFull, mercuryEmpty]) {
      if (total >= limit) break;
      total += countSolutions(List.of(t)..[i] = v, limit: limit - total);
    }
    return total;
  }
}

/// [MercurySolver.start] with the shown cells of [p].
List<int> mercuryStart(MercurySolver s, MercuryPuzzle p) => s.start({for (final g in p.givens) g: p.solutionAt(g)});
