import '../../core/lattice_loop.dart';
import 'pearls_model.dart';

/// Pearls' own rules for a traced [PearlsSolver] (ids from [loopRuleCount]);
/// the arg is the pearl's cell.
enum PearlsRule { pass, blackFar, blackStraight, blackTurn, whiteAxis, whiteTurn, failPass }

/// Loop logic plus the pearl rules.
class PearlsSolver extends LoopSolver {
  PearlsSolver(this.rows, this.cols, this.pearls) : super(LatticeLoop(rows, cols)) {
    for (var i = 0; i < pearls.length; i++) {
      if (pearls[i] != pearlNone) _cells.add(i);
    }
  }

  final int rows;
  final int cols;
  final List<int> pearls;
  final List<int> _cells = [];

  int _val(List<int> st, int e) => e < 0 ? 0 : st[e];

  @override
  bool clues(List<int> st) {
    for (final p in _cells) {
      final e = [for (final (dr, dc) in pearlDirs) g.step(p, dr, dc)]; // N, S, W, E
      // The loop passes every pearl.
      var lines = 0, open = 0;
      for (final x in e) {
        final v = _val(st, x);
        if (v == 1) lines++;
        if (v == -1) open++;
      }
      if (lines + open < 2) return fail(loopRuleCount + PearlsRule.failPass.index, p);
      if (lines + open == 2) {
        because(loopRuleCount + PearlsRule.pass.index, p);
        for (final x in e) {
          if (_val(st, x) == -1 && !set(st, x, 1)) return false;
        }
      }
      if (pearls[p] == pearlWhite) {
        if (!_white(st, p, e[0], e[1], e[2], e[3], -1, 0) || !_white(st, p, e[2], e[3], e[0], e[1], 0, -1)) {
          return false;
        }
      } else {
        for (var k = 0; k < 4; k++) {
          final (dr, dc) = pearlDirs[k];
          final opposite = e[k ^ 1];
          final here = e[k];
          final beyond = here < 0 ? -1 : g.step(p + dr * cols + dc, dr, dc);
          because(loopRuleCount + PearlsRule.blackFar.index, p);
          if (_val(st, beyond) == 0 && !set(st, here, 0)) return false;
          because(loopRuleCount + PearlsRule.blackStraight.index, p);
          if (_val(st, here) == 1 && (!set(st, beyond, 1) || !set(st, opposite, 0))) return false;
          because(loopRuleCount + PearlsRule.blackTurn.index, p);
          if (_val(st, here) == 0 && !set(st, opposite, 1)) return false;
        }
      }
    }
    return true;
  }

  /// White pearl along the axis of edges [a] (towards −) and [b] (towards +),
  /// across edges [x], [y]; (dr, dc) points towards [a].
  bool _white(List<int> st, int p, int a, int b, int x, int y, int dr, int dc) {
    final va = _val(st, a), vb = _val(st, b);
    because(loopRuleCount + PearlsRule.whiteAxis.index, p);
    if (va == 1 || vb == 1) {
      if (!set(st, a, 1) || !set(st, b, 1) || !set(st, x, 0) || !set(st, y, 0)) return false;
    } else if (va == 0 || vb == 0) {
      if (!set(st, a, 0) || !set(st, b, 0) || !set(st, x, 1) || !set(st, y, 1)) return false;
      return true;
    }
    // Going straight here needs a turn just before or just after.
    final before = g.step(p + dr * cols + dc, dr, dc);
    final after = g.step(p - dr * cols - dc, -dr, -dc);
    final sa = _val(st, before), sb = _val(st, after);
    because(loopRuleCount + PearlsRule.whiteTurn.index, p);
    if (sa == 1 && sb == 1) return set(st, a, 0) && set(st, b, 0) && set(st, x, 1) && set(st, y, 1);
    if (_val(st, a) == 1) {
      if (sa == 1 && !set(st, after, 0)) return false;
      if (sb == 1 && !set(st, before, 0)) return false;
    }
    return true;
  }

  /// Edges a pearl's rules look at: around its cell and one step beyond.
  @override
  List<int> premisesOf(int rule, int arg) {
    if (rule < loopRuleCount) return super.premisesOf(rule, arg);
    return [
      for (final (dr, dc) in pearlDirs) ...[
        g.step(arg, dr, dc),
        if (g.step(arg, dr, dc) >= 0) g.step(arg + dr * cols + dc, dr, dc),
      ],
    ].where((e) => e >= 0).toList();
  }

  @override
  bool cluesMet(List<bool> lines) {
    for (final p in _cells) {
      if (!pearlMet(g, lines, p, pearls[p])) return false;
    }
    return true;
  }
}
