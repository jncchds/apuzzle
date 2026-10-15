import 'package:flutter/material.dart';

import '../../core/day.dart';
import '../../core/difficulty.dart';
import '../../core/explain.dart';
import '../../core/grid.dart';
import '../../core/puzzle_type.dart';
import '../../core/tutorial.dart';
import '../../core/value_grid.dart';
import '../../l10n/l10n.dart';
import 'totals_explain.dart';
import 'totals_generator.dart';
import 'totals_model.dart';
import 'totals_tutorial.dart';

/// A crossword of digits: every run adds up to the clue before it, with no
/// digit twice.
class TotalsType extends ValueGridType<TotalsPuzzle> {
  const TotalsType();

  static const _blockLight = Color(0xFF2E3440);
  static const _blockDark = Color(0xFF08090C);

  @override
  String get id => 'totals';
  @override
  String name(AppLocalizations l) => l.totalsName;
  @override
  String tagline(AppLocalizations l) => l.totalsTagline;
  @override
  IconData get icon => Icons.functions_rounded;
  @override
  Color get accent => const Color(0xFF5FC3B4);

  @override
  String rulesText(AppLocalizations l) => l.totalsRules;

  @override
  List<TutorialStep> tutorial() => totalsTutorial;
  @override
  List<TutorialStep> strategies() => totalsStrategies;

  @override
  List<GridSize> get sizes => [for (var n = 6; n <= 10; n++) GridSize.square(n)];
  @override
  GridSize get defaultSize => const GridSize.square(8);
  @override
  GridSize dailySize(Difficulty difficulty) => switch (difficulty) {
    Difficulty.easy => const GridSize.square(7),
    Difficulty.medium => const GridSize.square(8),
    _ => const GridSize.square(9),
  };
  @override
  Day get dailySince => const Day(2026, 10, 16);

  @override
  InputMode get defaultInputMode => InputMode.palette;
  @override
  bool get supportsModeSwitch => false;
  @override
  bool get supportsPencil => true;
  @override
  bool get highlightPeers => true;
  @override
  bool get showLockIcon => false;
  @override
  double get gapRatio => 0.05;

  static final _all = [
    for (var d = 1; d <= 9; d++) ValueSpec.text('$d'),
    ValueSpec.custom((context, size) => const SizedBox.shrink(), label: 'clue'),
  ];

  @override
  List<ValueSpec> get values => _all;

  @override
  List<ValueSpec> valuesFor(TotalsPuzzle puzzle) => _all.sublist(0, 9);

  @override
  Iterable<Pos> markPeers(TotalsPuzzle puzzle, Pos pos) {
    final i = puzzle.size.index(pos);
    if (puzzle.isBlock(i)) return const [];
    return [
      for (final x in [puzzle.acrossOf[i], puzzle.downOf[i]])
        for (final j in puzzle.runs[x].cells)
          if (j != i) puzzle.size.pos(j),
    ];
  }

  @override
  TotalsPuzzle generate(GenParams params) => generateTotals(params);

  @override
  bool isSolved(TotalsPuzzle puzzle, ValueGrid state) =>
      state.isFull && totalsConflicts(puzzle, state.toFlat()).isEmpty;

  @override
  Set<Pos> conflicts(TotalsPuzzle puzzle, ValueGrid state) => {
    for (final i in totalsConflicts(puzzle, state.toFlat())) puzzle.size.pos(i),
  };

  @override
  Color? cellColorIn(BuildContext context, TotalsPuzzle puzzle, ValueGrid state, Pos pos, CellValue cell) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    if (puzzle.isBlock(puzzle.size.index(pos))) return dark ? _blockDark : _blockLight;
    // In the dark theme open cells are lifted, so the clue cells read as solid blocks.
    return dark ? Theme.of(context).colorScheme.surfaceContainerHighest : null;
  }

  @override
  Widget buildValue(BuildContext context, TotalsPuzzle puzzle, ValueGrid state, Pos pos, CellValue cell, double size) {
    final i = puzzle.size.index(pos);
    if (puzzle.isBlock(i)) return _clue(context, puzzle, state, i, size);
    final scheme = Theme.of(context).colorScheme;
    final dark = Theme.of(context).brightness == Brightness.dark;
    return Text(
      '${cell.value! + 1}',
      style: TextStyle(
        fontSize: size * 0.52,
        height: 1,
        fontWeight: cell.given ? FontWeight.w800 : FontWeight.w500,
        color: cell.given ? scheme.onSurface : (dark ? const Color(0xFF7CB6FF) : const Color(0xFF1F63D6)),
      ),
    );
  }

  /// A clue cell: a diagonal, the sum across top right, the sum down bottom
  /// left. A sum fades once its run is full and adds up.
  Widget _clue(BuildContext context, TotalsPuzzle puzzle, ValueGrid state, int i, double size) {
    final across = puzzle.acrossFrom[i], down = puzzle.downFrom[i];
    if (across < 0 && down < 0) return SizedBox(width: size, height: size);
    final g = state.toFlat();
    bool done(int x) {
      final run = puzzle.runs[x];
      final digits = [for (final j in run.cells) g[j] < 0 ? 0 : g[j] + 1];
      return !digits.contains(0) && totalsRunFits(run, digits);
    }

    final style = Theme.of(context).textTheme.bodySmall!.copyWith(
      fontSize: size * 0.3,
      height: 1,
      fontWeight: FontWeight.w700,
      color: Colors.white,
    );
    Widget sum(int x, Alignment at) => Align(
      alignment: at,
      child: SizedBox(
        width: size * 0.5,
        height: size * 0.42,
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 200),
            opacity: done(x) ? 0.35 : 1,
            child: Text('${puzzle.runs[x].sum}', style: style),
          ),
        ),
      ),
    );

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        children: [
          Positioned.fill(child: CustomPaint(painter: _DiagonalPainter(Colors.white.withValues(alpha: 0.45)))),
          Padding(
            padding: EdgeInsets.all(size * 0.06),
            child: Stack(
              children: [
                if (across >= 0) sum(across, Alignment.topRight),
                if (down >= 0) sum(down, Alignment.bottomLeft),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  bool get canExplain => true;

  @override
  Explanation? explain(TotalsPuzzle puzzle, ValueGrid state) => explainStep(const TotalsExplainer(), puzzle, state);

  @override
  Map<String, dynamic> encodePuzzle(TotalsPuzzle puzzle) => puzzle.toJson();
  @override
  TotalsPuzzle decodePuzzle(Map<String, dynamic> json) => TotalsPuzzle.fromJson(json);
}

/// The line from the top-left corner to the bottom-right one.
class _DiagonalPainter extends CustomPainter {
  _DiagonalPainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = size.width * 0.03;
    canvas.drawLine(Offset.zero, Offset(size.width, size.height), paint);
  }

  @override
  bool shouldRepaint(_DiagonalPainter old) => old.color != color;
}
