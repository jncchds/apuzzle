import 'explain.dart';
import 'grid.dart';
import 'lattice_loop.dart';

/// [Explainer] for loops drawn on [LoopMarks] (0 empty, 1 line, 2 cross),
/// solved by a [LoopSolver]: the knowledge is the solver's edge list.
/// Lines are shown before crosses, and crosses are optional.
abstract class LoopMarksExplainer<P> extends Explainer<P, LoopMarks, List<int>> with LoopRuleTexts<P> {
  const LoopMarksExplainer();

  LoopSolver solver(P p);

  /// The solution's lines per edge.
  List<bool> solutionLines(P p);

  @override
  int get levels => 2;

  @override
  bool probes(int level) => level == 2;

  @override
  List<int> seed(P p, LoopMarks s) {
    final st = solver(p).initial();
    final sol = solutionLines(p);
    for (var e = 0; e < st.length; e++) {
      if (st[e] != -1) continue;
      if (s.marks[e] == 1 && sol[e]) st[e] = 1;
      if (s.marks[e] == 2 && !sol[e]) st[e] = 0;
    }
    return st;
  }

  @override
  List<int> copy(List<int> k) => List.of(k);

  @override
  bool propagate(P p, List<int> k, int level, ExplainTrace? t) => solver(p).propagate(k, t);

  @override
  Iterable<(int, int)> probeCandidates(P p, List<int> k) sync* {
    for (var e = 0; e < k.length; e++) {
      if (k[e] == -1) {
        yield (e, 1);
        yield (e, 0);
      }
    }
  }

  @override
  void assume(P p, List<int> k, int slot, int value, ExplainTrace? t) {
    k[slot] = value;
    t?.fact(slot, value, ruleAssume);
  }

  @override
  void refute(P p, List<int> k, int slot, int value, ExplainTrace t) => k[slot] = 1 - value;

  /// The edge state [f] leaves (1 line, 0 cross), or null.
  int? edgeValue(Fact f) => f.slot < 0 || f.rule == ruleAssume ? null : (f.rule == ruleRefuted ? 1 - f.value : f.value);

  @override
  LoopMarks? move(P p, LoopMarks s, Fact f) {
    final v = edgeValue(f);
    if (v == null || f.slot >= s.marks.length) return null;
    final mark = v == 1 ? 1 : 2;
    if (s.marks[f.slot] == mark) return null;
    return LoopMarks(List.of(s.marks)..[f.slot] = mark);
  }

  @override
  int rank(P p, Fact f) => edgeValue(f) == 1 ? 0 : 1;

  @override
  Set<Pos> targets(P p, Fact f) => cellsOf(p, f.slot);

  @override
  Set<int> targetEdges(P p, Fact f) => {f.slot};

  @override
  (Pos, LoopMarks)? wrongEntry(P p, LoopMarks s) {
    final sol = solutionLines(p);
    for (var e = 0; e < s.marks.length; e++) {
      if ((s.marks[e] == 1 && !sol[e]) || (s.marks[e] == 2 && sol[e])) {
        return (cellsOf(p, e).first, LoopMarks(List.of(s.marks)..[e] = 0));
      }
    }
    return null;
  }

  @override
  (Pos, LoopMarks)? reveal(P p, LoopMarks s) {
    final sol = solutionLines(p);
    for (var e = 0; e < s.marks.length; e++) {
      if (sol[e] && s.marks[e] != 1) return (cellsOf(p, e).first, LoopMarks(List.of(s.marks)..[e] = 1));
    }
    return null;
  }

  @override
  bool done(P p, LoopMarks s) {
    final sol = solutionLines(p);
    for (var e = 0; e < s.marks.length; e++) {
      if ((s.marks[e] == 1) != sol[e]) return false;
    }
    return true;
  }
}

/// Texts for [LoopRule]s and edge assumptions, for explainers of loops.
mixin LoopRuleTexts<P> {
  /// Cells next to (or joined by) edge [e].
  Set<Pos> cellsOf(P p, int e);

  /// Edge [e] as a text token ([sideTok] or [linkTok]).
  String edgeTok(P p, int e);

  /// Texts for the loop's own rules ([LoopRule], assumptions); null for a
  /// puzzle rule.
  ExplainLine? describeLoop(P p, Fact f) {
    final at = f.slot >= 0 ? edgeTok(p, f.slot) : '';
    final here = {
      if (f.slot >= 0) ...cellsOf(p, f.slot),
      for (final e in f.premises.take(8)) ...cellsOf(p, e),
    };
    final line = f.value == 1;
    switch (f.rule) {
      case ruleAssume:
        return ExplainLine((l) => line ? l.exLoopSupposeLine(at) : l.exLoopSupposeCross(at), cellsOf(p, f.slot));
      case ruleRefuted:
        return ExplainLine((l) => line ? l.exLoopRefutedCross(at) : l.exLoopRefutedLine(at), cellsOf(p, f.slot));
    }
    if (f.rule >= loopRuleCount) return null;
    return switch (LoopRule.values[f.rule]) {
      LoopRule.full => ExplainLine((l) => l.exLoopFull(at), here),
      LoopRule.deadEnd => ExplainLine((l) => l.exLoopDeadEnd(at), here),
      LoopRule.onlyWay => ExplainLine((l) => l.exLoopOnlyWay(at), here),
      LoopRule.closeEarly => ExplainLine((l) => l.exLoopCloseEarly(at), cellsOf(p, f.slot)),
      LoopRule.loopDone => ExplainLine((l) => l.exLoopDone(at), cellsOf(p, f.slot)),
      LoopRule.failBranch => ExplainLine((l) => l.exLoopFailBranch, here),
      LoopRule.failDeadEnd => ExplainLine((l) => l.exLoopFailDeadEnd, here),
      LoopRule.failSubloop => ExplainLine((l) => l.exLoopFailSubloop, const {}),
      LoopRule.failClues => ExplainLine((l) => l.exLoopFailClues, const {}),
      LoopRule.failClash =>
        f.args[0] < 0
            ? ExplainLine((l) => l.exLoopFailOffBoard, here)
            : ExplainLine((l) => l.exLoopFailClash(edgeTok(p, f.args[0])), cellsOf(p, f.args[0])),
    };
  }
}

/// Edge [e] of a corner lattice over a [rows] × [cols] grid as a side of
/// cell [near] if it is one, else of the cell below or right of it.
String cornerEdgeTok(LatticeLoop g, int rows, int cols, int e, {Pos? near}) {
  final (a, _) = g.ends(e);
  final r = a ~/ g.vc, c = a % g.vc;
  if (g.isHorizontal(e)) {
    if (near == Pos(r - 1, c) || r >= rows) return sideTok(Pos(r - 1, c), 1);
    return sideTok(Pos(r, c), 0);
  }
  if (near == Pos(r, c - 1) || c >= cols) return sideTok(Pos(r, c - 1), 3);
  return sideTok(Pos(r, c), 2);
}

/// Cells on either side of edge [e] of a corner lattice.
Set<Pos> cornerEdgeCells(LatticeLoop g, int rows, int cols, int e) {
  final (a, _) = g.ends(e);
  final r = a ~/ g.vc, c = a % g.vc;
  final sides = g.isHorizontal(e) ? [Pos(r - 1, c), Pos(r, c)] : [Pos(r, c - 1), Pos(r, c)];
  return {
    for (final q in sides)
      if (q.r >= 0 && q.c >= 0 && q.r < rows && q.c < cols) q,
  };
}

/// Edge [e] of a centred lattice (points at cell centres) as a link token.
String centredEdgeTok(LatticeLoop g, int e) {
  final (a, b) = g.ends(e);
  return linkTok(Pos(a ~/ g.vc, a % g.vc), Pos(b ~/ g.vc, b % g.vc));
}

/// The two cells edge [e] of a centred lattice joins.
Set<Pos> centredEdgeCells(LatticeLoop g, int e) {
  final (a, b) = g.ends(e);
  return {Pos(a ~/ g.vc, a % g.vc), Pos(b ~/ g.vc, b % g.vc)};
}
