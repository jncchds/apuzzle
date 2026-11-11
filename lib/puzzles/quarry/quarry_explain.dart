import 'dart:math';

import '../../core/explain.dart';
import '../../core/value_grid.dart';
import '../../core/value_grid_explain.dart';
import 'quarry_model.dart';
import 'quarry_solver.dart';

final _solvers = Expando<QuarrySolver>();

/// [valTok] for stone [k]: the explain panel draws its shape.
String quarryPieceTok(int k) => valTok(quarryPieceToken + k);

/// Explains Quarry with [QuarrySolver]: where each stone still fits (and
/// which shaded cell only it can reach), cells no stone reaches, cells
/// walled off and last ways out, then cut cells and room for the other
/// stones, then probing. Dots on empty cells are optional.
class QuarryExplainer extends BinaryGridExplainer<QuarryPuzzle> {
  const QuarryExplainer();

  QuarrySolver _solver(QuarryPuzzle p) => _solvers[p] ??= QuarrySolver(p);

  @override
  int get levels => 3;

  @override
  bool probes(int level) => level == 3;

  @override
  Set<int> get optionalValues => const {quarryKeep};

  @override
  List<int> seed(QuarryPuzzle p, ValueGrid s) => knownStates(p, s);

  @override
  bool propagate(QuarryPuzzle p, List<int> k, int level, ExplainTrace? t) => _solver(p).propagate(k, min(level, 2), t);

  @override
  int rank(QuarryPuzzle p, Fact f) => placed(p, f) == quarryShade ? 0 : 1;

  @override
  ExplainLine? describe(QuarryPuzzle p, Fact f) {
    final pos = p.size.pos;
    String cell(int i) => cellTok(pos(i));
    final at = f.slot >= 0 ? cell(f.slot) : '';
    final me = {if (f.slot >= 0) pos(f.slot)};
    final shade = f.value == quarryShade;
    switch (f.rule) {
      case ruleAssume:
        return ExplainLine((l) => shade ? l.exSoloSupposeShade(at) : l.exSlabsSupposeKeep(at), me);
      case ruleRefuted:
        return ExplainLine((l) => shade ? l.exSlabsRefutedShade(at) : l.exSlabsRefutedKeep(at), me);
    }
    final a = f.args;
    final here = {...me, for (final i in f.premises) pos(i)};
    String stone() => quarryPieceTok(a[0]);
    return switch (QuarryRule.values[f.rule]) {
      QuarryRule.fits => ExplainLine((l) => l.exQuarryFits(at, stone()), here),
      QuarryRule.beside => ExplainLine((l) => l.exQuarryBeside(at, stone()), here),
      QuarryRule.only => ExplainLine((l) => l.exQuarryOnly(at, stone(), cell(a[1])), here),
      QuarryRule.onlyBeside => ExplainLine((l) => l.exQuarryOnlyBeside(at, stone(), cell(a[1])), here),
      QuarryRule.orphan => ExplainLine((l) => l.exQuarryOrphan(at), here),
      QuarryRule.isolated => ExplainLine((l) => l.exQuarryIsolated(at, cell(a[0])), here),
      QuarryRule.walled => ExplainLine((l) => l.exSoloWalled(at, cell(a[0])), here),
      QuarryRule.cut => ExplainLine((l) => l.exSoloCut(at), here),
      QuarryRule.room => ExplainLine((l) => l.exQuarryRoom(at, stone()), here),
      QuarryRule.roomBeside => ExplainLine((l) => l.exQuarryRoomBeside(at, stone()), here),
      QuarryRule.failNoRoom => ExplainLine((l) => l.exQuarryFailNoRoom(stone()), here),
      QuarryRule.failNoPiece => ExplainLine((l) => l.exQuarryFailNoPiece(cell(a[0])), here),
      QuarryRule.failApart => ExplainLine((l) => l.exSoloFailApart(cell(a[0]), cell(a[1])), here),
    };
  }
}
