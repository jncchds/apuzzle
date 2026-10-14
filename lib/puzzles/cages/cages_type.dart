import 'package:flutter/material.dart';

import '../../core/day.dart';
import '../../core/difficulty.dart';
import '../../core/explain.dart';
import '../../core/grid.dart';
import '../../core/puzzle_type.dart';
import '../../core/tutorial.dart';
import '../../core/value_grid.dart';
import '../../l10n/l10n.dart';
import '../../ui/board/cell_grid_board.dart';
import '../../ui/board/region_borders.dart';
import 'cages_explain.dart';
import 'cages_generator.dart';
import 'cages_model.dart';
import 'cages_tutorial.dart';

/// A Latin square cut into cages; each cage's numbers make its target with
/// its operation.
class CagesType extends ValueGridType<CagesPuzzle> {
  const CagesType();

  /// Room at the top of a cell for the cage's clue, as a share of the cell.
  static const _clueBand = 0.3;

  @override
  String get id => 'cages';
  @override
  String name(AppLocalizations l) => l.cagesName;
  @override
  String tagline(AppLocalizations l) => l.cagesTagline;
  @override
  IconData get icon => Icons.exposure_rounded;
  @override
  Color get accent => const Color(0xFF9D7CF2);

  @override
  String rulesText(AppLocalizations l) => l.cagesRules;

  @override
  List<TutorialStep> tutorial() => cagesTutorial;
  @override
  List<TutorialStep> strategies() => cagesStrategies;

  @override
  List<GridSize> get sizes => [for (var n = 4; n <= 9; n++) GridSize.square(n)];
  @override
  GridSize get defaultSize => const GridSize.square(6);
  @override
  GridSize dailySize(Difficulty difficulty) => switch (difficulty) {
    Difficulty.easy => const GridSize.square(5),
    Difficulty.medium => const GridSize.square(6),
    _ => const GridSize.square(7),
  };
  @override
  Day get dailySince => const Day(2026, 10, 15);

  @override
  InputMode get defaultInputMode => InputMode.palette;
  @override
  bool get supportsModeSwitch => false;
  @override
  bool get supportsPencil => true;
  @override
  bool get highlightSameValue => true;
  @override
  bool get highlightPeers => true;
  @override
  bool get showLockIcon => false;
  @override
  double get gapRatio => 0.04;

  static const _all = [
    ValueSpec.text('1'), ValueSpec.text('2'), ValueSpec.text('3'), //
    ValueSpec.text('4'), ValueSpec.text('5'), ValueSpec.text('6'),
    ValueSpec.text('7'), ValueSpec.text('8'), ValueSpec.text('9'),
  ];

  @override
  List<ValueSpec> get values => _all;

  @override
  List<ValueSpec> valuesFor(CagesPuzzle puzzle) => _all.sublist(0, puzzle.n);

  @override
  Iterable<Pos> markPeers(CagesPuzzle puzzle, Pos pos) => [
    for (var k = 0; k < puzzle.n; k++) ...[if (k != pos.c) Pos(pos.r, k), if (k != pos.r) Pos(k, pos.c)],
  ];

  @override
  Widget buildValue(BuildContext context, CagesPuzzle puzzle, ValueGrid state, Pos pos, CellValue cell, double size) {
    final scheme = Theme.of(context).colorScheme;
    final dark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: EdgeInsets.only(top: size * 0.16),
      child: Text(
        '${cell.value! + 1}',
        style: TextStyle(
          fontSize: size * 0.5,
          height: 1,
          fontWeight: cell.given ? FontWeight.w800 : FontWeight.w500,
          color: cell.given ? scheme.onSurface : (dark ? const Color(0xFF7CB6FF) : const Color(0xFF1F63D6)),
        ),
      ),
    );
  }

  /// Notes in three columns below the clue band.
  @override
  Widget buildMarks(BuildContext context, Set<int> marks, double size) {
    final top = size * (_clueBand + 0.04);
    final w = size / 3, h = (size - top) / 3;
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        children: [
          for (final m in marks)
            Positioned(
              left: (m % 3) * w,
              top: top + (m ~/ 3) * h,
              width: w,
              height: h,
              child: Center(
                child: FittedBox(child: Opacity(opacity: 0.85, child: values[m].build(context, h * 1.3))),
              ),
            ),
        ],
      ),
    );
  }

  @override
  CagesPuzzle generate(GenParams params) => generateCages(params);

  @override
  bool isSolved(CagesPuzzle puzzle, ValueGrid state) => state.isFull && cagesConflicts(puzzle, state.toFlat()).isEmpty;

  @override
  Set<Pos> conflicts(CagesPuzzle puzzle, ValueGrid state) => {
    for (final i in cagesConflicts(puzzle, state.toFlat())) puzzle.size.pos(i),
  };

  @override
  List<Widget> buildOverlayIn(BuildContext context, CagesPuzzle puzzle, ValueGrid state, BoardMetrics m) {
    final theme = Theme.of(context);
    final on = theme.colorScheme.onSurface;
    final g = state.toFlat();
    Widget label(Cage cage) {
      final done = cage.cells.every((i) => g[i] >= 0) && cage.holds([for (final i in cage.cells) g[i] + 1]);
      final at = puzzle.size.pos(cage.cells.first);
      return Positioned(
        left: m.x(at.c) + m.cell * 0.07,
        top: m.y(at.r) + m.cell * 0.04,
        width: m.cell * 0.9,
        height: m.cell * _clueBand,
        child: IgnorePointer(
          child: Align(
            alignment: Alignment.topLeft,
            child: FittedBox(
              child: AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 200),
                style: theme.textTheme.bodySmall!.copyWith(
                  fontSize: m.cell * 0.24,
                  height: 1,
                  fontWeight: FontWeight.w700,
                  color: on.withValues(alpha: done ? 0.35 : 0.9),
                ),
                child: Text(cage.clue),
              ),
            ),
          ),
        ),
      );
    }

    return [
      RegionBorders(metrics: m, regionOf: (i) => puzzle.cageOf[i], color: on),
      for (final cage in puzzle.cages) label(cage),
    ];
  }

  @override
  bool get canExplain => true;

  @override
  Explanation? explain(CagesPuzzle puzzle, ValueGrid state) => explainStep(const CagesExplainer(), puzzle, state);

  @override
  Map<String, dynamic> encodePuzzle(CagesPuzzle puzzle) => puzzle.toJson();
  @override
  CagesPuzzle decodePuzzle(Map<String, dynamic> json) => CagesPuzzle.fromJson(json);
}
