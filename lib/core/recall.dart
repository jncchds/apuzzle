import 'dart:math';

import 'package:flutter/material.dart';

import '../l10n/l10n.dart';
import '../ui/board/recall_board.dart';
import 'difficulty.dart';
import 'game_controller.dart';
import 'grid.dart';
import 'puzzle_type.dart';

/// Memory games: every round shows something (lit cells, numbers, jumps,
/// bumpers) for a moment or until the player is ready, hides it, and takes
/// the player's answer from memory. A right answer makes the next round one
/// level harder, a miss one level easier. The game is [RecallPuzzle.rounds]
/// rounds, or goes on until [RecallPuzzle.lives] misses; right rounds score
/// their level.
///
/// A round is a list of ints that its type reads (the lit cells, the cells
/// of 1, 2, 3...). It comes from the seed, the round number and the level
/// ([recallRound]), so a share code replays the same game.

enum RecallPhase {
  /// The round is on show.
  show,

  /// Hidden: the player answers.
  answer,

  /// The answer is in: right or wrong is shown for a moment.
  result,

  /// The game is over.
  done,
}

/// What ends a game.
enum RecallGoal {
  /// A fixed number of rounds.
  rounds('rounds'),

  /// Until the third miss.
  lives('lives');

  const RecallGoal(this.id);
  final String id;

  static RecallGoal byId(String? id) => values.firstWhere((g) => g.id == id, orElse: () => rounds);
}

/// Rounds of a [RecallGoal.rounds] game.
const recallRounds = 10;

/// Misses that end a [RecallGoal.lives] game.
const recallLives = 3;

/// How a round's answer stands after a tap.
enum RecallVerdict { going, passed, failed }

class RecallPuzzle {
  const RecallPuzzle({
    required this.rows,
    required this.cols,
    required this.seed,
    required this.difficulty,
    required this.goal,
    required this.rounds,
    required this.lives,
    required this.start,
    required this.min,
    required this.max,
    required this.pace,
    this.variant = '',
    this.retry = false,
    this.fixed = const [],
  });

  final int rows;
  final int cols;
  final int seed;
  final Difficulty difficulty;
  final RecallGoal goal;

  /// Rounds of a [RecallGoal.rounds] game (with [retry]: right rounds needed).
  final int rounds;

  /// Misses that end a [RecallGoal.lives] game.
  final int lives;

  /// The first round's level, and the range levels stay in.
  final int start;
  final int min;
  final int max;

  /// Show times in percent of the normal ones (longer on easy).
  final int pace;

  /// A type's own choice (Hopper's order), or empty.
  final String variant;

  /// A practice board (tutorials): a miss replays the same round, and the
  /// game ends after [rounds] right ones.
  final bool retry;

  /// Hand-made rounds played first (tutorials), instead of generated ones.
  final List<List<int>> fixed;

  GridSize get size => GridSize(rows, cols);
  int get cells => rows * cols;

  /// [ms] at this puzzle's pace.
  int paced(num ms) => (ms * pace / 100).round();

  Map<String, dynamic> toJson() => {
    'rows': rows,
    'cols': cols,
    'seed': seed,
    'difficulty': difficulty.name,
    'goal': goal.id,
    'rounds': rounds,
    'lives': lives,
    'start': start,
    'min': min,
    'max': max,
    'pace': pace,
    if (variant.isNotEmpty) 'variant': variant,
    if (retry) 'retry': true,
    if (fixed.isNotEmpty) 'fixed': fixed,
  };

  factory RecallPuzzle.fromJson(Map<String, dynamic> j) => RecallPuzzle(
    rows: j['rows'] as int,
    cols: j['cols'] as int,
    seed: j['seed'] as int,
    difficulty: Difficulty.values.byName(j['difficulty'] as String),
    goal: RecallGoal.byId(j['goal'] as String?),
    rounds: j['rounds'] as int,
    lives: j['lives'] as int,
    start: j['start'] as int,
    min: j['min'] as int,
    max: j['max'] as int,
    pace: j['pace'] as int,
    variant: j['variant'] as String? ?? '',
    retry: j['retry'] as bool? ?? false,
    fixed: [for (final r in (j['fixed'] as List?) ?? const []) (r as List).cast<int>()],
  );
}

class RecallState {
  const RecallState({
    required this.round,
    required this.level,
    this.score = 0,
    this.correct = 0,
    this.misses = 0,
    this.phase = RecallPhase.show,
    this.taps = const [],
    this.passed = false,
  });

  factory RecallState.initial(RecallPuzzle p) => RecallState(round: 0, level: p.start);

  /// Rounds played before this one (a replayed practice round keeps its number).
  final int round;

  /// This round's level: what it shows (cells, numbers, jumps, bumpers).
  final int level;
  final int score;

  /// Rounds right and missed so far.
  final int correct;
  final int misses;
  final RecallPhase phase;

  /// The player's answer so far: cells (or edge slots) in tap order.
  final List<int> taps;

  /// In [RecallPhase.result] (and after): whether the last round was right.
  final bool passed;

  RecallState copyWith({
    int? score,
    int? correct,
    int? misses,
    RecallPhase? phase,
    List<int>? taps,
    bool? passed,
  }) => RecallState(
    round: round,
    level: level,
    score: score ?? this.score,
    correct: correct ?? this.correct,
    misses: misses ?? this.misses,
    phase: phase ?? this.phase,
    taps: taps ?? this.taps,
    passed: passed ?? this.passed,
  );

  Map<String, dynamic> toJson() => {
    'round': round,
    'level': level,
    'score': score,
    'correct': correct,
    'misses': misses,
    'phase': phase.name,
    'taps': taps,
    if (passed) 'passed': true,
  };

  factory RecallState.fromJson(Map<String, dynamic> j) => RecallState(
    round: j['round'] as int,
    level: j['level'] as int,
    score: j['score'] as int? ?? 0,
    correct: j['correct'] as int? ?? 0,
    misses: j['misses'] as int? ?? 0,
    phase: RecallPhase.values.byName(j['phase'] as String),
    taps: (j['taps'] as List? ?? const []).cast<int>(),
    passed: j['passed'] as bool? ?? false,
  );
}

/// Everything a [RecallType] needs to paint the board.
class RecallView {
  const RecallView({
    required this.puzzle,
    required this.state,
    required this.round,
    required this.cell,
    required this.origin,
    required this.ms,
    required this.t,
    required this.waiting,
    required this.scheme,
    required this.accent,
  });

  final RecallPuzzle puzzle;
  final RecallState state;
  final List<int> round;

  /// Cell size, and the top-left corner of the grid (frame bands lie outside).
  final double cell;
  final Offset origin;

  /// Milliseconds into the phase, and the phase's progress (0..1).
  final double ms;
  final double t;

  /// The game waits for a tap to start: nothing is shown yet.
  final bool waiting;
  final ColorScheme scheme;
  final Color accent;

  RecallPhase get phase => state.phase;

  /// A right answer shows in this, a wrong tap in [bad].
  Color get good => const Color(0xFF3DBA6A);
  Color get bad => scheme.error;

  /// An empty tile.
  Color get tile => scheme.surfaceContainerHighest;

  Rect rectAt(int r, int c) => Rect.fromLTWH(origin.dx + c * cell, origin.dy + r * cell, cell, cell);
  Rect rectOf(int index) => rectAt(index ~/ puzzle.cols, index % puzzle.cols);
  Offset centerOf(int index) => rectOf(index).center;

  /// The tile of [index], [inset] of a cell smaller on every side.
  RRect tileOf(int index, {double inset = 0.06}) =>
      RRect.fromRectAndRadius(rectOf(index).deflate(cell * inset), Radius.circular(cell * 0.16));

  /// Every cell as an empty tile.
  void paintTiles(Canvas canvas) {
    final paint = Paint()..color = tile;
    for (var i = 0; i < puzzle.cells; i++) {
      canvas.drawRRect(tileOf(i), paint);
    }
  }

  /// [text] centred in [rect], [size] of a cell high.
  void paintText(Canvas canvas, String text, Rect rect, Color color, {double size = 0.5}) {
    final tp = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(color: color, fontSize: cell * size, fontWeight: FontWeight.w700, height: 1),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, rect.center - Offset(tp.width / 2, tp.height / 2));
    tp.dispose();
  }

  /// A cross over [rect] (a wrong tap).
  void paintCross(Canvas canvas, Rect rect, Color color) {
    final e = rect.shortestSide * 0.22;
    final c = rect.center;
    final pen = Paint()
      ..color = color
      ..strokeWidth = rect.shortestSide * 0.09
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(c + Offset(-e, -e), c + Offset(e, e), pen);
    canvas.drawLine(c + Offset(-e, e), c + Offset(e, -e), pen);
  }
}

/// The base of memory games: options, rounds, levels, score, the board with
/// its timers ([RecallBoard]) and the controls. Real time (no undo, redo or
/// hints); [hint] plays the right answer for tests and snapshots.
abstract class RecallType extends PuzzleType<RecallPuzzle, RecallState> {
  const RecallType();

  /// A new round at [level], drawn with [rng]. Pure.
  List<int> makeRound(RecallPuzzle p, int level, Random rng);

  /// Whether a tap on [target] counts as an answer (a tap on an empty cell
  /// or on one already tapped can be ignored).
  bool accepts(RecallPuzzle p, List<int> round, List<int> taps, int target);

  /// How the answer [taps] stands.
  RecallVerdict verdict(RecallPuzzle p, List<int> round, List<int> taps);

  /// The next right tap after [taps].
  int nextTap(RecallPuzzle p, List<int> round, List<int> taps);

  /// How long a round is shown, or null to show it until the first tap
  /// ([answerWhileShown]).
  int? showMs(RecallPuzzle p, List<int> round);

  /// The lowest and highest level on a board of [size].
  (int, int) levels(GridSize size);

  /// The first round's level at [difficulty].
  int startLevel(Difficulty difficulty);

  /// Paints the board: grid, what is shown, the answer and the feedback.
  void paint(Canvas canvas, RecallView view);

  /// What the player is asked to do once the round is hidden.
  String prompt(AppLocalizations l, RecallPuzzle p);

  /// What the player is told while the round is on show.
  String watchText(AppLocalizations l, RecallPuzzle p) => l.recallWatch;

  /// Taps already answer while the round is on show; the first one hides it.
  bool get answerWhileShown => false;

  /// A Ready button hides the round early.
  bool get hasReady => true;

  /// Width of the band around the grid, in cells (edge slots).
  double get frame => 0;

  /// The answer target at row [r], column [c] (outside the grid within
  /// [frame]: -1 or rows/cols), or null if nothing is there.
  int? targetAt(RecallPuzzle p, int r, int c) => r >= 0 && c >= 0 && r < p.rows && c < p.cols ? r * p.cols + c : null;

  /// Extra options of the type, shown before the goal.
  List<GameOption> get extraOptions => const [];

  @override
  bool get dailyOptIn => true;
  @override
  bool get realTime => true;
  @override
  bool get showSubmit => false;
  @override
  double get controlsHeight => 104;

  @override
  List<GameOption> optionsFor(Map<String, String> chosen) => [
    ...extraOptions,
    const GameOption('goal', ['rounds', 'lives']),
  ];

  @override
  String optionLabel(AppLocalizations l, String option) => l.popGoal;

  @override
  String choiceLabel(AppLocalizations l, String option, String choice) => switch (choice) {
    'rounds' => l.recallGoalRounds(recallRounds),
    'lives' => l.recallGoalLives(recallLives),
    _ => choice,
  };

  @override
  String? choiceDescription(AppLocalizations l, String option, String choice) => switch (choice) {
    'rounds' => l.recallGoalRoundsHint,
    'lives' => l.recallGoalLivesHint(recallLives),
    _ => null,
  };

  /// Show times at [difficulty], in percent.
  int pace(Difficulty difficulty) => switch (difficulty) {
    Difficulty.easy => 130,
    Difficulty.medium => 100,
    _ => 75,
  };

  @override
  RecallPuzzle generate(GenParams params) {
    final options = resolveOptions(params.options);
    final (lo, hi) = levels(params.size);
    return RecallPuzzle(
      rows: params.size.rows,
      cols: params.size.cols,
      seed: params.seed,
      difficulty: params.difficulty,
      goal: RecallGoal.byId(options['goal']),
      rounds: recallRounds,
      lives: recallLives,
      start: startLevel(params.difficulty).clamp(lo, hi),
      min: lo,
      max: hi,
      pace: pace(params.difficulty),
      variant: [
        for (final o in extraOptions) options[o.id]!,
      ].join('.'),
    );
  }

  /// The round [s] is playing.
  List<int> roundOf(RecallPuzzle p, RecallState s) => recallRound(this, p, s.round, s.level);

  @override
  RecallState initialState(RecallPuzzle puzzle) => RecallState.initial(puzzle);

  @override
  bool isComplete(RecallPuzzle puzzle, RecallState state) => state.phase == RecallPhase.done;

  /// A score game: the end is the finish.
  @override
  bool isSolved(RecallPuzzle puzzle, RecallState state) => true;

  @override
  Set<Pos> conflicts(RecallPuzzle puzzle, RecallState state) => const {};

  /// The right next move (not offered in play; tests and snapshots use it).
  @override
  HintResult<RecallState>? hint(RecallPuzzle puzzle, RecallState state) {
    final next = recallAuto(this, puzzle, state);
    return next == null ? null : HintResult(next, const {});
  }

  @override
  int? score(RecallPuzzle puzzle, RecallState state) => state.score;

  @override
  String finishTitle(AppLocalizations l, RecallPuzzle puzzle, RecallState state) =>
      puzzle.goal == RecallGoal.rounds ? l.recallRoundsRight(state.correct, puzzle.rounds) : l.popGameOver;

  @override
  Widget buildBoard(BuildContext context, GameController controller) => RecallBoard(type: this, controller: controller);

  @override
  Widget? buildControls(BuildContext context, GameController controller) =>
      RecallControls(type: this, controller: controller);

  @override
  Map<String, dynamic> encodePuzzle(RecallPuzzle puzzle) => puzzle.toJson();
  @override
  RecallPuzzle decodePuzzle(Map<String, dynamic> json) => RecallPuzzle.fromJson(json);
  @override
  Map<String, dynamic> encodeState(RecallState state) => state.toJson();
  @override
  RecallState decodeState(Map<String, dynamic> json) => RecallState.fromJson(json);
}

final _rounds = <String, List<int>>{};

/// Round [round] of [p] at [level]: a hand-made one, or one drawn from the
/// seed, the round number and the level (cached).
List<int> recallRound(RecallType type, RecallPuzzle p, int round, int level) {
  if (round < p.fixed.length) return p.fixed[round];
  final key = '${type.id}.${p.rows}x${p.cols}.${p.seed}.${p.difficulty.name}.${p.variant}.$round.$level';
  final hit = _rounds[key];
  if (hit != null) return hit;
  if (_rounds.length > 64) _rounds.clear();
  // Products stay below 2^53, so the web draws the same rounds.
  final rng = Random((p.seed * 1000003 + round * 7919 + level * 104729 + 17) & 0x7fffffff);
  return _rounds[key] = List.unmodifiable(type.makeRound(p, level, rng));
}

/// Hides the round on show.
RecallState recallHide(RecallState s) => s.phase == RecallPhase.show ? s.copyWith(phase: RecallPhase.answer) : s;

/// A tap on [target]: an answer while the round is hidden (or on show, for
/// [RecallType.answerWhileShown]); right or wrong once it is decided.
RecallState recallTap(RecallType type, RecallPuzzle p, RecallState s, int target) {
  if (s.phase != RecallPhase.answer && !(s.phase == RecallPhase.show && type.answerWhileShown)) return s;
  final round = type.roundOf(p, s);
  if (!type.accepts(p, round, s.taps, target)) return s;
  final taps = [...s.taps, target];
  return switch (type.verdict(p, round, taps)) {
    RecallVerdict.going => s.copyWith(phase: RecallPhase.answer, taps: taps),
    RecallVerdict.passed => s.copyWith(
      phase: RecallPhase.result,
      taps: taps,
      passed: true,
      score: s.score + s.level,
      correct: s.correct + 1,
    ),
    RecallVerdict.failed => s.copyWith(phase: RecallPhase.result, taps: taps, passed: false, misses: s.misses + 1),
  };
}

/// After the result: the next round one level up (right) or down (missed),
/// or the end of the game.
RecallState recallNext(RecallPuzzle p, RecallState s) {
  if (s.phase != RecallPhase.result) return s;
  final ok = s.passed;
  final again = p.retry && !ok;
  final over = p.retry
      ? s.correct >= p.rounds
      : p.goal == RecallGoal.lives
      ? s.misses >= p.lives
      : s.round + 1 >= p.rounds;
  return RecallState(
    round: again ? s.round : s.round + 1,
    level: again ? s.level : (s.level + (ok ? 1 : -1)).clamp(p.min, p.max),
    score: s.score,
    correct: s.correct,
    misses: s.misses,
    phase: over ? RecallPhase.done : RecallPhase.show,
    passed: ok,
  );
}

/// The state after the right next move, or null when the game is over.
RecallState? recallAuto(RecallType type, RecallPuzzle p, RecallState s) => switch (s.phase) {
  RecallPhase.show when !type.answerWhileShown => recallHide(s),
  RecallPhase.show || RecallPhase.answer => recallTap(type, p, s, type.nextTap(p, type.roundOf(p, s), s.taps)),
  RecallPhase.result => recallNext(p, s),
  RecallPhase.done => null,
};

/// A practice game for a tutorial step on [size]: the [fixed] rounds (then
/// generated ones), finished after [rounds] right ones; a miss replays the
/// round.
RecallPuzzle recallPractice(
  RecallType type,
  GridSize size, {
  List<List<int>> fixed = const [],
  int? rounds,
  int? start,
  int seed = 1,
  String variant = '',
}) {
  final (lo, hi) = type.levels(size);
  return RecallPuzzle(
    rows: size.rows,
    cols: size.cols,
    seed: seed,
    difficulty: Difficulty.easy,
    goal: RecallGoal.rounds,
    rounds: rounds ?? fixed.length,
    lives: recallLives,
    start: (start ?? lo).clamp(lo, hi),
    min: lo,
    max: hi,
    pace: type.pace(Difficulty.easy),
    variant: variant,
    retry: true,
    fixed: fixed,
  );
}

/// [count] distinct cells of [p] in random order.
List<int> recallCells(RecallPuzzle p, int count, Random rng) {
  final all = List.generate(p.cells, (i) => i)..shuffle(rng);
  return all.take(min(count, p.cells)).toList();
}
