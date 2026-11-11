import '../../core/explain.dart';
import '../../core/grid.dart';
import '../../core/value_grid.dart';
import '../../core/value_grid_explain.dart';
import 'between_model.dart';
import 'between_solver.dart';

final _solvers = Expando<BetweenSolver>();

/// Explains a board with [BetweenSolver]: singles, where the clues let the
/// shaded cells lie and which numbers go between them, then every way to
/// fill a line, then probing.
class BetweenExplainer extends MaskGridExplainer<BetweenPuzzle> {
  const BetweenExplainer();

  BetweenSolver _solver(BetweenPuzzle p) => _solvers[p] ??= BetweenSolver(p.n, p.clues);

  @override
  int get levels => 3;

  @override
  bool probes(int level) => level == 3;

  @override
  int get lastCandidateRule => BetweenRule.naked.index;

  @override
  Set<int> get placingRules => {BetweenRule.naked.index, BetweenRule.hidden.index, BetweenRule.shadePair.index};

  @override
  List<int> seed(BetweenPuzzle p, ValueGrid s) =>
      _solver(p).start([for (final v in knownValues(p, s)) v < 0 ? null : v]);

  @override
  bool propagate(BetweenPuzzle p, List<int> k, int level, ExplainTrace? t) =>
      _solver(p).propagate(k, level > 2 ? 2 : level, t);

  @override
  ExplainLine? describe(BetweenPuzzle p, Fact f) {
    final n = p.n;
    final pos = p.size.pos;
    final lines = betweenLines(n);
    String cell(int i) => cellTok(pos(i));
    Set<Pos> cells(Iterable<int> idx) => {for (final i in idx) pos(i)};
    String values(int mask) => [
      for (var v = 0; v < n - 1; v++)
        if (mask & (1 << v) != 0) valTok(v),
    ].join(', ');
    final at = f.slot >= 0 ? cell(f.slot) : '';
    final me = {if (f.slot >= 0) pos(f.slot)};
    switch (f.rule) {
      case ruleAssume:
        return ExplainLine((l) => l.exSuppose(at, valTok(f.value)), me);
      case ruleRefuted:
        return ExplainLine((l) => l.exRefuted(at, valTok(f.value)), me);
    }
    final a = f.args;
    String kind(int u) => u < n ? 'row' : 'col';
    String name(int u) => u < n ? rowTok(u) : colTok(u - n);
    switch (BetweenRule.values[f.rule]) {
      case BetweenRule.ruledOut:
        if (f.value != 1 || f.premises.length != 2) return null;
        final x = f.premises[0], y = f.premises[1];
        final u = x ~/ n == y ~/ n ? x ~/ n : n + x % n;
        return ExplainLine((l) => l.exBetweenTwoShaded(at, name(u), kind(u)), cells(lines[u]));
      case BetweenRule.naked:
        return ExplainLine((l) => l.exBetweenNaked(at, valTok(f.value)), {
          ...me,
          ...cells(lines[f.slot ~/ n]),
          ...cells(lines[n + f.slot % n]),
        });
      case BetweenRule.hidden:
        final u = a[0];
        return ExplainLine((l) => l.exBetweenHidden(at, valTok(f.value), name(u), kind(u)), cells(lines[u]));
      case BetweenRule.shadePair:
        final u = a[0];
        return ExplainLine((l) => l.exBetweenShadePair(at, name(u), kind(u)), cells(lines[u]));
      case BetweenRule.span:
        final u = a[0], sum = '${a[1]}';
        return ExplainLine((l) => l.exBetweenSpan(at, name(u), kind(u), sum), cells(lines[u]));
      case BetweenRule.sumOut:
        final u = a[0], sum = '${a[1]}', can = values(a[2]), gone = values(f.value);
        return ExplainLine((l) => l.exBetweenSumOut(name(u), kind(u), sum, can, at, gone), cells(lines[u]));
      case BetweenRule.sumIn:
        final u = a[0], sum = '${a[1]}', gone = values(f.value);
        return ExplainLine((l) => l.exBetweenSumIn(name(u), kind(u), sum, at, gone), cells(lines[u]));
      case BetweenRule.line:
        final u = a[0], sum = '${a[1]}', gone = values(f.value);
        return ExplainLine((l) => l.exBetweenLine(name(u), kind(u), sum, at, gone), cells(lines[u]));
      case BetweenRule.failEmpty:
        return ExplainLine((l) => l.exBetweenFailEmpty(cell(a[0])), {pos(a[0])});
      case BetweenRule.failNoPlace:
        final d = valTok(a[0]), u = a[1];
        return ExplainLine((l) => l.exBetweenFailNoPlace(d, name(u), kind(u)), cells(lines[u]));
      case BetweenRule.failShade:
        final u = a[0];
        return ExplainLine((l) => l.exBetweenFailShade(name(u), kind(u)), cells(lines[u]));
      case BetweenRule.failLine:
        final u = a[0], sum = '${a[1]}';
        return ExplainLine((l) => l.exBetweenFailLine(name(u), kind(u), sum), cells(lines[u]));
    }
  }
}
