import '../../core/lattice_loop.dart';
import 'arrows_model.dart';

/// Arrows' own rules for a traced [ArrowsSolver] (ids from [loopRuleCount]).
/// Cell slots follow the edges ([Fact.value] 0 shaded, 1 on the loop); the
/// arg is the cell, or the clue for clue rules.
enum ArrowsRule {
  cellOn,
  cellShaded,
  shadeNoLine,
  shadeNeighbours,
  onNeed,
  clueDone,
  clueNeed,
  failStuck,
  failClueMany,
  failClueFew,
}

/// Loop logic plus shading. The state holds every edge, then one entry per
/// cell: -1 unknown, 0 shaded, 1 on the loop (clue cells: 2). Tier 1: loop
/// degrees and sub-loops, shaded cells keep the loop away and their
/// neighbours on it, and each clue's count against the room in its row or
/// column (a run of free cells takes at most every other cell shaded).
/// Tier 2: + probing cells (shaded or not).
class ArrowsSolver extends LoopSolver {
  ArrowsSolver(this.rows, this.cols, this.arrows, this.counts) : super(LatticeLoop(rows, cols)) {
    for (var i = 0; i < rows * cols; i++) {
      if (arrows[i] >= 0) {
        _clues.add(i);
        _rays[i] = arrowsRay(rows, cols, arrows, i);
      }
    }
  }

  factory ArrowsSolver.of(ArrowsPuzzle p) => ArrowsSolver(p.rows, p.cols, p.arrows, p.counts);

  final int rows;
  final int cols;
  final List<int> arrows;
  final List<int> counts;
  final List<int> _clues = [];
  final Map<int, List<int>> _rays = {};

  int get _e => g.edgeCount;

  @override
  List<int> initial() {
    final st = List<int>.filled(_e + rows * cols, -1);
    for (final i in _clues) {
      st[_e + i] = 2;
      for (final e in g.incident[i]) {
        st[e] = 0;
      }
    }
    return st;
  }

  List<int> _orth(int i) {
    final r = i ~/ cols, c = i % cols;
    return [if (r > 0) i - cols, if (c + 1 < cols) i + 1, if (r + 1 < rows) i + cols, if (c > 0) i - 1];
  }

  @override
  bool clues(List<int> st) {
    final n = rows * cols;
    for (var i = 0; i < n; i++) {
      final cell = st[_e + i];
      if (cell == 2) continue;
      var lines = 0, open = 0;
      for (final e in g.incident[i]) {
        if (st[e] == 1) lines++;
        if (st[e] == -1) open++;
      }
      because(_rule(ArrowsRule.cellOn), i);
      if (lines > 0 && !set(st, _e + i, 1)) return false;
      because(_rule(ArrowsRule.cellShaded), i);
      if (lines + open < 2 && !set(st, _e + i, 0)) return false;
      if (st[_e + i] == 0) {
        because(_rule(ArrowsRule.shadeNoLine), i);
        for (final e in g.incident[i]) {
          if (!set(st, e, 0)) return false;
        }
        because(_rule(ArrowsRule.shadeNeighbours), i);
        for (final j in _orth(i)) {
          if (st[_e + j] != 2 && !set(st, _e + j, 1)) return false;
        }
      } else if (st[_e + i] == 1) {
        if (lines + open < 2) return fail(_rule(ArrowsRule.failStuck), i);
        if (lines + open == 2) {
          because(_rule(ArrowsRule.onNeed), i);
          for (final e in g.incident[i]) {
            if (st[e] == -1 && !set(st, e, 1)) return false;
          }
        }
      }
    }
    for (final c in _clues) {
      final ray = _rays[c]!;
      var shaded = 0;
      // Runs of unknown cells next to each other on the grid.
      final runs = <List<int>>[];
      for (var k = 0; k < ray.length; k++) {
        final v = st[_e + ray[k]];
        if (v == 0) shaded++;
        if (v != -1) continue;
        final touching = k > 0 && runs.isNotEmpty && runs.last.last == ray[k - 1] && _next(ray[k - 1], ray[k]);
        if (touching) {
          runs.last.add(ray[k]);
        } else {
          runs.add([ray[k]]);
        }
      }
      final room = runs.fold(0, (a, r) => a + (r.length + 1) ~/ 2);
      final want = counts[c];
      if (shaded > want || shaded + room < want) {
        return fail(_rule(shaded > want ? ArrowsRule.failClueMany : ArrowsRule.failClueFew), c);
      }
      because(_rule(shaded == want ? ArrowsRule.clueDone : ArrowsRule.clueNeed), c);
      if (shaded == want) {
        for (final r in runs) {
          for (final i in r) {
            if (!set(st, _e + i, 1)) return false;
          }
        }
      } else if (shaded + room == want) {
        for (final r in runs) {
          if (r.length.isEven) continue;
          for (var k = 0; k < r.length; k++) {
            if (!set(st, _e + r[k], k.isEven ? 0 : 1)) return false;
          }
        }
      }
    }
    return true;
  }

  static int _rule(ArrowsRule r) => loopRuleCount + r.index;

  /// Clue cells, in the order the rules visit them.
  List<int> get clueCells => _clues;

  /// Cells a clue's arrow looks along.
  List<int> rayOf(int clue) => _rays[clue]!;

  @override
  List<int> premisesOf(int rule, int arg) {
    if (rule < loopRuleCount) return super.premisesOf(rule, arg);
    final r = ArrowsRule.values[rule - loopRuleCount];
    if (r == ArrowsRule.clueDone ||
        r == ArrowsRule.clueNeed ||
        r == ArrowsRule.failClueMany ||
        r == ArrowsRule.failClueFew) {
      return [for (final j in _rays[arg]!) _e + j];
    }
    return [...g.incident[arg], _e + arg, for (final j in _orth(arg)) _e + j];
  }

  bool _next(int a, int b) {
    final d = (a - b).abs();
    return d == cols || (d == 1 && a ~/ cols == b ~/ cols);
  }

  @override
  bool cluesMet(List<bool> lines) {
    final n = rows * cols;
    final shaded = [
      for (var i = 0; i < n; i++) arrows[i] < 0 && !g.incident[i].any((e) => lines[e]),
    ];
    for (var i = 0; i < n; i++) {
      if (!shaded[i]) continue;
      if (_orth(i).any((j) => shaded[j])) return false;
    }
    for (final c in _clues) {
      if (_rays[c]!.where((j) => shaded[j]).length != counts[c]) return false;
    }
    return true;
  }

  @override
  bool solved(List<int> st) => !st.contains(-1);

  /// The loop's edges in a solved state.
  List<bool> linesOf(List<int> st) => [for (var e = 0; e < _e; e++) st[e] == 1];

  /// Shaded cells in a solved state.
  List<bool> shadedOf(List<int> st) => [for (var i = 0; i < rows * cols; i++) st[_e + i] == 0];

  @override
  bool solve(List<int> st, int tier) {
    if (!propagate(st)) return false;
    if (tier >= 2) {
      var progress = true;
      while (progress && !solved(st)) {
        progress = false;
        for (var i = _e; i < st.length; i++) {
          if (st[i] != -1) continue;
          for (final v in const [0, 1]) {
            if (!propagate(List.of(st)..[i] = v)) {
              st[i] = 1 - v;
              if (!propagate(st)) return false;
              progress = true;
              break;
            }
          }
        }
      }
    }
    return solved(st) && g.isSingleLoop(linesOf(st));
  }

  /// Entries logic up to [tier] leaves open (all of them on a contradiction).
  int slack(int tier) {
    final st = initial();
    if (!solve(st, tier) && st.contains(-1)) return st.where((x) => x == -1).length;
    return solved(st) && g.isSingleLoop(linesOf(st)) ? 0 : st.length;
  }

  @override
  int countSolutions(List<int> st, {int limit = 2}) {
    final t = List.of(st);
    if (!propagate(t)) return 0;
    // Branch next to the drawn lines first (keeps the search local).
    var pick = -1;
    for (var e = 0; e < _e && pick < 0; e++) {
      if (t[e] != -1) continue;
      final (a, b) = g.ends(e);
      if ([...g.incident[a], ...g.incident[b]].any((f) => t[f] == 1)) pick = e;
    }
    if (pick < 0) pick = t.indexOf(-1);
    if (pick < 0) {
      final lines = linesOf(t);
      return g.isSingleLoop(lines) && cluesMet(lines) ? 1 : 0;
    }
    var total = 0;
    for (final v in const [1, 0]) {
      if (total >= limit) break;
      total += countSolutions(List.of(t)..[pick] = v, limit: limit - total);
    }
    return total;
  }
}
