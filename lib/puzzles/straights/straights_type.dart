import 'package:flutter/material.dart';

import '../../core/day.dart';
import '../../core/difficulty.dart';
import '../../core/explain.dart';
import '../../core/grid.dart';
import '../../core/puzzle_type.dart';
import '../../core/tutorial.dart';
import '../../core/value_grid.dart';
import '../../l10n/l10n.dart';
import 'straights_explain.dart';
import 'straights_generator.dart';
import 'straights_model.dart';
import 'straights_tutorial.dart';

/// The numbers 1..n, none twice in a row or column; walls split the lines
/// into runs, and every run holds consecutive numbers.
class StraightsType extends ValueGridType<StraightsPuzzle> {
  const StraightsType();

  static const _wallLight = Color(0xFF2E3440);
  static const _wallDark = Color(0xFF08090C);

  @override
  String get id => 'straights';
  @override
  String name(AppLocalizations l) => l.straightsName;
  @override
  String tagline(AppLocalizations l) => l.straightsTagline;
  @override
  IconData get icon => Icons.stairs_rounded;
  @override
  Color get accent => const Color(0xFF9C8CE8);

  @override
  String rulesText(AppLocalizations l) => l.straightsRules;

  @override
  List<TutorialStep> tutorial() => straightsTutorial;
  @override
  List<TutorialStep> strategies() => straightsStrategies;

  @override
  List<GridSize> get sizes => [for (var n = 5; n <= 9; n++) GridSize.square(n)];
  @override
  GridSize get defaultSize => const GridSize.square(7);
  @override
  GridSize dailySize(Difficulty difficulty) => switch (difficulty) {
    Difficulty.easy => const GridSize.square(6),
    Difficulty.medium => const GridSize.square(7),
    _ => const GridSize.square(8),
  };
  @override
  Day get dailySince => const Day(2026, 11, 12);

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
  double get gapRatio => 0.05;

  static final _all = [
    for (var d = 1; d <= 9; d++) ValueSpec.text('$d'),
    ValueSpec.custom((context, size) => const SizedBox.shrink(), label: 'wall'),
  ];

  @override
  List<ValueSpec> get values => _all;

  @override
  List<ValueSpec> valuesFor(StraightsPuzzle puzzle) => _all.sublist(0, puzzle.n);

  @override
  Iterable<Pos> markPeers(StraightsPuzzle puzzle, Pos pos) {
    if (puzzle.dark[puzzle.size.index(pos)]) return const [];
    return [
      for (var k = 0; k < puzzle.n; k++) ...[
        if (k != pos.c && !puzzle.dark[pos.r * puzzle.n + k]) Pos(pos.r, k),
        if (k != pos.r && !puzzle.dark[k * puzzle.n + pos.c]) Pos(k, pos.c),
      ],
    ];
  }

  @override
  StraightsPuzzle generate(GenParams params) => generateStraights(params);

  @override
  bool isSolved(StraightsPuzzle puzzle, ValueGrid state) =>
      state.isFull && straightsConflicts(puzzle, state.toFlat()).isEmpty;

  @override
  Set<Pos> conflicts(StraightsPuzzle puzzle, ValueGrid state) => {
    for (final i in straightsConflicts(puzzle, state.toFlat())) puzzle.size.pos(i),
  };

  @override
  Color? cellColorIn(BuildContext context, StraightsPuzzle puzzle, ValueGrid state, Pos pos, CellValue cell) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    if (puzzle.dark[puzzle.size.index(pos)]) return dark ? _wallDark : _wallLight;
    // In the dark theme open cells are lifted, so the walls read as solid blocks.
    return dark ? Theme.of(context).colorScheme.surfaceContainerHighest : null;
  }

  @override
  Widget buildValue(
    BuildContext context,
    StraightsPuzzle puzzle,
    ValueGrid state,
    Pos pos,
    CellValue cell,
    double size,
  ) {
    final i = puzzle.size.index(pos);
    final scheme = Theme.of(context).colorScheme;
    final dark = Theme.of(context).brightness == Brightness.dark;
    if (puzzle.dark[i]) {
      final clue = puzzle.clues[i];
      return SizedBox.square(
        dimension: size,
        child: clue == null
            ? null
            : Center(
                child: Text(
                  '${clue + 1}',
                  style: TextStyle(
                    fontSize: size * 0.52,
                    height: 1,
                    fontWeight: FontWeight.w800,
                    color: Colors.white.withValues(alpha: 0.92),
                  ),
                ),
              ),
      );
    }
    return Text(
      '${cell.value! + 1}',
      style: TextStyle(
        fontSize: size * 0.56,
        height: 1,
        fontWeight: cell.given ? FontWeight.w800 : FontWeight.w500,
        color: cell.given ? scheme.onSurface : (dark ? const Color(0xFF7CB6FF) : const Color(0xFF1F63D6)),
      ),
    );
  }

  @override
  bool get canExplain => true;

  @override
  Explanation? explain(StraightsPuzzle puzzle, ValueGrid state, {Set<int> prefer = const {}}) =>
      explainStep(const StraightsExplainer(), puzzle, state, prefer: prefer);

  @override
  Map<String, dynamic> encodePuzzle(StraightsPuzzle puzzle) => puzzle.toJson();
  @override
  StraightsPuzzle decodePuzzle(Map<String, dynamic> json) => StraightsPuzzle.fromJson(json);
}
