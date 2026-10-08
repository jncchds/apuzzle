import 'dart:math';

import '../../core/difficulty.dart';
import 'snake_model.dart';

/// Apples to eat: 8%, 15% or 25% of the board, at least 3.
int snakeTarget(int rows, int cols, Difficulty d) => max(
  3,
  (rows *
          cols *
          switch (d) {
            Difficulty.easy => 0.08,
            Difficulty.medium => 0.15,
            _ => 0.25,
          })
      .round(),
);

/// Milliseconds per step at the start.
int snakeSpeed(Difficulty d) => switch (d) {
  Difficulty.easy => 240,
  Difficulty.medium => 170,
  _ => 120,
};

/// A snake of three on the middle row, heading right, and the first apple.
SnakePuzzle generateSnake(GenParams params, SnakeGoal goal) {
  final rows = params.size.rows, cols = params.size.cols;
  final r = rows ~/ 2;
  final body = [r * cols + 2, r * cols + 1, r * cols];
  return SnakePuzzle(
    rows: rows,
    cols: cols,
    goal: goal,
    target: goal == SnakeGoal.target ? snakeTarget(rows, cols, params.difficulty) : 0,
    seed: params.seed,
    stepMs: snakeSpeed(params.difficulty),
    start: body,
    dir: SnakeDir.right,
    food: snakeFood(params.seed, rows * cols, body, 0),
  );
}

/// Where to steer: the shortest way to the apple if the tail is still in
/// reach once there, else the move that keeps following the tail from the
/// farthest, else the one with the most room. Null when the game is over.
SnakeDir? snakeSuggest(SnakePuzzle p, SnakeState s) {
  if (s.dead || s.full) return null;
  final body = s.body;
  final head = body.first;
  final toFood = _path(p, head, s.food, body.sublist(0, body.length - 1).toSet());
  if (toFood != null) {
    final after = [...toFood.reversed, ...body].take(body.length + 1).toList();
    if (_path(p, after.first, after.last, after.sublist(0, after.length - 1).toSet()) != null) {
      return _dirTo(p, head, toFood.first);
    }
  }
  SnakeDir? best;
  var bestScore = -1;
  for (final dir in SnakeDir.values) {
    if (body.length > 1 && dir.isOpposite(s.dir)) continue;
    final next = snakeNext(p.rows, p.cols, head, dir);
    if (next < 0) continue;
    final grows = next == s.food;
    final after = [next, ...(grows ? body : body.sublist(0, body.length - 1))];
    if (after.skip(1).contains(next)) continue;
    final blocked = after.sublist(0, after.length - 1).toSet();
    final toTail = _path(p, next, after.last, blocked);
    final score = toTail != null ? 100000 + toTail.length : _room(p, next, blocked);
    if (score > bestScore) {
      bestScore = score;
      best = dir;
    }
  }
  return best ?? s.dir;
}

SnakeDir _dirTo(SnakePuzzle p, int from, int to) => SnakeDir.values.firstWhere(
  (d) => snakeNext(p.rows, p.cols, from, d) == to,
);

/// Cells from the one after [from] to [to], around [blocked] cells, or null.
List<int>? _path(SnakePuzzle p, int from, int to, Set<int> blocked) {
  if (from == to) return const [];
  final prev = List<int>.filled(p.rows * p.cols, -2);
  prev[from] = -1;
  final queue = [from];
  for (var k = 0; k < queue.length; k++) {
    final at = queue[k];
    for (final d in SnakeDir.values) {
      final n = snakeNext(p.rows, p.cols, at, d);
      if (n < 0 || prev[n] != -2 || (blocked.contains(n) && n != to)) continue;
      prev[n] = at;
      if (n == to) {
        final out = <int>[];
        for (var c = to; c != from; c = prev[c]) {
          out.add(c);
        }
        return out.reversed.toList();
      }
      queue.add(n);
    }
  }
  return null;
}

/// Free cells reachable from [from].
int _room(SnakePuzzle p, int from, Set<int> blocked) {
  final seen = {from};
  final queue = [from];
  for (var k = 0; k < queue.length; k++) {
    for (final d in SnakeDir.values) {
      final n = snakeNext(p.rows, p.cols, queue[k], d);
      if (n >= 0 && !blocked.contains(n) && seen.add(n)) queue.add(n);
    }
  }
  return seen.length;
}
