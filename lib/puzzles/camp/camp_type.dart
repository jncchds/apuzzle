import 'package:flutter/material.dart';

import '../../core/difficulty.dart';
import '../../core/grid.dart';
import '../../core/puzzle_type.dart';
import '../../core/tutorial.dart';
import '../../core/value_grid.dart';
import '../../l10n/l10n.dart';
import '../../ui/board/cell_grid_board.dart';
import '../../ui/symbols.dart';
import 'camp_generator.dart';
import 'camp_model.dart';
import 'camp_tutorial.dart';

/// Tents: pitch one tent next to every tree.
class CampType extends ValueGridType<CampPuzzle> {
  const CampType();

  static const tentColor = Color(0xFFE8894A);
  static const treeColor = Color(0xFF4E9A5B);
  static const grassColor = Color(0xFFB9DDA0);

  @override
  String get id => 'camp';
  @override
  String name(AppLocalizations l) => l.campName;
  @override
  String tagline(AppLocalizations l) => l.campTagline;
  @override
  IconData get icon => Icons.holiday_village_outlined;
  @override
  Color get accent => tentColor;

  @override
  String rulesText(AppLocalizations l) => l.campRules;

  @override
  List<TutorialStep> tutorial() => campTutorial;

  @override
  List<GridSize> get sizes => [for (var n = 5; n <= 10; n++) GridSize.square(n)];
  @override
  GridSize get defaultSize => const GridSize.square(7);
  @override
  GridSize dailySize(Difficulty difficulty) => switch (difficulty) {
        Difficulty.easy => const GridSize.square(6),
        Difficulty.medium => const GridSize.square(8),
        _ => const GridSize.square(9),
      };
  @override
  double get minCellSize => 32;

  @override
  List<ValueSpec> get values => [
        ValueSpec.custom((context, size) => DotSymbol(size: size, color: const Color(0xFF5E8C4A)), label: 'grass'),
        ValueSpec.custom((context, size) => TentSymbol(size: size * 0.86, color: tentColor), label: 'tent'),
        ValueSpec.custom((context, size) => Icon(Icons.park_rounded, size: size * 0.78, color: treeColor), label: 'tree'),
      ];

  @override
  List<ValueSpec> valuesFor(CampPuzzle puzzle) => values.sublist(0, 2);

  @override
  bool get showLockIcon => false;
  @override
  double get gapRatio => 0.06;

  @override
  CampPuzzle generate(GenParams params) => generateCamp(params);

  List<bool> _tents(ValueGrid s) => [for (final c in s.cells) c.value == campTent];

  @override
  bool isComplete(CampPuzzle puzzle, ValueGrid state) => _tents(state).where((t) => t).length == puzzle.treeCount;

  @override
  bool isSolved(CampPuzzle puzzle, ValueGrid state) =>
      isComplete(puzzle, state) && campConflicts(puzzle, _tents(state), complete: true).isEmpty;

  @override
  Set<Pos> conflicts(CampPuzzle puzzle, ValueGrid state) => {
        for (final i in campConflicts(puzzle, _tents(state), complete: isComplete(puzzle, state))) puzzle.size.pos(i),
      };

  @override
  HintResult<ValueGrid>? hint(CampPuzzle puzzle, ValueGrid state) {
    HintResult<ValueGrid> put(int i, int v) {
      final p = puzzle.size.pos(i);
      return HintResult(state.set(p, state.cells[i].withValue(v)), {p});
    }

    for (var i = 0; i < state.cells.length; i++) {
      if (state.cells[i].value == campTent && !puzzle.tents[i]) return put(i, campGrass);
    }
    for (var i = 0; i < state.cells.length; i++) {
      if (puzzle.tents[i] && state.cells[i].value != campTent) return put(i, campTent);
    }
    return null;
  }

  @override
  Color? cellColor(BuildContext context, CampPuzzle puzzle, Pos pos, CellValue cell) {
    if (cell.value == null || cell.value == campTent) return null;
    final dark = Theme.of(context).brightness == Brightness.dark;
    final base = cell.value == campTree ? const Color(0xFFD5EBC8) : grassColor;
    return dark ? Color.lerp(base, Colors.black, cell.value == campTree ? 0.55 : 0.62) : base;
  }

  @override
  (double, double) header(CampPuzzle puzzle) => (0.72, 0.72);

  @override
  List<Widget> buildOverlayIn(BuildContext context, CampPuzzle puzzle, ValueGrid state, BoardMetrics m) {
    final theme = Theme.of(context);
    final on = theme.colorScheme.onSurface;
    Widget label(Rect r, int? want, int have) {
      final done = want != null && have == want;
      return Positioned.fromRect(
        rect: r,
        child: Center(
          child: AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 200),
            style: theme.textTheme.bodyLarge!.copyWith(
              fontSize: m.cell * 0.4,
              fontWeight: FontWeight.w700,
              color: on.withValues(alpha: done ? 0.3 : 0.85),
            ),
            child: Text(want == null ? '' : '$want'),
          ),
        ),
      );
    }

    int count(Iterable<int> cells) => cells.where((i) => state.cells[i].value == campTent).length;
    return [
      for (var r = 0; r < puzzle.rows; r++)
        label(Rect.fromLTWH(0, m.y(r), m.ox - m.gap, m.cell), puzzle.rowCounts[r],
            count([for (var c = 0; c < puzzle.cols; c++) r * puzzle.cols + c])),
      for (var c = 0; c < puzzle.cols; c++)
        label(Rect.fromLTWH(m.x(c), 0, m.cell, m.oy - m.gap), puzzle.colCounts[c],
            count([for (var r = 0; r < puzzle.rows; r++) r * puzzle.cols + c])),
    ];
  }

  @override
  Map<String, dynamic> encodePuzzle(CampPuzzle puzzle) => puzzle.toJson();
  @override
  CampPuzzle decodePuzzle(Map<String, dynamic> json) => CampPuzzle.fromJson(json);
}
