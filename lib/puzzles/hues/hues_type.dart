import 'package:flutter/material.dart';

import '../../core/difficulty.dart';
import '../../core/grid.dart';
import '../../core/puzzle_type.dart';
import '../../core/tutorial.dart';
import '../../core/value_grid.dart';
import '../../l10n/l10n.dart';
import 'hues_generator.dart';
import 'hues_model.dart';
import 'hues_tutorial.dart';

/// Color every blank cell; numbers count same-colored blank neighbours.
class HuesType extends ValueGridType<HuesPuzzle> {
  const HuesType();

  static const palette = [Color(0xFF4DA3FF), Color(0xFFE05A87), Color(0xFFFFC15E), Color(0xFF6CCB8B)];

  @override
  String get id => 'hues';
  @override
  String name(AppLocalizations l) => l.huesName;
  @override
  String tagline(AppLocalizations l) => l.huesTagline;
  @override
  IconData get icon => Icons.palette_outlined;
  @override
  Color get accent => const Color(0xFFE05A87);

  @override
  String rulesText(AppLocalizations l) => l.huesRules;

  @override
  List<TutorialStep> tutorial() => huesTutorial;

  @override
  List<GridSize> get sizes => [for (var n = 5; n <= 9; n++) GridSize.square(n)];
  @override
  GridSize get defaultSize => const GridSize.square(6);
  @override
  GridSize dailySize(Difficulty difficulty) => switch (difficulty) {
        Difficulty.easy => const GridSize.square(6),
        Difficulty.medium => const GridSize.square(7),
        _ => const GridSize.square(8),
      };

  @override
  InputMode get defaultInputMode => InputMode.palette;

  @override
  List<ValueSpec> get values => [
        for (var i = 0; i < huesColorCount; i++) ValueSpec.fill(palette[i], label: ['blue', 'pink', 'yellow', 'green'][i]),
      ];

  @override
  bool get showLockIcon => false;

  @override
  HuesPuzzle generate(GenParams params) => generateHues(params);

  @override
  Color? cellColor(BuildContext context, HuesPuzzle puzzle, Pos pos, CellValue cell) =>
      cell.value == null ? null : palette[cell.value!];

  @override
  Widget buildValue(BuildContext context, HuesPuzzle puzzle, ValueGrid state, Pos pos, CellValue cell, double size) {
    final i = puzzle.size.index(pos);
    final n = puzzle.clues[i];
    if (n == null) return const SizedBox.shrink();
    // Count down: how many more neighbours still need this clue's color.
    var placed = 0;
    for (final j in _neighbors(puzzle)[i]) {
      if (puzzle.clues[j] == null && state.cells[j].value == puzzle.solution[i]) placed++;
    }
    final left = n - placed;
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 200),
      transitionBuilder: (child, anim) => ScaleTransition(scale: anim, child: FadeTransition(opacity: anim, child: child)),
      child: Text(
        '$left',
        key: ValueKey(left),
        style: TextStyle(
          fontSize: size * 0.55,
          height: 1,
          fontWeight: FontWeight.w600,
          color: Colors.black.withValues(alpha: left == 0 ? 0.3 : 0.82),
        ),
      ),
    );
  }

  static final Map<(int, int), List<List<int>>> _nbCache = {};
  static List<List<int>> _neighbors(HuesPuzzle p) =>
      _nbCache.putIfAbsent((p.rows, p.cols), () => huesNeighbors(p.rows, p.cols));

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
