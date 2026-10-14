import '../../core/explain.dart';
import '../../core/grid.dart';
import '../../core/latin_square.dart';
import 'skyline_model.dart';
import 'skyline_solver.dart';

final _solvers = Expando<SkylineSolver>();

/// Explains Skyline with [SkylineSolver]: singles and what each clue allows,
/// then pairs and every way to fill a clued line, then probing.
class SkylineExplainer extends LatinExplainer<SkylinePuzzle> {
  const SkylineExplainer();

  SkylineSolver _solver(SkylinePuzzle p) => _solvers[p] ??= SkylineSolver(p.n, p.clues);

  @override
  int get levels => 3;

  @override
  bool probes(int level) => level == 3;

  @override
  Set<int> get placingTypeRules => {SkylineRule.tallest.id};

  @override
  bool propagate(SkylinePuzzle p, List<int> k, int level, ExplainTrace? t) => _solver(p).propagate(k, level, t);

  @override
  ExplainLine? describeRule(SkylinePuzzle p, Fact f) {
    final n = p.n, sq = LatinSquare.of(n);
    final pos = p.size.pos;
    Set<Pos> cells(Iterable<int> idx) => {for (final i in idx) pos(i)};
    final at = cellTok(pos(f.slot.clamp(0, n * n - 1)));
    final a = f.args;
    String side(int side, int k) => sideTok(pos(skylineLine(n, side, k).first), side);
    switch (SkylineRule.values[f.rule - latinRuleCount]) {
      case SkylineRule.bound:
        final clue = a[2], max = valTok(a[3]), from = side(a[0], a[1]);
        return ExplainLine((l) => l.exSkylineBound(clue, from, at, max), cells(skylineLine(n, a[0], a[1])));
      case SkylineRule.tallest:
        final from = side(a[0], a[1]);
        return ExplainLine((l) => l.exSkylineTallest(at, valTok(n - 1), from), cells(skylineLine(n, a[0], a[1])));
      case SkylineRule.line:
        final u = a[0], v = valTok(LatinSquare.digitOf(f.value));
        return ExplainLine(
          (l) => u < n ? l.exSkylineLineRow(at, v, rowTok(u)) : l.exSkylineLineCol(at, v, colTok(u - n)),
          cells(sq.lines[u]),
        );
      case SkylineRule.failLine:
        final u = a[0];
        return ExplainLine(
          (l) => u < n ? l.exSkylineFailRow(rowTok(u)) : l.exSkylineFailCol(colTok(u - n)),
          cells(sq.lines[u]),
        );
    }
  }
}
