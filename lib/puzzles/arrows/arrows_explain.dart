import '../../core/explain.dart';
import '../../core/grid.dart';
import '../../core/lattice_loop.dart';
import '../../core/loop_explain.dart';
import 'arrows_model.dart';
import 'arrows_solver.dart';

final _solvers = Expando<ArrowsSolver>();

/// Explains Arrows with [ArrowsSolver]. Slots are edges, then cells: edge
/// facts become lines or crosses, cell facts shading or dots. Lines come
/// first; everything else is optional on the board.
class ArrowsExplainer extends Explainer<ArrowsPuzzle, ArrowsState, List<int>> with LoopRuleTexts<ArrowsPuzzle> {
  const ArrowsExplainer();

  ArrowsSolver _solver(ArrowsPuzzle p) => _solvers[p] ??= ArrowsSolver.of(p);

  int _ec(ArrowsPuzzle p) => p.lattice.edgeCount;

  @override
  Set<Pos> cellsOf(ArrowsPuzzle p, int e) => centredEdgeCells(p.lattice, e);

  @override
  String edgeTok(ArrowsPuzzle p, int e) => centredEdgeTok(p.lattice, e);

  @override
  GridSize size(ArrowsPuzzle p) => p.size;

  @override
  int get levels => 2;

  @override
  bool probes(int level) => level == 2;

  @override
  List<int> seed(ArrowsPuzzle p, ArrowsState s) {
    final st = _solver(p).initial();
    final ec = _ec(p);
    for (var e = 0; e < ec; e++) {
      if (st[e] != -1) continue;
      if (s.marks[e] == 1 && p.lines[e]) st[e] = 1;
      if (s.marks[e] == 2 && !p.lines[e]) st[e] = 0;
    }
    for (var i = 0; i < p.rows * p.cols; i++) {
      if (st[ec + i] != -1) continue;
      if (s.cells[i] == arrowsShade && p.shaded[i]) st[ec + i] = 0;
      if (s.cells[i] == arrowsDot && !p.shaded[i]) st[ec + i] = 1;
    }
    return st;
  }

  @override
  List<int> copy(List<int> k) => List.of(k);

  @override
  bool propagate(ArrowsPuzzle p, List<int> k, int level, ExplainTrace? t) => _solver(p).propagate(k, t);

  @override
  Iterable<(int, int)> probeCandidates(ArrowsPuzzle p, List<int> k) sync* {
    // Cells first (the solver probes shading), then edges.
    final ec = _ec(p);
    for (final range in [(ec, k.length), (0, ec)]) {
      for (var s = range.$1; s < range.$2; s++) {
        if (k[s] == -1) {
          yield (s, 0);
          yield (s, 1);
        }
      }
    }
  }

  @override
  void assume(ArrowsPuzzle p, List<int> k, int slot, int value, ExplainTrace? t) {
    k[slot] = value;
    t?.fact(slot, value, ruleAssume);
  }

  @override
  void refute(ArrowsPuzzle p, List<int> k, int slot, int value, ExplainTrace t) => k[slot] = 1 - value;

  int? _value(Fact f) => f.slot < 0 || f.rule == ruleAssume ? null : (f.rule == ruleRefuted ? 1 - f.value : f.value);

  @override
  ArrowsState? move(ArrowsPuzzle p, ArrowsState s, Fact f) {
    final v = _value(f);
    if (v == null) return null;
    final ec = _ec(p);
    if (f.slot < ec) {
      final mark = v == 1 ? 1 : 2;
      if (s.marks[f.slot] == mark) return null;
      return ArrowsState(List.of(s.marks)..[f.slot] = mark, s.cells);
    }
    final i = f.slot - ec, mark = v == 0 ? arrowsShade : arrowsDot;
    if (s.cells[i] == mark || (v == 1 && p.lattice.incident[i].any((e) => s.marks[e] == 1))) return null;
    return ArrowsState(s.marks, List.of(s.cells)..[i] = mark);
  }

  @override
  int rank(ArrowsPuzzle p, Fact f) {
    final edge = f.slot < _ec(p), v = _value(f);
    if (edge) return v == 1 ? 0 : 2;
    return v == 0 ? 1 : 3;
  }

  @override
  Set<Pos> targets(ArrowsPuzzle p, Fact f) {
    final ec = _ec(p);
    return f.slot < ec ? cellsOf(p, f.slot) : {p.size.pos(f.slot - ec)};
  }

  @override
  Set<int> targetEdges(ArrowsPuzzle p, Fact f) => f.slot < _ec(p) ? {f.slot} : const {};

  @override
  (Pos, ArrowsState)? wrongEntry(ArrowsPuzzle p, ArrowsState s) {
    for (var e = 0; e < s.marks.length; e++) {
      if ((s.marks[e] == 1 && !p.lines[e]) || (s.marks[e] == 2 && p.lines[e])) {
        return (cellsOf(p, e).first, ArrowsState(List.of(s.marks)..[e] = 0, s.cells));
      }
    }
    for (var i = 0; i < s.cells.length; i++) {
      if ((s.cells[i] == arrowsShade && !p.shaded[i]) || (s.cells[i] == arrowsDot && p.shaded[i])) {
        return (p.size.pos(i), ArrowsState(s.marks, List.of(s.cells)..[i] = arrowsEmpty));
      }
    }
    return null;
  }

  @override
  (Pos, ArrowsState)? reveal(ArrowsPuzzle p, ArrowsState s) {
    for (var e = 0; e < s.marks.length; e++) {
      if (p.lines[e] && s.marks[e] != 1) return (cellsOf(p, e).first, ArrowsState(List.of(s.marks)..[e] = 1, s.cells));
    }
    return null;
  }

  @override
  bool done(ArrowsPuzzle p, ArrowsState s) {
    for (var e = 0; e < s.marks.length; e++) {
      if ((s.marks[e] == 1) != p.lines[e]) return false;
    }
    return true;
  }

  @override
  ExplainLine? describe(ArrowsPuzzle p, Fact f) {
    final ec = _ec(p);
    final edge = f.slot >= 0 && f.slot < ec;
    final cellSlot = f.slot >= ec;
    String cell(int i) => cellTok(p.size.pos(i));
    final at = cellSlot ? cell(f.slot - ec) : '';
    final me = f.slot < 0 ? <Pos>{} : targets(p, f);
    Set<Pos> slots(Iterable<int> ks) => {
      for (final k in ks)
        if (k < ec) ...cellsOf(p, k) else p.size.pos(k - ec),
    };
    final here = {...me, ...slots(f.premises.take(12))};
    final a = f.args.isEmpty ? -1 : f.args[0];
    if (f.rule == LoopRule.failClash.index && a >= ec) {
      return ExplainLine((l) => l.exArrowsFailClash(cell(a - ec)), slots([a]));
    }
    if (cellSlot && (f.rule == ruleAssume || f.rule == ruleRefuted)) {
      final shade = f.value == 0;
      return ExplainLine(
        (l) => f.rule == ruleAssume
            ? (shade ? l.exArrowsSupposeShade(at) : l.exArrowsSupposeOn(at))
            : (shade ? l.exArrowsRefutedOn(at) : l.exArrowsRefutedShade(at)),
        me,
      );
    }
    final loop = describeLoop(p, f);
    if (loop != null || f.rule < loopRuleCount) return loop;
    final e = edge ? edgeTok(p, f.slot) : '';
    final shade = f.value == 0;
    int count(int c) => p.counts[c];
    return switch (ArrowsRule.values[f.rule - loopRuleCount]) {
      ArrowsRule.cellOn => ExplainLine((l) => l.exArrowsCellOn(at), here),
      ArrowsRule.cellShaded => ExplainLine((l) => l.exArrowsCellShaded(at), here),
      ArrowsRule.shadeNoLine => ExplainLine((l) => l.exArrowsShadeNoLine(e, cell(a)), here),
      ArrowsRule.shadeNeighbours => ExplainLine((l) => l.exArrowsShadeNeighbours(at, cell(a)), here),
      ArrowsRule.onNeed => ExplainLine((l) => l.exArrowsOnNeed(e, cell(a)), here),
      ArrowsRule.clueDone => ExplainLine((l) => l.exArrowsClueDone(at, cell(a), count(a)), here),
      ArrowsRule.clueNeed => ExplainLine(
        (l) => shade ? l.exArrowsClueNeedShade(at, cell(a), count(a)) : l.exArrowsClueNeedOn(at, cell(a), count(a)),
        here,
      ),
      ArrowsRule.failStuck => ExplainLine((l) => l.exArrowsFailStuck(cell(a)), here),
      ArrowsRule.failClueMany => ExplainLine((l) => l.exArrowsFailClueMany(cell(a), count(a)), here),
      ArrowsRule.failClueFew => ExplainLine((l) => l.exArrowsFailClueFew(cell(a), count(a)), here),
    };
  }
}
