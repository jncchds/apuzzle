import '../../core/explain.dart';
import '../../core/value_grid.dart';
import '../../core/value_grid_explain.dart';
import 'camp_model.dart';
import 'camp_solver.dart';

final _solvers = Expando<CampSolver>();

/// Explains Campsite with [CampSolver]: counts, touching and trees, then
/// probing. Grass is optional on the board.
class CampExplainer extends BinaryGridExplainer<CampPuzzle> {
  const CampExplainer();

  CampSolver _solver(CampPuzzle p) => _solvers[p] ??= CampSolver(p.rows, p.cols, p.trees, p.rowCounts, p.colCounts);

  @override
  int get levels => 2;

  @override
  bool probes(int level) => level == 2;

  @override
  Set<int> get optionalValues => const {campGrass};

  @override
  List<int> seed(CampPuzzle p, ValueGrid s) {
    final st = _solver(p).initial(givenTents: p.givenTents);
    final known = knownValues(p, s);
    for (var i = 0; i < st.length; i++) {
      if (st[i] == -1 && known[i] >= 0) st[i] = known[i];
    }
    return st;
  }

  @override
  bool propagate(CampPuzzle p, List<int> k, int level, ExplainTrace? t) => _solver(p).propagate(k, t);

  @override
  bool quiet(CampPuzzle p, Fact f) => f.rule == CampRule.nearTent.index;

  @override
  int rank(CampPuzzle p, Fact f) => placed(p, f) == campTent ? 0 : 1;

  @override
  ExplainLine? describe(CampPuzzle p, Fact f) {
    final pos = p.size.pos;
    String cell(int i) => cellTok(pos(i));
    final at = f.slot >= 0 ? cell(f.slot) : '';
    final me = {if (f.slot >= 0) pos(f.slot)};
    final here = {...me, for (final i in f.premises) pos(i)};
    final a = f.args;
    final tent = f.value == campTent;
    // A line as (is it a row, its index).
    String line(int li) => li < p.rows ? rowTok(li) : colTok(li - p.rows);
    final isRow = a.isNotEmpty && a[0] < p.rows;
    switch (f.rule) {
      case ruleAssume:
        return ExplainLine((l) => tent ? l.exCampSupposeTent(at) : l.exCampSupposeGrass(at), me);
      case ruleRefuted:
        return ExplainLine((l) => tent ? l.exCampRefutedGrass(at) : l.exCampRefutedTent(at), me);
    }
    return switch (CampRule.values[f.rule]) {
      CampRule.nearTent => ExplainLine((l) => l.exCampNearTent(at, cell(a[0])), here),
      CampRule.lineDone => ExplainLine(
        (l) => isRow ? l.exCampRowDone(at, line(a[0]), a[1]) : l.exCampColDone(at, line(a[0]), a[1]),
        here,
      ),
      CampRule.lineNeed => ExplainLine(
        (l) => isRow ? l.exCampRowNeed(at, line(a[0]), a[1]) : l.exCampColNeed(at, line(a[0]), a[1]),
        here,
      ),
      CampRule.total => ExplainLine((l) => tent ? l.exCampTotalNeed(at) : l.exCampTotalDone(at), me),
      CampRule.treeOnly => ExplainLine((l) => l.exCampTreeOnly(at, cell(a[0])), here),
      CampRule.failTouch => ExplainLine((l) => l.exCampFailTouch(cell(a[0]), cell(a[1])), here),
      CampRule.failLineMany => ExplainLine(
        (l) => isRow ? l.exCampFailRowMany(line(a[0]), a[1]) : l.exCampFailColMany(line(a[0]), a[1]),
        here,
      ),
      CampRule.failLineFew => ExplainLine(
        (l) => isRow ? l.exCampFailRowFew(line(a[0]), a[1]) : l.exCampFailColFew(line(a[0]), a[1]),
        here,
      ),
      CampRule.failTotal => ExplainLine((l) => l.exCampFailTotal, const {}),
      CampRule.failTree => ExplainLine((l) => l.exCampFailTree(cell(a[0])), here),
      CampRule.failPairing => ExplainLine((l) => l.exCampFailPairing, const {}),
    };
  }
}
