import '../../core/explain.dart';
import '../../core/grid.dart';
import '../../core/value_grid.dart';
import '../../core/value_grid_explain.dart';
import 'blocks_model.dart';
import 'blocks_solver.dart';

final _solvers = Expando<BlocksSolver>();

/// Explains Blocks with [BlocksSolver]: singles and touching, then pointing
/// and naked pairs, then probing.
class BlocksExplainer extends MaskGridExplainer<BlocksPuzzle> {
  const BlocksExplainer();

  BlocksSolver _solver(BlocksPuzzle p) => _solvers[p] ??= BlocksSolver(p.rows, p.cols, p.regions);

  @override
  int get levels => 3;

  @override
  bool probes(int level) => level == 3;

  @override
  int get lastCandidateRule => BlocksRule.naked.index;

  @override
  Set<int> get placingRules => {BlocksRule.naked.index, BlocksRule.hidden.index, BlocksRule.alone.index};

  @override
  List<int> seed(BlocksPuzzle p, ValueGrid s) {
    final known = knownValues(p, s);
    return _solver(p).start([for (final v in known) v < 0 ? null : v])!;
  }

  @override
  void start(BlocksPuzzle p, List<int> k, ExplainTrace t) {
    for (var i = 0; i < k.length; i++) {
      if (_solver(p).members[p.regions[i]].length == 1) t.fact(i, 0, BlocksRule.alone.index);
    }
  }

  @override
  bool propagate(BlocksPuzzle p, List<int> k, int level, ExplainTrace? t) => _solver(p).propagate(k, level, t);

  @override
  ExplainLine? describe(BlocksPuzzle p, Fact f) {
    final solver = _solver(p);
    final pos = p.size.pos;
    String cell(int i) => cellTok(pos(i));
    Set<Pos> cells(Iterable<int> idx) => {for (final i in idx) pos(i)};
    final at = f.slot >= 0 ? cell(f.slot) : '';
    final me = {if (f.slot >= 0) pos(f.slot)};
    final a = f.args;
    String region(int r) => cell(solver.members[r].first);
    switch (f.rule) {
      case ruleAssume:
        return ExplainLine((l) => l.exSuppose(at, valTok(f.value)), me);
      case ruleRefuted:
        return ExplainLine((l) => l.exRefuted(at, valTok(f.value)), me);
    }
    switch (BlocksRule.values[f.rule]) {
      case BlocksRule.touch || BlocksRule.region:
        return null;
      case BlocksRule.naked:
        return ExplainLine((l) => l.exBlocksNaked(at, valTok(f.value)), {
          ...me,
          ...cells(solver.kn[f.slot]),
          ...cells(solver.members[p.regions[f.slot]]),
        });
      case BlocksRule.alone:
        return ExplainLine((l) => l.exBlocksAlone(at), me);
      case BlocksRule.hidden:
        return ExplainLine((l) => l.exBlocksHidden(at, valTok(f.value)), cells(solver.members[a[0]]));
      case BlocksRule.pointing:
        final v = valTok(a[0]);
        return ExplainLine((l) => l.exBlocksPointing(at, v, region(a[1])), {...me, ...cells(solver.members[a[1]])});
      case BlocksRule.pair:
        final ds = [
          for (var v = 0; v < a[2].bitLength; v++)
            if (a[2] & (1 << v) != 0) valTok(v),
        ];
        return ExplainLine((l) => l.exBlocksPair(cell(a[0]), cell(a[1]), ds[0], ds[1]), {
          ...cells(solver.members[p.regions[a[0]]]),
        });
      case BlocksRule.failEmpty:
        return ExplainLine((l) => l.exBlocksFailEmpty(cell(a[0])), {pos(a[0])});
      case BlocksRule.failNoPlace:
        return ExplainLine((l) => l.exBlocksFailNoPlace(valTok(a[0]), region(a[1])), cells(solver.members[a[1]]));
    }
  }
}
