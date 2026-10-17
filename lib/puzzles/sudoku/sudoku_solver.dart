import 'dart:math';

import '../../core/explain.dart';
import 'sudoku_model.dart';

/// What a traced [SudokuSolver.propagate] records ([Fact.rule]). Placements
/// carry the digit as [Fact.value], eliminations the removed digits' bits.
enum SudokuRule {
  naked,
  hidden,
  ruledOut,
  pointing,
  claiming,
  pair,
  failEmpty,
  failNoPlace,
  failClash,
  triple,
  hiddenPair,
  hiddenTriple,
  xWing,
  swordfish,
  xyWing,
  xyzWing,
  skyscraper,
  kite,
  emptyRectangle,
  finnedXWing,
  wWing,
}

/// The tier a deduction rule belongs to (1 singles, 2 locked candidates and
/// subsets, 3 fish and wings).
int sudokuRuleTier(SudokuRule r) => switch (r) {
  SudokuRule.pointing ||
  SudokuRule.claiming ||
  SudokuRule.pair ||
  SudokuRule.triple ||
  SudokuRule.hiddenPair ||
  SudokuRule.hiddenTriple => 2,
  SudokuRule.xWing ||
  SudokuRule.swordfish ||
  SudokuRule.xyWing ||
  SudokuRule.xyzWing ||
  SudokuRule.skyscraper ||
  SudokuRule.kite ||
  SudokuRule.emptyRectangle ||
  SudokuRule.finnedXWing ||
  SudokuRule.wWing => 3,
  _ => 1,
};

/// Combinations of [k] items of [items] (in order).
Iterable<List<int>> _combos(List<int> items, int k, [int from = 0]) sync* {
  if (k == 0) {
    yield const [];
    return;
  }
  for (var i = from; i <= items.length - k; i++) {
    for (final rest in _combos(items, k - 1, i + 1)) {
      yield [items[i], ...rest];
    }
  }
}

int _pop(int x) {
  var c = 0;
  while (x != 0) {
    x &= x - 1;
    c++;
  }
  return c;
}

int _low(int x) => (x & -x).bitLength - 1;

/// Bitmask candidate solver.
///
/// Tiers (for grading):
///  1. naked + hidden singles
///  2. + locked candidates (pointing / claiming), naked and hidden pairs
///     and triples
///  3. + X-Wing, Swordfish, XY-Wing, XYZ-Wing, Skyscraper, 2-String Kite,
///     Empty Rectangle, finned X-Wing, W-Wing
/// All tiers are sound, so a full logical solve implies uniqueness.
class SudokuSolver {
  SudokuSolver(this.n, {this.disabled = const {}}) : geo = SudokuGeometry.of(n), full = (1 << n) - 1;

  final int n;

  /// Rules left out (for tests and strategy boards).
  final Set<SudokuRule> disabled;
  final SudokuGeometry geo;
  final int full;

  /// Candidates for [g] (-1 = empty), or null on immediate contradiction.
  List<int>? _candidates(List<int> g) {
    final cand = List<int>.filled(g.length, 0);
    for (var i = 0; i < g.length; i++) {
      if (g[i] >= 0) continue;
      var m = full;
      for (final p in geo.peers[i]) {
        if (g[p] >= 0) m &= ~(1 << g[p]);
      }
      if (m == 0) return null;
      cand[i] = m;
    }
    return cand;
  }

  /// Places [d] in cell [i] and rules it out around; false on a contradiction.
  bool _assign(List<int> g, List<int> cand, int i, int d, [ExplainTrace? t]) {
    g[i] = d;
    cand[i] = 0;
    final bit = 1 << d;
    for (final p in geo.peers[i]) {
      if (g[p] == d) {
        t?.fail(SudokuRule.failClash.index, premises: [i, p], args: [i, p, d]);
        return false;
      }
      if (g[p] < 0 && cand[p] & bit != 0) {
        cand[p] &= ~bit;
        t?.fact(p, d, SudokuRule.ruledOut.index, premises: [i]);
        if (cand[p] == 0) {
          t?.fail(SudokuRule.failEmpty.index, premises: [p], args: [p]);
          return false;
        }
      }
    }
    return true;
  }

  /// Removes the [bits] from cell [j] by [rule]; false if nothing is left.
  bool _remove(List<int> cand, int j, int bits, ExplainTrace? t, SudokuRule rule, List<int> premises, List<int> args) {
    cand[j] &= ~bits;
    t?.fact(j, bits, rule.index, premises: premises, args: args);
    if (cand[j] != 0) return true;
    t?.fail(SudokuRule.failEmpty.index, premises: [j], args: [j]);
    return false;
  }

  /// Solves in place with deductions up to [tier]; true if fully solved.
  bool solveLogic(List<int> g, int tier) {
    final cand = _candidates(g);
    return cand != null && propagate(g, cand, tier) && !g.contains(-1);
  }

  /// Candidates for the filled-in cells of [g], or null on a clash.
  List<int>? candidates(List<int> g) => _candidates(g);

  /// Places the digit [d] in [i] (an assumption); false on a contradiction.
  bool assign(List<int> g, List<int> cand, int i, int d, [ExplainTrace? t]) => _assign(g, cand, i, d, t);

  /// Applies deductions up to [tier] until nothing changes; false on a
  /// contradiction. With [t], every deduction is recorded (see [SudokuRule]).
  bool propagate(List<int> g, List<int> cand, int tier, [ExplainTrace? t]) {
    while (true) {
      var progress = false;
      // naked singles
      for (var i = 0; i < g.length; i++) {
        if (g[i] < 0 && _pop(cand[i]) == 1) {
          final d = _low(cand[i]);
          t?.fact(i, d, SudokuRule.naked.index, premises: [i]);
          if (!_assign(g, cand, i, d, t)) return false;
          progress = true;
        }
      }
      // hidden singles
      for (var ui = 0; ui < geo.units.length; ui++) {
        final u = geo.units[ui];
        for (var d = 0; d < n; d++) {
          final bit = 1 << d;
          var where = -1, count = 0, placed = false;
          for (final i in u) {
            if (g[i] == d) {
              placed = true;
              break;
            }
            if (g[i] < 0 && cand[i] & bit != 0) {
              count++;
              where = i;
            }
          }
          if (placed) continue;
          if (count == 0) {
            t?.fail(SudokuRule.failNoPlace.index, premises: u, args: [d, ui]);
            return false;
          }
          if (count == 1) {
            t?.fact(where, d, SudokuRule.hidden.index, premises: u, args: [ui]);
            if (!_assign(g, cand, where, d, t)) return false;
            progress = true;
          }
        }
      }
      if (progress) continue;
      if (tier < 2 || !g.contains(-1)) return true;
      // The other rules, simplest first; after any progress, singles again.
      for (final rule in _rules) {
        if (sudokuRuleTier(rule) > tier || disabled.contains(rule)) continue;
        final r = switch (rule) {
          SudokuRule.pointing => _pointing(g, cand, t),
          SudokuRule.claiming => _claiming(g, cand, t),
          SudokuRule.pair => _nakedSubsets(g, cand, 2, t),
          SudokuRule.hiddenPair => _hiddenSubsets(g, cand, 2, t),
          SudokuRule.triple => _nakedSubsets(g, cand, 3, t),
          SudokuRule.hiddenTriple => _hiddenSubsets(g, cand, 3, t),
          SudokuRule.xWing => _fish(g, cand, 2, t),
          SudokuRule.swordfish => _fish(g, cand, 3, t),
          SudokuRule.xyWing => _wing(g, cand, false, t),
          SudokuRule.xyzWing => _wing(g, cand, true, t),
          SudokuRule.skyscraper => _twoLinks(g, cand, false, t),
          SudokuRule.kite => _twoLinks(g, cand, true, t),
          SudokuRule.emptyRectangle => _emptyRectangle(g, cand, t),
          SudokuRule.finnedXWing => _finnedXWing(g, cand, t),
          SudokuRule.wWing => _wWing(g, cand, t),
          _ => 0,
        };
        if (r < 0) return false;
        if (r > 0) {
          progress = true;
          break;
        }
      }
      if (!progress) return true;
    }
  }

  static const _rules = [
    SudokuRule.pointing,
    SudokuRule.claiming,
    SudokuRule.pair,
    SudokuRule.hiddenPair,
    SudokuRule.triple,
    SudokuRule.hiddenTriple,
    SudokuRule.xWing,
    SudokuRule.skyscraper,
    SudokuRule.kite,
    SudokuRule.xyWing,
    SudokuRule.wWing,
    SudokuRule.emptyRectangle,
    SudokuRule.finnedXWing,
    SudokuRule.swordfish,
    SudokuRule.xyzWing,
  ];

  // Each rule below returns 1 on progress, 0 on none, -1 on a contradiction.

  /// A box's spots for a digit all in one line: the rest of the line loses it.
  int _pointing(List<int> g, List<int> cand, ExplainTrace? t) {
    var progress = 0;
    for (var bu = 2 * n; bu < 3 * n; bu++) {
      final boxCells = geo.units[bu];
      for (var d = 0; d < n; d++) {
        final bit = 1 << d;
        final cells = [
          for (final i in boxCells)
            if (g[i] < 0 && cand[i] & bit != 0) i,
        ];
        if (cells.isEmpty) continue;
        for (final lineKind in const [0, 1]) {
          final line = geo.unitsOf[cells.first][lineKind];
          if (!cells.every((i) => geo.unitsOf[i][lineKind] == line)) continue;
          for (final j in geo.units[line]) {
            if (g[j] < 0 && !boxCells.contains(j) && cand[j] & bit != 0) {
              if (!_remove(cand, j, bit, t, SudokuRule.pointing, boxCells, [d, bu, line])) return -1;
              progress = 1;
            }
          }
        }
      }
    }
    return progress;
  }

  /// A line's spots for a digit all in one box: the rest of the box loses it.
  int _claiming(List<int> g, List<int> cand, ExplainTrace? t) {
    var progress = 0;
    for (var lu = 0; lu < 2 * n; lu++) {
      final lineCells = geo.units[lu];
      for (var d = 0; d < n; d++) {
        final bit = 1 << d;
        final cells = [
          for (final i in lineCells)
            if (g[i] < 0 && cand[i] & bit != 0) i,
        ];
        if (cells.isEmpty) continue;
        final b = geo.unitsOf[cells.first][2];
        if (!cells.every((i) => geo.unitsOf[i][2] == b)) continue;
        for (final j in geo.units[b]) {
          if (g[j] < 0 && !lineCells.contains(j) && cand[j] & bit != 0) {
            if (!_remove(cand, j, bit, t, SudokuRule.claiming, lineCells, [d, lu, b])) return -1;
            progress = 1;
          }
        }
      }
    }
    return progress;
  }

  /// [k] cells of a unit holding only [k] digits between them: the rest of
  /// the unit loses those digits. Args: unit, digit bits, then the cells.
  int _nakedSubsets(List<int> g, List<int> cand, int k, ExplainTrace? t) {
    final rule = k == 2 ? SudokuRule.pair : SudokuRule.triple;
    for (var ui = 0; ui < geo.units.length; ui++) {
      final u = geo.units[ui];
      final open = [
        for (final i in u)
          if (g[i] < 0) i,
      ];
      if (open.length <= k) continue;
      final small = [
        for (final i in open)
          if (_pop(cand[i]) <= k) i,
      ];
      for (final set in _combos(small, k)) {
        var mask = 0;
        for (final i in set) {
          mask |= cand[i];
        }
        if (_pop(mask) != k) continue;
        var progress = 0;
        for (final j in open) {
          if (set.contains(j) || cand[j] & mask == 0) continue;
          if (!_remove(cand, j, cand[j] & mask, t, rule, set, [ui, mask, ...set])) return -1;
          progress = 1;
        }
        if (progress > 0) return 1;
      }
    }
    return 0;
  }

  /// [k] digits of a unit that can only go in the same [k] cells: those cells
  /// lose every other digit. Args: unit, digit bits, then the cells.
  int _hiddenSubsets(List<int> g, List<int> cand, int k, ExplainTrace? t) {
    final rule = k == 2 ? SudokuRule.hiddenPair : SudokuRule.hiddenTriple;
    for (var ui = 0; ui < geo.units.length; ui++) {
      final u = geo.units[ui];
      final open = [
        for (final i in u)
          if (g[i] < 0) i,
      ];
      if (open.length <= k) continue;
      // Where each missing digit can go, as bits over [open].
      final spots = List<int>.filled(n, 0);
      for (var x = 0; x < open.length; x++) {
        for (var d = 0; d < n; d++) {
          if (cand[open[x]] & (1 << d) != 0) spots[d] |= 1 << x;
        }
      }
      final digits = [
        for (var d = 0; d < n; d++)
          if (spots[d] != 0 && _pop(spots[d]) <= k) d,
      ];
      for (final set in _combos(digits, k)) {
        var where = 0, mask = 0;
        for (final d in set) {
          where |= spots[d];
          mask |= 1 << d;
        }
        if (_pop(where) != k) continue;
        final cells = [
          for (var x = 0; x < open.length; x++)
            if (where & (1 << x) != 0) open[x],
        ];
        var progress = 0;
        for (final j in cells) {
          if (cand[j] & ~mask == 0) continue;
          if (!_remove(cand, j, cand[j] & ~mask, t, rule, u, [ui, mask, ...cells])) return -1;
          progress = 1;
        }
        if (progress > 0) return 1;
      }
    }
    return 0;
  }

  /// X-Wing ([k] 2) and Swordfish ([k] 3): a digit's spots in [k] rows lie in
  /// [k] columns, so the rest of those columns lose it (and the same with
  /// rows and columns swapped). Args: digit, 0 for rows as the base lines or
  /// 1 for columns, the [k] base lines, the [k] cover lines (line indexes).
  int _fish(List<int> g, List<int> cand, int k, ExplainTrace? t) {
    final rule = k == 2 ? SudokuRule.xWing : SudokuRule.swordfish;
    for (var d = 0; d < n; d++) {
      final bit = 1 << d;
      for (final base in const [0, 1]) {
        int at(int line, int x) => base == 0 ? line * n + x : x * n + line;
        // Spots of the digit per base line, as bits over the cross lines.
        final lines = <int>[];
        final spots = List<int>.filled(n, 0);
        for (var line = 0; line < n; line++) {
          for (var x = 0; x < n; x++) {
            final i = at(line, x);
            if (g[i] < 0 && cand[i] & bit != 0) spots[line] |= 1 << x;
          }
          final c = _pop(spots[line]);
          if (c >= 2 && c <= k) lines.add(line);
        }
        for (final set in _combos(lines, k)) {
          var cover = 0;
          for (final line in set) {
            cover |= spots[line];
          }
          if (_pop(cover) != k) continue;
          final covers = [
            for (var x = 0; x < n; x++)
              if (cover & (1 << x) != 0) x,
          ];
          final premises = [
            for (final line in set)
              for (final x in covers)
                if (spots[line] & (1 << x) != 0) at(line, x),
          ];
          var progress = 0;
          for (final x in covers) {
            for (var line = 0; line < n; line++) {
              final j = at(line, x);
              if (set.contains(line) || g[j] >= 0 || cand[j] & bit == 0) continue;
              if (!_remove(cand, j, bit, t, rule, premises, [d, base, ...set, ...covers])) return -1;
              progress = 1;
            }
          }
          if (progress > 0) return 1;
        }
      }
    }
    return 0;
  }

  /// XY-Wing: a pivot of {x, y} sees a cell of {x, z} and one of {y, z}; one
  /// of those two holds z, so a cell seeing both can't. XYZ-Wing ([xyz]): the
  /// pivot is {x, y, z}, and only cells that see all three lose z. Args:
  /// pivot, the two wings, z, then the other digit of each wing.
  int _wing(List<int> g, List<int> cand, bool xyz, ExplainTrace? t) {
    final rule = xyz ? SudokuRule.xyzWing : SudokuRule.xyWing;
    for (var p = 0; p < g.length; p++) {
      if (g[p] >= 0 || _pop(cand[p]) != (xyz ? 3 : 2)) continue;
      final pm = cand[p];
      final wings = [
        for (final q in geo.peers[p])
          if (g[q] < 0 && _pop(cand[q]) == 2 && _pop(cand[q] & pm) == (xyz ? 2 : 1)) q,
      ];
      for (var a = 0; a < wings.length; a++) {
        for (var b = a + 1; b < wings.length; b++) {
          final wa = wings[a], wb = wings[b];
          final ma = cand[wa], mb = cand[wb];
          if (ma == mb) continue;
          // Both wings share z with each other; in XY-Wing it's outside the
          // pivot, in XYZ-Wing it's the pivot's digit both wings hold.
          final z = ma & mb;
          if (_pop(z) != 1) continue;
          if (xyz ? (ma | mb) != pm : (z & pm != 0 || (ma | mb) & pm != pm)) continue;
          final seen = {...geo.peers[wa]}..retainAll(geo.peers[wb]);
          if (xyz) seen.retainAll(geo.peers[p]);
          var progress = 0;
          for (final j in seen) {
            if (j == p || g[j] >= 0 || cand[j] & z == 0) continue;
            final args = [p, wa, wb, _low(z), _low(ma & ~z), _low(mb & ~z)];
            if (!_remove(cand, j, z, t, rule, [p, wa, wb], args)) return -1;
            progress = 1;
          }
          if (progress > 0) return 1;
        }
      }
    }
    return 0;
  }

  int _row(int i) => i ~/ n;
  int _col(int i) => i % n;

  /// Whether cells [a] and [b] share a row, column or box.
  bool _sees(int a, int b) {
    final ua = geo.unitsOf[a], ub = geo.unitsOf[b];
    return a != b && (ua[0] == ub[0] || ua[1] == ub[1] || ua[2] == ub[2]);
  }

  /// Strong links of [d]: units where it has exactly two spots, as (unit,
  /// cell, cell). [lines] leaves out boxes.
  List<(int, int, int)> _links(List<int> g, List<int> cand, int d, {bool lines = false}) {
    final bit = 1 << d;
    final out = <(int, int, int)>[];
    for (var ui = 0; ui < (lines ? 2 * n : geo.units.length); ui++) {
      var a = -1, b = -1, count = 0;
      for (final i in geo.units[ui]) {
        if (g[i] == d) {
          count = 3;
          break;
        }
        if (g[i] < 0 && cand[i] & bit != 0) {
          if (count++ == 0) {
            a = i;
          } else {
            b = i;
          }
        }
      }
      if (count == 2) out.add((ui, a, b));
    }
    return out;
  }

  /// Removes [d] from the open cells that see both [a] and [b] (other than
  /// [skip]); 1 on progress, -1 on a contradiction.
  int _seenByBoth(
    List<int> g,
    List<int> cand,
    int d,
    int a,
    int b,
    List<int> skip,
    ExplainTrace? t,
    SudokuRule rule,
    List<int> premises,
    List<int> args,
  ) {
    final bit = 1 << d;
    var progress = 0;
    for (final j in geo.peers[a]) {
      if (g[j] >= 0 || cand[j] & bit == 0 || skip.contains(j) || !_sees(j, b)) continue;
      if (!_remove(cand, j, bit, t, rule, premises, args)) return -1;
      progress = 1;
    }
    return progress;
  }

  /// Skyscraper (two row links or two column links whose near ends share a
  /// column or row) and 2-String Kite ([kite]: a row link and a column link
  /// whose near ends share a box): the near ends can't both hold the digit,
  /// so one far end does, and cells seeing both far ends lose it. Args:
  /// digit, then each link as unit, near end, far end.
  int _twoLinks(List<int> g, List<int> cand, bool kite, ExplainTrace? t) {
    final rule = kite ? SudokuRule.kite : SudokuRule.skyscraper;
    for (var d = 0; d < n; d++) {
      final links = _links(g, cand, d, lines: true);
      for (var x = 0; x < links.length; x++) {
        for (var y = x + 1; y < links.length; y++) {
          final (u1, p1, p2) = links[x];
          final (u2, q1, q2) = links[y];
          if ((u1 < n) == (u2 < n) ? kite : !kite) continue;
          if (p1 == q1 || p1 == q2 || p2 == q1 || p2 == q2) continue;
          for (final (a1, a2) in [(p1, p2), (p2, p1)]) {
            for (final (b1, b2) in [(q1, q2), (q2, q1)]) {
              if (kite) {
                if (geo.unitsOf[a1][2] != geo.unitsOf[b1][2]) continue;
              } else {
                // The near ends share the cross line, the far ends don't
                // (else it's an X-Wing).
                final cross = u1 < n ? 1 : 0;
                if (geo.unitsOf[a1][cross] != geo.unitsOf[b1][cross]) continue;
                if (geo.unitsOf[a2][cross] == geo.unitsOf[b2][cross]) continue;
              }
              final r = _seenByBoth(g, cand, d, a2, b2, [a1, b1], t, rule, [a1, a2, b1, b2], [
                d,
                u1,
                a1,
                a2,
                u2,
                b1,
                b2,
              ]);
              if (r != 0) return r;
            }
          }
        }
      }
    }
    return 0;
  }

  /// Empty Rectangle: a box's spots for a digit lie in one of its rows and
  /// one of its columns. A line link with one end on that row (or column)
  /// outside the box rules the digit out where the link's other end meets
  /// the box's column (or row): there the far end would be empty, the near
  /// end hold the digit, and the box have no place left. Args: digit, box,
  /// row, column, link unit, near end, far end.
  int _emptyRectangle(List<int> g, List<int> cand, ExplainTrace? t) {
    for (var d = 0; d < n; d++) {
      final bit = 1 << d;
      final links = _links(g, cand, d, lines: true);
      if (links.isEmpty) continue;
      for (var bu = 2 * n; bu < 3 * n; bu++) {
        final spots = [
          for (final i in geo.units[bu])
            if (g[i] < 0 && cand[i] & bit != 0) i,
        ];
        if (spots.length < 2) continue;
        final rows = {for (final i in geo.units[bu]) _row(i)};
        final cols = {for (final i in geo.units[bu]) _col(i)};
        for (final r in rows) {
          for (final c in cols) {
            if (!spots.every((i) => _row(i) == r || _col(i) == c)) continue;
            // All on one line is pointing.
            if (spots.every((i) => _row(i) == r) || spots.every((i) => _col(i) == c)) continue;
            for (final (lu, e1, e2) in links) {
              for (final (a, b) in [(e1, e2), (e2, e1)]) {
                int target;
                if (lu >= n) {
                  // A column link: near end on row r, far end outside the
                  // box's rows; the target is on the far end's row, column c.
                  if (_row(a) != r || cols.contains(_col(a)) || rows.contains(_row(b))) continue;
                  target = _row(b) * n + c;
                } else {
                  if (_col(a) != c || rows.contains(_row(a)) || cols.contains(_col(b))) continue;
                  target = r * n + _col(b);
                }
                if (g[target] >= 0 || cand[target] & bit == 0) continue;
                if (!_remove(
                  cand,
                  target,
                  bit,
                  t,
                  SudokuRule.emptyRectangle,
                  [...spots, a, b],
                  [d, bu, r, c, lu, a, b],
                )) {
                  return -1;
                }
                return 1;
              }
            }
          }
        }
      }
    }
    return 0;
  }

  /// Finned X-Wing (sashimi too): two rows hold a digit only in two columns,
  /// but for a few extra spots (fins) in one row, all in one box. Either a
  /// fin holds it or the rows make an X-Wing, so the cells of the fins' box
  /// in those columns (outside the rows) lose it. Rows and columns may swap.
  /// Args: digit, 0 for rows or 1 for columns, the clean line, the finned
  /// line, the two cover lines, the fins' box, then the fins.
  int _finnedXWing(List<int> g, List<int> cand, ExplainTrace? t) {
    for (var d = 0; d < n; d++) {
      final bit = 1 << d;
      for (final base in const [0, 1]) {
        int at(int line, int x) => base == 0 ? line * n + x : x * n + line;
        final spots = List<int>.filled(n, 0);
        for (var line = 0; line < n; line++) {
          for (var x = 0; x < n; x++) {
            final i = at(line, x);
            if (g[i] < 0 && cand[i] & bit != 0) spots[line] |= 1 << x;
          }
        }
        for (var clean = 0; clean < n; clean++) {
          final cover = spots[clean];
          if (_pop(cover) != 2) continue;
          for (var finned = 0; finned < n; finned++) {
            if (finned == clean || spots[finned] & cover == 0) continue;
            final finBits = spots[finned] & ~cover;
            if (finBits == 0) continue;
            final fins = [
              for (var x = 0; x < n; x++)
                if (finBits & (1 << x) != 0) at(finned, x),
            ];
            final box = geo.unitsOf[fins.first][2];
            if (fins.any((i) => geo.unitsOf[i][2] != box)) continue;
            final covers = [
              for (var x = 0; x < n; x++)
                if (cover & (1 << x) != 0) x,
            ];
            var progress = 0;
            for (final x in covers) {
              for (var line = 0; line < n; line++) {
                final j = at(line, x);
                if (line == clean || line == finned || geo.unitsOf[j][2] != box) continue;
                if (g[j] >= 0 || cand[j] & bit == 0) continue;
                final premises = [
                  for (final l in [clean, finned])
                    for (var y = 0; y < n; y++)
                      if (spots[l] & (1 << y) != 0) at(l, y),
                ];
                final args = [d, base, clean, finned, covers[0], covers[1], box, ...fins];
                if (!_remove(cand, j, bit, t, SudokuRule.finnedXWing, premises, args)) return -1;
                progress = 1;
              }
            }
            if (progress > 0) return 1;
          }
        }
      }
    }
    return 0;
  }

  /// W-Wing: two cells that can only be x or y, not seeing each other, and a
  /// link of x whose ends see one cell each. Both cells being x would leave
  /// the link empty, so one of them is y, and cells seeing both lose y.
  /// Args: the two cells, x, y, link unit, the end by the first cell, the
  /// end by the second.
  int _wWing(List<int> g, List<int> cand, ExplainTrace? t) {
    final pairs = [
      for (var i = 0; i < g.length; i++)
        if (g[i] < 0 && _pop(cand[i]) == 2) i,
    ];
    if (pairs.length < 2) return 0;
    final links = [for (var d = 0; d < n; d++) _links(g, cand, d)];
    for (var x = 0; x < pairs.length; x++) {
      for (var y = x + 1; y < pairs.length; y++) {
        final p = pairs[x], q = pairs[y];
        if (cand[p] != cand[q] || _sees(p, q)) continue;
        for (final dx in [_low(cand[p]), _low(cand[p] & (cand[p] - 1))]) {
          final dy = _low(cand[p] & ~(1 << dx));
          for (final (u, e1, e2) in links[dx]) {
            if (e1 == p || e1 == q || e2 == p || e2 == q) continue;
            final (a, b) = _sees(e1, p) && _sees(e2, q)
                ? (e1, e2)
                : _sees(e2, p) && _sees(e1, q)
                ? (e2, e1)
                : (-1, -1);
            if (a < 0) continue;
            final r = _seenByBoth(
              g,
              cand,
              dy,
              p,
              q,
              const [],
              t,
              SudokuRule.wWing,
              [p, q, a, b],
              [p, q, dx, dy, u, a, b],
            );
            if (r != 0) return r;
          }
        }
      }
    }
    return 0;
  }

  /// Number of solutions up to [limit].
  int countSolutions(List<int> g, {int limit = 2}) {
    final cand = _candidates(g);
    if (cand == null) return 0;
    return _count(List.of(g), cand, limit);
  }

  int _count(List<int> g, List<int> cand, int limit) {
    var best = -1, bestPop = 99;
    for (var i = 0; i < g.length; i++) {
      if (g[i] >= 0) continue;
      final p = _pop(cand[i]);
      if (p == 0) return 0;
      if (p < bestPop) {
        bestPop = p;
        best = i;
        if (p == 1) break;
      }
    }
    if (best < 0) return 1;
    var total = 0;
    var m = cand[best];
    while (m != 0 && total < limit) {
      final d = _low(m);
      m &= m - 1;
      final g2 = List.of(g), c2 = List.of(cand);
      if (_assign(g2, c2, best, d)) total += _count(g2, c2, limit - total);
    }
    return total;
  }

  /// Random complete grid.
  List<int> randomSolution(Random rng) {
    final g = List.filled(n * n, -1);
    final cand = _candidates(g)!;
    return _fill(g, cand, rng)!;
  }

  List<int>? _fill(List<int> g, List<int> cand, Random rng) {
    var best = -1, bestPop = 99;
    for (var i = 0; i < g.length; i++) {
      if (g[i] >= 0) continue;
      final p = _pop(cand[i]);
      if (p == 0) return null;
      if (p < bestPop) {
        bestPop = p;
        best = i;
      }
    }
    if (best < 0) return g;
    final digits = [
      for (var d = 0; d < n; d++)
        if (cand[best] & (1 << d) != 0) d,
    ]..shuffle(rng);
    for (final d in digits) {
      final g2 = List.of(g), c2 = List.of(cand);
      if (!_assign(g2, c2, best, d)) continue;
      final r = _fill(g2, c2, rng);
      if (r != null) return r;
    }
    return null;
  }
}
