import '../../core/explain.dart';
import '../../core/grid.dart';
import '../../core/lattice_loop.dart';
import '../../core/loop_explain.dart';
import 'pearls_model.dart';
import 'pearls_solver.dart';

final _solvers = Expando<PearlsSolver>();

/// Explains Pearls with [PearlsSolver]: the loop's rules and the pearls',
/// then probing edges.
class PearlsExplainer extends LoopMarksExplainer<PearlsPuzzle> {
  const PearlsExplainer();

  @override
  PearlsSolver solver(PearlsPuzzle p) => _solvers[p] ??= PearlsSolver(p.rows, p.cols, p.pearls);

  @override
  GridSize size(PearlsPuzzle p) => p.size;

  @override
  List<bool> solutionLines(PearlsPuzzle p) => p.lines;

  @override
  Set<Pos> cellsOf(PearlsPuzzle p, int e) => centredEdgeCells(p.lattice, e);

  @override
  String edgeTok(PearlsPuzzle p, int e) => centredEdgeTok(p.lattice, e);

  @override
  ExplainLine? describe(PearlsPuzzle p, Fact f) {
    final loop = describeLoop(p, f);
    if (loop != null || f.rule < loopRuleCount) return loop;
    final pearl = p.size.pos(f.args[0]);
    final at = f.slot >= 0 ? edgeTok(p, f.slot) : '';
    final here = {pearl, if (f.slot >= 0) ...cellsOf(p, f.slot)};
    final c = cellTok(pearl);
    final line = f.value == 1;
    return switch (PearlsRule.values[f.rule - loopRuleCount]) {
      PearlsRule.pass => ExplainLine((l) => l.exPearlsPass(at, c), here),
      PearlsRule.blackFar => ExplainLine((l) => l.exPearlsBlackFar(at, c), here),
      PearlsRule.blackStraight => ExplainLine(
        (l) => line ? l.exPearlsBlackStraight(at, c) : l.exPearlsBlackThrough(at, c),
        here,
      ),
      PearlsRule.blackTurn => ExplainLine((l) => l.exPearlsBlackTurn(at, c), here),
      PearlsRule.whiteAxis => ExplainLine((l) => line ? l.exPearlsWhiteLine(at, c) : l.exPearlsWhiteCross(at, c), here),
      PearlsRule.whiteTurn => ExplainLine(
        (l) => line ? l.exPearlsWhiteTurnLine(at, c) : l.exPearlsWhiteTurnCross(at, c),
        here,
      ),
      PearlsRule.failPass => ExplainLine((l) => l.exPearlsFailPass(c), here),
    };
  }
}
