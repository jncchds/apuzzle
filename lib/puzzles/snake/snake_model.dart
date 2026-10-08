import 'dart:math';

import '../../core/grid.dart';

enum SnakeDir {
  up(-1, 0),
  down(1, 0),
  left(0, -1),
  right(0, 1);

  const SnakeDir(this.dr, this.dc);
  final int dr;
  final int dc;

  bool isOpposite(SnakeDir o) => dr == -o.dr && dc == -o.dc;
}

/// What counts as a win.
enum SnakeGoal {
  /// No target: eat until you crash and chase a best score.
  free('free'),

  /// Eat [SnakePuzzle.target] apples.
  target('target');

  const SnakeGoal(this.id);
  final String id;

  static SnakeGoal byId(String? id) => values.firstWhere((g) => g.id == id, orElse: () => free);
}

class SnakePuzzle {
  const SnakePuzzle({
    required this.rows,
    required this.cols,
    required this.goal,
    required this.target,
    required this.seed,
    required this.stepMs,
    required this.start,
    required this.dir,
    required this.food,
  });

  final int rows;
  final int cols;
  final SnakeGoal goal;

  /// Apples to eat ([SnakeGoal.target]), else 0.
  final int target;

  /// Drives where the apples appear, so a share code replays the same game.
  final int seed;

  /// Milliseconds per step at the start; the snake speeds up as it grows.
  final int stepMs;

  /// The snake's cells, head first.
  final List<int> start;
  final SnakeDir dir;

  /// The first apple.
  final int food;

  GridSize get size => GridSize(rows, cols);

  Map<String, dynamic> toJson() => {
    'rows': rows,
    'cols': cols,
    'goal': goal.id,
    'target': target,
    'seed': seed,
    'ms': stepMs,
    'start': start,
    'dir': dir.name,
    'food': food,
  };

  factory SnakePuzzle.fromJson(Map<String, dynamic> j) => SnakePuzzle(
    rows: j['rows'] as int,
    cols: j['cols'] as int,
    goal: SnakeGoal.byId(j['goal'] as String?),
    target: j['target'] as int,
    seed: j['seed'] as int,
    stepMs: j['ms'] as int,
    start: (j['start'] as List).cast<int>(),
    dir: SnakeDir.values.byName(j['dir'] as String),
    food: j['food'] as int,
  );
}

class SnakeState {
  const SnakeState({
    required this.body,
    required this.dir,
    required this.food,
    required this.eaten,
    required this.steps,
    this.dead = false,
  });

  factory SnakeState.initial(SnakePuzzle p) => SnakeState(body: p.start, dir: p.dir, food: p.food, eaten: 0, steps: 0);

  /// Cells, head first.
  final List<int> body;
  final SnakeDir dir;

  /// The apple's cell, or -1 once the snake fills the board.
  final int food;
  final int eaten;
  final int steps;

  /// Ran into a wall or itself.
  final bool dead;

  bool get full => food < 0;

  Map<String, dynamic> toJson() => {
    'body': body,
    'dir': dir.name,
    'food': food,
    'eaten': eaten,
    'steps': steps,
    if (dead) 'dead': true,
  };

  factory SnakeState.fromJson(Map<String, dynamic> j) => SnakeState(
    body: (j['body'] as List).cast<int>(),
    dir: SnakeDir.values.byName(j['dir'] as String),
    food: j['food'] as int,
    eaten: j['eaten'] as int,
    steps: j['steps'] as int,
    dead: j['dead'] as bool? ?? false,
  );
}

/// Milliseconds per step: a little faster with every apple, down to 60%.
int snakeInterval(SnakePuzzle p, SnakeState s) => max(p.stepMs * 0.6, p.stepMs - 2.0 * s.eaten).round();

/// The apple after [eaten] apples: a free cell picked by the seed and the
/// apple count, so replays match. -1 when the snake fills the board.
int snakeFood(int seed, int cells, List<int> body, int eaten) {
  final taken = body.toSet();
  final free = [
    for (var i = 0; i < cells; i++)
      if (!taken.contains(i)) i,
  ];
  if (free.isEmpty) return -1;
  final rng = Random((seed * 1000003 + eaten * 7919 + 17) & 0x7fffffff);
  return free[rng.nextInt(free.length)];
}

/// The neighbour of [cell] toward [dir], or -1 off the board.
int snakeNext(int rows, int cols, int cell, SnakeDir dir) {
  final r = cell ~/ cols + dir.dr, c = cell % cols + dir.dc;
  return r < 0 || c < 0 || r >= rows || c >= cols ? -1 : r * cols + c;
}

/// One step toward [dir] (a U-turn keeps going straight).
SnakeState snakeStep(SnakePuzzle p, SnakeState s, SnakeDir dir) {
  if (s.dead || s.full) return s;
  if (s.body.length > 1 && dir.isOpposite(s.dir)) dir = s.dir;
  final next = snakeNext(p.rows, p.cols, s.body.first, dir);
  SnakeState crash() =>
      SnakeState(body: s.body, dir: dir, food: s.food, eaten: s.eaten, steps: s.steps + 1, dead: true);
  if (next < 0) return crash();
  final grows = next == s.food;
  // The tail moves out of the way unless the snake grows.
  final keep = grows ? s.body : s.body.sublist(0, s.body.length - 1);
  if (keep.contains(next)) return crash();
  final body = [next, ...keep];
  final eaten = s.eaten + (grows ? 1 : 0);
  return SnakeState(
    body: body,
    dir: dir,
    food: grows ? snakeFood(p.seed, p.rows * p.cols, body, eaten) : s.food,
    eaten: eaten,
    steps: s.steps + 1,
  );
}
