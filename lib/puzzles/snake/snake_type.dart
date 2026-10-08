import 'package:flutter/material.dart';

import '../../core/day.dart';
import '../../core/difficulty.dart';
import '../../core/game_controller.dart';
import '../../core/grid.dart';
import '../../core/puzzle_type.dart';
import '../../core/tutorial.dart';
import '../../l10n/l10n.dart';
import 'snake_board.dart';
import 'snake_generator.dart';
import 'snake_model.dart';
import 'snake_tutorial.dart';

/// Snake: steer a growing snake to the apples without hitting a wall or
/// itself. Real time; difficulty sets the speed.
class SnakeType extends PuzzleType<SnakePuzzle, SnakeState> {
  const SnakeType();

  @override
  String get id => 'snake';
  @override
  String name(AppLocalizations l) => l.snakeName;
  @override
  String tagline(AppLocalizations l) => l.snakeTagline;
  @override
  IconData get icon => Icons.gesture_rounded;
  @override
  Color get accent => SnakeBoard.snakeColor;

  @override
  String rulesText(AppLocalizations l) => l.snakeRules;

  @override
  List<TutorialStep> tutorial() => snakeTutorial;
  @override
  List<TutorialStep> strategies() => snakeStrategies;

  @override
  List<GridSize> get sizes => const [
    GridSize.square(8),
    GridSize.square(10),
    GridSize.square(12),
    GridSize(16, 12),
    GridSize(20, 14),
    GridSize.square(16),
    GridSize.square(20),
  ];
  @override
  GridSize get defaultSize => const GridSize.square(10);
  @override
  GridSize dailySize(Difficulty difficulty) => switch (difficulty) {
    Difficulty.easy => const GridSize.square(8),
    Difficulty.medium => const GridSize.square(10),
    _ => const GridSize.square(12),
  };
  @override
  Day get dailySince => const Day(2026, 10, 8);
  @override
  double get minCellSize => 20;
  @override
  double get controlsHeight => 56;
  @override
  bool get showSubmit => false;
  @override
  bool get realTime => true;

  @override
  List<GameOption> optionsFor(Map<String, String> chosen) => const [
    GameOption('goal', ['free', 'target']),
  ];

  @override
  String optionLabel(AppLocalizations l, String option) => l.popGoal;

  @override
  String choiceLabel(AppLocalizations l, String option, String choice) => switch (choice) {
    'target' => l.snakeGoalTarget,
    'free' => l.popGoalFree,
    _ => choice,
  };

  @override
  String? choiceDescription(AppLocalizations l, String option, String choice) => switch (choice) {
    'target' => l.snakeGoalTargetHint,
    'free' => l.snakeGoalFreeHint,
    _ => null,
  };

  @override
  SnakePuzzle generate(GenParams params) =>
      generateSnake(params, SnakeGoal.byId(resolveOptions(params.options)['goal']));

  @override
  SnakeState initialState(SnakePuzzle puzzle) => SnakeState.initial(puzzle);

  bool _reached(SnakePuzzle p, SnakeState s) => s.full || (p.goal == SnakeGoal.target && s.eaten >= p.target);

  @override
  bool isComplete(SnakePuzzle puzzle, SnakeState state) => state.dead || _reached(puzzle, state);

  /// A crash ends free play (that is its finish), but fails a target.
  @override
  bool isSolved(SnakePuzzle puzzle, SnakeState state) => puzzle.goal == SnakeGoal.free || _reached(puzzle, state);

  @override
  Set<Pos> conflicts(SnakePuzzle puzzle, SnakeState state) => const {};

  /// One step the safe way toward the apple (not offered in play; tests and snapshots use it).
  @override
  HintResult<SnakeState>? hint(SnakePuzzle puzzle, SnakeState state) {
    if (isComplete(puzzle, state)) return null;
    final dir = snakeSuggest(puzzle, state);
    if (dir == null) return null;
    final next = snakeStep(puzzle, state, dir);
    return HintResult(next, {puzzle.size.pos(next.body.first)});
  }

  @override
  int? score(SnakePuzzle puzzle, SnakeState state) => state.eaten;

  @override
  String finishTitle(AppLocalizations l, SnakePuzzle puzzle, SnakeState state) => state.full
      ? l.snakeFull
      : puzzle.goal == SnakeGoal.target
      ? l.snakeFed(puzzle.target)
      : l.popGameOver;

  @override
  Widget buildBoard(BuildContext context, GameController ctrl) {
    final p = ctrl.puzzle as SnakePuzzle;
    final s = ctrl.state as SnakeState;
    return SnakeBoard(
      rows: p.rows,
      cols: p.cols,
      state: s,
      interval: snakeInterval(p, s),
      onStep: ctrl.solved
          ? null
          : (dir) {
              final now = ctrl.state as SnakeState;
              final next = snakeStep(p, now, dir);
              // Straight steps aren't worth a save; turns, apples and crashes are.
              ctrl.advance(next, persist: next.dir != now.dir || next.eaten != now.eaten || next.dead);
            },
      onRestart: ctrl.restart,
    );
  }

  @override
  Widget? buildControls(BuildContext context, GameController ctrl) {
    final p = ctrl.puzzle as SnakePuzzle;
    final s = ctrl.state as SnakeState;
    final theme = Theme.of(context);
    final l = context.l10n;
    final numbers = theme.textTheme.titleMedium?.copyWith(fontFeatures: const [FontFeature.tabularFigures()]);
    Widget pill(String text, {bool strong = false}) => Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: strong ? theme.colorScheme.primary : theme.colorScheme.outline, width: 2),
      ),
      child: Text(text, style: numbers),
    );
    return Wrap(
      spacing: 10,
      runSpacing: 8,
      alignment: WrapAlignment.center,
      children: [
        if (p.goal == SnakeGoal.target)
          pill('${s.eaten} / ${p.target}', strong: s.eaten >= p.target)
        else
          pill(l.snakeApples(s.eaten)),
        pill(l.snakeLength(s.body.length)),
      ],
    );
  }

  @override
  Map<String, dynamic> encodePuzzle(SnakePuzzle puzzle) => puzzle.toJson();
  @override
  SnakePuzzle decodePuzzle(Map<String, dynamic> json) => SnakePuzzle.fromJson(json);
  @override
  Map<String, dynamic> encodeState(SnakeState state) => state.toJson();
  @override
  SnakeState decodeState(Map<String, dynamic> json) => SnakeState.fromJson(json);
}
