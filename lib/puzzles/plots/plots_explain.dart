import '../../core/explain.dart';
import '../../core/value_grid.dart';
import '../../core/value_grid_explain.dart';
import 'plots_model.dart';
import 'plots_solver.dart';

final _solvers = Expando<PlotsSolver>();

/// Explains Plots with [PlotsSolver]: group logic, then probing.
class PlotsExplainer extends MaskGridExplainer<PlotsPuzzle> {
  const PlotsExplainer();

  PlotsSolver _solver(PlotsPuzzle p) => _solvers[p] ??= PlotsSolver(p.rows, p.cols, p.maxValue);

  @override
  int get levels => 2;

  @override
  bool probes(int level) => level == 2;

  @override
  int get lastCandidateRule => PlotsRule.only.index;

  @override
  Set<int> get placingRules => {PlotsRule.exit.index, PlotsRule.only.index};

  @override
  List<int> seed(PlotsPuzzle p, ValueGrid s) => _solver(p).start([for (final v in knownValues(p, s)) v < 0 ? null : v]);

  @override
  bool propagate(PlotsPuzzle p, List<int> k, int level, ExplainTrace? t) => _solver(p).propagate(k, t);

  @override
  ExplainLine? describe(PlotsPuzzle p, Fact f) {
    final pos = p.size.pos;
    String cell(int i) => cellTok(pos(i));
    final at = f.slot >= 0 ? cell(f.slot) : '';
    final me = {if (f.slot >= 0) pos(f.slot)};
    final here = {...me, for (final i in f.premises) pos(i)};
    final a = f.args;
    switch (f.rule) {
      case ruleAssume:
        return ExplainLine((l) => l.exSuppose(at, valTok(f.value)), me);
      case ruleRefuted:
        return ExplainLine((l) => l.exRefuted(at, valTok(f.value)), me);
    }
    switch (PlotsRule.values[f.rule]) {
      case PlotsRule.closed:
        return ExplainLine((l) => l.exPlotsClosed(at, valTok(a[1]), cell(a[0])), here);
      case PlotsRule.exit:
        return ExplainLine((l) => l.exPlotsExit(at, valTok(a[1]), cell(a[0])), here);
      case PlotsRule.merge:
        return ExplainLine((l) => l.exPlotsMerge(at, valTok(a[0])), here);
      case PlotsRule.room:
        return ExplainLine((l) => l.exPlotsRoom(at, valTok(a[0])), me);
      case PlotsRule.only:
        return ExplainLine((l) => l.exPlotsOnly(at, valTok(f.value)), me);
      case PlotsRule.failEmpty:
        return ExplainLine((l) => l.exPlotsFailEmpty(cell(a[0])), {pos(a[0])});
      case PlotsRule.failBig:
        return ExplainLine((l) => l.exPlotsFailBig(valTok(a[1]), cell(a[0])), here);
      case PlotsRule.failShut:
        return ExplainLine((l) => l.exPlotsFailShut(valTok(a[1]), cell(a[0])), here);
      case PlotsRule.failRoom:
        return ExplainLine((l) => l.exPlotsFailRoom(valTok(a[1]), cell(a[0])), {pos(a[0])});
    }
  }
}
