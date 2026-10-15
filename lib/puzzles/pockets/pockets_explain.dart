import 'dart:math';

import '../../core/explain.dart';
import '../../core/grid.dart';
import '../../core/value_grid.dart';
import '../../core/value_grid_explain.dart';
import '../../l10n/l10n.dart';
import '../totals/totals_solver.dart';
import 'pockets_model.dart';
import 'pockets_solver.dart';

final _solvers = Expando<PocketsSolver>();

/// Explains a board with [PocketsSolver]: singles and the digit sets of each
/// pocket, then locked candidates, pairs, every way to fill a pocket and the
/// sums whole regions give away, then probing.
class PocketsExplainer extends MaskGridExplainer<PocketsPuzzle> {
  const PocketsExplainer();

  PocketsSolver _solver(PocketsPuzzle p) => _solvers[p] ??= PocketsSolver(p);

  @override
  int get levels => 3;

  @override
  bool probes(int level) => level == 3;

  @override
  int get lastCandidateRule => PocketsRule.naked.index;

  @override
  Set<int> get placingRules => {PocketsRule.naked.index, PocketsRule.hidden.index, PocketsRule.must.index};

  @override
  List<int> seed(PocketsPuzzle p, ValueGrid s) {
    final full = (1 << p.n) - 1;
    return [for (final v in knownValues(p, s)) v >= 0 ? 1 << v : full];
  }

  @override
  bool propagate(PocketsPuzzle p, List<int> k, int level, ExplainTrace? t) => _solver(p).propagate(k, min(level, 2), t);

  @override
  ExplainLine? describe(PocketsPuzzle p, Fact f) {
    final n = p.n;
    final s = _solver(p);
    final pos = p.size.pos;
    String cell(int i) => cellTok(pos(i));
    Set<Pos> cells(Iterable<int> idx) => {for (final i in idx) pos(i)};
    String digits(int mask) => totalsDigits(mask).map(valTok).join(', ');
    String box(int u) => areaTok(pos(s.geo.units[u].first), pos(s.geo.units[u].last));
    final at = f.slot >= 0 ? cell(f.slot) : '';
    final me = {if (f.slot >= 0) pos(f.slot)};
    final a = f.args;
    switch (f.rule) {
      case ruleAssume:
        return ExplainLine((l) => l.exSuppose(at, valTok(f.value)), me);
      case ruleRefuted:
        return ExplainLine((l) => l.exRefuted(at, valTok(f.value)), me);
    }

    // The sum an area makes: a pocket's own, or what a region gives away.
    String Function(AppLocalizations) lead(PocketsArea area) {
      final r = area.region, regions = pocketsRegions(n);
      final cs = cellsTok(cells(area.cells)), sum = '${area.sum}', total = '${area.total}', other = '${area.other}';
      final first = pos(regions[r].first), last = pos(regions[r].last);
      String region(AppLocalizations l) => r < n
          ? l.exPocketsRegionRow(rowTok(r))
          : r < 2 * n
          ? l.exPocketsRegionCol(colTok(r - n))
          : r < 3 * n
          ? l.exPocketsRegionBox(areaTok(first, last))
          : first.c == 0 && last.c == n - 1
          ? l.exPocketsRegionRows(rowTok(first.r), rowTok(last.r))
          : l.exPocketsRegionCols(colTok(first.c), colTok(last.c));
      return (l) => area.outside
          ? l.exPocketsOutie(region(l), total, other, cs, sum)
          : l.exPocketsInnie(region(l), total, other, cs, sum);
    }

    switch (PocketsRule.values[f.rule]) {
      case PocketsRule.ruledOut:
        return null;
      case PocketsRule.naked:
        return ExplainLine((l) => l.exTotalsNaked(at, valTok(f.value)), me);
      case PocketsRule.hidden:
        final u = a[0], v = valTok(f.value);
        return ExplainLine(
          (l) => u < n
              ? l.exSudokuHiddenRow(at, v, rowTok(u))
              : u < 2 * n
              ? l.exSudokuHiddenCol(at, v, colTok(u - n))
              : l.exSudokuHiddenBox(at, v, box(u)),
          cells(s.geo.units[u]),
        );
      case PocketsRule.pointing:
        final d = valTok(a[0]), line = a[2];
        return ExplainLine(
          (l) => line < n
              ? l.exSudokuPointingRow(box(a[1]), d, rowTok(line))
              : l.exSudokuPointingCol(box(a[1]), d, colTok(line - n)),
          {...cells(s.geo.units[a[1]]), ...cells(s.geo.units[line])},
        );
      case PocketsRule.claiming:
        final d = valTok(a[0]), line = a[1];
        return ExplainLine(
          (l) => line < n
              ? l.exSudokuClaimingRow(rowTok(line), d, box(a[2]))
              : l.exSudokuClaimingCol(colTok(line - n), d, box(a[2])),
          {...cells(s.geo.units[line]), ...cells(s.geo.units[a[2]])},
        );
      case PocketsRule.pair:
        final u = a[0];
        final ds = totalsDigits(a[3]).map(valTok).toList();
        final c1 = cell(a[1]), c2 = cell(a[2]);
        return ExplainLine(
          (l) => u < n
              ? l.exSudokuPairRow(c1, c2, ds[0], ds[1], rowTok(u))
              : u < 2 * n
              ? l.exSudokuPairCol(c1, c2, ds[0], ds[1], colTok(u - n))
              : l.exSudokuPairBox(c1, c2, ds[0], ds[1], box(u)),
          cells(s.geo.units[u]),
        );
      case PocketsRule.failEmpty:
        return ExplainLine((l) => l.exSudokuFailEmpty(cell(a[0])), {pos(a[0])});
      case PocketsRule.failNoPlace:
        final d = valTok(a[0]), u = a[1];
        return ExplainLine(
          (l) => u < n
              ? l.exSudokuFailNoPlaceRow(d, rowTok(u))
              : u < 2 * n
              ? l.exSudokuFailNoPlaceCol(d, colTok(u - n))
              : l.exSudokuFailNoPlaceBox(d, box(u)),
          cells(s.geo.units[u]),
        );
      case PocketsRule.combo || PocketsRule.must || PocketsRule.fill || PocketsRule.line || PocketsRule.failSum:
        break;
    }

    final area = s.areas[a[0]];
    final here = cells(area.cells);
    final sum = '${area.sum}';
    final pocket = area.pocket >= 0 ? cell(area.cells.first) : '';
    final rule = PocketsRule.values[f.rule];
    if (area.pocket < 0) {
      final why = lead(area);
      return switch (rule) {
        PocketsRule.combo => () {
          final can = digits(a[1]), gone = digits(f.value);
          return ExplainLine((l) => l.exPocketsAreaCombo(why(l), can, at, gone), here);
        }(),
        PocketsRule.must => ExplainLine((l) => l.exPocketsAreaMust(why(l), valTok(f.value), at), here),
        PocketsRule.fill => () {
          final gone = digits(f.value);
          return ExplainLine((l) => l.exPocketsAreaFill(why(l), gone, at), here);
        }(),
        _ => () {
          final cs = cellsTok(here);
          return ExplainLine((l) => l.exPocketsFailCells(cs, sum), here);
        }(),
      };
    }
    switch (rule) {
      case PocketsRule.combo:
        final can = digits(a[1]), gone = digits(f.value);
        return ExplainLine((l) => l.exPocketsCombo(sum, pocket, can, at, gone), here);
      case PocketsRule.must:
        return ExplainLine((l) => l.exPocketsMust(sum, pocket, valTok(f.value), at), here);
      case PocketsRule.fill:
        final gone = digits(f.value);
        return ExplainLine((l) => l.exPocketsFill(sum, pocket, gone, at), here);
      case PocketsRule.line:
        final d = valTok(a[1]), u = a[2];
        return ExplainLine(
          (l) => u < n
              ? l.exPocketsLineRow(sum, pocket, d, rowTok(u))
              : u < 2 * n
              ? l.exPocketsLineCol(sum, pocket, d, colTok(u - n))
              : l.exPocketsLineBox(sum, pocket, d, box(u)),
          {...here, ...cells(s.geo.units[u])},
        );
      default:
        return ExplainLine((l) => l.exPocketsFailSum(pocket, sum), here);
    }
  }
}
