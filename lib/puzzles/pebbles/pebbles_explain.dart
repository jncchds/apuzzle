import 'dart:math';

import '../../core/explain.dart';
import '../../core/value_grid.dart';
import '../../core/value_grid_explain.dart';
import 'pebbles_model.dart';
import 'pebbles_solver.dart';

final _solvers = Expando<PebblesSolver>();

/// Explains Pebbles with [PebblesSolver]: blocks, walled-in cells and
/// groups, then the edge, alternating blocks and cuts, then probing.
class PebblesExplainer extends BinaryGridExplainer<PebblesPuzzle> {
  const PebblesExplainer();

  PebblesSolver _solver(PebblesPuzzle p) => _solvers[p] ??= PebblesSolver(p.n);

  @override
  int get levels => 3;

  @override
  bool probes(int level) => level == 3;

  @override
  List<int> seed(PebblesPuzzle p, ValueGrid s) => knownStates(p, s);

  @override
  bool propagate(PebblesPuzzle p, List<int> k, int level, ExplainTrace? t) => _solver(p).propagate(k, min(level, 2), t);

  @override
  ExplainLine? describe(PebblesPuzzle p, Fact f) {
    final pos = p.size.pos;
    String cell(int i) => cellTok(pos(i));
    final at = f.slot >= 0 ? cell(f.slot) : '';
    final me = {if (f.slot >= 0) pos(f.slot)};
    final here = {...me, for (final i in f.premises) pos(i)};
    final stone = valTok(f.value), other = valTok(1 - f.value);
    switch (f.rule) {
      case ruleAssume:
        return ExplainLine((l) => l.exSuppose(at, stone), me);
      case ruleRefuted:
        return ExplainLine((l) => l.exRefutedBinary(at, other, stone), me);
    }
    final a = f.args;
    final args = {for (final i in a) pos(i)};
    return switch (PebblesRule.values[f.rule]) {
      PebblesRule.block => ExplainLine((l) => l.exPebblesBlock(at, stone, other), here),
      PebblesRule.enclosed => ExplainLine((l) => l.exPebblesEnclosed(at, stone, other), here),
      PebblesRule.exit => ExplainLine((l) => l.exPebblesExit(at, stone, cell(a[0])), here),
      PebblesRule.edge => ExplainLine(
        (l) => l.exPebblesEdge(at, stone, other, cell(a[0]), cell(a[1]), cell(a[2])),
        {...me, ...args},
      ),
      PebblesRule.checker => ExplainLine(
        (l) => l.exPebblesChecker(at, stone, other, cell(a[0]), cell(a[1]), cell(a[2])),
        here,
      ),
      PebblesRule.cut => ExplainLine((l) => l.exPebblesCut(at, stone, other), me),
      PebblesRule.failBlock => ExplainLine((l) => l.exPebblesFailBlock(cell(a[0])), here),
      PebblesRule.failClosed => ExplainLine((l) => l.exPebblesFailClosed(cell(a[0])), here),
      PebblesRule.failEdge => ExplainLine(
        (l) => l.exPebblesFailEdge(cell(a[0]), cell(a[1]), cell(a[2]), cell(a[3])),
        args,
      ),
      PebblesRule.failChecker => ExplainLine((l) => l.exPebblesFailChecker(cell(a[0])), here),
      PebblesRule.failApart => ExplainLine((l) => l.exPebblesFailApart(cell(a[0]), cell(a[1])), args),
    };
  }
}
