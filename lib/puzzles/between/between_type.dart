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
import 'between_explain.dart';
import 'between_generator.dart';
import 'between_model.dart';
import 'between_tutorial.dart';

/// Two shaded cells and the numbers 1..n−2 in every row and column; the
/// clues say what the numbers between the two shaded cells add up to.
class BetweenType extends ValueGridType<BetweenPuzzle> {
  const BetweenType();

  static const _accent = Color(0xFFE08A5B);
  static const shadeLight = Color(0xFF4A3A33);
  static const shadeDark = Color(0xFF8A6A58);

  static Color shadeOf(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? shadeDark : shadeLight;

  @override
  String get id => 'between';
  @override
  String name(AppLocalizations l) => l.betweenName;
  @override
  String tagline(AppLocalizations l) => l.betweenTagline;
  @override
  IconData get icon => Icons.data_array_rounded;
  @override
  Color get accent => _accent;

  @override
  String rulesText(AppLocalizations l) => l.betweenRules;

  @override
  List<TutorialStep> tutorial() => betweenTutorial;
  @override
  List<TutorialStep> strategies() => betweenStrategies;

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
    ValueSpec.custom(
      (context, size) => Container(
        width: size * 0.7,
        height: size * 0.7,
        decoration: BoxDecoration(color: shadeOf(context), borderRadius: BorderRadius.circular(size * 0.12)),
      ),
      label: 'shade',
    ),
    for (var d = 1; d <= 7; d++) ValueSpec.text('$d'),
  ];

  @override
  List<ValueSpec> get values => _all;

  @override
  List<ValueSpec> valuesFor(BetweenPuzzle puzzle) => _all.sublist(0, puzzle.n - 1);

  @override
  Iterable<Pos> markPeers(BetweenPuzzle puzzle, Pos pos) => [
    for (var k = 0; k < puzzle.n; k++) ...[if (k != pos.c) Pos(pos.r, k), if (k != pos.r) Pos(k, pos.c)],
  ];

  @override
  Widget buildValue(BuildContext context, BetweenPuzzle puzzle, ValueGrid state, Pos pos, CellValue cell, double size) {
    final v = cell.value!;
    if (v == betweenShade) return SizedBox.square(dimension: size);
    return Center(
      child: Text(
        '$v',
        style: TextStyle(
          fontSize: size * 0.56,
          height: 1,
          fontWeight: cell.given ? FontWeight.w800 : FontWeight.w500,
          color: cell.given ? Theme.of(context).colorScheme.onSurface : _entryColor(context),
        ),
      ),
    );
  }

  @override
  Color? cellColor(BuildContext context, BetweenPuzzle puzzle, Pos pos, CellValue cell) =>
      cell.value == betweenShade ? shadeOf(context) : null;

  @override
  BetweenPuzzle generate(GenParams params) => generateBetween(params);

  @override
  bool isSolved(BetweenPuzzle puzzle, ValueGrid state) =>
      state.isFull && betweenConflicts(puzzle, state.toFlat()).isEmpty;

  @override
  Set<Pos> conflicts(BetweenPuzzle puzzle, ValueGrid state) => {
    for (final i in betweenConflicts(puzzle, state.toFlat())) puzzle.size.pos(i),
  };

  @override
  (double, double) header(BetweenPuzzle puzzle) => (0.75, 0.75);

  @override
  List<Widget> buildOverlayIn(BuildContext context, BetweenPuzzle puzzle, ValueGrid state, BoardMetrics m) {
    final theme = Theme.of(context);
    final on = theme.colorScheme.onSurface;
    final n = puzzle.n, g = state.toFlat();
    final lines = betweenLines(n);
    Widget label(int u) {
      final want = puzzle.clues[u];
      final line = lines[u];
      final values = [for (final i in line) g[i]];
      final shaded = [
        for (var x = 0; x < n; x++)
          if (values[x] == betweenShade) x,
      ];
      final done =
          want != null &&
          shaded.length == 2 &&
          values.sublist(shaded[0] + 1, shaded[1]).every((v) => v > 0) &&
          betweenSum(values) == want;
      final k = u % n;
      final rect = u < n
          ? Rect.fromLTWH(0, m.y(k), m.ox - m.gap, m.cell)
          : Rect.fromLTWH(m.x(k), 0, m.cell, m.oy - m.gap);
      return Positioned.fromRect(
        rect: rect,
        child: Center(
          child: AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 200),
            style: theme.textTheme.bodyLarge!.copyWith(
              fontSize: m.cell * (want != null && want >= 10 ? 0.38 : 0.42),
              fontWeight: FontWeight.w700,
              color: on.withValues(alpha: done ? 0.3 : 0.85),
            ),
            child: Text(want == null ? '' : '$want'),
          ),
        ),
      );
    }

    return [for (var u = 0; u < 2 * n; u++) label(u)];
  }

  @override
  bool get canExplain => true;

  @override
  Explanation? explain(BetweenPuzzle puzzle, ValueGrid state, {Set<int> prefer = const {}}) =>
      explainStep(const BetweenExplainer(), puzzle, state, prefer: prefer);

  @override
  Map<String, dynamic> encodePuzzle(BetweenPuzzle puzzle) => puzzle.toJson();
  @override
  BetweenPuzzle decodePuzzle(Map<String, dynamic> json) => BetweenPuzzle.fromJson(json);

  static Color _entryColor(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? const Color(0xFF7CB6FF) : const Color(0xFF1F63D6);
}
