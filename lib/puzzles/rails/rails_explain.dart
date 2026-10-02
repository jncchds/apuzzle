import '../../core/explain.dart';
import '../../core/grid.dart';
import '../../core/loop_explain.dart';
import 'rails_model.dart';
import 'rails_solver.dart';

final _solvers = Expando<RailsSolver>();

/// Explains Rails with [RailsSolver]. Slots are edges, then cells: edge
/// facts become track or crosses, cell facts become the player's notes.
/// Track comes first; crosses and notes are optional.
class RailsExplainer extends Explainer<RailsPuzzle, RailsState, List<int>> {
  const RailsExplainer();

  RailsSolver _solver(RailsPuzzle p) => _solvers[p] ??= RailsSolver(p);

  int _ec(RailsPuzzle p) => p.lattice.edgeCount;

  @override
  GridSize size(RailsPuzzle p) => p.size;

  @override
  int get levels => 2;

  @override
  bool probes(int level) => level == 2;

  @override
  List<int> seed(RailsPuzzle p, RailsState s) {
    final st = _solver(p).initial();
    final ec = _ec(p);
    final used = railsUsed(p, p.lines);
    for (var e = 0; e < ec; e++) {
      if (st[e] != -1) continue;
      if (s.marks[e] == 1 && p.lines[e]) st[e] = 1;
      if (s.marks[e] == 2 && !p.lines[e]) st[e] = 0;
    }
    for (var i = 0; i < used.length; i++) {
      if (st[ec + i] != -1) continue;
      if (s.note(i) == railsNoteTrack && used[i]) st[ec + i] = 1;
      if (s.note(i) == railsNoteDot && !used[i]) st[ec + i] = 0;
    }
    return st;
  }

  @override
  List<int> copy(List<int> k) => List.of(k);

  @override
  bool propagate(RailsPuzzle p, List<int> k, int level, ExplainTrace? t) => _solver(p).propagate(k, t);

  @override
  Iterable<(int, int)> probeCandidates(RailsPuzzle p, List<int> k) sync* {
    for (var s = 0; s < k.length; s++) {
      if (k[s] == -1) {
        yield (s, 1);
        yield (s, 0);
      }
    }
  }

  @override
  void assume(RailsPuzzle p, List<int> k, int slot, int value, ExplainTrace? t) {
    k[slot] = value;
    t?.fact(slot, value, ruleAssume);
  }

  @override
  void refute(RailsPuzzle p, List<int> k, int slot, int value, ExplainTrace t) => k[slot] = 1 - value;

  int? _value(Fact f) => f.slot < 0 || f.rule == ruleAssume ? null : (f.rule == ruleRefuted ? 1 - f.value : f.value);

  @override
  RailsState? move(RailsPuzzle p, RailsState s, Fact f) {
    final v = _value(f);
    if (v == null) return null;
    final ec = _ec(p);
    if (f.slot < ec) {
      final mark = v == 1 ? 1 : 2;
      if (s.marks[f.slot] == mark) return null;
      return RailsState(List.of(s.marks)..[f.slot] = mark, s.cells);
    }
    final i = f.slot - ec, note = v == 1 ? railsNoteTrack : railsNoteDot;
    final notes = s.notes(p.rows * p.cols);
    // Track drawn through the cell already says it.
    if (notes[i] == note || (v == 1 && p.lattice.incident[i].any((e) => s.marks[e] == 1))) return null;
    return RailsState(s.marks, notes..[i] = note);
  }

  @override
  int rank(RailsPuzzle p, Fact f) {
    final edge = f.slot < _ec(p);
    return _value(f) == 1 ? (edge ? 0 : 1) : (edge ? 1 : 2);
  }

  @override
  Set<Pos> targets(RailsPuzzle p, Fact f) {
    final ec = _ec(p);
    return f.slot < ec ? centredEdgeCells(p.lattice, f.slot) : {p.size.pos(f.slot - ec)};
  }

  @override
  Set<int> targetEdges(RailsPuzzle p, Fact f) => f.slot < _ec(p) ? {f.slot} : const {};

  @override
  (Pos, RailsState)? wrongEntry(RailsPuzzle p, RailsState s) {
    for (var e = 0; e < s.marks.length; e++) {
      if ((s.marks[e] == 1 && !p.lines[e]) || (s.marks[e] == 2 && p.lines[e])) {
        return (centredEdgeCells(p.lattice, e).first, RailsState(List.of(s.marks)..[e] = 0, s.cells));
      }
    }
    final used = railsUsed(p, p.lines);
    for (var i = 0; i < used.length; i++) {
      final n = s.note(i);
      if ((n == railsNoteTrack && !used[i]) || (n == railsNoteDot && used[i])) {
        return (p.size.pos(i), RailsState(s.marks, s.notes(used.length)..[i] = railsNoteNone));
      }
    }
    return null;
  }

  @override
  (Pos, RailsState)? reveal(RailsPuzzle p, RailsState s) {
    for (var e = 0; e < s.marks.length; e++) {
      if (p.lines[e] && s.marks[e] != 1) {
        return (centredEdgeCells(p.lattice, e).first, RailsState(List.of(s.marks)..[e] = 1, s.cells));
      }
    }
    return null;
  }

  @override
  bool done(RailsPuzzle p, RailsState s) {
    for (var e = 0; e < s.marks.length; e++) {
      if ((s.marks[e] == 1) != p.lines[e]) return false;
    }
    return true;
  }

  @override
  ExplainLine? describe(RailsPuzzle p, Fact f) {
    final g = p.lattice, ec = _ec(p);
    final edge = f.slot >= 0 && f.slot < ec;
    final at = f.slot < 0 ? '' : (edge ? centredEdgeTok(g, f.slot) : cellTok(p.size.pos(f.slot - ec)));
    final me = f.slot < 0 ? <Pos>{} : targets(p, f);
    Set<Pos> slots(Iterable<int> ks) => {
      for (final k in ks)
        if (k < ec) ...centredEdgeCells(g, k) else p.size.pos(k - ec),
    };
    final here = {...me, ...slots(f.premises.take(12))};
    final on = f.value == 1;
    final a = f.args.isEmpty ? -1 : f.args[0];
    String cell(int i) => cellTok(p.size.pos(i));
    String line(int li) => li < p.rows ? rowTok(li) : colTok(li - p.rows);
    final isRow = a >= 0 && a < p.rows;
    int count(int li) => li < p.rows ? p.rowCounts[li] : p.colCounts[li - p.rows];
    switch (f.rule) {
      case ruleAssume:
        return ExplainLine(
          (l) => edge
              ? (on ? l.exLoopSupposeLine(at) : l.exLoopSupposeCross(at))
              : (on ? l.exRailsSupposeOn(at) : l.exRailsSupposeOff(at)),
          me,
        );
      case ruleRefuted:
        return ExplainLine(
          (l) => edge
              ? (on ? l.exLoopRefutedCross(at) : l.exLoopRefutedLine(at))
              : (on ? l.exRailsRefutedOff(at) : l.exRailsRefutedOn(at)),
          me,
        );
    }
    return switch (RailsRule.values[f.rule]) {
      RailsRule.cellUsed => ExplainLine((l) => l.exRailsCellUsed(at), here),
      RailsRule.cellEmpty => ExplainLine((l) => l.exRailsCellEmpty(at), here),
      RailsRule.pieceFull => ExplainLine((l) => l.exRailsPieceFull(at, cell(a)), here),
      RailsRule.pieceEmpty => ExplainLine((l) => l.exRailsPieceEmpty(at, cell(a)), here),
      RailsRule.pieceNeed => ExplainLine((l) => l.exRailsPieceNeed(at, cell(a)), here),
      RailsRule.lineDone => ExplainLine(
        (l) => isRow ? l.exRailsRowDone(at, line(a), count(a)) : l.exRailsColDone(at, line(a), count(a)),
        here,
      ),
      RailsRule.lineNeed => ExplainLine(
        (l) => isRow ? l.exRailsRowNeed(at, line(a), count(a)) : l.exRailsColNeed(at, line(a), count(a)),
        here,
      ),
      RailsRule.trackDone => ExplainLine(
        (l) => edge ? l.exRailsDoneEdge(at) : (on ? l.exRailsDoneOn(at) : l.exRailsDoneOff(at)),
        me,
      ),
      RailsRule.closeEarly => ExplainLine((l) => l.exRailsCloseEarly(at), me),
      RailsRule.failBranch => ExplainLine((l) => l.exRailsFailBranch(cell(a)), here),
      RailsRule.failDeadEnd => ExplainLine((l) => l.exRailsFailDeadEnd(cell(a)), here),
      RailsRule.failLineMany => ExplainLine(
        (l) => isRow ? l.exRailsFailRowMany(line(a), count(a)) : l.exRailsFailColMany(line(a), count(a)),
        here,
      ),
      RailsRule.failLineFew => ExplainLine(
        (l) => isRow ? l.exRailsFailRowFew(line(a), count(a)) : l.exRailsFailColFew(line(a), count(a)),
        here,
      ),
      RailsRule.failLoop => ExplainLine((l) => l.exRailsFailLoop, const {}),
      RailsRule.failClosed => ExplainLine((l) => l.exRailsFailClosed, const {}),
      RailsRule.failClash => ExplainLine(
        (l) => a < ec ? l.exLoopFailClash(centredEdgeTok(g, a)) : l.exRailsFailClash(cell(a - ec)),
        slots([a]),
      ),
    };
  }
}
