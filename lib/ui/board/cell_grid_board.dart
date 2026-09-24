import 'dart:math';

import 'package:flutter/material.dart';

import '../../core/grid.dart';

/// Geometry of a laid-out board. Optional sections (e.g. Sudoku boxes) add an
/// extra gap every [sectionCols] columns / [sectionRows] rows.
class BoardMetrics {
  const BoardMetrics({
    required this.rows,
    required this.cols,
    required this.cell,
    required this.gap,
    this.sectionRows = 0,
    this.sectionCols = 0,
    this.sectionGap = 0,
  });

  final int rows;
  final int cols;
  final double cell;
  final double gap;
  final int sectionRows;
  final int sectionCols;
  final double sectionGap;

  static int _sections(int n, int k) => k <= 0 ? 0 : (n - 1) ~/ k;

  double x(int c) => c * (cell + gap) + (sectionCols > 0 ? (c ~/ sectionCols) * sectionGap : 0);
  double y(int r) => r * (cell + gap) + (sectionRows > 0 ? (r ~/ sectionRows) * sectionGap : 0);

  double get width => x(cols - 1) + cell;
  double get height => y(rows - 1) + cell;
  Offset topLeft(Pos p) => Offset(x(p.c), y(p.r));
  Offset center(Pos p) => topLeft(p) + Offset(cell / 2, cell / 2);
  Rect rectOf(Pos p) => topLeft(p) & Size(cell, cell);

  /// Cell containing [o] (gaps count as the nearest cell), or null if outside.
  Pos? cellAt(Offset o) {
    if (o.dx < 0 || o.dy < 0 || o.dx > width || o.dy > height) return null;
    int find(double v, int n, double Function(int) start) {
      for (var i = n - 1; i >= 0; i--) {
        if (v >= start(i) - gap / 2 - (i > 0 ? 0 : 1)) return i;
      }
      return 0;
    }

    return Pos(find(o.dy, rows, y), find(o.dx, cols, x));
  }

  /// Midpoint of the shared edge between two orthogonal neighbours.
  Offset edgeCenter(Pos a, Pos b) {
    final ra = rectOf(a), rb = rectOf(b);
    if (a.r == b.r) {
      final left = a.c < b.c ? ra : rb, right = a.c < b.c ? rb : ra;
      return Offset((left.right + right.left) / 2, left.center.dy);
    }
    final top = a.r < b.r ? ra : rb, bottom = a.r < b.r ? rb : ra;
    return Offset(top.center.dx, (top.bottom + bottom.top) / 2);
  }

  /// Computes the largest cell size that fits [space].
  static BoardMetrics fit({
    required Size space,
    required int rows,
    required int cols,
    double gapRatio = 0.08,
    int sectionRows = 0,
    int sectionCols = 0,
    double sectionGapRatio = 0.12,
    double maxCell = 88,
  }) {
    final wUnits = cols + gapRatio * (cols - 1) + sectionGapRatio * _sections(cols, sectionCols);
    final hUnits = rows + gapRatio * (rows - 1) + sectionGapRatio * _sections(rows, sectionRows);
    final cell = min(min(space.width / wUnits, space.height / hUnits), maxCell).floorToDouble();
    return BoardMetrics(
      rows: rows,
      cols: cols,
      cell: cell,
      gap: cell * gapRatio,
      sectionRows: sectionRows,
      sectionCols: sectionCols,
      sectionGap: cell * sectionGapRatio,
    );
  }
}

typedef CellWidgetBuilder = Widget Function(BuildContext context, Pos pos, BoardMetrics m);

/// Fit-to-screen grid of tappable cells (no zoom).
class CellGridBoard extends StatelessWidget {
  const CellGridBoard({
    super.key,
    required this.rows,
    required this.cols,
    required this.cellBuilder,
    this.onTap,
    this.onSecondary,
    this.overlayBuilder,
    this.underlayBuilder,
    this.win,
    this.onDragStart,
    this.onDragUpdate,
    this.onDragEnd,
    this.gapRatio = 0.08,
    this.sectionRows = 0,
    this.sectionCols = 0,
    this.sectionGapRatio = 0.12,
    this.maxCell = 88,
  });

  final int rows;
  final int cols;
  final CellWidgetBuilder cellBuilder;
  final void Function(Pos)? onTap;

  /// Long-press on touch, right-click on desktop.
  final void Function(Pos)? onSecondary;

  /// Drawn above cells, ignores pointer (edge clues, borders...).
  final List<Widget> Function(BuildContext context, BoardMetrics m)? overlayBuilder;

  /// Drag gestures over the board (cell under the finger; null when outside).
  final void Function(Pos pos, Offset local)? onDragStart;
  final void Function(Pos? pos, Offset local)? onDragUpdate;
  final VoidCallback? onDragEnd;

  /// Drawn below cells (region backgrounds...).
  final List<Widget> Function(BuildContext context, BoardMetrics m)? underlayBuilder;
  final Animation<double>? win;
  final double gapRatio;
  final int sectionRows;
  final int sectionCols;
  final double sectionGapRatio;
  final double maxCell;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, cons) {
      final m = BoardMetrics.fit(
        space: cons.biggest,
        rows: rows,
        cols: cols,
        gapRatio: gapRatio,
        sectionRows: sectionRows,
        sectionCols: sectionCols,
        sectionGapRatio: sectionGapRatio,
        maxCell: maxCell,
      );

      final children = <Widget>[
        if (underlayBuilder != null) ...underlayBuilder!(context, m),
      ];
      for (var r = 0; r < rows; r++) {
        for (var c = 0; c < cols; c++) {
          final pos = Pos(r, c);
          final o = m.topLeft(pos);
          Widget child = GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: onTap == null ? null : () => onTap!(pos),
            onLongPress: onSecondary == null ? null : () => onSecondary!(pos),
            onSecondaryTap: onSecondary == null ? null : () => onSecondary!(pos),
            child: cellBuilder(context, pos, m),
          );
          if (win != null) child = _WinBump(win: win!, pos: pos, rows: rows, cols: cols, child: child);
          children.add(Positioned(left: o.dx, top: o.dy, width: m.cell, height: m.cell, child: child));
        }
      }
      if (overlayBuilder != null) {
        children.add(Positioned.fill(
          child: IgnorePointer(child: Stack(clipBehavior: Clip.none, children: overlayBuilder!(context, m))),
        ));
      }
      Widget board = SizedBox(
        width: m.width,
        height: m.height,
        child: Stack(clipBehavior: Clip.none, children: children),
      );
      if (onDragStart != null) {
        board = GestureDetector(
          behavior: HitTestBehavior.opaque,
          onPanStart: (d) {
            final p = m.cellAt(d.localPosition);
            if (p != null) onDragStart!(p, d.localPosition);
          },
          onPanUpdate: (d) => onDragUpdate?.call(m.cellAt(d.localPosition), d.localPosition),
          onPanEnd: (_) => onDragEnd?.call(),
          onPanCancel: () => onDragEnd?.call(),
          child: board,
        );
      }
      return Center(child: board);
    });
  }
}

/// Diagonal ripple wave played when the puzzle is solved.
class _WinBump extends StatelessWidget {
  const _WinBump({required this.win, required this.pos, required this.rows, required this.cols, required this.child});

  final Animation<double> win;
  final Pos pos;
  final int rows;
  final int cols;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final span = max(1, rows + cols - 2);
    final d = (pos.r + pos.c) / span;
    return AnimatedBuilder(
      animation: win,
      child: child,
      builder: (context, child) {
        final t = win.value;
        if (t == 0 || t == 1) return child!;
        final local = ((t * 1.6 - d) / 0.6).clamp(0.0, 1.0);
        final s = 1 + 0.16 * sin(pi * local);
        return Transform.scale(scale: s, child: child);
      },
    );
  }
}
