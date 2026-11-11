import 'dart:math';

import '../../core/explain.dart';
import '../../core/value_grid.dart';
import '../../core/value_grid_explain.dart';
import 'slabs_model.dart';
import 'slabs_solver.dart';

final _solvers = Expando<SlabsSolver>();

/// Explains Slabs with [SlabsSolver]: rectangles, full areas, ways out and
/// joins, then the rectangles and reach of numbers, then probing. Dots on
/// unshaded cells are optional.
class SlabsExplainer extends BinaryGridExplainer<SlabsPuzzle> {
  const SlabsExplainer();

  SlabsSolver _solver(SlabsPuzzle p) => _solvers[p] ??= SlabsSolver(p);

  @override
  int get levels => 3;

  @override
  bool probes(int level) => level == 3;

  @override
  Set<int> get optionalValues => const {slabsKeep};

  @override
  List<int> seed(SlabsPuzzle p, ValueGrid s) => knownStates(p, s);

  @override
  bool propagate(SlabsPuzzle p, List<int> k, int level, ExplainTrace? t) => _solver(p).propagate(k, min(level, 2), t);

  @override
  int rank(SlabsPuzzle p, Fact f) => placed(p, f) == slabsShade ? 0 : 1;

  @override
  ExplainLine? describe(SlabsPuzzle p, Fact f) {
    final pos = p.size.pos;
    String cell(int i) => cellTok(pos(i));
    final at = f.slot >= 0 ? cell(f.slot) : '';
    final me = {if (f.slot >= 0) pos(f.slot)};
    final shade = f.value == slabsShade;
    switch (f.rule) {
      case ruleAssume:
        return ExplainLine((l) => shade ? l.exSoloSupposeShade(at) : l.exSlabsSupposeKeep(at), me);
      case ruleRefuted:
        return ExplainLine((l) => shade ? l.exSlabsRefutedShade(at) : l.exSlabsRefutedKeep(at), me);
    }
    final a = f.args;
    final here = {...me, for (final i in f.premises) pos(i)};
    return switch (SlabsRule.values[f.rule]) {
      SlabsRule.box => ExplainLine((l) => l.exSlabsBox(at, cell(a[0])), here),
      SlabsRule.full => ExplainLine(
        (l) => shade ? l.exSlabsFullShade(at, cell(a[0]), a[1]) : l.exSlabsFullKeep(at, cell(a[0]), a[1]),
        here,
      ),
      SlabsRule.grow => ExplainLine(
        (l) => shade ? l.exSlabsGrowShade(at, cell(a[0]), a[1]) : l.exSlabsGrowKeep(at, cell(a[0]), a[1]),
        here,
      ),
      SlabsRule.growRect => ExplainLine((l) => l.exSlabsGrowRect(at, cell(a[0])), here),
      SlabsRule.joinBig => ExplainLine(
        (l) => shade ? l.exSlabsJoinBigShade(at, cell(a[0]), a[1]) : l.exSlabsJoinBigKeep(at, cell(a[0]), a[1]),
        here,
      ),
      SlabsRule.joinMix => ExplainLine(
        (l) => shade
            ? l.exSlabsJoinMixShade(at, cell(a[0]), cell(a[1]))
            : l.exSlabsJoinMixKeep(at, cell(a[0]), cell(a[1])),
        here,
      ),
      SlabsRule.corner => ExplainLine((l) => l.exSlabsCorner(at, cell(a[0])), here),
      SlabsRule.small => ExplainLine((l) => l.exSlabsSmall(at, a[0]), me),
      SlabsRule.noRect => ExplainLine((l) => l.exSlabsNoRect(at, a[0]), here),
      SlabsRule.rectIn => ExplainLine((l) => l.exSlabsRectIn(at, cell(a[0]), a[1]), here),
      SlabsRule.rectOut => ExplainLine((l) => l.exSlabsRectOut(at, cell(a[0]), a[1]), here),
      SlabsRule.reach => ExplainLine((l) => l.exSlabsReach(at, a[0]), here),
      SlabsRule.reachAll => ExplainLine((l) => l.exSlabsReachAll(at, cell(a[0]), a[1]), here),
      SlabsRule.failMix => ExplainLine((l) => l.exSlabsFailMix(cell(a[0]), cell(a[1])), here),
      SlabsRule.failBig => ExplainLine((l) => l.exSlabsFailBig(cell(a[0]), a[1]), here),
      SlabsRule.failSize => ExplainLine((l) => l.exSlabsFailSize(cell(a[0]), a[1]), here),
      SlabsRule.failShape => ExplainLine((l) => l.exSlabsFailShape(cell(a[0])), here),
      SlabsRule.failRect => ExplainLine((l) => l.exSlabsFailRect(cell(a[0])), here),
      SlabsRule.failNoRect => ExplainLine((l) => l.exSlabsFailNoRect(cell(a[0]), a[1]), here),
      SlabsRule.failReach => ExplainLine((l) => l.exSlabsFailReach(cell(a[0]), a[1]), here),
    };
  }
}
