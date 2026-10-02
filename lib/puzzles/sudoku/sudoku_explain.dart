import '../../core/explain.dart';
import '../../core/grid.dart';
import '../../core/value_grid.dart';
import '../../core/value_grid_explain.dart';
import 'sudoku_model.dart';
import 'sudoku_solver.dart';

/// Digits and candidates for [SudokuExplainer]; [ok] is false once an
/// assumption clashed.
class SudokuKnowledge {
  SudokuKnowledge(this.g, this.cand, [this.ok = true]);

  final List<int> g;
  final List<int> cand;
  bool ok;

  SudokuKnowledge copy() => SudokuKnowledge(List.of(g), List.of(cand), ok);
}

/// Explains Sudoku with [SudokuSolver]: singles, then locked candidates and
/// naked pairs, then probing two- and three-candidate cells.
class SudokuExplainer extends ValueGridExplainer<SudokuPuzzle, SudokuKnowledge> {
  const SudokuExplainer();

  static SudokuSolver _solver(SudokuPuzzle p) => _solvers[p.n] ??= SudokuSolver(p.n);
  static final _solvers = <int, SudokuSolver>{};

  @override
  int get levels => 3;

  @override
  bool probes(int level) => level == 3;

  @override
  SudokuKnowledge seed(SudokuPuzzle p, ValueGrid s) {
    final g = knownValues(p, s);
    return SudokuKnowledge(g, _solver(p).candidates(g)!);
  }

  @override
  SudokuKnowledge copy(SudokuKnowledge k) => k.copy();

  @override
  bool propagate(SudokuPuzzle p, SudokuKnowledge k, int level, ExplainTrace? t) =>
      k.ok && _solver(p).propagate(k.g, k.cand, level, t);

  @override
  Iterable<(int, int)> probeCandidates(SudokuPuzzle p, SudokuKnowledge k) sync* {
    for (final want in const [2, 3]) {
      for (var i = 0; i < k.g.length; i++) {
        if (k.g[i] >= 0) continue;
        final digits = [
          for (var d = 0; d < p.n; d++)
            if (k.cand[i] & (1 << d) != 0) d,
        ];
        if (digits.length != want) continue;
        for (final d in digits) {
          yield (i, d);
        }
      }
    }
  }

  @override
  void assume(SudokuPuzzle p, SudokuKnowledge k, int slot, int value, ExplainTrace? t) {
    t?.fact(slot, value, ruleAssume, premises: [slot]);
    if (!_solver(p).assign(k.g, k.cand, slot, value, t)) k.ok = false;
  }

  @override
  void refute(SudokuPuzzle p, SudokuKnowledge k, int slot, int value) {
    k.cand[slot] &= ~(1 << value);
    if (k.cand[slot] == 0) k.ok = false;
  }

  @override
  int? placed(SudokuPuzzle p, Fact f) => switch (f.rule) {
    ruleAssume || ruleRefuted => null,
    _ => switch (SudokuRule.values[f.rule]) {
      SudokuRule.naked || SudokuRule.hidden => f.value,
      _ => null,
    },
  };

  @override
  ExplainLine? describe(SudokuPuzzle p, Fact f) {
    final n = p.n;
    final geo = SudokuGeometry.of(n);
    final pos = p.size.pos;
    String cell(int i) => cellTok(pos(i));
    Set<Pos> cells(Iterable<int> idx) => {for (final i in idx) pos(i)};
    String box(int ui) => areaTok(pos(geo.units[ui].first), pos(geo.units[ui].last));
    final a = f.args;
    final at = f.slot >= 0 ? cell(f.slot) : '';
    final v = valTok(f.value);
    final here = {...cells(f.premises), if (f.slot >= 0) pos(f.slot)};
    switch (f.rule) {
      case ruleAssume:
        return ExplainLine((l) => l.exSuppose(at, v), {pos(f.slot)});
      case ruleRefuted:
        return ExplainLine((l) => l.exRefuted(at, v), {pos(f.slot)});
    }
    switch (SudokuRule.values[f.rule]) {
      case SudokuRule.naked:
        return ExplainLine((l) => l.exSudokuNaked(at, v), {pos(f.slot), for (final q in geo.peers[f.slot]) pos(q)});
      case SudokuRule.hidden:
        final ui = a[0];
        return ExplainLine(
          (l) => ui < n
              ? l.exSudokuHiddenRow(at, v, rowTok(ui))
              : ui < 2 * n
              ? l.exSudokuHiddenCol(at, v, colTok(ui - n))
              : l.exSudokuHiddenBox(at, v, box(ui)),
          cells(geo.units[ui]),
        );
      case SudokuRule.ruledOut:
        return null;
      case SudokuRule.pointing:
        final d = valTok(a[0]), line = a[2];
        return ExplainLine(
          (l) => line < n
              ? l.exSudokuPointingRow(box(a[1]), d, rowTok(line))
              : l.exSudokuPointingCol(box(a[1]), d, colTok(line - n)),
          {...cells(geo.units[a[1]]), ...cells(geo.units[line])},
        );
      case SudokuRule.claiming:
        final d = valTok(a[0]), line = a[1];
        return ExplainLine(
          (l) => line < n
              ? l.exSudokuClaimingRow(rowTok(line), d, box(a[2]))
              : l.exSudokuClaimingCol(colTok(line - n), d, box(a[2])),
          {...cells(geo.units[line]), ...cells(geo.units[a[2]])},
        );
      case SudokuRule.pair:
        final ui = a[0];
        final ds = [
          for (var d = 0; d < n; d++)
            if (a[3] & (1 << d) != 0) valTok(d),
        ];
        final c1 = cell(a[1]), c2 = cell(a[2]);
        return ExplainLine(
          (l) => ui < n
              ? l.exSudokuPairRow(c1, c2, ds[0], ds[1], rowTok(ui))
              : ui < 2 * n
              ? l.exSudokuPairCol(c1, c2, ds[0], ds[1], colTok(ui - n))
              : l.exSudokuPairBox(c1, c2, ds[0], ds[1], box(ui)),
          cells(geo.units[ui]),
        );
      case SudokuRule.failEmpty:
        return ExplainLine((l) => l.exSudokuFailEmpty(cell(a[0])), here);
      case SudokuRule.failNoPlace:
        final d = valTok(a[0]), ui = a[1];
        return ExplainLine(
          (l) => ui < n
              ? l.exSudokuFailNoPlaceRow(d, rowTok(ui))
              : ui < 2 * n
              ? l.exSudokuFailNoPlaceCol(d, colTok(ui - n))
              : l.exSudokuFailNoPlaceBox(d, box(ui)),
          here,
        );
      case SudokuRule.failClash:
        return ExplainLine((l) => l.exSudokuFailClash(cell(a[0]), cell(a[1]), valTok(a[2])), here);
    }
  }
}
