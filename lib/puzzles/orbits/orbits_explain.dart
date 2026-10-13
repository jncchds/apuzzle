import 'dart:typed_data';

import '../../core/explain.dart';
import '../../core/grid.dart';
import 'orbits_model.dart';
import 'orbits_solver.dart';

final _solvers = Expando<OrbitsSolver>();

/// Explains Orbits with [OrbitsSolver]: twins and ways to a star, cells that
/// keep a region in one piece, then probing. A slot is a cell and a star.
class OrbitsExplainer extends Explainer<OrbitsPuzzle, OrbitsState, Uint8List> {
  const OrbitsExplainer();

  static const _placing = {OrbitsRule.only, OrbitsRule.twin, OrbitsRule.bridge};

  OrbitsSolver _solver(OrbitsPuzzle p) => _solvers[p] ??= OrbitsSolver(p.geo);

  @override
  GridSize size(OrbitsPuzzle p) => p.size;

  @override
  int get levels => 3;

  @override
  bool probes(int level) => level == 3;

  @override
  Uint8List seed(OrbitsPuzzle p, OrbitsState s) => _solver(p).start([
    for (var i = 0; i < s.owner.length; i++) s.owner[i] == p.solution[i] ? s.owner[i] : p.geo.home[i],
  ]);

  @override
  Uint8List copy(Uint8List k) => Uint8List.fromList(k);

  @override
  void start(OrbitsPuzzle p, Uint8List k, ExplainTrace t) {
    final s = _solver(p);
    for (var i = 0; i < s.n; i++) {
      final one = s.starOf(k, i);
      if (one >= 0) t.fact(i * s.count + one, one, OrbitsRule.only.index);
    }
  }

  @override
  bool propagate(OrbitsPuzzle p, Uint8List k, int level, ExplainTrace? t) =>
      _solver(p).propagate(k, level < 2 ? 1 : 2, t);

  @override
  Iterable<(int, int)> probeCandidates(OrbitsPuzzle p, Uint8List k) sync* {
    final s = _solver(p);
    final options = [for (var i = 0; i < s.n; i++) s.options(k, i)];
    final most = options.fold(0, (a, b) => a > b ? a : b);
    for (var want = 2; want <= most; want++) {
      for (var i = 0; i < s.n; i++) {
        if (options[i] != want) continue;
        for (var star = 0; star < s.count; star++) {
          if (k[i * s.count + star] != 0) yield (i * s.count + star, star);
        }
      }
    }
  }

  @override
  void assume(OrbitsPuzzle p, Uint8List k, int slot, int value, ExplainTrace? t) =>
      _solver(p).decide(k, slot ~/ p.geo.count, value, t, ruleAssume);

  @override
  void refute(OrbitsPuzzle p, Uint8List k, int slot, int value, ExplainTrace t) {
    final s = _solver(p), i = slot ~/ s.count;
    k[slot] = 0;
    final one = s.starOf(k, i);
    if (one >= 0) t.fact(i * s.count + one, one, OrbitsRule.only.index, premises: s.slots(i, one));
  }

  bool _places(Fact f) => f.rule >= 0 && _placing.contains(OrbitsRule.values[f.rule]);

  @override
  OrbitsState? move(OrbitsPuzzle p, OrbitsState s, Fact f) {
    if (!_places(f)) return null;
    final next = p.geo.paint(s.owner, f.slot ~/ p.geo.count, f.value);
    return next == null ? null : OrbitsState(next);
  }

  @override
  Set<Pos> targets(OrbitsPuzzle p, Fact f) {
    final i = f.slot ~/ p.geo.count;
    return {p.size.pos(i), p.size.pos(p.geo.twin(i, f.value))};
  }

  @override
  (Pos, OrbitsState)? wrongEntry(OrbitsPuzzle p, OrbitsState s) {
    for (var i = 0; i < s.owner.length; i++) {
      if (s.owner[i] >= 0 && s.owner[i] != p.solution[i]) {
        return (p.size.pos(i), OrbitsState(p.geo.paint(s.owner, i, -1)!));
      }
    }
    return null;
  }

  @override
  (Pos, OrbitsState)? reveal(OrbitsPuzzle p, OrbitsState s) {
    for (var i = 0; i < s.owner.length; i++) {
      if (s.owner[i] != p.solution[i]) return (p.size.pos(i), OrbitsState(p.geo.paint(s.owner, i, p.solution[i])!));
    }
    return null;
  }

  @override
  bool done(OrbitsPuzzle p, OrbitsState s) {
    for (var i = 0; i < s.owner.length; i++) {
      if (s.owner[i] != p.solution[i]) return false;
    }
    return true;
  }

  @override
  ExplainLine? describe(OrbitsPuzzle p, Fact f) {
    final g = p.geo, pos = p.size.pos;
    String cell(int i) => cellTok(pos(i));
    final a = f.args;
    if (f.slot < 0) return ExplainLine((l) => l.exOrbitsFailEmpty(cell(a[0])), {pos(a[0])});
    final i = f.slot ~/ g.count, k = f.value;
    final home = {for (final x in g.core[k]) pos(x)};
    final star = cellsTok(home);
    final at = cell(i);
    final here = {pos(i), ...home};
    switch (f.rule) {
      case ruleAssume:
        return ExplainLine((l) => l.exOrbitsSuppose(at, star), here);
      case ruleRefuted:
        return ExplainLine((l) => l.exOrbitsRefuted(at, star), here);
    }
    return switch (OrbitsRule.values[f.rule]) {
      OrbitsRule.twinOut => ExplainLine((l) => l.exOrbitsTwinOut(at, star, cell(a[0])), {...here, pos(a[0])}),
      OrbitsRule.reach => ExplainLine((l) => l.exOrbitsReach(at, star), here),
      OrbitsRule.only => ExplainLine((l) => l.exOrbitsOnly(at, star), here),
      OrbitsRule.twin => ExplainLine((l) => l.exOrbitsTwin(at, star, cell(a[0])), {...here, pos(a[0])}),
      OrbitsRule.bridge => ExplainLine((l) => l.exOrbitsBridge(at, star, cell(a[0])), {...here, pos(a[0])}),
      OrbitsRule.taken || OrbitsRule.failEmpty => null,
    };
  }
}
