import 'package:flutter/material.dart';

import '../../core/difficulty.dart';
import '../../core/game_controller.dart';
import '../../core/grid.dart';
import '../../core/puzzle_type.dart';
import '../../core/tutorial.dart';
import '../../l10n/l10n.dart';
import '../mosaic/mosaic_type.dart';
import 'pop_board.dart';
import 'pop_generator.dart';
import 'pop_model.dart';
import 'pop_tutorial.dart';

/// Bubble popping: tap a group of touching same-colored bubbles to select
/// it, tap again to pop it. Bigger groups score more.
class PopType extends PuzzleType<PopPuzzle, PopState> {
  const PopType();

  static const palette = MosaicType.palette;

  @override
  String get id => 'pop';
  @override
  String name(AppLocalizations l) => l.popName;
  @override
  String tagline(AppLocalizations l) => l.popTagline;
  @override
  IconData get icon => Icons.bubble_chart_rounded;
  @override
  Color get accent => const Color(0xFF5B8DEF);

  @override
  String rulesText(AppLocalizations l) => l.popRules;

  @override
  List<TutorialStep> tutorial() => popTutorial;

  @override
  List<GridSize> get sizes => const [
        GridSize.square(6),
        GridSize.square(8),
        GridSize(10, 8),
        GridSize.square(10),
        GridSize(12, 10),
        GridSize(15, 12),
      ];
  @override
  GridSize get defaultSize => const GridSize(10, 8);
  @override
  GridSize dailySize(Difficulty difficulty) => switch (difficulty) {
        Difficulty.easy => const GridSize.square(6),
        Difficulty.medium => const GridSize.square(8),
        _ => const GridSize(10, 8),
      };
  @override
  double get minCellSize => 28;
  @override
  double get controlsHeight => 56;
  @override
  bool get showSubmit => false;

  static const _modes = GameOption('mode', ['std', 'shift', 'cont', 'mega']);

  @override
  List<GameOption> optionsFor(Map<String, String> chosen) => [
        _modes,
        GameOption('goal', [if (PopMode.byId(chosen['mode']) == PopMode.standard) 'clear', 'target', 'free']),
      ];

  @override
  String optionLabel(AppLocalizations l, String option) => option == 'mode' ? l.popMode : l.popGoal;

  @override
  String choiceLabel(AppLocalizations l, String option, String choice) => switch (choice) {
        'std' => l.popModeStandard,
        'shift' => l.popModeShifter,
        'cont' => l.popModeContinuous,
        'mega' => l.popModeMega,
        'clear' => l.popGoalClear,
        'target' => l.popGoalTarget,
        'free' => l.popGoalFree,
        _ => choice,
      };

  @override
  String? choiceDescription(AppLocalizations l, String option, String choice) => switch (choice) {
        'std' => l.popModeStandardHint,
        'shift' => l.popModeShifterHint,
        'cont' => l.popModeContinuousHint,
        'mega' => l.popModeMegaHint,
        'clear' => l.popGoalClearHint,
        'target' => l.popGoalTargetHint,
        'free' => l.popGoalFreeHint,
        _ => null,
      };

  /// Bump when [generate] changes what a seed produces.
  @override
  int get generatorVersion => 2;

  @override
  PopPuzzle generate(GenParams params) {
    final o = resolveOptions(params.options);
    return generatePop(params, PopMode.byId(o['mode']), PopGoal.byId(o['goal']));
  }

  @override
  PopState initialState(PopPuzzle puzzle) => PopState.initial(puzzle);

  @override
  bool isComplete(PopPuzzle puzzle, PopState state) => !popHasMoves(state.cells, puzzle.rows, puzzle.cols);

  @override
  bool isSolved(PopPuzzle puzzle, PopState state) => switch (puzzle.goal) {
        PopGoal.clear => state.left == 0,
        PopGoal.target => state.score >= puzzle.target,
        PopGoal.free => true,
      };

  @override
  Set<Pos> conflicts(PopPuzzle puzzle, PopState state) => const {};

  @override
  HintResult<PopState>? hint(PopPuzzle puzzle, PopState state) {
    final g = popSuggest(puzzle, state);
    return g == null ? null : HintResult(state, {for (final i in g) puzzle.size.pos(i)});
  }

  @override
  int? score(PopPuzzle puzzle, PopState state) => state.score;

  @override
  String finishTitle(AppLocalizations l, PopPuzzle puzzle, PopState state) => switch (puzzle.goal) {
        PopGoal.clear => l.popCleared,
        PopGoal.target => l.popTargetReached,
        PopGoal.free => l.popGameOver,
      };

  void _tap(GameController ctrl, Pos pos) {
    final p = ctrl.puzzle as PopPuzzle;
    final s = ctrl.state as PopState;
    final i = p.size.index(pos);
    final group = popGroup(s.cells, p.rows, p.cols, i);
    if (group.length < 2) {
      ctrl.select(null);
      return;
    }
    final sel = ctrl.selectedCell;
    if (sel == null || !group.contains(p.size.index(sel))) {
      ctrl.select(pos);
      return;
    }
    ctrl.select(null);
    ctrl.apply(popAt(p, s, i)!);
    final after = ctrl.state as PopState;
    if (!ctrl.solved && isComplete(p, after)) {
      ctrl.showToast((l) => switch (p.goal) {
            PopGoal.clear => l.popStuckBubbles(after.left),
            _ => l.popStuckPoints(p.target - after.score),
          });
    }
  }

  @override
  Widget buildBoard(BuildContext context, GameController ctrl) {
    final p = ctrl.puzzle as PopPuzzle;
    final s = ctrl.state as PopState;
    final sel = ctrl.selectedCell;
    final selected = sel == null ? const <int>[] : popGroup(s.cells, p.rows, p.cols, p.size.index(sel));
    return PopBoard(
      rows: p.rows,
      cols: p.cols,
      cells: s.cells,
      ids: s.ids,
      palette: palette,
      selected: selected.length < 2 ? const {} : selected.toSet(),
      hinted: {for (final pos in ctrl.flashHints) p.size.index(pos)},
      win: ctrl.winAnimation,
      onTap: ctrl.solved ? null : (pos) => _tap(ctrl, pos),
    );
  }

  @override
  Widget? buildControls(BuildContext context, GameController ctrl) {
    final p = ctrl.puzzle as PopPuzzle;
    final s = ctrl.state as PopState;
    final theme = Theme.of(context);
    final l = context.l10n;
    final sel = ctrl.selectedCell;
    final group = sel == null ? 0 : popGroup(s.cells, p.rows, p.cols, p.size.index(sel)).length;
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
      pill(p.goal == PopGoal.target ? '${s.score} / ${p.target}' : l.popPoints(s.score), strong: p.goal == PopGoal.target && s.score >= p.target),
      if (p.goal == PopGoal.clear) pill(l.popLeft(s.left)),
      if (p.mode.refills) pill(l.popColumns(p.reserve.length - s.used)),
      if (group > 1) pill('+${popPoints(group)}', strong: true),
    ]);
  }

  @override
  Map<String, dynamic> encodePuzzle(PopPuzzle puzzle) => puzzle.toJson();
  @override
  PopPuzzle decodePuzzle(Map<String, dynamic> json) => PopPuzzle.fromJson(json);
  @override
  Map<String, dynamic> encodeState(PopState state) => state.toJson();
  @override
  PopState decodeState(Map<String, dynamic> json) => PopState.fromJson(json);
}
