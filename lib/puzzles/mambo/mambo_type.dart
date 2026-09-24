import 'package:flutter/material.dart';

import '../../core/difficulty.dart';
import '../../core/grid.dart';
import '../../core/value_grid.dart';
import '../../ui/board/cell_grid_board.dart';
import 'mambo_generator.dart';
import 'mambo_model.dart';

/// Sun & Moon (Tango / Binairo with = and × clues).
class MamboType extends ValueGridType<MamboPuzzle> {
  const MamboType();

  @override
  String get id => 'mambo';
  @override
  String get name => 'Sun & Moon';
  @override
  String get tagline => 'Balance suns and moons';
  @override
  IconData get icon => Icons.wb_twilight_rounded;
  @override
  Color get accent => const Color(0xFFF5A524);

  @override
  String get rulesText => '''
• Fill every cell with a sun or a moon.
• No more than 2 identical symbols next to each other in a row or column.
• Each row and column has the same number of suns and moons.
• "=" between two cells: they hold the same symbol.
• "×" between two cells: they hold different symbols.
• Locked cells are given.

Tap a cell to cycle empty → sun → moon. Long-press / right-click cycles back.''';

  @override
  List<GridSize> get sizes => const [GridSize.square(4), GridSize.square(6), GridSize.square(8), GridSize.square(10)];
  @override
  GridSize get defaultSize => const GridSize.square(6);

  @override
  List<ValueSpec> get values => const [
        ValueSpec.icon(Icons.wb_sunny_rounded, color: Color(0xFFF5A524), label: 'Sun'),
        ValueSpec.icon(Icons.dark_mode_rounded, color: Color(0xFF4F6BFF), label: 'Moon'),
      ];

  @override
  MamboPuzzle generate(GenParams params) => generateMambo(params);

  @override
  bool isSolved(MamboPuzzle puzzle, ValueGrid state) =>
      state.isFull && mamboConflicts(puzzle.n, state.toFlat(), puzzle.edges).isEmpty;

  @override
  Set<Pos> conflicts(MamboPuzzle puzzle, ValueGrid state) =>
      {for (final i in mamboConflicts(puzzle.n, state.toFlat(), puzzle.edges)) puzzle.size.pos(i)};

  @override
  Map<String, dynamic> encodePuzzle(MamboPuzzle puzzle) => puzzle.toJson();
  @override
  MamboPuzzle decodePuzzle(Map<String, dynamic> json) => MamboPuzzle.fromJson(json);

  @override
  List<Widget> buildOverlay(BuildContext context, MamboPuzzle puzzle, BoardMetrics m) {
    final scheme = Theme.of(context).colorScheme;
    final d = (m.cell * 0.34).clamp(14.0, 26.0);
    return [
      for (final e in puzzle.edges)
        Builder(builder: (context) {
          final c = m.edgeCenter(puzzle.size.pos(e.a), puzzle.size.pos(e.b));
          return Positioned(
            left: c.dx - d / 2,
            top: c.dy - d / 2,
            width: d,
            height: d,
            child: Container(
              decoration: BoxDecoration(
                color: scheme.surface,
                shape: BoxShape.circle,
                border: Border.all(color: scheme.outline, width: 1.5),
              ),
              child: Icon(e.same ? Icons.drag_handle_rounded : Icons.close_rounded, size: d * 0.72, color: scheme.onSurface),
            ),
          );
        }),
    ];
  }
}
