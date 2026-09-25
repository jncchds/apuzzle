import 'package:flutter/material.dart';

import '../../core/difficulty.dart';
import '../../core/grid.dart';
import '../../core/puzzle_type.dart';
import '../../core/value_grid.dart';
import '../../l10n/l10n.dart';
import '../../ui/symbols.dart';
import 'islands_generator.dart';
import 'islands_model.dart';

/// Nurikabe: flood the sea around numbered islands.
class IslandsType extends ValueGridType<IslandsPuzzle> {
  const IslandsType();

  static const seaColor = Color(0xFF3F7FBF);
  static const sandColor = Color(0xFFF3E3B5);

  @override
  String get id => 'islands';
  @override
  String name(AppLocalizations l) => l.islandsName;
  @override
  String tagline(AppLocalizations l) => l.islandsTagline;
  @override
  IconData get icon => Icons.water_rounded;
  @override
  Color get accent => const Color(0xFF5B9BD5);

  @override
  String rulesText(AppLocalizations l) => l.islandsRules;

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
  List<ValueSpec> get values => [
        ValueSpec.custom((context, size) => const SizedBox.shrink(), label: 'sea'),
        ValueSpec.custom((context, size) => DotSymbol(size: size, color: const Color(0xFF9A7B3C)), label: 'dot'),
      ];

  @override
  bool get showLockIcon => false;
  @override
  double get gapRatio => 0.05;

  @override
  IslandsPuzzle generate(GenParams params) => generateIslands(params);

  List<bool> _sea(ValueGrid s) => [for (final c in s.cells) c.value == islandsSea];

  @override
  bool isComplete(IslandsPuzzle puzzle, ValueGrid state) =>
      _sea(state).where((s) => s).length == puzzle.sea.where((s) => s).length;

  @override
  bool isSolved(IslandsPuzzle puzzle, ValueGrid state) =>
      islandsConflicts(puzzle.rows, puzzle.cols, puzzle.clues, _sea(state), complete: true).isEmpty;

  @override
  Set<Pos> conflicts(IslandsPuzzle puzzle, ValueGrid state) => {
        for (final i in islandsConflicts(puzzle.rows, puzzle.cols, puzzle.clues, _sea(state),
            complete: isComplete(puzzle, state)))
          puzzle.size.pos(i),
      };

  @override
  HintResult<ValueGrid>? hint(IslandsPuzzle puzzle, ValueGrid state) {
    HintResult<ValueGrid> put(int i, int v) {
      final p = puzzle.size.pos(i);
      return HintResult(state.set(p, state.cells[i].withValue(v)), {p});
    }

    // Wrong marks first, then a missing piece of sea.
    for (var i = 0; i < state.cells.length; i++) {
      final v = state.cells[i].value;
      if (v != null && v != puzzle.solutionAt(i)) return put(i, puzzle.solutionAt(i));
    }
    for (var i = 0; i < state.cells.length; i++) {
      if (puzzle.sea[i] && state.cells[i].value == null) return put(i, islandsSea);
    }
    for (var i = 0; i < state.cells.length; i++) {
      if (state.cells[i].value == null) return put(i, islandsLand);
    }
    return null;
  }

  @override
  Color? cellColor(BuildContext context, IslandsPuzzle puzzle, Pos pos, CellValue cell) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    if (cell.value == islandsSea) return dark ? Color.lerp(seaColor, Colors.black, 0.2) : seaColor;
    if (cell.value == islandsLand) return dark ? Color.lerp(sandColor, Colors.black, 0.62) : sandColor;
    return null;
  }

  @override
  Widget buildValue(BuildContext context, IslandsPuzzle puzzle, ValueGrid state, Pos pos, CellValue cell, double size) {
    final n = puzzle.clues[puzzle.size.index(pos)];
    if (n == null) return super.buildValue(context, puzzle, state, pos, cell, size);
    return Text(
      '$n',
      style: TextStyle(
        fontSize: size * 0.55,
        height: 1,
        fontWeight: FontWeight.w700,
        color: Theme.of(context).brightness == Brightness.dark ? const Color(0xFFF3E3B5) : const Color(0xFF5A4520),
      ),
    );
  }

  @override
  Map<String, dynamic> encodePuzzle(IslandsPuzzle puzzle) => puzzle.toJson();
  @override
  IslandsPuzzle decodePuzzle(Map<String, dynamic> json) => IslandsPuzzle.fromJson(json);
}
