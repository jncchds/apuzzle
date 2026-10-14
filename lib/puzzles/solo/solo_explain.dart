import 'dart:math';

import '../../core/explain.dart';
import '../../core/value_grid.dart';
import '../../core/value_grid_explain.dart';
import 'solo_model.dart';
import 'solo_solver.dart';

final _solvers = Expando<SoloSolver>();

/// Explains Solo with [SoloSolver]: repeats, neighbours, patterns and walled
/// cells, then cuts, then probing. Circles on numbers that stay are optional.
class SoloExplainer extends BinaryGridExplainer<SoloPuzzle> {
  const SoloExplainer();

  SoloSolver _solver(SoloPuzzle p) => _solvers[p] ??= SoloSolver.of(p);

  @override
  int get levels => 3;

  @override
  bool probes(int level) => level == 3;

  @override
  Set<int> get optionalValues => const {soloKeep};

  @override
  List<int> seed(SoloPuzzle p, ValueGrid s) => knownStates(p, s);

  @override
  bool propagate(SoloPuzzle p, List<int> k, int level, ExplainTrace? t) => _solver(p).propagate(k, min(level, 2), t);

  @override
  int rank(SoloPuzzle p, Fact f) => placed(p, f) == soloShade ? 0 : 1;

  @override
  ExplainLine? describe(SoloPuzzle p, Fact f) {
    final pos = p.size.pos;
    String cell(int i) => cellTok(pos(i));
    final at = f.slot >= 0 ? cell(f.slot) : '';
    final me = {if (f.slot >= 0) pos(f.slot)};
    final here = {...me, for (final i in f.premises) pos(i)};
    final keep = f.value == soloKeep;
    switch (f.rule) {
      case ruleAssume:
        return ExplainLine((l) => keep ? l.exSoloSupposeKeep(at) : l.exSoloSupposeShade(at), me);
      case ruleRefuted:
        return ExplainLine((l) => keep ? l.exSoloRefutedShade(at) : l.exSoloRefutedKeep(at), me);
    }
    final a = f.args;
    int digit(int i) => p.digits[i];
    final d = f.slot >= 0 ? digit(f.slot) : (a.isNotEmpty ? digit(a[0]) : 0);
    return switch (SoloRule.values[f.rule]) {
      SoloRule.unique => ExplainLine((l) => l.exSoloUnique(at, d), me),
      SoloRule.lastCopy => ExplainLine((l) => l.exSoloLastCopy(at, d), here),
      SoloRule.twice => ExplainLine(
        (l) => a[0] ~/ p.n == f.slot ~/ p.n
            ? l.exSoloTwiceRow(at, cell(a[0]), d, rowTok(f.slot ~/ p.n))
            : l.exSoloTwiceCol(at, cell(a[0]), d, colTok(f.slot % p.n)),
        here,
      ),
      SoloRule.touch => ExplainLine((l) => l.exSoloTouch(at, cell(a[0])), here),
      SoloRule.shows => ExplainLine((l) => l.exSoloShows(at, cell(a[0]), d), {...me, pos(a[0])}),
      SoloRule.between => ExplainLine((l) => l.exSoloBetween(at, cell(a[0]), cell(a[1]), digit(a[0])), here),
      SoloRule.pair => ExplainLine((l) => l.exSoloPair(at, cell(a[0]), cell(a[1]), d), here),
      SoloRule.walled => ExplainLine((l) => l.exSoloWalled(at, cell(a[0])), here),
      SoloRule.cut => ExplainLine((l) => l.exSoloCut(at), me),
      SoloRule.failTwice => ExplainLine((l) => l.exSoloFailTwice(cell(a[0]), cell(a[1]), d), here),
      SoloRule.failTouch => ExplainLine((l) => l.exSoloFailTouch(cell(a[0]), cell(a[1])), here),
      SoloRule.failLonely => ExplainLine((l) => l.exSoloFailLonely(cell(a[0]), d), here),
      SoloRule.failWalled => ExplainLine((l) => l.exSoloFailWalled(cell(a[0])), here),
      SoloRule.failApart => ExplainLine((l) => l.exSoloFailApart(cell(a[0]), cell(a[1])), {pos(a[0]), pos(a[1])}),
    };
  }
}
