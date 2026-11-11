import '../../core/explain.dart';
import '../../core/latin_square.dart';
import 'straights_model.dart';

/// What [StraightsSolver] records ([Fact.rule]). Eliminations carry the
/// removed bits as [Fact.value] (bit d = digit d, the board value),
/// placements the digit. A run is an index into [StraightsPuzzle.runs].
/// - [ruledOut]: a placed number (or a dark cell's) rules it out in the line;
/// - [naked]: the last number left in a cell;
/// - [range]: no stretch of consecutive numbers the run can still hold
///   covers it (args: run, the numbers that some stretch covers);
/// - [sure]: every stretch the run can hold uses the number, so it can't be
///   elsewhere in the line (args: run);
/// - [hidden]: a number every stretch uses with one spot left in the run
///   (args: run);
/// - [subset]: k cells of a line that can only hold k numbers between them
///   rule those out in the rest of it (args: line, numbers, the k cells);
/// - [fill]: no way to fill the run with different consecutive numbers puts
///   it there (args: run);
/// - [failEmpty] (args: cell), [failRun] (args: run).
enum StraightsRule { ruledOut, naked, range, sure, hidden, subset, fill, failEmpty, failRun }

/// Candidate logic on masks (bit d = digit d; a dark cell holds its number's
/// bit, or bit [straightsBlock] when it has none, so it counts as placed).
/// Tier 1: singles, the stretches of consecutive numbers each run can still
/// hold (with every number of the stretch housable) and the numbers every
/// stretch uses. Tier 2: + naked pairs and triples in a line and every way to
/// fill a run (a matching of cells to numbers). Tier 3: + probing. All sound,
/// so a full solve proves the solution unique.
class StraightsSolver {
  StraightsSolver(this.p, {this.disabled = const {}}) : n = p.n, full = (1 << p.n) - 1, lines = straightsLines(p.n);

  final StraightsPuzzle p;
  final int n, full;
  final List<List<int>> lines;

  /// Rules left out (tests and lesson boards).
  final Set<StraightsRule> disabled;

  static const int blockBit = 1 << straightsBlock;

  /// Candidates with the dark cells and the [givens] (a digit or null per
  /// open cell) placed.
  List<int> start(List<int?> givens) => [
    for (var i = 0; i < givens.length; i++)
      if (p.dark[i])
        p.clues[i] == null ? blockBit : 1 << p.clues[i]!
      else if (givens[i] case final g?)
        1 << g
      else
        full,
  ];

  static bool single(int m) => m != 0 && m & (m - 1) == 0;
  static int valueOf(int m) => m.bitLength - 1;

  int _steps = 0;

  bool _remove(
    List<int> c,
    int i,
    int mask,
    StraightsRule rule,
    ExplainTrace? t, {
    List<int> premises = const [],
    List<int> args = const [],
  }) {
    final gone = c[i] & mask;
    if (gone == 0) return true;
    _steps++;
    c[i] &= ~mask;
    if (t != null) {
      t.fact(i, gone, rule.index, premises: premises, args: args);
      if (single(c[i])) t.fact(i, valueOf(c[i]), StraightsRule.naked.index, premises: [i]);
      if (c[i] == 0) t.fail(StraightsRule.failEmpty.index, premises: [i], args: [i]);
    }
    return c[i] != 0;
  }

  bool _place(List<int> c, int i, int v, StraightsRule rule, ExplainTrace? t, List<int> premises, List<int> args) {
    if (c[i] == 1 << v) return true;
    if (c[i] & (1 << v) == 0) {
      t?.fail(StraightsRule.failEmpty.index, premises: [i], args: [i]);
      return false;
    }
    _steps++;
    c[i] = 1 << v;
    t?.fact(i, v, rule.index, premises: premises, args: args);
    return true;
  }

  /// A placed number (on an open or a dark cell) is ruled out in the open
  /// cells of its row and column.
  bool _singles(List<int> c, ExplainTrace? t) {
    for (var i = 0; i < c.length; i++) {
      final m = c[i];
      if (m == 0) {
        t?.fail(StraightsRule.failEmpty.index, premises: [i], args: [i]);
        return false;
      }
      if (!single(m) || m == blockBit) continue;
      for (final line in [lines[i ~/ n], lines[n + i % n]]) {
        for (final j in line) {
          if (j == i || p.dark[j]) continue;
          if (!_remove(c, j, m, StraightsRule.ruledOut, t, premises: [i])) return false;
        }
      }
    }
    return true;
  }

  /// Whether the [cells] (masks) can take the numbers of [set] one each
  /// ([set] has as many bits as there are cells).
  static bool matches(List<int> cells, int set) {
    var union = 0;
    for (final m in cells) {
      if (m & set == 0) return false;
      union |= m;
    }
    if (union & set != set) return false;
    final owner = List.filled(16, -1);
    bool assign(int x, int seen) {
      for (var m = cells[x] & set & ~seen; m != 0; m &= m - 1) {
        final bit = m & -m;
        final d = bit.bitLength - 1;
        final o = owner[d];
        if (o < 0 || assign(o, seen | bit)) {
          owner[d] = x;
          return true;
        }
      }
      return false;
    }

    for (var x = 0; x < cells.length; x++) {
      if (!assign(x, 0)) return false;
    }
    return true;
  }

  /// The stretches (as masks of consecutive numbers) the run with cell masks
  /// [masks] can hold: every cell can take one of its numbers and every
  /// number fits some cell, or with [exact] a matching of cells to numbers.
  List<int> stretches(List<int> masks, bool exact) {
    final k = masks.length;
    final out = <int>[];
    for (var a = 0; a + k <= n; a++) {
      final set = ((1 << k) - 1) << a;
      if (exact) {
        if (matches(masks, set)) out.add(set);
        continue;
      }
      var union = 0, ok = true;
      for (final m in masks) {
        if (m & set == 0) {
          ok = false;
          break;
        }
        union |= m;
      }
      if (ok && union & set == set) out.add(set);
    }
    return out;
  }

  /// The run rules: numbers no stretch covers ([StraightsRule.range], with
  /// [exact] every cell's numbers some filling uses: [StraightsRule.fill]),
  /// numbers every stretch uses ruled out in the rest of the line, and their
  /// last spot in the run.
  bool _runs(List<int> c, bool exact, ExplainTrace? t, List<List<int>?> seen) {
    for (var x = 0; x < p.runs.length; x++) {
      final run = p.runs[x];
      final masks = [for (final i in run.cells) c[i]];
      if (exact) {
        if (seen[x] case final last? when _same(last, masks)) continue;
        seen[x] = masks;
      }
      final sets = stretches(masks, exact);
      if (sets.isEmpty) {
        t?.fail(StraightsRule.failRun.index, premises: run.cells, args: [x]);
        return false;
      }
      var any = 0, every = full;
      for (final s in sets) {
        any |= s;
        every &= s;
      }
      if (!exact && !disabled.contains(StraightsRule.range)) {
        for (final i in run.cells) {
          if (!_remove(c, i, full & ~any, StraightsRule.range, t, premises: run.cells, args: [x, any])) return false;
        }
      }
      if (exact && !disabled.contains(StraightsRule.fill)) {
        final can = List.filled(masks.length, 0);
        for (final s in sets) {
          for (var y = 0; y < masks.length; y++) {
            for (var m = masks[y] & s & ~can[y]; m != 0; m &= m - 1) {
              final bit = m & -m;
              final rest = [
                for (var z = 0; z < masks.length; z++)
                  if (z != y) masks[z],
              ];
              if (matches(rest, s & ~bit)) can[y] |= bit;
            }
          }
        }
        for (var y = 0; y < masks.length; y++) {
          if (!_remove(c, run.cells[y], full & ~can[y], StraightsRule.fill, t, premises: run.cells, args: [x])) {
            return false;
          }
        }
      }
      if (every == 0) continue;
      if (!disabled.contains(StraightsRule.sure)) {
        for (final j in lines[run.line]) {
          if (p.dark[j] || run.cells.contains(j)) continue;
          if (!_remove(c, j, every, StraightsRule.sure, t, premises: run.cells, args: [x])) return false;
        }
      }
      if (!disabled.contains(StraightsRule.hidden)) {
        for (var m = every; m != 0; m &= m - 1) {
          final bit = m & -m;
          var spots = 0, at = -1;
          for (final i in run.cells) {
            if (c[i] & bit != 0) {
              spots++;
              at = i;
            }
          }
          if (spots == 1 && !_place(c, at, bit.bitLength - 1, StraightsRule.hidden, t, run.cells, [x])) return false;
        }
      }
    }
    return true;
  }

  /// k open cells of a line (k = 2, 3) that can only hold k numbers between
  /// them rule those out in the line's other open cells.
  bool _subsets(List<int> c, ExplainTrace? t) {
    if (disabled.contains(StraightsRule.subset)) return true;
    for (var u = 0; u < lines.length; u++) {
      final open = [
        for (final i in lines[u])
          if (!p.dark[i] && !single(c[i])) i,
      ];
      bool apply(List<int> cells, int union) {
        for (final j in open) {
          if (cells.contains(j)) continue;
          final args = [u, union, ...cells];
          if (!_remove(c, j, union, StraightsRule.subset, t, premises: cells, args: args)) return false;
        }
        return true;
      }

      for (var a = 0; a < open.length; a++) {
        for (var b = a + 1; b < open.length; b++) {
          final ab = c[open[a]] | c[open[b]];
          if (LatinSquare.count(ab) == 2) {
            if (!apply([open[a], open[b]], ab)) return false;
            continue;
          }
          for (var d = b + 1; d < open.length; d++) {
            final abd = ab | c[open[d]];
            if (LatinSquare.count(abd) == 3 && !apply([open[a], open[b], open[d]], abd)) return false;
          }
        }
      }
    }
    return true;
  }

  /// Applies the rules of [tier] (1 or 2) in place until nothing changes;
  /// false on a contradiction. With [t], every deduction is recorded.
  bool propagate(List<int> c, int tier, [ExplainTrace? t]) {
    final seen = List<List<int>?>.filled(p.runs.length, null);
    while (true) {
      final before = _steps;
      if (!_singles(c, t)) return false;
      if (_steps != before) continue;
      if (!_runs(c, false, t, seen)) return false;
      if (_steps != before) continue;
      if (tier < 2) return true;
      if (!_subsets(c, t)) return false;
      if (_steps != before) continue;
      if (!_runs(c, true, t, seen)) return false;
      if (_steps == before) return true;
    }
  }

  static bool _same(List<int> a, List<int> b) {
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  bool solved(List<int> c) => c.every(single);

  /// Solves [c] in place with the rules up to [tier] (3 probes); true if
  /// every cell is known.
  bool solve(List<int> c, int tier) {
    final ok = tier >= 3 ? LatinSquare.of(n).probe(c, (x) => propagate(x, 2)) : propagate(c, tier);
    return ok && solved(c);
  }

  /// The lowest tier (1..3) that solves the board from [givens], or 4.
  int grade(List<int?> givens) {
    for (var tier = 1; tier <= 3; tier++) {
      if (solve(start(givens), tier)) return tier;
    }
    return 4;
  }

  int countSolutions(List<int> c, {int limit = 2}) =>
      LatinSquare.of(n).countSolutions(c, (x) => propagate(x, 2), limit: limit);

  /// The board values of a solved [c] (dark cells [straightsBlock]).
  List<int> values(List<int> c) => [
    for (var i = 0; i < c.length; i++) p.dark[i] ? straightsBlock : valueOf(c[i]),
  ];
}
