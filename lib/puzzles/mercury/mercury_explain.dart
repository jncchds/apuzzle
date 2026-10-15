import 'dart:math';

import '../../core/explain.dart';
import '../../core/value_grid.dart';
import '../../core/value_grid_explain.dart';
import '../../l10n/app_localizations.dart';
import 'mercury_model.dart';
import 'mercury_solver.dart';

final _solvers = Expando<MercurySolver>();

/// Explains Mercury with [MercurySolver]: filling down to the bulb and
/// counts, then two lines that share tubes counted together, then probing.
/// Empty marks are optional.
class MercuryExplainer extends BinaryGridExplainer<MercuryPuzzle> {
  const MercuryExplainer();

  MercurySolver _solver(MercuryPuzzle p) => _solvers[p] ??= MercurySolver.of(p);

  @override
  int get levels => 3;

  @override
  bool probes(int level) => level == 3;

  @override
  Set<int> get optionalValues => const {mercuryEmpty};

  @override
  List<int> seed(MercuryPuzzle p, ValueGrid s) {
    final st = mercuryStart(_solver(p), p);
    final known = knownStates(p, s);
    for (var i = 0; i < st.length; i++) {
      if (st[i] == -1 && known[i] >= 0) st[i] = known[i];
    }
    return st;
  }

  @override
  bool propagate(MercuryPuzzle p, List<int> k, int level, ExplainTrace? t) => _solver(p).propagate(k, min(level, 2), t);

  @override
  bool quiet(MercuryPuzzle p, Fact f) => f.rule == MercuryRule.pastEmpty.index;

  @override
  int rank(MercuryPuzzle p, Fact f) => placed(p, f) == mercuryFull ? 0 : 1;

  @override
  ExplainLine? describe(MercuryPuzzle p, Fact f) {
    final pos = p.size.pos;
    String cell(int i) => cellTok(pos(i));
    final at = f.slot >= 0 ? cell(f.slot) : '';
    final me = {if (f.slot >= 0) pos(f.slot)};
    final full = f.value == mercuryFull;
    switch (f.rule) {
      case ruleAssume:
        return ExplainLine((l) => full ? l.exMercurySupposeFull(at) : l.exMercurySupposeEmpty(at), me);
      case ruleRefuted:
        return ExplainLine((l) => full ? l.exMercuryRefutedFull(at) : l.exMercuryRefutedEmpty(at), me);
    }
    final a = f.args;
    String line(int li) => li < p.rows ? rowTok(li) : colTok(li - p.rows);
    final isRow = a.isNotEmpty && a[0] < p.rows;
    final lineCells = {...me, for (final i in f.premises) pos(i)};
    final tube = {
      if (f.slot >= 0)
        for (final i in p.tubes[p.tubeOf[f.slot]]) pos(i),
    };
    String pair(AppLocalizations l) {
      if (a[1] < p.rows) return l.exMercuryLinesRows(line(a[0]), line(a[1]));
      if (a[0] >= p.rows) return l.exMercuryLinesCols(line(a[0]), line(a[1]));
      return l.exMercuryLinesRowCol(line(a[0]), line(a[1]));
    }

    return switch (MercuryRule.values[f.rule]) {
      MercuryRule.toBulb => ExplainLine((l) => l.exMercuryToBulb(at, cell(a[0])), {...me, pos(a[0])}),
      MercuryRule.pastEmpty => ExplainLine((l) => l.exMercuryPastEmpty(at, cell(a[0])), {...me, pos(a[0])}),
      MercuryRule.lineDone => ExplainLine(
        (l) => isRow ? l.exMercuryRowDone(at, line(a[0]), a[1]) : l.exMercuryColDone(at, line(a[0]), a[1]),
        lineCells,
      ),
      MercuryRule.lineNeed => ExplainLine(
        (l) => isRow ? l.exMercuryRowNeed(at, line(a[0]), a[1]) : l.exMercuryColNeed(at, line(a[0]), a[1]),
        lineCells,
      ),
      MercuryRule.tooMuch => ExplainLine(
        (l) => isRow
            ? l.exMercuryTooMuchRow(at, line(a[0]), a[1], a[2])
            : l.exMercuryTooMuchCol(at, line(a[0]), a[1], a[2]),
        {...lineCells, ...tube},
      ),
      MercuryRule.tooLittle => ExplainLine(
        (l) => isRow ? l.exMercuryTooLittleRow(at, line(a[0]), a[1]) : l.exMercuryTooLittleCol(at, line(a[0]), a[1]),
        {...lineCells, ...tube},
      ),
      MercuryRule.pair => ExplainLine(
        (l) => full ? l.exMercuryPairFull(at, pair(l)) : l.exMercuryPairEmpty(at, pair(l)),
        {...lineCells, ...tube},
      ),
      MercuryRule.failOrder => ExplainLine((l) => l.exMercuryFailOrder(cell(a[0]), cell(a[1])), {pos(a[0]), pos(a[1])}),
      MercuryRule.failLineMany => ExplainLine(
        (l) => isRow ? l.exMercuryFailRowMany(line(a[0]), a[1]) : l.exMercuryFailColMany(line(a[0]), a[1]),
        lineCells,
      ),
      MercuryRule.failLineFew => ExplainLine(
        (l) => isRow ? l.exMercuryFailRowFew(line(a[0]), a[1]) : l.exMercuryFailColFew(line(a[0]), a[1]),
        lineCells,
      ),
      MercuryRule.failPair => ExplainLine((l) => l.exMercuryFailPair(pair(l)), lineCells),
    };
  }
}
