import 'dart:math';

import 'package:flutter/material.dart';

import '../../core/grid.dart';
import '../../ui/board/cell_grid_board.dart' show BoardMetrics;

/// Bubbles keyed by id, so they fall and slide to their new spots; popped
/// ones shrink away and new ones grow in.
class PopBoard extends StatefulWidget {
  const PopBoard({
    super.key,
    required this.rows,
    required this.cols,
    required this.cells,
    required this.ids,
    required this.palette,
    required this.selected,
    required this.hinted,
    required this.win,
    required this.onTap,
  });

  final int rows;
  final int cols;
  final List<int> cells;
  final List<int> ids;
  final List<Color> palette;
  final Set<int> selected;
  final Set<int> hinted;
  final Animation<double>? win;
  final void Function(Pos)? onTap;

  @override
  State<PopBoard> createState() => _PopBoardState();
}

class _PopBoardState extends State<PopBoard> {
  /// Popped bubbles still shrinking: id → (cell, color).
  final _ghosts = <int, (int, int)>{};

  static const _move = Duration(milliseconds: 240);

  @override
  void didUpdateWidget(PopBoard old) {
    super.didUpdateWidget(old);
    if (identical(old.ids, widget.ids)) return;
    final now = widget.ids.toSet();
    for (var i = 0; i < old.ids.length; i++) {
      final id = old.ids[i];
      if (id >= 0 && !now.contains(id)) _ghosts[id] = (i, old.cells[i]);
    }
    _ghosts.removeWhere((id, _) => now.contains(id));
  }

  @override
  Widget build(BuildContext context) {
    final w = widget;
    final scheme = Theme.of(context).colorScheme;
    return LayoutBuilder(builder: (context, cons) {
      final m = BoardMetrics.fit(space: cons.biggest, rows: w.rows, cols: w.cols, gapRatio: 0.04, maxCell: 64);
      Offset at(int i) => m.topLeft(Pos(i ~/ w.cols, i % w.cols));
      final picking = w.selected.isNotEmpty;

      final children = <Widget>[
        for (final MapEntry(key: id, value: (i, color)) in _ghosts.entries)
          Positioned(
            key: ValueKey('g$id'),
            left: at(i).dx,
            top: at(i).dy,
            width: m.cell,
            height: m.cell,
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 1, end: 0),
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeIn,
              onEnd: () => setState(() => _ghosts.remove(id)),
              builder: (context, t, _) => Opacity(
                opacity: t,
                child: Transform.scale(scale: 0.6 + 0.6 * (1 - t), child: _Bubble(color: w.palette[color])),
              ),
            ),
          ),
        for (var i = 0; i < w.cells.length; i++)
          if (w.ids[i] >= 0)
            AnimatedPositioned(
              key: ValueKey(w.ids[i]),
              duration: _move,
              curve: Curves.easeInCubic,
              left: at(i).dx,
              top: at(i).dy,
              width: m.cell,
              height: m.cell,
              child: _WinBump(
                win: w.win,
                delay: (i ~/ w.cols + i % w.cols) / max(1, w.rows + w.cols - 2),
                child: TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0, end: 1),
                  duration: const Duration(milliseconds: 220),
                  curve: Curves.easeOutBack,
                  builder: (context, grow, child) => Transform.scale(scale: grow, child: child),
                  child: AnimatedScale(
                    scale: w.selected.contains(i) ? 1.06 : 1,
                    duration: const Duration(milliseconds: 120),
                    child: AnimatedOpacity(
                      opacity: picking && !w.selected.contains(i) ? 0.55 : 1,
                      duration: const Duration(milliseconds: 120),
                      child: _Bubble(
                        color: w.palette[w.cells[i]],
                        ring: w.selected.contains(i)
                            ? scheme.onSurface
                            : w.hinted.contains(i)
                                ? scheme.primary
                                : null,
                      ),
                    ),
                  ),
                ),
              ),
            ),
      ];

      return Center(
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTapUp: w.onTap == null
              ? null
              : (d) {
                  final pos = m.cellAt(d.localPosition);
                  if (pos != null) w.onTap!(pos);
                },
          child: SizedBox(
            width: m.width,
            height: m.height,
            child: Stack(clipBehavior: Clip.none, children: children),
          ),
        ),
      );
    });
  }
}

class _Bubble extends StatelessWidget {
  const _Bubble({required this.color, this.ring});

  final Color color;
  final Color? ring;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(1),
        child: DecoratedBox(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              center: const Alignment(-0.35, -0.4),
              radius: 0.95,
              colors: [Color.lerp(color, Colors.white, 0.5)!, color, Color.lerp(color, Colors.black, 0.28)!],
              stops: const [0, 0.5, 1],
            ),
            border: ring == null ? null : Border.all(color: ring!, width: 2.5),
          ),
          child: const SizedBox.expand(),
        ),
      );
}

/// The win ripple, per bubble.
class _WinBump extends StatelessWidget {
  const _WinBump({required this.win, required this.delay, required this.child});

  final Animation<double>? win;
  final double delay;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final a = win;
    if (a == null) return child;
    return AnimatedBuilder(
      animation: a,
      child: child,
      builder: (context, child) {
        final t = a.value;
        if (t == 0 || t == 1) return child!;
        final local = ((t * 1.6 - delay) / 0.6).clamp(0.0, 1.0);
        return Transform.scale(scale: 1 + 0.16 * sin(pi * local), child: child);
      },
    );
  }
}
