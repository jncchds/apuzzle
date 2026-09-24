import 'dart:math';

import 'package:flutter/material.dart';

import '../../core/difficulty.dart';
import '../../core/game_controller.dart';
import '../../core/grid.dart';
import '../../core/puzzle_type.dart';
import '../../ui/board/cell_grid_board.dart';
import '../../ui/board/region_borders.dart';
import '../mosaic/mosaic_type.dart';
import 'blend_model.dart';

/// Free flood: repaint any patch; touching patches of that color merge.
class BlendType extends PuzzleType<BlendPuzzle, BlendState> {
  const BlendType();

  static const palette = MosaicType.palette;

  @override
  String get id => 'blend';
  @override
  String get name => 'Blend';
  @override
  String get tagline => 'Repaint any patch until one color remains';
  @override
  IconData get icon => Icons.format_paint_rounded;
  @override
  Color get accent => const Color(0xFFB57EDC);

  @override
  String get rulesText => '''
• The board is made of colored patches (touching cells of the same color).
• Pick a color, then tap any patch to repaint it. It merges with every touching patch of that color.
• Make the whole board one color within the move limit.

The palette color stays selected, so you can paint several patches in a row.''';

  @override
  List<GridSize> get sizes => [for (final n in [5, 6, 8, 10, 12, 14]) GridSize.square(n)];
  @override
  GridSize get defaultSize => const GridSize.square(8);
  @override
  double get minCellSize => 24;
  @override
  double get controlsHeight => 120;
  @override
  bool get showSubmit => false;

  int colorsFor(Difficulty d) => switch (d) {
        Difficulty.easy => 3,
        Difficulty.medium => 4,
        _ => 5,
      };

  @override
  BlendPuzzle generate(GenParams params) {
    final rows = params.size.rows, cols = params.size.cols;
    final rng = Random(params.seed);
    final k = colorsFor(params.difficulty);
    final start = List.generate(rows * cols, (_) => rng.nextInt(k));
    // Best of a few greedy runs gives a tighter (but always achievable) limit.
    List<BlendMove>? plan;
    for (var t = 0; t < 4; t++) {
      final p = blendSolve(start, rows, cols, k, rng);
      if (plan == null || p.length < plan.length) plan = p;
    }
    final slack = switch (params.difficulty) {
      Difficulty.easy => 4,
      Difficulty.medium => 2,
      _ => 0,
    };
    return BlendPuzzle(rows: rows, cols: cols, colors: k, start: start, limit: plan!.length + slack, plan: plan);
  }

  @override
  BlendState initialState(BlendPuzzle puzzle) => BlendState(puzzle.start, 0);
  @override
  bool isComplete(BlendPuzzle puzzle, BlendState state) => blendDone(state.cells);
  @override
  bool isSolved(BlendPuzzle puzzle, BlendState state) => blendDone(state.cells) && state.moves <= puzzle.limit;
  @override
  Set<Pos> conflicts(BlendPuzzle puzzle, BlendState state) => const {};

  @override
  HintResult<BlendState>? hint(BlendPuzzle puzzle, BlendState state) {
    if (blendDone(state.cells)) return null;
    final (cell, color) = blendSolve(state.cells, puzzle.rows, puzzle.cols, puzzle.colors, Random(state.moves)).first;
    final comp = blendComponents(state.cells, puzzle.rows, puzzle.cols);
    final patch = {for (var i = 0; i < comp.length; i++) if (comp[i] == comp[cell]) puzzle.size.pos(i)};
    return HintResult(BlendState(blendApply(state.cells, puzzle.rows, puzzle.cols, cell, color), state.moves + 1), patch);
  }

  int _color(GameController ctrl) => (ctrl.tool == null || ctrl.tool! < 0) ? 0 : ctrl.tool!;

  void _paint(GameController ctrl, Pos pos) {
    final p = ctrl.puzzle as BlendPuzzle;
    final s = ctrl.state as BlendState;
    final i = p.size.index(pos);
    final color = _color(ctrl);
    if (s.cells[i] == color || blendDone(s.cells)) return;
    if (s.moves >= p.limit) {
      ctrl.showToast('Out of moves: undo or restart');
      return;
    }
    ctrl.apply(BlendState(blendApply(s.cells, p.rows, p.cols, i, color), s.moves + 1));
    final after = ctrl.state as BlendState;
    if (!blendDone(after.cells) && after.moves >= p.limit) ctrl.showToast('Out of moves: undo or restart');
  }

  @override
  Widget buildBoard(BuildContext context, GameController ctrl) {
    final p = ctrl.puzzle as BlendPuzzle;
    final s = ctrl.state as BlendState;
    final comp = blendComponents(s.cells, p.rows, p.cols);
    final scheme = Theme.of(context).colorScheme;
    return CellGridBoard(
      rows: p.rows,
      cols: p.cols,
      gapRatio: 0,
      maxCell: 64,
      win: ctrl.winAnimation,
      onTap: ctrl.solved ? null : (pos) => _paint(ctrl, pos),
      overlayBuilder: (context, m) => [
        RegionBorders(metrics: m, regionOf: (i) => comp[i], color: scheme.surface.withValues(alpha: 0.85)),
      ],
      cellBuilder: (context, pos, m) {
        final i = p.size.index(pos);
        final hinted = ctrl.flashHints.contains(pos);
        return AnimatedContainer(
          duration: const Duration(milliseconds: 260),
          curve: Curves.easeOut,
          decoration: BoxDecoration(
            color: palette[s.cells[i]],
            border: hinted ? Border.all(color: scheme.onSurface, width: 2) : null,
          ),
        );
      },
    );
  }

  @override
  Widget? buildControls(BuildContext context, GameController ctrl) {
    final p = ctrl.puzzle as BlendPuzzle;
    final s = ctrl.state as BlendState;
    final theme = Theme.of(context);
    final selected = _color(ctrl);
    return Column(mainAxisSize: MainAxisSize.min, children: [
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: s.moves >= p.limit ? theme.colorScheme.error : theme.colorScheme.outline, width: 2),
        ),
        child: Text('${s.moves} / ${p.limit} moves',
            style: theme.textTheme.titleMedium?.copyWith(fontFeatures: const [FontFeature.tabularFigures()])),
      ),
      const SizedBox(height: 10),
      Wrap(spacing: 10, runSpacing: 10, alignment: WrapAlignment.center, children: [
        for (var c = 0; c < p.colors; c++)
          GestureDetector(
            onTap: () => ctrl.setTool(c),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 160),
              width: 48,
              height: 48,
              transform: Matrix4.diagonal3Values(selected == c ? 1.12 : 1, selected == c ? 1.12 : 1, 1),
              transformAlignment: Alignment.center,
              decoration: BoxDecoration(
                color: palette[c],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: selected == c ? theme.colorScheme.onSurface : Colors.transparent, width: 3),
              ),
            ),
          ),
      ]),
    ]);
  }

  @override
  Map<String, dynamic> encodePuzzle(BlendPuzzle puzzle) => puzzle.toJson();
  @override
  BlendPuzzle decodePuzzle(Map<String, dynamic> json) => BlendPuzzle.fromJson(json);
  @override
  Map<String, dynamic> encodeState(BlendState state) => state.toJson();
  @override
  BlendState decodeState(Map<String, dynamic> json) => BlendState.fromJson(json);
}
