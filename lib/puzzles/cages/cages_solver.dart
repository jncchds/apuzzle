import '../../core/explain.dart';
import '../../core/latin_square.dart';
import 'cages_model.dart';

/// The cage rules on top of [LatinRule], recorded with the id
/// `latinRuleCount + index`:
/// - [single]: a one-cell cage holds its target (args: cage);
/// - [combo]: no way to fill the cage puts these digits here (args: cage);
/// - [required]: every way to fill the cage puts these digits into its part
///   of a line, so the rest of the line can't have them (args: cage, line);
/// - [failCage]: the cage can't be filled at all (args: cage).
enum CagesRule {
  single,
  combo,
  required,
  failCage;

  int get id => latinRuleCount + index;
}

/// The ways to fill one cage: the digits each cell can take (all zero if
/// none), and per line part the digits every way puts there.
class _Fills {
  _Fills(this.can, this.required);
  final List<int> can;
  final List<int> required;
}

class _CageInfo {
  _CageInfo(this.cage, int n) {
    final k = cage.cells.length;
    for (var a = 0; a < k; a++) {
      final i = cage.cells[a];
      clash.add([
        for (var b = 0; b < a; b++)
          if (cage.cells[b] ~/ n == i ~/ n || cage.cells[b] % n == i % n) b,
      ]);
    }
    final byLine = <int, List<int>>{};
    for (var a = 0; a < k; a++) {
      final i = cage.cells[a];
      byLine.putIfAbsent(i ~/ n, () => []).add(a);
      byLine.putIfAbsent(n + i % n, () => []).add(a);
    }
    // A part that is the whole line has nothing left to rule out.
    for (final e in byLine.entries) {
      if (e.value.length < n) parts.add((e.key, e.value));
    }
  }

  final Cage cage;

  /// Per cell, the earlier cells of the cage in its row or column.
  final List<List<int>> clash = [];

  /// The cage's cells in each line it crosses: (line, positions in the cage).
  final List<(int, List<int>)> parts = [];

  final Map<int, _Fills> cache = {};
}

/// Candidate logic for cages. Cage eliminations carry the removed digits as
/// [Fact.value] (a mask). Tier 1: the Latin singles plus every way to
/// fill each cage ([CagesRule.combo]). Tier 2: + naked pairs and digits a
/// cage must put into one of its lines ([CagesRule.required]). Tier 3: +
/// probing. All sound, so a full solve proves the solution unique.
class CagesSolver {
  CagesSolver(this.n, List<Cage> cages) : sq = LatinSquare.of(n), _info = [for (final c in cages) _CageInfo(c, n)];

  final int n;
  final LatinSquare sq;
  final List<_CageInfo> _info;

  List<int> start(List<int?> givens) => sq.start(givens);

  _Fills _fills(_CageInfo x, List<int> masks) {
    var key = 0;
    for (final m in masks) {
      key = key * 256 + m;
    }
    return x.cache[key] ??= _enumerate(x, masks);
  }

  _Fills _enumerate(_CageInfo x, List<int> masks) {
    final k = masks.length, op = x.cage.op, target = x.cage.target;
    final can = List.filled(k, 0);
    final required = List.filled(x.parts.length, sq.full);
    final fill = List.filled(k, 0);
    // The smallest and largest numbers the cells from here on can add up to.
    final lowRest = List.filled(k + 1, 0), highRest = List.filled(k + 1, 0);
    for (var a = k - 1; a >= 0; a--) {
      if (masks[a] == 0) return _Fills(can, required);
      lowRest[a] = lowRest[a + 1] + (masks[a] & -masks[a]).bitLength;
      highRest[a] = highRest[a + 1] + masks[a].bitLength;
    }
    var any = false;
    void go(int at, int acc) {
      if (at == k) {
        if (op != CageOp.add && op != CageOp.mul && !cageHolds(op, target, [for (final d in fill) d + 1])) return;
        if ((op == CageOp.add || op == CageOp.mul) && acc != target) return;
        any = true;
        for (var a = 0; a < k; a++) {
          can[a] |= 1 << fill[a];
        }
        for (var p = 0; p < x.parts.length; p++) {
          var m = 0;
          for (final a in x.parts[p].$2) {
            m |= 1 << fill[a];
          }
          required[p] &= m;
        }
        return;
      }
      var m = masks[at];
      for (final b in x.clash[at]) {
        m &= ~(1 << fill[b]);
      }
      for (; m != 0; m &= m - 1) {
        final d = (m & -m).bitLength - 1, v = d + 1;
        var next = acc;
        if (op == CageOp.add) {
          next = acc + v;
          if (next + lowRest[at + 1] > target || next + highRest[at + 1] < target) continue;
        } else if (op == CageOp.mul) {
          next = acc * v;
          if (target % next != 0) continue;
        }
        fill[at] = d;
        go(at + 1, next);
      }
    }

    go(0, op == CageOp.mul ? 1 : 0);
    if (!any) required.fillRange(0, required.length, 0);
    return _Fills(can, required);
  }

  /// Applies the rules of [tier] (1 or 2) in place until nothing changes;
  /// false on a contradiction. With [t], every deduction is recorded.
  bool propagate(List<int> c, int tier, [ExplainTrace? t]) {
    for (var x = 0; x < _info.length; x++) {
      final cage = _info[x].cage;
      if (cage.op != CageOp.none) continue;
      final i = cage.cells.first, d = cage.target - 1;
      if (c[i] == 1 << d) continue;
      if (c[i] & (1 << d) == 0) {
        t?.fail(LatinRule.failEmpty.index, premises: [i], args: [i]);
        return false;
      }
      c[i] = 1 << d;
      t?.fact(i, d, CagesRule.single.id, args: [x]);
    }
    // The masks each cage was last filled with: unchanged cages are skipped.
    final seen = List<List<int>?>.filled(_info.length, null);
    while (true) {
      if (!sq.propagate(c, pairs: tier >= 2, t: t)) return false;
      var changed = false;
      for (var x = 0; x < _info.length; x++) {
        final cage = _info[x].cage, cells = cage.cells;
        if (cage.op == CageOp.none) continue;
        final masks = [for (final i in cells) c[i]];
        if (seen[x] case final last? when _same(last, masks)) continue;
        final f = _fills(_info[x], masks);
        if (f.can.every((m) => m == 0)) {
          t?.fail(CagesRule.failCage.id, premises: cells, args: [x]);
          return false;
        }
        for (var a = 0; a < cells.length; a++) {
          final gone = c[cells[a]] & ~f.can[a];
          if (gone == 0) continue;
          changed = true;
          sq.remove(c, cells[a], gone, CagesRule.combo.id, t: t, premises: cells, args: [x]);
        }
        if (tier >= 2) {
          for (var p = 0; p < _info[x].parts.length; p++) {
            final u = _info[x].parts[p].$1, must = f.required[p];
            if (must == 0) continue;
            for (final j in sq.lines[u]) {
              if (c[j] & must == 0 || cells.contains(j)) continue;
              changed = true;
              final ok = sq.remove(c, j, must, CagesRule.required.id, t: t, premises: cells, args: [x, u]);
              if (!ok) return false;
            }
          }
        }
        seen[x] = [for (final i in cells) c[i]];
      }
      if (!changed) return true;
    }
  }

  static bool _same(List<int> a, List<int> b) {
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  /// Solves [c] in place with the rules up to [tier] (3 probes); true if
  /// every cell is known.
  bool solve(List<int> c, int tier) {
    final ok = tier >= 3 ? sq.probe(c, (x) => propagate(x, 2)) : propagate(c, tier);
    return ok && sq.solved(c);
  }

  int countSolutions(List<int> c, {int limit = 2}) => sq.countSolutions(c, (x) => propagate(x, 2), limit: limit);
}
