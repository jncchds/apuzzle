import '../../core/explain.dart';
import '../../core/grid.dart';
import 'shikaku_model.dart';
import 'shikaku_solver.dart';

final _solvers = Expando<ShikakuSolver>();

/// Explains Shikaku with [ShikakuSolver]: rectangles ruled out per number
/// until one is left, then probing rectangles. Slots are clues.
class ShikakuExplainer extends Explainer<ShikakuPuzzle, ShikakuState, List<List<CellRect>>> {
  const ShikakuExplainer();

  ShikakuSolver _solver(ShikakuPuzzle p) => _solvers[p] ??= ShikakuSolver(p.rows, p.cols, p.clues);

  @override
  GridSize size(ShikakuPuzzle p) => p.size;

  @override
  int get levels => 2;

  @override
  bool probes(int level) => level == 2;

  /// The clue (index) inside [r], or -1.
  int _clueIn(ShikakuPuzzle p, CellRect r) {
    final s = _solver(p);
    for (var k = 0; k < s.clueCells.length; k++) {
      final i = s.clueCells[k];
      if (r.contains(i ~/ p.cols, i % p.cols)) return k;
    }
    return -1;
  }

  @override
  List<List<CellRect>> seed(ShikakuPuzzle p, ShikakuState s) {
    final cand = [for (final c in _solver(p).candidates) List.of(c)];
    for (final r in s.rects) {
      if (!p.solution.contains(r)) continue;
      final k = _clueIn(p, r);
      if (k >= 0) cand[k] = [r];
    }
    return cand;
  }

  @override
  void start(ShikakuPuzzle p, List<List<CellRect>> k, ExplainTrace t) {
    final s = _solver(p);
    for (var c = 0; c < k.length; c++) {
      if (s.candidates[c].length == 1) t.fact(c, 0, ShikakuRule.fixed.index);
    }
  }

  @override
  List<List<CellRect>> copy(List<List<CellRect>> k) => [for (final c in k) List.of(c)];

  @override
  bool propagate(ShikakuPuzzle p, List<List<CellRect>> k, int level, ExplainTrace? t) => _solver(p).propagate(k, t);

  @override
  Iterable<(int, int)> probeCandidates(ShikakuPuzzle p, List<List<CellRect>> k) sync* {
    final s = _solver(p);
    final order = [
      for (var c = 0; c < k.length; c++)
        if (k[c].length > 1) c,
    ]..sort((a, b) => k[a].length - k[b].length);
    for (final c in order) {
      for (final r in List.of(k[c])) {
        yield (c, s.candidates[c].indexOf(r));
      }
    }
  }

  @override
  void assume(ShikakuPuzzle p, List<List<CellRect>> k, int slot, int value, ExplainTrace? t) {
    k[slot] = [_solver(p).candidates[slot][value]];
    t?.fact(slot, value, ruleAssume);
  }

  @override
  void refute(ShikakuPuzzle p, List<List<CellRect>> k, int slot, int value, ExplainTrace t) {
    final s = _solver(p);
    k[slot].remove(s.candidates[slot][value]);
    if (k[slot].length == 1) {
      t.fact(slot, s.candidates[slot].indexOf(k[slot].single), ShikakuRule.fixed.index, premises: [slot]);
    }
  }

  CellRect? _fixed(ShikakuPuzzle p, Fact f) =>
      f.rule == ShikakuRule.fixed.index ? _solver(p).candidates[f.slot][f.value] : null;

  @override
  ShikakuState? move(ShikakuPuzzle p, ShikakuState s, Fact f) {
    final r = _fixed(p, f);
    if (r == null || s.rects.contains(r)) return null;
    return ShikakuState([
      for (final x in s.rects)
        if (!x.overlaps(r)) x,
      r,
    ]);
  }

  @override
  Set<Pos> targets(ShikakuPuzzle p, Fact f) => {for (final i in _fixed(p, f)!.cells(p.cols)) p.size.pos(i)};

  @override
  (Pos, ShikakuState)? wrongEntry(ShikakuPuzzle p, ShikakuState s) {
    for (final r in s.rects) {
      if (!p.solution.contains(r)) {
        return (Pos(r.r0, r.c0), ShikakuState([...s.rects]..remove(r)));
      }
    }
    return null;
  }

  @override
  (Pos, ShikakuState)? reveal(ShikakuPuzzle p, ShikakuState s) {
    for (final r in p.solution) {
      if (!s.rects.contains(r)) return (Pos(r.r0, r.c0), ShikakuState([...s.rects, r]));
    }
    return null;
  }

  @override
  bool done(ShikakuPuzzle p, ShikakuState s) => p.solution.every(s.rects.contains);

  @override
  ExplainLine? describe(ShikakuPuzzle p, Fact f) {
    final solver = _solver(p);
    final pos = p.size.pos;
    String clue(int k) => cellTok(pos(solver.clueCells[k]));
    String rect(CellRect r) => areaTok(Pos(r.r0, r.c0), Pos(r.r1, r.c1));
    Set<Pos> cells(CellRect r) => {for (final i in r.cells(p.cols)) pos(i)};
    final a = f.args;
    final k = f.slot;
    switch (f.rule) {
      case ruleAssume:
        final r = solver.candidates[k][f.value];
        return ExplainLine((l) => l.exShikakuSuppose(clue(k), rect(r)), cells(r));
      case ruleRefuted:
        final r = solver.candidates[k][f.value];
        return ExplainLine((l) => l.exShikakuRefuted(clue(k), rect(r)), cells(r));
    }
    return switch (ShikakuRule.values[f.rule]) {
      ShikakuRule.overlap => ExplainLine((l) => l.exShikakuOverlap(clue(k), clue(a[0])), {
        pos(solver.clueCells[k]),
        pos(solver.clueCells[a[0]]),
      }),
      ShikakuRule.owner => ExplainLine((l) => l.exShikakuOwner(clue(k), cellTok(pos(a[1]))), {
        pos(solver.clueCells[k]),
        pos(a[1]),
      }),
      ShikakuRule.common => ExplainLine((l) => l.exShikakuCommon(clue(a[0]), cellTok(pos(a[1])), clue(k)), {
        pos(solver.clueCells[a[0]]),
        pos(a[1]),
      }),
      ShikakuRule.fixed => ExplainLine(
        (l) => l.exShikakuFixed(clue(k), rect(solver.candidates[k][f.value])),
        cells(solver.candidates[k][f.value]),
      ),
      ShikakuRule.failNone => ExplainLine((l) => l.exShikakuFailNone(clue(a[0])), {pos(solver.clueCells[a[0]])}),
      ShikakuRule.failUncovered => ExplainLine((l) => l.exShikakuFailUncovered(cellTok(pos(a[0]))), {pos(a[0])}),
    };
  }
}
