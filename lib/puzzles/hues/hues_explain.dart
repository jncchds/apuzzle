import '../../core/explain.dart';
import '../../core/grid.dart';
import '../../core/value_grid.dart';
import '../../core/value_grid_explain.dart';
import 'hues_model.dart';
import 'hues_solver.dart';

final _solvers = Expando<HuesSolver>();

/// Explains Hues with [HuesSolver]: clue counting, then probing colors.
class HuesExplainer extends ValueGridExplainer<HuesPuzzle, List<int>> {
  const HuesExplainer();

  HuesSolver _solver(HuesPuzzle p) => _solvers[p] ??= HuesSolver(
    rows: p.rows,
    cols: p.cols,
    colors: p.colors,
    clueNum: p.clues,
    clueColor: p.solution,
  );

  @override
  int get levels => 2;

  @override
  bool probes(int level) => level == 2;

  @override
  List<int> seed(HuesPuzzle p, ValueGrid s) {
    final dom = _solver(p).initialDomains();
    final known = knownValues(p, s);
    for (var i = 0; i < dom.length; i++) {
      if (p.clues[i] == null && known[i] >= 0) dom[i] = 1 << known[i];
    }
    return dom;
  }

  @override
  List<int> copy(List<int> k) => List.of(k);

  @override
  bool propagate(HuesPuzzle p, List<int> k, int level, ExplainTrace? t) => _solver(p).propagate(k, t);

  static bool _single(int m) => m & (m - 1) == 0;

  @override
  Iterable<(int, int)> probeCandidates(HuesPuzzle p, List<int> k) sync* {
    for (var i = 0; i < k.length; i++) {
      if (p.clues[i] != null || _single(k[i])) continue;
      for (var c = 0; c < p.colors; c++) {
        if (k[i] & (1 << c) != 0) yield (i, c);
      }
    }
  }

  @override
  void assume(HuesPuzzle p, List<int> k, int slot, int value, ExplainTrace? t) {
    k[slot] = 1 << value;
    t?.fact(slot, value, ruleAssume);
  }

  @override
  void refute(HuesPuzzle p, List<int> k, int slot, int value, ExplainTrace t) {
    k[slot] &= ~(1 << value);
    if (k[slot] != 0 && _single(k[slot])) {
      t.fact(slot, k[slot].bitLength - 1, HuesRule.single.index, premises: [slot]);
    }
  }

  @override
  int? placed(HuesPuzzle p, Fact f) => switch (f.rule) {
    ruleAssume || ruleRefuted => null,
    _ => switch (HuesRule.values[f.rule]) {
      HuesRule.need || HuesRule.single => f.value,
      _ => null,
    },
  };

  @override
  ExplainLine? describe(HuesPuzzle p, Fact f) {
    final pos = p.size.pos;
    String cell(int i) => cellTok(pos(i));
    final at = f.slot >= 0 ? cell(f.slot) : '';
    final me = {if (f.slot >= 0) pos(f.slot)};
    final a = f.args;
    // A clue with its neighbours.
    Set<Pos> around(int c) => {pos(c), for (final j in _solver(p).clueNb[c]!) pos(j)};
    switch (f.rule) {
      case ruleAssume:
        return ExplainLine((l) => l.exSuppose(at, valTok(f.value)), me);
      case ruleRefuted:
        return ExplainLine((l) => l.exRefuted(at, valTok(f.value)), me);
    }
    switch (HuesRule.values[f.rule]) {
      case HuesRule.full:
        final c = a[0];
        return ExplainLine((l) => l.exHuesFull(at, valTok(p.solution[c]), cell(c), p.clues[c]!), {...me, ...around(c)});
      case HuesRule.need:
        final c = a[0];
        return ExplainLine((l) => l.exHuesNeed(at, valTok(f.value), cell(c), p.clues[c]!), {...me, ...around(c)});
      case HuesRule.single:
        return ExplainLine((l) => l.exHuesSingle(at, valTok(f.value)), me);
      case HuesRule.failEmpty:
        return ExplainLine((l) => l.exHuesFailEmpty(cell(a[0])), {pos(a[0])});
      case HuesRule.failMany:
        final c = a[0];
        return ExplainLine((l) => l.exHuesFailMany(cell(c), valTok(p.solution[c])), around(c));
      case HuesRule.failFew:
        final c = a[0];
        return ExplainLine((l) => l.exHuesFailFew(cell(c), valTok(p.solution[c])), around(c));
    }
  }
}
