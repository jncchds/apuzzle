import 'package:flutter/material.dart';

import '../../core/difficulty.dart';
import '../../core/grid.dart';
import '../../core/puzzle_type.dart';
import '../../core/value_grid.dart';
import 'hues_generator.dart';
import 'hues_model.dart';

/// Color every blank cell; numbers count same-colored blank neighbours.
class HuesType extends ValueGridType<HuesPuzzle> {
  const HuesType();

  static const palette = [Color(0xFF4DA3FF), Color(0xFFE05A87), Color(0xFFFFC15E), Color(0xFF6CCB8B)];

  @override
  String get id => 'hues';
  @override
  String get name => 'Hues';
  @override
  String get tagline => 'Count the matching colors around each number';
  @override
  IconData get icon => Icons.palette_outlined;
  @override
  Color get accent => const Color(0xFFE05A87);

  @override
  String get rulesText => '''
• Color every blank cell using the palette colors.
• Each numbered cell shows how many of the blank cells around it (all 8 neighbours, including diagonals) end up in the same color as the numbered cell.
• Numbered cells themselves never count.

Pick a color in the palette and tap cells to paint them (tap again to clear), or tap a cell to cycle through the colors.''';

  @override
  List<GridSize> get sizes => [for (var n = 5; n <= 9; n++) GridSize.square(n)];
  @override
  GridSize get defaultSize => const GridSize.square(6);

  @override
  InputMode get defaultInputMode => InputMode.palette;

  @override
  List<ValueSpec> get values => [
        for (var i = 0; i < huesColorCount; i++) ValueSpec.fill(palette[i], label: ['Blue', 'Pink', 'Yellow', 'Green'][i]),
      ];

  @override
  bool get showLockIcon => false;

  @override
  HuesPuzzle generate(GenParams params) => generateHues(params);

  @override
  Color? cellColor(BuildContext context, HuesPuzzle puzzle, Pos pos, CellValue cell) =>
      cell.value == null ? null : palette[cell.value!];

  @override
  Widget buildValue(BuildContext context, HuesPuzzle puzzle, Pos pos, CellValue cell, double size) {
    final n = puzzle.clues[puzzle.size.index(pos)];
    if (n == null) return const SizedBox.shrink();
    return Text(
      '$n',
      style: TextStyle(fontSize: size * 0.55, height: 1, fontWeight: FontWeight.w600, color: Colors.black.withValues(alpha: 0.82)),
    );
  }

  @override
  bool isSolved(HuesPuzzle puzzle, ValueGrid state) => state.isFull && huesConflicts(puzzle, state.toFlat()).isEmpty;

  @override
  Set<Pos> conflicts(HuesPuzzle puzzle, ValueGrid state) =>
      {for (final i in huesConflicts(puzzle, state.toFlat())) puzzle.size.pos(i)};

  @override
  Map<String, dynamic> encodePuzzle(HuesPuzzle puzzle) => puzzle.toJson();
  @override
  HuesPuzzle decodePuzzle(Map<String, dynamic> json) => HuesPuzzle.fromJson(json);
}
