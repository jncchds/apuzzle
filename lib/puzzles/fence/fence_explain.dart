import '../../core/explain.dart';
import '../../core/grid.dart';
import '../../core/lattice_loop.dart';
import '../../core/loop_explain.dart';
import 'fence_model.dart';
import 'fence_solver.dart';

final _solvers = Expando<FenceSolver>();

/// Explains Fence with [FenceSolver]: the loop's rules and the numbers,
/// then probing edges.
class FenceExplainer extends LoopMarksExplainer<FencePuzzle> {
  const FenceExplainer();

  @override
  FenceSolver solver(FencePuzzle p) => _solvers[p] ??= FenceSolver(p.rows, p.cols, p.numbers);

  @override
  GridSize size(FencePuzzle p) => p.size;

  @override
  List<bool> solutionLines(FencePuzzle p) => p.lines;

  @override
  Set<Pos> cellsOf(FencePuzzle p, int e) => cornerEdgeCells(p.lattice, p.rows, p.cols, e);

  @override
  String edgeTok(FencePuzzle p, int e) => cornerEdgeTok(p.lattice, p.rows, p.cols, e);

  @override
  ExplainLine? describe(FencePuzzle p, Fact f) {
    final loop = describeLoop(p, f);
    if (loop != null || f.rule < loopRuleCount) return loop;
    final s = solver(p);
    final k = f.args[0];
    final clue = p.size.pos(s.clueCells[k]);
    final at = f.slot >= 0 ? cornerEdgeTok(p.lattice, p.rows, p.cols, f.slot, near: clue) : '';
    final here = {clue, if (f.slot >= 0) ...cellsOf(p, f.slot)};
    final c = cellTok(clue);
    return switch (FenceRule.values[f.rule - loopRuleCount]) {
      FenceRule.done => ExplainLine((l) => l.exFenceDone(at, c), here),
      FenceRule.need => ExplainLine((l) => l.exFenceNeed(at, c), here),
      FenceRule.failMany => ExplainLine((l) => l.exFenceFailMany(c), here),
      FenceRule.failFew => ExplainLine((l) => l.exFenceFailFew(c), here),
    };
  }
}
