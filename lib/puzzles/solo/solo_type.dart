import 'dart:math';

import 'package:flutter/material.dart';

import '../../core/day.dart';
import '../../core/difficulty.dart';
import '../../core/explain.dart';
import '../../core/grid.dart';
import '../../core/puzzle_type.dart';
import '../../core/tutorial.dart';
import '../../core/value_grid.dart';
import '../../l10n/l10n.dart';
import 'solo_explain.dart';
import 'solo_generator.dart';
import 'solo_model.dart';
import 'solo_tutorial.dart';

/// Shade repeated numbers until every row and column shows each one once.
class SoloType extends ValueGridType<SoloPuzzle> {
  const SoloType();

  static const ringColor = Color(0xFF3FA796);
  static const shadeLight = Color(0xFF3D3550);
  static const shadeDark = Color(0xFF6A5A96);

  @override
  String get id => 'solo';
  @override
  String name(AppLocalizations l) => l.soloName;
  @override
  String tagline(AppLocalizations l) => l.soloTagline;
  @override
  IconData get icon => Icons.looks_one_rounded;
  @override
  Color get accent => const Color(0xFF9B7FD4);

  @override
  String rulesText(AppLocalizations l) => l.soloRules;

  @override
  List<TutorialStep> tutorial() => soloTutorial;
  @override
  List<TutorialStep> strategies() => soloStrategies;

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
  Day get dailySince => const Day(2026, 10, 15);
  @override
  double get minCellSize => 32;

  @override
  List<ValueSpec> get values => [
    ValueSpec.custom(
      (context, size) => Container(
        width: size * 0.7,
        height: size * 0.7,
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark ? shadeDark : shadeLight,
          borderRadius: BorderRadius.circular(size * 0.12),
        ),
      ),
      label: 'shade',
    ),
    ValueSpec.custom((context, size) => _Ring(size: size), label: 'keep'),
  ];

  @override
  bool get showLockIcon => false;
  @override
  double get gapRatio => 0.06;

  @override
  SoloPuzzle generate(GenParams params) => generateSolo(params);

  Widget _digit(BuildContext context, int digit, double size, {Color? color}) => Text(
    '$digit',
    style: TextStyle(
      fontSize: size * 0.5,
      height: 1,
      fontWeight: FontWeight.w600,
      color: color ?? Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.87),
    ),
  );

  @override
  Widget? buildEmpty(BuildContext context, SoloPuzzle puzzle, Pos pos, double size) =>
      _digit(context, puzzle.digits[puzzle.size.index(pos)], size);

  @override
  Widget buildValue(BuildContext context, SoloPuzzle puzzle, ValueGrid state, Pos pos, CellValue cell, double size) {
    final digit = puzzle.digits[puzzle.size.index(pos)];
    if (cell.value == soloShade) return _digit(context, digit, size, color: Colors.white.withValues(alpha: 0.3));
    return Stack(
      alignment: Alignment.center,
      children: [
        _Ring(size: size),
        _digit(context, digit, size, color: Theme.of(context).colorScheme.onSurface),
      ],
    );
  }

  @override
  Color? cellColor(BuildContext context, SoloPuzzle puzzle, Pos pos, CellValue cell) {
    if (cell.value != soloShade) return null;
    return Theme.of(context).brightness == Brightness.dark ? shadeDark : shadeLight;
  }

  List<bool> _shaded(ValueGrid s) => [for (final c in s.cells) c.value == soloShade];

  @override
  bool isComplete(SoloPuzzle puzzle, ValueGrid state) =>
      soloConflicts(puzzle.n, puzzle.digits, _shaded(state), complete: false).isEmpty;

  @override
  bool isSolved(SoloPuzzle puzzle, ValueGrid state) =>
      soloConflicts(puzzle.n, puzzle.digits, _shaded(state), complete: true).isEmpty;

  /// Before the board is complete only circled numbers count as staying.
  @override
  Set<Pos> conflicts(SoloPuzzle puzzle, ValueGrid state) {
    final complete = isComplete(puzzle, state);
    return {
      for (final i in soloConflicts(
        puzzle.n,
        puzzle.digits,
        _shaded(state),
        kept: complete ? null : [for (final c in state.cells) c.value == soloKeep],
        complete: complete,
      ))
        puzzle.size.pos(i),
    };
  }

  /// Fixes a wrong entry, else shades a missing cell: circles are optional.
  @override
  HintResult<ValueGrid>? hint(SoloPuzzle puzzle, ValueGrid state) {
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

  @override
  bool get canExplain => true;

  @override
  Explanation? explain(SoloPuzzle puzzle, ValueGrid state) => explainStep(const SoloExplainer(), puzzle, state);

  @override
  Map<String, dynamic> encodePuzzle(SoloPuzzle puzzle) => puzzle.toJson();
  @override
  SoloPuzzle decodePuzzle(Map<String, dynamic> json) => SoloPuzzle.fromJson(json);
}

/// The circle around a number that stays.
class _Ring extends StatelessWidget {
  const _Ring({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) => Container(
    width: size * 0.74,
    height: size * 0.74,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: SoloType.ringColor.withValues(alpha: 0.16),
      border: Border.all(color: SoloType.ringColor, width: size * 0.06),
    ),
  );
}
