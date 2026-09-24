import 'dart:math';

import 'package:flutter/material.dart';

import '../../core/difficulty.dart';
import '../../core/game_controller.dart';
import '../../core/grid.dart';
import '../../core/puzzle_type.dart';
import '../../ui/board/cell_grid_board.dart';
import '../../ui/board/region_borders.dart';
import 'mosaic_model.dart';

/// Flood-fill from the top-left corner within a move limit.
class MosaicType extends PuzzleType<MosaicPuzzle, MosaicState> {
  const MosaicType();

  static const palette = [
    Color(0xFFE0605A), Color(0xFF6FE8C4), Color(0xFF5B8DEF), Color(0xFFFFC15E), Color(0xFFB57EDC), Color(0xFFF28DB2),
  ];

  @override
  String get id => 'mosaic';
  @override
  String get name => 'Mosaic';
  @override
  String get tagline => 'Flood the board with one color';
  @override
  IconData get icon => Icons.format_color_fill_rounded;
  @override
  Color get accent => const Color(0xFF6FE8C4);

  @override
  String get rulesText => '''
• The colored area in the top-left corner is yours.
• Pick a color: your area takes that color and absorbs every touching cell of the same color.
• Paint the whole board in one color within the move limit.

Tap a palette color, or tap any cell to use its color.''';

  @override
  List<GridSize> get sizes => [for (final n in [6, 8, 10, 12, 14, 16, 18]) GridSize.square(n)];
  @override
  GridSize get defaultSize => const GridSize.square(12);
  @override
  double get minCellSize => 20;
  @override
  double get controlsHeight => 120;
  @override
  bool get showSubmit => false;

  int colorsFor(Difficulty d) => switch (d) {
        Difficulty.easy => 4,
        Difficulty.medium => 5,
        _ => 6,
      };

  @override
  MosaicPuzzle generate(GenParams params) {
    final rows = params.size.rows, cols = params.size.cols;
    final rng = Random(params.seed);
    final k = colorsFor(params.difficulty);
    final start = List.generate(rows * cols, (_) => rng.nextInt(k));
    final plan = floodSolve(start, rows, cols, k);
    final slack = switch (params.difficulty) {
      Difficulty.easy => 5,
      Difficulty.medium => 2,
      _ => 0,
    };
    return MosaicPuzzle(rows: rows, cols: cols, colors: k, start: start, limit: plan.length + slack, plan: plan);
  }

  @override
  MosaicState initialState(MosaicPuzzle puzzle) => MosaicState(puzzle.start, 0);
  @override
  bool isComplete(MosaicPuzzle puzzle, MosaicState state) => floodDone(state.cells);
  @override
  bool isSolved(MosaicPuzzle puzzle, MosaicState state) => floodDone(state.cells) && state.moves <= puzzle.limit;
  @override
  Set<Pos> conflicts(MosaicPuzzle puzzle, MosaicState state) => const {};

  @override
  HintResult<MosaicState>? hint(MosaicPuzzle puzzle, MosaicState state) {
    if (floodDone(state.cells)) return null;
    final best = floodSolve(state.cells, puzzle.rows, puzzle.cols, puzzle.colors).first;
    final next = MosaicState(floodApply(state.cells, puzzle.rows, puzzle.cols, best), state.moves + 1);
    return HintResult(next, {const Pos(0, 0)});
  }

  void _play(GameController ctrl, int color) {
    final p = ctrl.puzzle as MosaicPuzzle;
    final s = ctrl.state as MosaicState;
    if (s.cells[0] == color || floodDone(s.cells)) return;
    if (s.moves >= p.limit) {
      ctrl.showToast('Out of moves: undo or restart');
      return;
    }
    ctrl.apply(MosaicState(floodApply(s.cells, p.rows, p.cols, color), s.moves + 1));
    final after = ctrl.state as MosaicState;
    if (!floodDone(after.cells) && after.moves >= p.limit) ctrl.showToast('Out of moves: undo or restart');
  }

  @override
  Widget buildBoard(BuildContext context, GameController ctrl) {
    final p = ctrl.puzzle as MosaicPuzzle;
    final s = ctrl.state as MosaicState;
    final region = floodRegion(s.cells, p.rows, p.cols);
    return CellGridBoard(
      rows: p.rows,
      cols: p.cols,
      gapRatio: 0,
      maxCell: 64,
      win: ctrl.winAnimation,
      onTap: ctrl.solved ? null : (pos) => _play(ctrl, s.cells[p.size.index(pos)]),
      overlayBuilder: (context, m) => [
        RegionBorders(
          metrics: m,
          regionOf: (i) => region.containsKey(i) ? 1 : 0,
          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.9),
        ),
      ],
      cellBuilder: (context, pos, m) {
        final i = p.size.index(pos);
        final d = region[i] ?? 0;
        return AnimatedContainer(
          duration: Duration(milliseconds: 120 + min(d, 40) * 22),
          curve: Curves.easeInCubic,
          decoration: BoxDecoration(
            color: palette[s.cells[i]],
            border: Border.all(color: Colors.black.withValues(alpha: 0.12), width: 0.5),
          ),
        );
      },
    );
  }

  @override
  Widget? buildControls(BuildContext context, GameController ctrl) {
    final p = ctrl.puzzle as MosaicPuzzle;
    final s = ctrl.state as MosaicState;
    final theme = Theme.of(context);
    final left = p.limit - s.moves;
    return Column(mainAxisSize: MainAxisSize.min, children: [
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: left <= 0 ? theme.colorScheme.error : theme.colorScheme.outline, width: 2),
        ),
        child: Text('${s.moves} / ${p.limit} moves',
            style: theme.textTheme.titleMedium?.copyWith(fontFeatures: const [FontFeature.tabularFigures()])),
      ),
      const SizedBox(height: 10),
      Wrap(spacing: 10, runSpacing: 10, alignment: WrapAlignment.center, children: [
        for (var c = 0; c < p.colors; c++)
          GestureDetector(
            onTap: () => _play(ctrl, c),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 160),
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: palette[c],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: s.cells[0] == c ? theme.colorScheme.onSurface : Colors.transparent,
                  width: 3,
                ),
              ),
            ),
          ),
      ]),
    ]);
  }

  @override
  Map<String, dynamic> encodePuzzle(MosaicPuzzle puzzle) => puzzle.toJson();
  @override
  MosaicPuzzle decodePuzzle(Map<String, dynamic> json) => MosaicPuzzle.fromJson(json);
  @override
  Map<String, dynamic> encodeState(MosaicState state) => state.toJson();
  @override
  MosaicState decodeState(Map<String, dynamic> json) => MosaicState.fromJson(json);
}
