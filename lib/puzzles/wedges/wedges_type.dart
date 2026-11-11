import 'package:flutter/material.dart';

import '../../core/day.dart';
import '../../core/difficulty.dart';
import '../../core/explain.dart';
import '../../core/grid.dart';
import '../../core/tutorial.dart';
import '../../core/value_grid.dart';
import '../../l10n/l10n.dart';
import '../../ui/symbols.dart';
import 'wedges_explain.dart';
import 'wedges_generator.dart';
import 'wedges_model.dart';
import 'wedges_tutorial.dart';

/// Wedges: cut the open cells with half-cell wedges so that every open area
/// is a rectangle, upright or turned 45°.
class WedgesType extends ValueGridType<WedgesPuzzle> {
  const WedgesType();

  static const wallColor = Color(0xFF2E3440);
  static const darkWall = Color(0xFF08090C);

  @override
  String get id => 'wedges';
  @override
  String name(AppLocalizations l) => l.wedgesName;
  @override
  String tagline(AppLocalizations l) => l.wedgesTagline;
  @override
  IconData get icon => Icons.change_history_rounded;
  @override
  Color get accent => const Color(0xFF7E9CD8);

  @override
  String rulesText(AppLocalizations l) => l.wedgesRules;

  @override
  List<TutorialStep> tutorial() => wedgesTutorial;
  @override
  List<TutorialStep> strategies() => wedgesStrategies;

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
  Day get dailySince => const Day(2026, 11, 12);

  @override
  List<ValueSpec> get values => [
    for (final v in const [wedgeTL, wedgeTR, wedgeBR, wedgeBL])
      ValueSpec.custom(
        (context, size) => _Wedge(value: v, size: size, chip: true),
        label: 'wedge $v',
      ),
    ValueSpec.custom((context, size) => DotSymbol(size: size), label: 'dot'),
    ValueSpec.custom((context, size) => const SizedBox.shrink(), label: 'wall'),
  ];

  @override
  List<ValueSpec> valuesFor(WedgesPuzzle puzzle) => values.sublist(0, 5);

  @override
  bool get showLockIcon => false;
  @override
  double get gapRatio => 0.05;

  @override
  WedgesPuzzle generate(GenParams params) => generateWedges(params);

  List<int> _values(WedgesPuzzle p, ValueGrid s) => [
    for (var i = 0; i < s.cells.length; i++) p.isWall(i) ? wedgeWall : s.cells[i].value ?? -1,
  ];

  @override
  bool isComplete(WedgesPuzzle puzzle, ValueGrid state) =>
      state.cells.where((c) => c.value != null && isWedge(c.value!)).length == puzzle.wedges;

  @override
  bool isSolved(WedgesPuzzle puzzle, ValueGrid state) => wedgesSolved(puzzle, _values(puzzle, state));

  @override
  Set<Pos> conflicts(WedgesPuzzle puzzle, ValueGrid state) => {
    for (final i in wedgesConflicts(puzzle, _values(puzzle, state), complete: isComplete(puzzle, state)))
      puzzle.size.pos(i),
  };

  /// Dots in the empty cells beside walls whose number is met, and in those
  /// where no wedge fits with the cells round them.
  @override
  ValueGrid? markForbidden(WedgesPuzzle puzzle, ValueGrid state) {
    final g = puzzle.geo;
    final v = _values(puzzle, state);
    final out = <int>{};
    for (var i = 0; i < g.cells; i++) {
      final want = puzzle.clues[i];
      if (want >= 0 && wedgesAround(g, v, i) == want) out.addAll(g.sides[i]);
    }
    for (var i = 0; i < g.cells; i++) {
      if (v[i] != -1) continue;
      var fits = false;
      for (var w = 0; w < 4 && !fits; w++) {
        v[i] = w;
        fits = g.cellPoints[i].every((k) => g.pointFits(k, v));
      }
      v[i] = -1;
      if (!fits) out.add(i);
    }
    return dotted(state, out, wedgeDot);
  }

  @override
  Color? cellColorIn(BuildContext context, WedgesPuzzle puzzle, ValueGrid state, Pos pos, CellValue cell) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    if (puzzle.isWall(puzzle.size.index(pos))) return dark ? darkWall : wallColor;
    // In the dark theme open cells are lifted, so walls and wedges read as solid.
    return dark ? Theme.of(context).colorScheme.surfaceContainerHighest : null;
  }

  @override
  Widget buildValue(BuildContext context, WedgesPuzzle puzzle, ValueGrid state, Pos pos, CellValue cell, double size) {
    final i = puzzle.size.index(pos);
    if (puzzle.isWall(i)) {
      final n = puzzle.clues[i];
      if (n < 0) return const SizedBox.shrink();
      // A number fades once it has its wedges; a 0 (met from the start) once
      // the open cells beside it are dotted.
      final v = _values(puzzle, state), g = puzzle.geo;
      final met = n > 0 ? wedgesAround(g, v, i) == n : g.sides[i].every((j) => v[j] == wedgeDot || v[j] == wedgeWall);
      return Text(
        '$n',
        style: TextStyle(
          fontSize: size * 0.52,
          height: 1,
          fontWeight: FontWeight.w700,
          color: Colors.white.withValues(alpha: met ? 0.4 : 1),
        ),
      );
    }
    if (cell.value == wedgeDot) return DotSymbol(size: size);
    // Corner to corner of the cell, across the gaps round it.
    final reach = size * (1 + gapRatio);
    return OverflowBox(
      maxWidth: reach,
      maxHeight: reach,
      child: _Wedge(value: cell.value!, size: reach, given: cell.given),
    );
  }

  @override
  bool get canExplain => true;

  @override
  Explanation? explain(WedgesPuzzle puzzle, ValueGrid state) => explainStep(const WedgesExplainer(), puzzle, state);

  @override
  Map<String, dynamic> encodePuzzle(WedgesPuzzle puzzle) => puzzle.toJson();
  @override
  WedgesPuzzle decodePuzzle(Map<String, dynamic> json) => WedgesPuzzle.fromJson(json);
}

/// One wedge in a [size] square: on the board in the walls' color, as a
/// [chip] (palette, explain texts) in the text color with a faint outline
/// of the cell.
class _Wedge extends StatelessWidget {
  const _Wedge({required this.value, required this.size, this.chip = false, this.given = false});

  final int value;
  final double size;
  final bool chip;
  final bool given;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dark = theme.brightness == Brightness.dark;
    final color = chip
        ? theme.colorScheme.onSurface.withValues(alpha: 0.85)
        : given
        ? Color.lerp(dark ? WedgesType.darkWall : WedgesType.wallColor, theme.colorScheme.primary, 0.35)!
        : dark
        ? WedgesType.darkWall
        : WedgesType.wallColor;
    return CustomPaint(
      size: Size.square(size),
      painter: _WedgePainter(value, color, chip ? theme.colorScheme.onSurface.withValues(alpha: 0.35) : null),
    );
  }
}

class _WedgePainter extends CustomPainter {
  _WedgePainter(this.value, this.color, this.outline);

  final int value;
  final Color color;
  final Color? outline;

  @override
  void paint(Canvas canvas, Size size) {
    final inset = outline == null ? 0.0 : size.width * 0.12;
    final r = Offset(inset, inset) & Size(size.width - 2 * inset, size.height - 2 * inset);
    final corners = [r.topLeft, r.topRight, r.bottomRight, r.bottomLeft];
    final path = Path()
      ..moveTo(corners[value].dx, corners[value].dy)
      ..lineTo(corners[(value + 1) % 4].dx, corners[(value + 1) % 4].dy)
      ..lineTo(corners[(value + 3) % 4].dx, corners[(value + 3) % 4].dy)
      ..close();
    canvas.drawPath(path, Paint()..color = color);
    if (outline != null) {
      canvas.drawRect(
        r,
        Paint()
          ..color = outline!
          ..style = PaintingStyle.stroke
          ..strokeWidth = size.width * 0.05,
      );
    }
  }

  @override
  bool shouldRepaint(_WedgePainter old) => old.value != value || old.color != color || old.outline != outline;
}
