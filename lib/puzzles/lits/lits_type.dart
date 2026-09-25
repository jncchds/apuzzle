import 'package:flutter/material.dart';

import '../../core/difficulty.dart';
import '../../core/grid.dart';
import '../../core/puzzle_type.dart';
import '../../core/tutorial.dart';
import '../../core/value_grid.dart';
import '../../l10n/l10n.dart';
import '../../ui/board/cell_grid_board.dart';
import '../../ui/board/region_borders.dart';
import '../../ui/symbols.dart';
import 'lits_generator.dart';
import 'lits_model.dart';
import 'lits_tutorial.dart';

/// LITS: shade one tetromino per region.
class LitsType extends ValueGridType<LitsPuzzle> {
  const LitsType();

  static const shapeColors = {
    Tetro.l: Color(0xFFF2BE8A),
    Tetro.i: Color(0xFF7FA3D1),
    Tetro.t: Color(0xFF9CC79A),
    Tetro.s: Color(0xFFD2A9DE),
  };

  @override
  String get id => 'lits';
  @override
  String name(AppLocalizations l) => l.litsName;
  @override
  String tagline(AppLocalizations l) => l.litsTagline;
  @override
  IconData get icon => Icons.extension_outlined;
  @override
  Color get accent => const Color(0xFF9CC79A);

  @override
  String rulesText(AppLocalizations l) => l.litsRules;

  @override
  List<TutorialStep> tutorial() => litsTutorial;

  @override
  // Larger boards take too long to generate on-device for now (see CLAUDE.md).
  List<GridSize> get sizes => [for (var n = 5; n <= 7; n++) GridSize.square(n)];
  @override
  GridSize get defaultSize => const GridSize.square(6);
  @override
  GridSize dailySize(Difficulty difficulty) => switch (difficulty) {
        Difficulty.easy => const GridSize.square(5),
        Difficulty.medium => const GridSize.square(6),
        _ => const GridSize.square(7),
      };
  @override
  double get gapRatio => 0.06;

  @override
  List<ValueSpec> get values => [
        ValueSpec.custom((context, size) => const SizedBox.shrink(), label: 'shade'),
        ValueSpec.custom((context, size) => DotSymbol(size: size), label: 'dot'),
      ];

  @override
  LitsPuzzle generate(GenParams params) => generateLits(params);

  List<bool> _shaded(ValueGrid s) => [for (final c in s.cells) c.value == litsShade];

  @override
  bool isComplete(LitsPuzzle puzzle, ValueGrid state) {
    final counts = List<int>.filled(puzzle.regionCount, 0);
    for (var i = 0; i < state.cells.length; i++) {
      if (state.cells[i].value == litsShade) counts[puzzle.regions[i]]++;
    }
    return counts.every((c) => c == 4);
  }

  @override
  bool isSolved(LitsPuzzle puzzle, ValueGrid state) =>
      isComplete(puzzle, state) && litsConflicts(puzzle.n, puzzle.regions, _shaded(state), complete: true).isEmpty;

  @override
  Set<Pos> conflicts(LitsPuzzle puzzle, ValueGrid state) => {
        for (final i in litsConflicts(puzzle.n, puzzle.regions, _shaded(state), complete: isComplete(puzzle, state)))
          puzzle.size.pos(i),
      };

  @override
  HintResult<ValueGrid>? hint(LitsPuzzle puzzle, ValueGrid state) {
    for (var i = 0; i < state.cells.length; i++) {
      final shaded = state.cells[i].value == litsShade;
      if (shaded != puzzle.shaded[i] && (shaded || puzzle.shaded[i])) {
        final p = puzzle.size.pos(i);
        return HintResult(state.set(p, state.cells[i].withValue(puzzle.shaded[i] ? litsShade : litsDot)), {p});
      }
    }
    return null;
  }

  @override
  Color? cellColor(BuildContext context, LitsPuzzle puzzle, Pos pos, CellValue cell) {
    if (cell.value != litsShade) return null;
    final s = (context.findAncestorWidgetOfExactType<_ShapeScope>())?.shapes;
    final shape = s?[puzzle.regions[puzzle.size.index(pos)]];
    return shape == null ? Theme.of(context).colorScheme.outline : shapeColors[shape];
  }

  @override
  Widget buildBoard(BuildContext context, controller) {
    final p = controller.puzzle as LitsPuzzle;
    final s = controller.state as ValueGrid;
    final byRegion = List.generate(p.regionCount, (_) => <int>[]);
    for (var i = 0; i < s.cells.length; i++) {
      if (s.cells[i].value == litsShade) byRegion[p.regions[i]].add(i);
    }
    final shapes = [for (final cells in byRegion) cells.length == 4 ? classify(cells, p.n) : null];
    return _ShapeScope(shapes: shapes, child: Builder(builder: (context) => super.buildBoard(context, controller)));
  }

  @override
  List<Widget> buildOverlay(BuildContext context, LitsPuzzle puzzle, BoardMetrics m) => [
        RegionBorders(metrics: m, regionOf: (i) => puzzle.regions[i], color: Theme.of(context).colorScheme.onSurface),
      ];

  @override
  Map<String, dynamic> encodePuzzle(LitsPuzzle puzzle) => puzzle.toJson();
  @override
  LitsPuzzle decodePuzzle(Map<String, dynamic> json) => LitsPuzzle.fromJson(json);
}

/// Passes the currently detected shape per region down to cell builders.
class _ShapeScope extends StatelessWidget {
  const _ShapeScope({required this.shapes, required this.child});
  final List<Tetro?> shapes;
  final Widget child;

  @override
  Widget build(BuildContext context) => child;
}
