import '../../core/explain.dart';
import '../../core/grid.dart';
import '../../core/value_grid.dart';
import '../../core/value_grid_explain.dart';
import 'wedges_model.dart';
import 'wedges_solver.dart';

final _solvers = Expando<WedgesSolver>();

/// Explains Wedges with [WedgesSolver]: corners that must stay square and
/// numbers that are done or need every cell left, then two corners or a
/// numbered wall read together, then probing. Dots are optional.
class WedgesExplainer extends MaskGridExplainer<WedgesPuzzle> {
  const WedgesExplainer();

  WedgesSolver _solver(WedgesPuzzle p) => _solvers[p] ??= WedgesSolver(p);

  @override
  int get levels => 3;

  @override
  bool probes(int level) => level == 3;

  @override
  int get lastCandidateRule => WedgesRule.last.index;

  @override
  Set<int> get placingRules => {WedgesRule.done.index, WedgesRule.last.index};

  @override
  Set<int> get optionalValues => const {wedgeDot};

  @override
  List<int> seed(WedgesPuzzle p, ValueGrid s) {
    final st = _solver(p).start();
    final known = knownValues(p, s);
    for (var i = 0; i < known.length; i++) {
      if (known[i] >= 0) st[i] = 1 << known[i];
    }
    return st;
  }

  @override
  bool propagate(WedgesPuzzle p, List<int> k, int level, ExplainTrace? t) => _solver(p).propagate(k, level, t);

  /// Wedges before the dots they leave.
  @override
  int rank(WedgesPuzzle p, Fact f) => placed(p, f) == wedgeDot ? 1 : 0;

  /// "Nothing else fits" goes without saying after what ruled the rest out.
  @override
  bool quiet(WedgesPuzzle p, Fact f) => f.rule == WedgesRule.last.index;

  @override
  ExplainLine? describe(WedgesPuzzle p, Fact f) {
    final g = p.geo;
    final pos = p.size.pos;
    Set<Pos> cells(Iterable<int> idx) => {
      for (final i in idx)
        if (i >= 0) pos(i),
    };
    String corner(int k) {
      final (cell, which) = g.cornerOf(k);
      return cornerTok(cell, which);
    }

    Set<Pos> round(int k) => cells(g.pointCells[k]);
    Set<Pos> ring(int w) {
      final r = w ~/ p.cols, c = w % p.cols;
      return {
        for (var dr = -1; dr <= 1; dr++)
          for (var dc = -1; dc <= 1; dc++)
            if (r + dr >= 0 && r + dr < p.rows && c + dc >= 0 && c + dc < p.cols) Pos(r + dr, c + dc),
      };
    }

    final at = f.slot >= 0 ? cellTok(pos(f.slot)) : '';
    final me = {if (f.slot >= 0) pos(f.slot)};
    final value = valTok(f.value);
    final a = f.args;
    // The values a point, pair or ring rule rules out (the last arg).
    final gone = a.isEmpty ? 0 : a.last;
    final kind = gone == 1 << wedgeDot ? 'dot' : 'wedge';
    final values = [
      for (var v = 0; v < 5; v++)
        if (gone & (1 << v) != 0) valTok(v),
    ].join(' ');
    switch (f.rule) {
      case ruleAssume:
        return ExplainLine((l) => l.exSuppose(at, value), me);
      case ruleRefuted:
        return ExplainLine((l) => l.exRefuted(at, value), me);
    }
    String wall(int i) => cellTok(pos(i));
    return switch (WedgesRule.values[f.rule]) {
      WedgesRule.point => ExplainLine((l) => l.exWedgesPoint(kind, at, values, corner(a[0])), {...me, ...round(a[0])}),
      WedgesRule.done => ExplainLine(
        (l) => l.exWedgesDone(at, wall(a[0]), p.clues[a[0]]),
        {...me, pos(a[0]), ...cells(g.sides[a[0]])},
      ),
      WedgesRule.need => ExplainLine(
        (l) => l.exWedgesNeed(at, wall(a[0]), p.clues[a[0]]),
        {...me, pos(a[0]), ...cells(g.sides[a[0]])},
      ),
      WedgesRule.last => ExplainLine((l) => l.exWedgesLast(at, value), me),
      WedgesRule.pair => ExplainLine(
        (l) => l.exWedgesPair(kind, at, values, corner(a[0]), corner(a[1])),
        {...me, ...round(a[0]), ...round(a[1])},
      ),
      WedgesRule.ring => ExplainLine((l) => l.exWedgesRing(kind, at, values, wall(a[0]), p.clues[a[0]]), {
        ...me,
        ...ring(a[0]),
      }),
      WedgesRule.failEmpty => ExplainLine((l) => l.exWedgesFailEmpty(cellTok(pos(a[0]))), {pos(a[0])}),
      WedgesRule.failPoint => ExplainLine((l) => l.exWedgesFailPoint(corner(a[0])), round(a[0])),
      WedgesRule.failClue => ExplainLine(
        (l) => l.exWedgesFailClue(wall(a[0]), p.clues[a[0]]),
        {pos(a[0]), ...cells(g.sides[a[0]])},
      ),
      WedgesRule.failPair => ExplainLine(
        (l) => l.exWedgesFailPair(corner(a[0]), corner(a[1])),
        {...round(a[0]), ...round(a[1])},
      ),
      WedgesRule.failRing => ExplainLine((l) => l.exWedgesFailRing(wall(a[0]), p.clues[a[0]]), ring(a[0])),
    };
  }
}
