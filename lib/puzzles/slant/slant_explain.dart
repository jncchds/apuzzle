import '../../core/explain.dart';
import '../../core/grid.dart';
import '../../core/value_grid.dart';
import '../../core/value_grid_explain.dart';
import 'slant_model.dart';
import 'slant_solver.dart';

final _solvers = Expando<SlantSolver>();

/// Explains Twigs with [SlantSolver]: numbers that are done or need every
/// cell left, diagonals that would close a loop, then two neighbouring
/// numbers together, then probing.
class SlantExplainer extends BinaryGridExplainer<SlantPuzzle> {
  const SlantExplainer();

  SlantSolver _solver(SlantPuzzle p) => _solvers[p] ??= SlantSolver(p);

  @override
  int get levels => 3;

  @override
  bool probes(int level) => level == 3;

  @override
  List<int> seed(SlantPuzzle p, ValueGrid s) => knownStates(p, s);

  @override
  bool propagate(SlantPuzzle p, List<int> k, int level, ExplainTrace? t) => _solver(p).propagate(k, level, t);

  @override
  ExplainLine? describe(SlantPuzzle p, Fact f) {
    final g = p.geo;
    final pos = p.size.pos;
    Set<Pos> cells(Iterable<int> idx) => {for (final i in idx) pos(i)};
    String corner(int k) {
      final (cell, which) = g.cornerOf(k);
      return cornerTok(cell, which);
    }

    Set<Pos> around(int k) => cells([for (final (i, _) in g.cornerCells[k]) i]);
    final at = f.slot >= 0 ? cellTok(pos(f.slot)) : '';
    final me = {if (f.slot >= 0) pos(f.slot)};
    final diag = valTok(f.value);
    final a = f.args;
    switch (f.rule) {
      case ruleAssume:
        return ExplainLine((l) => l.exSlantSuppose(at, diag), me);
      case ruleRefuted:
        final other = valTok(1 - f.value);
        return ExplainLine((l) => l.exSlantRefuted(at, other), me);
    }
    switch (SlantRule.values[f.rule]) {
      case SlantRule.done:
        return ExplainLine((l) => l.exSlantDone(at, diag, corner(a[0]), p.clues[a[0]]), {...me, ...around(a[0])});
      case SlantRule.need:
        return ExplainLine((l) => l.exSlantNeed(at, diag, corner(a[0]), p.clues[a[0]]), {...me, ...around(a[0])});
      case SlantRule.loop:
        return ExplainLine((l) => l.exSlantLoop(at, diag, cellsTok(cells(a))), {...me, ...cells(a)});
      case SlantRule.pair:
        return ExplainLine(
          (l) => l.exSlantPair(at, diag, corner(a[0]), corner(a[1])),
          {...me, ...around(a[0]), ...around(a[1])},
        );
      case SlantRule.failClue:
        return ExplainLine((l) => l.exSlantFailClue(corner(a[0]), p.clues[a[0]]), around(a[0]));
      case SlantRule.failLoop:
        return ExplainLine((l) => l.exSlantFailLoop(cellsTok(cells(f.premises))), cells(f.premises));
      case SlantRule.failStuck:
        return ExplainLine((l) => l.exSlantFailStuck(cellTok(pos(a[0]))), {pos(a[0]), ...cells(f.premises)});
      case SlantRule.failPair:
        return ExplainLine(
          (l) => l.exSlantFailPair(corner(a[0]), corner(a[1])),
          {...around(a[0]), ...around(a[1])},
        );
    }
  }
}
