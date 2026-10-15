import 'dart:math';

import '../../core/explain.dart';
import '../../core/value_grid.dart';
import '../../core/value_grid_explain.dart';
import 'rampart_model.dart';
import 'rampart_solver.dart';

final _solvers = Expando<RampartSolver>();

/// Explains Rampart with [RampartSolver]: clues, 2×2 blocks and parts of
/// the wall with one way out, then clues against blocks and shut-in parts
/// and cuts, then probing. Dots on cells that stay are optional.
class RampartExplainer extends BinaryGridExplainer<RampartPuzzle> {
  const RampartExplainer();

  RampartSolver _solver(RampartPuzzle p) => _solvers[p] ??= RampartSolver(p);

  @override
  int get levels => 3;

  @override
  bool probes(int level) => level == 3;

  @override
  Set<int> get optionalValues => const {rampartKeep};

  @override
  List<int> seed(RampartPuzzle p, ValueGrid s) => knownStates(p, s);

  @override
  bool propagate(RampartPuzzle p, List<int> k, int level, ExplainTrace? t) => _solver(p).propagate(k, min(level, 2), t);

  @override
  int rank(RampartPuzzle p, Fact f) => placed(p, f) == rampartShade ? 0 : 1;

  @override
  ExplainLine? describe(RampartPuzzle p, Fact f) {
    final pos = p.size.pos;
    String cell(int i) => cellTok(pos(i));
    String block(int b) => areaTok(pos(b), pos(b + p.n + 1));
    final at = f.slot >= 0 ? cell(f.slot) : '';
    final me = {if (f.slot >= 0) pos(f.slot)};
    final keep = f.value == rampartKeep;
    switch (f.rule) {
      case ruleAssume:
        return ExplainLine((l) => keep ? l.exSoloSupposeKeep(at) : l.exSoloSupposeShade(at), me);
      case ruleRefuted:
        return ExplainLine((l) => keep ? l.exSoloRefutedShade(at) : l.exSoloRefutedKeep(at), me);
    }
    final a = f.args;
    final here = {...me, for (final i in f.premises) pos(i)};
    return switch (RampartRule.values[f.rule]) {
      RampartRule.clue => ExplainLine(
        (l) => keep ? l.exRampartClueKeep(at, cell(a[0])) : l.exRampartClueShade(at, cell(a[0])),
        here,
      ),
      RampartRule.pool => ExplainLine((l) => l.exRampartPool(at, block(a[0])), here),
      RampartRule.escape => ExplainLine((l) => l.exRampartEscape(at, cell(a[0])), here),
      RampartRule.ways => ExplainLine(
        (l) => keep ? l.exRampartWaysKeep(at, cell(a[0])) : l.exRampartWaysShade(at, cell(a[0])),
        here,
      ),
      RampartRule.cut => ExplainLine((l) => l.exRampartCut(at), me),
      RampartRule.away => ExplainLine((l) => l.exRampartAway(at), me),
      RampartRule.failClue => ExplainLine((l) => l.exRampartFailClue(cell(a[0])), here),
      RampartRule.failPool => ExplainLine((l) => l.exRampartFailPool(block(a[0])), here),
      RampartRule.failShut => ExplainLine((l) => l.exRampartFailShut(cell(a[0])), here),
      RampartRule.failWays => ExplainLine((l) => l.exRampartFailWays(cell(a[0])), here),
      RampartRule.failApart => ExplainLine(
        (l) => l.exRampartFailApart(cell(a[0]), cell(a[1])),
        {pos(a[0]), pos(a[1])},
      ),
    };
  }
}
