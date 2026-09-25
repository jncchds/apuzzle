import 'package:flutter/material.dart';

import '../../core/difficulty.dart';
import '../../core/game_controller.dart';
import '../../core/grid.dart';
import '../../core/puzzle_type.dart';
import '../../core/tutorial.dart';
import '../../l10n/l10n.dart';
import 'merge_board.dart';
import 'merge_generator.dart';
import 'merge_model.dart';
import 'merge_tutorial.dart';

/// 2048: slide every tile one way; two equal tiles that meet merge into
/// their sum. Difficulty sets the tile to build.
class MergeType extends PuzzleType<MergePuzzle, MergeState> {
  const MergeType();

  @override
  String get id => 'merge';
  @override
  String name(AppLocalizations l) => l.mergeName;
  @override
  String tagline(AppLocalizations l) => l.mergeTagline;
  @override
  IconData get icon => Icons.grid_4x4_rounded;
  @override
  Color get accent => const Color(0xFFF0605D);

  @override
  String rulesText(AppLocalizations l) => l.mergeRules;

  @override
  List<TutorialStep> tutorial() => mergeTutorial;

  @override
  List<GridSize> get sizes => const [GridSize.square(3), GridSize.square(4), GridSize.square(5), GridSize.square(6)];
  @override
  GridSize get defaultSize => const GridSize.square(4);
  @override
  GridSize dailySize(Difficulty difficulty) => const GridSize.square(4);
  @override
  double get controlsHeight => 56;
  @override
  bool get showSubmit => false;

  @override
  List<GameOption> optionsFor(Map<String, String> chosen) => const [
        GameOption('goal', ['target', 'free']),
      ];

  @override
  String optionLabel(AppLocalizations l, String option) => l.popGoal;

  @override
  String choiceLabel(AppLocalizations l, String option, String choice) => switch (choice) {
        'target' => l.mergeGoalTarget,
        'free' => l.popGoalFree,
        _ => choice,
      };

  @override
  String? choiceDescription(AppLocalizations l, String option, String choice) => switch (choice) {
        'target' => l.mergeGoalTargetHint,
        'free' => l.mergeGoalFreeHint,
        _ => null,
      };

  @override
  MergePuzzle generate(GenParams params) => generateMerge(params, MergeGoal.byId(resolveOptions(params.options)['goal']));

  @override
  MergeState initialState(MergePuzzle puzzle) => MergeState.initial(puzzle);

  @override
  bool isComplete(MergePuzzle puzzle, MergeState state) =>
      (puzzle.goal == MergeGoal.target && state.best >= puzzle.target) || !mergeCanMove(state.cells, puzzle.rows, puzzle.cols);

  @override
  bool isSolved(MergePuzzle puzzle, MergeState state) => puzzle.goal == MergeGoal.free || state.best >= puzzle.target;

  @override
  Set<Pos> conflicts(MergePuzzle puzzle, MergeState state) => const {};

  @override
  HintResult<MergeState>? hint(MergePuzzle puzzle, MergeState state) {
    final dir = mergeSuggest(puzzle, state);
    if (dir == null) return null;
    final next = mergeMove(puzzle, state, dir)!;
    return HintResult(next, {for (final (_, at) in next.merged) puzzle.size.pos(at)});
  }

  @override
  int? score(MergePuzzle puzzle, MergeState state) => state.score;

  @override
  String finishTitle(AppLocalizations l, MergePuzzle puzzle, MergeState state) =>
      puzzle.goal == MergeGoal.target ? l.mergeReached(puzzle.target) : l.popGameOver;

  void _move(GameController ctrl, MergeDir dir) {
    final p = ctrl.puzzle as MergePuzzle;
    final next = mergeMove(p, ctrl.state as MergeState, dir);
    if (next == null) return;
    ctrl.apply(next);
    if (!ctrl.solved && isComplete(p, next)) ctrl.showToast((l) => l.mergeStuck);
  }

  @override
  Widget buildBoard(BuildContext context, GameController ctrl) {
    final p = ctrl.puzzle as MergePuzzle;
    final s = ctrl.state as MergeState;
    return MergeBoard(
      rows: p.rows,
      cols: p.cols,
      cells: s.cells,
      ids: s.ids,
      merged: s.merged,
      hinted: {for (final pos in ctrl.flashHints) p.size.index(pos)},
      win: ctrl.winAnimation,
      onMove: ctrl.solved ? null : (dir) => _move(ctrl, dir),
    );
  }

  @override
  Widget? buildControls(BuildContext context, GameController ctrl) {
    final p = ctrl.puzzle as MergePuzzle;
    final s = ctrl.state as MergeState;
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
    return Wrap(spacing: 10, runSpacing: 8, alignment: WrapAlignment.center, children: [
      pill(l.popPoints(s.score)),
      if (p.goal == MergeGoal.target) pill('${s.best} / ${p.target}', strong: s.best >= p.target) else pill(l.mergeBest(s.best)),
    ]);
  }

  @override
  Map<String, dynamic> encodePuzzle(MergePuzzle puzzle) => puzzle.toJson();
  @override
  MergePuzzle decodePuzzle(Map<String, dynamic> json) => MergePuzzle.fromJson(json);
  @override
  Map<String, dynamic> encodeState(MergeState state) => state.toJson();
  @override
  MergeState decodeState(Map<String, dynamic> json) => MergeState.fromJson(json);
}
