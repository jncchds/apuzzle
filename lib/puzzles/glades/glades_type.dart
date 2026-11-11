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
import '../../ui/symbols.dart';
import 'glades_explain.dart';
import 'glades_generator.dart';
import 'glades_model.dart';
import 'glades_tutorial.dart';

/// Glades: shade cells so every unshaded area is a numbered rectangle.
class GladesType extends ValueGridType<GladesPuzzle> {
  const GladesType();

  static const shadeLight = Color(0xFF2F5D3A);
  static const shadeDark = Color(0xFF4F8A5C);

  static Color shadeColor(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? shadeDark : shadeLight;

  @override
  String get id => 'glades';
  @override
  String name(AppLocalizations l) => l.gladesName;
  @override
  String tagline(AppLocalizations l) => l.gladesTagline;
  @override
  IconData get icon => Icons.forest_rounded;
  @override
  Color get accent => const Color(0xFF6FBF73);

  @override
  String rulesText(AppLocalizations l) => l.gladesRules;

  @override
  List<TutorialStep> tutorial() => gladesTutorial;
  @override
  List<TutorialStep> strategies() => gladesStrategies;

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
  Day get dailySince => const Day(2026, 11, 12);
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
  GladesPuzzle generate(GenParams params) => generateGlades(params);

  List<bool> _shaded(ValueGrid s) => [for (final c in s.cells) c.value == gladesShade];

  /// The cells not shaded joined side by side to [i].
  List<int> _areaOf(GladesPuzzle p, List<bool> shaded, int i) {
    final nb = orthNeighbors(p.n, p.n);
    final seen = {i};
    final queue = [i];
    for (var k = 0; k < queue.length; k++) {
      for (final j in nb[queue[k]]) {
        if (!shaded[j] && seen.add(j)) queue.add(j);
      }
    }
    return queue;
  }

  /// A number is met once shaded cells and the edge close its area as a
  /// rectangle of that many cells.
  bool _met(GladesPuzzle p, List<bool> shaded, int i) {
    final area = _areaOf(p, shaded, i);
    return area.length == p.clues[i] && gladesIsRect(p.n, area);
  }

  @override
  Widget buildValue(BuildContext context, GladesPuzzle puzzle, ValueGrid state, Pos pos, CellValue cell, double size) {
    final i = puzzle.size.index(pos);
    final clue = puzzle.clues[i];
    if (clue == null) {
      if (cell.value == gladesShade) return const SizedBox.shrink();
      return super.buildValue(context, puzzle, state, pos, cell, size);
    }
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 200),
      opacity: _met(puzzle, _shaded(state), i) ? 0.35 : 1,
      child: Text(
        '$clue',
        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
          fontSize: size * 0.52,
          height: 1,
          fontWeight: FontWeight.w700,
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ),
    );
  }

  @override
  Color? cellColor(BuildContext context, GladesPuzzle puzzle, Pos pos, CellValue cell) =>
      cell.value == gladesShade ? shadeColor(context) : null;

  /// As many shaded cells as the solution, or every cell filled.
  @override
  bool isComplete(GladesPuzzle puzzle, ValueGrid state) =>
      state.isFull || state.cells.where((c) => c.value == gladesShade).length == puzzle.shadedCount;

  @override
  bool isSolved(GladesPuzzle puzzle, ValueGrid state) => gladesValid(puzzle, _shaded(state));

  /// Before the board is complete only what more cells can't mend.
  @override
  Set<Pos> conflicts(GladesPuzzle puzzle, ValueGrid state) {
    final complete = isComplete(puzzle, state);
    return {
      for (final i in gladesConflicts(
        puzzle,
        _shaded(state),
        kept: complete ? null : [for (final c in state.cells) c.value == gladesKeep],
        complete: complete,
      ))
        puzzle.size.pos(i),
    };
  }

  /// Fixes a wrong entry, else shades a missing cell: dots are optional.
  @override
  HintResult<ValueGrid>? hint(GladesPuzzle puzzle, ValueGrid state) {
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

  /// Dots the cells of every area that has its number, and the last cell of
  /// a 2×2 block with three shaded.
  @override
  ValueGrid markForbidden(GladesPuzzle puzzle, ValueGrid state) {
    final n = puzzle.n;
    final shaded = _shaded(state);
    final dots = <int>{};
    for (var i = 0; i < n * n; i++) {
      if (puzzle.clues[i] != null && _met(puzzle, shaded, i)) dots.addAll(_areaOf(puzzle, shaded, i));
    }
    for (var y = 0; y + 1 < n; y++) {
      for (var x = 0; x + 1 < n; x++) {
        final block = [y * n + x, y * n + x + 1, y * n + x + n, y * n + x + n + 1];
        final open = block.where((j) => !shaded[j]).toList();
        if (open.length == 1) dots.add(open.first);
      }
    }
    return dotted(state, dots.where((i) => !shaded[i] && puzzle.clues[i] == null).toSet(), gladesKeep);
  }

  @override
  bool get canExplain => true;

  @override
  Explanation? explain(GladesPuzzle puzzle, ValueGrid state, {Set<int> prefer = const {}}) =>
      explainStep(const GladesExplainer(), puzzle, state, prefer: prefer);

  @override
  Map<String, dynamic> encodePuzzle(GladesPuzzle puzzle) => puzzle.toJson();
  @override
  GladesPuzzle decodePuzzle(Map<String, dynamic> json) => GladesPuzzle.fromJson(json);
}
