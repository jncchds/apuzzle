import 'dart:math';

import '../../core/difficulty.dart';
import 'pop_model.dart';

/// Five colors, like the classic; difficulty sets the target share and, when
/// clearing, the group sizes.
const popColors = 5;

/// Share of the best found score to reach, per difficulty.
double _targetShare(Difficulty d) => switch (d) {
      Difficulty.easy => 0.6,
      Difficulty.medium => 0.8,
      _ => 1.0,
    };

PopPuzzle generatePop(GenParams params, PopMode mode, PopGoal goal) {
  final rows = params.size.rows, cols = params.size.cols;
  final rng = Random(params.seed);
  final colors = popColors;

  if (goal == PopGoal.clear) {
    final (start, plan) = _clearable(rows, cols, colors, params.difficulty, rng);
    return PopPuzzle(
        rows: rows, cols: cols, colors: colors, mode: mode, goal: goal, start: start, reserve: const [], target: 0, plan: plan);
  }

  final start = List.generate(rows * cols, (_) => rng.nextInt(colors));
  final reserve = !mode.refills
      ? const <List<int>>[]
      : [
          for (var k = 0; k < cols * 2; k++)
            List.generate(rows ~/ 2 + rng.nextInt(rows - rows ~/ 2 + 1), (_) => rng.nextInt(colors)),
        ];
  var p = PopPuzzle(
      rows: rows, cols: cols, colors: colors, mode: mode, goal: goal, start: start, reserve: reserve, target: 0, plan: const []);
  if (goal == PopGoal.free) return p;

  final best = _bestPlayout(p, PopState.initial(p), 40, rng);
  final target = max(10, (best.score * _targetShare(params.difficulty)) ~/ 10 * 10);
  p = PopPuzzle(
      rows: rows, cols: cols, colors: colors, mode: mode, goal: goal, start: start, reserve: reserve, target: target, plan: best.ids);
  return p;
}

/// The group to pop next: along the stored plan while the player follows
/// it, else the first move of the best of a few playouts. Null when stuck.
List<int>? popSuggest(PopPuzzle p, PopState s) {
  if (!popHasMoves(s.cells, p.rows, p.cols)) return null;
  if (s.moves < p.plan.length && _onPlan(p, s)) {
    final i = s.ids.indexOf(p.plan[s.moves]);
    if (i >= 0) return popGroup(s.cells, p.rows, p.cols, i);
  }
  final best = _bestPlayout(p, s, 16, Random(s.moves * 7919 + s.score));
  return popGroup(s.cells, p.rows, p.cols, s.ids.indexOf(best.ids.first));
}

bool _onPlan(PopPuzzle p, PopState s) {
  var t = PopState.initial(p);
  for (var k = 0; k < s.moves; k++) {
    final next = popAt(p, t, t.ids.indexOf(p.plan[k]));
    if (next == null) return false;
    t = next;
  }
  for (var i = 0; i < t.ids.length; i++) {
    if (t.ids[i] != s.ids[i]) return false;
  }
  return true;
}

// ---- playouts ----

typedef _Line = ({int score, int left, List<int> ids});

/// Better for [p.goal]: fewer bubbles left when clearing, else more points.
bool _better(PopPuzzle p, _Line a, _Line b) =>
    p.goal == PopGoal.clear ? (a.left < b.left || (a.left == b.left && a.score > b.score)) : a.score > b.score;

_Line _bestPlayout(PopPuzzle p, PopState from, int runs, Random rng) {
  _Line? best;
  for (var run = 0; run < runs; run++) {
    final line = _playout(p, from, run % 4, rng);
    if (best == null || _better(p, line, best)) best = line;
  }
  return best!;
}

/// Plays to the end with a simple policy:
/// 0 random, 1 random but saving the most common color, 2 smallest group
/// but saving the most common color, 3 largest group.
_Line _playout(PopPuzzle p, PopState from, int policy, Random rng) {
  var s = from;
  final ids = <int>[];
  while (true) {
    final groups = popGroups(s.cells, p.rows, p.cols);
    if (groups.isEmpty) break;
    var pool = groups;
    if (policy == 1 || policy == 2) {
      final counts = List<int>.filled(p.colors, 0);
      for (final c in s.cells) {
        if (c >= 0) counts[c]++;
      }
      var top = 0;
      for (var c = 1; c < p.colors; c++) {
        if (counts[c] > counts[top]) top = c;
      }
      final others = [for (final g in groups) if (s.cells[g.first] != top) g];
      if (others.isNotEmpty) pool = others;
    }
    final List<int> g;
    if (policy == 2 || policy == 3) {
      final want = policy == 2 ? pool.map((g) => g.length).reduce(min) : pool.map((g) => g.length).reduce(max);
      final ties = [for (final g in pool) if (g.length == want) g];
      g = ties[rng.nextInt(ties.length)];
    } else {
      g = pool[rng.nextInt(pool.length)];
    }
    ids.add(s.ids[g.first]);
    s = popAt(p, s, g.first)!;
  }
  return (score: s.score, left: s.left, ids: ids);
}

// ---- clearable boards ----

/// Builds a full, clearable standard-mode board backwards from an empty one:
/// each step un-pops a group (a vertical run, a horizontal run or a new
/// column) of a color none of its neighbours has, so popping the groups in
/// reverse order clears it. Returns the colors and the plan (bubble ids).
(List<int>, List<int>) _clearable(int rows, int cols, int colors, Difficulty d, Random rng) {
  final (kMin, kMax) = switch (d) {
    Difficulty.easy => (2, 5),
    Difficulty.medium => (2, 4),
    _ => (2, 3),
  };
  while (true) {
    final built = _tryClearable(rows, cols, colors, kMin, kMax, rng);
    if (built != null) return built;
  }
}

/// Where to un-pop a group of [k]: a new column at [at] (h unused), a
/// vertical run in column [at] from height [h], or a horizontal run over
/// columns [at]..[at]+k-1 at height [h].
typedef _Spot = ({int kind, int at, int h, int k});

const _newColumn = 0, _vertical = 1, _horizontal = 2;

(List<int>, List<int>)? _tryClearable(int rows, int cols, int colors, int kMin, int kMax, Random rng) {
  final total = rows * cols;
  // Packed (right-aligned) non-empty columns, bottom-up (color, token).
  var columns = <List<(int, int)>>[];
  var count = 0;
  final groups = <int>[]; // one token per un-popped group, in build order
  var token = 0;

  /// The board with the group inserted (color -1 for now) and the group's
  /// (column, height) cells, or null when it doesn't fit.
  (List<List<(int, int)>>, List<(int, int)>)? insert(_Spot s) {
    final m = columns.length, k = s.k;
    switch (s.kind) {
      case _newColumn:
        if (m >= cols || k > rows || s.at > m) return null;
        return (
          [...columns.sublist(0, s.at), [for (var j = 0; j < k; j++) (-1, token + j)], ...columns.sublist(s.at)],
          [for (var j = 0; j < k; j++) (s.at, j)],
        );
      case _vertical:
        if (s.at >= m) return null;
        final col = columns[s.at];
        if (col.length + k > rows || s.h > col.length) return null;
        final next = [...columns];
        next[s.at] = [...col.sublist(0, s.h), for (var j = 0; j < k; j++) (-1, token + j), ...col.sublist(s.h)];
        return (next, [for (var j = 0; j < k; j++) (s.at, s.h + j)]);
      default:
        if (s.at + k > m) return null;
        final span = columns.sublist(s.at, s.at + k);
        if (span.any((col) => col.length >= rows || col.length < s.h)) return null;
        final next = [...columns];
        for (var j = 0; j < k; j++) {
          final col = columns[s.at + j];
          next[s.at + j] = [...col.sublist(0, s.h), (-1, token + j), ...col.sublist(s.h)];
        }
        return (next, [for (var j = 0; j < k; j++) (s.at + j, s.h)]);
    }
  }

  /// Places the group at [s] in a color no neighbour outside it has.
  bool place(_Spot s) {
    final built = insert(s);
    if (built == null) return false;
    final (next, cells) = built;
    final banned = <int>{};
    for (final (c, h) in cells) {
      for (final (nc, nh) in [(c - 1, h), (c + 1, h), (c, h - 1), (c, h + 1)]) {
        if (nc < 0 || nc >= next.length || nh < 0 || nh >= next[nc].length) continue;
        final color = next[nc][nh].$1;
        if (color >= 0) banned.add(color);
      }
    }
    final free = [for (var c = 0; c < colors; c++) if (!banned.contains(c)) c];
    if (free.isEmpty) return false;
    final color = free[rng.nextInt(free.length)];
    for (final (c, h) in cells) {
      next[c][h] = (color, next[c][h].$2);
    }
    columns = next;
    groups.add(token);
    token += s.k;
    count += s.k;
    return true;
  }

  bool fits(int k, int remaining) => k <= remaining && remaining - k != 1;

  while (count < total) {
    final remaining = total - count;
    final m = columns.length;
    var placed = false;
    // Random spots first, biased to new columns while few exist.
    for (var tries = 0; tries < 60 && !placed; tries++) {
      final k = kMin + rng.nextInt(kMax - kMin + 1);
      if (!fits(k, remaining)) continue;
      final roll = rng.nextDouble();
      final kind = m < cols && roll < 0.15 + 0.5 * (cols - m) / cols
          ? _newColumn
          : roll < 0.75 || m < k
              ? _vertical
              : _horizontal;
      final at = rng.nextInt(kind == _newColumn ? m + 1 : max(1, m));
      final h = kind == _newColumn || at >= m ? 0 : rng.nextInt(columns[at].length + 1);
      placed = place((kind: kind, at: at, h: h, k: k));
    }
    if (!placed) {
      // Every spot, in random order.
      final spots = <_Spot>[
        for (var k = kMin; k <= kMax; k++)
          if (fits(k, remaining)) ...[
            for (var at = 0; at <= m; at++) (kind: _newColumn, at: at, h: 0, k: k),
            for (var at = 0; at < m; at++)
              for (var h = 0; h <= columns[at].length; h++) ...[
                (kind: _vertical, at: at, h: h, k: k),
                (kind: _horizontal, at: at, h: h, k: k),
              ],
          ],
      ]..shuffle(rng);
      for (final s in spots) {
        if (place(s)) {
          placed = true;
          break;
        }
      }
    }
    if (!placed) return null;
  }

  final start = List<int>.filled(total, -1);
  final idOf = <int, int>{};
  for (var c = 0; c < cols; c++) {
    for (var h = 0; h < rows; h++) {
      final i = (rows - 1 - h) * cols + c;
      final (color, t) = columns[c][h];
      start[i] = color;
      idOf[t] = i;
    }
  }
  return (start, [for (final t in groups.reversed) idOf[t]!]);
}
