import '../../core/explain.dart';
import '../../core/grid.dart';
import '../../core/value_grid.dart';
import '../../core/value_grid_explain.dart';
import 'lits_model.dart';
import 'lits_solver.dart';

/// Placements still possible per region and what is known per cell (1
/// shaded, -1 empty, 0 unknown) for [LitsExplainer].
class LitsKnowledge {
  LitsKnowledge(this.cand, this.known);

  final List<List<Placement>> cand;
  final List<int> known;
}

final _solvers = Expando<LitsSolver>();

/// Explains Tetra with [LitsSolver]: shapes ruled out per region and the
/// cells they agree on, then probing shapes. Dots are optional.
class LitsExplainer extends ValueGridExplainer<LitsPuzzle, LitsKnowledge> {
  const LitsExplainer();

  LitsSolver _solver(LitsPuzzle p) => _solvers[p] ??= LitsSolver(p.n, p.regions);

  @override
  int get levels => 2;

  @override
  bool probes(int level) => level == 2;

  @override
  Set<int> get optionalValues => const {litsDot};

  @override
  LitsKnowledge seed(LitsPuzzle p, ValueGrid s) {
    final solver = _solver(p);
    final known = solver.initialKnown();
    final board = knownValues(p, s);
    for (var i = 0; i < known.length; i++) {
      if (board[i] == litsShade) known[i] = 1;
      if (board[i] == litsDot) known[i] = -1;
    }
    return LitsKnowledge(solver.copyCandidates(), known);
  }

  @override
  LitsKnowledge copy(LitsKnowledge k) => LitsKnowledge([for (final l in k.cand) List.of(l)], List.of(k.known));

  @override
  bool propagate(LitsPuzzle p, LitsKnowledge k, int level, ExplainTrace? t) => _solver(p).propagate(k.cand, k.known, t);

  @override
  Iterable<(int, int)> probeCandidates(LitsPuzzle p, LitsKnowledge k) sync* {
    final solver = _solver(p);
    final cells = p.n * p.n;
    final regions = [
      for (var r = 0; r < k.cand.length; r++)
        if (k.cand[r].length > 1) r,
    ]..sort((a, b) => k.cand[a].length - k.cand[b].length);
    for (final r in regions) {
      for (final pl in List.of(k.cand[r])) {
        yield (cells + r, solver.candidates[r].indexOf(pl));
      }
    }
  }

  @override
  void assume(LitsPuzzle p, LitsKnowledge k, int slot, int value, ExplainTrace? t) {
    final r = slot - p.n * p.n;
    k.cand[r]
      ..clear()
      ..add(_solver(p).candidates[r][value]);
    t?.fact(slot, value, ruleAssume, args: [r]);
  }

  @override
  void refute(LitsPuzzle p, LitsKnowledge k, int slot, int value, ExplainTrace t) {
    final r = slot - p.n * p.n;
    k.cand[r].remove(_solver(p).candidates[r][value]);
  }

  @override
  int? placed(LitsPuzzle p, Fact f) => f.slot >= p.n * p.n || f.rule < 0
      ? null
      : switch (LitsRule.values[f.rule]) {
          LitsRule.allShapes => litsShade,
          LitsRule.noShape => litsDot,
          _ => null,
        };

  @override
  int rank(LitsPuzzle p, Fact f) => placed(p, f) == litsShade ? 0 : 1;

  @override
  bool quiet(LitsPuzzle p, Fact f) => f.rule == LitsRule.overEmpty.index || f.rule == LitsRule.missesShaded.index;

  @override
  ExplainLine? describe(LitsPuzzle p, Fact f) {
    final solver = _solver(p);
    final cells = p.n * p.n;
    final pos = p.size.pos;
    String cell(int i) => cellTok(pos(i));
    Set<Pos> region(int r) => {for (final i in solver.cellsOf[r]) pos(i)};
    String anchor(int r) => cell(solver.cellsOf[r].first);
    final a = f.args;
    final r = f.slot >= cells ? f.slot - cells : (a.isEmpty ? -1 : a[0]);
    final at = f.slot >= 0 && f.slot < cells ? cell(f.slot) : '';
    String shape() => cellsTok([for (final i in solver.candidates[r][f.value].cells) pos(i)]);
    switch (f.rule) {
      case ruleAssume:
        return ExplainLine((l) => l.exLitsSuppose(anchor(r), shape()), region(r));
      case ruleRefuted:
        return ExplainLine((l) => l.exLitsRefuted(anchor(r), shape()), region(r));
    }
    final o = a.length > 1 ? a[1] : -1;
    return switch (LitsRule.values[f.rule]) {
      LitsRule.overEmpty => ExplainLine((l) => l.exLitsOverEmpty(anchor(r)), region(r)),
      LitsRule.missesShaded => ExplainLine((l) => l.exLitsMisses(anchor(r)), region(r)),
      LitsRule.pool => ExplainLine((l) => l.exLitsPool(anchor(r)), region(r)),
      LitsRule.clash => ExplainLine((l) => l.exLitsClash(anchor(r), anchor(o)), {...region(r), ...region(o)}),
      LitsRule.cut => ExplainLine((l) => l.exLitsCut(anchor(r)), region(r)),
      LitsRule.twin => ExplainLine((l) => l.exLitsTwin(anchor(r), anchor(o)), {...region(r), ...region(o)}),
      LitsRule.allShapes => ExplainLine((l) => l.exLitsAll(at, anchor(r)), region(r)),
      LitsRule.noShape => ExplainLine((l) => l.exLitsNone(at, anchor(r)), region(r)),
      LitsRule.failNoShape => ExplainLine((l) => l.exLitsFailNoShape(anchor(r)), region(r)),
      LitsRule.failCut => ExplainLine((l) => l.exLitsFailCut, const {}),
    };
  }
}
