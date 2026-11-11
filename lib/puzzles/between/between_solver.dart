import 'dart:math';

import '../../core/explain.dart';
import '../../core/latin_square.dart';
import 'between_model.dart';

/// What [BetweenSolver] records ([Fact.rule]). Eliminations carry the
/// removed bits as [Fact.value] (bit 0 = shaded, bit d = digit d),
/// placements the value. Line u is a row below n, else a column.
/// - [ruledOut]: a placed digit, or a line's two shaded cells, rule it out;
/// - [naked]: the last value left in a cell;
/// - [hidden]: the only spot of a digit in a line (args: line);
/// - [shadePair]: the only two cells of a line that can be shaded (args: line);
/// - [span]: no cell of the line that can be shaded lies at a distance whose
///   cells between could make the clue (args: line, clue);
/// - [sumOut]: with the shaded cells known, no set of digits for the cells
///   between makes the clue with this digit (args: line, clue, digits that can);
/// - [sumIn]: every such set uses the digit, so it can't be outside (args:
///   line, clue);
/// - [line]: no way to fill the line that makes its clue puts this value
///   here (args: line, clue);
/// - [failEmpty], [failNoPlace] (args: digit, line), [failShade] (args: line,
///   too few cells left to shade), [failLine] (args: line, clue).
enum BetweenRule {
  ruledOut,
  naked,
  hidden,
  shadePair,
  span,
  sumOut,
  sumIn,
  line,
  failEmpty,
  failNoPlace,
  failShade,
  failLine,
}

/// The digit sets (bit d = digit d) of [g] different digits from 1..k that
/// add up to [s].
class BetweenCombos {
  BetweenCombos._(this.k) {
    final top = k * (k + 1) ~/ 2;
    sets = [
      for (var g = 0; g <= k; g++) [for (var s = 0; s <= top; s++) <int>[]],
    ];
    for (var m = 0; m < 1 << k; m++) {
      var g = 0, s = 0;
      for (var d = 1; d <= k; d++) {
        if (m & (1 << (d - 1)) != 0) {
          g++;
          s += d;
        }
      }
      sets[g][s].add(m << 1);
    }
  }

  final int k;
  late final List<List<List<int>>> sets;

  static final _cache = <int, BetweenCombos>{};
  static BetweenCombos of(int k) => _cache.putIfAbsent(k, () => BetweenCombos._(k));

  List<int> list(int g, int s) => g < 0 || g > k || s < 0 || s >= sets[g].length ? const [] : sets[g][s];

  /// Bit g set for every gap g that can make [s].
  int gaps(int s) {
    var m = 0;
    for (var g = 0; g <= k; g++) {
      if (list(g, s).isNotEmpty) m |= 1 << g;
    }
    return m;
  }
}

/// Candidate logic for the puzzle: masks over the values (bit 0 shaded, bit
/// d digit d). Tier 1: singles (a digit once, two shaded cells per line),
/// where a clue lets the shaded cells lie ([BetweenRule.span]) and, once
/// they are known, which digits make the clue between them. Tier 2: + every
/// way to fill a clued line. Tier 3: + probing. All sound, so a full solve
/// proves the solution unique.
class BetweenSolver {
  BetweenSolver(this.n, this.clues, {this.disabled = const {}})
    : k = n - 2,
      full = (1 << (n - 1)) - 1,
      lines = betweenLines(n),
      combos = BetweenCombos.of(n - 2) {
    gaps = [for (final s in clues) s == null ? 0 : combos.gaps(s)];
  }

  final int n, k, full;
  final List<int?> clues;

  /// Rules left out (tests and lesson boards).
  final Set<BetweenRule> disabled;
  final List<List<int>> lines;
  final BetweenCombos combos;
  late final List<int> gaps;

  int get _digits => full & ~1;

  List<int> start(List<int?> givens) => [for (final g in givens) g == null ? full : 1 << g];

  static bool single(int m) => m != 0 && m & (m - 1) == 0;
  static int valueOf(int m) => m.bitLength - 1;

  int _steps = 0;

  bool _remove(
    List<int> c,
    int i,
    int mask,
    BetweenRule rule,
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
      if (single(c[i])) t.fact(i, valueOf(c[i]), BetweenRule.naked.index, premises: [i]);
      if (c[i] == 0) t.fail(BetweenRule.failEmpty.index, premises: [i], args: [i]);
    }
    return c[i] != 0;
  }

  bool _place(List<int> c, int i, int v, BetweenRule rule, ExplainTrace? t, List<int> premises, List<int> args) {
    if (c[i] == 1 << v) return true;
    if (c[i] & (1 << v) == 0) {
      t?.fail(BetweenRule.failEmpty.index, premises: [i], args: [i]);
      return false;
    }
    _steps++;
    c[i] = 1 << v;
    t?.fact(i, v, rule.index, premises: premises, args: args);
    return true;
  }

  /// A placed digit is ruled out in its lines, a line's two shaded cells
  /// rule shading out in the rest, a digit with one spot goes there, and two
  /// cells left that can be shaded are.
  bool _singles(List<int> c, ExplainTrace? t) {
    for (var i = 0; i < c.length; i++) {
      final m = c[i];
      if (m == 0) {
        t?.fail(BetweenRule.failEmpty.index, premises: [i], args: [i]);
        return false;
      }
      if (!single(m) || m == 1) continue;
      for (final line in [lines[i ~/ n], lines[n + i % n]]) {
        for (final j in line) {
          if (j == i) continue;
          if (!_remove(c, j, m, BetweenRule.ruledOut, t, premises: [i])) return false;
        }
      }
    }
    for (var u = 0; u < lines.length; u++) {
      final line = lines[u];
      final shaded = [
        for (final i in line)
          if (c[i] == 1) i,
      ];
      if (shaded.length >= 2) {
        for (final j in line) {
          if (shaded.contains(j)) continue;
          if (!_remove(c, j, 1, BetweenRule.ruledOut, t, premises: shaded.take(2).toList())) return false;
        }
      }
      final can = [
        for (final i in line)
          if (c[i] & 1 != 0) i,
      ];
      if (can.length < 2) {
        t?.fail(BetweenRule.failShade.index, premises: line, args: [u]);
        return false;
      }
      if (can.length == 2 && !disabled.contains(BetweenRule.shadePair)) {
        for (final i in can) {
          if (!_place(c, i, 0, BetweenRule.shadePair, t, line, [u])) return false;
        }
      }
      for (var d = 1; d <= k; d++) {
        final bit = 1 << d;
        var spots = 0, at = -1;
        for (final i in line) {
          if (c[i] & bit != 0) {
            spots++;
            at = i;
          }
        }
        if (spots == 0) {
          t?.fail(BetweenRule.failNoPlace.index, premises: line, args: [d, u]);
          return false;
        }
        if (spots == 1 && !disabled.contains(BetweenRule.hidden)) {
          if (!_place(c, at, d, BetweenRule.hidden, t, line, [u])) return false;
        }
      }
    }
    return true;
  }

  /// Positions in [line] that must be shaded.
  List<int> _forced(List<int> c, List<int> line) => [
    for (var x = 0; x < n; x++)
      if (c[line[x]] == 1) x,
  ];

  /// Whether positions [a] < [b] of [line] (line [u]) can be its two shaded
  /// cells.
  bool _pairOk(List<int> c, int u, List<int> line, List<int> forced, int a, int b) {
    if (c[line[a]] & 1 == 0 || c[line[b]] & 1 == 0) return false;
    if (gaps[u] & (1 << ((a - b).abs() - 1)) == 0) return false;
    for (final f in forced) {
      if (f != a && f != b) return false;
    }
    return true;
  }

  /// A cell can only be shaded with a partner the clue allows; once both
  /// shaded cells are known, the digits between them make the clue.
  bool _clueRules(List<int> c, ExplainTrace? t) {
    for (var u = 0; u < lines.length; u++) {
      final s = clues[u];
      if (s == null) continue;
      final line = lines[u];
      final forced = _forced(c, line);
      for (var x = 0; x < n; x++) {
        if (c[line[x]] & 1 == 0) continue;
        var ok = false;
        for (var y = 0; y < n && !ok; y++) {
          if (y != x && _pairOk(c, u, line, forced, min(x, y), max(x, y))) ok = true;
        }
        if (ok || disabled.contains(BetweenRule.span)) continue;
        if (!_remove(c, line[x], 1, BetweenRule.span, t, premises: line, args: [u, s])) return false;
      }
      final shaded = _forced(c, line);
      if (shaded.length != 2) continue;
      final a = shaded[0], b = shaded[1];
      final sets = combos.list(b - a - 1, s);
      if (sets.isEmpty) {
        t?.fail(BetweenRule.failLine.index, premises: line, args: [u, s]);
        return false;
      }
      var any = 0, every = _digits;
      for (final m in sets) {
        any |= m;
        every &= m;
      }
      for (var x = 0; x < n; x++) {
        if (x == a || x == b) continue;
        final inside = x > a && x < b;
        final gone = inside ? _digits & ~any : every;
        final rule = inside ? BetweenRule.sumOut : BetweenRule.sumIn;
        if (disabled.contains(rule)) continue;
        final args = inside ? [u, s, any] : [u, s];
        if (!_remove(c, line[x], gone, rule, t, premises: line, args: args)) return false;
      }
    }
    return true;
  }

  /// Whether the [cells] (masks) can take the digits of [set] one each.
  static bool _matches(List<int> cells, int set) {
    if (cells.isEmpty) return set == 0;
    var union = 0;
    for (final m in cells) {
      if (m & set == 0) return false;
      union |= m;
    }
    if (union & set != set) return false;
    final owner = <int, int>{};
    bool assign(int x, int seen) {
      for (var m = cells[x] & set & ~seen; m != 0; m &= m - 1) {
        final bit = m & -m;
        final o = owner[bit];
        if (o == null || assign(o, seen | bit)) {
          owner[bit] = x;
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

  /// The values each cell of clued line [u] can take in some way to place
  /// its shaded cells and a digit set between them that makes the clue (with
  /// the cells between and outside each able to take their digits).
  List<int> _fills(List<int> c, int u) {
    final s = clues[u]!, line = lines[u];
    final masks = [for (final i in line) c[i]];
    final forced = _forced(c, line);
    final union = List.filled(n, 0);
    for (var a = 0; a < n; a++) {
      for (var b = a + 1; b < n; b++) {
        if (!_pairOk(c, u, line, forced, a, b)) continue;
        final inside = masks.sublist(a + 1, b);
        final outside = [...masks.sublist(0, a), ...masks.sublist(b + 1)];
        for (final set in combos.list(b - a - 1, s)) {
          if (!_matches(inside, set) || !_matches(outside, _digits & ~set)) continue;
          union[a] |= 1;
          union[b] |= 1;
          for (var x = 0; x < n; x++) {
            if (x == a || x == b) continue;
            union[x] |= masks[x] & (x > a && x < b ? set : _digits & ~set);
          }
        }
      }
    }
    return union;
  }

  /// Applies the rules of [tier] (1 or 2) in place until nothing changes;
  /// false on a contradiction. With [t], every deduction is recorded.
  bool propagate(List<int> c, int tier, [ExplainTrace? t]) {
    final seen = List<List<int>?>.filled(lines.length, null);
    while (true) {
      final before = _steps;
      if (!_singles(c, t)) return false;
      if (_steps != before) continue;
      if (!_clueRules(c, t)) return false;
      if (_steps != before) continue;
      if (tier < 2) return true;
      for (var u = 0; u < lines.length; u++) {
        final s = clues[u];
        if (s == null) continue;
        final line = lines[u];
        final masks = [for (final i in line) c[i]];
        if (seen[u] case final last? when _same(last, masks)) continue;
        seen[u] = masks;
        final can = _fills(c, u);
        if (can.every((m) => m == 0)) {
          t?.fail(BetweenRule.failLine.index, premises: line, args: [u, s]);
          return false;
        }
        for (var x = 0; x < n; x++) {
          if (!_remove(c, line[x], ~can[x] & full, BetweenRule.line, t, premises: line, args: [u, s])) return false;
        }
        if (_steps != before) break;
      }
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

  /// The values of a solved [c].
  List<int> values(List<int> c) => [for (final m in c) valueOf(m)];
}
