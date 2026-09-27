import 'package:flutter/material.dart';

import '../../core/day.dart';
import '../../core/difficulty.dart';
import '../../core/grid.dart';
import '../../core/puzzle_type.dart';
import '../../core/tutorial.dart';
import '../../core/value_grid.dart';
import '../../l10n/l10n.dart';
import '../../ui/board/cell_grid_board.dart';
import '../../ui/board/region_borders.dart';
import '../../ui/symbols.dart';
import 'plots_generator.dart';
import 'plots_model.dart';
import 'plots_tutorial.dart';

/// Fillomino: split the grid into plots whose cells show the plot's size.
class PlotsType extends ValueGridType<PlotsPuzzle> {
  const PlotsType();

  @override
  String get id => 'plots';
  @override
  String name(AppLocalizations l) => l.plotsName;
  @override
  String tagline(AppLocalizations l) => l.plotsTagline;
  @override
  IconData get icon => Icons.grass_rounded;
  @override
  Color get accent => const Color(0xFF8BC48A);

  @override
  String rulesText(AppLocalizations l) => l.plotsRules;

  @override
  List<TutorialStep> tutorial() => plotsTutorial;

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
  Day get dailySince => const Day(2026, 9, 28);

  @override
  InputMode get defaultInputMode => InputMode.palette;
  @override
  bool get supportsPencil => true;
  @override
  bool get highlightSameValue => true;
  @override
  bool get showLockIcon => false;
  @override
  double get gapRatio => 0.04;

  static const _all = [
    ValueSpec.text('1'), ValueSpec.text('2'), ValueSpec.text('3'), //
    ValueSpec.text('4'), ValueSpec.text('5'), ValueSpec.text('6'), //
    ValueSpec.text('7'), ValueSpec.text('8'), ValueSpec.text('9'),
  ];

  @override
  List<ValueSpec> get values => _all;

  @override
  List<ValueSpec> valuesFor(PlotsPuzzle puzzle) => _all.sublist(0, puzzle.maxValue);

  @override
  PlotsPuzzle generate(GenParams params) => generatePlots(params);

  @override
  bool isSolved(PlotsPuzzle puzzle, ValueGrid state) =>
      state.isFull && plotsConflicts(puzzle.rows, puzzle.cols, state.toFlat(), complete: true).isEmpty;

  @override
  Set<Pos> conflicts(PlotsPuzzle puzzle, ValueGrid state) => {
        for (final i in plotsConflicts(puzzle.rows, puzzle.cols, state.toFlat(), complete: state.isFull))
          puzzle.size.pos(i),
      };

  @override
  Color? cellColor(BuildContext context, PlotsPuzzle puzzle, Pos pos, CellValue cell) {
    final v = cell.value;
    if (v == null) return null;
    final base = regionColors[(v * 5) % regionColors.length];
    final surface = Theme.of(context).colorScheme.surface;
    return Color.lerp(base, surface, Theme.of(context).brightness == Brightness.dark ? 0.55 : 0.35);
  }

  @override
  Widget buildValue(BuildContext context, PlotsPuzzle puzzle, ValueGrid state, Pos pos, CellValue cell, double size) {
    final scheme = Theme.of(context).colorScheme;
    return Text(
      '${cell.value! + 1}',
      style: TextStyle(
        fontSize: size * 0.56,
        height: 1,
        fontWeight: cell.given ? FontWeight.w800 : FontWeight.w400,
        color: cell.given ? scheme.onSurface : scheme.onSurface.withValues(alpha: 0.75),
      ),
    );
  }

  /// Lines between filled cells with different numbers: the plots so far.
  @override
  List<Widget> buildOverlayIn(BuildContext context, PlotsPuzzle puzzle, ValueGrid state, BoardMetrics m) => [
        RegionBorders(
          metrics: m,
          split: (a, b) {
            final va = state.cells[a].value, vb = state.cells[b].value;
            return va != null && vb != null && va != vb;
          },
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ];

  @override
  Map<String, dynamic> encodePuzzle(PlotsPuzzle puzzle) => puzzle.toJson();
  @override
  PlotsPuzzle decodePuzzle(Map<String, dynamic> json) => PlotsPuzzle.fromJson(json);
}
