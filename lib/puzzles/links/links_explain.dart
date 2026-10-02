import '../../core/explain.dart';
import '../../core/grid.dart';
import '../../core/loop_explain.dart';
import 'links_model.dart';
import 'links_solver.dart';

final _solvers = Expando<LinksSolver>();

/// Explains Links with [LinksSolver] (edges between cell centres). The board
/// holds paths drawn from a dot, so a step is a link that starts or extends
/// one; links decided elsewhere are its reasons.
class LinksExplainer extends Explainer<LinksPuzzle, LinksState, List<int>> {
  const LinksExplainer();

  LinksSolver _solver(LinksPuzzle p) => _solvers[p] ??= LinksSolver(p.rows, p.cols, p.dots);

  @override
  GridSize size(LinksPuzzle p) => p.size;

  @override
  int get levels => 2;

  @override
  bool probes(int level) => level == 2;

  /// The solution path of pair [k] in the direction a path from [from] runs.
  List<int> _want(LinksPuzzle p, int k, int from) =>
      p.paths[k].first == from ? p.paths[k] : p.paths[k].reversed.toList();

  @override
  List<int> seed(LinksPuzzle p, LinksState s) {
    final g = _solver(p).g;
    final st = _solver(p).start();
    for (final path in s.paths) {
      for (var i = 0; i + 1 < path.length; i++) {
        final e = g.between(path[i], path[i + 1]);
        if (e >= 0) st[e] = 1;
      }
    }
    return st;
  }

  @override
  List<int> copy(List<int> k) => List.of(k);

  @override
  bool propagate(LinksPuzzle p, List<int> k, int level, ExplainTrace? t) => _solver(p).propagate(k, t);

  @override
  Iterable<(int, int)> probeCandidates(LinksPuzzle p, List<int> k) sync* {
    for (var e = 0; e < k.length; e++) {
      if (k[e] == -1) {
        yield (e, 1);
        yield (e, 0);
      }
    }
  }

  @override
  void assume(LinksPuzzle p, List<int> k, int slot, int value, ExplainTrace? t) {
    k[slot] = value;
    t?.fact(slot, value, ruleAssume);
  }

  @override
  void refute(LinksPuzzle p, List<int> k, int slot, int value, ExplainTrace t) => k[slot] = 1 - value;

  int? _value(Fact f) => f.slot < 0 || f.rule == ruleAssume ? null : (f.rule == ruleRefuted ? 1 - f.value : f.value);

  @override
  LinksState? move(LinksPuzzle p, LinksState s, Fact f) {
    if (_value(f) != 1) return null;
    final (a, b) = _solver(p).g.ends(f.slot);
    final taken = {for (final path in s.paths) ...path};
    for (var k = 0; k < s.paths.length; k++) {
      final path = s.paths[k];
      // A path is done once it reaches its pair's other dot.
      final done = path.length > 1 && p.dots[path.last] == k;
      for (final (from, to) in [(a, b), (b, a)]) {
        final next = path.isEmpty
            ? (p.dots[from] == k ? [from, to] : null)
            : (path.last == from && !done ? [...path, to] : null);
        if (next == null || taken.contains(to) || (p.dots[to] >= 0 && p.dots[to] != k)) continue;
        return _with(s, k, next);
      }
    }
    return null;
  }

  @override
  Set<Pos> targets(LinksPuzzle p, Fact f) => centredEdgeCells(_solver(p).g, f.slot);

  @override
  (Pos, LinksState)? wrongEntry(LinksPuzzle p, LinksState s) {
    for (var k = 0; k < s.paths.length; k++) {
      final path = s.paths[k];
      if (path.isEmpty) continue;
      if (p.dots[path.first] != k) return (p.size.pos(path.first), _with(s, k, const []));
      final want = _want(p, k, path.first);
      var n = 0;
      while (n < path.length && n < want.length && path[n] == want[n]) {
        n++;
      }
      if (n < path.length) return (p.size.pos(path[n]), _with(s, k, n < 2 ? const [] : path.sublist(0, n)));
    }
    return null;
  }

  LinksState _with(LinksState s, int k, List<int> path) => LinksState([
    for (var j = 0; j < s.paths.length; j++) j == k ? path : s.paths[j],
  ]);

  @override
  (Pos, LinksState)? reveal(LinksPuzzle p, LinksState s) {
    for (var k = 0; k < p.pairs; k++) {
      if (s.paths[k].length == p.paths[k].length) continue;
      final cells = p.paths[k].toSet();
      return (
        p.size.pos(p.paths[k].first),
        LinksState([
          for (var j = 0; j < p.pairs; j++)
            if (j == k) p.paths[k] else _cut(s.paths[j], cells),
        ]),
      );
    }
    return null;
  }

  static List<int> _cut(List<int> path, Set<int> taken) {
    final at = path.indexWhere(taken.contains);
    return at < 0 ? path : path.sublist(0, at);
  }

  @override
  bool done(LinksPuzzle p, LinksState s) {
    for (var k = 0; k < p.pairs; k++) {
      if (s.paths[k].length != p.paths[k].length) return false;
    }
    return true;
  }

  @override
  ExplainLine? describe(LinksPuzzle p, Fact f) {
    final g = _solver(p).g;
    final at = f.slot >= 0 ? centredEdgeTok(g, f.slot) : '';
    final me = f.slot >= 0 ? centredEdgeCells(g, f.slot) : <Pos>{};
    final a = f.args.isEmpty ? -1 : f.args[0];
    final on = f.value == 1;
    switch (f.rule) {
      case ruleAssume:
        return ExplainLine((l) => on ? l.exLinksSupposeOn(at) : l.exLinksSupposeOff(at), me);
      case ruleRefuted:
        return ExplainLine((l) => on ? l.exLinksRefutedOff(at) : l.exLinksRefutedOn(at), me);
    }
    final cell = a >= 0 ? cellTok(p.size.pos(a)) : '';
    final here = {...me, if (a >= 0) p.size.pos(a)};
    final dot = a >= 0 && p.dots[a] >= 0;
    return switch (LinksRule.values[f.rule]) {
      LinksRule.degreeDone => ExplainLine(
        (l) => dot ? l.exLinksDotDone(at, cell) : l.exLinksDegreeDone(at, cell),
        here,
      ),
      LinksRule.degreeNeed => ExplainLine(
        (l) => dot ? l.exLinksDotNeed(at, cell) : l.exLinksDegreeNeed(at, cell),
        here,
      ),
      LinksRule.loop => ExplainLine((l) => l.exLinksLoop(at), me),
      LinksRule.mixed => ExplainLine((l) => l.exLinksMixed(at), me),
      LinksRule.failBranch => ExplainLine((l) => l.exLinksFailBranch(cell), here),
      LinksRule.failStuck => ExplainLine((l) => l.exLinksFailStuck(cell), here),
      LinksRule.failLoop => ExplainLine((l) => l.exLinksFailLoop, const {}),
      LinksRule.failMixed => ExplainLine((l) => l.exLinksFailMixed, const {}),
    };
  }
}
