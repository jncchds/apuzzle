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
import 'lookout_explain.dart';
import 'lookout_generator.dart';
import 'lookout_model.dart';
import 'lookout_tutorial.dart';

/// Lookout: shade cells so every number sees as many cells as it says.
class LookoutType extends ValueGridType<LookoutPuzzle> {
  const LookoutType();

  static const shadeLight = Color(0xFF2E4756);
  static const shadeDark = Color(0xFF5D8199);

  static Color shadeColor(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? shadeDark : shadeLight;

  @override
  String get id => 'lookout';
  @override
  String name(AppLocalizations l) => l.lookoutName;
  @override
  String tagline(AppLocalizations l) => l.lookoutTagline;
  @override
  IconData get icon => Icons.visibility_rounded;
  @override
  Color get accent => const Color(0xFF4FA3C7);

  @override
  String rulesText(AppLocalizations l) => l.lookoutRules;

  @override
  List<TutorialStep> tutorial() => lookoutTutorial;
  @override
  List<TutorialStep> strategies() => lookoutStrategies;

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
  LookoutPuzzle generate(GenParams params) => generateLookout(params);

  List<bool> _shaded(ValueGrid s) => [for (final c in s.cells) c.value == lookoutShade];

  /// A number is met once shaded cells and edges close its view at its
  /// count; with no shaded cell in view, only once every cell it sees is filled.
  bool _met(LookoutPuzzle p, ValueGrid s, int i) {
    final shaded = _shaded(s);
    if (lookoutSeen(p.n, i, (j) => !shaded[j]) != p.clues[i]) return false;
    final rays = lookoutRaysOf(p.n)[i];
    return rays.any((ray) => ray.any((j) => shaded[j])) ||
        rays.every((ray) => ray.every((j) => s.cells[j].value != null));
  }

  @override
  Widget buildValue(BuildContext context, LookoutPuzzle puzzle, ValueGrid state, Pos pos, CellValue cell, double size) {
    final i = puzzle.size.index(pos);
    final clue = puzzle.clues[i];
    if (clue == null) {
      if (cell.value == lookoutShade) return const SizedBox.shrink();
      return super.buildValue(context, puzzle, state, pos, cell, size);
    }
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 200),
      opacity: _met(puzzle, state, i) ? 0.35 : 1,
      child: Text(
        '$clue',
        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
          fontSize: size * (clue >= 10 ? 0.44 : 0.52),
          height: 1,
          fontWeight: FontWeight.w700,
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ),
    );
  }

  @override
  Color? cellColor(BuildContext context, LookoutPuzzle puzzle, Pos pos, CellValue cell) =>
      cell.value == lookoutShade ? shadeColor(context) : null;

  @override
  bool isComplete(LookoutPuzzle puzzle, ValueGrid state) =>
      lookoutConflicts(puzzle, _shaded(state), complete: false).isEmpty;

  @override
  bool isSolved(LookoutPuzzle puzzle, ValueGrid state) =>
      lookoutConflicts(puzzle, _shaded(state), complete: true).isEmpty;

  /// Before the board is complete only dotted cells count as staying.
  @override
  Set<Pos> conflicts(LookoutPuzzle puzzle, ValueGrid state) {
    final complete = isComplete(puzzle, state);
    return {
      for (final i in lookoutConflicts(
        puzzle,
        _shaded(state),
        kept: complete ? null : [for (final c in state.cells) c.value == lookoutKeep],
        complete: complete,
      ))
        puzzle.size.pos(i),
    };
  }

  /// Fixes a wrong entry, else shades a missing cell: dots are optional.
  @override
  HintResult<ValueGrid>? hint(LookoutPuzzle puzzle, ValueGrid state) {
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

  /// Dots the neighbours of shaded cells and every cell a number sees once
  /// shaded cells and edges close its view at its count.
  @override
  ValueGrid markForbidden(LookoutPuzzle puzzle, ValueGrid state) {
    final n = puzzle.n;
    final nb = orthNeighbors(n, n);
    final shaded = _shaded(state);
    final dots = <int>{};
    for (var i = 0; i < n * n; i++) {
      if (shaded[i]) dots.addAll(nb[i]);
      if (puzzle.clues[i] != null && lookoutSeen(n, i, (j) => !shaded[j]) == puzzle.clues[i]) {
        for (final ray in lookoutRaysOf(n)[i]) {
          dots.addAll(ray.takeWhile((j) => !shaded[j]));
        }
      }
    }
    return dotted(state, dots.where((i) => !shaded[i] && puzzle.clues[i] == null).toSet(), lookoutKeep);
  }

  @override
  bool get canExplain => true;

  @override
  Explanation? explain(LookoutPuzzle puzzle, ValueGrid state) => explainStep(const LookoutExplainer(), puzzle, state);

  @override
  Map<String, dynamic> encodePuzzle(LookoutPuzzle puzzle) => puzzle.toJson();
  @override
  LookoutPuzzle decodePuzzle(Map<String, dynamic> json) => LookoutPuzzle.fromJson(json);
}
