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
import 'signs_explain.dart';
import 'signs_generator.dart';
import 'signs_model.dart';
import 'signs_tutorial.dart';

/// A Latin square with signs between neighbouring cells, each pointing at
/// the smaller number.
class SignsType extends ValueGridType<SignsPuzzle> {
  const SignsType();

  @override
  String get id => 'signs';
  @override
  String name(AppLocalizations l) => l.signsName;
  @override
  String tagline(AppLocalizations l) => l.signsTagline;
  @override
  IconData get icon => Icons.code_rounded;
  @override
  Color get accent => const Color(0xFF4FC3E8);

  @override
  String rulesText(AppLocalizations l) => l.signsRules;

  @override
  List<TutorialStep> tutorial() => signsTutorial;
  @override
  List<TutorialStep> strategies() => signsStrategies;

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

  /// Room between cells for the signs.
  @override
  double get gapRatio => 0.18;

  static const _all = [
    ValueSpec.text('1'), ValueSpec.text('2'), ValueSpec.text('3'), //
    ValueSpec.text('4'), ValueSpec.text('5'), ValueSpec.text('6'),
    ValueSpec.text('7'), ValueSpec.text('8'), ValueSpec.text('9'),
  ];

  @override
  List<ValueSpec> get values => _all;

  @override
  List<ValueSpec> valuesFor(SignsPuzzle puzzle) => _all.sublist(0, puzzle.n);

  @override
  Iterable<Pos> markPeers(SignsPuzzle puzzle, Pos pos) => [
    for (var k = 0; k < puzzle.n; k++) ...[if (k != pos.c) Pos(pos.r, k), if (k != pos.r) Pos(k, pos.c)],
  ];

  @override
  Widget buildValue(BuildContext context, SignsPuzzle puzzle, ValueGrid state, Pos pos, CellValue cell, double size) {
    final scheme = Theme.of(context).colorScheme;
    final dark = Theme.of(context).brightness == Brightness.dark;
    return Text(
      '${cell.value! + 1}',
      style: TextStyle(
        fontSize: size * 0.55,
        height: 1,
        fontWeight: cell.given ? FontWeight.w800 : FontWeight.w500,
        color: cell.given ? scheme.onSurface : (dark ? const Color(0xFF7CB6FF) : const Color(0xFF1F63D6)),
      ),
    );
  }

  @override
  SignsPuzzle generate(GenParams params) => generateSigns(params);

  @override
  bool isSolved(SignsPuzzle puzzle, ValueGrid state) => state.isFull && signsConflicts(puzzle, state.toFlat()).isEmpty;

  @override
  Set<Pos> conflicts(SignsPuzzle puzzle, ValueGrid state) => {
    for (final i in signsConflicts(puzzle, state.toFlat())) puzzle.size.pos(i),
  };

  @override
  List<Widget> buildOverlayIn(BuildContext context, SignsPuzzle puzzle, ValueGrid state, BoardMetrics m) => [
    Positioned.fill(
      child: IgnorePointer(
        child: CustomPaint(
          painter: _SignsPainter(puzzle, state.toFlat(), m, Theme.of(context).colorScheme.onSurface),
        ),
      ),
    ),
  ];

  @override
  bool get canExplain => true;

  @override
  Explanation? explain(SignsPuzzle puzzle, ValueGrid state) => explainStep(const SignsExplainer(), puzzle, state);

  @override
  Map<String, dynamic> encodePuzzle(SignsPuzzle puzzle) => puzzle.toJson();
  @override
  SignsPuzzle decodePuzzle(Map<String, dynamic> json) => SignsPuzzle.fromJson(json);
}

/// Each sign as a chevron in the gap between its cells, its point at the
/// smaller one; signs whose cells already agree with it fade.
class _SignsPainter extends CustomPainter {
  _SignsPainter(this.puzzle, this.grid, this.m, this.color);

  final SignsPuzzle puzzle;
  final List<int> grid;
  final BoardMetrics m;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final pos = puzzle.size.pos;
    final reach = m.cell * 0.11, spread = m.cell * 0.13;
    for (final s in puzzle.signs) {
      final lo = pos(s.lo), hi = pos(s.hi);
      final a = m.center(lo), b = m.center(hi);
      final mid = (a + b) / 2;
      // Unit vector from the smaller cell to the bigger one, and across it.
      final along = (b - a) / (b - a).distance, across = Offset(-along.dy, along.dx);
      final tip = mid - along * reach, back = mid + along * reach;
      final done = grid[s.lo] >= 0 && grid[s.hi] >= 0 && grid[s.lo] < grid[s.hi];
      final paint = Paint()
        ..color = color.withValues(alpha: done ? 0.3 : 0.85)
        ..style = PaintingStyle.stroke
        ..strokeWidth = (m.cell * 0.065).clamp(1.5, 5.0)
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round;
      canvas.drawPath(
        Path()
          ..moveTo(back.dx + across.dx * spread, back.dy + across.dy * spread)
          ..lineTo(tip.dx, tip.dy)
          ..lineTo(back.dx - across.dx * spread, back.dy - across.dy * spread),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_SignsPainter old) =>
      old.puzzle != puzzle || old.m.cell != m.cell || old.color != color || !_same(old.grid, grid);

  static bool _same(List<int> a, List<int> b) {
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}
