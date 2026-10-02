import '../../core/explain.dart';
import '../../core/grid.dart';
import '../../core/value_grid.dart';
import '../../core/value_grid_explain.dart';
import 'mambo_model.dart';
import 'mambo_solver.dart';

final _solvers = Expando<MamboSolver>();

/// Explains Sun & Moon with [MamboSolver]: its direct rules, then probing.
class MamboExplainer extends BinaryGridExplainer<MamboPuzzle> {
  const MamboExplainer();

  MamboSolver _solver(MamboPuzzle p) => _solvers[p] ??= MamboSolver(p.n, p.edges);

  @override
  int get levels => 2;

  @override
  bool probes(int level) => level == 2;

  @override
  List<int> seed(MamboPuzzle p, ValueGrid s) => knownValues(p, s);

  @override
  bool propagate(MamboPuzzle p, List<int> k, int level, ExplainTrace? t) => _solver(p).propagate(k, t);

  @override
  ExplainLine? describe(MamboPuzzle p, Fact f) {
    final pos = p.size.pos;
    String cell(int i) => cellTok(pos(i));
    final a = f.args;
    final v = valTok(f.value), o = valTok(1 - f.value);
    final at = f.slot >= 0 ? cell(f.slot) : '';
    Set<Pos> cells(Iterable<int> idx) => {for (final i in idx) pos(i)};
    final here = {...cells(f.premises), if (f.slot >= 0) pos(f.slot)};
    final n = p.n;
    switch (f.rule) {
      case ruleAssume:
        return ExplainLine((l) => l.exSuppose(at, v), here);
      case ruleRefuted:
        return ExplainLine((l) => l.exRefutedBinary(at, o, v), here);
    }
    switch (MamboRule.values[f.rule]) {
      case MamboRule.pair:
        return ExplainLine((l) => l.exMamboPair(at, v, cell(a[0]), cell(a[1]), o), here);
      case MamboRule.gap:
        return ExplainLine((l) => l.exMamboGap(at, v, cell(a[0]), cell(a[1]), o), here);
      case MamboRule.half:
        final li = a[0];
        return ExplainLine(
          (l) => li < n
              ? l.exMamboHalfRow(at, v, rowTok(li), n ~/ 2, o)
              : l.exMamboHalfCol(at, v, colTok(li - n), n ~/ 2, o),
          here,
        );
      case MamboRule.edge:
        return ExplainLine(
          (l) => a[1] == 1 ? l.exMamboSame(at, v, cell(a[0])) : l.exMamboDiff(at, v, cell(a[0]), o),
          here,
        );
      case MamboRule.failThree:
        return ExplainLine((l) => l.exMamboFailThree(cell(a[0]), cell(a[1]), cell(a[2]), valTok(a[3])), here);
      case MamboRule.failHalf:
        final li = a[0];
        final w = valTok(a[1]);
        return ExplainLine(
          (l) => li < n ? l.exMamboFailHalfRow(rowTok(li), n ~/ 2, w) : l.exMamboFailHalfCol(colTok(li - n), n ~/ 2, w),
          here,
        );
      case MamboRule.failEdge:
        return ExplainLine(
          (l) => a[2] == 1 ? l.exMamboFailSame(cell(a[0]), cell(a[1])) : l.exMamboFailDiff(cell(a[0]), cell(a[1])),
          here,
        );
    }
  }
}
