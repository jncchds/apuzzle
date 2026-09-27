import 'package:flutter/material.dart';

import '../../core/day.dart';
import '../../core/difficulty.dart';
import '../../core/grid.dart';
import '../../core/grid_graph.dart';
import '../../core/puzzle_type.dart';
import '../../core/tutorial.dart';
import '../../core/value_grid.dart';
import '../../l10n/l10n.dart';
import '../../ui/board/cell_grid_board.dart';
import '../../ui/board/region_borders.dart';
import 'blocks_generator.dart';
import 'blocks_model.dart';
import 'blocks_tutorial.dart';

/// Suguru: numbers 1..k in every region of k cells, equal numbers never touch.
class BlocksType extends ValueGridType<BlocksPuzzle> {
  const BlocksType();

  @override
  String get id => 'blocks';
  @override
  String name(AppLocalizations l) => l.blocksName;
  @override
  String tagline(AppLocalizations l) => l.blocksTagline;
  @override
  IconData get icon => Icons.dashboard_outlined;
  @override
  Color get accent => const Color(0xFFE0A458);

  @override
  String rulesText(AppLocalizations l) => l.blocksRules;

  @override
  List<TutorialStep> tutorial() => blocksTutorial;

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
    ValueSpec.text('4'), ValueSpec.text('5'), ValueSpec.text('6'),
  ];

  @override
  List<ValueSpec> get values => _all;

  @override
  List<ValueSpec> valuesFor(BlocksPuzzle puzzle) => _all.sublist(0, puzzle.maxRegion);

  @override
  Iterable<Pos> markPeers(BlocksPuzzle puzzle, Pos pos) {
    final i = puzzle.size.index(pos);
    return {
      for (final j in kingNeighbors(puzzle.rows, puzzle.cols)[i]) j,
      for (var j = 0; j < puzzle.regions.length; j++)
        if (j != i && puzzle.regions[j] == puzzle.regions[i]) j,
    }.map(puzzle.size.pos);
  }

  @override
  BlocksPuzzle generate(GenParams params) => generateBlocks(params);

  @override
  bool isSolved(BlocksPuzzle puzzle, ValueGrid state) =>
      state.isFull && blocksConflicts(puzzle.rows, puzzle.cols, puzzle.regions, state.toFlat()).isEmpty;

  @override
  Set<Pos> conflicts(BlocksPuzzle puzzle, ValueGrid state) =>
      {for (final i in blocksConflicts(puzzle.rows, puzzle.cols, puzzle.regions, state.toFlat())) puzzle.size.pos(i)};

  @override
  Widget buildValue(BuildContext context, BlocksPuzzle puzzle, ValueGrid state, Pos pos, CellValue cell, double size) {
    final scheme = Theme.of(context).colorScheme;
    final dark = Theme.of(context).brightness == Brightness.dark;
    return Text(
      '${cell.value! + 1}',
      style: TextStyle(
        fontSize: size * 0.58,
        height: 1,
        fontWeight: cell.given ? FontWeight.w800 : FontWeight.w500,
        color: cell.given ? scheme.onSurface : (dark ? const Color(0xFFF2C38B) : const Color(0xFFB0661A)),
      ),
    );
  }

  @override
  List<Widget> buildOverlay(BuildContext context, BlocksPuzzle puzzle, BoardMetrics m) => [
        RegionBorders(metrics: m, regionOf: (i) => puzzle.regions[i], color: Theme.of(context).colorScheme.onSurface),
      ];

  @override
  Map<String, dynamic> encodePuzzle(BlocksPuzzle puzzle) => puzzle.toJson();
  @override
  BlocksPuzzle decodePuzzle(Map<String, dynamic> json) => BlocksPuzzle.fromJson(json);
}
