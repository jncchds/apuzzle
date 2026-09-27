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
import 'pairs_generator.dart';
import 'pairs_model.dart';
import 'pairs_tutorial.dart';

/// Norinori: two shaded cells per region, shaded cells in side-by-side pairs.
class PairsType extends ValueGridType<PairsPuzzle> {
  const PairsType();

  static const shadeColor = Color(0xFF3E6E8E);

  /// Region tints without the blues, so blue always means shaded.
  static final _regionColors = [
    for (final c in regionColors)
      if (c != const Color(0xFF90CAF9) && c != const Color(0xFF80DEEA) && c != const Color(0xFFB0BEC5)) c,
  ];

  @override
  String get id => 'pairs';
  @override
  String name(AppLocalizations l) => l.pairsName;
  @override
  String tagline(AppLocalizations l) => l.pairsTagline;
  @override
  IconData get icon => Icons.view_agenda_outlined;
  @override
  Color get accent => const Color(0xFF6FA3C7);

  @override
  String rulesText(AppLocalizations l) => l.pairsRules;

  @override
  List<TutorialStep> tutorial() => pairsTutorial;
  @override
  List<TutorialStep> strategies() => pairsStrategies;

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
  List<ValueSpec> get values => [
        ValueSpec.custom(
          (context, size) => Container(
            width: size * 0.78,
            height: size * 0.78,
            decoration: BoxDecoration(color: shadeColor, borderRadius: BorderRadius.circular(size * 0.14)),
          ),
          label: 'shade',
        ),
        ValueSpec.custom((context, size) => DotSymbol(size: size, color: Colors.black54), label: 'dot'),
      ];

  @override
  bool get showLockIcon => false;
  @override
  double get gapRatio => 0.05;

  @override
  PairsPuzzle generate(GenParams params) => generatePairs(params);

  List<bool> _shaded(ValueGrid s) => [for (final c in s.cells) c.value == pairsShade];

  @override
  bool isComplete(PairsPuzzle puzzle, ValueGrid state) =>
      _shaded(state).where((x) => x).length == 2 * puzzle.regionCount;

  @override
  bool isSolved(PairsPuzzle puzzle, ValueGrid state) =>
      isComplete(puzzle, state) && pairsConflicts(puzzle.n, puzzle.regions, _shaded(state), complete: true).isEmpty;

  @override
  Set<Pos> conflicts(PairsPuzzle puzzle, ValueGrid state) => {
        for (final i in pairsConflicts(puzzle.n, puzzle.regions, _shaded(state), complete: isComplete(puzzle, state)))
          puzzle.size.pos(i),
      };

  @override
  HintResult<ValueGrid>? hint(PairsPuzzle puzzle, ValueGrid state) {
    HintResult<ValueGrid> put(int i, int v) {
      final p = puzzle.size.pos(i);
      return HintResult(state.set(p, state.cells[i].withValue(v)), {p});
    }

    // Wrong marks first, then a missing shaded cell, then the dots.
    for (var i = 0; i < state.cells.length; i++) {
      final v = state.cells[i].value;
      if (v != null && v != puzzle.solutionAt(i)) return put(i, puzzle.solutionAt(i));
    }
    for (var i = 0; i < state.cells.length; i++) {
      if (puzzle.shaded[i] && state.cells[i].value == null) return put(i, pairsShade);
    }
    for (var i = 0; i < state.cells.length; i++) {
      if (state.cells[i].value == null) return put(i, pairsDot);
    }
    return null;
  }

  @override
  Widget buildValue(BuildContext context, PairsPuzzle puzzle, ValueGrid state, Pos pos, CellValue cell, double size) =>
      cell.value == pairsShade ? const SizedBox.shrink() : super.buildValue(context, puzzle, state, pos, cell, size);

  @override
  Color? cellColor(BuildContext context, PairsPuzzle puzzle, Pos pos, CellValue cell) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    if (cell.value == pairsShade) return dark ? const Color(0xFF7FB2D6) : shadeColor;
    final base = _regionColors[puzzle.regions[puzzle.size.index(pos)] % _regionColors.length];
    return Color.lerp(base, Theme.of(context).colorScheme.surface, dark ? 0.7 : 0.55);
  }

  @override
  List<Widget> buildOverlay(BuildContext context, PairsPuzzle puzzle, BoardMetrics m) => [
        RegionBorders(metrics: m, regionOf: (i) => puzzle.regions[i], color: Theme.of(context).colorScheme.onSurface),
      ];

  @override
  Map<String, dynamic> encodePuzzle(PairsPuzzle puzzle) => puzzle.toJson();
  @override
  PairsPuzzle decodePuzzle(Map<String, dynamic> json) => PairsPuzzle.fromJson(json);
}
