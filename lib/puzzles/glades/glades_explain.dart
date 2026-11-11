import 'dart:math';

import '../../core/explain.dart';
import '../../core/value_grid.dart';
import '../../core/value_grid_explain.dart';
import 'glades_model.dart';
import 'glades_solver.dart';

final _solvers = Expando<GladesSolver>();

/// Explains Glades with [GladesSolver]: 2×2 blocks, rectangles, full areas,
/// ways out, joins and corner links, then cuts, the rectangles numbers can
/// be and cells none reaches, then probing. Dots on unshaded cells are
/// optional.
class GladesExplainer extends BinaryGridExplainer<GladesPuzzle> {
  const GladesExplainer();

  GladesSolver _solver(GladesPuzzle p) => _solvers[p] ??= GladesSolver(p);

  @override
  int get levels => 3;

  @override
  bool probes(int level) => level == 3;

  @override
  Set<int> get optionalValues => const {gladesKeep};

  @override
  List<int> seed(GladesPuzzle p, ValueGrid s) => knownStates(p, s);

  @override
  bool propagate(GladesPuzzle p, List<int> k, int level, ExplainTrace? t) => _solver(p).propagate(k, min(level, 2), t);

  @override
  int rank(GladesPuzzle p, Fact f) => placed(p, f) == gladesShade ? 0 : 1;

  @override
  ExplainLine? describe(GladesPuzzle p, Fact f) {
    final pos = p.size.pos;
    String cell(int i) => cellTok(pos(i));
    final at = f.slot >= 0 ? cell(f.slot) : '';
    final me = {if (f.slot >= 0) pos(f.slot)};
    final shade = f.value == gladesShade;
    switch (f.rule) {
      case ruleAssume:
        return ExplainLine((l) => shade ? l.exSoloSupposeShade(at) : l.exSlabsSupposeKeep(at), me);
      case ruleRefuted:
        return ExplainLine((l) => shade ? l.exSlabsRefutedShade(at) : l.exSlabsRefutedKeep(at), me);
    }
    final a = f.args;
    final here = {...me, for (final i in f.premises) pos(i)};
    return switch (GladesRule.values[f.rule]) {
      GladesRule.pool => ExplainLine((l) => l.exGladesPool(at, cell(a[0])), here),
      GladesRule.box => ExplainLine((l) => l.exGladesBox(at, cell(a[0])), here),
      GladesRule.full => ExplainLine((l) => l.exGladesFull(at, cell(a[0]), a[1]), here),
      GladesRule.grow => ExplainLine((l) => l.exGladesGrow(at, cell(a[0]), a[1]), here),
      GladesRule.growNone => ExplainLine((l) => l.exGladesGrowNone(at, cell(a[0])), here),
      GladesRule.joinMix => ExplainLine((l) => l.exGladesJoinMix(at, cell(a[0]), cell(a[1])), here),
      GladesRule.joinBig => ExplainLine((l) => l.exGladesJoinBig(at, cell(a[0]), a[1]), here),
      GladesRule.corner => ExplainLine((l) => l.exGladesCorner(at, cell(a[0])), here),
      GladesRule.isolated => ExplainLine((l) => l.exGladesIsolated(at), here),
      GladesRule.escape => ExplainLine((l) => l.exGladesEscape(at, cell(a[0])), here),
      GladesRule.cut => ExplainLine((l) => l.exGladesCut(at), here),
      GladesRule.rectIn => ExplainLine((l) => l.exGladesRectIn(at, cell(a[0]), a[1]), here),
      GladesRule.rectOut => ExplainLine((l) => l.exGladesRectOut(at, cell(a[0]), a[1]), here),
      GladesRule.orphan => ExplainLine((l) => l.exGladesOrphan(at), here),
      GladesRule.failPool => ExplainLine((l) => l.exGladesFailPool(cell(a[0])), here),
      GladesRule.failMix => ExplainLine((l) => l.exGladesFailMix(cell(a[0]), cell(a[1])), here),
      GladesRule.failBig => ExplainLine((l) => l.exGladesFailBig(cell(a[0]), a[1]), here),
      GladesRule.failShape => ExplainLine((l) => l.exGladesFailShape(cell(a[0])), here),
      GladesRule.failSize => ExplainLine((l) => l.exGladesFailSize(cell(a[0]), a[1]), here),
      GladesRule.failNoNum => ExplainLine((l) => l.exGladesFailNoNum(cell(a[0])), here),
      GladesRule.failApart => ExplainLine((l) => l.exSoloFailApart(cell(a[0]), cell(a[1])), here),
      GladesRule.failNoRect => ExplainLine((l) => l.exGladesFailNoRect(cell(a[0]), a[1]), here),
      GladesRule.failOrphan => ExplainLine((l) => l.exGladesFailOrphan(cell(a[0])), here),
    };
  }
}
