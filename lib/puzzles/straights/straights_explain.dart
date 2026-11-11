import '../../core/explain.dart';
import '../../core/grid.dart';
import '../../core/value_grid.dart';
import '../../core/value_grid_explain.dart';
import 'straights_model.dart';
import 'straights_solver.dart';

final _solvers = Expando<StraightsSolver>();

/// Explains a board with [StraightsSolver]: singles and the stretches each
/// run can hold, then pairs, triples and every way to fill a run, then
/// probing.
class StraightsExplainer extends MaskGridExplainer<StraightsPuzzle> {
  const StraightsExplainer();

  StraightsSolver _solver(StraightsPuzzle p) => _solvers[p] ??= StraightsSolver(p);

  @override
  int get levels => 3;

  @override
  bool probes(int level) => level == 3;

  @override
  int get lastCandidateRule => StraightsRule.naked.index;

  @override
  Set<int> get placingRules => {StraightsRule.naked.index, StraightsRule.hidden.index};

  @override
  List<int> seed(StraightsPuzzle p, ValueGrid s) => _solver(
    p,
  ).start([for (final (i, v) in knownValues(p, s).indexed) p.dark[i] || v < 0 ? null : v]);

  @override
  bool propagate(StraightsPuzzle p, List<int> k, int level, ExplainTrace? t) =>
      _solver(p).propagate(k, level > 2 ? 2 : level, t);

  @override
  ExplainLine? describe(StraightsPuzzle p, Fact f) {
    final n = p.n;
    final pos = p.size.pos;
    final lines = straightsLines(n);
    String cell(int i) => cellTok(pos(i));
    Set<Pos> cells(Iterable<int> idx) => {for (final i in idx) pos(i)};
    String values(int mask) => [
      for (var v = 0; v < n; v++)
        if (mask & (1 << v) != 0) valTok(v),
    ].join(', ');
    String run(int x) {
      final c = p.runs[x].cells;
      return c.length == 1 ? cell(c.first) : areaTok(pos(c.first), pos(c.last));
    }

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
    switch (StraightsRule.values[f.rule]) {
      case StraightsRule.ruledOut:
        return null;
      case StraightsRule.naked:
        return ExplainLine((l) => l.exStraightsNaked(at, valTok(f.value)), {
          ...me,
          ...cells(lines[f.slot ~/ n]),
          ...cells(lines[n + f.slot % n]),
        });
      case StraightsRule.range:
        final x = a[0], digits = values(a[1]), gone = values(f.value);
        return ExplainLine((l) => l.exStraightsRange(run(x), digits, at, gone), {...me, ...cells(p.runs[x].cells)});
      case StraightsRule.sure:
        final x = a[0], u = p.runs[x].line, gone = values(f.value);
        return ExplainLine((l) => l.exStraightsSure(run(x), gone, at, name(u), kind(u)), {
          ...me,
          ...cells(p.runs[x].cells),
        });
      case StraightsRule.hidden:
        final x = a[0];
        return ExplainLine((l) => l.exStraightsHidden(at, valTok(f.value), run(x)), cells(p.runs[x].cells));
      case StraightsRule.subset:
        final u = a[0], digits = values(a[1]), group = a.sublist(2), gone = values(f.value);
        return ExplainLine(
          (l) => l.exStraightsSubset(cellsTok(group.map(pos)), digits, at, name(u), kind(u), gone),
          {...me, ...cells(group)},
        );
      case StraightsRule.fill:
        final x = a[0], gone = values(f.value);
        return ExplainLine((l) => l.exStraightsFill(run(x), gone, at), {...me, ...cells(p.runs[x].cells)});
      case StraightsRule.failEmpty:
        return ExplainLine((l) => l.exStraightsFailEmpty(cell(a[0])), {pos(a[0])});
      case StraightsRule.failRun:
        final x = a[0];
        return ExplainLine((l) => l.exStraightsFailRun(run(x)), cells(p.runs[x].cells));
    }
  }
}
