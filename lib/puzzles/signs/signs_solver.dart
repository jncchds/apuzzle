import '../../core/explain.dart';
import '../../core/latin_square.dart';
import 'signs_model.dart';

/// The sign rules on top of [LatinRule], recorded with the id
/// `latinRuleCount + index`; eliminations carry the removed digits as
/// [Fact.value] (a mask):
/// - [bound]: a cell smaller than a neighbour can't reach the neighbour's
///   largest candidate, and a bigger one its smallest (args: neighbour,
///   0 = smaller / 1 = bigger, that candidate);
/// - [group]: a cell smaller (bigger) than several cells of one line, through
///   a run of signs, needs that many different bigger (smaller) numbers left
///   for them (args: line, 0 = smaller / 1 = bigger, the cells...).
enum SignsRule {
  bound,
  group;

  int get id => latinRuleCount + index;
}

/// Cells of one line on the far side of a run of signs from a cell.
class _Group {
  const _Group(this.line, this.bigger, this.cells);

  final int line;

  /// Whether the cells are bigger than the cell (else smaller).
  final bool bigger;
  final List<int> cells;
}

/// Candidate logic for signs. Tier 1: the Latin singles plus sign bounds
/// (which carry along chains). Tier 2: + naked pairs and runs of signs in a
/// line ([SignsRule.group]). Tier 3: + probing. All sound, so a full solve
/// proves the solution unique.
class SignsSolver {
  SignsSolver(this.n, this.signs) : sq = LatinSquare.of(n) {
    final less = {for (final s in signs) (s.lo, s.hi)};
    for (var x = 0; x < n * n; x++) {
      final mine = <_Group>[];
      for (final u in [sq.rowOf(x), sq.colOf(x)]) {
        final line = sq.lines[u];
        final at = line.indexOf(x);
        for (final bigger in [true, false]) {
          bool step(int from, int to) => bigger ? less.contains((from, to)) : less.contains((to, from));
          final cells = <int>[];
          for (var q = at + 1; q < n && step(line[q - 1], line[q]); q++) {
            cells.add(line[q]);
          }
          for (var q = at - 1; q >= 0 && step(line[q + 1], line[q]); q--) {
            cells.add(line[q]);
          }
          if (cells.length >= 2) mine.add(_Group(u, bigger, cells..sort()));
        }
      }
      _groups.add(mine);
    }
  }

  final int n;
  final List<Sign> signs;
  final LatinSquare sq;
  final List<List<_Group>> _groups = [];

  List<int> start(List<int?> givens) => sq.start(givens);

  /// Applies the rules of [tier] (1 or 2) in place until nothing changes;
  /// false on a contradiction. With [t], every deduction is recorded.
  bool propagate(List<int> c, int tier, [ExplainTrace? t]) {
    while (true) {
      if (!sq.propagate(c, pairs: tier >= 2, t: t)) return false;
      final bounds = _bounds(c, t);
      if (bounds != 0) {
        if (bounds < 0) return false;
        continue;
      }
      if (tier < 2) return true;
      final runs = _runs(c, t);
      if (runs <= 0) return runs == 0;
    }
  }

  /// -1 on a contradiction, 1 if something was ruled out, else 0.
  int _bounds(List<int> c, ExplainTrace? t) {
    var changed = 0;
    for (final s in signs) {
      final top = LatinSquare.digitOf(c[s.hi]);
      final over = c[s.lo] & ~((1 << top) - 1);
      if (over != 0) {
        changed = 1;
        final ok = sq.remove(c, s.lo, over, SignsRule.bound.id, t: t, premises: [s.hi], args: [s.hi, 0, top]);
        if (!ok) return -1;
      }
      final low = LatinSquare.digitOf(c[s.lo] & -c[s.lo]);
      final under = c[s.hi] & ((2 << low) - 1);
      if (under != 0) {
        changed = 1;
        final ok = sq.remove(c, s.hi, under, SignsRule.bound.id, t: t, premises: [s.lo], args: [s.lo, 1, low]);
        if (!ok) return -1;
      }
    }
    return changed;
  }

  int _runs(List<int> c, ExplainTrace? t) {
    var changed = 0;
    for (var x = 0; x < c.length; x++) {
      for (final g in _groups[x]) {
        var union = 0;
        for (final j in g.cells) {
          union |= c[j];
        }
        var gone = 0;
        for (final d in LatinSquare.digits(c[x])) {
          final side = g.bigger ? union & ~((2 << d) - 1) : union & ((1 << d) - 1);
          if (LatinSquare.count(side) < g.cells.length) gone |= 1 << d;
        }
        if (gone == 0) continue;
        changed = 1;
        final ok = sq.remove(
          c,
          x,
          gone,
          SignsRule.group.id,
          t: t,
          premises: g.cells,
          args: [g.line, g.bigger ? 0 : 1, ...g.cells],
        );
        if (!ok) return -1;
      }
    }
    return changed;
  }

  /// Solves [c] in place with the rules up to [tier] (3 probes); true if
  /// every cell is known.
  bool solve(List<int> c, int tier) {
    final ok = tier >= 3 ? sq.probe(c, (x) => propagate(x, 2)) : propagate(c, tier);
    return ok && sq.solved(c);
  }

  int countSolutions(List<int> c, {int limit = 2}) => sq.countSolutions(c, (x) => propagate(x, 2), limit: limit);
}
