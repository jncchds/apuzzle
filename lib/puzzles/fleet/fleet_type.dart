import 'dart:math';

import 'package:flutter/material.dart';

import '../../core/day.dart';
import '../../core/difficulty.dart';
import '../../core/explain.dart';
import '../../core/grid.dart';
import '../../core/grid_graph.dart';
import '../../core/puzzle_type.dart';
import '../../core/tutorial.dart';
import '../../core/value_grid.dart';
import '../../l10n/l10n.dart';
import '../../ui/board/cell_grid_board.dart';
import 'fleet_explain.dart';
import 'fleet_generator.dart';
import 'fleet_model.dart';
import 'fleet_tutorial.dart';

/// The fleet below the grid, in cells: ship unit, gap between ships, line height.
const double _unit = 0.42, _shipGap = 0.34, _lineHeight = 0.6;

/// Fleet: find the hidden ships from the row and column counts.
class FleetType extends ValueGridType<FleetPuzzle> {
  const FleetType();

  static const shipLight = Color(0xFF34495E);
  static const shipDark = Color(0xFFB9C9DB);
  static const waterLight = Color(0xFFCFE5F6);
  static const waveColor = Color(0xFF4A90C8);

  static Color shipColor(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? shipDark : shipLight;

  @override
  String get id => 'fleet';
  @override
  String name(AppLocalizations l) => l.fleetName;
  @override
  String tagline(AppLocalizations l) => l.fleetTagline;
  @override
  IconData get icon => Icons.sailing_rounded;
  @override
  Color get accent => const Color(0xFF3D8BD9);

  @override
  String rulesText(AppLocalizations l) => l.fleetRules;

  @override
  List<TutorialStep> tutorial() => fleetTutorial;
  @override
  List<TutorialStep> strategies() => fleetStrategies;

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
      (context, size) => ShipPiece(size: size, joins: 0, color: shipColor(context)),
      label: 'ship',
    ),
    ValueSpec.custom(
      (context, size) => Icon(Icons.waves_rounded, size: size * 0.5, color: waveColor.withValues(alpha: 0.7)),
      label: 'water',
    ),
  ];

  @override
  bool get showLockIcon => false;
  @override
  double get gapRatio => 0.06;

  @override
  FleetPuzzle generate(GenParams params) => generateFleet(params);

  List<int> _values(ValueGrid s) => [for (final c in s.cells) c.value ?? -1];

  @override
  Widget buildValue(BuildContext context, FleetPuzzle puzzle, ValueGrid state, Pos pos, CellValue cell, double size) {
    if (cell.value != fleetShip) return values[fleetWater].build(context, size);
    final i = puzzle.size.index(pos);
    if (cell.given && puzzle.ships[i]) {
      final shape = puzzle.shapeOf(i);
      final joins = shape == pieceMiddle ? sideUp | sideRight | sideDown | sideLeft : shape;
      return ShipPiece(size: size, joins: joins, color: shipColor(context));
    }
    // A placed cell: rounded only where water or the edge closes it in.
    var joins = 0, closed = 0;
    for (final side in const [sideUp, sideRight, sideDown, sideLeft]) {
      final k = stepTo(puzzle.rows, puzzle.cols, i, side);
      if (k >= 0 && state.cells[k].value == fleetShip) joins |= side;
      if (k < 0 || state.cells[k].value == fleetWater) closed |= side;
    }
    return ShipPiece(size: size, joins: joins, closed: closed, color: shipColor(context));
  }

  @override
  Color? cellColor(BuildContext context, FleetPuzzle puzzle, Pos pos, CellValue cell) {
    if (cell.value != fleetWater) return null;
    return Theme.of(context).brightness == Brightness.dark ? Color.lerp(waterLight, Colors.black, 0.72) : waterLight;
  }

  @override
  bool isComplete(FleetPuzzle puzzle, ValueGrid state) =>
      state.cells.where((c) => c.value == fleetShip).length == puzzle.shipCells;

  @override
  bool isSolved(FleetPuzzle puzzle, ValueGrid state) =>
      isComplete(puzzle, state) && fleetConflicts(puzzle, _values(state), complete: true).isEmpty;

  @override
  Set<Pos> conflicts(FleetPuzzle puzzle, ValueGrid state) => {
    for (final i in fleetConflicts(puzzle, _values(state), complete: isComplete(puzzle, state))) puzzle.size.pos(i),
  };

  /// Fixes a wrong entry, else puts a missing ship cell: water is optional.
  @override
  HintResult<ValueGrid>? hint(FleetPuzzle puzzle, ValueGrid state) {
    final wrong = <int>[], missing = <int>[];
    for (var i = 0; i < state.cells.length; i++) {
      final v = state.cells[i].value;
      if (v != null && v != puzzle.solutionAt(i)) wrong.add(i);
      if (v == null && puzzle.ships[i]) missing.add(i);
    }
    final pool = wrong.isNotEmpty ? wrong : missing;
    if (pool.isEmpty) return null;
    final i = pool[Random().nextInt(pool.length)];
    final pos = puzzle.size.pos(i);
    return HintResult(state.set(pos, state.cells[i].withValue(puzzle.solutionAt(i))), {pos});
  }

  /// Water on the diagonals of ship cells and in lines that have all their ship cells.
  @override
  ValueGrid markForbidden(FleetPuzzle puzzle, ValueGrid state) {
    final rows = puzzle.rows, cols = puzzle.cols, kn = kingNeighbors(rows, cols);
    final ships = [for (final c in state.cells) c.value == fleetShip];
    final water = <int>{};
    for (var i = 0; i < ships.length; i++) {
      if (!ships[i]) continue;
      for (final j in kn[i]) {
        if (j ~/ cols != i ~/ cols && j % cols != i % cols) water.add(j);
      }
    }
    final lines = fleetLines(rows, cols);
    for (var li = 0; li < lines.length; li++) {
      final want = li < rows ? puzzle.rowCounts[li] : puzzle.colCounts[li - rows];
      if (want != null && lines[li].where((i) => ships[i]).length == want) water.addAll(lines[li]);
    }
    if (ships.where((s) => s).length == puzzle.shipCells) {
      water.addAll([for (var i = 0; i < ships.length; i++) i]);
    }
    return dotted(state, water, fleetWater);
  }

  /// The fleet's ships laid out in lines below the grid: (line, x) per ship, in cells.
  static List<(int, double)> legendLayout(List<int> fleet, int cols) {
    final width = cols * 1.06 - 0.06;
    final out = <(int, double)>[];
    var line = 0;
    var x = 0.0;
    for (final len in fleet) {
      final w = len * _unit;
      if (x > 0 && x + w > width) {
        line++;
        x = 0;
      }
      out.add((line, x));
      x += w + _shipGap;
    }
    return out;
  }

  @override
  (double, double) header(FleetPuzzle puzzle) => (0.72, 0.72);

  @override
  (double, double) footer(FleetPuzzle puzzle) {
    final lines = legendLayout(puzzle.fleet, puzzle.cols).last.$1 + 1;
    return (0, 0.2 + lines * _lineHeight);
  }

  @override
  List<Widget> buildOverlayIn(BuildContext context, FleetPuzzle puzzle, ValueGrid state, BoardMetrics m) {
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

    int count(Iterable<int> cells) => cells.where((i) => values[i] == fleetShip).length;

    // Found ships dim in the legend, the first ones of their length.
    final found = <int, int>{};
    for (final run in closedShips(puzzle.rows, puzzle.cols, values)) {
      found[run.length] = (found[run.length] ?? 0) + 1;
    }
    final layout = legendLayout(puzzle.fleet, puzzle.cols);
    final unit = m.cell * _unit, top = m.height + m.gap + m.cell * 0.2;
    final ship = shipColor(context);
    return [
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
      for (var k = 0; k < puzzle.fleet.length; k++)
        Positioned(
          left: m.ox + layout[k].$2 * m.cell,
          top: top + layout[k].$1 * m.cell * _lineHeight,
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 200),
            opacity: (found[puzzle.fleet[k]] ?? 0) > puzzle.fleet.take(k).where((l) => l == puzzle.fleet[k]).length
                ? 0.25
                : 0.9,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (var s = 0; s < puzzle.fleet[k]; s++)
                  ShipPiece(
                    size: unit,
                    color: ship,
                    joins: puzzle.fleet[k] == 1
                        ? 0
                        : s == 0
                        ? sideRight
                        : s == puzzle.fleet[k] - 1
                        ? sideLeft
                        : sideLeft | sideRight,
                  ),
              ],
            ),
          ),
        ),
    ];
  }

  @override
  bool get canExplain => true;

  @override
  Explanation? explain(FleetPuzzle puzzle, ValueGrid state) => explainStep(const FleetExplainer(), puzzle, state);

  @override
  Map<String, dynamic> encodePuzzle(FleetPuzzle puzzle) => puzzle.toJson();
  @override
  FleetPuzzle decodePuzzle(Map<String, dynamic> json) => FleetPuzzle.fromJson(json);
}

/// One cell of a ship: flat towards the [joins] sides (where the ship goes
/// on), rounded between two [closed] sides (where it ends), so a closed-in
/// lone cell is a circle. [closed] defaults to every side not joined.
class ShipPiece extends StatelessWidget {
  const ShipPiece({super.key, required this.size, required this.joins, this.closed, required this.color});

  final double size;
  final int joins;
  final int? closed;
  final Color color;

  @override
  Widget build(BuildContext context) =>
      CustomPaint(size: Size.square(size), painter: _PiecePainter(joins, closed ?? ~joins, color));
}

class _PiecePainter extends CustomPainter {
  _PiecePainter(this.joins, this.closed, this.color);

  final int joins;
  final int closed;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width, inset = s * 0.13;
    bool j(int side) => joins & side != 0;
    final rect = Rect.fromLTRB(
      j(sideLeft) ? 0 : inset,
      j(sideUp) ? 0 : inset,
      j(sideRight) ? s : s - inset,
      j(sideDown) ? s : s - inset,
    );
    // A shown middle piece (joined all round) is a square.
    final all = joins == sideUp | sideRight | sideDown | sideLeft;
    final round = Radius.circular(min(rect.width, rect.height) / 2);
    final small = Radius.circular(all ? s * 0.08 : 0), open = Radius.circular(s * 0.12);
    Radius corner(int a, int b) => j(a) || j(b)
        ? small
        : closed & a != 0 && closed & b != 0
        ? round
        : open;
    final shape = all
        ? RRect.fromRectAndRadius(rect.deflate(inset), small)
        : RRect.fromRectAndCorners(
            rect,
            topLeft: corner(sideUp, sideLeft),
            topRight: corner(sideUp, sideRight),
            bottomRight: corner(sideDown, sideRight),
            bottomLeft: corner(sideDown, sideLeft),
          );
    canvas.drawRRect(shape, Paint()..color = color);
  }

  @override
  bool shouldRepaint(_PiecePainter old) => old.joins != joins || old.closed != closed || old.color != color;
}
