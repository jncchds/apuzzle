import '../../core/explain.dart';
import '../../core/grid.dart';
import '../../core/latin_square.dart';
import 'cages_model.dart';
import 'cages_solver.dart';

final _solvers = Expando<CagesSolver>();

/// Explains cages with [CagesSolver]: singles and every way to fill a cage,
/// then pairs and digits a cage must put into a line, then probing.
class CagesExplainer extends LatinExplainer<CagesPuzzle> {
  const CagesExplainer();

  CagesSolver _solver(CagesPuzzle p) => _solvers[p] ??= CagesSolver(p.n, p.cages);

  @override
  int get levels => 3;

  @override
  bool probes(int level) => level == 3;

  @override
  Set<int> get placingTypeRules => {CagesRule.single.id};

  @override
  bool propagate(CagesPuzzle p, List<int> k, int level, ExplainTrace? t) => _solver(p).propagate(k, level, t);

  @override
  ExplainLine? describeRule(CagesPuzzle p, Fact f) {
    final n = p.n, sq = LatinSquare.of(n);
    final pos = p.size.pos;
    Set<Pos> cells(Iterable<int> idx) => {for (final i in idx) pos(i)};
    final at = cellTok(pos(f.slot.clamp(0, n * n - 1)));
    final a = f.args;
    final cage = p.cages[a[0]];
    final clue = cage.clue, where = cellTok(pos(cage.cells.first));
    String values(int mask) => LatinSquare.digits(mask).map(valTok).join(', ');
    switch (CagesRule.values[f.rule - latinRuleCount]) {
      case CagesRule.single:
        return ExplainLine((l) => l.exCagesSingle(at, valTok(f.value)), {pos(f.slot)});
      case CagesRule.combo:
        final v = values(f.value);
        return ExplainLine((l) => l.exCagesCombo(clue, where, v, at), cells(cage.cells));
      case CagesRule.required:
        final u = a[1], v = values(f.value);
        return ExplainLine(
          (l) => u < n
              ? l.exCagesRequiredRow(clue, where, v, rowTok(u), at)
              : l.exCagesRequiredCol(clue, where, v, colTok(u - n), at),
          {...cells(sq.lines[u]), ...cells(cage.cells)},
        );
      case CagesRule.failCage:
        return ExplainLine((l) => l.exCagesFail(clue, where), cells(cage.cells));
    }
  }
}
