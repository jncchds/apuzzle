import 'dart:math';

import '../../core/difficulty.dart';
import 'blockade_model.dart';
import 'blockade_solver.dart';

/// Longest common cycle of the ships allowed (keeps the solver's states few).
const blockadeMaxCycle = 120;

/// Ships, their longest beat (cells), spare turns, and how many turns the
/// fastest passage must lose to the ships, for a board of [rows] × [cols] at [d].
({int ships, int reach, int slack, int delay}) blockadeShape(int rows, int cols, Difficulty d) {
  final s = min(rows, cols);
  return switch (d) {
    Difficulty.easy => (ships: max(1, s ~/ 3), reach: 4, slack: 4, delay: 1),
    Difficulty.medium => (ships: s ~/ 3 + 1, reach: 5, slack: 2, delay: 2),
    _ => (ships: s ~/ 3 + 2, reach: 6, slack: 0, delay: 2),
  };
}

/// Random seas, keeping the one whose fastest passage loses the most turns to
/// the ships (at least the shape's delay, so the shortest way is never safe),
/// and on medium and hard where sailing straight on and waiting when blocked
/// does worst.
BlockadePuzzle generateBlockade(GenParams params) {
  final rows = params.size.rows, cols = params.size.cols;
  final rng = Random(params.seed);
  final shape = blockadeShape(rows, cols, params.difficulty);
  final easy = params.difficulty == Difficulty.easy;
  final tries = easy ? 40 : 80;
  // No `-1 << 30` sentinel: on the web shifts give unsigned 32-bit results,
  // so it would be positive and no board would ever beat it.
  BlockadePuzzle? best;
  var bestScore = 0;
  for (var t = 0; t < tries || best == null; t++) {
    final sea = blockadeSea(rows, cols, shape.ships, shape.reach, rng);
    if (sea == null) continue;
    final solver = BlockadeSolver(sea);
    final opt = solver.best();
    if (opt == null) continue;
    final delay = opt - solver.plain();
    final limit = opt + shape.slack;
    final greedy = solver.greedy(cap: limit);
    // Turns the obvious play loses (it fails: 4), and whether just waiting
    // at the start for the right moment is enough.
    final miss = greedy == null ? 4 : min(4, greedy - opt);
    final waitOnly = !easy && solver.waitThenGo(cap: opt) != null;
    final score = easy
        ? min(delay, 2) * 10 - (delay - 2).abs()
        : min(delay, shape.delay + 2) * 10 + miss * 6 + (waitOnly ? 0 : 12) + min(opt, 3 * max(rows, cols)) ~/ 4;
    if (best == null || score > bestScore) {
      bestScore = score;
      best = _withLimit(sea, opt, limit);
    }
    if (easy && delay >= shape.delay && delay <= 3 && t >= 4) break;
    if (!easy && delay >= shape.delay + 1 && greedy == null && !waitOnly && t >= 20) break;
  }
  return best;
}

BlockadePuzzle _withLimit(BlockadePuzzle p, int best, int limit) => BlockadePuzzle(
  rows: p.rows,
  cols: p.cols,
  rocks: p.rocks,
  start: p.start,
  goal: p.goal,
  patrols: p.patrols,
  limit: limit,
  best: best,
);

/// A random sea: rocks, the start on one side and the harbour on the other,
/// and up to [ships] ships whose beats (up to [reach] cells along a line, or
/// round a rectangle) lie mostly across the short ways to the harbour. Null
/// if the ships don't fit. [BlockadePuzzle.limit] and [BlockadePuzzle.best]
/// are left 0.
BlockadePuzzle? blockadeSea(int rows, int cols, int ships, int reach, Random rng) {
  final n = rows * cols;
  final rocks = List<bool>.filled(n, false);
  // Start and harbour on opposite sides, across rows or across columns.
  final across = rng.nextBool();
  int cell(int along, int side) => across ? side * cols + along : along * cols + side;
  final len = across ? cols : rows, depth = across ? rows : cols;
  var start = cell(rng.nextInt(len), 0), goal = cell(rng.nextInt(len), depth - 1);
  if (rng.nextBool()) (start, goal) = (goal, start);
  for (var i = 0; i < n; i++) {
    if (i != start && i != goal && rng.nextDouble() < 0.14) rocks[i] = true;
  }

  final used = List<bool>.filled(n, false)
    ..[start] = true
    ..[goal] = true;
  final patrols = <Patrol>[];
  final draft = BlockadePuzzle(
    rows: rows,
    cols: cols,
    rocks: rocks,
    start: start,
    goal: goal,
    patrols: patrols,
    limit: 0,
    best: 0,
  );
  for (var k = 0; k < ships; k++) {
    // Cells on a shortest way (or one step longer) between start and harbour.
    final fromGoal = BlockadeSolver(draft).distances();
    if (fromGoal[start] < 0) return null;
    final fromStart = _distancesFrom(draft, start);
    final way = [
      for (var i = 0; i < n; i++)
        if (!used[i] && !rocks[i] && fromGoal[i] >= 0 && fromStart[i] + fromGoal[i] <= fromGoal[start] + 1) i,
    ];
    for (var attempt = 0; attempt < 40; attempt++) {
      final anchor = way.isNotEmpty && rng.nextDouble() < 0.8 ? way[rng.nextInt(way.length)] : rng.nextInt(n);
      final s = rng.nextDouble() < 0.4
          ? _loopAt(draft, anchor, reach, used, rng)
          : _lineAt(draft, anchor, reach, used, rng);
      if (s == null) continue;
      if (patrolCycle([...patrols, s]) > blockadeMaxCycle) continue;
      patrols.add(s);
      for (final i in s.route) {
        used[i] = true;
      }
      break;
    }
  }
  if (patrols.isEmpty) return null;
  // Close off sea the boat can't reach; every ship must be reachable.
  final reach0 = _distancesFrom(draft, start);
  if (reach0[goal] < 0) return null;
  for (final s in patrols) {
    if (s.route.any((i) => reach0[i] < 0)) return null;
  }
  for (var i = 0; i < n; i++) {
    if (reach0[i] < 0) rocks[i] = true;
  }
  return draft;
}

List<int> _distancesFrom(BlockadePuzzle p, int from) {
  final d = List<int>.filled(p.cells, -1)..[from] = 0;
  final queue = [from];
  for (var q = 0; q < queue.length; q++) {
    for (final v in p.neighbours(queue[q])) {
      if (d[v] >= 0) continue;
      d[v] = d[queue[q]] + 1;
      queue.add(v);
    }
  }
  return d;
}

bool _free(BlockadePuzzle p, int i, List<bool> used) => !p.rocks[i] && !used[i];

/// A ship going back and forth along a row or column through [anchor].
Patrol? _lineAt(BlockadePuzzle p, int anchor, int reach, List<bool> used, Random rng) {
  if (!_free(p, anchor, used)) return null;
  final length = 2 + rng.nextInt(reach - 1);
  final vertical = rng.nextBool();
  final step = vertical ? p.cols : 1;
  final r = anchor ~/ p.cols, c = anchor % p.cols;
  final pos = vertical ? r : c, span = vertical ? p.rows : p.cols;
  final first = pos - rng.nextInt(length);
  if (first < 0 || first + length > span) return null;
  final route = [for (var k = 0; k < length; k++) anchor + (first - pos + k) * step];
  if (!route.every((i) => _free(p, i, used))) return null;
  final period = 2 * (length - 1);
  return Patrol(rng.nextBool() ? route : route.reversed.toList(), loop: false, phase: rng.nextInt(period));
}

/// A ship sailing round the rim of a rectangle with [anchor] on it; the
/// inside (if any) becomes an island.
Patrol? _loopAt(BlockadePuzzle p, int anchor, int reach, List<bool> used, Random rng) {
  final h = 2 + rng.nextInt(2), w = 2 + rng.nextInt(reach > 4 ? 3 : 2);
  final (rh, rw) = rng.nextBool() ? (h, w) : (w, h);
  final ar = anchor ~/ p.cols, ac = anchor % p.cols;
  final top = ar - rng.nextInt(rh), left = ac - rng.nextInt(rw);
  if (top < 0 || left < 0 || top + rh > p.rows || left + rw > p.cols) return null;
  final rim = <int>[
    for (var c = left; c < left + rw; c++) top * p.cols + c,
    for (var r = top + 1; r < top + rh; r++) r * p.cols + left + rw - 1,
    for (var c = left + rw - 2; c >= left; c--) (top + rh - 1) * p.cols + c,
    for (var r = top + rh - 2; r > top; r--) r * p.cols + left,
  ];
  if (!rim.contains(anchor) || !rim.every((i) => _free(p, i, used))) return null;
  final inside = [
    for (var r = top + 1; r < top + rh - 1; r++)
      for (var c = left + 1; c < left + rw - 1; c++) r * p.cols + c,
  ];
  if (inside.any((i) => used[i])) return null;
  for (final i in inside) {
    p.rocks[i] = true;
  }
  return Patrol(rng.nextBool() ? rim : rim.reversed.toList(), loop: true, phase: rng.nextInt(rim.length));
}
