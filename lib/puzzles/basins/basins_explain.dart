import 'dart:math';

import '../../core/explain.dart';
import '../../core/value_grid.dart';
import '../../core/value_grid_explain.dart';
import 'basins_model.dart';
import 'basins_solver.dart';

final _solvers = Expando<BasinsSolver>();

/// Explains Basins with [BasinsSolver]: settling water and counts, then
/// every way to fill a row and every level of a basin, then probing. Dry
/// marks are optional.
class BasinsExplainer extends BinaryGridExplainer<BasinsPuzzle> {
  const BasinsExplainer();

  BasinsSolver _solver(BasinsPuzzle p) => _solvers[p] ??= BasinsSolver.of(p);

  @override
  int get levels => 3;

  @override
  bool probes(int level) => level == 3;

  @override
  Set<int> get optionalValues => const {basinsDry};

  @override
  List<int> seed(BasinsPuzzle p, ValueGrid s) {
    final st = basinsStart(_solver(p), p);
    final known = knownStates(p, s);
    for (var i = 0; i < st.length; i++) {
      if (st[i] == -1 && known[i] >= 0) st[i] = known[i];
    }
    return st;
  }

  @override
  bool propagate(BasinsPuzzle p, List<int> k, int level, ExplainTrace? t) => _solver(p).propagate(k, min(level, 2), t);

  @override
  bool quiet(BasinsPuzzle p, Fact f) => f.rule == BasinsRule.dryAbove.index;

  @override
  int rank(BasinsPuzzle p, Fact f) => placed(p, f) == basinsWater ? 0 : 1;

  @override
  ExplainLine? describe(BasinsPuzzle p, Fact f) {
    final pos = p.size.pos;
    String cell(int i) => cellTok(pos(i));
    final at = f.slot >= 0 ? cell(f.slot) : '';
    final me = {if (f.slot >= 0) pos(f.slot)};
    final wet = f.value == basinsWater;
    switch (f.rule) {
      case ruleAssume:
        return ExplainLine((l) => wet ? l.exBasinsSupposeWater(at) : l.exBasinsSupposeDry(at), me);
      case ruleRefuted:
        return ExplainLine((l) => wet ? l.exBasinsRefutedWater(at) : l.exBasinsRefutedDry(at), me);
    }
    final a = f.args;
    String line(int li) => li < p.rows ? rowTok(li) : colTok(li - p.rows);
    final isRow = a.isNotEmpty && a[0] < p.rows;
    final lineCells = {...me, for (final i in f.premises) pos(i)};
    final basin = {
      for (var i = 0; i < p.regions.length; i++)
        if (f.slot >= 0 && p.regions[i] == p.regions[f.slot]) pos(i),
    };
    return switch (BasinsRule.values[f.rule]) {
      BasinsRule.waterBelow => ExplainLine((l) => l.exBasinsWaterBelow(at, cell(a[0])), {...me, pos(a[0])}),
      BasinsRule.dryAbove => ExplainLine((l) => l.exBasinsDryAbove(at, cell(a[0])), {...me, pos(a[0])}),
      BasinsRule.lineDone => ExplainLine(
        (l) => isRow ? l.exBasinsRowDone(at, line(a[0]), a[1]) : l.exBasinsColDone(at, line(a[0]), a[1]),
        lineCells,
      ),
      BasinsRule.lineNeed => ExplainLine(
        (l) => isRow ? l.exBasinsRowNeed(at, line(a[0]), a[1]) : l.exBasinsColNeed(at, line(a[0]), a[1]),
        lineCells,
      ),
      BasinsRule.tooMuch => ExplainLine(
        (l) =>
            isRow ? l.exBasinsTooMuchRow(at, line(a[0]), a[1], a[2]) : l.exBasinsTooMuchCol(at, line(a[0]), a[1], a[2]),
        {...lineCells, ...basin},
      ),
      BasinsRule.tooLittle => ExplainLine(
        (l) => isRow ? l.exBasinsTooLittleRow(at, line(a[0]), a[1]) : l.exBasinsTooLittleCol(at, line(a[0]), a[1]),
        {...lineCells, ...basin},
      ),
      BasinsRule.lineWays => ExplainLine(
        (l) => wet ? l.exBasinsWaysWater(at, line(a[0]), a[1]) : l.exBasinsWaysDry(at, line(a[0]), a[1]),
        lineCells,
      ),
      BasinsRule.levels => ExplainLine((l) => wet ? l.exBasinsLevelsWater(at) : l.exBasinsLevelsDry(at), basin),
      BasinsRule.failLevel => ExplainLine((l) => l.exBasinsFailLevel(cell(a[0]), cell(a[1])), {pos(a[0]), pos(a[1])}),
      BasinsRule.failLineMany => ExplainLine(
        (l) => isRow ? l.exBasinsFailRowMany(line(a[0]), a[1]) : l.exBasinsFailColMany(line(a[0]), a[1]),
        lineCells,
      ),
      BasinsRule.failLineFew => ExplainLine(
        (l) => isRow ? l.exBasinsFailRowFew(line(a[0]), a[1]) : l.exBasinsFailColFew(line(a[0]), a[1]),
        lineCells,
      ),
      BasinsRule.failWays => ExplainLine((l) => l.exBasinsFailWays(line(a[0]), a[1]), {
        for (final i in basinsLines(p.rows, p.cols)[a[0]]) pos(i),
      }),
      BasinsRule.failLevels => ExplainLine((l) => l.exBasinsFailLevels(cell(a[0])), {
        for (var i = 0; i < p.regions.length; i++)
          if (p.regions[i] == p.regions[a[0]]) pos(i),
      }),
    };
  }
}
