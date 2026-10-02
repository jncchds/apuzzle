import '../../core/explain.dart';
import '../../core/value_grid.dart';
import '../../core/value_grid_explain.dart';
import 'islands_model.dart';
import 'islands_solver.dart';

final _solvers = Expando<IslandsSolver>();

/// Explains Islands with [IslandsSolver]: pools, island growth, reach and
/// sea connectivity, then probing. Land dots are optional on the board.
class IslandsExplainer extends BinaryGridExplainer<IslandsPuzzle> {
  const IslandsExplainer();

  IslandsSolver _solver(IslandsPuzzle p) => _solvers[p] ??= IslandsSolver(p.rows, p.cols, p.clues);

  @override
  int get levels => 2;

  @override
  bool probes(int level) => level == 2;

  @override
  Set<int> get optionalValues => const {islandsLand};

  @override
  List<int> seed(IslandsPuzzle p, ValueGrid s) => knownStates(p, s);

  @override
  bool propagate(IslandsPuzzle p, List<int> k, int level, ExplainTrace? t) => _solver(p).propagate(k, t);

  @override
  int rank(IslandsPuzzle p, Fact f) => placed(p, f) == islandsSea ? 0 : 1;

  @override
  ExplainLine? describe(IslandsPuzzle p, Fact f) {
    final pos = p.size.pos;
    String cell(int i) => cellTok(pos(i));
    final at = f.slot >= 0 ? cell(f.slot) : '';
    final me = {if (f.slot >= 0) pos(f.slot)};
    final here = {...me, for (final i in f.premises) pos(i)};
    final a = f.args;
    final sea = f.value == islandsSea;
    switch (f.rule) {
      case ruleAssume:
        return ExplainLine((l) => sea ? l.exIslandsSupposeSea(at) : l.exIslandsSupposeLand(at), me);
      case ruleRefuted:
        return ExplainLine((l) => sea ? l.exIslandsRefutedLand(at) : l.exIslandsRefutedSea(at), me);
    }
    return switch (IslandsRule.values[f.rule]) {
      IslandsRule.total => ExplainLine((l) => sea ? l.exIslandsTotalSea(at) : l.exIslandsTotalLand(at), me),
      IslandsRule.pool => ExplainLine((l) => l.exIslandsPool(at), here),
      IslandsRule.complete => ExplainLine((l) => l.exIslandsComplete(at, cell(a[0]), a[1]), here),
      IslandsRule.exit => ExplainLine((l) => l.exIslandsExit(at, cell(a[0])), here),
      IslandsRule.between => ExplainLine((l) => l.exIslandsBetween(at), here),
      IslandsRule.unreachable => ExplainLine((l) => l.exIslandsUnreachable(at), me),
      IslandsRule.seaExit => ExplainLine((l) => l.exIslandsSeaExit(at, cell(a[0])), here),
      IslandsRule.failTotal => ExplainLine((l) => l.exIslandsFailTotal, const {}),
      IslandsRule.failInvalid => ExplainLine((l) => l.exIslandsFailInvalid, const {}),
      IslandsRule.failPool => ExplainLine((l) => l.exIslandsFailPool(cell(a[0])), here),
      IslandsRule.failTwoClues => ExplainLine((l) => l.exIslandsFailTwoClues(cell(a[0]), cell(a[1])), here),
      IslandsRule.failBig => ExplainLine((l) => l.exIslandsFailBig(cell(a[0]), a[1]), here),
      IslandsRule.failShut => ExplainLine(
        (l) => a[1] < 0 ? l.exIslandsFailOrphan(cell(a[0])) : l.exIslandsFailShut(cell(a[0])),
        here,
      ),
      IslandsRule.failUnreachable => ExplainLine((l) => l.exIslandsFailUnreachable(cell(a[0])), {pos(a[0])}),
      IslandsRule.failSeaShut => ExplainLine((l) => l.exIslandsFailSeaShut(cell(a[0])), here),
    };
  }
}
