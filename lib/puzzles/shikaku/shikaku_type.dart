import 'package:flutter/material.dart';

import '../../core/difficulty.dart';
import '../../core/game_controller.dart';
import '../../core/grid.dart';
import '../../core/puzzle_type.dart';
import '../../ui/board/cell_grid_board.dart';
import '../../ui/symbols.dart';
import 'shikaku_generator.dart';
import 'shikaku_model.dart';

/// Divide the grid into rectangles; each holds one number equal to its area.
class ShikakuType extends PuzzleType<ShikakuPuzzle, ShikakuState> {
  const ShikakuType();

  @override
  String get id => 'shikaku';
  @override
  String get name => 'Shikaku';
  @override
  String get tagline => 'Split the grid into numbered rectangles';
  @override
  IconData get icon => Icons.crop_square_rounded;
  @override
  Color get accent => const Color(0xFFD4C97E);

  @override
  String get rulesText => '''
• Divide the whole grid into rectangles (squares count too).
• Every rectangle contains exactly one number.
• That number equals the rectangle's area in cells.

Drag from one corner to the opposite corner to draw a rectangle. Tap a rectangle to remove it.''';

  @override
  List<GridSize> get sizes => [for (final n in [5, 6, 7, 8, 9, 10, 12]) GridSize.square(n)];
  @override
  GridSize get defaultSize => const GridSize.square(7);
  @override
  double get controlsHeight => 40;

  @override
  ShikakuPuzzle generate(GenParams params) => generateShikaku(params);
  @override
  ShikakuState initialState(ShikakuPuzzle puzzle) => const ShikakuState([]);

  int _covered(ShikakuState s) => s.rects.fold(0, (a, r) => a + r.area);

  @override
  bool isComplete(ShikakuPuzzle puzzle, ShikakuState state) => _covered(state) == puzzle.rows * puzzle.cols;
  @override
  bool isSolved(ShikakuPuzzle puzzle, ShikakuState state) =>
      isComplete(puzzle, state) && shikakuBadRects(puzzle, state.rects).isEmpty;

  @override
  Set<Pos> conflicts(ShikakuPuzzle puzzle, ShikakuState state) => {
        for (final r in shikakuBadRects(puzzle, state.rects))
          for (final i in r.cells(puzzle.cols)) puzzle.size.pos(i),
      };

  @override
  HintResult<ShikakuState>? hint(ShikakuPuzzle puzzle, ShikakuState state) {
    // Drop a wrong rectangle, or add one from the solution.
    for (final r in state.rects) {
      if (!puzzle.solution.contains(r)) {
        return HintResult(ShikakuState([...state.rects]..remove(r)), r.cells(puzzle.cols).map(puzzle.size.pos).toSet());
      }
    }
    for (final r in puzzle.solution) {
      if (!state.rects.contains(r)) {
        return HintResult(ShikakuState([...state.rects, r]), r.cells(puzzle.cols).map(puzzle.size.pos).toSet());
      }
    }
    return null;
  }

  static void place(GameController ctrl, CellRect rect) {
    final s = ctrl.state as ShikakuState;
    ctrl.apply(ShikakuState([
      for (final r in s.rects)
        if (!r.overlaps(rect)) r,
      rect,
    ]));
  }

  static void removeAt(GameController ctrl, Pos pos) {
    final s = ctrl.state as ShikakuState;
    final hit = s.rects.where((r) => r.contains(pos.r, pos.c)).toList();
    if (hit.isEmpty) return;
    ctrl.apply(ShikakuState([...s.rects]..remove(hit.first)));
  }

  @override
  Widget buildBoard(BuildContext context, GameController controller) => _ShikakuBoard(controller: controller);

  @override
  Map<String, dynamic> encodePuzzle(ShikakuPuzzle puzzle) => puzzle.toJson();
  @override
  ShikakuPuzzle decodePuzzle(Map<String, dynamic> json) => ShikakuPuzzle.fromJson(json);
  @override
  Map<String, dynamic> encodeState(ShikakuState state) => state.toJson();
  @override
  ShikakuState decodeState(Map<String, dynamic> json) => ShikakuState.fromJson(json);
}

class _ShikakuBoard extends StatefulWidget {
  const _ShikakuBoard({required this.controller});
  final GameController controller;

  @override
  State<_ShikakuBoard> createState() => _ShikakuBoardState();
}

class _ShikakuBoardState extends State<_ShikakuBoard> {
  Pos? _start;
  Pos? _end;

  GameController get ctrl => widget.controller;

  @override
  Widget build(BuildContext context) {
    final p = ctrl.puzzle as ShikakuPuzzle;
    final s = ctrl.state as ShikakuState;
    final scheme = Theme.of(context).colorScheme;
    final errors = ctrl.errorCells;
    final preview = _start != null && _end != null ? CellRect.span(_start!, _end!) : null;

    Rect pixelRect(BoardMetrics m, CellRect r) =>
        Rect.fromLTRB(m.x(r.c0), m.y(r.r0), m.x(r.c1) + m.cell, m.y(r.r1) + m.cell);

    return CellGridBoard(
      rows: p.rows,
      cols: p.cols,
      gapRatio: 0.04,
      win: ctrl.winAnimation,
      onTap: ctrl.solved
          ? null
          : (pos) {
              final i = p.size.index(pos);
              final inside = s.rects.any((r) => r.contains(pos.r, pos.c));
              if (inside) {
                ShikakuType.removeAt(ctrl, pos);
              } else if (p.clues[i] == 1) {
                ShikakuType.place(ctrl, CellRect(pos.r, pos.c, pos.r, pos.c));
              }
            },
      onDragStart: ctrl.solved ? null : (pos, _) => setState(() => _start = _end = pos),
      onDragUpdate: (pos, _) {
        if (pos != null && pos != _end) setState(() => _end = pos);
      },
      onDragEnd: () {
        final a = _start, b = _end;
        setState(() => _start = _end = null);
        if (a != null && b != null) ShikakuType.place(ctrl, CellRect.span(a, b));
      },
      underlayBuilder: (context, m) => [
        for (var k = 0; k < s.rects.length; k++)
          Positioned.fromRect(
            key: ValueKey(s.rects[k]),
            rect: pixelRect(m, s.rects[k]).inflate(m.gap / 2),
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.85, end: 1),
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeOutBack,
              builder: (context, v, child) => Transform.scale(scale: v, child: child),
              child: Container(
                decoration: BoxDecoration(
                  color: regionColors[(s.rects[k].r0 * 7 + s.rects[k].c0 * 3) % regionColors.length],
                  borderRadius: BorderRadius.circular(m.cell * 0.2),
                ),
              ),
            ),
          ),
      ],
      overlayBuilder: (context, m) => [
        if (preview != null)
          Positioned.fromRect(
            rect: pixelRect(m, preview).inflate(m.gap / 2),
            child: Container(
              decoration: BoxDecoration(
                color: scheme.primary.withValues(alpha: 0.18),
                borderRadius: BorderRadius.circular(m.cell * 0.2),
                border: Border.all(color: scheme.primary, width: 2.5),
              ),
              alignment: Alignment.center,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(color: scheme.primary, borderRadius: BorderRadius.circular(10)),
                child: Text('${preview.area}', style: TextStyle(color: scheme.onPrimary, fontWeight: FontWeight.w700)),
              ),
            ),
          ),
      ],
      cellBuilder: (context, pos, m) {
        final i = p.size.index(pos);
        final covered = s.rects.any((r) => r.contains(pos.r, pos.c));
        final clue = p.clues[i];
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: covered ? Colors.transparent : scheme.surfaceContainerHigh,
            borderRadius: BorderRadius.circular(m.cell * 0.16),
            border: errors.contains(pos)
                ? Border.all(color: scheme.error, width: 2.5)
                : ctrl.flashHints.contains(pos)
                    ? Border.all(color: scheme.tertiary, width: 2.5)
                    : null,
          ),
          alignment: Alignment.center,
          child: clue == null
              ? null
              : Text(
                  '$clue',
                  style: TextStyle(
                    fontSize: m.cell * 0.5,
                    fontWeight: FontWeight.w800,
                    color: covered ? Colors.black.withValues(alpha: 0.8) : scheme.onSurface,
                  ),
                ),
        );
      },
    );
  }
}
