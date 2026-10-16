import 'package:flutter/material.dart';

import '../../core/day.dart';
import '../../core/difficulty.dart';
import '../../core/explain.dart';
import '../../core/grid.dart';
import '../../core/puzzle_type.dart';
import '../../core/tutorial.dart';
import '../../core/value_grid.dart';
import '../../l10n/l10n.dart';
import '../../ui/board/cell_grid_board.dart';
import 'layers_explain.dart';
import 'layers_generator.dart';
import 'layers_model.dart';
import 'layers_solver.dart';
import 'layers_tutorial.dart';

/// Every row and column was painted once in its own color; the last stroke
/// over a cell shows. Finish the picture.
class LayersType extends ValueGridType<LayersPuzzle> {
  const LayersType();

  static const palette = [Color(0xFF4DA3FF), Color(0xFFE05A87), Color(0xFFFFC15E)];

  @override
  String get id => 'layers';
  @override
  String name(AppLocalizations l) => l.layersName;
  @override
  String tagline(AppLocalizations l) => l.layersTagline;
  @override
  IconData get icon => Icons.layers_rounded;
  @override
  Color get accent => const Color(0xFF4DA3FF);

  @override
  String rulesText(AppLocalizations l) => l.layersRules;

  @override
  List<TutorialStep> tutorial() => layersTutorial;
  @override
  List<TutorialStep> strategies() => layersStrategies;

  @override
  List<GridSize> get sizes => [for (var n = 5; n <= 10; n++) GridSize.square(n)];
  @override
  GridSize get defaultSize => const GridSize.square(6);
  @override
  GridSize dailySize(Difficulty difficulty) => switch (difficulty) {
    Difficulty.easy => const GridSize.square(6),
    Difficulty.medium => const GridSize.square(7),
    _ => const GridSize.square(8),
  };
  @override
  Day get dailySince => const Day(2026, 10, 18);

  @override
  InputMode get defaultInputMode => InputMode.palette;

  @override
  List<ValueSpec> get values => [
    for (var i = 0; i < palette.length; i++) ValueSpec.fill(palette[i], label: ['blue', 'pink', 'yellow'][i]),
  ];

  @override
  List<ValueSpec> valuesFor(LayersPuzzle puzzle) => values.take(puzzle.colors).toList();

  @override
  bool get showLockIcon => false;

  @override
  LayersPuzzle generate(GenParams params) => generateLayers(params);

  @override
  bool cellHidden(LayersPuzzle puzzle, Pos pos) => puzzle.isHole(puzzle.size.index(pos));

  @override
  Color? cellColor(BuildContext context, LayersPuzzle puzzle, Pos pos, CellValue cell) =>
      cell.value == null || cell.value! >= palette.length ? null : palette[cell.value!];

  // Shown cells carry a small dot, so they stand apart from painted ones.
  @override
  Widget buildValue(BuildContext context, LayersPuzzle puzzle, ValueGrid state, Pos pos, CellValue cell, double size) =>
      cell.given
      ? Container(
          width: size * 0.2,
          height: size * 0.2,
          decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.85), shape: BoxShape.circle),
        )
      : const SizedBox.shrink();

  @override
  bool isSolved(LayersPuzzle puzzle, ValueGrid state) {
    if (!state.isFull) return false;
    final values = state.toFlat();
    return layersConflicts(puzzle, values).isEmpty && LayersSolver(puzzle).valid(values);
  }

  @override
  Set<Pos> conflicts(LayersPuzzle puzzle, ValueGrid state) => {
    for (final i in layersConflicts(puzzle, state.toFlat())) puzzle.size.pos(i),
  };

  @override
  (double, double) header(LayersPuzzle puzzle) => (0.72, 0.72);

  /// A stroke chip at the start of each line: its color with an arrow into
  /// the board, or a question mark for a hidden color.
  @override
  List<Widget> buildOverlay(BuildContext context, LayersPuzzle puzzle, BoardMetrics m) {
    Widget chip(Rect r, int line, bool across) => Positioned.fromRect(
      rect: r,
      child: Center(
        child: _StrokeChip(
          color: puzzle.hidden.contains(line) ? null : palette[puzzle.lineColors[line]],
          across: across,
          size: m.cell,
        ),
      ),
    );
    return [
      for (var r = 0; r < puzzle.rows; r++) chip(Rect.fromLTWH(0, m.y(r), m.ox - m.gap, m.cell), r, true),
      for (var c = 0; c < puzzle.cols; c++)
        chip(Rect.fromLTWH(m.x(c), 0, m.cell, m.oy - m.gap), puzzle.rows + c, false),
    ];
  }

  @override
  bool get canExplain => true;

  @override
  Explanation? explain(LayersPuzzle puzzle, ValueGrid state) => explainStep(const LayersExplainer(), puzzle, state);

  @override
  Map<String, dynamic> encodePuzzle(LayersPuzzle puzzle) => puzzle.toJson();
  @override
  LayersPuzzle decodePuzzle(Map<String, dynamic> json) => LayersPuzzle.fromJson(json);
}

/// A line's color as a short stroke with an arrow pointing into the board;
/// [color] null for a hidden one (an outline with a question mark).
class _StrokeChip extends StatelessWidget {
  const _StrokeChip({required this.color, required this.across, required this.size});

  final Color? color;
  final bool across;
  final double size;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final long = size * 0.78, short = size * 0.5;
    final ink = color == null ? scheme.onSurface.withValues(alpha: 0.6) : Colors.black.withValues(alpha: 0.55);
    return Container(
      width: across ? short : long,
      height: across ? long : short,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(size * 0.16),
        border: color == null ? Border.all(color: scheme.outline, width: size * 0.04) : null,
      ),
      alignment: Alignment.center,
      child: color == null
          ? Text(
              '?',
              style: TextStyle(fontSize: size * 0.34, height: 1, fontWeight: FontWeight.w700, color: ink),
            )
          : Icon(
              across ? Icons.keyboard_arrow_right_rounded : Icons.keyboard_arrow_down_rounded,
              size: size * 0.42,
              color: ink,
            ),
    );
  }
}
