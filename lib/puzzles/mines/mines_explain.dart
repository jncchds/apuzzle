import '../../core/explain.dart';
import '../../core/grid.dart';
import 'mines_model.dart';
import 'mines_solver.dart';

/// What [MinesExplainer] knows: the open cells (fixed for a step) and per
/// cell -1 unknown, 0 safe, 1 mine.
class MinesKnowledge {
  MinesKnowledge(this.open, this.k);

  final List<bool> open;
  final List<int> k;
}

final _solvers = Expando<MinesSolver>();

/// Explains Mines with [MinesSolver]: single numbers, pairs of numbers, the
/// mine total, then probing. Safe cells get dug, mines flagged; digging
/// comes first.
class MinesExplainer extends Explainer<MinesPuzzle, MinesState, MinesKnowledge> {
  const MinesExplainer();

  MinesSolver _solver(MinesPuzzle p) => _solvers[p] ??= MinesSolver(p.rows, p.cols, mineCounts(p), p.mineCount);

  @override
  GridSize size(MinesPuzzle p) => p.size;

  @override
  int get levels => 4;

  @override
  bool probes(int level) => level == 4;

  @override
  MinesKnowledge seed(MinesPuzzle p, MinesState s) {
    final k = [
      for (var i = 0; i < s.open.length; i++)
        s.open[i]
            ? 0
            : s.flags[i] && p.mines[i]
            ? 1
            : -1,
    ];
    return MinesKnowledge(s.open, k);
  }

  @override
  MinesKnowledge copy(MinesKnowledge k) => MinesKnowledge(k.open, List.of(k.k));

  @override
  bool propagate(MinesPuzzle p, MinesKnowledge k, int level, ExplainTrace? t) =>
      _solver(p).propagate(k.open, k.k, level, t);

  @override
  Iterable<(int, int)> probeCandidates(MinesPuzzle p, MinesKnowledge k) sync* {
    final kn = _solver(p).kn;
    for (var i = 0; i < k.k.length; i++) {
      if (k.k[i] != -1 || !kn[i].any((j) => k.open[j])) continue;
      yield (i, 1);
      yield (i, 0);
    }
  }

  @override
  void assume(MinesPuzzle p, MinesKnowledge k, int slot, int value, ExplainTrace? t) {
    k.k[slot] = value;
    t?.fact(slot, value, ruleAssume);
  }

  @override
  void refute(MinesPuzzle p, MinesKnowledge k, int slot, int value, ExplainTrace t) => k.k[slot] = 1 - value;

  int? _value(Fact f) => f.slot < 0 || f.rule == ruleAssume ? null : (f.rule == ruleRefuted ? 1 - f.value : f.value);

  @override
  MinesState? move(MinesPuzzle p, MinesState s, Fact f) {
    final v = _value(f);
    if (v == null) return null;
    if (v == 0) return s.open[f.slot] ? null : minesDig(p, s, [f.slot]);
    if (s.flags[f.slot]) return null;
    return MinesState(open: s.open, flags: List.of(s.flags)..[f.slot] = true, booms: s.booms);
  }

  @override
  int rank(MinesPuzzle p, Fact f) => _value(f) == 0 ? 0 : 1;

  @override
  Set<Pos> targets(MinesPuzzle p, Fact f) => {p.size.pos(f.slot)};

  @override
  (Pos, MinesState)? wrongEntry(MinesPuzzle p, MinesState s) {
    for (var i = 0; i < s.flags.length; i++) {
      if (s.flags[i] && !p.mines[i]) {
        return (p.size.pos(i), MinesState(open: s.open, flags: List.of(s.flags)..[i] = false, booms: s.booms));
      }
    }
    return null;
  }

  @override
  (Pos, MinesState)? reveal(MinesPuzzle p, MinesState s) {
    final kn = _solver(p).kn;
    int? pick;
    for (var i = 0; i < s.open.length; i++) {
      if (s.open[i] || p.mines[i]) continue;
      pick ??= i;
      if (kn[i].any((j) => s.open[j])) {
        pick = i;
        break;
      }
    }
    if (pick == null) return null;
    return (p.size.pos(pick), minesDig(p, s, [pick]));
  }

  @override
  bool done(MinesPuzzle p, MinesState s) => minesCleared(p, s.open);

  @override
  ExplainLine? describe(MinesPuzzle p, Fact f) {
    final pos = p.size.pos;
    String cell(int i) => cellTok(pos(i));
    final at = f.slot >= 0 ? cell(f.slot) : '';
    final me = {if (f.slot >= 0) pos(f.slot)};
    final here = {...me, for (final i in f.premises.take(18)) pos(i)};
    final mine = f.value == 1;
    switch (f.rule) {
      case ruleAssume:
        return ExplainLine((l) => mine ? l.exMinesSupposeMine(at) : l.exMinesSupposeSafe(at), me);
      case ruleRefuted:
        return ExplainLine((l) => mine ? l.exMinesRefutedMine(at) : l.exMinesRefutedSafe(at), me);
    }
    final a = f.args[0], b = f.args[1];
    final numbers = {if (a >= 0) pos(a), if (b >= 0) pos(b)};
    return switch (MinesRule.values[f.rule]) {
      MinesRule.numberSafe => ExplainLine((l) => l.exMinesNumberSafe(at, cell(a)), {...me, ...numbers}),
      MinesRule.numberMines => ExplainLine((l) => l.exMinesNumberMine(at, cell(a)), {...me, ...numbers}),
      MinesRule.totalSafe => ExplainLine((l) => l.exMinesTotalSafe(at), me),
      MinesRule.totalMines => ExplainLine((l) => l.exMinesTotalMine(at), me),
      MinesRule.pairSafe => ExplainLine((l) => l.exMinesPairSafe(at, cell(a), cell(b)), {...me, ...numbers}),
      MinesRule.pairMines => ExplainLine((l) => l.exMinesPairMine(at, cell(a), cell(b)), {...me, ...numbers}),
      MinesRule.failNumber => ExplainLine((l) => l.exMinesFailNumber(cell(a)), here),
      MinesRule.failTotal => ExplainLine((l) => l.exMinesFailTotal, const {}),
      MinesRule.failPair => ExplainLine((l) => l.exMinesFailPair(cell(a), cell(b)), numbers),
    };
  }
}
