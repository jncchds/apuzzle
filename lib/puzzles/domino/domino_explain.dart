import '../../core/explain.dart';
import '../../core/grid.dart';
import '../../core/lattice_loop.dart';
import '../../core/loop_explain.dart';
import 'domino_model.dart';
import 'domino_solver.dart';

final _solvers = Expando<DominoSolver>();

DominoSolver dominoSolver(DominoPuzzle p) => _solvers[p] ??= DominoSolver.of(p);

/// Explains a domino board with [DominoSolver]: the knowledge is one entry
/// per edge (-1 open, 0 not a domino, 1 a domino). Dominoes are shown before
/// crosses, and crosses next to a placed domino go without saying.
class DominoExplainer extends Explainer<DominoPuzzle, LoopMarks, List<int>> {
  const DominoExplainer();

  @override
  GridSize size(DominoPuzzle p) => p.size;

  @override
  int get levels => 3;

  @override
  bool probes(int level) => level == 3;

  @override
  List<int> seed(DominoPuzzle p, LoopMarks s) {
    final solver = dominoSolver(p);
    final st = solver.start();
    for (var e = 0; e < st.length; e++) {
      if (s.marks[e] == 1 && p.lines[e] && st[e] == -1) solver.line(st, e, null);
    }
    for (var e = 0; e < st.length; e++) {
      if (s.marks[e] == 2 && !p.lines[e] && st[e] == -1) st[e] = 0;
    }
    return st;
  }

  @override
  List<int> copy(List<int> k) => List.of(k);

  @override
  bool propagate(DominoPuzzle p, List<int> k, int level, ExplainTrace? t) =>
      dominoSolver(p).propagate(k, level < 2 ? level : 2, t);

  @override
  Iterable<(int, int)> probeCandidates(DominoPuzzle p, List<int> k) sync* {
    for (var e = 0; e < k.length; e++) {
      if (k[e] == -1) {
        yield (e, 1);
        yield (e, 0);
      }
    }
  }

  @override
  void assume(DominoPuzzle p, List<int> k, int slot, int value, ExplainTrace? t) {
    final solver = dominoSolver(p);
    t?.fact(slot, value, ruleAssume);
    if (value == 1) {
      // The assumption is recorded already; only its follow-ups go to [t].
      solver.line(k, slot, t);
    } else {
      k[slot] = 0;
    }
  }

  @override
  void refute(DominoPuzzle p, List<int> k, int slot, int value, ExplainTrace t) {
    final solver = dominoSolver(p);
    if (value == 0) {
      // Not a domino failed: it is one, with what that covers.
      if (k[slot] == -1) solver.line(k, slot, t);
    } else {
      k[slot] = 0;
    }
  }

  /// The edge state [f] leaves (1 domino, 0 not), or null.
  int? edgeValue(Fact f) => f.slot < 0 || f.rule == ruleAssume ? null : (f.rule == ruleRefuted ? 1 - f.value : f.value);

  /// Whether the board shows that edge [e] is no domino without a cross: a
  /// domino covers one of its cells.
  bool _implied(DominoPuzzle p, LoopMarks s, int e) {
    final g = p.lattice;
    final (a, b) = g.ends(e);
    return [a, b].any((cell) => g.incident[cell].any((f) => f != e && s.marks[f] == 1 && p.lines[f]));
  }

  @override
  LoopMarks? move(DominoPuzzle p, LoopMarks s, Fact f) {
    final v = edgeValue(f);
    if (v == null) return null;
    if (v == 1) {
      if (s.marks[f.slot] == 1) return null;
      return LoopMarks(dominoCommit(p.lattice, s.marks, List.of(s.marks)..[f.slot] = 1));
    }
    if (s.marks[f.slot] == 2 || _implied(p, s, f.slot)) return null;
    return LoopMarks(List.of(s.marks)..[f.slot] = 2);
  }

  @override
  int rank(DominoPuzzle p, Fact f) => edgeValue(f) == 1 ? 0 : 1;

  @override
  bool quiet(DominoPuzzle p, Fact f) => f.rule == DominoRule.covered.index;

  @override
  Set<Pos> targets(DominoPuzzle p, Fact f) => centredEdgeCells(p.lattice, f.slot);

  @override
  Set<int> targetEdges(DominoPuzzle p, Fact f) => {f.slot};

  @override
  (Pos, LoopMarks)? wrongEntry(DominoPuzzle p, LoopMarks s) {
    for (var e = 0; e < s.marks.length; e++) {
      if ((s.marks[e] == 1 && !p.lines[e]) || (s.marks[e] == 2 && p.lines[e])) {
        return (centredEdgeCells(p.lattice, e).first, LoopMarks(List.of(s.marks)..[e] = 0));
      }
    }
    return null;
  }

  @override
  (Pos, LoopMarks)? reveal(DominoPuzzle p, LoopMarks s) {
    for (var e = 0; e < s.marks.length; e++) {
      if (p.lines[e] && s.marks[e] != 1) {
        return (
          centredEdgeCells(p.lattice, e).first,
          LoopMarks(dominoCommit(p.lattice, s.marks, List.of(s.marks)..[e] = 1)),
        );
      }
    }
    return null;
  }

  @override
  bool done(DominoPuzzle p, LoopMarks s) {
    for (var e = 0; e < s.marks.length; e++) {
      if ((s.marks[e] == 1) != p.lines[e]) return false;
    }
    return true;
  }

  @override
  ExplainLine? describe(DominoPuzzle p, Fact f) {
    final g = p.lattice;
    final at = f.slot >= 0 ? centredEdgeTok(g, f.slot) : '';
    final here = {
      if (f.slot >= 0) ...centredEdgeCells(g, f.slot),
    };
    final line = f.value == 1;
    switch (f.rule) {
      case ruleAssume:
        return ExplainLine((l) => line ? l.exDominoSupposeLine(at) : l.exDominoSupposeCross(at), here);
      case ruleRefuted:
        return ExplainLine((l) => line ? l.exDominoRefutedLine(at) : l.exDominoRefutedCross(at), here);
    }
    final a = f.args.isNotEmpty ? valTok(f.args[0]) : '';
    final b = f.args.length > 1 ? valTok(f.args[1]) : '';
    Pos cell(int i) => p.size.pos(i);
    return switch (DominoRule.values[f.rule]) {
      DominoRule.onlySpot => ExplainLine((l) => l.exDominoOnlySpot(a, b, at), here),
      DominoRule.onlyWay => ExplainLine((l) => l.exDominoOnlyWay(cellTok(cell(f.args[0])), at), here),
      DominoRule.covered => ExplainLine((l) => l.exDominoCovered(cellTok(cell(f.args[0])), at), here),
      DominoRule.used => ExplainLine(
        (l) => l.exDominoUsed(a, b, centredEdgeTok(g, f.args[2]), at),
        {...here, ...centredEdgeCells(g, f.args[2])},
      ),
      DominoRule.pairAtCell => ExplainLine(
        (l) => l.exDominoPairAtCell(a, b, cellTok(cell(f.args[2])), at),
        {...here, cell(f.args[2])},
      ),
      DominoRule.cellOnePair => ExplainLine(
        (l) => l.exDominoCellOnePair(a, b, cellTok(cell(f.args[2])), at),
        {...here, cell(f.args[2])},
      ),
      DominoRule.failCell => ExplainLine((l) => l.exDominoFailCell(cellTok(cell(f.args[0]))), {cell(f.args[0])}),
      DominoRule.failPair => ExplainLine((l) => l.exDominoFailPair(a, b), const {}),
      DominoRule.failCellTwice => ExplainLine(
        (l) => l.exDominoFailCellTwice(cellTok(cell(f.args[0]))),
        {cell(f.args[0])},
      ),
      DominoRule.failPairTwice => ExplainLine((l) => l.exDominoFailPairTwice(a, b), const {}),
      DominoRule.failOdd => ExplainLine(
        (l) => l.exDominoFailOdd(cellTok(cell(f.args[0])), f.args[1]),
        {cell(f.args[0])},
      ),
    };
  }
}
