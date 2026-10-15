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
import '../../ui/symbols.dart';
import 'mercury_explain.dart';
import 'mercury_generator.dart';
import 'mercury_model.dart';
import 'mercury_tutorial.dart';

/// Mercury: fill the tubes from their bulbs to match the row and column counts.
class MercuryType extends ValueGridType<MercuryPuzzle> {
  const MercuryType();

  static const mercuryLight = Color(0xFFD9443A);
  static const mercuryDark = Color(0xFFFF6E61);

  static bool _dark(BuildContext context) => Theme.of(context).brightness == Brightness.dark;
  static Color mercuryColor(BuildContext context) => _dark(context) ? mercuryDark : mercuryLight;

  @override
  String get id => 'mercury';
  @override
  String name(AppLocalizations l) => l.mercuryName;
  @override
  String tagline(AppLocalizations l) => l.mercuryTagline;
  @override
  IconData get icon => Icons.thermostat_rounded;
  @override
  Color get accent => const Color(0xFFE5604F);

  @override
  String rulesText(AppLocalizations l) => l.mercuryRules;

  @override
  List<TutorialStep> tutorial() => mercuryTutorial;
  @override
  List<TutorialStep> strategies() => mercuryStrategies;

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
  Day get dailySince => const Day(2026, 10, 16);
  @override
  double get minCellSize => 32;

  @override
  List<ValueSpec> get values => [
    ValueSpec.custom(
      (context, size) => Container(
        width: size * 0.5,
        height: size * 0.5,
        decoration: BoxDecoration(color: mercuryColor(context), shape: BoxShape.circle),
      ),
      label: 'mercury',
    ),
    ValueSpec.custom((context, size) => DotSymbol(size: size), label: 'empty'),
  ];

  @override
  bool get showLockIcon => false;
  @override
  double get gapRatio => 0.05;

  @override
  MercuryPuzzle generate(GenParams params) => generateMercury(params);

  List<int> _values(ValueGrid s) => [for (final c in s.cells) c.value ?? -1];

  /// The mercury is drawn along its tube in the overlay.
  @override
  Widget buildValue(
    BuildContext context,
    MercuryPuzzle puzzle,
    ValueGrid state,
    Pos pos,
    CellValue cell,
    double size,
  ) => cell.value == mercuryFull ? const SizedBox.shrink() : super.buildValue(context, puzzle, state, pos, cell, size);

  @override
  bool isComplete(MercuryPuzzle puzzle, ValueGrid state) =>
      state.cells.where((c) => c.value == mercuryFull).length == puzzle.filledCells;

  @override
  bool isSolved(MercuryPuzzle puzzle, ValueGrid state) =>
      isComplete(puzzle, state) && mercuryConflicts(puzzle, _values(state), complete: true).isEmpty;

  @override
  Set<Pos> conflicts(MercuryPuzzle puzzle, ValueGrid state) => {
    for (final i in mercuryConflicts(puzzle, _values(state), complete: isComplete(puzzle, state))) puzzle.size.pos(i),
  };

  /// Fixes a wrong entry, else fills a missing cell: empty marks are optional.
  @override
  HintResult<ValueGrid>? hint(MercuryPuzzle puzzle, ValueGrid state) {
    final wrong = <int>[], missing = <int>[];
    for (var i = 0; i < state.cells.length; i++) {
      final v = state.cells[i].value;
      if (v != null && v != puzzle.solutionAt(i)) wrong.add(i);
      if (v == null && puzzle.full(i)) missing.add(i);
    }
    final pool = wrong.isNotEmpty ? wrong : missing;
    if (pool.isEmpty) return null;
    final i = pool[Random().nextInt(pool.length)];
    final pos = puzzle.size.pos(i);
    return HintResult(state.set(pos, state.cells[i].withValue(puzzle.solutionAt(i))), {pos});
  }

  /// Mercury fills down to the bulb below placed mercury, empty marks go
  /// past empty cells up to the tip and into lines that have all their cells.
  @override
  ValueGrid markForbidden(MercuryPuzzle puzzle, ValueGrid state) {
    final v = _values(state);
    final full = <int>{}, empty = <int>{};
    for (final tube in puzzle.tubes) {
      for (var k = 0; k < tube.length; k++) {
        if (v[tube[k]] == mercuryFull) full.addAll(tube.take(k));
        if (v[tube[k]] == mercuryEmpty) empty.addAll(tube.skip(k + 1));
      }
    }
    final lines = mercuryLines(puzzle.rows, puzzle.cols);
    for (var li = 0; li < lines.length; li++) {
      final want = li < puzzle.rows ? puzzle.rowCounts[li] : puzzle.colCounts[li - puzzle.rows];
      if (want != null && lines[li].where((i) => v[i] == mercuryFull).length == want) empty.addAll(lines[li]);
    }
    // Where both would go the board already breaks a rule: leave those alone.
    return dotted(dotted(state, full.difference(empty), mercuryFull), empty.difference(full), mercuryEmpty);
  }

  @override
  (double, double) header(MercuryPuzzle puzzle) => (0.72, 0.72);

  @override
  List<Widget> buildOverlayIn(BuildContext context, MercuryPuzzle puzzle, ValueGrid state, BoardMetrics m) {
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

    int count(Iterable<int> cells) => cells.where((i) => values[i] == mercuryFull).length;
    return [
      Positioned.fill(
        child: IgnorePointer(
          child: CustomPaint(
            painter: _TubesPainter(
              puzzle: puzzle,
              values: values,
              metrics: m,
              glass: on.withValues(alpha: _dark(context) ? 0.2 : 0.17),
              mercury: mercuryColor(context),
            ),
          ),
        ),
      ),
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
  Explanation? explain(MercuryPuzzle puzzle, ValueGrid state) => explainStep(const MercuryExplainer(), puzzle, state);

  @override
  Map<String, dynamic> encodePuzzle(MercuryPuzzle puzzle) => puzzle.toJson();
  @override
  MercuryPuzzle decodePuzzle(Map<String, dynamic> json) => MercuryPuzzle.fromJson(json);
}

/// Sizes in cells: the tube and its bulb, the mercury inside, and how far
/// the tube's rounded tip reaches past the centre of its last cell.
const double _tube = 0.46, _bulb = 0.37, _mercury = 0.26, _mercuryBulb = 0.27, _tip = 0.2;

/// Every tube as faint glass from a round bulb to a rounded tip, and the
/// mercury of filled cells inside it, joined along the tube.
class _TubesPainter extends CustomPainter {
  _TubesPainter({
    required this.puzzle,
    required this.values,
    required this.metrics,
    required this.glass,
    required this.mercury,
  });

  final MercuryPuzzle puzzle;
  final List<int> values;
  final BoardMetrics metrics;
  final Color glass;
  final Color mercury;

  Offset _at(int i) => metrics.center(Pos(i ~/ puzzle.cols, i % puzzle.cols));

  /// Past the tip's centre, away from the cell before it.
  Offset _tipOf(List<int> tube) {
    final end = _at(tube.last);
    if (tube.length < 2) return end;
    final d = end - _at(tube[tube.length - 2]);
    return end + d / d.distance * metrics.cell * _tip;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final cell = metrics.cell;
    // The glass in one layer, so overlapping strokes don't darken it.
    canvas.saveLayer(Offset.zero & size, Paint()..color = Color.fromRGBO(0, 0, 0, glass.a));
    final solid = glass.withValues(alpha: 1);
    final opaque = Paint()..color = solid;
    final stroke = Paint()
      ..color = solid
      ..style = PaintingStyle.stroke
      ..strokeWidth = cell * _tube
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    for (final tube in puzzle.tubes) {
      final path = Path()..moveTo(_at(tube.first).dx, _at(tube.first).dy);
      for (final i in tube.skip(1)) {
        path.lineTo(_at(i).dx, _at(i).dy);
      }
      final tip = _tipOf(tube);
      path.lineTo(tip.dx, tip.dy);
      canvas.drawPath(path, stroke);
      canvas.drawCircle(_at(tube.first), cell * _bulb, opaque);
    }
    canvas.restore();

    final fill = Paint()..color = mercury;
    final line = Paint()
      ..color = mercury
      ..strokeWidth = cell * _mercury
      ..strokeCap = StrokeCap.butt;
    for (final tube in puzzle.tubes) {
      for (var k = 0; k < tube.length; k++) {
        if (values[tube[k]] != mercuryFull) continue;
        final c = _at(tube[k]);
        // From the edge toward the bulb to the edge toward the tip.
        if (k == 0) canvas.drawCircle(c, cell * _mercuryBulb, fill);
        if (k > 0) canvas.drawLine(c, Offset.lerp(c, _at(tube[k - 1]), 0.5)!, line);
        if (k + 1 < tube.length) {
          canvas.drawLine(c, Offset.lerp(c, _at(tube[k + 1]), 0.5)!, line);
        } else if (tube.length > 1) {
          final tip = _tipOf(tube);
          canvas.drawLine(c, tip, line);
          canvas.drawCircle(tip, cell * _mercury / 2, fill);
        }
        canvas.drawCircle(c, cell * _mercury / 2, fill);
      }
    }
  }

  @override
  bool shouldRepaint(_TubesPainter old) =>
      old.metrics != metrics ||
      old.glass != glass ||
      old.mercury != mercury ||
      old.puzzle != puzzle ||
      !_same(old.values, values);

  static bool _same(List<int> a, List<int> b) {
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}
