import 'package:flutter/material.dart';

import '../../core/difficulty.dart';
import '../../core/game_controller.dart';
import '../../core/grid.dart';
import '../../core/puzzle_type.dart';
import '../mosaic/mosaic_type.dart';
import 'pop_board.dart';
import 'pop_generator.dart';
import 'pop_model.dart';

/// Bubble popping: tap a group of touching same-colored bubbles to select
/// it, tap again to pop it. Bigger groups score more.
class PopType extends PuzzleType<PopPuzzle, PopState> {
  const PopType();

  static const palette = MosaicType.palette;

  @override
  String get id => 'pop';
  @override
  String get name => 'Pop';
  @override
  String get tagline => 'Pop big bubble groups for big points';
  @override
  IconData get icon => Icons.bubble_chart_rounded;
  @override
  Color get accent => const Color(0xFF5B8DEF);

  @override
  String get rulesText => '''
• Tap a group of 2 or more touching bubbles of one color to select it; tap it again to pop it.
• A group of n bubbles scores n × (n − 1), so saving up for big groups pays off.
• Bubbles above fall down, and empty columns close up to the right.

Modes
• Standard: just that.
• Shifter: every row also slides right to close its gaps.
• Continuous: new columns roll in from the left as space frees up.
• Mega: Shifter and Continuous together.

Goals
• Clear the board: pop every bubble (Standard only; there is always a way).
• Target score: reach the score before no moves are left.
• Free play: no target, just beat your best score.

The game ends when no group of 2 is left.''';

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
  double get minCellSize => 28;
  @override
  double get controlsHeight => 56;
  @override
  bool get showSubmit => false;

  static const _modes = GameOption('mode', 'Mode', [
    OptionChoice('std', 'Standard', 'Bubbles fall down; empty columns close up to the right.'),
    OptionChoice('shift', 'Shifter', 'Rows also slide right to close every gap.'),
    OptionChoice('cont', 'Continuous', 'New columns roll in from the left as space frees up.'),
    OptionChoice('mega', 'Mega', 'Shifter and Continuous together.'),
  ]);
  static const _clear = OptionChoice('clear', 'Clear board', 'Pop every bubble. There is always a way.');
  static const _target = OptionChoice('target', 'Target score', 'Reach the target before no moves are left.');
  static const _free = OptionChoice('free', 'Free play', 'No target: play it out and beat your best score.');

  @override
  List<GameOption> optionsFor(Map<String, String> chosen) => [
        _modes,
        GameOption('goal', 'Goal', [if (PopMode.byId(chosen['mode']) == PopMode.standard) _clear, _target, _free]),
      ];

  /// Bump when [generate] changes what a seed produces.
  @override
  int get generatorVersion => 1;

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
  String finishTitle(PopPuzzle puzzle, PopState state) => switch (puzzle.goal) {
        PopGoal.clear => 'Cleared!',
        PopGoal.target => 'Target reached!',
        PopGoal.free => 'Game over',
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
      ctrl.showToast(switch (p.goal) {
        PopGoal.clear => 'No moves left with ${after.left} bubble${after.left == 1 ? '' : 's'} on the board: undo or restart',
        _ => 'No moves left, ${p.target - after.score} points short: undo or restart',
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
      pill(p.goal == PopGoal.target ? '${s.score} / ${p.target}' : '${s.score} pts', strong: p.goal == PopGoal.target && s.score >= p.target),
      if (p.goal == PopGoal.clear) pill('${s.left} left'),
      if (p.mode.refills) pill('+${p.reserve.length - s.used} cols'),
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
