import 'package:flutter/material.dart';

import '../../core/difficulty.dart';
import '../../core/grid.dart';
import '../../core/puzzle_type.dart';
import '../../core/value_grid.dart';
import '../../ui/board/cell_grid_board.dart';
import '../../ui/board/region_borders.dart';
import '../../ui/symbols.dart';
import 'kings_generator.dart';
import 'kings_model.dart';

/// Kings (one per row/column/region, never touching).
class KingsType extends ValueGridType<KingsPuzzle> {
  const KingsType();

  @override
  String get id => 'kings';
  @override
  String get name => 'Crowns';
  @override
  String get tagline => 'One crown per row, column and region';
  @override
  IconData get icon => Icons.workspace_premium_outlined;
  @override
  Color get accent => const Color(0xFFB39DDB);

  @override
  String get rulesText => '''
• Place exactly one crown in every row, every column and every colored region.
• Crowns may not touch each other, not even diagonally.

Tap a cell to cycle empty → dot (your "no crown here" note) → crown. Long-press / right-click cycles back.''';

  @override
  List<GridSize> get sizes => [for (var n = 5; n <= 10; n++) GridSize.square(n)];
  @override
  GridSize get defaultSize => const GridSize.square(8);

  @override
  List<ValueSpec> get values => [
        ValueSpec.custom((context, size) => DotSymbol(size: size, color: Colors.black54), label: 'Dot'),
        ValueSpec.custom((context, size) => CrownSymbol(size: size * 0.9, color: Colors.black87), label: 'Crown'),
      ];

  @override
  double get gapRatio => 0.06;

  @override
  KingsPuzzle generate(GenParams params) => generateKings(params);

  List<int> _kings(ValueGrid s) => [for (var i = 0; i < s.cells.length; i++) if (s.cells[i].value == kKing) i];

  @override
  bool isComplete(KingsPuzzle puzzle, ValueGrid state) => _kings(state).length == puzzle.n;

  @override
  bool isSolved(KingsPuzzle puzzle, ValueGrid state) {
    final k = _kings(state);
    return k.length == puzzle.n && kingsConflicts(puzzle.n, puzzle.regions, k).isEmpty;
  }

  @override
  Set<Pos> conflicts(KingsPuzzle puzzle, ValueGrid state) =>
      {for (final i in kingsConflicts(puzzle.n, puzzle.regions, _kings(state))) puzzle.size.pos(i)};

  @override
  HintResult<ValueGrid>? hint(KingsPuzzle puzzle, ValueGrid state) {
    // Remove a wrong crown first, otherwise reveal a missing one.
    for (var i = 0; i < state.cells.length; i++) {
      if (state.cells[i].value == kKing && puzzle.solutionAt(i) != kKing) {
        final p = puzzle.size.pos(i);
        return HintResult(state.set(p, state.cells[i].withValue(kDot)), {p});
      }
    }
    for (var r = 0; r < puzzle.n; r++) {
      final i = r * puzzle.n + puzzle.solution[r];
      if (state.cells[i].value != kKing) {
        final p = puzzle.size.pos(i);
        return HintResult(state.set(p, state.cells[i].withValue(kKing)), {p});
      }
    }
    return null;
  }

  @override
  Color? cellColor(BuildContext context, KingsPuzzle puzzle, Pos pos, CellValue cell) {
    final base = regionColors[puzzle.regions[puzzle.size.index(pos)] % regionColors.length];
    return Theme.of(context).brightness == Brightness.dark ? Color.lerp(base, Colors.black, 0.12) : base;
  }

  @override
  List<Widget> buildOverlay(BuildContext context, KingsPuzzle puzzle, BoardMetrics m) => [
        RegionBorders(metrics: m, regionOf: (i) => puzzle.regions[i], color: Theme.of(context).colorScheme.onSurface),
      ];

  @override
  Map<String, dynamic> encodePuzzle(KingsPuzzle puzzle) => puzzle.toJson();
  @override
  KingsPuzzle decodePuzzle(Map<String, dynamic> json) => KingsPuzzle.fromJson(json);
}
