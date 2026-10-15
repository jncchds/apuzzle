import '../../core/explain.dart';
import '../../core/grid.dart';
import '../../core/value_grid.dart';
import '../../core/value_grid_explain.dart';
import 'poles_model.dart';
import 'poles_solver.dart';

final _solvers = Expando<PolesSolver>();

/// Explains Poles with [PolesSolver]: dominoes, neighbours and counts, then
/// every way to fill a line, then probing. Blanks are optional.
class PolesExplainer extends MaskGridExplainer<PolesPuzzle> {
  const PolesExplainer();

  PolesSolver _solver(PolesPuzzle p) => _solvers[p] ??= PolesSolver.of(p);

  @override
  int get levels => 3;

  @override
  bool probes(int level) => level == 3;

  @override
  int get lastCandidateRule => PolesRule.last.index;

  @override
  Set<int> get placingRules => {
    PolesRule.partner.index,
    PolesRule.lineNeed.index,
    PolesRule.chargedDone.index,
    PolesRule.last.index,
  };

  @override
  Set<int> get optionalValues => const {poleBlank};

  @override
  List<int> seed(PolesPuzzle p, ValueGrid s) {
    final known = knownValues(p, s);
    return _solver(p).start({
      for (final g in p.givens) g: p.solution[g],
      for (var i = 0; i < known.length; i++)
        if (known[i] >= 0) i: known[i],
    });
  }

  @override
  bool propagate(PolesPuzzle p, List<int> k, int level, ExplainTrace? t) =>
      _solver(p).propagate(k, level < 2 ? 1 : 2, t);

  @override
  int rank(PolesPuzzle p, Fact f) => placed(p, f) == poleBlank ? 1 : 0;

  /// "Nothing else is left" goes without saying after what ruled the rest out.
  @override
  bool quiet(PolesPuzzle p, Fact f) => f.rule == PolesRule.last.index;

  @override
  ExplainLine? describe(PolesPuzzle p, Fact f) {
    final solver = _solver(p);
    final pos = p.size.pos;
    String cell(int i) => cellTok(pos(i));
    Set<Pos> cells(Iterable<int> idx) => {for (final i in idx) pos(i)};
    final at = f.slot >= 0 ? cell(f.slot) : '';
    final me = {if (f.slot >= 0) pos(f.slot)};
    final value = valTok(f.value);
    switch (f.rule) {
      case ruleAssume:
        return ExplainLine((l) => l.exSuppose(at, value), me);
      case ruleRefuted:
        return ExplainLine((l) => l.exRefuted(at, value), me);
    }
    final a = f.args;
    final isRow = a.isNotEmpty && a[0] < p.rows;
    String line(int li) => li < p.rows ? rowTok(li) : colTok(li - p.rows);
    Set<Pos> lineCells(int li) => {...me, ...cells(solver.lines[li])};
    final plus = valTok(polePlus), minus = valTok(poleMinus);
    return switch (PolesRule.values[f.rule]) {
      PolesRule.partner => ExplainLine(
        (l) => l.exPolesPartner(at, value, cell(a[0]), valTok(poleOpposite(f.value))),
        {...me, pos(a[0])},
      ),
      PolesRule.partnerOut => ExplainLine(
        (l) => l.exPolesPartnerOut(at, value, cell(a[0]), valTok(poleOpposite(f.value))),
        {...me, pos(a[0])},
      ),
      PolesRule.repel => ExplainLine((l) => l.exPolesRepel(at, value, cell(a[0])), {...me, pos(a[0])}),
      // Told once per line: it rules out every other cell of the line.
      PolesRule.lineDone => ExplainLine(
        (l) => isRow ? l.exPolesRowDone(value, line(a[0]), a[1]) : l.exPolesColDone(value, line(a[0]), a[1]),
        lineCells(a[0]),
        (PolesRule.lineDone, a[0], f.value),
      ),
      PolesRule.lineNeed => ExplainLine(
        (l) => isRow ? l.exPolesRowNeed(at, value, line(a[0]), a[1]) : l.exPolesColNeed(at, value, line(a[0]), a[1]),
        lineCells(a[0]),
      ),
      PolesRule.chargedDone => ExplainLine(
        (l) => isRow
            ? l.exPolesRowBlank(at, line(a[0]), a[1], plus, minus)
            : l.exPolesColBlank(at, line(a[0]), a[1], plus, minus),
        lineCells(a[0]),
      ),
      PolesRule.chargedNeed => ExplainLine(
        (l) => isRow
            ? l.exPolesRowCharged(line(a[0]), a[1], plus, minus)
            : l.exPolesColCharged(line(a[0]), a[1], plus, minus),
        lineCells(a[0]),
        (PolesRule.chargedNeed, a[0]),
      ),
      PolesRule.last => ExplainLine((l) => l.exPolesLast(at, value), me),
      PolesRule.fill => ExplainLine(
        (l) => isRow ? l.exPolesRowFill(at, value, line(a[0])) : l.exPolesColFill(at, value, line(a[0])),
        lineCells(a[0]),
      ),
      PolesRule.failEmpty => ExplainLine((l) => l.exPolesFailEmpty(cell(a[0])), {pos(a[0])}),
      PolesRule.failMany => ExplainLine(
        (l) => isRow
            ? l.exPolesFailRowMany(line(a[0]), valTok(a[1]), a[2])
            : l.exPolesFailColMany(line(a[0]), valTok(a[1]), a[2]),
        lineCells(a[0]),
      ),
      PolesRule.failFew => ExplainLine(
        (l) => isRow
            ? l.exPolesFailRowFew(line(a[0]), valTok(a[1]), a[2])
            : l.exPolesFailColFew(line(a[0]), valTok(a[1]), a[2]),
        lineCells(a[0]),
      ),
      PolesRule.failFill => ExplainLine(
        (l) => isRow ? l.exPolesFailRowFill(line(a[0])) : l.exPolesFailColFill(line(a[0])),
        lineCells(a[0]),
      ),
    };
  }
}
