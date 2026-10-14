import 'package:flutter/material.dart';

import '../../core/difficulty.dart';
import '../../core/game_controller.dart';
import '../../core/grid.dart';
import '../../core/puzzle_type.dart';
import '../../core/tutorial.dart';
import '../../l10n/l10n.dart';
import '../../ui/board/cell_grid_board.dart';
import 'pipe_tile.dart';
import 'pipes_generator.dart';
import 'pipes_model.dart';
import 'pipes_tutorial.dart';

/// Rotate tiles so every pipe connects back to the source.
class PipesType extends PuzzleType<PipesPuzzle, PipesState> {
  const PipesType();

  static const water = PipeTile.water;

  @override
  String get id => 'pipes';
  @override
  String name(AppLocalizations l) => l.pipesName;
  @override
  String tagline(AppLocalizations l) => l.pipesTagline;
  @override
  IconData get icon => Icons.plumbing_rounded;
  @override
  Color get accent => water;

  @override
  String rulesText(AppLocalizations l) => l.pipesRules;

  @override
  List<TutorialStep> tutorial() => pipesTutorial;
  @override
  List<TutorialStep> strategies() => pipesStrategies;

  @override
  List<GridSize> get sizes => [for (var n = 4; n <= 11; n++) GridSize.square(n)];
  @override
  GridSize get defaultSize => const GridSize.square(6);
  @override
  GridSize dailySize(Difficulty difficulty) => switch (difficulty) {
    Difficulty.easy => const GridSize.square(5),
    Difficulty.medium => const GridSize.square(7),
    _ => const GridSize.square(9),
  };
  @override
  bool get showSubmit => false;
  @override
  double get controlsHeight => 40;

  @override
  PipesPuzzle generate(GenParams params) => generatePipes(params);

  @override
  PipesState initialState(PipesPuzzle puzzle) => PipesState(List.of(puzzle.start));

  @override
  bool isComplete(PipesPuzzle puzzle, PipesState state) => isSolved(puzzle, state);
  @override
  bool isSolved(PipesPuzzle puzzle, PipesState state) => pipesSolved(puzzle, currentMasks(puzzle, state));

  @override
  Set<Pos> conflicts(PipesPuzzle puzzle, PipesState state) => {
    for (final i in looseTiles(puzzle, currentMasks(puzzle, state))) puzzle.size.pos(i),
  };

  @override
  HintResult<PipesState>? hint(PipesPuzzle puzzle, PipesState state) {
    final m = currentMasks(puzzle, state);
    for (var i = 0; i < m.length; i++) {
      if (puzzle.locked[i] || m[i] == puzzle.masks[i]) continue;
      final turns = List.of(state.turns);
      var k = 0;
      while (rotateMask(puzzle.masks[i], turns[i]) != puzzle.masks[i] && k++ < 4) {
        turns[i]++;
      }
      return HintResult(PipesState(turns), {puzzle.size.pos(i)});
    }
    return null;
  }

  void _rotate(GameController ctrl, Pos pos, int delta) {
    final p = ctrl.puzzle as PipesPuzzle;
    final s = ctrl.state as PipesState;
    final i = p.size.index(pos);
    if (p.locked[i]) return;
    final turns = List.of(s.turns)..[i] += delta;
    ctrl.apply(PipesState(turns));
  }

  @override
  Widget buildBoard(BuildContext context, GameController ctrl) {
    final p = ctrl.puzzle as PipesPuzzle;
    final s = ctrl.state as PipesState;
    final m = currentMasks(p, s);
    final lit = litTiles(p, m);
    final errors = ctrl.errorCells;
    return CellGridBoard(
      rows: p.rows,
      cols: p.cols,
      gapRatio: 0.02,
      win: ctrl.winAnimation,
      onTap: ctrl.solved ? null : (pos) => _rotate(ctrl, pos, 1),
      onSecondary: ctrl.solved ? null : (pos) => _rotate(ctrl, pos, -1),
      cellBuilder: (context, pos, bm) {
        final i = p.size.index(pos);
        return PipeTile(
          bm: bm,
          mask: p.masks[i],
          turns: s.turns[i],
          lit: lit.contains(i),
          source: i == p.source,
          locked: p.locked[i],
          error: errors.contains(pos),
          flash: ctrl.flashHints.contains(pos),
        );
      },
    );
  }

  @override
  Map<String, dynamic> encodePuzzle(PipesPuzzle puzzle) => puzzle.toJson();
  @override
  PipesPuzzle decodePuzzle(Map<String, dynamic> json) => PipesPuzzle.fromJson(json);
  @override
  Map<String, dynamic> encodeState(PipesState state) => state.toJson();
  @override
  PipesState decodeState(Map<String, dynamic> json) => PipesState.fromJson(json);
}
