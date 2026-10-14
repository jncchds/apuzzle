import '../../core/explain.dart';
import '../../core/latin_square.dart';
import 'skyline_model.dart';

/// Skyline's own rules on top of [LatinRule], recorded with the id
/// `latinRuleCount + index`:
/// - [bound]: a clue of k leaves room for at most n − k + 1 + d at distance d
///   (args: side, line, clue, highest digit);
/// - [tallest]: a clue of 1 puts the tallest tower first (args: side, line);
/// - [line]: no way to fill the row or column that matches its clues uses
///   this digit here (args: line);
/// - [failLine]: no way at all (args: line).
enum SkylineRule {
  bound,
  tallest,
  line,
  failLine;

  int get id => latinRuleCount + index;
}

/// Candidate logic for Skyline. Tier 1: the Latin singles plus what each clue
/// alone allows ([SkylineRule.bound], [SkylineRule.tallest]). Tier 2: + naked
/// pairs and every way to fill a clued line. Tier 3: + probing. All sound, so
/// a full solve proves the solution unique.
class SkylineSolver {
  SkylineSolver(this.n, this.clues) : sq = LatinSquare.of(n) {
    for (var u = 0; u < 2 * n; u++) {
      // A row is read from the left, a column from the top.
      final k = u % n;
      final (a, b) = u < n
          ? (clues[skylineLeft * n + k], clues[skylineRight * n + k])
          : (clues[skylineTop * n + k], clues[skylineBottom * n + k]);
      if (a != null || b != null) clued.add((u, a, b));
    }
  }

  final int n;
  final List<int?> clues;
  final LatinSquare sq;

  /// Lines with a clue: (line, clue at its start, clue at its end).
  final List<(int, int?, int?)> clued = [];

  List<int> start(List<int?> givens) => sq.start(givens);

  /// The clue rules, which need nothing but the clues. False on a contradiction.
  bool _clueRules(List<int> c, ExplainTrace? t) {
    for (var side = 0; side < 4; side++) {
      for (var k = 0; k < n; k++) {
        final clue = clues[side * n + k];
        if (clue == null) continue;
        final line = skylineLine(n, side, k);
        if (clue == 1) {
          final i = line.first, bit = 1 << (n - 1);
          if (c[i] == bit) continue;
          if (c[i] & bit == 0) {
            t?.fail(LatinRule.failEmpty.index, premises: [i], args: [i]);
            return false;
          }
          c[i] = bit;
          t?.fact(i, n - 1, SkylineRule.tallest.id, args: [side, k]);
          continue;
        }
        for (var d = 0; d < clue - 1; d++) {
          final top = n - clue + d;
          final ok = sq.remove(
            c,
            line[d],
            sq.full & ~((2 << top) - 1),
            SkylineRule.bound.id,
            t: t,
            args: [side, k, clue, top],
          );
          if (!ok) return false;
        }
      }
    }
    return true;
  }

  /// Every way to fill a line with [masks] (in reading order) whose clue at
  /// the start is [a] and at the end [b]: the digits each cell can take, all
  /// zero if there is no way.
  List<int> _fills(List<int> masks, int a, int? b) {
    final top = n - 1;
    return sq.lineFills(
      masks,
      (f) => skylineVisible(f) == a && (b == null || skylineVisible(f.reversed) == b),
      prefix: (f, len) {
        final seen = skylineVisible(f.take(len));
        // Nothing behind the tallest tower can be seen.
        return seen <= a && (f[len - 1] != top || seen == a) && seen + (n - len) >= a;
      },
    );
  }

  /// Applies the rules of [tier] (1 or 2) in place until nothing changes;
  /// false on a contradiction. With [t], every deduction is recorded.
  bool propagate(List<int> c, int tier, [ExplainTrace? t]) {
    if (!_clueRules(c, t)) return false;
    // The masks each clued line was last filled with: unchanged lines are skipped.
    final seen = List<List<int>?>.filled(clued.length, null);
    while (true) {
      if (!sq.propagate(c, pairs: tier >= 2, t: t)) return false;
      if (tier < 2) return true;
      var changed = false;
      for (var x = 0; x < clued.length; x++) {
        final (u, a, b) = clued[x];
        final cells = sq.lines[u];
        final masks = [for (final i in cells) c[i]];
        if (seen[x] case final last? when _same(last, masks)) continue;
        // Read from a clued end, so partial fills can be cut short.
        final can = a == null ? _fills(masks.reversed.toList(), b!, null).reversed.toList() : _fills(masks, a, b);
        if (can.every((m) => m == 0)) {
          t?.fail(SkylineRule.failLine.id, premises: cells, args: [u]);
          return false;
        }
        for (var k = 0; k < n; k++) {
          final i = cells[k];
          for (final d in LatinSquare.digits(c[i] & ~can[k])) {
            changed = true;
            sq.remove(c, i, 1 << d, SkylineRule.line.id, t: t, premises: cells, args: [u]);
          }
        }
        seen[x] = can;
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
