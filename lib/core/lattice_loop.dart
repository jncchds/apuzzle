import 'dart:math';

/// A lattice of [vr] × [vc] points joined by unit edges, for "draw one loop"
/// puzzles. Edge ids: horizontal edges row by row, then vertical ones.
class LatticeLoop {
  LatticeLoop(this.vr, this.vc) {
    for (var e = 0; e < edgeCount; e++) {
      final (a, b) = ends(e);
      incident[a].add(e);
      incident[b].add(e);
    }
  }

  final int vr;
  final int vc;
  late final List<List<int>> incident = List.generate(vr * vc, (_) => <int>[]);

  int get vertexCount => vr * vc;
  int get hCount => vr * (vc - 1);
  int get edgeCount => hCount + (vr - 1) * vc;

  /// Edge from point (r, c) to (r, c + 1).
  int h(int r, int c) => r * (vc - 1) + c;

  /// Edge from point (r, c) to (r + 1, c).
  int v(int r, int c) => hCount + r * vc + c;

  bool isHorizontal(int e) => e < hCount;

  /// Endpoints (point indices r * vc + c), lower one first.
  (int, int) ends(int e) {
    if (e < hCount) {
      final r = e ~/ (vc - 1), c = e % (vc - 1);
      return (r * vc + c, r * vc + c + 1);
    }
    final k = e - hCount, r = k ~/ vc, c = k % vc;
    return (r * vc + c, (r + 1) * vc + c);
  }

  /// Edge between two points, or -1.
  int between(int a, int b) {
    if (a > b) return between(b, a);
    final ra = a ~/ vc, ca = a % vc, rb = b ~/ vc, cb = b % vc;
    if (ra == rb && cb == ca + 1) return h(ra, ca);
    if (ca == cb && rb == ra + 1) return v(ra, ca);
    return -1;
  }

  /// Edge leaving point [p] in direction (dr, dc), or -1 at the border.
  int step(int p, int dr, int dc) {
    final r = p ~/ vc + dr, c = p % vc + dc;
    if (r < 0 || c < 0 || r >= vr || c >= vc) return -1;
    return between(p, r * vc + c);
  }

  /// Whether the [lines] form exactly one closed loop.
  bool isSingleLoop(List<bool> lines) {
    var start = -1, count = 0;
    for (var p = 0; p < vertexCount; p++) {
      final d = incident[p].where((e) => lines[e]).length;
      if (d != 0 && d != 2) return false;
      if (d == 2) {
        count++;
        if (start < 0) start = p;
      }
    }
    if (start < 0) return false;
    // Walk the loop from start.
    var prev = -1, cur = start, seen = 0;
    do {
      final next = incident[cur].where((e) => lines[e]).map((e) {
        final (a, b) = ends(e);
        return a == cur ? b : a;
      }).firstWhere((q) => q != prev, orElse: () => prev);
      prev = cur;
      cur = next;
      seen++;
    } while (cur != start && seen <= count);
    return seen == count;
  }

  /// Points where the [lines] break the loop rules (branching or dead ends).
  Set<int> badPoints(List<bool> lines) => {
        for (var p = 0; p < vertexCount; p++)
          if (incident[p].where((e) => lines[e]).length case final d when d != 0 && d != 2) p,
      };

  /// The loop around a region of unit squares ([faces], (vr-1) × (vc-1)).
  List<bool> boundary(List<bool> faces) {
    final fc = vc - 1, fr = vr - 1;
    bool inside(int r, int c) => r >= 0 && c >= 0 && r < fr && c < fc && faces[r * fc + c];
    return [
      for (var e = 0; e < edgeCount; e++)
        if (e < hCount)
          inside(e ~/ (vc - 1) - 1, e % (vc - 1)) != inside(e ~/ (vc - 1), e % (vc - 1))
        else
          inside((e - hCount) ~/ vc, (e - hCount) % vc - 1) != inside((e - hCount) ~/ vc, (e - hCount) % vc),
    ];
  }
}

/// Edge marks drawn by the player: 0 empty, 1 line, 2 cross.
class LoopMarks {
  const LoopMarks(this.marks);

  final List<int> marks;

  List<bool> get lines => [for (final m in marks) m == 1];

  Map<String, dynamic> toJson() => {'m': marks};
  factory LoopMarks.fromJson(Map<String, dynamic> j) => LoopMarks((j['m'] as List).cast<int>());
}

/// A region of [fr] × [fc] unit squares whose outline is one simple loop:
/// connected, no holes, and never touching itself only at a corner.
class LoopRegion {
  LoopRegion(this.fr, this.fc) : inside = List<bool>.filled(fr * fc, false);

  final int fr;
  final int fc;
  final List<bool> inside;

  int get n => fr * fc;

  List<int> neighbors(int i) {
    final r = i ~/ fc, c = i % fc;
    return [if (r > 0) i - fc, if (c + 1 < fc) i + 1, if (r + 1 < fr) i + fc, if (c > 0) i - 1];
  }

  bool _at(int r, int c) => r >= 0 && c >= 0 && r < fr && c < fc && inside[r * fc + c];

  /// Whether square [i] can switch sides keeping the outline one simple loop.
  bool canToggle(int i) {
    inside[i] = !inside[i];
    final ok = _valid(i);
    inside[i] = !inside[i];
    return ok;
  }

  bool _valid(int i) {
    final r = i ~/ fc, c = i % fc;
    for (final (pr, pc) in [(r, c), (r, c + 1), (r + 1, c), (r + 1, c + 1)]) {
      final a = _at(pr - 1, pc - 1), b = _at(pr - 1, pc), x = _at(pr, pc - 1), y = _at(pr, pc);
      if (a == y && b == x && a != b) return false;
    }
    // The region is one piece, and so is the outside (through the border).
    final seen = List<bool>.filled(n, false);
    List<int> flood(bool side, Iterable<int> from) {
      final queue = [for (final k in from) if (!seen[k] && inside[k] == side) k];
      for (final k in queue) {
        seen[k] = true;
      }
      for (var q = 0; q < queue.length; q++) {
        for (final j in neighbors(queue[q])) {
          if (!seen[j] && inside[j] == side) {
            seen[j] = true;
            queue.add(j);
          }
        }
      }
      return queue;
    }

    final start = inside.indexOf(true);
    if (start < 0) return false;
    final region = flood(true, [start]).length;
    final border = [
      for (var k = 0; k < n; k++)
        if (k ~/ fc == 0 || k % fc == 0 || k ~/ fc == fr - 1 || k % fc == fc - 1) k,
    ];
    final outside = flood(false, border).length;
    return region + outside == n;
  }

  /// Grows from a random square towards [share] of the squares, preferring
  /// thin branches so the loop wiggles, or with [compact], filling in corners
  /// so the loop gets long straight runs.
  void grow(Random rng, double share, {bool compact = false}) {
    if (!inside.contains(true)) inside[rng.nextInt(n)] = true;
    var size = inside.where((x) => x).length;
    final target = max(2, (n * share).round());
    var fails = 0;
    while (size < target && fails < n * 4) {
      final cand = <int>[];
      final weight = <double>[];
      for (var i = 0; i < n; i++) {
        if (inside[i]) continue;
        final k = neighbors(i).where((j) => inside[j]).length;
        if (k == 0) continue;
        cand.add(i);
        weight.add(compact ? const [0.0, 1.0, 4.0, 3.0, 3.0][k] : const [0.0, 3.0, 1.0, 0.3, 0.3][k]);
      }
      if (cand.isEmpty) break;
      var pick = rng.nextDouble() * weight.fold(0.0, (a, b) => a + b);
      var i = cand.last;
      for (var k = 0; k < cand.length; k++) {
        pick -= weight[k];
        if (pick <= 0) {
          i = cand[k];
          break;
        }
      }
      if (canToggle(i)) {
        inside[i] = true;
        size++;
      } else {
        fails++;
      }
    }
  }
}

/// A random [LoopRegion] (see [LoopRegion.grow]) as a square mask.
List<bool> randomLoopRegion(int fr, int fc, Random rng, double share, {bool compact = false}) =>
    (LoopRegion(fr, fc)..grow(rng, share, compact: compact)).inside;

/// Edge knowledge: -1 unknown, 0 no line (cross), 1 line.
/// Tier 1: point degrees (0 or 2), the puzzle's clue rules and no early
/// sub-loops. Tier 2: + probing (try an edge, refute it by propagation).
abstract class LoopSolver {
  LoopSolver(this.g);

  final LatticeLoop g;
  bool _changed = false;

  /// Applies the clue rules (using [set]); false on a contradiction.
  bool clues(List<int> st);

  /// Whether a complete set of [lines] satisfies every clue.
  bool cluesMet(List<bool> lines);

  /// Initial knowledge (edges ruled out up front).
  List<int> initial() => List<int>.filled(g.edgeCount, -1);

  /// Fixes edge [e] to [v]; false if it is already the other way.
  bool set(List<int> st, int e, int v) {
    if (e < 0) return v == 0;
    if (st[e] == v) return true;
    if (st[e] != -1) return false;
    st[e] = v;
    _changed = true;
    return true;
  }

  bool propagate(List<int> st) {
    do {
      _changed = false;
      for (var p = 0; p < g.vertexCount; p++) {
        var lines = 0, open = 0;
        for (final e in g.incident[p]) {
          if (st[e] == 1) lines++;
          if (st[e] == -1) open++;
        }
        if (lines > 2 || (lines == 1 && open == 0)) return false;
        if (open == 0) continue;
        if (lines == 2 || (lines == 0 && open == 1)) {
          for (final e in g.incident[p]) {
            if (st[e] == -1) set(st, e, 0);
          }
        } else if (lines == 1 && open == 1) {
          for (final e in g.incident[p]) {
            if (st[e] == -1) set(st, e, 1);
          }
        }
      }
      if (!clues(st)) return false;
      if (!_changed && !_subloops(st)) return false;
    } while (_changed);
    return true;
  }

  /// Closing a loop early is only allowed if it finishes the puzzle.
  bool _subloops(List<int> st) {
    final parent = List<int>.generate(g.vertexCount, (i) => i);
    int find(int x) {
      while (parent[x] != x) {
        x = parent[x] = parent[parent[x]];
      }
      return x;
    }

    var total = 0;
    var cycle = -1;
    for (var e = 0; e < g.edgeCount; e++) {
      if (st[e] != 1) continue;
      total++;
      final (a, b) = g.ends(e);
      final ra = find(a), rb = find(b);
      if (ra == rb) {
        cycle = ra;
      } else {
        parent[ra] = rb;
      }
    }
    if (total == 0) return true;
    final size = <int, int>{};
    for (var e = 0; e < g.edgeCount; e++) {
      if (st[e] == 1) size.update(find(g.ends(e).$1), (x) => x + 1, ifAbsent: () => 1);
    }
    if (cycle >= 0) {
      // A closed loop must be the whole answer.
      if (size.length > 1) return false;
      final lines = [for (final x in st) x == 1];
      if (!cluesMet(lines)) return false;
      for (var e = 0; e < g.edgeCount; e++) {
        if (st[e] == -1) set(st, e, 0);
      }
      return true;
    }
    for (var e = 0; e < g.edgeCount; e++) {
      if (st[e] != -1) continue;
      final (a, b) = g.ends(e);
      final ra = find(a);
      if (ra != find(b)) continue;
      // Adding e closes the path through a and b.
      var ok = size.length == 1;
      if (ok) {
        final lines = [for (final x in st) x == 1]..[e] = true;
        ok = g.isSingleLoop(lines) && cluesMet(lines);
      }
      if (!ok) set(st, e, 0);
    }
    return true;
  }

  bool solved(List<int> st) => !st.contains(-1);

  /// Fills in [st] using logic up to [tier]; true if it gets fully determined.
  bool solve(List<int> st, int tier) {
    if (!propagate(st)) return false;
    if (tier >= 2) {
      var progress = true;
      while (progress && !solved(st)) {
        progress = false;
        for (var e = 0; e < st.length; e++) {
          if (st[e] != -1) continue;
          for (final v in const [1, 0]) {
            final t = List.of(st)..[e] = v;
            if (!propagate(t)) {
              st[e] = 1 - v;
              if (!propagate(st)) return false;
              progress = true;
              break;
            }
          }
        }
      }
    }
    return solved(st) && g.isSingleLoop([for (final x in st) x == 1]);
  }

  int countSolutions(List<int> st, {int limit = 2}) {
    final t = List.of(st);
    if (!propagate(t)) return 0;
    // Branch next to the drawn lines first (keeps the search local).
    var pick = -1;
    for (var e = 0; e < t.length && pick < 0; e++) {
      if (t[e] != -1) continue;
      final (a, b) = g.ends(e);
      if ([...g.incident[a], ...g.incident[b]].any((f) => t[f] == 1)) pick = e;
    }
    if (pick < 0) pick = t.indexOf(-1);
    if (pick < 0) return g.isSingleLoop([for (final x in t) x == 1]) && cluesMet([for (final x in t) x == 1]) ? 1 : 0;
    var total = 0;
    for (final v in const [1, 0]) {
      if (total >= limit) break;
      total += countSolutions(List.of(t)..[pick] = v, limit: limit - total);
    }
    return total;
  }
}
