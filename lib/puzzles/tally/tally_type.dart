import 'package:flutter/material.dart';

import '../../core/day.dart';
import '../../core/difficulty.dart';
import '../../core/explain.dart';
import '../../core/grid.dart';
import '../../core/tutorial.dart';
import '../../core/value_grid.dart';
import '../../l10n/l10n.dart';
import '../../ui/board/cell_grid_board.dart';
import 'tally_explain.dart';
import 'tally_generator.dart';
import 'tally_model.dart';
import 'tally_tutorial.dart';

/// Cross out digits until every row and column adds up to its number.
class TallyType extends ValueGridType<TallyPuzzle> {
  const TallyType();

  static const ringColor = Color(0xFF5C9DD6);

  @override
  String get id => 'tally';
  @override
  String name(AppLocalizations l) => l.tallyName;
  @override
  String tagline(AppLocalizations l) => l.tallyTagline;
  @override
  IconData get icon => Icons.functions_rounded;
  @override
  Color get accent => ringColor;

  @override
  String rulesText(AppLocalizations l) => l.tallyRules;

  @override
  List<TutorialStep> tutorial() => tallyTutorial;
  @override
  List<TutorialStep> strategies() => tallyStrategies;

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
  Day get dailySince => const Day(2026, 10, 10);
  @override
  double get minCellSize => 32;

  @override
  List<ValueSpec> get values => [
    ValueSpec.custom(
      (context, size) => Icon(
        Icons.close_rounded,
        size: size * 0.7,
        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.55),
      ),
      label: 'cross',
    ),
    ValueSpec.custom((context, size) => _Ring(size: size), label: 'keep'),
  ];

  @override
  bool get showLockIcon => false;
  @override
  double get gapRatio => 0.06;

  @override
  TallyPuzzle generate(GenParams params) => generateTally(params);

  Widget _digit(BuildContext context, int digit, double size, {double alpha = 0.87, bool struck = false}) {
    final on = Theme.of(context).colorScheme.onSurface;
    return Text(
      '$digit',
      style: TextStyle(
        fontSize: size * 0.5,
        height: 1,
        fontWeight: FontWeight.w600,
        color: on.withValues(alpha: alpha),
        decoration: struck ? TextDecoration.lineThrough : null,
        decorationColor: on.withValues(alpha: 0.5),
        decorationThickness: 2,
      ),
    );
  }

  @override
  Widget? buildEmpty(BuildContext context, TallyPuzzle puzzle, Pos pos, double size) =>
      _digit(context, puzzle.digits[puzzle.size.index(pos)], size);

  @override
  Widget buildValue(BuildContext context, TallyPuzzle puzzle, ValueGrid state, Pos pos, CellValue cell, double size) {
    final digit = puzzle.digits[puzzle.size.index(pos)];
    if (cell.value == tallyCross) return _digit(context, digit, size, alpha: 0.25, struck: true);
    return Stack(
      alignment: Alignment.center,
      children: [
        _Ring(size: size),
        _digit(context, digit, size, alpha: 1),
      ],
    );
  }

  List<bool> _crossed(ValueGrid s) => [for (final c in s.cells) c.value == tallyCross];

  @override
  bool isComplete(TallyPuzzle puzzle, ValueGrid state) => tallySums(puzzle, _crossed(state));

  @override
  bool isSolved(TallyPuzzle puzzle, ValueGrid state) => isComplete(puzzle, state);

  @override
  Set<Pos> conflicts(TallyPuzzle puzzle, ValueGrid state) => {
    for (final i in tallyConflicts(puzzle, _crossed(state), [for (final c in state.cells) c.value == tallyKeep]))
      puzzle.size.pos(i),
  };

  @override
  (double, double) header(TallyPuzzle puzzle) => (0.8, 0.72);

  @override
  List<Widget> buildOverlayIn(BuildContext context, TallyPuzzle puzzle, ValueGrid state, BoardMetrics m) {
    final theme = Theme.of(context);
    final on = theme.colorScheme.onSurface;
    Widget label(Rect r, int want, List<int> cells) {
      // Met when the digits not crossed out add up to it.
      final have = cells.fold(0, (s, i) => state.cells[i].value == tallyCross ? s : s + puzzle.digits[i]);
      return Positioned.fromRect(
        rect: r,
        child: Center(
          child: AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 200),
            style: theme.textTheme.bodyLarge!.copyWith(
              fontSize: m.cell * 0.38,
              fontWeight: FontWeight.w700,
              color: on.withValues(alpha: have == want ? 0.3 : 0.85),
            ),
            child: Text('$want'),
          ),
        ),
      );
    }

    final rt = puzzle.rowTargets, ct = puzzle.colTargets;
    return [
      for (var r = 0; r < puzzle.rows; r++)
        label(Rect.fromLTWH(0, m.y(r), m.ox - m.gap, m.cell), rt[r], puzzle.rowCells(r)),
      for (var c = 0; c < puzzle.cols; c++)
        label(Rect.fromLTWH(m.x(c), 0, m.cell, m.oy - m.gap), ct[c], puzzle.colCells(c)),
    ];
  }

  @override
  bool get canExplain => true;

  @override
  Explanation? explain(TallyPuzzle puzzle, ValueGrid state) => explainStep(const TallyExplainer(), puzzle, state);

  @override
  Map<String, dynamic> encodePuzzle(TallyPuzzle puzzle) => puzzle.toJson();
  @override
  TallyPuzzle decodePuzzle(Map<String, dynamic> json) => TallyPuzzle.fromJson(json);
}

/// The circle around a digit that stays.
class _Ring extends StatelessWidget {
  const _Ring({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) => Container(
    width: size * 0.74,
    height: size * 0.74,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: TallyType.ringColor.withValues(alpha: 0.16),
      border: Border.all(color: TallyType.ringColor, width: size * 0.06),
    ),
  );
}
