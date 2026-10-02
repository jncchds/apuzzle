import '../../core/explain.dart';
import '../../core/grid.dart';
import '../../core/value_grid.dart';
import '../../core/value_grid_explain.dart';
import 'pairs_model.dart';
import 'pairs_solver.dart';

final _solvers = Expando<PairsSolver>();

/// Explains Pairs with [PairsSolver]: region counts and domino rules, then
/// every way to finish a region, then probing.
class PairsExplainer extends BinaryGridExplainer<PairsPuzzle> {
  const PairsExplainer();

  PairsSolver _solver(PairsPuzzle p) => _solvers[p] ??= PairsSolver(p.n, p.regions);

  @override
  int get levels => 3;

  @override
  bool probes(int level) => level == 3;

  @override
  List<int> get boardValues => const [pairsDot, pairsShade];

  @override
  Set<int> get optionalValues => const {pairsDot};

  @override
  List<int> seed(PairsPuzzle p, ValueGrid s) => knownStates(p, s);

  @override
  bool propagate(PairsPuzzle p, List<int> k, int level, ExplainTrace? t) => _solver(p).propagate(k, level, t);

  @override
  ExplainLine? describe(PairsPuzzle p, Fact f) {
    final solver = _solver(p);
    final pos = p.size.pos;
    String cell(int i) => cellTok(pos(i));
    final at = f.slot >= 0 ? cell(f.slot) : '';
    final me = {if (f.slot >= 0) pos(f.slot)};
    final here = {...me, for (final i in f.premises) pos(i)};
    String region(int r) => cell(solver.members[r].first);
    Set<Pos> cells(int r) => {for (final i in solver.members[r]) pos(i)};
    final shade = f.value == 1;
    final x = f.args.isEmpty ? -1 : f.args[0];
    switch (f.rule) {
      case ruleAssume:
        return ExplainLine((l) => shade ? l.exPairsSupposeShade(at) : l.exPairsSupposeDot(at), me);
      case ruleRefuted:
        // The assumption [f.value] failed: the cell is the other way.
        return ExplainLine((l) => shade ? l.exPairsRefutedDot(at) : l.exPairsRefutedShade(at), me);
    }
    return switch (PairsRule.values[f.rule]) {
      PairsRule.regionDone => ExplainLine((l) => l.exPairsRegionDone(at, region(x)), {...me, ...cells(x)}),
      PairsRule.regionNeed => ExplainLine((l) => l.exPairsRegionNeed(at, region(x)), {...me, ...cells(x)}),
      PairsRule.partnered => ExplainLine((l) => l.exPairsPartnered(at, cell(x)), here),
      PairsRule.oneWay => ExplainLine((l) => l.exPairsOneWay(at, cell(x)), here),
      PairsRule.crowd => ExplainLine((l) => l.exPairsCrowd(at), here),
      PairsRule.alone => ExplainLine((l) => l.exPairsAlone(at), here),
      PairsRule.everyWay => ExplainLine(
        (l) => shade ? l.exPairsEveryShade(at, region(x)) : l.exPairsEveryDot(at, region(x)),
        {...me, ...cells(x)},
      ),
      PairsRule.failMany => ExplainLine((l) => l.exPairsFailMany(region(x)), cells(x)),
      PairsRule.failFew => ExplainLine((l) => l.exPairsFailFew(region(x)), cells(x)),
      PairsRule.failCrowd => ExplainLine((l) => l.exPairsFailCrowd(cell(x)), here),
      PairsRule.failAlone => ExplainLine((l) => l.exPairsFailAlone(cell(x)), here),
      PairsRule.failNoWay => ExplainLine((l) => l.exPairsFailNoWay(region(x)), cells(x)),
    };
  }
}
