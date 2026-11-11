import '../../core/explain.dart';
import '../../core/grid.dart';
import '../../core/value_grid.dart';
import '../../core/value_grid_explain.dart';
import 'ripples_model.dart';
import 'ripples_solver.dart';

final _solvers = Expando<RipplesSolver>();

/// Explains Echoes with [RipplesSolver]: singles, regions and the distance
/// rule, then pointing and naked pairs, then probing.
class RipplesExplainer extends MaskGridExplainer<RipplesPuzzle> {
  const RipplesExplainer();

  RipplesSolver _solver(RipplesPuzzle p) => _solvers[p] ??= RipplesSolver(p.rows, p.cols, p.regions);

  @override
  int get levels => 3;

  @override
  bool probes(int level) => level == 3;

  @override
  int get lastCandidateRule => RipplesRule.naked.index;

  @override
  Set<int> get placingRules => {RipplesRule.naked.index, RipplesRule.hidden.index, RipplesRule.alone.index};

  @override
  List<int> seed(RipplesPuzzle p, ValueGrid s) {
    final known = knownValues(p, s);
    return _solver(p).start([for (final v in known) v < 0 ? null : v])!;
  }

  @override
  void start(RipplesPuzzle p, List<int> k, ExplainTrace t) {
    for (var i = 0; i < k.length; i++) {
      if (_solver(p).members[p.regions[i]].length == 1) t.fact(i, 0, RipplesRule.alone.index);
    }
  }

  @override
  bool propagate(RipplesPuzzle p, List<int> k, int level, ExplainTrace? t) => _solver(p).propagate(k, level, t);

  @override
  ExplainLine? describe(RipplesPuzzle p, Fact f) {
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
    switch (RipplesRule.values[f.rule]) {
      case RipplesRule.echo || RipplesRule.region:
        return null;
      case RipplesRule.naked:
        return ExplainLine((l) => l.exRipplesNaked(at, valTok(f.value)), {
          ...me,
          ...cells(solver.reach[f.slot].last),
          ...cells(solver.members[p.regions[f.slot]]),
        });
      case RipplesRule.alone:
        return ExplainLine((l) => l.exRipplesAlone(at), me);
      case RipplesRule.hidden:
        return ExplainLine((l) => l.exRipplesHidden(at, valTok(f.value)), cells(solver.members[a[0]]));
      case RipplesRule.pointing:
        final v = valTok(a[0]);
        return ExplainLine((l) => l.exRipplesPointing(at, v, region(a[1])), {...me, ...cells(solver.members[a[1]])});
      case RipplesRule.pair:
        final ds = [
          for (var v = 0; v < a[2].bitLength; v++)
            if (a[2] & (1 << v) != 0) valTok(v),
        ];
        return ExplainLine((l) => l.exRipplesPair(cell(a[0]), cell(a[1]), ds[0], ds[1]), {
          ...cells(solver.members[p.regions[a[0]]]),
        });
      case RipplesRule.failEmpty:
        return ExplainLine((l) => l.exRipplesFailEmpty(cell(a[0])), {pos(a[0])});
      case RipplesRule.failNoPlace:
        return ExplainLine((l) => l.exRipplesFailNoPlace(valTok(a[0]), region(a[1])), cells(solver.members[a[1]]));
    }
  }
}
