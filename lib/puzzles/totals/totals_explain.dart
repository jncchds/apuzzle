import 'dart:math';

import '../../core/explain.dart';
import '../../core/grid.dart';
import '../../core/value_grid.dart';
import '../../core/value_grid_explain.dart';
import 'totals_model.dart';
import 'totals_solver.dart';

final _solvers = Expando<TotalsSolver>();

/// Explains a board with [TotalsSolver]: digit sets that make each run's
/// sum, then every way to fill a run, then probing.
class TotalsExplainer extends MaskGridExplainer<TotalsPuzzle> {
  const TotalsExplainer();

  TotalsSolver _solver(TotalsPuzzle p) => _solvers[p] ??= TotalsSolver(p);

  @override
  int get levels => 3;

  @override
  bool probes(int level) => level == 3;

  @override
  int get lastCandidateRule => TotalsRule.naked.index;

  @override
  Set<int> get placingRules => {TotalsRule.naked.index, TotalsRule.must.index};

  @override
  List<int> seed(TotalsPuzzle p, ValueGrid s) {
    final known = knownValues(p, s);
    return [
      for (var i = 0; i < known.length; i++)
        if (p.isBlock(i)) 0 else if (known[i] >= 0) 1 << known[i] else totalsFull,
    ];
  }

  @override
  bool propagate(TotalsPuzzle p, List<int> k, int level, ExplainTrace? t) => _solver(p).propagate(k, min(level, 2), t);

  @override
  ExplainLine? describe(TotalsPuzzle p, Fact f) {
    final pos = p.size.pos;
    String cell(int i) => cellTok(pos(i));
    Set<Pos> cells(Iterable<int> idx) => {for (final i in idx) pos(i)};
    String values(int mask) => totalsDigits(mask).map(valTok).join(', ');
    final at = f.slot >= 0 ? cell(f.slot) : '';
    final me = {if (f.slot >= 0) pos(f.slot)};
    switch (f.rule) {
      case ruleAssume:
        return ExplainLine((l) => l.exSuppose(at, valTok(f.value)), me);
      case ruleRefuted:
        return ExplainLine((l) => l.exRefuted(at, valTok(f.value)), me);
    }
    final a = f.args;
    final rule = TotalsRule.values[f.rule];
    if (rule == TotalsRule.naked) return ExplainLine((l) => l.exTotalsNaked(at, valTok(f.value)), me);
    if (rule == TotalsRule.failEmpty) return ExplainLine((l) => l.exTotalsFailEmpty(cell(a[0])), {pos(a[0])});
    final run = p.runs[a[0]];
    final sum = '${run.sum}', where = areaTok(pos(run.cells.first), pos(run.cells.last));
    final runCells = cells(run.cells);
    return switch (rule) {
      TotalsRule.ruledOut || TotalsRule.naked || TotalsRule.failEmpty => null,
      TotalsRule.combo => () {
        final can = values(a[1]), gone = values(f.value);
        return ExplainLine((l) => l.exTotalsCombo(sum, where, can, at, gone), runCells);
      }(),
      TotalsRule.must => ExplainLine((l) => l.exTotalsMust(sum, where, valTok(f.value), at), runCells),
      TotalsRule.fill => () {
        final gone = values(f.value);
        return ExplainLine((l) => l.exTotalsFill(sum, where, gone, at), runCells);
      }(),
      TotalsRule.failRun => ExplainLine((l) => l.exTotalsFailRun(sum, where), runCells),
    };
  }
}
