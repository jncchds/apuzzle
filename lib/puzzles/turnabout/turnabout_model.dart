import 'dart:math';

import '../../core/grid.dart';
import '../labyrinth/labyrinth_generator.dart';
import '../labyrinth/labyrinth_model.dart';

/// What ends a game.
enum TurnaboutGoal {
  /// A fixed number of rounds ([turnaboutRounds]).
  rounds('rounds'),

  /// Until the rival has won [turnaboutLives] rounds.
  lives('lives');

  const TurnaboutGoal(this.id);
  final String id;

  static TurnaboutGoal byId(String? id) => values.firstWhere((g) => g.id == id, orElse: () => rounds);
}

/// Rounds of a [TurnaboutGoal.rounds] game.
const turnaboutRounds = 5;

/// Lost rounds that end a [TurnaboutGoal.lives] game.
const turnaboutLives = 3;

/// Milliseconds of one step of the clock.
const turnaboutTickMs = 100;

/// Steps the runner needs between two moves.
const turnaboutPlayerTicks = 2;

/// Steps of warning before the maze turns.
const turnaboutWarnTicks = 15;

/// Steps a turn takes (nobody moves meanwhile): a quarter turn, a half turn.
int turnaboutTurnTicks(int by) => by == 2 ? 7 : 5;

/// Turns (quarter turns clockwise: 1, 2 or 3) planned per round.
const turnaboutPlannedTurns = 40;

/// The maze direction (0 north, 1 east, 2 south, 3 west) a screen direction
/// (0 up, 1 right, 2 down, 3 left) points at while the maze is drawn turned
/// [orient] quarter turns clockwise.
int turnaboutMazeDir(int screen, int orient) => (screen - orient) & 3;

/// The screen direction of maze direction [maze] at [orient].
int turnaboutScreenDir(int maze, int orient) => (maze + orient) & 3;

/// The cell next to [i] in maze direction [d] (0..3) through an open passage, or -1.
int turnaboutStepCell(int n, List<int> open, int i, int d) {
  if (open[i] & dirs[d] == 0) return -1;
  return neighbor(i, dirs[d], n, n) ?? -1;
}

/// Path lengths from [from] to every cell of a perfect maze.
List<int> turnaboutDistances(int n, List<int> open, int from) {
  final dist = List.filled(n * n, -1)..[from] = 0;
  final queue = [from];
  for (var q = 0; q < queue.length; q++) {
    final i = queue[q];
    for (var d = 0; d < 4; d++) {
      final j = turnaboutStepCell(n, open, i, d);
      if (j >= 0 && dist[j] < 0) {
        dist[j] = dist[i] + 1;
        queue.add(j);
      }
    }
  }
  return dist;
}

/// The only way from [from] to [to] (both included).
List<int> turnaboutPath(int n, List<int> open, int from, int to) {
  final dist = turnaboutDistances(n, open, to);
  final path = [from];
  while (path.last != to) {
    final i = path.last;
    for (var d = 0; d < 4; d++) {
      final j = turnaboutStepCell(n, open, i, d);
      if (j >= 0 && dist[j] == dist[i] - 1) {
        path.add(j);
        break;
      }
    }
  }
  return path;
}

/// One round: a maze on n×n cells, where the runner and the rival start,
/// the star, and when the maze turns.
class TurnaboutRound {
  TurnaboutRound({
    required this.n,
    required this.open,
    required this.player,
    required this.rival,
    required this.prize,
    required this.turns,
  });

  final int n;

  /// Open passages per cell (labyrinth direction bits).
  final List<int> open;

  /// Start cells; [rival] is -1 on a practice board without one.
  final int player;
  final int rival;

  /// The star.
  final int prize;

  /// (step, quarter turns clockwise) of every turn, in order.
  final List<(int, int)> turns;

  /// The rival's way to the star, its start first.
  late final List<int> rivalPath = rival < 0 ? const [] : turnaboutPath(n, open, rival, prize);

  /// Path lengths to the star.
  late final List<int> toPrize = turnaboutDistances(n, open, prize);

  Map<String, dynamic> toJson() => {
    'n': n,
    'open': open,
    'player': player,
    'rival': rival,
    'prize': prize,
    'turns': [
      for (final (t, by) in turns) [t, by],
    ],
  };

  factory TurnaboutRound.fromJson(Map<String, dynamic> j) => TurnaboutRound(
    n: j['n'] as int,
    open: (j['open'] as List).cast<int>(),
    player: j['player'] as int,
    rival: j['rival'] as int,
    prize: j['prize'] as int,
    turns: [for (final t in j['turns'] as List) ((t as List)[0] as int, t[1] as int)],
  );
}

/// When a round's maze turns: the first turn after [first] steps (a range),
/// then every [gap] steps; [half] allows half turns.
typedef TurnaboutTurnPlan = ({(int, int) first, (int, int) gap, bool half});

/// A random round on n×n: a perfect maze ([newest] sets its style), the runner
/// in a random corner and the rival in the opposite one, and the star at the
/// same path length from both (corner to corner is always an even length in a
/// grid). The star sits on the way between them or a little off it.
TurnaboutRound turnaboutMakeRound(int n, double newest, Random rng, TurnaboutTurnPlan plan) {
  final maze = carveLabyrinth(n, n, newest, rng);
  final open = maze.open;
  final corners = [0, n - 1, n * n - 1, n * (n - 1)];
  final c = rng.nextInt(4);
  final player = corners[c], rival = corners[(c + 2) % 4];
  final dp = turnaboutDistances(n, open, player), dr = turnaboutDistances(n, open, rival);
  final half = dp[rival] ~/ 2;
  final reach = max(1, n ~/ 3);
  final spots = [
    for (var i = 0; i < n * n; i++)
      if (dp[i] == dr[i] && dp[i] - half <= reach) i,
  ];
  final prize = spots[rng.nextInt(spots.length)];
  return TurnaboutRound(
    n: n,
    open: open,
    player: player,
    rival: rival,
    prize: prize,
    turns: turnaboutPlanTurns(rng, plan),
  );
}

List<(int, int)> turnaboutPlanTurns(Random rng, TurnaboutTurnPlan plan) {
  int pick((int, int) range) => range.$1 + rng.nextInt(range.$2 - range.$1 + 1);
  final out = <(int, int)>[];
  var t = pick(plan.first);
  for (var k = 0; k < turnaboutPlannedTurns; k++) {
    final by = plan.half && rng.nextInt(4) == 0 ? 2 : (rng.nextBool() ? 1 : 3);
    out.add((t, by));
    t += turnaboutTurnTicks(by) + pick(plan.gap);
  }
  return out;
}

/// A game of rounds. Each round's maze and turns come from (seed, round), so
/// a share code replays the same game; practice boards carry [fixed] rounds.
class TurnaboutPuzzle {
  TurnaboutPuzzle({
    required this.n,
    required this.seed,
    required this.goal,
    required this.newest,
    required this.rivalTicks,
    required this.firstTurn,
    required this.turnGap,
    required this.half,
    this.fixed = const [],
  });

  /// Board side (the maze is square, so it fits however it is turned).
  final int n;
  final int seed;
  final TurnaboutGoal goal;

  /// Maze style in percent (the chance of carving on from the newest cell).
  final int newest;

  /// Steps the rival needs per cell.
  final int rivalTicks;

  /// Steps to the first turn, and between turns (ranges).
  final (int, int) firstTurn;
  final (int, int) turnGap;

  /// Whether the maze sometimes makes a half turn.
  final bool half;

  /// A practice board (tutorials): these rounds, and losing one fails it.
  final List<TurnaboutRound> fixed;

  bool get practice => fixed.isNotEmpty;
  GridSize get size => GridSize.square(n);

  /// Rounds of the game, or null when it goes on until the lives are gone.
  int? get rounds => practice ? fixed.length : (goal == TurnaboutGoal.rounds ? turnaboutRounds : null);

  final _cache = <int, TurnaboutRound>{};

  /// Round [r] (from 0).
  TurnaboutRound round(int r) {
    if (practice) return fixed[r];
    return _cache[r] ??= turnaboutMakeRound(
      n,
      newest / 100,
      Random((seed * 1000003 + r * 7919 + 13) & 0x7fffffff),
      (first: firstTurn, gap: turnGap, half: half),
    );
  }

  /// Steps the rival needs per cell after [wins] won rounds: a lives game
  /// speeds it up every three wins, never to the runner's pace.
  int rivalPace(int wins) =>
      goal == TurnaboutGoal.lives && !practice ? max(turnaboutPlayerTicks + 1, rivalTicks - wins ~/ 3) : rivalTicks;

  Map<String, dynamic> toJson() => {
    'n': n,
    'seed': seed,
    'goal': goal.id,
    'newest': newest,
    'rival': rivalTicks,
    'first': [firstTurn.$1, firstTurn.$2],
    'gap': [turnGap.$1, turnGap.$2],
    if (half) 'half': true,
    if (fixed.isNotEmpty) 'fixed': [for (final r in fixed) r.toJson()],
  };

  factory TurnaboutPuzzle.fromJson(Map<String, dynamic> j) {
    (int, int) range(String key) => ((j[key] as List)[0] as int, (j[key] as List)[1] as int);
    return TurnaboutPuzzle(
      n: j['n'] as int,
      seed: j['seed'] as int,
      goal: TurnaboutGoal.byId(j['goal'] as String?),
      newest: j['newest'] as int,
      rivalTicks: j['rival'] as int,
      firstTurn: range('first'),
      turnGap: range('gap'),
      half: j['half'] as bool? ?? false,
      fixed: [for (final r in (j['fixed'] as List?) ?? const []) TurnaboutRound.fromJson(r as Map<String, dynamic>)],
    );
  }
}

/// How the current round stands.
enum TurnaboutResult { running, won, lost }

class TurnaboutState {
  const TurnaboutState({
    required this.round,
    required this.wins,
    required this.losses,
    required this.player,
    this.tick = 0,
    this.rival = 0,
    this.orient = 0,
    this.turnsDone = 0,
    this.turnAt = -100,
    this.turnBy = 1,
    this.readyAt = 0,
    this.clock = 0,
    this.result = TurnaboutResult.running,
  });

  /// Round [r] at its start.
  factory TurnaboutState.start(TurnaboutPuzzle p, int r, {int wins = 0, int losses = 0}) =>
      TurnaboutState(round: r, wins: wins, losses: losses, player: p.round(r).player);

  final int round;
  final int wins;
  final int losses;

  /// Steps played in this round.
  final int tick;

  /// The runner's cell.
  final int player;

  /// How far along its way the rival is.
  final int rival;

  /// Quarter turns clockwise the maze is drawn at.
  final int orient;

  /// Turns made in this round, and the step and size of the last one.
  final int turnsDone;
  final int turnAt;
  final int turnBy;

  /// The first step the runner may move again.
  final int readyAt;

  /// Steps the rival has had (steps outside turns).
  final int clock;

  final TurnaboutResult result;

  /// Nothing has happened in this round yet.
  bool get fresh => tick == 0 && readyAt == 0 && result == TurnaboutResult.running;

  TurnaboutState copyWith({
    int? tick,
    int? player,
    int? rival,
    int? orient,
    int? turnsDone,
    int? turnAt,
    int? turnBy,
    int? readyAt,
    int? clock,
    int? wins,
    int? losses,
    TurnaboutResult? result,
  }) => TurnaboutState(
    round: round,
    wins: wins ?? this.wins,
    losses: losses ?? this.losses,
    player: player ?? this.player,
    tick: tick ?? this.tick,
    rival: rival ?? this.rival,
    orient: orient ?? this.orient,
    turnsDone: turnsDone ?? this.turnsDone,
    turnAt: turnAt ?? this.turnAt,
    turnBy: turnBy ?? this.turnBy,
    readyAt: readyAt ?? this.readyAt,
    clock: clock ?? this.clock,
    result: result ?? this.result,
  );

  Map<String, dynamic> toJson() => {
    'r': round,
    'w': wins,
    'l': losses,
    't': tick,
    'p': player,
    'v': rival,
    'o': orient,
    'k': turnsDone,
    'ta': turnAt,
    'tb': turnBy,
    'ra': readyAt,
    'c': clock,
    'x': result.index,
  };

  factory TurnaboutState.fromJson(Map<String, dynamic> j) => TurnaboutState(
    round: j['r'] as int,
    wins: j['w'] as int,
    losses: j['l'] as int,
    tick: j['t'] as int,
    player: j['p'] as int,
    rival: j['v'] as int,
    orient: j['o'] as int,
    turnsDone: j['k'] as int,
    turnAt: j['ta'] as int,
    turnBy: j['tb'] as int,
    readyAt: j['ra'] as int,
    clock: j['c'] as int,
    result: TurnaboutResult.values[j['x'] as int],
  );
}

/// The rival's cell, or -1 when there is none.
int turnaboutRivalCell(TurnaboutPuzzle p, TurnaboutState s) {
  final path = p.round(s.round).rivalPath;
  return path.isEmpty ? -1 : path[s.rival];
}

/// The maze is turning (nobody moves).
bool turnaboutTurning(TurnaboutState s) => s.tick < s.turnAt + turnaboutTurnTicks(s.turnBy);

/// The next turn (its step and size) if it is close enough to warn about.
(int, int)? turnaboutWarning(TurnaboutPuzzle p, TurnaboutState s) {
  if (s.result != TurnaboutResult.running) return null;
  final turns = p.round(s.round).turns;
  if (s.turnsDone >= turns.length) return null;
  final next = turns[s.turnsDone];
  return next.$1 - s.tick <= turnaboutWarnTicks ? next : null;
}

/// The game is over: every round is played, or the lives are gone (a
/// practice board also ends with its first lost round).
bool turnaboutOver(TurnaboutPuzzle p, TurnaboutState s) {
  if (s.result == TurnaboutResult.running) return false;
  if (p.practice && s.losses > 0) return true;
  final rounds = p.rounds;
  return rounds != null ? s.round + 1 >= rounds : s.losses >= turnaboutLives;
}

/// The runner may move now.
bool turnaboutCanMove(TurnaboutState s) =>
    s.result == TurnaboutResult.running && s.tick >= s.readyAt && !turnaboutTurning(s);

/// One step of the clock: the maze turns when its time has come (and nobody
/// moves while it turns), else the rival moves on when its pace allows.
TurnaboutState turnaboutStep(TurnaboutPuzzle p, TurnaboutState s) {
  if (s.result != TurnaboutResult.running) return s;
  final round = p.round(s.round);
  final tick = s.tick + 1;
  if (s.turnsDone < round.turns.length && round.turns[s.turnsDone].$1 <= tick) {
    final by = round.turns[s.turnsDone].$2;
    return s.copyWith(tick: tick, orient: (s.orient + by) & 3, turnsDone: s.turnsDone + 1, turnAt: tick, turnBy: by);
  }
  if (tick < s.turnAt + turnaboutTurnTicks(s.turnBy)) return s.copyWith(tick: tick);
  final clock = s.clock + 1;
  var rival = s.rival;
  if (round.rival >= 0 && clock % p.rivalPace(s.wins) == 0) rival++;
  if (round.rival >= 0 && round.rivalPath[rival] == round.prize) {
    return s.copyWith(tick: tick, clock: clock, rival: rival, losses: s.losses + 1, result: TurnaboutResult.lost);
  }
  return s.copyWith(tick: tick, clock: clock, rival: rival);
}

/// The runner moves one cell toward screen direction [screen] (0 up, 1 right,
/// 2 down, 3 left). Unchanged ([identical]) if it can't move now or a wall
/// is in the way.
TurnaboutState turnaboutMove(TurnaboutPuzzle p, TurnaboutState s, int screen) {
  if (!turnaboutCanMove(s)) return s;
  final round = p.round(s.round);
  final to = turnaboutStepCell(round.n, round.open, s.player, turnaboutMazeDir(screen, s.orient));
  if (to < 0) return s;
  final won = to == round.prize;
  return s.copyWith(
    player: to,
    readyAt: s.tick + turnaboutPlayerTicks,
    wins: won ? s.wins + 1 : null,
    result: won ? TurnaboutResult.won : null,
  );
}

/// The next round, once this one is decided.
TurnaboutState turnaboutNext(TurnaboutPuzzle p, TurnaboutState s) {
  if (s.result == TurnaboutResult.running || turnaboutOver(p, s)) return s;
  return TurnaboutState.start(p, s.round + 1, wins: s.wins, losses: s.losses);
}

/// The screen direction of the runner's shortest way to the star (it
/// depends on how the maze is turned now).
int turnaboutBestDir(TurnaboutPuzzle p, TurnaboutState s) {
  final round = p.round(s.round);
  for (var d = 0; d < 4; d++) {
    final j = turnaboutStepCell(round.n, round.open, s.player, d);
    if (j >= 0 && round.toPrize[j] == round.toPrize[s.player] - 1) return turnaboutScreenDir(d, s.orient);
  }
  return 0;
}

/// The perfect player's next action: the next round, a move on the shortest
/// way as soon as it may move, else a step of the clock. Null when the game
/// is over.
TurnaboutState? turnaboutAuto(TurnaboutPuzzle p, TurnaboutState s) {
  if (turnaboutOver(p, s)) return null;
  if (s.result != TurnaboutResult.running) return turnaboutNext(p, s);
  if (turnaboutCanMove(s)) return turnaboutMove(p, s, turnaboutBestDir(p, s));
  return turnaboutStep(p, s);
}
