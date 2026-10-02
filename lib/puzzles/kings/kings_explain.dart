import '../../core/explain.dart';
import '../../core/grid.dart';
import '../../core/value_grid.dart';
import '../../core/value_grid_explain.dart';
import 'kings_model.dart';
import 'kings_solver.dart';

/// Candidates and crowns for [KingsExplainer]; [ok] is false once an
/// assumption clashed.
class KingsKnowledge {
  KingsKnowledge(this.cand, this.king, [this.ok = true]);

  final List<bool> cand;
  final List<bool> king;
  bool ok;
}

final _solvers = Expando<KingsSolver>();

/// Explains Crowns with [KingsSolver]: last places, then confinement and
/// attacks, then probing crowns. Crowns are shown before the dots they imply.
class KingsExplainer extends ValueGridExplainer<KingsPuzzle, KingsKnowledge> {
  const KingsExplainer();

  KingsSolver _solver(KingsPuzzle p) => _solvers[p] ??= KingsSolver(p.n, p.regions);

  @override
  int get levels => 3;

  @override
  bool probes(int level) => level == 3;

  @override
  KingsKnowledge seed(KingsPuzzle p, ValueGrid s) {
    final solver = _solver(p);
    final cand = [for (final r in p.regions) r >= 0];
    final king = List.filled(p.n * p.n, false);
    final known = knownValues(p, s);
    for (var i = 0; i < known.length; i++) {
      if (known[i] == kKing) solver.place(cand, king, i);
    }
    for (var i = 0; i < known.length; i++) {
      if (known[i] == kDot) cand[i] = false;
    }
    return KingsKnowledge(cand, king);
  }

  @override
  KingsKnowledge copy(KingsKnowledge k) => KingsKnowledge(List.of(k.cand), List.of(k.king), k.ok);

  @override
  bool propagate(KingsPuzzle p, KingsKnowledge k, int level, ExplainTrace? t) =>
      k.ok && _solver(p).propagate(k.cand, k.king, level, t);

  @override
  Iterable<(int, int)> probeCandidates(KingsPuzzle p, KingsKnowledge k) sync* {
    for (var i = 0; i < k.cand.length; i++) {
      if (k.cand[i]) yield (i, kKing);
    }
  }

  @override
  void assume(KingsPuzzle p, KingsKnowledge k, int slot, int value, ExplainTrace? t) {
    t?.fact(slot, kKing, ruleAssume);
    if (!_solver(p).place(k.cand, k.king, slot, t)) k.ok = false;
  }

  @override
  void refute(KingsPuzzle p, KingsKnowledge k, int slot, int value, ExplainTrace t) => k.cand[slot] = false;

  @override
  int? placed(KingsPuzzle p, Fact f) => switch (f.rule) {
    ruleAssume => null,
    ruleRefuted => kDot,
    _ => f.slot >= 0 ? f.value : null,
  };

  @override
  int rank(KingsPuzzle p, Fact f) => switch (f.rule) {
    ruleRefuted => 1,
    _ when KingsRule.values[f.rule] == KingsRule.single => 0,
    _ when KingsRule.values[f.rule] == KingsRule.ruledOut => 2,
    _ => 1,
  };

  @override
  bool quiet(KingsPuzzle p, Fact f) => f.rule >= 0 && KingsRule.values[f.rule] == KingsRule.ruledOut;

  @override
  Set<int> get optionalValues => const {kDot};

  @override
  ExplainLine? describe(KingsPuzzle p, Fact f) {
    final n = p.n;
    final solver = _solver(p);
    final pos = p.size.pos;
    String cell(int i) => cellTok(pos(i));
    Set<Pos> cells(Iterable<int> idx) => {for (final i in idx) pos(i)};
    final at = f.slot >= 0 ? cell(f.slot) : '';
    final a = f.args;
    Set<Pos> unit(int u) => cells(solver.units[u]);
    // A region is named by its first cell.
    String region(int u) => cell(solver.units[u].first);
    final me = {if (f.slot >= 0) pos(f.slot)};
    switch (f.rule) {
      case ruleAssume:
        return ExplainLine((l) => l.exKingsSuppose(at), me);
      case ruleRefuted:
        return ExplainLine((l) => l.exKingsRefuted(at), me);
    }
    switch (KingsRule.values[f.rule]) {
      case KingsRule.single:
        final u = a[0];
        return ExplainLine(
          (l) => u < n
              ? l.exKingsSingleRow(at, rowTok(u))
              : u < 2 * n
              ? l.exKingsSingleCol(at, colTok(u - n))
              : l.exKingsSingleRegion(at),
          unit(u),
        );
      case KingsRule.ruledOut:
        return ExplainLine((l) => l.exKingsRuledOut(at, cell(a[0])), {...me, pos(a[0])});
      case KingsRule.confine:
        final u = a[0], o = a[1];
        return ExplainLine(
          (l) => u < n
              ? l.exKingsConfineRow(at, rowTok(u), region(o))
              : u < 2 * n
              ? l.exKingsConfineCol(at, colTok(u - n), region(o))
              : o < n
              ? l.exKingsConfineRegionRow(at, region(u), rowTok(o))
              : l.exKingsConfineRegionCol(at, region(u), colTok(o - n)),
          {...me, ...unit(u)},
        );
      case KingsRule.attack:
        final u = a[0];
        return ExplainLine(
          (l) => u < n
              ? l.exKingsAttackRow(at, rowTok(u))
              : u < 2 * n
              ? l.exKingsAttackCol(at, colTok(u - n))
              : l.exKingsAttackRegion(at, region(u)),
          {...me, ...unit(u)},
        );
      case KingsRule.failEmpty:
        final u = a[0];
        return ExplainLine(
          (l) => u < n
              ? l.exKingsFailRow(rowTok(u))
              : u < 2 * n
              ? l.exKingsFailCol(colTok(u - n))
              : l.exKingsFailRegion(region(u)),
          unit(u),
        );
      case KingsRule.failClash:
        return ExplainLine((l) => l.exKingsFailClash(cell(a[0]), cell(a[1])), cells(a));
    }
  }
}
