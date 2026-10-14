import 'dart:math';

import '../../core/explain.dart';
import '../../core/value_grid.dart';
import '../../core/value_grid_explain.dart';
import 'fleet_model.dart';
import 'fleet_solver.dart';

final _solvers = Expando<FleetSolver>();

/// Explains Fleet with [FleetSolver]: pieces, diagonals, counts and lengths,
/// then where the missing ships fit, then probing. Water is optional.
class FleetExplainer extends BinaryGridExplainer<FleetPuzzle> {
  const FleetExplainer();

  FleetSolver _solver(FleetPuzzle p) => _solvers[p] ??= FleetSolver.of(p);

  @override
  int get levels => 3;

  @override
  bool probes(int level) => level == 3;

  @override
  Set<int> get optionalValues => const {fleetWater};

  @override
  List<int> seed(FleetPuzzle p, ValueGrid s) {
    final st = fleetStart(_solver(p), p);
    final known = knownStates(p, s);
    for (var i = 0; i < st.length; i++) {
      if (st[i] == -1 && known[i] >= 0) st[i] = known[i];
    }
    return st;
  }

  @override
  bool propagate(FleetPuzzle p, List<int> k, int level, ExplainTrace? t) => _solver(p).propagate(k, min(level, 2), t);

  @override
  bool quiet(FleetPuzzle p, Fact f) => f.rule == FleetRule.diagonal.index || f.rule == FleetRule.pieceWater.index;

  @override
  int rank(FleetPuzzle p, Fact f) => placed(p, f) == fleetShip ? 0 : 1;

  @override
  ExplainLine? describe(FleetPuzzle p, Fact f) {
    final pos = p.size.pos;
    String cell(int i) => cellTok(pos(i));
    final at = f.slot >= 0 ? cell(f.slot) : '';
    final me = {if (f.slot >= 0) pos(f.slot)};
    final ship = f.value == fleetShip;
    switch (f.rule) {
      case ruleAssume:
        return ExplainLine((l) => ship ? l.exFleetSupposeShip(at) : l.exFleetSupposeWater(at), me);
      case ruleRefuted:
        return ExplainLine((l) => ship ? l.exFleetRefutedShip(at) : l.exFleetRefutedWater(at), me);
    }
    final a = f.args;
    String line(int li) => li < p.rows ? rowTok(li) : colTok(li - p.rows);
    final isRow = a.isNotEmpty && a[0] < p.rows;
    final other = {...me, if (a.isNotEmpty && a[0] < p.ships.length) pos(a[0])};
    final lineCells = {...me, for (final i in f.premises) pos(i)};
    return switch (FleetRule.values[f.rule]) {
      FleetRule.pieceShip => ExplainLine((l) => l.exFleetPieceShip(at, cell(a[0])), other),
      FleetRule.pieceWater => ExplainLine((l) => l.exFleetPieceWater(at, cell(a[0])), other),
      FleetRule.middle => ExplainLine((l) => l.exFleetMiddle(at, cell(a[0])), other),
      FleetRule.diagonal => ExplainLine((l) => l.exFleetDiagonal(at, cell(a[0])), other),
      FleetRule.lineDone => ExplainLine(
        (l) => isRow ? l.exFleetRowDone(at, line(a[0]), a[1]) : l.exFleetColDone(at, line(a[0]), a[1]),
        lineCells,
      ),
      FleetRule.lineNeed => ExplainLine(
        (l) => isRow ? l.exFleetRowNeed(at, line(a[0]), a[1]) : l.exFleetColNeed(at, line(a[0]), a[1]),
        lineCells,
      ),
      FleetRule.allFound => ExplainLine((l) => l.exFleetAllFound(at), me),
      FleetRule.longest => ExplainLine((l) => l.exFleetLongest(at, cell(a[0]), a[1]), other),
      FleetRule.tooLong => ExplainLine((l) => l.exFleetTooLong(at, a[0]), me),
      FleetRule.noFit => ExplainLine((l) => l.exFleetNoFit(at), me),
      FleetRule.extend => ExplainLine((l) => l.exFleetExtend(at, cell(a[0])), other),
      FleetRule.mustCover => ExplainLine((l) => l.exFleetMustCover(at, a[0]), me),
      FleetRule.onlySpots => ExplainLine((l) => l.exFleetOnlySpots(at, a[0]), me),
      FleetRule.failTouch => ExplainLine((l) => l.exFleetFailTouch(cell(a[0]), cell(a[1])), {pos(a[0]), pos(a[1])}),
      FleetRule.failLineMany => ExplainLine(
        (l) => isRow ? l.exFleetFailRowMany(line(a[0]), a[1]) : l.exFleetFailColMany(line(a[0]), a[1]),
        lineCells,
      ),
      FleetRule.failLineFew => ExplainLine(
        (l) => isRow ? l.exFleetFailRowFew(line(a[0]), a[1]) : l.exFleetFailColFew(line(a[0]), a[1]),
        lineCells,
      ),
      FleetRule.failPiece => ExplainLine((l) => l.exFleetFailPiece(cell(a[0])), {pos(a[0])}),
      FleetRule.failLong => ExplainLine((l) => l.exFleetFailLong(cell(a[0]), a[1]), {pos(a[0])}),
      FleetRule.failFleet => ExplainLine((l) => l.exFleetFailFleet(a[0]), const {}),
      FleetRule.failNoRoom => ExplainLine((l) => l.exFleetFailNoRoom(a[0]), const {}),
      FleetRule.failStray => ExplainLine((l) => l.exFleetFailStray(cell(a[0])), {pos(a[0])}),
    };
  }
}
