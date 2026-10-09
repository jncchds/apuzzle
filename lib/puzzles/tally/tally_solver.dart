import '../../core/explain.dart';
import 'tally_model.dart';

/// What a traced [TallySolver.propagate] records ([Fact.rule]); [Fact.value]
/// is [tallyCross] or [tallyKeep]. The args are the line (rows, then
/// columns) and a number: what the line still needs ([tooBig]) or its sum.
enum TallyRule { tooBig, needed, everyWay, failOver, failShort, failNoWay }

/// Tally logic on cell states: -1 undecided, [tallyCross], [tallyKeep].
/// Tier 1: a digit bigger than what its line still needs goes; a digit the
/// line can't reach its sum without stays. Tier 2: + what every way to make
/// a line's sum agrees on. Tier 3: + probing.
class TallySolver {
  TallySolver(this.rows, this.cols, this.digits, List<int> rowTargets, List<int> colTargets)
    : lines = [
        for (var r = 0; r < rows; r++) [for (var c = 0; c < cols; c++) r * cols + c],
        for (var c = 0; c < cols; c++) [for (var r = 0; r < rows; r++) r * cols + c],
      ],
      targets = [...rowTargets, ...colTargets];

  factory TallySolver.of(TallyPuzzle p) => TallySolver(p.rows, p.cols, p.digits, p.rowTargets, p.colTargets);

  final int rows;
  final int cols;
  final List<int> digits;
  final List<List<int>> lines;
  final List<int> targets;

  List<int> start({List<int> givens = const [], List<bool>? kept}) {
    final st = List<int>.filled(rows * cols, -1);
    for (final i in givens) {
      st[i] = kept![i] ? tallyKeep : tallyCross;
    }
    return st;
  }

  /// Applies logic up to [tier] (1 or 2) in place; false on a contradiction.
  /// With [t], every deduction is recorded (see [TallyRule]).
  bool propagate(List<int> st, [int tier = 2, ExplainTrace? t]) {
    var changed = true;
    void set(int i, int v, TallyRule rule, int li, int arg) {
      if (st[i] != -1) return;
      st[i] = v;
      changed = true;
      t?.fact(i, v, rule.index, premises: lines[li], args: [li, arg]);
    }

    while (changed) {
      changed = false;
      for (var li = 0; li < lines.length; li++) {
        var left = targets[li], open = 0;
        for (final i in lines[li]) {
          if (st[i] == tallyKeep) left -= digits[i];
          if (st[i] == -1) open += digits[i];
        }
        if (left < 0) {
          t?.fail(TallyRule.failOver.index, premises: lines[li], args: [li, targets[li]]);
          return false;
        }
        if (open < left) {
          t?.fail(TallyRule.failShort.index, premises: lines[li], args: [li, targets[li]]);
          return false;
        }
        for (final i in lines[li]) {
          if (st[i] != -1) continue;
          if (digits[i] > left) {
            set(i, tallyCross, TallyRule.tooBig, li, left);
          } else if (open - digits[i] < left) {
            set(i, tallyKeep, TallyRule.needed, li, targets[li]);
          }
        }
      }
      if (changed || tier < 2) continue;
      for (var li = 0; li < lines.length && !changed; li++) {
        if (!_everyWay(st, li, set)) {
          t?.fail(TallyRule.failNoWay.index, premises: lines[li], args: [li, targets[li]]);
          return false;
        }
      }
    }
    return true;
  }

  /// Settles the open cells of line [li] that every way to make its sum
  /// keeps (or crosses out); false if there's no way at all.
  bool _everyWay(List<int> st, int li, void Function(int, int, TallyRule, int, int) set) {
    var need = targets[li];
    final open = <int>[];
    for (final i in lines[li]) {
      if (st[i] == tallyKeep) need -= digits[i];
      if (st[i] == -1) open.add(i);
    }
    if (open.isEmpty) return need == 0;
    final m = open.length;
    // ahead[k][s]: the first k open cells can make s; behind[k][s]: the cells from k on can.
    final ahead = List.generate(m + 1, (_) => List<bool>.filled(need + 1, false));
    final behind = List.generate(m + 1, (_) => List<bool>.filled(need + 1, false));
    ahead[0][0] = true;
    behind[m][0] = true;
    for (var k = 0; k < m; k++) {
      final d = digits[open[k]];
      for (var s = 0; s <= need; s++) {
        ahead[k + 1][s] = ahead[k][s] || (s >= d && ahead[k][s - d]);
      }
    }
    for (var k = m - 1; k >= 0; k--) {
      final d = digits[open[k]];
      for (var s = 0; s <= need; s++) {
        behind[k][s] = behind[k + 1][s] || (s >= d && behind[k + 1][s - d]);
      }
    }
    if (!ahead[m][need]) return false;
    bool can(int k, int rest) {
      for (var s = 0; s <= rest; s++) {
        if (ahead[k][s] && behind[k + 1][rest - s]) return true;
      }
      return false;
    }

    for (var k = 0; k < m; k++) {
      final d = digits[open[k]];
      final keep = d <= need && can(k, need - d), cross = can(k, need);
      if (!keep) set(open[k], tallyCross, TallyRule.everyWay, li, targets[li]);
      if (!cross) set(open[k], tallyKeep, TallyRule.everyWay, li, targets[li]);
    }
    return true;
  }

  /// Solves in place with logic up to [tier]; false on a contradiction.
  bool solve(List<int> st, int tier) {
    if (!propagate(st, tier.clamp(1, 2))) return false;
    if (tier >= 3) {
      var progress = true;
      while (progress && st.contains(-1)) {
        progress = false;
        for (var i = 0; i < st.length; i++) {
          if (st[i] != -1) continue;
          for (final v in const [tallyCross, tallyKeep]) {
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

  /// Cells logic up to [tier] leaves open from [st0] (all cells + 1 on a
  /// contradiction).
  int slack(int tier, [List<int>? st0]) {
    final st = st0 == null ? start() : List.of(st0);
    if (!solve(st, tier)) return st.length + 1;
    return st.where((x) => x == -1).length;
  }

  /// Lowest tier (1..3) that solves the board from [st0], or 4.
  int grade([List<int>? st0]) {
    for (var t = 1; t <= 3; t++) {
      if (slack(t, st0) == 0) return t;
    }
    return 4;
  }

  /// Number of solutions (up to [limit]), or -1 if the search gets too big.
  int countSolutions({int limit = 2, List<int>? from, int budget = 100000}) {
    var nodes = 0, total = 0;
    void rec(List<int> st) {
      if (total >= limit || ++nodes > budget) return;
      if (!propagate(st)) return;
      final i = st.indexOf(-1);
      if (i < 0) {
        total++;
        return;
      }
      for (final v in const [tallyCross, tallyKeep]) {
        rec(List.of(st)..[i] = v);
      }
    }

    rec(from == null ? start() : List.of(from));
    return nodes > budget ? -1 : total;
  }
}
