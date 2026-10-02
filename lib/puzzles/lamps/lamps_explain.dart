import '../../core/explain.dart';
import '../../core/value_grid.dart';
import '../../core/value_grid_explain.dart';
import 'lamps_model.dart';
import 'lamps_solver.dart';

final _solvers = Expando<LampsSolver>();

/// Explains Lamps with [LampsSolver]: lit cells, wall numbers and single
/// light sources, then probing. Dots are optional on the board.
class LampsExplainer extends BinaryGridExplainer<LampsPuzzle> {
  const LampsExplainer();

  LampsSolver _solver(LampsPuzzle p) => _solvers[p] ??= LampsSolver(p.rows, p.cols, p.walls, p.numbers);

  @override
  int get levels => 2;

  @override
  bool probes(int level) => level == 2;

  @override
  Set<int> get optionalValues => const {lampsDot};

  @override
  List<int> seed(LampsPuzzle p, ValueGrid s) {
    final st = _solver(p).initial();
    final known = knownValues(p, s);
    for (var i = 0; i < st.length; i++) {
      if (st[i] == -1 && known[i] >= 0) st[i] = known[i];
    }
    return st;
  }

  @override
  bool propagate(LampsPuzzle p, List<int> k, int level, ExplainTrace? t) => _solver(p).propagate(k, t);

  @override
  bool quiet(LampsPuzzle p, Fact f) => f.rule == LampsRule.lit.index;

  @override
  int rank(LampsPuzzle p, Fact f) => placed(p, f) == lampsLamp ? 0 : 1;

  @override
  ExplainLine? describe(LampsPuzzle p, Fact f) {
    final pos = p.size.pos;
    String cell(int i) => cellTok(pos(i));
    final at = f.slot >= 0 ? cell(f.slot) : '';
    final me = {if (f.slot >= 0) pos(f.slot)};
    final here = {...me, for (final i in f.premises) pos(i)};
    final a = f.args;
    final lamp = f.value == lampsLamp;
    switch (f.rule) {
      case ruleAssume:
        return ExplainLine((l) => lamp ? l.exLampsSupposeLamp(at) : l.exLampsSupposeDot(at), me);
      case ruleRefuted:
        return ExplainLine((l) => lamp ? l.exLampsRefutedDot(at) : l.exLampsRefutedLamp(at), me);
    }
    return switch (LampsRule.values[f.rule]) {
      LampsRule.lit => ExplainLine((l) => l.exLampsLit(at, cell(a[0])), here),
      LampsRule.wallDone => ExplainLine((l) => l.exLampsWallDone(at, cell(a[0])), here),
      LampsRule.wallNeed => ExplainLine((l) => l.exLampsWallNeed(at, cell(a[0])), here),
      LampsRule.onlySource => ExplainLine(
        (l) => a[0] == f.slot ? l.exLampsSelf(at) : l.exLampsOnlySource(at, cell(a[0])),
        here,
      ),
      LampsRule.failSee => ExplainLine((l) => l.exLampsFailSee(cell(a[0]), cell(a[1])), here),
      LampsRule.failMany => ExplainLine((l) => l.exLampsFailMany(cell(a[0])), here),
      LampsRule.failFew => ExplainLine((l) => l.exLampsFailFew(cell(a[0])), here),
      LampsRule.failDark => ExplainLine((l) => l.exLampsFailDark(cell(a[0])), here),
    };
  }
}
