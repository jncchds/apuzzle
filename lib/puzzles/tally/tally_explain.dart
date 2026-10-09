import 'dart:math';

import '../../core/explain.dart';
import '../../core/value_grid.dart';
import '../../core/value_grid_explain.dart';
import 'tally_model.dart';
import 'tally_solver.dart';

final _solvers = Expando<TallySolver>();

/// Explains Tally with [TallySolver]: digits too big or needed, then every
/// way to make a sum, then probing. Circles on kept digits are optional.
class TallyExplainer extends BinaryGridExplainer<TallyPuzzle> {
  const TallyExplainer();

  TallySolver _solver(TallyPuzzle p) => _solvers[p] ??= TallySolver.of(p);

  @override
  int get levels => 3;

  @override
  bool probes(int level) => level == 3;

  @override
  Set<int> get optionalValues => const {tallyKeep};

  @override
  List<int> seed(TallyPuzzle p, ValueGrid s) => knownStates(p, s);

  @override
  bool propagate(TallyPuzzle p, List<int> k, int level, ExplainTrace? t) => _solver(p).propagate(k, min(level, 2), t);

  @override
  ExplainLine? describe(TallyPuzzle p, Fact f) {
    final pos = p.size.pos;
    final at = f.slot >= 0 ? cellTok(pos(f.slot)) : '';
    final me = {if (f.slot >= 0) pos(f.slot)};
    final here = {...me, for (final i in f.premises) pos(i)};
    final keep = f.value == tallyKeep;
    switch (f.rule) {
      case ruleAssume:
        return ExplainLine((l) => keep ? l.exTallySupposeKeep(at) : l.exTallySupposeCross(at), me);
      case ruleRefuted:
        return ExplainLine((l) => keep ? l.exTallyRefutedCross(at) : l.exTallyRefutedKeep(at), me);
    }
    final li = f.args[0], x = f.args[1];
    final isRow = li < p.rows;
    final line = isRow ? rowTok(li) : colTok(li - p.rows);
    final digit = f.slot >= 0 ? p.digits[f.slot] : 0;
    return switch (TallyRule.values[f.rule]) {
      TallyRule.tooBig => ExplainLine(
        (l) => isRow ? l.exTallyRowTooBig(at, line, digit, x) : l.exTallyColTooBig(at, line, digit, x),
        here,
      ),
      TallyRule.needed => ExplainLine(
        (l) => isRow ? l.exTallyRowNeeded(at, line, digit, x) : l.exTallyColNeeded(at, line, digit, x),
        here,
      ),
      TallyRule.everyWay => ExplainLine(
        (l) => switch ((isRow, keep)) {
          (true, true) => l.exTallyRowEveryKeep(at, line, x),
          (true, false) => l.exTallyRowEveryCross(at, line, x),
          (false, true) => l.exTallyColEveryKeep(at, line, x),
          (false, false) => l.exTallyColEveryCross(at, line, x),
        },
        here,
      ),
      TallyRule.failOver => ExplainLine(
        (l) => isRow ? l.exTallyFailRowOver(line, x) : l.exTallyFailColOver(line, x),
        here,
      ),
      TallyRule.failShort => ExplainLine(
        (l) => isRow ? l.exTallyFailRowShort(line, x) : l.exTallyFailColShort(line, x),
        here,
      ),
      TallyRule.failNoWay => ExplainLine(
        (l) => isRow ? l.exTallyFailRowNoWay(line, x) : l.exTallyFailColNoWay(line, x),
        here,
      ),
    };
  }
}
