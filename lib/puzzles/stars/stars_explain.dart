import '../../core/explain.dart';
import '../../core/grid.dart';
import '../../core/value_grid.dart';
import '../../core/value_grid_explain.dart';
import 'stars_model.dart';
import 'stars_solver.dart';

/// Open cells and stars for [StarsExplainer]; [ok] is false once an
/// assumption clashed.
class StarsKnowledge {
  StarsKnowledge(this.cand, this.star, [this.ok = true]);

  final List<bool> cand;
  final List<bool> star;
  bool ok;
}

final _solvers = Expando<StarsSolver>();

/// Explains Stars with [StarsSolver]: full units, last places and squeezes,
/// then attacks and band counting, then probing stars. Stars are shown before
/// the dots they imply.
class StarsExplainer extends ValueGridExplainer<StarsPuzzle, StarsKnowledge> {
  const StarsExplainer();

  StarsSolver _solver(StarsPuzzle p) => _solvers[p] ??= StarsSolver(p.n, p.regions, k: p.k);

  @override
  int get levels => 3;

  @override
  bool probes(int level) => level == 3;

  @override
  StarsKnowledge seed(StarsPuzzle p, ValueGrid s) {
    final solver = _solver(p);
    final cand = solver.startCand();
    final star = List.filled(p.n * p.n, false);
    final known = knownValues(p, s);
    for (var i = 0; i < known.length; i++) {
      if (known[i] == sStar) solver.place(cand, star, i);
    }
    for (var i = 0; i < known.length; i++) {
      if (known[i] == sDot) cand[i] = false;
    }
    return StarsKnowledge(cand, star);
  }

  @override
  StarsKnowledge copy(StarsKnowledge k) => StarsKnowledge(List.of(k.cand), List.of(k.star), k.ok);

  @override
  bool propagate(StarsPuzzle p, StarsKnowledge k, int level, ExplainTrace? t) =>
      k.ok && _solver(p).propagate(k.cand, k.star, level, t);

  @override
  Iterable<(int, int)> probeCandidates(StarsPuzzle p, StarsKnowledge k) sync* {
    for (var i = 0; i < k.cand.length; i++) {
      if (k.cand[i]) yield (i, sStar);
    }
  }

  @override
  void assume(StarsPuzzle p, StarsKnowledge k, int slot, int value, ExplainTrace? t) {
    t?.fact(slot, sStar, ruleAssume);
    if (!_solver(p).place(k.cand, k.star, slot, t)) k.ok = false;
  }

  @override
  void refute(StarsPuzzle p, StarsKnowledge k, int slot, int value, ExplainTrace t) => k.cand[slot] = false;

  @override
  int? placed(StarsPuzzle p, Fact f) => switch (f.rule) {
    ruleAssume => null,
    ruleRefuted => sDot,
    _ => f.slot >= 0 ? f.value : null,
  };

  @override
  int rank(StarsPuzzle p, Fact f) {
    if (f.rule < 0) return 1;
    return switch (StarsRule.values[f.rule]) {
      StarsRule.fill || StarsRule.squeeze => 0,
      StarsRule.touch || StarsRule.full => 2,
      _ => 1,
    };
  }

  @override
  bool quiet(StarsPuzzle p, Fact f) =>
      f.rule >= 0 && (StarsRule.values[f.rule] == StarsRule.touch || StarsRule.values[f.rule] == StarsRule.full);

  @override
  Set<int> get optionalValues => const {sDot};

  @override
  ExplainLine? describe(StarsPuzzle p, Fact f) {
    final n = p.n;
    final solver = _solver(p);
    final pos = p.size.pos;
    String cell(int i) => cellTok(pos(i));
    Set<Pos> cells(Iterable<int> idx) => {for (final i in idx) pos(i)};
    final at = f.slot >= 0 ? cell(f.slot) : '';
    final a = f.args;
    final me = {if (f.slot >= 0) pos(f.slot)};
    // A unit as (kind, token): rows and columns by number, a region by its
    // first cell.
    String kind(int u) => u < n ? 'row' : (u < 2 * n ? 'col' : 'region');
    String unit(int u) => u < n ? rowTok(u) : (u < 2 * n ? colTok(u - n) : cell(solver.units[u].first));
    Set<Pos> unitCells(int u) => cells(solver.units[u]);
    // A band of lines: (kind, from, to); one line is 'row' or 'col'.
    String bandKind(List<int> a) => '${a[0] == 0 ? 'row' : 'col'}${a[1] == a[2] ? '' : 's'}';
    String line(int kind, int l) => kind == 0 ? rowTok(l) : colTok(l);
    Set<Pos> bandCells(List<int> a) => {
      for (var i = 0; i < n * n; i++)
        if ((a[0] == 0 ? i ~/ n : i % n) >= a[1] && (a[0] == 0 ? i ~/ n : i % n) <= a[2]) pos(i),
    };
    switch (f.rule) {
      case ruleAssume:
        return ExplainLine((l) => l.exStarsSuppose(at), me);
      case ruleRefuted:
        return ExplainLine((l) => l.exStarsRefuted(at), me);
    }
    switch (StarsRule.values[f.rule]) {
      case StarsRule.touch:
        return ExplainLine((l) => l.exStarsTouch(at, cell(a[0])), {...me, pos(a[0])});
      case StarsRule.full:
        return ExplainLine((l) => l.exStarsFull(at, kind(a[0]), unit(a[0])), {...me, ...unitCells(a[0])});
      case StarsRule.fill:
        return ExplainLine((l) => l.exStarsFill(at, kind(a[0]), unit(a[0])), {...me, ...unitCells(a[0])});
      case StarsRule.squeeze:
        return ExplainLine((l) => l.exStarsSqueeze(at, kind(a[0]), unit(a[0])), {...me, ...unitCells(a[0])});
      case StarsRule.attack:
        return ExplainLine((l) => l.exStarsAttack(at, kind(a[0]), unit(a[0])), {...me, ...unitCells(a[0])});
      case StarsRule.bandIn:
        return ExplainLine(
          (l) => l.exStarsBandIn(at, bandKind(a), line(a[0], a[1]), line(a[0], a[2])),
          {...me, ...cells(f.premises)},
        );
      case StarsRule.bandOut:
        return ExplainLine(
          (l) => l.exStarsBandOut(at, bandKind(a), line(a[0], a[1]), line(a[0], a[2])),
          {...me, ...cells(f.premises)},
        );
      case StarsRule.failEmpty:
        return ExplainLine((l) => l.exStarsFailEmpty(kind(a[0]), unit(a[0])), unitCells(a[0]));
      case StarsRule.failClash:
        return ExplainLine((l) => l.exStarsFailClash(cell(a[0]), cell(a[1])), cells(a));
      case StarsRule.failBand:
        return ExplainLine(
          (l) => l.exStarsFailBand(bandKind(a), line(a[0], a[1]), line(a[0], a[2])),
          bandCells(a),
        );
    }
  }
}
