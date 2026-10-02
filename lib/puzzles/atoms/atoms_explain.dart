import '../../core/explain.dart';
import '../../core/grid.dart';
import 'atoms_model.dart';
import 'atoms_solver.dart';

/// Bond bounds per edge for [AtomsExplainer].
class AtomsKnowledge {
  AtomsKnowledge(this.lo, this.hi);

  final List<int> lo;
  final List<int> hi;
}

final _solvers = Expando<AtomsSolver>();

/// Explains Atoms with [AtomsSolver]: island sums and crossings, probing
/// bond counts, then connectivity and probing with it. Facts are bounds
/// (slot 2e: least bonds of edge e, 2e + 1: most); raising the least is
/// what the board shows.
class AtomsExplainer extends Explainer<AtomsPuzzle, AtomsState, AtomsKnowledge> {
  const AtomsExplainer();

  AtomsSolver _solver(AtomsPuzzle p) => _solvers[p] ??= AtomsSolver(p);

  @override
  GridSize size(AtomsPuzzle p) => p.size;

  @override
  int get levels => 4;

  @override
  bool probes(int level) => level.isEven;

  @override
  AtomsKnowledge seed(AtomsPuzzle p, AtomsState s) {
    final solver = _solver(p);
    final lo = solver.initialLo(), hi = solver.initialHi();
    for (var e = 0; e < lo.length; e++) {
      if (s.bonds[e] <= p.solution[e] && s.bonds[e] > lo[e]) lo[e] = s.bonds[e];
    }
    return AtomsKnowledge(lo, hi);
  }

  @override
  AtomsKnowledge copy(AtomsKnowledge k) => AtomsKnowledge(List.of(k.lo), List.of(k.hi));

  @override
  bool propagate(AtomsPuzzle p, AtomsKnowledge k, int level, ExplainTrace? t) =>
      _solver(p).propagate(k.lo, k.hi, level >= 3, t);

  @override
  Iterable<(int, int)> probeCandidates(AtomsPuzzle p, AtomsKnowledge k) sync* {
    for (var e = 0; e < k.lo.length; e++) {
      if (k.lo[e] == k.hi[e]) continue;
      yield (2 * e, k.lo[e]);
      yield (2 * e + 1, k.hi[e]);
    }
  }

  @override
  void assume(AtomsPuzzle p, AtomsKnowledge k, int slot, int value, ExplainTrace? t) {
    final e = slot ~/ 2;
    k.lo[e] = value;
    k.hi[e] = value;
    t?.fact(slot, value, ruleAssume);
  }

  @override
  void refute(AtomsPuzzle p, AtomsKnowledge k, int slot, int value, ExplainTrace t) {
    final e = slot ~/ 2;
    if (slot.isEven) {
      k.lo[e] = value + 1;
    } else {
      k.hi[e] = value - 1;
    }
  }

  /// The least bonds [f] proves for its edge, or null.
  int? _atLeast(Fact f) {
    if (f.slot < 0 || f.slot.isOdd) return null;
    if (f.rule == ruleRefuted) return f.value + 1;
    return f.rule == AtomsRule.atLeast.index ? f.value : null;
  }

  @override
  AtomsState? move(AtomsPuzzle p, AtomsState s, Fact f) {
    final v = _atLeast(f);
    final e = f.slot ~/ 2;
    if (v == null || s.bonds[e] >= v) return null;
    return AtomsState(List.of(s.bonds)..[e] = v);
  }

  Set<Pos> _ends(AtomsPuzzle p, int e) => {
    p.size.pos(p.islands[p.edges[e].a]),
    p.size.pos(p.islands[p.edges[e].b]),
  };

  String _edge(AtomsPuzzle p, int e) =>
      linkTok(p.size.pos(p.islands[p.edges[e].a]), p.size.pos(p.islands[p.edges[e].b]));

  @override
  Set<Pos> targets(AtomsPuzzle p, Fact f) => _ends(p, f.slot ~/ 2);

  @override
  (Pos, AtomsState)? wrongEntry(AtomsPuzzle p, AtomsState s) {
    for (var e = 0; e < s.bonds.length; e++) {
      if (s.bonds[e] > p.solution[e]) {
        return (_ends(p, e).first, AtomsState(List.of(s.bonds)..[e] = p.solution[e]));
      }
    }
    return null;
  }

  @override
  (Pos, AtomsState)? reveal(AtomsPuzzle p, AtomsState s) {
    for (var e = 0; e < s.bonds.length; e++) {
      if (s.bonds[e] != p.solution[e]) {
        return (_ends(p, e).first, AtomsState(List.of(s.bonds)..[e] = p.solution[e]));
      }
    }
    return null;
  }

  @override
  bool done(AtomsPuzzle p, AtomsState s) {
    for (var e = 0; e < s.bonds.length; e++) {
      if (s.bonds[e] != p.solution[e]) return false;
    }
    return true;
  }

  @override
  ExplainLine? describe(AtomsPuzzle p, Fact f) {
    final e = f.slot >= 0 ? f.slot ~/ 2 : -1;
    final at = e >= 0 ? _edge(p, e) : '';
    final me = e >= 0 ? _ends(p, e) : <Pos>{};
    String island(int k) => cellTok(p.size.pos(p.islands[k]));
    final a = f.args;
    switch (f.rule) {
      case ruleAssume:
        return ExplainLine((l) => l.exAtomsSuppose(at, f.value), me);
      case ruleRefuted:
        return ExplainLine(
          (l) => f.slot.isEven ? l.exAtomsRefutedMore(at, f.value + 1) : l.exAtomsRefutedLess(f.value - 1, at),
          me,
        );
    }
    return switch (AtomsRule.values[f.rule]) {
      AtomsRule.atLeast => ExplainLine((l) => l.exAtomsAtLeast(at, f.value, island(a[0])), {
        ...me,
        p.size.pos(p.islands[a[0]]),
      }),
      AtomsRule.atMost => ExplainLine((l) => l.exAtomsAtMost(f.value, at, island(a[0])), {
        ...me,
        p.size.pos(p.islands[a[0]]),
      }),
      AtomsRule.cross => ExplainLine((l) => l.exAtomsCross(at, _edge(p, a[0])), {...me, ..._ends(p, a[0])}),
      AtomsRule.failSum => ExplainLine((l) => l.exAtomsFailSum(island(a[0])), {p.size.pos(p.islands[a[0]])}),
      AtomsRule.failCross => ExplainLine((l) => l.exAtomsFailCross(_edge(p, a[0]), _edge(p, a[1])), {
        ..._ends(p, a[0]),
        ..._ends(p, a[1]),
      }),
      AtomsRule.failConnect => ExplainLine((l) => l.exAtomsFailConnect, const {}),
    };
  }
}
