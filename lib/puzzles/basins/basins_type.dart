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
import '../../ui/board/cell_grid_board.dart';
import '../../ui/board/region_borders.dart';
import '../../ui/symbols.dart';
import 'basins_explain.dart';
import 'basins_generator.dart';
import 'basins_model.dart';
import 'basins_tutorial.dart';

/// Basins: fill the basins with level water to match the row and column counts.
class BasinsType extends ValueGridType<BasinsPuzzle> {
  const BasinsType();

  static const waterLight = Color(0xFF5AA9E6);
  static const waterDark = Color(0xFF2F6FA3);

  static Color waterColor(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? waterDark : waterLight;

  @override
  String get id => 'basins';
  @override
  String name(AppLocalizations l) => l.basinsName;
  @override
  String tagline(AppLocalizations l) => l.basinsTagline;
  @override
  IconData get icon => Icons.water_rounded;
  @override
  Color get accent => const Color(0xFF4FA3E0);

  @override
  String rulesText(AppLocalizations l) => l.basinsRules;

  @override
  List<TutorialStep> tutorial() => basinsTutorial;
  @override
  List<TutorialStep> strategies() => basinsStrategies;

  @override
  List<GridSize> get sizes => [for (var n = 6; n <= 10; n++) GridSize.square(n)];
  @override
  GridSize get defaultSize => const GridSize.square(8);
  @override
  GridSize dailySize(Difficulty difficulty) => switch (difficulty) {
    Difficulty.easy => const GridSize.square(6),
    Difficulty.medium => const GridSize.square(8),
    _ => const GridSize.square(9),
  };
  @override
  Day get dailySince => const Day(2026, 10, 15);
  @override
  double get minCellSize => 32;

  @override
  List<ValueSpec> get values => [
    ValueSpec.custom(
      (context, size) => SizedBox.square(
        dimension: size * 0.78,
        child: CustomPaint(painter: _WaterPainter(waterColor(context), surface: true, chip: true)),
      ),
      label: 'water',
    ),
    ValueSpec.custom((context, size) => DotSymbol(size: size), label: 'dry'),
  ];

  @override
  bool get showLockIcon => false;
  @override
  double get gapRatio => 0.05;

  @override
  BasinsPuzzle generate(GenParams params) => generateBasins(params);

  List<int> _values(ValueGrid s) => [for (final c in s.cells) c.value ?? -1];

  @override
  Widget buildValue(BuildContext context, BasinsPuzzle puzzle, ValueGrid state, Pos pos, CellValue cell, double size) {
    if (cell.value != basinsWater) return super.buildValue(context, puzzle, state, pos, cell, size);
    // The water's surface: open air of the same basin above.
    final i = puzzle.size.index(pos), up = i - puzzle.cols;
    final surface = up >= 0 && puzzle.regions[up] == puzzle.regions[i] && state.cells[up].value != basinsWater;
    return CustomPaint(
      size: Size.square(size),
      painter: _WaterPainter(waterColor(context), surface: surface),
    );
  }

  @override
  bool isComplete(BasinsPuzzle puzzle, ValueGrid state) =>
      state.cells.where((c) => c.value == basinsWater).length == puzzle.waterCells;

  @override
  bool isSolved(BasinsPuzzle puzzle, ValueGrid state) =>
      isComplete(puzzle, state) && basinsConflicts(puzzle, _values(state), complete: true).isEmpty;

  @override
  Set<Pos> conflicts(BasinsPuzzle puzzle, ValueGrid state) => {
    for (final i in basinsConflicts(puzzle, _values(state), complete: isComplete(puzzle, state))) puzzle.size.pos(i),
  };

  /// Fixes a wrong entry, else puts a missing water cell: dry marks are optional.
  @override
  HintResult<ValueGrid>? hint(BasinsPuzzle puzzle, ValueGrid state) {
    final wrong = <int>[], missing = <int>[];
    for (var i = 0; i < state.cells.length; i++) {
      final v = state.cells[i].value;
      if (v != null && v != puzzle.solutionAt(i)) wrong.add(i);
      if (v == null && puzzle.water[i]) missing.add(i);
    }
    final pool = wrong.isNotEmpty ? wrong : missing;
    if (pool.isEmpty) return null;
    final i = pool[Random().nextInt(pool.length)];
    final pos = puzzle.size.pos(i);
    return HintResult(state.set(pos, state.cells[i].withValue(puzzle.solutionAt(i))), {pos});
  }

  /// Water settles below placed water, dry marks go above dry cells of
  /// the same basin and into lines that have all their water.
  @override
  ValueGrid markForbidden(BasinsPuzzle puzzle, ValueGrid state) {
    final (below, above) = basinsLevels(puzzle.cols, puzzle.regions);
    final v = _values(state);
    final wet = <int>{}, dry = <int>{};
    for (var i = 0; i < v.length; i++) {
      if (v[i] == basinsWater) wet.addAll(below[i]);
      if (v[i] == basinsDry) dry.addAll(above[i]);
    }
    final lines = basinsLines(puzzle.rows, puzzle.cols);
    for (var li = 0; li < lines.length; li++) {
      final want = li < puzzle.rows ? puzzle.rowCounts[li] : puzzle.colCounts[li - puzzle.rows];
      if (want != null && lines[li].where((i) => v[i] == basinsWater).length == want) dry.addAll(lines[li]);
    }
    // Where both would go the board already breaks a rule: leave those alone.
    return dotted(dotted(state, wet.difference(dry), basinsWater), dry.difference(wet), basinsDry);
  }

  @override
  (double, double) header(BasinsPuzzle puzzle) => (0.72, 0.72);

  @override
  List<Widget> buildOverlayIn(BuildContext context, BasinsPuzzle puzzle, ValueGrid state, BoardMetrics m) {
    final theme = Theme.of(context);
    final on = theme.colorScheme.onSurface;
    final values = _values(state);
    Widget label(Rect r, int? want, int have) {
      final done = want != null && have == want;
      return Positioned.fromRect(
        rect: r,
        child: Center(
          child: AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 200),
            style: theme.textTheme.bodyLarge!.copyWith(
              fontSize: m.cell * 0.4,
              fontWeight: FontWeight.w700,
              color: on.withValues(alpha: done ? 0.3 : 0.85),
            ),
            child: Text(want == null ? '' : '$want'),
          ),
        ),
      );
    }

    int count(Iterable<int> cells) => cells.where((i) => values[i] == basinsWater).length;
    return [
      RegionBorders(metrics: m, regionOf: (i) => puzzle.regions[i], color: on),
      for (var r = 0; r < puzzle.rows; r++)
        label(
          Rect.fromLTWH(0, m.y(r), m.ox - m.gap, m.cell),
          puzzle.rowCounts[r],
          count([for (var c = 0; c < puzzle.cols; c++) r * puzzle.cols + c]),
        ),
      for (var c = 0; c < puzzle.cols; c++)
        label(
          Rect.fromLTWH(m.x(c), 0, m.cell, m.oy - m.gap),
          puzzle.colCounts[c],
          count([for (var r = 0; r < puzzle.rows; r++) r * puzzle.cols + c]),
        ),
    ];
  }

  @override
  bool get canExplain => true;

  @override
  Explanation? explain(BasinsPuzzle puzzle, ValueGrid state) => explainStep(const BasinsExplainer(), puzzle, state);

  @override
  Map<String, dynamic> encodePuzzle(BasinsPuzzle puzzle) => puzzle.toJson();
  @override
  BasinsPuzzle decodePuzzle(Map<String, dynamic> json) => BasinsPuzzle.fromJson(json);
}

/// A cell of water: the whole cell, or with a wavy surface a little below
/// its top where air of its basin lies above. The palette [chip] is rounded.
class _WaterPainter extends CustomPainter {
  _WaterPainter(this.color, {required this.surface, this.chip = false});

  final Color color;
  final bool surface;
  final bool chip;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final paint = Paint()..color = color;
    final rect = Offset.zero & size;
    canvas.save();
    canvas.clipRRect(RRect.fromRectAndRadius(rect, Radius.circular(w * (chip ? 0.16 : 0.1))));
    if (!surface) {
      canvas.drawRect(rect, paint);
      canvas.restore();
      return;
    }
    // A wave: two crests across the cell.
    final top = h * 0.22, amp = h * 0.05;
    final path = Path()..moveTo(0, top);
    for (var k = 0; k < 2; k++) {
      final x0 = w * k / 2;
      path
        ..quadraticBezierTo(x0 + w / 8, top - amp, x0 + w / 4, top)
        ..quadraticBezierTo(x0 + 3 * w / 8, top + amp, x0 + w / 2, top);
    }
    path
      ..lineTo(w, h)
      ..lineTo(0, h)
      ..close();
    canvas.drawPath(path, paint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(_WaterPainter old) => old.color != color || old.surface != surface || old.chip != chip;
}
