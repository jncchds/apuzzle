import '../../core/explain.dart';
import '../../core/grid.dart';
import 'trail_logic.dart';
import 'trail_model.dart';

final _logics = Expando<TrailLogic>();

/// Explains Trail with [TrailLogic] (edges: 1 on, -1 off, 0 unknown). The
/// board only shows the path from its start, so the step is always the next
/// cell; the edges decided elsewhere are its reasons.
class TrailExplainer extends Explainer<TrailPuzzle, TrailState, List<int>> {
  const TrailExplainer();

  TrailLogic _logic(TrailPuzzle p) => _logics[p] ??= TrailLogic(p.rows, p.cols, p.numbers);

  @override
  GridSize size(TrailPuzzle p) => p.size;

  @override
  int get levels => 2;

  @override
  bool probes(int level) => level == 2;

  /// The edge between cells [a] and [b], or -1.
  int _edge(TrailLogic g, int a, int b) {
    for (final k in g.edgesOf[a]) {
      if (g.ea[k] == b || g.eb[k] == b) return k;
    }
    return -1;
  }

  @override
  List<int> seed(TrailPuzzle p, TrailState s) {
    final g = _logic(p);
    final e = List<int>.filled(g.edgeCount, 0);
    for (var i = 0; i + 1 < s.path.length; i++) {
      final k = _edge(g, s.path[i], s.path[i + 1]);
      if (k >= 0) e[k] = 1;
    }
    return e;
  }

  @override
  List<int> copy(List<int> k) => List.of(k);

  @override
  bool propagate(TrailPuzzle p, List<int> k, int level, ExplainTrace? t) => _logic(p).propagate(k, t);

  @override
  Iterable<(int, int)> probeCandidates(TrailPuzzle p, List<int> k) sync* {
    for (var e = 0; e < k.length; e++) {
      if (k[e] == 0) {
        yield (e, 1);
        yield (e, -1);
      }
    }
  }

  @override
  void assume(TrailPuzzle p, List<int> k, int slot, int value, ExplainTrace? t) {
    k[slot] = value;
    t?.fact(slot, value, ruleAssume);
  }

  @override
  void refute(TrailPuzzle p, List<int> k, int slot, int value, ExplainTrace t) => k[slot] = -value;

  int? _value(Fact f) => f.slot < 0 || f.rule == ruleAssume ? null : (f.rule == ruleRefuted ? -f.value : f.value);

  @override
  TrailState? move(TrailPuzzle p, TrailState s, Fact f) {
    if (_value(f) != 1) return null;
    final g = _logic(p);
    final path = s.path.isEmpty ? [p.startCell] : s.path;
    final end = path.last, a = g.ea[f.slot], b = g.eb[f.slot];
    final next = a == end ? b : (b == end ? a : -1);
    if (next < 0 || path.contains(next)) return null;
    return TrailState([...path, next]);
  }

  @override
  Set<Pos> targets(TrailPuzzle p, Fact f) {
    final g = _logic(p);
    return {p.size.pos(g.ea[f.slot]), p.size.pos(g.eb[f.slot])};
  }

  @override
  (Pos, TrailState)? wrongEntry(TrailPuzzle p, TrailState s) {
    var k = 0;
    while (k < s.path.length && k < p.solution.length && s.path[k] == p.solution[k]) {
      k++;
    }
    if (k == s.path.length) return null;
    return (p.size.pos(s.path[k]), TrailState(s.path.sublist(0, k)));
  }

  @override
  (Pos, TrailState)? reveal(TrailPuzzle p, TrailState s) {
    final k = s.path.length;
    if (k >= p.solution.length) return null;
    return (p.size.pos(p.solution[k]), TrailState(p.solution.sublist(0, k + 1)));
  }

  @override
  bool done(TrailPuzzle p, TrailState s) => s.path.length == p.solution.length;

  @override
  ExplainLine? describe(TrailPuzzle p, Fact f) {
    final g = _logic(p);
    final pos = p.size.pos;
    String edge(int k) => linkTok(pos(g.ea[k]), pos(g.eb[k]));
    Set<Pos> ends(int k) => {pos(g.ea[k]), pos(g.eb[k])};
    final at = f.slot >= 0 ? edge(f.slot) : '';
    final me = f.slot >= 0 ? ends(f.slot) : <Pos>{};
    final a = f.args.isEmpty ? -1 : f.args[0];
    final on = f.value == 1;
    switch (f.rule) {
      case ruleAssume:
        return ExplainLine((l) => on ? l.exTrailSupposeOn(at) : l.exTrailSupposeOff(at), me);
      case ruleRefuted:
        return ExplainLine((l) => on ? l.exTrailRefutedOff(at) : l.exTrailRefutedOn(at), me);
    }
    final cell = a >= 0 ? cellTok(pos(a)) : '';
    final here = {...me, if (a >= 0) pos(a)};
    return switch (TrailRule.values[f.rule]) {
      TrailRule.degreeDone => ExplainLine(
        (l) => g.target[a] == 1 ? l.exTrailEndDone(at, cell) : l.exTrailDegreeDone(at, cell),
        here,
      ),
      TrailRule.degreeNeed => ExplainLine((l) => l.exTrailDegreeNeed(at, cell), here),
      TrailRule.loop => ExplainLine((l) => l.exTrailLoop(at), me),
      TrailRule.order => ExplainLine((l) => l.exTrailOrder(at), me),
      TrailRule.early => ExplainLine((l) => l.exTrailEarly(at), me),
      TrailRule.failBranch => ExplainLine((l) => l.exTrailFailBranch(cell), here),
      TrailRule.failStuck => ExplainLine((l) => l.exTrailFailStuck(cell), here),
      TrailRule.failOrder => ExplainLine((l) => l.exTrailFailOrder, const {}),
      TrailRule.failLoop => ExplainLine((l) => l.exTrailFailLoop, const {}),
      TrailRule.failConnect => ExplainLine((l) => l.exTrailFailConnect, const {}),
    };
  }
}
