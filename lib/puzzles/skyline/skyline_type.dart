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
import 'skyline_explain.dart';
import 'skyline_generator.dart';
import 'skyline_model.dart';
import 'skyline_tutorial.dart';

/// Towers of 1..n floors, each height once per row and column; the clues
/// around say how many towers can be seen from there.
class SkylineType extends ValueGridType<SkylinePuzzle> {
  const SkylineType();

  static const _accent = Color(0xFF3FB8AF);

  @override
  String get id => 'skyline';
  @override
  String name(AppLocalizations l) => l.skylineName;
  @override
  String tagline(AppLocalizations l) => l.skylineTagline;
  @override
  IconData get icon => Icons.location_city_rounded;
  @override
  Color get accent => _accent;

  @override
  String rulesText(AppLocalizations l) => l.skylineRules;

  @override
  List<TutorialStep> tutorial() => skylineTutorial;
  @override
  List<TutorialStep> strategies() => skylineStrategies;

  @override
  List<GridSize> get sizes => [for (var n = 4; n <= 7; n++) GridSize.square(n)];
  @override
  GridSize get defaultSize => const GridSize.square(5);
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
  double get gapRatio => 0.05;

  static const _all = [
    ValueSpec.text('1'), ValueSpec.text('2'), ValueSpec.text('3'), ValueSpec.text('4'), //
    ValueSpec.text('5'), ValueSpec.text('6'), ValueSpec.text('7'),
  ];

  @override
  List<ValueSpec> get values => _all;

  @override
  List<ValueSpec> valuesFor(SkylinePuzzle puzzle) => _all.sublist(0, puzzle.n);

  @override
  Iterable<Pos> markPeers(SkylinePuzzle puzzle, Pos pos) => [
    for (var k = 0; k < puzzle.n; k++) ...[if (k != pos.c) Pos(pos.r, k), if (k != pos.r) Pos(k, pos.c)],
  ];

  /// A tower: a bar as tall as its height behind the digit.
  @override
  Widget buildValue(BuildContext context, SkylinePuzzle puzzle, ValueGrid state, Pos pos, CellValue cell, double size) {
    final scheme = Theme.of(context).colorScheme;
    final dark = Theme.of(context).brightness == Brightness.dark;
    final h = cell.value!;
    return SizedBox.square(
      dimension: size,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            width: size * 0.8,
            height: size * 0.8 * (h + 1) / puzzle.n,
            margin: EdgeInsets.only(bottom: size * 0.1),
            decoration: BoxDecoration(
              color: _accent.withValues(alpha: dark ? 0.22 : 0.26),
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(size * 0.06),
                bottom: Radius.circular(size * 0.1),
              ),
            ),
          ),
          Center(
            child: Text(
              '${h + 1}',
              style: TextStyle(
                fontSize: size * 0.56,
                height: 1,
                fontWeight: cell.given ? FontWeight.w800 : FontWeight.w500,
                color: cell.given ? scheme.onSurface : _entryColor(context),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  SkylinePuzzle generate(GenParams params) => generateSkyline(params);

  @override
  bool isSolved(SkylinePuzzle puzzle, ValueGrid state) =>
      state.isFull && skylineConflicts(puzzle, state.toFlat()).isEmpty;

  @override
  Set<Pos> conflicts(SkylinePuzzle puzzle, ValueGrid state) => {
    for (final i in skylineConflicts(puzzle, state.toFlat())) puzzle.size.pos(i),
  };

  @override
  (double, double) header(SkylinePuzzle puzzle) => (0.7, 0.7);
  @override
  (double, double) footer(SkylinePuzzle puzzle) => (0.7, 0.7);

  @override
  List<Widget> buildOverlayIn(BuildContext context, SkylinePuzzle puzzle, ValueGrid state, BoardMetrics m) {
    final theme = Theme.of(context);
    final on = theme.colorScheme.onSurface;
    final n = puzzle.n, g = state.toFlat();
    Widget label(int side, int k) {
      final want = puzzle.clue(side, k);
      final line = skylineLine(n, side, k);
      final done = want != null && line.every((i) => g[i] >= 0) && skylineVisible(line.map((i) => g[i])) == want;
      final along = side < 2 ? m.x(k) : m.y(k);
      final rect = switch (side) {
        skylineTop => Rect.fromLTWH(along, 0, m.cell, m.oy - m.gap),
        skylineBottom => Rect.fromLTWH(along, m.height + m.gap, m.cell, m.ey - m.gap),
        skylineLeft => Rect.fromLTWH(0, along, m.ox - m.gap, m.cell),
        _ => Rect.fromLTWH(m.width + m.gap, along, m.ex - m.gap, m.cell),
      };
      return Positioned.fromRect(
        rect: rect,
        child: Center(
          child: AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 200),
            style: theme.textTheme.bodyLarge!.copyWith(
              fontSize: m.cell * 0.42,
              fontWeight: FontWeight.w700,
              color: on.withValues(alpha: done ? 0.3 : 0.85),
            ),
            child: Text(want == null ? '' : '$want'),
          ),
        ),
      );
    }

    return [
      for (var side = 0; side < 4; side++)
        for (var k = 0; k < n; k++) label(side, k),
    ];
  }

  @override
  bool get canExplain => true;

  @override
  Explanation? explain(SkylinePuzzle puzzle, ValueGrid state) => explainStep(const SkylineExplainer(), puzzle, state);

  @override
  Map<String, dynamic> encodePuzzle(SkylinePuzzle puzzle) => puzzle.toJson();
  @override
  SkylinePuzzle decodePuzzle(Map<String, dynamic> json) => SkylinePuzzle.fromJson(json);

  static Color _entryColor(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? const Color(0xFF7CB6FF) : const Color(0xFF1F63D6);
}
