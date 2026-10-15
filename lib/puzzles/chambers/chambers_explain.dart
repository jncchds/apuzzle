import 'dart:math';

import '../../core/explain.dart';
import '../../core/grid.dart';
import '../../core/value_grid.dart';
import '../../core/value_grid_explain.dart';
import 'chambers_model.dart';
import 'chambers_solver.dart';

final _solvers = Expando<ChambersSolver>();

/// Explains Chambers with [ChambersSolver]: neighbours, room numbers, runs
/// and walled cells, then every way to shade a room and cuts, then probing.
/// Dots on cells that stay are optional.
class ChambersExplainer extends BinaryGridExplainer<ChambersPuzzle> {
  const ChambersExplainer();

  ChambersSolver _solver(ChambersPuzzle p) => _solvers[p] ??= ChambersSolver(p);

  @override
  int get levels => 3;

  @override
  bool probes(int level) => level == 3;

  @override
  Set<int> get optionalValues => const {chambersKeep};

  @override
  List<int> seed(ChambersPuzzle p, ValueGrid s) => knownStates(p, s);

  @override
  bool propagate(ChambersPuzzle p, List<int> k, int level, ExplainTrace? t) =>
      _solver(p).propagate(k, min(level, 2), t);

  @override
  int rank(ChambersPuzzle p, Fact f) => placed(p, f) == chambersShade ? 0 : 1;

  @override
  ExplainLine? describe(ChambersPuzzle p, Fact f) {
    final pos = p.size.pos;
    String cell(int i) => cellTok(pos(i));
    final at = f.slot >= 0 ? cell(f.slot) : '';
    final me = {if (f.slot >= 0) pos(f.slot)};
    final keep = f.value == chambersKeep;
    switch (f.rule) {
      case ruleAssume:
        return ExplainLine((l) => keep ? l.exSoloSupposeKeep(at) : l.exSoloSupposeShade(at), me);
      case ruleRefuted:
        return ExplainLine((l) => keep ? l.exSoloRefutedShade(at) : l.exSoloRefutedKeep(at), me);
    }
    final a = f.args;
    final here = {...me, for (final i in f.premises) pos(i)};
    String room(int k) {
      final r = p.rooms[k];
      final from = Pos(r.r, r.c), to = Pos(r.r + r.h - 1, r.c + r.w - 1);
      return r.area == 1 ? cellTok(from) : areaTok(from, to);
    }

    Set<Pos> roomCells(int k) => {for (final i in p.rooms[k].cells(p.n)) pos(i)};
    Set<Pos> run(int from, int to) => {
      for (var r = pos(from).r; r <= pos(to).r; r++)
        for (var c = pos(from).c; c <= pos(to).c; c++) Pos(r, c),
    };
    return switch (ChambersRule.values[f.rule]) {
      ChambersRule.touch => ExplainLine((l) => l.exSoloTouch(at, cell(a[0])), here),
      ChambersRule.full => ExplainLine((l) => l.exChambersFull(at, room(a[0]), a[1]), roomCells(a[0])),
      ChambersRule.need => ExplainLine((l) => l.exChambersNeed(at, room(a[0]), a[1]), roomCells(a[0])),
      ChambersRule.span => ExplainLine((l) => l.exChambersSpan(at, cell(a[0]), cell(a[1])), run(a[0], a[1])),
      ChambersRule.walled => ExplainLine((l) => l.exSoloWalled(at, cell(a[0])), here),
      ChambersRule.ways => ExplainLine(
        (l) => keep ? l.exChambersWaysKeep(at, room(a[0]), a[1]) : l.exChambersWaysShade(at, room(a[0]), a[1]),
        {...me, ...roomCells(a[0])},
      ),
      ChambersRule.cut => ExplainLine((l) => l.exSoloCut(at), me),
      ChambersRule.failTouch => ExplainLine((l) => l.exSoloFailTouch(cell(a[0]), cell(a[1])), here),
      ChambersRule.failMany => ExplainLine((l) => l.exChambersFailMany(room(a[0]), a[1]), roomCells(a[0])),
      ChambersRule.failFew => ExplainLine((l) => l.exChambersFailFew(room(a[0]), a[1]), roomCells(a[0])),
      ChambersRule.failSpan => ExplainLine((l) => l.exChambersFailSpan(cell(a[0]), cell(a[1])), run(a[0], a[1])),
      ChambersRule.failWalled => ExplainLine((l) => l.exSoloFailWalled(cell(a[0])), here),
      ChambersRule.failWays => ExplainLine((l) => l.exChambersFailWays(room(a[0]), a[1]), roomCells(a[0])),
      ChambersRule.failApart => ExplainLine(
        (l) => l.exSoloFailApart(cell(a[0]), cell(a[1])),
        {pos(a[0]), pos(a[1])},
      ),
    };
  }
}
