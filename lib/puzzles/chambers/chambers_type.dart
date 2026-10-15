import 'dart:math';

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
import '../../ui/symbols.dart';
import 'chambers_explain.dart';
import 'chambers_generator.dart';
import 'chambers_model.dart';
import 'chambers_tutorial.dart';

/// Chambers: shade cells in a grid of rooms to match the rooms' numbers.
class ChambersType extends ValueGridType<ChambersPuzzle> {
  const ChambersType();

  static const shadeLight = Color(0xFF4A3B33);
  static const shadeDark = Color(0xFF8A6A58);

  static Color shadeColor(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? shadeDark : shadeLight;

  @override
  String get id => 'chambers';
  @override
  String name(AppLocalizations l) => l.chambersName;
  @override
  String tagline(AppLocalizations l) => l.chambersTagline;
  @override
  IconData get icon => Icons.meeting_room_rounded;
  @override
  Color get accent => const Color(0xFFC98B62);

  @override
  String rulesText(AppLocalizations l) => l.chambersRules;

  @override
  List<TutorialStep> tutorial() => chambersTutorial;
  @override
  List<TutorialStep> strategies() => chambersStrategies;

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
  Day get dailySince => const Day(2026, 10, 16);
  @override
  double get minCellSize => 32;

  @override
  List<ValueSpec> get values => [
    ValueSpec.custom(
      (context, size) => Container(
        width: size * 0.7,
        height: size * 0.7,
        decoration: BoxDecoration(color: shadeColor(context), borderRadius: BorderRadius.circular(size * 0.12)),
      ),
      label: 'shade',
    ),
    ValueSpec.custom((context, size) => DotSymbol(size: size), label: 'keep'),
  ];

  @override
  bool get showLockIcon => false;
  @override
  double get gapRatio => 0.05;

  @override
  ChambersPuzzle generate(GenParams params) => generateChambers(params);

  @override
  Widget buildValue(
    BuildContext context,
    ChambersPuzzle puzzle,
    ValueGrid state,
    Pos pos,
    CellValue cell,
    double size,
  ) {
    if (cell.value == chambersShade) return const SizedBox.shrink();
    return super.buildValue(context, puzzle, state, pos, cell, size);
  }

  @override
  Color? cellColor(BuildContext context, ChambersPuzzle puzzle, Pos pos, CellValue cell) =>
      cell.value == chambersShade ? shadeColor(context) : null;

  List<bool> _shaded(ValueGrid s) => [for (final c in s.cells) c.value == chambersShade];

  @override
  bool isComplete(ChambersPuzzle puzzle, ValueGrid state) =>
      chambersConflicts(puzzle, _shaded(state), complete: false).isEmpty;

  @override
  bool isSolved(ChambersPuzzle puzzle, ValueGrid state) =>
      chambersConflicts(puzzle, _shaded(state), complete: true).isEmpty;

  /// Before the board is complete only dotted cells count as staying.
  @override
  Set<Pos> conflicts(ChambersPuzzle puzzle, ValueGrid state) {
    final complete = isComplete(puzzle, state);
    return {
      for (final i in chambersConflicts(
        puzzle,
        _shaded(state),
        kept: complete ? null : [for (final c in state.cells) c.value == chambersKeep],
        complete: complete,
      ))
        puzzle.size.pos(i),
    };
  }

  /// Fixes a wrong entry, else shades a missing cell: dots are optional.
  @override
  HintResult<ValueGrid>? hint(ChambersPuzzle puzzle, ValueGrid state) {
    final wrong = <int>[], missing = <int>[];
    for (var i = 0; i < state.cells.length; i++) {
      final v = state.cells[i].value;
      if (v != null && v != puzzle.solutionAt(i)) wrong.add(i);
      if (v == null && puzzle.shaded[i]) missing.add(i);
    }
    final pool = wrong.isNotEmpty ? wrong : missing;
    if (pool.isEmpty) return null;
    final i = pool[Random().nextInt(pool.length)];
    final pos = puzzle.size.pos(i);
    return HintResult(state.set(pos, state.cells[i].withValue(puzzle.solutionAt(i))), {pos});
  }

  /// Dots the neighbours of shaded cells and the rest of rooms that hold
  /// all their shaded cells.
  @override
  ValueGrid markForbidden(ChambersPuzzle puzzle, ValueGrid state) {
    final n = puzzle.n;
    final nb = orthNeighbors(n, n);
    final shaded = _shaded(state);
    final dots = <int>{};
    for (var i = 0; i < n * n; i++) {
      if (shaded[i]) dots.addAll(nb[i]);
    }
    for (var k = 0; k < puzzle.rooms.length; k++) {
      final cells = puzzle.rooms[k].cells(n);
      if (puzzle.clues[k] == cells.where((i) => shaded[i]).length) dots.addAll(cells);
    }
    return dotted(state, dots.where((i) => !shaded[i]).toSet(), chambersKeep);
  }

  @override
  List<Widget> buildOverlayIn(BuildContext context, ChambersPuzzle puzzle, ValueGrid state, BoardMetrics m) {
    final theme = Theme.of(context);
    final on = theme.colorScheme.onSurface;
    final shaded = _shaded(state);
    Widget label(int k) {
      final room = puzzle.rooms[k];
      final at = room.r * puzzle.n + room.c;
      // A 0 fades once its room is dotted, the others once they are met.
      final cells = room.cells(puzzle.n);
      final done =
          cells.where((i) => shaded[i]).length == puzzle.clues[k] &&
          (puzzle.clues[k]! > 0 || cells.every((i) => state.cells[i].value != null));
      final color = shaded[at] ? Colors.white : on;
      return Positioned(
        left: m.x(room.c) + m.cell * 0.08,
        top: m.y(room.r) + m.cell * 0.05,
        width: m.cell * 0.6,
        height: m.cell * 0.4,
        child: IgnorePointer(
          child: Align(
            alignment: Alignment.topLeft,
            child: AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: theme.textTheme.bodyMedium!.copyWith(
                fontSize: m.cell * 0.36,
                height: 1,
                fontWeight: FontWeight.w700,
                color: color.withValues(alpha: done ? 0.35 : 0.9),
              ),
              child: Text('${puzzle.clues[k]}'),
            ),
          ),
        ),
      );
    }

    return [
      RegionBorders(metrics: m, regionOf: (i) => puzzle.roomOf[i], color: on),
      for (var k = 0; k < puzzle.rooms.length; k++)
        if (puzzle.clues[k] != null) label(k),
    ];
  }

  @override
  bool get canExplain => true;

  @override
  Explanation? explain(ChambersPuzzle puzzle, ValueGrid state) => explainStep(const ChambersExplainer(), puzzle, state);

  @override
  Map<String, dynamic> encodePuzzle(ChambersPuzzle puzzle) => puzzle.toJson();
  @override
  ChambersPuzzle decodePuzzle(Map<String, dynamic> json) => ChambersPuzzle.fromJson(json);
}
