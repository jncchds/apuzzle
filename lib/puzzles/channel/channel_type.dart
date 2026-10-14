import 'package:flutter/material.dart';

import '../../core/day.dart';
import '../../core/difficulty.dart';
import '../../core/game_controller.dart';
import '../../core/grid.dart';
import '../../core/puzzle_type.dart';
import '../../core/tutorial.dart';
import '../../l10n/l10n.dart';
import '../../ui/board/cell_grid_board.dart';
import '../pipes/pipe_tile.dart';
import 'channel_generator.dart';
import 'channel_model.dart';
import 'channel_solver.dart';
import 'channel_tutorial.dart';

/// Turn the tiles so that one pipe runs from the source to the drain; the
/// other tiles don't matter.
class ChannelType extends PuzzleType<ChannelPuzzle, PipesState> {
  const ChannelType();

  static const water = PipeTile.water;

  @override
  String get id => 'channel';
  @override
  String name(AppLocalizations l) => l.channelName;
  @override
  String tagline(AppLocalizations l) => l.channelTagline;
  @override
  IconData get icon => Icons.water_drop_rounded;
  @override
  Color get accent => const Color(0xFF5FC4D9);

  @override
  String rulesText(AppLocalizations l) => l.channelRules;

  @override
  List<TutorialStep> tutorial() => channelTutorial;
  @override
  List<TutorialStep> strategies() => channelStrategies;

  @override
  List<GridSize> get sizes => [for (var n = 5; n <= 10; n++) GridSize.square(n)];
  @override
  GridSize get defaultSize => const GridSize.square(7);
  @override
  GridSize dailySize(Difficulty difficulty) => switch (difficulty) {
    Difficulty.easy => const GridSize.square(6),
    Difficulty.medium => const GridSize.square(7),
    _ => const GridSize.square(8),
  };
  @override
  Day get dailySince => const Day(2026, 10, 15);
  @override
  bool get showSubmit => false;
  @override
  double get controlsHeight => 40;

  @override
  ChannelPuzzle generate(GenParams params) => generateChannel(params);

  @override
  PipesState initialState(ChannelPuzzle puzzle) => PipesState(List.of(puzzle.start));

  @override
  bool isComplete(ChannelPuzzle puzzle, PipesState state) => isSolved(puzzle, state);
  @override
  bool isSolved(ChannelPuzzle puzzle, PipesState state) => channelSolved(puzzle, channelMasks(puzzle, state));

  /// Open ends and tiles off the pipe are fine: nothing can be wrong.
  @override
  Set<Pos> conflicts(ChannelPuzzle puzzle, PipesState state) => const {};

  /// Turns the first tile from the source, along a pipe that needs the
  /// fewest tiles turned, that doesn't carry the water yet.
  @override
  HintResult<PipesState>? hint(ChannelPuzzle puzzle, PipesState state) {
    final turn = channelHintTurn(puzzle, state);
    if (turn == null) return null;
    final (i, t) = turn;
    return HintResult(PipesState(List.of(state.turns)..[i] = t), {puzzle.size.pos(i)});
  }

  void _rotate(GameController ctrl, Pos pos, int delta) {
    final p = ctrl.puzzle as ChannelPuzzle;
    final s = ctrl.state as PipesState;
    final i = p.size.index(pos);
    if (!p.turnable(i)) return;
    ctrl.apply(PipesState(List.of(s.turns)..[i] += delta));
  }

  @override
  Widget buildBoard(BuildContext context, GameController ctrl) {
    final p = ctrl.puzzle as ChannelPuzzle;
    final s = ctrl.state as PipesState;
    final flow = channelFlow(p, channelMasks(p, s));
    return CellGridBoard(
      rows: p.rows,
      cols: p.cols,
      gapRatio: 0.02,
      win: ctrl.winAnimation,
      onTap: ctrl.solved ? null : (pos) => _rotate(ctrl, pos, 1),
      onSecondary: ctrl.solved ? null : (pos) => _rotate(ctrl, pos, -1),
      cellBuilder: (context, pos, bm) {
        final i = p.size.index(pos);
        final bridge = p.isBridge(i);
        return PipeTile(
          bm: bm,
          mask: p.masks[i],
          turns: s.turns[i],
          lit: bridge ? flow[i] & flowEW != 0 : flow[i] != 0,
          crossLit: flow[i] & flowNS != 0,
          source: i == p.source,
          target: i == p.target,
          locked: p.locked[i] && i != p.source && i != p.target,
          bridge: bridge,
          flash: ctrl.flashHints.contains(pos),
        );
      },
    );
  }

  @override
  Map<String, dynamic> encodePuzzle(ChannelPuzzle puzzle) => puzzle.toJson();
  @override
  ChannelPuzzle decodePuzzle(Map<String, dynamic> json) => ChannelPuzzle.fromJson(json);
  @override
  Map<String, dynamic> encodeState(PipesState state) => state.toJson();
  @override
  PipesState decodeState(Map<String, dynamic> json) => PipesState.fromJson(json);
}
