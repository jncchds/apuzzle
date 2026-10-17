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
/// pairs and triples, then fish and wings, then probing two- and
/// three-candidate cells.
class SudokuExplainer extends ValueGridExplainer<SudokuPuzzle, SudokuKnowledge> {
  const SudokuExplainer();

  static SudokuSolver _solver(SudokuPuzzle p) => _solvers[p.n] ??= SudokuSolver(p.n);
  static final _solvers = <int, SudokuSolver>{};

  @override
  int get levels => 4;

  @override
  bool probes(int level) => level == 4;

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
  void refute(SudokuPuzzle p, SudokuKnowledge k, int slot, int value, ExplainTrace t) {
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
    String kindOf(int ui) => ui < n ? 'row' : (ui < 2 * n ? 'col' : 'box');
    String unitOf(int ui) => ui < n ? rowTok(ui) : (ui < 2 * n ? colTok(ui - n) : box(ui));
    List<String> digits(int mask) => [
      for (var d = 0; d < n; d++)
        if (mask & (1 << d) != 0) valTok(d),
    ];
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
      case SudokuRule.pair || SudokuRule.triple || SudokuRule.hiddenPair || SudokuRule.hiddenTriple:
        final ui = a[0];
        final kind = kindOf(ui);
        final unit = unitOf(ui);
        final ds = digits(a[1]);
        final set = [for (final i in a.sublist(2)) cell(i)];
        final rule = SudokuRule.values[f.rule];
        return ExplainLine(
          (l) => switch (rule) {
            SudokuRule.pair => l.exSudokuPair(set[0], set[1], ds[0], ds[1], kind, unit),
            SudokuRule.triple => l.exSudokuTriple(cellsTok(cells(a.sublist(2))), ds[0], ds[1], ds[2], kind, unit),
            SudokuRule.hiddenPair => l.exSudokuHiddenPair(set[0], set[1], ds[0], ds[1], kind, unit),
            _ => l.exSudokuHiddenTriple(cellsTok(cells(a.sublist(2))), ds[0], ds[1], ds[2], kind, unit),
          },
          cells(geo.units[ui]),
          'subset:${f.rule}:${a.join(',')}',
        );
      case SudokuRule.xWing || SudokuRule.swordfish:
        final k = f.rule == SudokuRule.xWing.index ? 2 : 3;
        final d = valTok(a[0]), rows = a[1] == 0;
        final base = [for (final x in a.sublist(2, 2 + k)) rows ? rowTok(x) : colTok(x)];
        final cover = [for (final x in a.sublist(2 + k)) rows ? colTok(x) : rowTok(x)];
        final kind = rows ? 'row' : 'col';
        final lines = {
          for (var x = 0; x < k; x++) ...[
            ...cells(geo.units[rows ? a[2 + x] : n + a[2 + x]]),
            ...cells(geo.units[rows ? n + a[2 + k + x] : a[2 + k + x]]),
          ],
        };
        return ExplainLine(
          (l) => k == 2
              ? l.exSudokuXWing(d, kind, base[0], base[1], cover[0], cover[1])
              : l.exSudokuSwordfish(d, kind, base[0], base[1], base[2], cover[0], cover[1], cover[2]),
          lines,
          'fish:${a.join(',')}',
        );
      case SudokuRule.xyWing || SudokuRule.xyzWing:
        final pivot = a[0], wa = a[1], wb = a[2], z = a[3], x = valTok(a[4]), y = valTok(a[5]);
        return ExplainLine(
          (l) => f.rule == SudokuRule.xyWing.index
              ? l.exSudokuXyWing(cell(pivot), x, y, cell(wa), cell(wb), valTok(z))
              : l.exSudokuXyzWing(cell(pivot), x, y, cell(wa), cell(wb), valTok(z)),
          {pos(pivot), pos(wa), pos(wb), pos(f.slot)},
          'wing:${a.join(',')}',
        );
      case SudokuRule.skyscraper || SudokuRule.kite:
        return ExplainLine(
          (l) => l.exSudokuTwoLinks(
            valTok(a[0]),
            kindOf(a[1]),
            unitOf(a[1]),
            cell(a[2]),
            cell(a[3]),
            kindOf(a[4]),
            unitOf(a[4]),
            cell(a[5]),
            cell(a[6]),
          ),
          {...cells(geo.units[a[1]]), ...cells(geo.units[a[4]]), pos(f.slot)},
          'links:${a.join(',')}',
        );
      case SudokuRule.emptyRectangle:
        return ExplainLine(
          (l) => l.exSudokuEmptyRectangle(
            valTok(a[0]),
            box(a[1]),
            rowTok(a[2]),
            colTok(a[3]),
            kindOf(a[4]),
            unitOf(a[4]),
            cell(a[5]),
            cell(a[6]),
            cell(f.slot),
          ),
          {...cells(geo.units[a[1]]), ...cells(geo.units[a[4]]), pos(f.slot)},
          'er:${a.join(',')}',
        );
      case SudokuRule.finnedXWing:
        final rows = a[1] == 0;
        String line(int x) => rows ? rowTok(x) : colTok(x);
        String cover(int x) => rows ? colTok(x) : rowTok(x);
        return ExplainLine(
          (l) => l.exSudokuFinnedXWing(
            valTok(a[0]),
            rows ? 'row' : 'col',
            line(a[2]),
            line(a[3]),
            cover(a[4]),
            cover(a[5]),
            cellsTok(cells(a.sublist(7))),
            box(a[6]),
          ),
          {...cells(f.premises), ...cells(geo.units[a[6]])},
          'finned:${a.join(',')}',
        );
      case SudokuRule.wWing:
        return ExplainLine(
          (l) => l.exSudokuWWing(
            cell(a[0]),
            cell(a[1]),
            valTok(a[2]),
            valTok(a[3]),
            kindOf(a[4]),
            unitOf(a[4]),
            cell(a[5]),
            cell(a[6]),
          ),
          {pos(a[0]), pos(a[1]), ...cells(geo.units[a[4]]), pos(f.slot)},
          'wwing:${a.join(',')}',
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
