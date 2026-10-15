import '../../core/explain.dart';
import '../../core/grid.dart';
import 'waymarks_model.dart';
import 'waymarks_solver.dart';

final _solvers = Expando<WaymarksSolver>();

/// Explains Waymarks with [WaymarksSolver]. The board holds links, so a step
/// is a link; ruled-out links and the numbers cells can hold are reasons.
class WaymarksExplainer extends Explainer<WaymarksPuzzle, WaymarksState, WaymarksKnow> {
  const WaymarksExplainer();

  WaymarksSolver _solver(WaymarksPuzzle p) => _solvers[p] ??= WaymarksSolver(p);

  /// The cell each cell leads on to in the solution, or -1.
  static List<int> solutionNext(WaymarksPuzzle p) {
    final next = List<int>.filled(p.cells, -1);
    for (var k = 0; k + 1 < p.cells; k++) {
      next[p.path[k]] = p.path[k + 1];
    }
    return next;
  }

  @override
  GridSize size(WaymarksPuzzle p) => p.size;

  @override
  int get levels => 3;

  @override
  bool probes(int level) => level == 3;

  @override
  WaymarksKnow seed(WaymarksPuzzle p, WaymarksState s) {
    final want = solutionNext(p);
    final k = _solver(p).start();
    _solver(p).seedLinks(k, [for (var c = 0; c < p.cells; c++) s.next[c] == want[c] ? want[c] : -1]);
    return k;
  }

  @override
  WaymarksKnow copy(WaymarksKnow k) => WaymarksKnow.copy(k);

  @override
  bool propagate(WaymarksPuzzle p, WaymarksKnow k, int level, ExplainTrace? t) => _solver(p).propagate(k, level, t);

  @override
  Iterable<(int, int)> probeCandidates(WaymarksPuzzle p, WaymarksKnow k) sync* {
    for (var e = 0; e < k.edge.length; e++) {
      if (k.edge[e] == -1) {
        yield (e, 1);
        yield (e, 0);
      }
    }
  }

  @override
  void assume(WaymarksPuzzle p, WaymarksKnow k, int slot, int value, ExplainTrace? t) {
    k.edge[slot] = value;
    t?.fact(slot, value, ruleAssume);
  }

  @override
  void refute(WaymarksPuzzle p, WaymarksKnow k, int slot, int value, ExplainTrace t) => k.edge[slot] = 1 - value;

  bool _isEdge(WaymarksPuzzle p, Fact f) => f.slot >= 0 && f.slot < _solver(p).edges;

  @override
  WaymarksState? move(WaymarksPuzzle p, WaymarksState s, Fact f) {
    if (!_isEdge(p, f) || f.rule == ruleAssume) return null;
    final on = f.rule == ruleRefuted ? f.value == 0 : f.value == 1;
    if (!on) return null;
    final a = _solver(p).from[f.slot], b = _solver(p).to[f.slot];
    if (s.next[a] == b) return null;
    return WaymarksState(List.of(s.next)..[a] = b);
  }

  @override
  Set<Pos> targets(WaymarksPuzzle p, Fact f) =>
      _isEdge(p, f) ? {p.size.pos(_solver(p).from[f.slot]), p.size.pos(_solver(p).to[f.slot])} : const {};

  @override
  bool quiet(WaymarksPuzzle p, Fact f) => f.rule == WaymarksRule.taken.index;

  @override
  (Pos, WaymarksState)? wrongEntry(WaymarksPuzzle p, WaymarksState s) {
    final want = solutionNext(p);
    for (final c in p.path) {
      if (s.next[c] >= 0 && s.next[c] != want[c]) return (p.size.pos(c), WaymarksState(List.of(s.next)..[c] = -1));
    }
    return null;
  }

  @override
  (Pos, WaymarksState)? reveal(WaymarksPuzzle p, WaymarksState s) {
    final want = solutionNext(p);
    for (final c in p.path) {
      if (want[c] < 0 || s.next[c] == want[c]) continue;
      final next = [for (final j in s.next) j == want[c] ? -1 : j]..[c] = want[c];
      return (p.size.pos(c), WaymarksState(next));
    }
    return null;
  }

  @override
  bool done(WaymarksPuzzle p, WaymarksState s) {
    final want = solutionNext(p);
    for (var c = 0; c < p.cells; c++) {
      if (s.next[c] != want[c]) return false;
    }
    return true;
  }

  @override
  ExplainLine? describe(WaymarksPuzzle p, Fact f) {
    final sv = _solver(p);
    String cell(int i) => cellTok(p.size.pos(i));
    if (_isEdge(p, f)) {
      final a = sv.from[f.slot], b = sv.to[f.slot];
      final from = cell(a), to = cell(b);
      final here = {p.size.pos(a), p.size.pos(b)};
      final on = f.value == 1;
      switch (f.rule) {
        case ruleAssume:
          return ExplainLine((l) => on ? l.exWaymarksSupposeOn(from, to) : l.exWaymarksSupposeOff(from, to), here);
        case ruleRefuted:
          return ExplainLine((l) => on ? l.exWaymarksRefutedOff(from, to) : l.exWaymarksRefutedOn(from, to), here);
      }
      final args = f.args;
      return switch (WaymarksRule.values[f.rule]) {
        WaymarksRule.onlyOut => ExplainLine((l) => l.exWaymarksOnlyOut(from, to), here),
        WaymarksRule.onlyIn => ExplainLine((l) => l.exWaymarksOnlyIn(from, to), here),
        WaymarksRule.taken => () {
          // args: the link that took the place.
          final x = cell(args[0]), y = cell(args[1]);
          return ExplainLine(
            (l) => l.exWaymarksTaken(x, y),
            {p.size.pos(args[0]), p.size.pos(args[1])},
            ('taken', args[0], args[1]),
          );
        }(),
        WaymarksRule.consecutive => ExplainLine((l) => l.exWaymarksConsecutive(from, to, args[2], args[3]), here),
        WaymarksRule.apart => ExplainLine((l) => l.exWaymarksApart(from, to, args[2], args[3]), here),
        WaymarksRule.loop => ExplainLine((l) => l.exWaymarksLoop(from, to), here),
        WaymarksRule.noFit => ExplainLine((l) => l.exWaymarksNoFit(from, to), here),
        _ => null,
      };
    }
    if (f.slot < 0) {
      final a = f.args.isEmpty ? -1 : f.args[0];
      final at = a >= 0 ? cell(a) : '';
      final here = {if (a >= 0) p.size.pos(a), if (f.args.length > 1) p.size.pos(f.args[1])};
      return switch (WaymarksRule.values[f.rule]) {
        WaymarksRule.failStuck => ExplainLine((l) => l.exWaymarksFailStuck(at), here),
        WaymarksRule.failNoPrev => ExplainLine((l) => l.exWaymarksFailNoPrev(at), here),
        WaymarksRule.failNumber => ExplainLine((l) => l.exWaymarksFailNumber(at), here),
        WaymarksRule.failLoop => ExplainLine((l) => l.exWaymarksFailLoop(at), here),
        WaymarksRule.failLink => ExplainLine((l) => l.exWaymarksFailLink(at, cell(f.args[1])), here),
        _ => null,
      };
    }
    // A cell's numbers: a story tells only what each cell ends up with.
    final c = f.slot - sv.edges;
    final at = cell(c);
    final here = {p.size.pos(c)};
    final nums = waymarksRanges(f.args);
    final key = ('numbers', c);
    return switch (WaymarksRule.values[f.rule]) {
      WaymarksRule.numberOn => ExplainLine((l) => l.exWaymarksNumberOn(at, nums), here, key, true),
      WaymarksRule.before ||
      WaymarksRule.after ||
      WaymarksRule.used => ExplainLine((l) => l.exWaymarksNumbers(at, nums), here, key, true),
      _ => null,
    };
  }
}

/// Sorted numbers as runs: "2–5, 9".
String waymarksRanges(List<int> xs) {
  final out = <String>[];
  for (var i = 0; i < xs.length;) {
    var j = i;
    while (j + 1 < xs.length && xs[j + 1] == xs[j] + 1) {
      j++;
    }
    out.add(j == i ? '${xs[i]}' : (j == i + 1 ? '${xs[i]}, ${xs[j]}' : '${xs[i]}–${xs[j]}'));
    i = j + 1;
  }
  return out.join(', ');
}
