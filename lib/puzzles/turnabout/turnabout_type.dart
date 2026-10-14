import 'package:flutter/material.dart';

import '../../core/day.dart';
import '../../core/difficulty.dart';
import '../../core/game_controller.dart';
import '../../core/grid.dart';
import '../../core/puzzle_type.dart';
import '../../core/tutorial.dart';
import '../../l10n/l10n.dart';
import 'turnabout_board.dart';
import 'turnabout_generator.dart';
import 'turnabout_model.dart';
import 'turnabout_tutorial.dart';

/// Turnabout: race a rival through a maze to the star, while the maze keeps
/// turning. Real time, in rounds; difficulty sets the rival's pace, the
/// mazes and how often they turn.
class TurnaboutType extends PuzzleType<TurnaboutPuzzle, TurnaboutState> {
  const TurnaboutType();

  @override
  String get id => 'turnabout';
  @override
  String name(AppLocalizations l) => l.turnaboutName;
  @override
  String tagline(AppLocalizations l) => l.turnaboutTagline;
  @override
  IconData get icon => Icons.screen_rotation_alt_rounded;
  @override
  Color get accent => TurnaboutBoard.runnerColor;

  @override
  String rulesText(AppLocalizations l) => l.turnaboutRules;

  @override
  List<TutorialStep> tutorial() => turnaboutTutorial;

  @override
  List<GridSize> get sizes => const [
    GridSize.square(6),
    GridSize.square(7),
    GridSize.square(8),
    GridSize.square(9),
    GridSize.square(10),
    GridSize.square(12),
  ];
  @override
  GridSize get defaultSize => const GridSize.square(8);
  @override
  GridSize dailySize(Difficulty difficulty) => switch (difficulty) {
    Difficulty.easy => const GridSize.square(7),
    Difficulty.medium => const GridSize.square(8),
    _ => const GridSize.square(9),
  };
  @override
  Day get dailySince => const Day(2026, 10, 15);
  @override
  bool get dailyOptIn => true;
  @override
  double get minCellSize => 28;
  @override
  double get controlsHeight => 56;
  @override
  bool get showSubmit => false;
  @override
  bool get realTime => true;

  @override
  List<GameOption> optionsFor(Map<String, String> chosen) => const [
    GameOption('goal', ['rounds', 'lives']),
  ];

  @override
  String optionLabel(AppLocalizations l, String option) => l.popGoal;

  @override
  String choiceLabel(AppLocalizations l, String option, String choice) => switch (choice) {
    'rounds' => l.recallGoalRounds(turnaboutRounds),
    'lives' => l.recallGoalLives(turnaboutLives),
    _ => choice,
  };

  @override
  String? choiceDescription(AppLocalizations l, String option, String choice) => switch (choice) {
    'rounds' => l.turnaboutGoalRoundsHint,
    'lives' => l.turnaboutGoalLivesHint(turnaboutLives),
    _ => null,
  };

  @override
  TurnaboutPuzzle generate(GenParams params) =>
      generateTurnabout(params, TurnaboutGoal.byId(resolveOptions(params.options)['goal']));

  @override
  TurnaboutState initialState(TurnaboutPuzzle puzzle) => TurnaboutState.start(puzzle, 0);

  @override
  bool isComplete(TurnaboutPuzzle puzzle, TurnaboutState state) => turnaboutOver(puzzle, state);

  /// A score game: the end is the finish (a practice board must be won).
  @override
  bool isSolved(TurnaboutPuzzle puzzle, TurnaboutState state) => !puzzle.practice || state.losses == 0;

  @override
  Set<Pos> conflicts(TurnaboutPuzzle puzzle, TurnaboutState state) => const {};

  /// The perfect player's next action (not offered in play; tests and snapshots use it).
  @override
  HintResult<TurnaboutState>? hint(TurnaboutPuzzle puzzle, TurnaboutState state) {
    final next = turnaboutAuto(puzzle, state);
    return next == null ? null : HintResult(next, const {});
  }

  @override
  int? score(TurnaboutPuzzle puzzle, TurnaboutState state) => state.wins;

  @override
  String finishTitle(AppLocalizations l, TurnaboutPuzzle puzzle, TurnaboutState state) =>
      puzzle.rounds != null ? l.turnaboutFinished(state.wins, puzzle.rounds!) : l.turnaboutStreak(state.wins);

  @override
  Widget buildBoard(BuildContext context, GameController ctrl) {
    final p = ctrl.puzzle as TurnaboutPuzzle;
    final s = ctrl.state as TurnaboutState;
    final live = !ctrl.solved;
    return TurnaboutBoard(
      puzzle: p,
      state: s,
      onStep: live
          ? () {
              final now = ctrl.state as TurnaboutState;
              final next = turnaboutStep(p, now);
              // Plain steps aren't worth a save; turns and round ends are.
              ctrl.advance(next, persist: next.result != now.result || next.turnsDone != now.turnsDone);
            }
          : null,
      onMove: live
          ? (dir) {
              final now = ctrl.state as TurnaboutState;
              if (!turnaboutCanMove(now)) return TurnaboutMoveResult.wait;
              final next = turnaboutMove(p, now, dir);
              if (identical(next, now)) return TurnaboutMoveResult.blocked;
              ctrl.advance(next, persist: next.result != now.result);
              return TurnaboutMoveResult.moved;
            }
          : null,
      onNext: live ? () => ctrl.advance(turnaboutNext(p, ctrl.state as TurnaboutState)) : null,
      onRestart: ctrl.restart,
    );
  }

  @override
  Widget? buildControls(BuildContext context, GameController ctrl) {
    final p = ctrl.puzzle as TurnaboutPuzzle;
    final s = ctrl.state as TurnaboutState;
    // A practice board is one round: nothing to count.
    if (p.practice) return null;
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
    final rounds = p.rounds;
    return Wrap(
      spacing: 10,
      runSpacing: 8,
      alignment: WrapAlignment.center,
      children: [
        pill(rounds != null ? l.recallRound(s.round + 1, rounds) : l.turnaboutRound(s.round + 1)),
        pill(l.turnaboutScore(s.wins, s.losses), strong: true),
        if (rounds == null) pill(l.recallGoalLives(turnaboutLives - s.losses)),
      ],
    );
  }

  @override
  Map<String, dynamic> encodePuzzle(TurnaboutPuzzle puzzle) => puzzle.toJson();
  @override
  TurnaboutPuzzle decodePuzzle(Map<String, dynamic> json) => TurnaboutPuzzle.fromJson(json);
  @override
  Map<String, dynamic> encodeState(TurnaboutState state) => state.toJson();
  @override
  TurnaboutState decodeState(Map<String, dynamic> json) => TurnaboutState.fromJson(json);
}
