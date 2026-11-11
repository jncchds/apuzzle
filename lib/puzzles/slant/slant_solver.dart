import '../../core/explain.dart';
import 'slant_model.dart';

/// What a traced [SlantSolver.propagate] records ([Fact.rule]); every fact
/// puts a diagonal ([Fact.value]) into a cell ([Fact.slot]).
///
/// Args: [done], [need] and [failClue] the corner; [loop] the cells that
/// would close the loop; [pair] and [failPair] the two corners; [failLoop]
/// and [failStuck] the cell.
enum SlantRule { done, need, loop, pair, failClue, failLoop, failStuck, failPair }

/// Solver for "a diagonal in every cell, numbers count the diagonals
/// touching their corner, no closed loop", on a flat list of cells (-1
/// open, else [slBack] or [slFwd]).
///
/// Tiers:
///  1. a number with all its diagonals turns its other cells away, a number
///     that needs every cell it has left takes them all, and a diagonal
///     that would close a loop goes the other way;
///  2. + every way to meet two neighbouring numbers together (the cells
///     between them touch exactly one of the two, or both or neither);
///  3. + probing (assume a diagonal, run tier 2, reject on a contradiction).
class SlantSolver {
  SlantSolver(this.p, {this.disabled = const {}}) {
    final g = p.geo;
    for (var k = 0; k < g.corners; k++) {
      if (p.clues[k] >= 0) clued.add(k);
    }
    // Numbered corners sharing a cell: right, down, and both diagonals down.
    for (final a in clued) {
      final r = a ~/ g.w, c = a % g.w;
      for (final (dr, dc) in const [(0, 1), (1, 0), (1, 1), (1, -1)]) {
        final rr = r + dr, cc = c + dc;
        if (rr > g.rows || cc < 0 || cc >= g.w) continue;
        final b = rr * g.w + cc;
        if (p.clues[b] < 0) continue;
        pairs.add((a, b));
        pairCells.add({for (final (i, _) in g.cornerCells[a]) i, for (final (i, _) in g.cornerCells[b]) i}.toList());
      }
    }
  }

  final SlantPuzzle p;

  /// Rules left out, for tests and lesson checks ([SlantRule.pair]).
  final Set<SlantRule> disabled;

  /// Corners with a number.
  final List<int> clued = [];

  /// Numbered corners next to each other (sharing a cell), and the cells
  /// around either.
  final List<(int, int)> pairs = [];
  final List<List<int>> pairCells = [];

  /// The givens, the rest open.
  List<int> start() => [for (var i = 0; i < p.rows * p.cols; i++) p.givens.contains(i) ? p.solution[i] : -1];

  /// The diagonals if logic up to [tier] solves the board, else null.
  List<int>? solveLogic(int tier) {
    final v = start();
    if (!propagate(v, tier)) return null;
    return v.every((x) => x >= 0) ? v : null;
  }

  /// Open cells logic up to [tier] leaves (0 = solved).
  int slack(int tier) {
    final v = start();
    if (!propagate(v, tier)) return 1 << 28;
    return v.where((x) => x < 0).length;
  }

  /// Hardest tier needed (1..3), or 4 when guessing is required.
  int grade() {
    for (var t = 1; t <= 3; t++) {
      if (solveLogic(t) != null) return t;
    }
    return 4;
  }

  List<int> _cellsOf(int corner) => [for (final (i, _) in p.geo.cornerCells[corner]) i];

  /// Logic up to [tier] (1..3) in place; false on a contradiction. With [t],
  /// every deduction is recorded (see [SlantRule]).
  bool propagate(List<int> v, int tier, [ExplainTrace? t]) {
    final g = p.geo;
    final forest = SlantForest(g.corners);
    for (var i = 0; i < g.cells; i++) {
      if (v[i] < 0) continue;
      final (a, b) = g.ends(i, v[i]);
      if (!forest.join(a, b)) {
        t?.fail(SlantRule.failLoop.index, premises: [i, ...slantPath(g, v, a, b, i)], args: [i]);
        return false;
      }
    }

    // Puts [val] into open cell [i]; false if it closes a loop.
    bool set(int i, int val, SlantRule rule, List<int> premises, List<int> args) {
      v[i] = val;
      t?.fact(i, val, rule.index, premises: premises, args: args);
      final (a, b) = g.ends(i, val);
      if (forest.join(a, b)) return true;
      t?.fail(SlantRule.failLoop.index, premises: [i, ...slantPath(g, v, a, b, i)], args: [i]);
      return false;
    }

    while (true) {
      var progress = false;
      // Numbers: done, or needing every open cell.
      for (final k in clued) {
        final want = p.clues[k];
        var touch = 0, open = 0;
        for (final (i, tv) in g.cornerCells[k]) {
          if (v[i] < 0) {
            open++;
          } else if (v[i] == tv) {
            touch++;
          }
        }
        if (touch > want || touch + open < want) {
          t?.fail(SlantRule.failClue.index, premises: _cellsOf(k), args: [k]);
          return false;
        }
        if (open == 0 || (touch < want && touch + open > want)) continue;
        final rule = touch == want ? SlantRule.done : SlantRule.need;
        final known = t == null
            ? const <int>[]
            : [
                for (final (i, _) in g.cornerCells[k])
                  if (v[i] >= 0) i,
              ];
        for (final (i, tv) in g.cornerCells[k]) {
          if (v[i] >= 0) continue;
          if (!set(i, rule == SlantRule.done ? 1 - tv : tv, rule, known, [k])) return false;
        }
        progress = true;
      }
      if (progress) continue;

      // Loops: a diagonal joining two joined corners goes the other way.
      for (var i = 0; i < g.cells; i++) {
        if (v[i] >= 0) continue;
        final (a0, b0) = g.ends(i, slBack);
        final (a1, b1) = g.ends(i, slFwd);
        final c0 = forest.joined(a0, b0), c1 = forest.joined(a1, b1);
        if (!c0 && !c1) continue;
        if (c0 && c1) {
          t?.fail(
            SlantRule.failStuck.index,
            premises: [...slantPath(g, v, a0, b0), ...slantPath(g, v, a1, b1)],
            args: [i],
          );
          return false;
        }
        final path = t == null ? const <int>[] : (c0 ? slantPath(g, v, a0, b0) : slantPath(g, v, a1, b1));
        if (!set(i, c0 ? slFwd : slBack, SlantRule.loop, path, path)) return false;
        progress = true;
      }
      if (progress) continue;
      if (tier < 2) return true;

      // Two neighbouring numbers together.
      for (var q = 0; q < pairs.length && !disabled.contains(SlantRule.pair); q++) {
        final r = _pair(v, q, set, t);
        if (r == null) return false;
        if (r) {
          progress = true;
          break;
        }
      }
      if (progress) continue;
      if (tier < 3) return true;

      // Probing.
      for (var i = 0; i < g.cells && !progress; i++) {
        if (v[i] >= 0) continue;
        for (final val in const [slBack, slFwd]) {
          final w = List.of(v)..[i] = val;
          if (!propagate(w, 2)) {
            if (!set(i, 1 - val, SlantRule.pair, const [], const [])) return false;
            progress = true;
            break;
          }
        }
      }
      if (!progress) return true;
    }
  }

  /// Every way to fill the open cells around pair [q] that meets both its
  /// numbers; true on progress, false for none, null on a contradiction.
  bool? _pair(
    List<int> v,
    int q,
    bool Function(int, int, SlantRule, List<int>, List<int>) set,
    ExplainTrace? t,
  ) {
    final g = p.geo;
    final (a, b) = pairs[q];
    final open = [
      for (final i in pairCells[q])
        if (v[i] < 0) i,
    ];
    if (open.isEmpty) return false;
    // Per number: what it still needs, and the bit that touches it per open cell.
    int need(int k) {
      var n = p.clues[k];
      for (final (i, tv) in g.cornerCells[k]) {
        if (v[i] == tv) n--;
      }
      return n;
    }

    final needA = need(a), needB = need(b);
    var touchA = 0, careA = 0, touchB = 0, careB = 0;
    for (var j = 0; j < open.length; j++) {
      for (final (i, tv) in g.cornerCells[a]) {
        if (i == open[j]) {
          careA |= 1 << j;
          if (tv == slFwd) touchA |= 1 << j;
        }
      }
      for (final (i, tv) in g.cornerCells[b]) {
        if (i == open[j]) {
          careB |= 1 << j;
          if (tv == slFwd) touchB |= 1 << j;
        }
      }
    }
    // Bit j set = cell open[j] gets slFwd.
    var all = (1 << open.length) - 1, any = 0, found = false;
    for (var m = 0; m < 1 << open.length; m++) {
      if (_bits(~(m ^ touchA) & careA) != needA || _bits(~(m ^ touchB) & careB) != needB) continue;
      found = true;
      all &= m;
      any |= m;
    }
    if (!found) {
      t?.fail(SlantRule.failPair.index, premises: pairCells[q], args: [a, b]);
      return null;
    }
    final known = t == null
        ? const <int>[]
        : [
            for (final i in pairCells[q])
              if (v[i] >= 0) i,
          ];
    var progress = false;
    for (var j = 0; j < open.length; j++) {
      final fwd = all & (1 << j) != 0, back = any & (1 << j) == 0;
      if (!fwd && !back) continue;
      if (!set(open[j], fwd ? slFwd : slBack, SlantRule.pair, known, [a, b])) return null;
      progress = true;
    }
    return progress;
  }

  static int _bits(int m) {
    var k = 0;
    for (; m != 0; m &= m - 1) {
      k++;
    }
    return k;
  }

  /// Up to [limit] solutions, each as the diagonal per cell.
  List<List<int>> solutions({int limit = 2}) {
    final out = <List<int>>[];
    void rec(List<int> v) {
      if (out.length >= limit) return;
      if (!propagate(v, 1)) return;
      final i = v.indexOf(-1);
      if (i < 0) {
        out.add(v);
        return;
      }
      for (final val in const [slBack, slFwd]) {
        rec(List.of(v)..[i] = val);
      }
    }

    rec(start());
    return out;
  }

  /// Number of solutions, up to [limit].
  int countSolutions({int limit = 2}) => solutions(limit: limit).length;
}
