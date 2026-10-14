import '../../core/explain.dart';
import '../../core/grid.dart';
import '../../core/latin_square.dart';
import 'signs_model.dart';
import 'signs_solver.dart';

final _solvers = Expando<SignsSolver>();

/// Explains signs with [SignsSolver]: singles and sign bounds, then pairs and
/// runs of signs in a line, then probing.
class SignsExplainer extends LatinExplainer<SignsPuzzle> {
  const SignsExplainer();

  SignsSolver _solver(SignsPuzzle p) => _solvers[p] ??= SignsSolver(p.n, p.signs);

  @override
  int get levels => 3;

  @override
  bool probes(int level) => level == 3;

  @override
  bool propagate(SignsPuzzle p, List<int> k, int level, ExplainTrace? t) => _solver(p).propagate(k, level, t);

  @override
  ExplainLine? describeRule(SignsPuzzle p, Fact f) {
    final n = p.n, sq = LatinSquare.of(n);
    final pos = p.size.pos;
    final at = cellTok(pos(f.slot));
    final a = f.args;
    final v = LatinSquare.digits(f.value).map(valTok).join(', ');
    switch (SignsRule.values[f.rule - latinRuleCount]) {
      case SignsRule.bound:
        final other = cellTok(pos(a[0])), limit = valTok(a[2]);
        return ExplainLine(
          (l) => a[1] == 0 ? l.exSignsLess(at, other, limit, v) : l.exSignsMore(at, other, limit, v),
          {pos(f.slot), pos(a[0])},
        );
      case SignsRule.group:
        final u = a[0], smaller = a[1] == 0;
        final group = [for (final i in a.skip(2)) pos(i)];
        final others = cellsTok(group);
        final Set<Pos> shown = {for (final i in sq.lines[u]) pos(i)};
        if (u < n) {
          final row = rowTok(u);
          return ExplainLine(
            (l) => smaller ? l.exSignsBelowRow(at, others, row, v) : l.exSignsAboveRow(at, others, row, v),
            shown,
          );
        }
        final col = colTok(u - n);
        return ExplainLine(
          (l) => smaller ? l.exSignsBelowCol(at, others, col, v) : l.exSignsAboveCol(at, others, col, v),
          shown,
        );
    }
  }
}
