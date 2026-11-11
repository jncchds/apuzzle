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
import '../../ui/symbols.dart';
import '../inlay/inlay_model.dart' show Cell;
import 'quarry_explain.dart';
import 'quarry_generator.dart';
import 'quarry_model.dart';
import 'quarry_tutorial.dart';

/// Quarry: cut the stones of the tray out of the grid.
class QuarryType extends ValueGridType<QuarryPuzzle> {
  const QuarryType();

  static const stoneLight = Color(0xFF7A6E60);
  static const stoneDark = Color(0xFFA39582);

  static Color stoneColor(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? stoneDark : stoneLight;

  /// A tray cell, in board cells.
  static const _unit = 0.34;

  /// Room between stones in the tray, in board cells.
  static const _pieceGap = 0.45;

  @override
  String get id => 'quarry';
  @override
  String name(AppLocalizations l) => l.quarryName;
  @override
  String tagline(AppLocalizations l) => l.quarryTagline;
  @override
  IconData get icon => Icons.landscape_rounded;
  @override
  Color get accent => const Color(0xFFC8A27A);

  @override
  String rulesText(AppLocalizations l) => l.quarryRules;

  @override
  List<TutorialStep> tutorial() => quarryTutorial;
  @override
  List<TutorialStep> strategies() => quarryStrategies;

  @override
  List<GridSize> get sizes => [for (var n = 5; n <= 10; n++) GridSize.square(n)];
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
  double get minCellSize => 32;

  @override
  List<ValueSpec> get values => [
    ValueSpec.custom(
      (context, size) => Container(
        width: size * 0.7,
        height: size * 0.7,
        decoration: BoxDecoration(color: stoneColor(context), borderRadius: BorderRadius.circular(size * 0.12)),
      ),
      label: 'shade',
    ),
    ValueSpec.custom((context, size) => DotSymbol(size: size), label: 'keep'),
  ];

  @override
  bool get showLockIcon => false;
  @override
  double get gapRatio => 0.05;

  @override
  QuarryPuzzle generate(GenParams params) => generateQuarry(params);

  List<bool> _shaded(ValueGrid s) => [for (final c in s.cells) c.value == quarryShade];

  /// The shaded areas that are surely a stone of the tray, with that stone
  /// (see [quarryFinished]), for the long press: closed off means every cell
  /// beside the area is dotted, a hollow circle, or the board is complete.
  List<(List<int>, int)> _finished(QuarryPuzzle p, ValueGrid s) {
    final nb = orthNeighbors(p.n, p.n);
    final shaded = _shaded(s);
    final complete = isComplete(p, s);
    return [
      for (final g in components(nb, (i) => shaded[i]))
        if (quarryFinished(
              p,
              g,
              closed: complete || g.every((i) => nb[i].every((j) => shaded[j] || s.cells[j].value == quarryKeep)),
            )
            case final k when k >= 0)
          (g, k),
    ];
  }

  @override
  Widget buildValue(BuildContext context, QuarryPuzzle puzzle, ValueGrid state, Pos pos, CellValue cell, double size) {
    final clue = puzzle.clues[puzzle.size.index(pos)];
    if (clue == quarryShade) {
      return Container(
        width: size * 0.42,
        height: size * 0.42,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Color.lerp(stoneColor(context), Colors.black, 0.5),
        ),
      );
    }
    if (clue == quarryKeep) {
      return Container(
        width: size * 0.46,
        height: size * 0.46,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.75),
            width: max(1.5, size * 0.07),
          ),
        ),
      );
    }
    if (cell.value == quarryShade) return const SizedBox.shrink();
    return super.buildValue(context, puzzle, state, pos, cell, size);
  }

  @override
  Color? cellColor(BuildContext context, QuarryPuzzle puzzle, Pos pos, CellValue cell) =>
      cell.value == quarryShade ? stoneColor(context) : null;

  /// A stone of the tray in explain texts; other values as usual.
  @override
  Widget buildValueChip(BuildContext context, QuarryPuzzle puzzle, int value, double size) {
    if (value < quarryPieceToken) return super.buildValueChip(context, puzzle, value, size);
    final cells = quarryShown(puzzle.pieces[value - quarryPieceToken]);
    final (h, w) = quarryExtent(cells);
    final unit = size / max(3, max(w, h));
    return QuarryStone(cells: cells, unit: unit, color: stoneColor(context));
  }

  /// The tray's stones in lines below the grid: (line, x) per stone, in
  /// board cells.
  static List<(int, double)> trayLayout(QuarryPuzzle p) {
    final width = p.n * 1.05 - 0.05;
    final out = <(int, double)>[];
    var line = 0;
    var x = 0.0;
    for (final k in p.pieces) {
      final (_, w) = quarryExtent(quarryShown(k));
      final wide = w * _unit;
      if (x > 0 && x + wide > width) {
        line++;
        x = 0;
      }
      out.add((line, x));
      x += wide + _pieceGap;
    }
    // Centre each line.
    final lines = out.isEmpty ? 0 : out.last.$1 + 1;
    final ends = List<double>.filled(lines, 0);
    for (var k = 0; k < out.length; k++) {
      final (_, w) = quarryExtent(quarryShown(p.pieces[k]));
      ends[out[k].$1] = out[k].$2 + w * _unit;
    }
    return [for (final (l, x) in out) (l, x + (width - ends[l]) / 2)];
  }

  /// Each tray line's height, in board cells.
  static List<double> _lineHeights(QuarryPuzzle p, List<(int, double)> layout) {
    final lines = layout.last.$1 + 1;
    final out = List<double>.filled(lines, 0);
    for (var k = 0; k < p.pieces.length; k++) {
      final (h, _) = quarryExtent(quarryShown(p.pieces[k]));
      out[layout[k].$1] = max(out[layout[k].$1], h * _unit + 0.2);
    }
    return out;
  }

  @override
  (double, double) footer(QuarryPuzzle puzzle) {
    final heights = _lineHeights(puzzle, trayLayout(puzzle));
    return (0, 0.2 + heights.fold(0.0, (s, h) => s + h));
  }

  @override
  List<Widget> buildOverlayIn(BuildContext context, QuarryPuzzle puzzle, ValueGrid state, BoardMetrics m) {
    // A stone fades whenever the board shows an area of its shape, whether
    // or not it is right or could still grow: the tray only mirrors the board.
    final shaded = _shaded(state);
    final found = {
      for (final g in components(orthNeighbors(puzzle.n, puzzle.n), (i) => shaded[i])) quarryPieceOf(puzzle, g),
    }..remove(-1);
    final layout = trayLayout(puzzle);
    final heights = _lineHeights(puzzle, layout);
    final tops = <double>[];
    var y = m.height + m.gap + m.cell * 0.2;
    for (final h in heights) {
      tops.add(y);
      y += h * m.cell;
    }
    final color = stoneColor(context);
    return [
      for (var k = 0; k < puzzle.pieces.length; k++)
        Positioned(
          left: m.ox + layout[k].$2 * m.cell,
          top: tops[layout[k].$1],
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 200),
            opacity: found.contains(k) ? 0.25 : 0.95,
            child: QuarryStone(cells: quarryShown(puzzle.pieces[k]), unit: m.cell * _unit, color: color),
          ),
        ),
    ];
  }

  /// As many shaded cells as the solution, or every cell filled.
  @override
  bool isComplete(QuarryPuzzle puzzle, ValueGrid state) =>
      state.isFull || state.cells.where((c) => c.value == quarryShade).length == puzzle.shadedCount;

  @override
  bool isSolved(QuarryPuzzle puzzle, ValueGrid state) => quarryValid(puzzle, _shaded(state));

  /// Before the board is complete only what more cells can't mend.
  @override
  Set<Pos> conflicts(QuarryPuzzle puzzle, ValueGrid state) {
    final complete = isComplete(puzzle, state);
    return {
      for (final i in quarryConflicts(
        puzzle,
        _shaded(state),
        kept: complete ? null : [for (final c in state.cells) c.value == quarryKeep],
        complete: complete,
      ))
        puzzle.size.pos(i),
    };
  }

  /// Fixes a wrong entry, else shades a missing cell: dots are optional.
  @override
  HintResult<ValueGrid>? hint(QuarryPuzzle puzzle, ValueGrid state) {
    final wrong = <int>[], missing = <int>[];
    for (var i = 0; i < state.cells.length; i++) {
      final v = state.cells[i].value;
      if (v != null && v != puzzle.solutionAt(i)) wrong.add(i);
      if (v == null && puzzle.shaded[i]) missing.add(i);
    }
    final pool = wrong.isNotEmpty ? wrong : missing;
    if (pool.isEmpty) return null;
    final i = pool[Random().nextInt(pool.length)];
    final pos = puzzle.size.pos(i);
    return HintResult(state.set(pos, state.cells[i].withValue(puzzle.solutionAt(i))), {pos});
  }

  /// Dots the cells around every shaded area that is surely a stone of the
  /// tray.
  @override
  ValueGrid markForbidden(QuarryPuzzle puzzle, ValueGrid state) {
    final nb = orthNeighbors(puzzle.n, puzzle.n);
    final dots = <int>{};
    for (final (g, _) in _finished(puzzle, state)) {
      for (final i in g) {
        for (final j in nb[i]) {
          if (state.cells[j].value != quarryShade && puzzle.clues[j] == null) dots.add(j);
        }
      }
    }
    return dotted(state, dots, quarryKeep);
  }

  @override
  bool get canExplain => true;

  @override
  Explanation? explain(QuarryPuzzle puzzle, ValueGrid state) => explainStep(const QuarryExplainer(), puzzle, state);

  @override
  Map<String, dynamic> encodePuzzle(QuarryPuzzle puzzle) => puzzle.toJson();
  @override
  QuarryPuzzle decodePuzzle(Map<String, dynamic> json) => QuarryPuzzle.fromJson(json);
}

/// A stone drawn from its [cells], [unit] per cell, joined cells without a
/// gap and a faint line between them.
class QuarryStone extends StatelessWidget {
  const QuarryStone({super.key, required this.cells, required this.unit, required this.color});

  final List<Cell> cells;
  final double unit;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final (h, w) = quarryExtent(cells);
    return CustomPaint(
      size: Size(w * unit, h * unit),
      painter: _StonePainter(cells, unit, color, Theme.of(context).colorScheme.surface),
    );
  }
}

class _StonePainter extends CustomPainter {
  _StonePainter(this.cells, this.unit, this.color, this.line);

  final List<Cell> cells;
  final double unit;
  final Color color;
  final Color line;

  @override
  void paint(Canvas canvas, Size size) {
    final fill = Paint()..color = color;
    final r = Radius.circular(unit * 0.18);
    final set = cells.toSet();
    for (final (y, x) in cells) {
      final rect = Rect.fromLTWH(x * unit, y * unit, unit, unit);
      bool has(int dy, int dx) => set.contains((y + dy, x + dx));
      canvas.drawRRect(
        RRect.fromRectAndCorners(
          rect,
          topLeft: has(-1, 0) || has(0, -1) ? Radius.zero : r,
          topRight: has(-1, 0) || has(0, 1) ? Radius.zero : r,
          bottomLeft: has(1, 0) || has(0, -1) ? Radius.zero : r,
          bottomRight: has(1, 0) || has(0, 1) ? Radius.zero : r,
        ),
        fill,
      );
    }
    final seam = Paint()
      ..color = line.withValues(alpha: 0.45)
      ..strokeWidth = max(0.6, unit * 0.06);
    for (final (y, x) in cells) {
      if (set.contains((y, x + 1))) {
        canvas.drawLine(
          Offset((x + 1) * unit, y * unit + unit * 0.2),
          Offset((x + 1) * unit, (y + 1) * unit - unit * 0.2),
          seam,
        );
      }
      if (set.contains((y + 1, x))) {
        canvas.drawLine(
          Offset(x * unit + unit * 0.2, (y + 1) * unit),
          Offset((x + 1) * unit - unit * 0.2, (y + 1) * unit),
          seam,
        );
      }
    }
  }

  @override
  bool shouldRepaint(_StonePainter old) => old.unit != unit || old.color != color || old.cells != cells;
}
