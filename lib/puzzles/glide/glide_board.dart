import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/grid.dart';
import '../../ui/board/cell_grid_board.dart' show BoardMetrics;

/// The frame: tiles keyed by number, so they slide to their new spots. Tap a
/// tile in the gap's row or column to slide it (and those between) into the
/// gap; swipe a tile toward the gap, or swipe anywhere to slide the tile that
/// can go that way; arrow keys / WASD too.
class GlideBoard extends StatefulWidget {
  const GlideBoard({
    super.key,
    required this.rows,
    required this.cols,
    required this.tiles,
    required this.colors,
    required this.hinted,
    required this.win,
    required this.onTap,
    required this.onSwipe,
  });

  final int rows;
  final int cols;
  final List<int> tiles;

  /// Tiles show their home's color in a gradient instead of a number.
  final bool colors;
  final Set<int> hinted;
  final Animation<double>? win;
  final void Function(int cell)? onTap;

  /// A swipe from [cell] (null for a key) that moves tiles in direction [dir]
  /// ('u', 'd', 'l' or 'r').
  final void Function(int? cell, String dir)? onSwipe;

  static const tile = Color(0xFFE2A85A);
  static const _ink = Color(0xFF3B2610);

  /// The gradient color of the tile whose home is [home].
  static Color colorOf(int home, int rows, int cols) {
    final r = home ~/ cols, c = home % cols;
    final across = cols == 1 ? 0.0 : c / (cols - 1);
    final down = rows == 1 ? 0.0 : r / (rows - 1);
    return HSLColor.fromAHSL(1, 5 + 215 * across, 0.68, 0.78 - 0.42 * down).toColor();
  }

  @override
  State<GlideBoard> createState() => _GlideBoardState();
}

class _GlideBoardState extends State<GlideBoard> {
  final _focus = FocusNode(debugLabel: 'glide board');
  Offset _drag = Offset.zero;
  int? _from;
  bool _fired = false;

  static const _slide = Duration(milliseconds: 120);

  @override
  void dispose() {
    _focus.dispose();
    super.dispose();
  }

  KeyEventResult _key(FocusNode _, KeyEvent e) {
    if (e is! KeyDownEvent && e is! KeyRepeatEvent) return KeyEventResult.ignored;
    final dir = switch (e.logicalKey) {
      LogicalKeyboardKey.arrowUp || LogicalKeyboardKey.keyW => 'u',
      LogicalKeyboardKey.arrowDown || LogicalKeyboardKey.keyS => 'd',
      LogicalKeyboardKey.arrowLeft || LogicalKeyboardKey.keyA => 'l',
      LogicalKeyboardKey.arrowRight || LogicalKeyboardKey.keyD => 'r',
      _ => null,
    };
    if (dir == null || widget.onSwipe == null) return KeyEventResult.ignored;
    widget.onSwipe!(null, dir);
    return KeyEventResult.handled;
  }

  @override
  Widget build(BuildContext context) {
    final w = widget;
    final scheme = Theme.of(context).colorScheme;
    return LayoutBuilder(
      builder: (context, cons) {
        // The header units reserve room for the frame (one gap on each side).
        final m = BoardMetrics.fit(
          space: cons.biggest,
          rows: w.rows,
          cols: w.cols,
          gapRatio: 0.07,
          maxCell: 100,
          headerCols: 0.3,
          headerRows: 0.3,
        );
        final pad = m.gap * 2;
        Offset at(int i) => m.topLeft(Pos(i ~/ w.cols, i % w.cols)) - Offset(m.ox - pad, m.oy - pad);
        int? cellAt(Offset p) {
          for (var i = 0; i < w.tiles.length; i++) {
            final o = at(i);
            if (p.dx >= o.dx - m.gap / 2 &&
                p.dy >= o.dy - m.gap / 2 &&
                p.dx < o.dx + m.cell + m.gap / 2 &&
                p.dy < o.dy + m.cell + m.gap / 2) {
              return i;
            }
          }
          return null;
        }

        final children = <Widget>[
          for (var i = 0; i < w.tiles.length; i++)
            if (w.tiles[i] != 0)
              AnimatedPositioned(
                key: ValueKey(w.tiles[i]),
                duration: _slide,
                curve: Curves.easeOut,
                left: at(i).dx,
                top: at(i).dy,
                width: m.cell,
                height: m.cell,
                child: _WinBump(
                  win: w.win,
                  delay: (i ~/ w.cols + i % w.cols) / max(1, w.rows + w.cols - 2),
                  child: _Tile(
                    number: w.tiles[i],
                    color: w.colors ? GlideBoard.colorOf(w.tiles[i] - 1, w.rows, w.cols) : null,
                    size: m.cell,
                    ring: w.hinted.contains(i) ? scheme.onSurface : null,
                  ),
                ),
              ),
        ];

        return Center(
          child: Focus(
            focusNode: _focus,
            autofocus: true,
            onKeyEvent: _key,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTapUp: (d) {
                _focus.requestFocus();
                final cell = cellAt(d.localPosition);
                if (cell != null) w.onTap?.call(cell);
              },
              onPanStart: (d) {
                _drag = Offset.zero;
                _from = cellAt(d.localPosition);
                _fired = false;
              },
              onPanUpdate: w.onSwipe == null
                  ? null
                  : (d) {
                      if (_fired) return;
                      _drag += d.delta;
                      if (_drag.distance < max(16.0, m.cell * 0.25)) return;
                      _fired = true;
                      w.onSwipe!(
                        _from,
                        _drag.dx.abs() > _drag.dy.abs() ? (_drag.dx > 0 ? 'r' : 'l') : (_drag.dy > 0 ? 'd' : 'u'),
                      );
                    },
              child: Container(
                width: m.width - m.ox + pad * 2,
                height: m.height - m.oy + pad * 2,
                decoration: BoxDecoration(
                  color: scheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(m.cell * 0.16),
                  border: Border.all(color: scheme.outlineVariant, width: 2),
                ),
                child: Stack(clipBehavior: Clip.none, children: children),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// One tile: a number on wood, or a patch of the gradient.
class _Tile extends StatelessWidget {
  const _Tile({required this.number, required this.color, required this.size, this.ring});

  final int number;
  final Color? color;
  final double size;
  final Color? ring;

  @override
  Widget build(BuildContext context) {
    final fill = color ?? GlideBoard.tile;
    final text = '$number';
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(size * 0.14),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color.lerp(fill, Colors.white, 0.18)!, fill, Color.lerp(fill, Colors.black, 0.12)!],
        ),
        border: Border.all(color: ring ?? Color.lerp(fill, Colors.black, 0.25)!, width: ring == null ? 1 : 3),
        boxShadow: const [BoxShadow(color: Color(0x40000000), blurRadius: 3, offset: Offset(0, 1.5))],
      ),
      alignment: Alignment.center,
      child: color != null
          ? null
          : Text(
              text,
              maxLines: 1,
              style: TextStyle(
                color: GlideBoard._ink,
                fontSize: size * (text.length == 1 ? 0.46 : 0.4),
                fontWeight: FontWeight.w800,
                height: 1,
              ),
            ),
    );
  }
}

/// The win ripple, per tile.
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
        return Transform.scale(scale: 1 + 0.12 * sin(pi * local), child: child);
      },
    );
  }
}
