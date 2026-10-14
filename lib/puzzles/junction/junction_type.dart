import 'package:flutter/material.dart';

import '../../core/day.dart';
import '../../core/difficulty.dart';
import '../../core/game_controller.dart';
import '../../core/grid.dart';
import '../../core/puzzle_type.dart';
import '../../core/tutorial.dart';
import '../../l10n/l10n.dart';
import 'junction_board.dart';
import 'junction_generator.dart';
import 'junction_model.dart';
import 'junction_tutorial.dart';

/// Junction: trains leave a depot one by one and run along a branching
/// track; tap the switches so each reaches the station with its symbol.
/// Real time; difficulty sets the speed, the departures and the stations.
class JunctionType extends PuzzleType<JunctionPuzzle, JunctionState> {
  const JunctionType();

  @override
  String get id => 'junction';
  @override
  String name(AppLocalizations l) => l.junctionName;
  @override
  String tagline(AppLocalizations l) => l.junctionTagline;
  @override
  IconData get icon => Icons.alt_route_rounded;
  @override
  Color get accent => JunctionBoard.trackColor;

  @override
  String rulesText(AppLocalizations l) => l.junctionRules;

  @override
  List<TutorialStep> tutorial() => junctionTutorial;

  @override
  List<GridSize> get sizes => const [
    GridSize.square(7),
    GridSize.square(8),
    GridSize.square(9),
    GridSize.square(10),
    GridSize(14, 10),
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
    GameOption('goal', ['trains', 'timed']),
  ];

  @override
  String optionLabel(AppLocalizations l, String option) => l.popGoal;

  @override
  String choiceLabel(AppLocalizations l, String option, String choice) => switch (choice) {
    'trains' => l.junctionGoalTrains(junctionTrainCount),
    'timed' => l.junctionGoalTimed(junctionRoundSeconds ~/ 60),
    _ => choice,
  };

  @override
  String? choiceDescription(AppLocalizations l, String option, String choice) => switch (choice) {
    'trains' => l.junctionGoalTrainsHint,
    'timed' => l.junctionGoalTimedHint,
    _ => null,
  };

  @override
  JunctionPuzzle generate(GenParams params) =>
      generateJunction(params, JunctionGoal.byId(resolveOptions(params.options)['goal']));

  @override
  JunctionState initialState(JunctionPuzzle puzzle) => JunctionState.initial(puzzle);

  @override
  bool isComplete(JunctionPuzzle puzzle, JunctionState state) => junctionOver(puzzle, state);

  /// A score game: the end is the finish (a practice board wants no misses).
  @override
  bool isSolved(JunctionPuzzle puzzle, JunctionState state) => !puzzle.perfect || state.misses == 0;

  @override
  Set<Pos> conflicts(JunctionPuzzle puzzle, JunctionState state) => const {};

  /// The perfect player's next move (not offered in play; tests and snapshots use it).
  @override
  HintResult<JunctionState>? hint(JunctionPuzzle puzzle, JunctionState state) {
    final next = junctionAuto(puzzle, state);
    return next == null ? null : HintResult(next, const {});
  }

  @override
  int? score(JunctionPuzzle puzzle, JunctionState state) => state.score;

  @override
  String finishTitle(AppLocalizations l, JunctionPuzzle puzzle, JunctionState state) =>
      puzzle.goal == JunctionGoal.trains ? l.junctionFinished(state.score, puzzle.trains) : l.junctionTimeUp;

  @override
  Widget buildBoard(BuildContext context, GameController ctrl) {
    final p = ctrl.puzzle as JunctionPuzzle;
    final s = ctrl.state as JunctionState;
    return JunctionBoard(
      puzzle: p,
      state: s,
      onStep: ctrl.solved
          ? null
          : () {
              final now = ctrl.state as JunctionState;
              final next = junctionStep(p, now);
              // Plain steps aren't worth a save; departures and arrivals are.
              ctrl.advance(
                next,
                persist: next.next != now.next || next.arrived.length != now.arrived.length || junctionOver(p, next),
              );
            },
      onFlip: ctrl.solved ? null : (k) => ctrl.advance(junctionFlip(p, ctrl.state as JunctionState, k)),
      onRestart: ctrl.restart,
    );
  }

  @override
  Widget? buildControls(BuildContext context, GameController ctrl) {
    final p = ctrl.puzzle as JunctionPuzzle;
    final s = ctrl.state as JunctionState;
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
    final timed = p.goal == JunctionGoal.timed;
    final left = timed ? ((p.ticks - s.tick).clamp(0, p.ticks) * p.stepMs / 1000).ceil() : 0;
    return Wrap(
      spacing: 10,
      runSpacing: 8,
      alignment: WrapAlignment.center,
      children: [
        if (timed) pill('${left ~/ 60}:${(left % 60).toString().padLeft(2, '0')}'),
        pill(l.junctionArrived(s.score), strong: true),
        if (!timed) pill('${s.next} / ${p.trains}'),
        pill(l.junctionMisses(s.misses)),
      ],
    );
  }

  @override
  Map<String, dynamic> encodePuzzle(JunctionPuzzle puzzle) => puzzle.toJson();
  @override
  JunctionPuzzle decodePuzzle(Map<String, dynamic> json) => JunctionPuzzle.fromJson(json);
  @override
  Map<String, dynamic> encodeState(JunctionState state) => state.toJson();
  @override
  JunctionState decodeState(Map<String, dynamic> json) => JunctionState.fromJson(json);
}
