import 'package:flutter/material.dart';

import '../../core/day.dart';
import '../../core/difficulty.dart';
import '../../core/explain.dart';
import '../../core/grid.dart';
import '../../core/tutorial.dart';
import '../../core/value_grid.dart';
import '../../l10n/l10n.dart';
import '../../ui/board/cell_grid_board.dart';
import 'slant_explain.dart';
import 'slant_generator.dart';
import 'slant_model.dart';
import 'slant_tutorial.dart';

/// Twigs: a diagonal in every cell, numbers on the corners count the
/// diagonals touching them, and no loop anywhere.
class SlantType extends ValueGridType<SlantPuzzle> {
  const SlantType();

  @override
  String get id => 'slant';
  @override
  String name(AppLocalizations l) => l.slantName;
  @override
  String tagline(AppLocalizations l) => l.slantTagline;
  @override
  IconData get icon => Icons.call_split_rounded;
  @override
  Color get accent => const Color(0xFFA5D66F);

  @override
  String rulesText(AppLocalizations l) => l.slantRules;

  @override
  List<TutorialStep> tutorial() => slantTutorial;
  @override
  List<TutorialStep> strategies() => slantStrategies;

  @override
  List<GridSize> get sizes => const [
    GridSize.square(4),
    GridSize.square(5),
    GridSize.square(6),
    GridSize.square(7),
    GridSize.square(8),
    GridSize.square(9),
    GridSize.square(10),
  ];
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
  List<ValueSpec> get values => [
    ValueSpec.custom(
      (context, size) => _Diagonal(value: slBack, size: size, inset: 0.18),
      label: r'\',
    ),
    ValueSpec.custom(
      (context, size) => _Diagonal(value: slFwd, size: size, inset: 0.18),
      label: '/',
    ),
  ];

  @override
  bool get showLockIcon => false;

  @override
  double get gapRatio => 0.06;

  // Room for the numbers on the outer corners.
  @override
  (double, double) header(SlantPuzzle puzzle) => (0.3, 0.3);
  @override
  (double, double) footer(SlantPuzzle puzzle) => (0.3, 0.3);

  @override
  Widget buildValue(
    BuildContext context,
    SlantPuzzle puzzle,
    ValueGrid state,
    Pos pos,
    CellValue cell,
    double size,
  ) {
    // Corner to corner of the lattice, across the gaps between cells.
    final reach = size * (1 + gapRatio);
    return OverflowBox(
      maxWidth: reach,
      maxHeight: reach,
      child: _Diagonal(value: cell.value!, size: reach, inset: 0, given: cell.given),
    );
  }

  @override
  SlantPuzzle generate(GenParams params) => generateSlant(params);

  @override
  bool isSolved(SlantPuzzle puzzle, ValueGrid state) => slantSolved(puzzle, state.toFlat());

  @override
  Set<Pos> conflicts(SlantPuzzle puzzle, ValueGrid state) => {
    for (final i in slantConflicts(puzzle, state.toFlat())) puzzle.size.pos(i),
  };

  @override
  List<Widget> buildOverlayIn(BuildContext context, SlantPuzzle puzzle, ValueGrid state, BoardMetrics m) => [
    Positioned.fill(
      child: CustomPaint(
        painter: _CornersPainter(
          puzzle: puzzle,
          values: state.toFlat(),
          m: m,
          ink: Theme.of(context).colorScheme.onSurface,
          fill: Theme.of(context).colorScheme.surface,
          style: Theme.of(context).textTheme.bodyLarge!,
        ),
      ),
    ),
  ];

  @override
  bool get canExplain => true;

  @override
  Explanation? explain(SlantPuzzle puzzle, ValueGrid state, {Set<int> prefer = const {}}) =>
      explainStep(const SlantExplainer(), puzzle, state, prefer: prefer);

  @override
  Map<String, dynamic> encodePuzzle(SlantPuzzle puzzle) => puzzle.toJson();
  @override
  SlantPuzzle decodePuzzle(Map<String, dynamic> json) => SlantPuzzle.fromJson(json);
}

/// One diagonal in a [size] square, [inset] (share of the size) from its
/// corners.
class _Diagonal extends StatelessWidget {
  const _Diagonal({required this.value, required this.size, required this.inset, this.given = false});

  final int value;
  final double size;
  final double inset;
  final bool given;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return CustomPaint(
      size: Size.square(size),
      painter: _DiagonalPainter(value, inset, given ? scheme.primary : scheme.onSurface.withValues(alpha: 0.85)),
    );
  }
}

class _DiagonalPainter extends CustomPainter {
  _DiagonalPainter(this.value, this.inset, this.color);

  final int value;
  final double inset;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width, a = s * inset, b = s - a;
    final paint = Paint()
      ..color = color
      ..strokeWidth = s * 0.095
      ..strokeCap = StrokeCap.round;
    if (value == slBack) {
      canvas.drawLine(Offset(a, a), Offset(b, b), paint);
    } else {
      canvas.drawLine(Offset(b, a), Offset(a, b), paint);
    }
  }

  @override
  bool shouldRepaint(_DiagonalPainter old) => old.value != value || old.inset != inset || old.color != color;
}

/// The numbers on the corners, in rings; a number fades once its cells are
/// all filled and it is met.
class _CornersPainter extends CustomPainter {
  _CornersPainter({
    required this.puzzle,
    required this.values,
    required this.m,
    required this.ink,
    required this.fill,
    required this.style,
  });

  final SlantPuzzle puzzle;
  final List<int> values;
  final BoardMetrics m;
  final Color ink;
  final Color fill;
  final TextStyle style;

  @override
  void paint(Canvas canvas, Size size) {
    final g = puzzle.geo;
    final radius = m.cell * 0.24;
    for (var k = 0; k < g.corners; k++) {
      final want = puzzle.clues[k];
      if (want < 0) continue;
      var touch = 0, open = 0;
      for (final (i, v) in g.cornerCells[k]) {
        if (values[i] < 0) {
          open++;
        } else if (values[i] == v) {
          touch++;
        }
      }
      final alpha = open == 0 && touch == want ? 0.4 : 1.0;
      final at = Offset(m.x(k % g.w) - m.gap / 2, m.y(k ~/ g.w) - m.gap / 2);
      canvas.drawCircle(at, radius, Paint()..color = fill);
      canvas.drawCircle(
        at,
        radius,
        Paint()
          ..color = ink.withValues(alpha: 0.8 * alpha)
          ..style = PaintingStyle.stroke
          ..strokeWidth = m.cell * 0.035,
      );
      final text = TextPainter(
        text: TextSpan(
          text: '$want',
          style: style.copyWith(
            fontSize: radius * 1.35,
            height: 1,
            fontWeight: FontWeight.w700,
            color: ink.withValues(alpha: alpha),
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      text.paint(canvas, at - Offset(text.width / 2, text.height / 2));
    }
  }

  @override
  bool shouldRepaint(_CornersPainter old) => true;
}
