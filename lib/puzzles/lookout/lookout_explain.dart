import 'dart:math';

import '../../core/explain.dart';
import '../../core/value_grid.dart';
import '../../core/value_grid_explain.dart';
import 'lookout_model.dart';
import 'lookout_solver.dart';

final _solvers = Expando<LookoutSolver>();

/// Explains Lookout with [LookoutSolver]: neighbours, how far numbers see
/// and walled cells, then every way to split a number's view and cuts,
/// then probing. Dots on cells that stay are optional.
class LookoutExplainer extends BinaryGridExplainer<LookoutPuzzle> {
  const LookoutExplainer();

  LookoutSolver _solver(LookoutPuzzle p) => _solvers[p] ??= LookoutSolver(p);

  @override
  int get levels => 3;

  @override
  bool probes(int level) => level == 3;

  @override
  Set<int> get optionalValues => const {lookoutKeep};

  @override
  List<int> seed(LookoutPuzzle p, ValueGrid s) => knownStates(p, s);

  @override
  bool propagate(LookoutPuzzle p, List<int> k, int level, ExplainTrace? t) => _solver(p).propagate(k, min(level, 2), t);

  @override
  int rank(LookoutPuzzle p, Fact f) => placed(p, f) == lookoutShade ? 0 : 1;

  @override
  ExplainLine? describe(LookoutPuzzle p, Fact f) {
    final pos = p.size.pos;
    String cell(int i) => cellTok(pos(i));
    final at = f.slot >= 0 ? cell(f.slot) : '';
    final me = {if (f.slot >= 0) pos(f.slot)};
    final keep = f.value == lookoutKeep;
    switch (f.rule) {
      case ruleAssume:
        return ExplainLine((l) => keep ? l.exSoloSupposeKeep(at) : l.exSoloSupposeShade(at), me);
      case ruleRefuted:
        return ExplainLine((l) => keep ? l.exSoloRefutedShade(at) : l.exSoloRefutedKeep(at), me);
    }
    final a = f.args;
    final here = {...me, for (final i in f.premises) pos(i)};
    return switch (LookoutRule.values[f.rule]) {
      LookoutRule.touch => ExplainLine((l) => l.exSoloTouch(at, cell(a[0])), here),
      LookoutRule.reach => ExplainLine((l) => l.exLookoutReach(at, cell(a[0]), a[1]), here),
      LookoutRule.close => ExplainLine((l) => l.exLookoutClose(at, cell(a[0]), a[1]), here),
      LookoutRule.walled => ExplainLine((l) => l.exSoloWalled(at, cell(a[0])), here),
      LookoutRule.ways => ExplainLine(
        (l) => keep ? l.exLookoutWaysKeep(at, cell(a[0]), a[1]) : l.exLookoutWaysShade(at, cell(a[0]), a[1]),
        here,
      ),
      LookoutRule.cut => ExplainLine((l) => l.exSoloCut(at), me),
      LookoutRule.failTouch => ExplainLine((l) => l.exSoloFailTouch(cell(a[0]), cell(a[1])), here),
      LookoutRule.failMany => ExplainLine((l) => l.exLookoutFailMany(cell(a[0]), a[1]), here),
      LookoutRule.failFew => ExplainLine((l) => l.exLookoutFailFew(cell(a[0]), a[1]), here),
      LookoutRule.failWalled => ExplainLine((l) => l.exSoloFailWalled(cell(a[0])), here),
      LookoutRule.failWays => ExplainLine((l) => l.exLookoutFailWays(cell(a[0]), a[1]), here),
      LookoutRule.failApart => ExplainLine(
        (l) => l.exSoloFailApart(cell(a[0]), cell(a[1])),
        {pos(a[0]), pos(a[1])},
      ),
    };
  }
}
