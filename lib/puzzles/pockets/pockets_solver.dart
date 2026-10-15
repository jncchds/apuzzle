import '../../core/explain.dart';
import '../sudoku/sudoku_model.dart';
import '../totals/totals_solver.dart';
import 'pockets_model.dart';

/// What a traced [PocketsSolver.propagate] records ([Fact.rule]).
/// Eliminations carry the removed digits as [Fact.value] (a mask),
/// placements the digit.
/// - [ruledOut]: a placed digit can't come again in its row, column, box or
///   pocket;
/// - [naked]: the last digit left in a cell;
/// - [hidden]: the only spot left for a digit in a unit (args: unit);
/// - [combo]: the digit sets that make an area's sum have no such digit
///   (args: area, union of the sets' open digits);
/// - [must]: every such set holds the digit and one cell of the area can
///   take it (args: area);
/// - [pointing], [claiming], [pair]: as in Sudoku (args: digit, box, line /
///   digit, line, box / unit, cell, cell, mask);
/// - [fill]: no way to fill the area with different digits making its sum
///   puts these digits here (args: area);
/// - [line]: every set of a pocket holds the digit, and its spots in the
///   pocket all lie in one unit, so the rest of that unit can't take it
///   (args: area, digit, unit);
/// - [failEmpty]: a cell has no digit left (args: cell);
/// - [failNoPlace]: a unit has no spot for a digit (args: digit, unit);
/// - [failSum]: an area can't make its sum (args: area).
///
/// An area is a pocket, or a group of cells whose sum follows from a whole
/// row, column, box, band or stack ([PocketsArea]).
enum PocketsRule {
  ruledOut,
  naked,
  hidden,
  combo,
  must,
  pointing,
  claiming,
  pair,
  fill,
  line,
  failEmpty,
  failNoPlace,
  failSum,
}

bool _single(int m) => m != 0 && m & (m - 1) == 0;

int _count(int m) {
  var k = 0;
  for (; m != 0; m &= m - 1) {
    k++;
  }
  return k;
}

/// Cells with different digits and a known sum: a pocket ([pocket] ≥ 0), or
/// cells whose sum a [region] (a row, column, box, band or stack, which adds
/// up to [total]) gives away: the cells it keeps once the pockets wholly
/// inside it (adding up to [other]) are taken out, or, [outside], the cells
/// beyond it of the pockets reaching into it (adding up to [other]).
class PocketsArea {
  const PocketsArea(
    this.cells,
    this.sum, {
    this.pocket = -1,
    this.region = -1,
    this.outside = false,
    this.total = 0,
    this.other = 0,
  });

  final List<int> cells;
  final int sum;
  final int pocket;
  final int region;
  final bool outside;
  final int total;
  final int other;
}

/// The regions whose digits add up to a known total: rows (0..n-1), columns
/// (n..2n-1), boxes (2n..3n-1), then bands of box rows and stacks of box
/// columns. Every region is a rectangle, cells ascending.
List<List<int>> pocketsRegions(int n) => _regions[n] ??= () {
  final geo = SudokuGeometry.of(n);
  final (br, bc) = geo.box;
  return [
    ...geo.units,
    for (var r0 = 0; r0 < n; r0 += br) [for (var i = r0 * n; i < (r0 + br) * n; i++) i],
    for (var c0 = 0; c0 < n; c0 += bc)
      [
        for (var r = 0; r < n; r++)
          for (var c = c0; c < c0 + bc; c++) r * n + c,
      ],
  ];
}();
final _regions = <int, List<List<int>>>{};

/// Candidate logic on a mask per cell (bit d: digit d + 1). Tier 1: placed
/// digits, last digits, the only spot for a digit in a row, column or box,
/// and the digit sets that make each pocket's sum ([PocketsRule.combo],
/// [PocketsRule.must]). Tier 2: + locked candidates and naked pairs, every
/// way to fill a pocket, digits a pocket must put into one unit, and the
/// sums whole rows, columns, boxes, bands and stacks give away. Tier 3: +
/// probing. All sound, so a full solve proves the solution unique.
class PocketsSolver {
  PocketsSolver(this.p) : n = p.n, geo = SudokuGeometry.of(p.n), full = (1 << p.n) - 1 {
    peers = [
      for (var i = 0; i < n * n; i++)
        {
          ...geo.peers[i],
          for (final j in p.pockets[p.pocketOf[i]].cells)
            if (j != i) j,
        }.toList(),
    ];
    _areas();
  }

  final PocketsPuzzle p;
  final int n;
  final SudokuGeometry geo;
  final int full;

  /// Row, column, box and pocket mates of every cell.
  late final List<List<int>> peers;

  /// The pockets (index = pocket), then the areas the regions give away.
  final List<PocketsArea> areas = [];

  /// Most cells of an area a region gives away.
  static const _maxArea = 5;

  void _areas() {
    for (var x = 0; x < p.pockets.length; x++) {
      areas.add(PocketsArea(p.pockets[x].cells, p.pockets[x].sum, pocket: x));
    }
    final known = {for (final a in areas) a.cells.join(',')};
    bool together(List<int> cells) => cells.length == 1 || geo.units.any((u) => cells.every(u.contains));
    void add(List<int> cells, int sum, int region, bool outside, int total, int other) {
      cells.sort();
      if (cells.isEmpty || cells.length > _maxArea || !together(cells) || !known.add(cells.join(','))) return;
      areas.add(PocketsArea(cells, sum, region: region, outside: outside, total: total, other: other));
    }

    final regions = pocketsRegions(n);
    for (var r = 0; r < regions.length; r++) {
      final cells = regions[r].toSet();
      final total = cells.length ~/ n * n * (n + 1) ~/ 2;
      final rest = Set.of(cells), beyond = <int>[];
      var inside = 0, reach = 0;
      for (var x = 0; x < p.pockets.length; x++) {
        final pocket = p.pockets[x];
        if (!pocket.cells.any(cells.contains)) continue;
        reach += pocket.sum;
        if (pocket.cells.every(cells.contains)) {
          inside += pocket.sum;
          rest.removeAll(pocket.cells);
        } else {
          beyond.addAll(pocket.cells.where((i) => !cells.contains(i)));
        }
      }
      add(rest.toList(), total - inside, r, false, total, inside);
      add(beyond, reach - total, r, true, total, reach);
    }
  }

  /// Every cell open, but for [givens] (the puzzle's own by default).
  List<int> start([List<int?>? givens]) => [for (final g in givens ?? p.givens) g == null ? full : 1 << g];

  bool solved(List<int> c) => c.every(_single);

  /// Cells [c] hasn't settled.
  int open(List<int> c) => c.where((m) => !_single(m)).length;

  /// The digits (0..n-1) of a solved [c].
  List<int> values(List<int> c) => [for (final m in c) m.bitLength - 1];

  /// Rules out [mask] in cell [i]; a cell left with one digit records
  /// [PocketsRule.naked]. False if nothing is left.
  bool _remove(List<int> c, int i, int mask, PocketsRule rule, ExplainTrace? t, List<int> premises, List<int> args) {
    final gone = c[i] & mask;
    if (gone == 0) return true;
    c[i] &= ~mask;
    if (t != null) {
      t.fact(i, gone, rule.index, premises: premises, args: args);
      if (_single(c[i])) t.fact(i, c[i].bitLength - 1, PocketsRule.naked.index, premises: [i]);
      if (c[i] == 0) t.fail(PocketsRule.failEmpty.index, premises: [i], args: [i]);
    }
    return c[i] != 0;
  }

  /// Places [d] in cell [i] by [rule].
  void _place(List<int> c, int i, int d, PocketsRule rule, ExplainTrace? t, List<int> premises, List<int> args) {
    c[i] = 1 << d;
    t?.fact(i, d, rule.index, premises: premises, args: args);
  }

  /// Every way of [sum] in [k] different digits 1..n, as masks.
  List<int> _combos(int k, int sum) => totalsCombos(k, sum).where((m) => m <= full).toList();
  final _comboCache = <int, List<int>>{};

  /// The digit sets that can still make area [x]'s sum, as their digits not
  /// yet placed (none on a contradiction).
  List<int> _sets(List<int> c, int x) {
    final area = areas[x];
    var placed = 0, union = 0, singles = 0;
    final open = <int>[];
    for (final i in area.cells) {
      if (_single(c[i])) {
        if (placed & c[i] != 0) return const [];
        placed |= c[i];
        singles++;
      } else {
        open.add(c[i]);
        union |= c[i];
      }
    }
    final sets = <int>[];
    final combos = _comboCache[area.cells.length * 64 + area.sum] ??= _combos(area.cells.length, area.sum);
    for (final combo in combos) {
      if (combo & placed != placed) continue;
      final rest = combo & ~placed;
      if (rest & ~union != 0 || open.any((m) => m & rest == 0)) continue;
      sets.add(rest);
    }
    assert(singles + open.length == area.cells.length);
    return sets;
  }

  /// Every way to fill the open cells of area [x] with the digits of one of
  /// [sets]: the digits each open cell can take (in the area's order).
  List<int> _fills(List<int> c, int x, List<int> sets) {
    final open = [
      for (final i in areas[x].cells)
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

  /// Placed digits ruled out among their peers, until nothing changes.
  bool _placed(List<int> c, List<int> done, ExplainTrace? t) {
    var changed = true;
    while (changed) {
      changed = false;
      for (var i = 0; i < c.length; i++) {
        final m = c[i];
        if (!_single(m) || done[i] == m) continue;
        done[i] = m;
        changed = true;
        for (final j in peers[i]) {
          if (c[j] & m == 0) continue;
          if (_single(c[j])) {
            t?.fail(PocketsRule.failEmpty.index, premises: [j], args: [j]);
            return false;
          }
          if (!_remove(c, j, m, PocketsRule.ruledOut, t, [i], const [])) return false;
        }
      }
    }
    return true;
  }

  /// Hidden singles in rows, columns and boxes; null on a contradiction,
  /// else whether something was placed.
  bool? _hidden(List<int> c, ExplainTrace? t) {
    var changed = false;
    for (var u = 0; u < geo.units.length; u++) {
      final cells = geo.units[u];
      for (var d = 0; d < n; d++) {
        final bit = 1 << d;
        var spots = 0, at = -1;
        for (final i in cells) {
          if (c[i] & bit != 0) {
            spots++;
            at = i;
          }
        }
        if (spots == 0) {
          t?.fail(PocketsRule.failNoPlace.index, premises: cells, args: [d, u]);
          return null;
        }
        if (spots == 1 && c[at] != bit) {
          _place(c, at, d, PocketsRule.hidden, t, cells, [u]);
          changed = true;
        }
      }
    }
    return changed;
  }

  /// The digit-set rules on area [x]; null on a contradiction, else whether
  /// something changed.
  bool? _setRules(List<int> c, int x, ExplainTrace? t) {
    final cells = areas[x].cells;
    final sets = _sets(c, x);
    if (sets.isEmpty) {
      t?.fail(PocketsRule.failSum.index, premises: cells, args: [x]);
      return null;
    }
    var union = 0, all = full;
    for (final s in sets) {
      union |= s;
      all &= s;
    }
    var changed = false;
    for (final i in cells) {
      if (_single(c[i]) || c[i] & ~union == 0) continue;
      changed = true;
      if (!_remove(c, i, ~union & full, PocketsRule.combo, t, cells, [x, union])) return null;
    }
    if (changed) return true;
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
      _place(c, at, d, PocketsRule.must, t, cells, [x]);
      return true;
    }
    return false;
  }

  /// Applies the rules of [tier] (1 or 2) in place until nothing changes;
  /// false on a contradiction. With [t], every deduction is recorded.
  bool propagate(List<int> c, int tier, [ExplainTrace? t]) {
    final done = List.filled(c.length, 0);
    // The masks each area was last looked at with, per rule level: unchanged
    // areas are skipped.
    final seen = [for (var k = 0; k < 3; k++) List<List<int>?>.filled(areas.length, null)];
    bool fresh(int level, int x) {
      final cells = areas[x].cells, last = seen[level][x];
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
      if (!_placed(c, done, t)) return false;
      final hidden = _hidden(c, t);
      if (hidden == null) return false;
      if (hidden) continue;
      var changed = false;
      for (var x = 0; x < p.pockets.length && !changed; x++) {
        if (!fresh(0, x)) continue;
        final r = _setRules(c, x, t);
        if (r == null) return false;
        changed = r;
      }
      if (changed) continue;
      if (tier < 2 || solved(c)) return true;

      for (var x = p.pockets.length; x < areas.length && !changed; x++) {
        if (!fresh(0, x)) continue;
        final r = _setRules(c, x, t);
        if (r == null) return false;
        changed = r;
      }
      if (changed) continue;
      final locked = _locked(c, t);
      if (locked == null) return false;
      if (locked) continue;
      for (var x = 0; x < areas.length && !changed; x++) {
        if (!fresh(1, x)) continue;
        final cells = areas[x].cells;
        final can = _fills(c, x, _sets(c, x));
        if (can.isEmpty) continue;
        if (can.every((m) => m == 0)) {
          t?.fail(PocketsRule.failSum.index, premises: cells, args: [x]);
          return false;
        }
        var a = 0;
        for (final i in cells) {
          if (_single(c[i])) continue;
          final gone = c[i] & ~can[a++];
          if (gone == 0) continue;
          changed = true;
          if (!_remove(c, i, gone, PocketsRule.fill, t, cells, [x])) return false;
        }
      }
      if (changed) continue;
      for (var x = 0; x < p.pockets.length && !changed; x++) {
        if (!fresh(2, x)) continue;
        final r = _line(c, x, t);
        if (r == null) return false;
        changed = r;
      }
      if (!changed) return true;
    }
  }

  /// Digits every set of pocket [x] holds whose spots in it share a unit:
  /// ruled out in the rest of that unit.
  bool? _line(List<int> c, int x, ExplainTrace? t) {
    final cells = areas[x].cells;
    final sets = _sets(c, x);
    if (sets.isEmpty) return false;
    var all = full;
    for (final s in sets) {
      all &= s;
    }
    var changed = false;
    for (final d in totalsDigits(all)) {
      final bit = 1 << d;
      final spots = [
        for (final i in cells)
          if (c[i] & bit != 0) i,
      ];
      if (spots.length < 2) continue;
      for (final u in geo.unitsOf[spots.first]) {
        if (!spots.every(geo.units[u].contains)) continue;
        for (final j in geo.units[u]) {
          if (c[j] & bit == 0 || cells.contains(j)) continue;
          changed = true;
          if (!_remove(c, j, bit, PocketsRule.line, t, cells, [x, d, u])) return null;
        }
      }
    }
    return changed;
  }

  /// Locked candidates (pointing and claiming) and naked pairs; null on a
  /// contradiction, else whether something changed.
  bool? _locked(List<int> c, ExplainTrace? t) {
    var changed = false;
    for (var bu = 2 * n; bu < 3 * n; bu++) {
      final box = geo.units[bu];
      for (var d = 0; d < n; d++) {
        final bit = 1 << d;
        final spots = [
          for (final i in box)
            if (c[i] & bit != 0) i,
        ];
        if (spots.length < 2) continue;
        for (final kind in const [0, 1]) {
          final line = geo.unitsOf[spots.first][kind];
          if (!spots.every((i) => geo.unitsOf[i][kind] == line)) continue;
          for (final j in geo.units[line]) {
            if (c[j] & bit == 0 || box.contains(j)) continue;
            changed = true;
            if (!_remove(c, j, bit, PocketsRule.pointing, t, box, [d, bu, line])) return null;
          }
        }
      }
    }
    if (changed) return true;
    for (var lu = 0; lu < 2 * n; lu++) {
      final line = geo.units[lu];
      for (var d = 0; d < n; d++) {
        final bit = 1 << d;
        final spots = [
          for (final i in line)
            if (c[i] & bit != 0) i,
        ];
        if (spots.length < 2) continue;
        final b = geo.unitsOf[spots.first][2];
        if (!spots.every((i) => geo.unitsOf[i][2] == b)) continue;
        for (final j in geo.units[b]) {
          if (c[j] & bit == 0 || line.contains(j)) continue;
          changed = true;
          if (!_remove(c, j, bit, PocketsRule.claiming, t, line, [d, lu, b])) return null;
        }
      }
    }
    if (changed) return true;
    for (var u = 0; u < geo.units.length; u++) {
      final cells = geo.units[u];
      for (var a = 0; a < cells.length; a++) {
        final ia = cells[a];
        if (_count(c[ia]) != 2) continue;
        for (var b = a + 1; b < cells.length; b++) {
          final ib = cells[b];
          if (c[ib] != c[ia]) continue;
          for (final j in cells) {
            if (j == ia || j == ib || c[j] & c[ia] == 0) continue;
            changed = true;
            if (!_remove(c, j, c[ia], PocketsRule.pair, t, [ia, ib], [u, ia, ib, c[ia]])) return null;
          }
        }
      }
    }
    return changed;
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
    var best = -1, fewest = 99;
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
