import 'package:flutter/material.dart';

import '../../core/day.dart';
import '../../core/difficulty.dart';
import '../../core/explain.dart';
import '../../core/grid.dart';
import '../../core/grid_graph.dart';
import '../../core/puzzle_type.dart';
import '../../core/tutorial.dart';
import '../../core/value_grid.dart';
import '../../l10n/l10n.dart';
import '../../ui/board/cell_grid_board.dart';
import '../../ui/board/region_borders.dart';
import 'ripples_explain.dart';
import 'ripples_generator.dart';
import 'ripples_model.dart';
import 'ripples_tutorial.dart';

/// Echoes: numbers 1..k in every region of k cells, and two equal numbers d
/// in a row or column have at least d cells between them.
class RipplesType extends ValueGridType<RipplesPuzzle> {
  const RipplesType();

  @override
  String get id => 'ripples';
  @override
  String name(AppLocalizations l) => l.ripplesName;
  @override
  String tagline(AppLocalizations l) => l.ripplesTagline;
  @override
  IconData get icon => Icons.waves;
  @override
  Color get accent => const Color(0xFF4FA3C7);

  @override
  String rulesText(AppLocalizations l) => l.ripplesRules;

  @override
  List<TutorialStep> tutorial() => ripplesTutorial;
  @override
  List<TutorialStep> strategies() => ripplesStrategies;

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
  Day get dailySince => const Day(2026, 11, 12);

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
  List<ValueSpec> valuesFor(RipplesPuzzle puzzle) => _all.sublist(0, puzzle.maxRegion);

  /// The region and the side neighbours (equal numbers never sit side by
  /// side); further cells in the line depend on the number.
  @override
  Iterable<Pos> markPeers(RipplesPuzzle puzzle, Pos pos) {
    final i = puzzle.size.index(pos);
    return {
      for (final j in orthNeighbors(puzzle.rows, puzzle.cols)[i]) j,
      for (var j = 0; j < puzzle.regions.length; j++)
        if (j != i && puzzle.regions[j] == puzzle.regions[i]) j,
    }.map(puzzle.size.pos);
  }

  @override
  RipplesPuzzle generate(GenParams params) => generateRipples(params);

  @override
  bool isSolved(RipplesPuzzle puzzle, ValueGrid state) =>
      state.isFull && ripplesConflicts(puzzle.rows, puzzle.cols, puzzle.regions, state.toFlat()).isEmpty;

  @override
  Set<Pos> conflicts(RipplesPuzzle puzzle, ValueGrid state) => {
    for (final i in ripplesConflicts(puzzle.rows, puzzle.cols, puzzle.regions, state.toFlat())) puzzle.size.pos(i),
  };

  @override
  Widget buildValue(BuildContext context, RipplesPuzzle puzzle, ValueGrid state, Pos pos, CellValue cell, double size) {
    final scheme = Theme.of(context).colorScheme;
    final dark = Theme.of(context).brightness == Brightness.dark;
    return Text(
      '${cell.value! + 1}',
      style: TextStyle(
        fontSize: size * 0.58,
        height: 1,
        fontWeight: cell.given ? FontWeight.w800 : FontWeight.w500,
        color: cell.given ? scheme.onSurface : (dark ? const Color(0xFF8FD0EC) : const Color(0xFF1F6F94)),
      ),
    );
  }

  @override
  List<Widget> buildOverlay(BuildContext context, RipplesPuzzle puzzle, BoardMetrics m) => [
    RegionBorders(metrics: m, regionOf: (i) => puzzle.regions[i], color: Theme.of(context).colorScheme.onSurface),
  ];

  @override
  bool get canExplain => true;

  @override
  Explanation? explain(RipplesPuzzle puzzle, ValueGrid state) => explainStep(const RipplesExplainer(), puzzle, state);

  @override
  Map<String, dynamic> encodePuzzle(RipplesPuzzle puzzle) => puzzle.toJson();
  @override
  RipplesPuzzle decodePuzzle(Map<String, dynamic> json) => RipplesPuzzle.fromJson(json);
}
