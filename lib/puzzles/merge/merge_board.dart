import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/grid.dart';
import '../../ui/board/cell_grid_board.dart' show BoardMetrics;
import 'merge_model.dart';

/// Tiles keyed by id, so they slide to their new spots; swallowed tiles
/// slide into their partner and fade, grown tiles pulse, new ones grow in.
/// Swipe, or use the arrow keys / WASD.
class MergeBoard extends StatefulWidget {
  const MergeBoard({
    super.key,
    required this.rows,
    required this.cols,
    required this.cells,
    required this.ids,
    required this.merged,
    required this.hinted,
    required this.win,
    required this.onMove,
  });

  final int rows;
  final int cols;
  final List<int> cells;
  final List<int> ids;
  final List<(int, int)> merged;
  final Set<int> hinted;
  final Animation<double>? win;
  final void Function(MergeDir)? onMove;

  /// Tile colors by power of two (2, 4, 8, ...); bigger tiles use the last.
  static const colors = [
    Color(0xFF9ADBD2), // 2
    Color(0xFF5CC0C4), // 4
    Color(0xFF3E9AD6), // 8
    Color(0xFF5B6CFF), // 16
    Color(0xFF8A5CF6), // 32
    Color(0xFFB54FD8), // 64
    Color(0xFFDE559E), // 128
    Color(0xFFF0605D), // 256
    Color(0xFFF5874A), // 512
    Color(0xFFF4AE33), // 1024
    Color(0xFFE9CB2A), // 2048
    Color(0xFF3DBA6A), // 4096
    Color(0xFF1F7A5C), // 8192
    Color(0xFF263041), // 16384+
  ];

  static Color colorOf(int value) => colors[min(colors.length - 1, (log(value) / ln2).round() - 1)];

  @override
  State<MergeBoard> createState() => _MergeBoardState();
}

class _MergeBoardState extends State<MergeBoard> {
  /// Swallowed tiles still sliding in: id → (from cell, to cell, value).
  final _ghosts = <int, (int, int, int)>{};
  final _focus = FocusNode(debugLabel: 'merge board');
  Offset _drag = Offset.zero;
  bool _fired = false;

  static const _slide = Duration(milliseconds: 110);

  @override
  void dispose() {
    _focus.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(MergeBoard old) {
    super.didUpdateWidget(old);
    if (identical(old.ids, widget.ids)) return;
    for (final (id, to) in widget.merged) {
      final from = old.ids.indexOf(id);
      if (from >= 0) _ghosts[id] = (from, to, old.cells[from]);
    }
  }

  void _move(MergeDir dir) => widget.onMove?.call(dir);

  KeyEventResult _key(FocusNode _, KeyEvent e) {
    if (e is! KeyDownEvent && e is! KeyRepeatEvent) return KeyEventResult.ignored;
    final dir = switch (e.logicalKey) {
      LogicalKeyboardKey.arrowUp || LogicalKeyboardKey.keyW => MergeDir.up,
      LogicalKeyboardKey.arrowDown || LogicalKeyboardKey.keyS => MergeDir.down,
      LogicalKeyboardKey.arrowLeft || LogicalKeyboardKey.keyA => MergeDir.left,
      LogicalKeyboardKey.arrowRight || LogicalKeyboardKey.keyD => MergeDir.right,
      _ => null,
    };
    if (dir == null || widget.onMove == null) return KeyEventResult.ignored;
    _move(dir);
    return KeyEventResult.handled;
  }

  @override
  Widget build(BuildContext context) {
    final w = widget;
    final scheme = Theme.of(context).colorScheme;
    return LayoutBuilder(builder: (context, cons) {
      // The header units reserve room for the frame (one gap on each side).
      final m = BoardMetrics.fit(
          space: cons.biggest, rows: w.rows, cols: w.cols, gapRatio: 0.1, maxCell: 110, headerCols: 0.2, headerRows: 0.2);
      final pad = m.gap;
      Offset at(int i) => m.topLeft(Pos(i ~/ w.cols, i % w.cols)) - Offset(m.ox - pad, m.oy - pad);
      Widget placed(int i, Widget child) => SizedBox(width: m.cell, height: m.cell, child: child);

      final children = <Widget>[
        for (var i = 0; i < w.cells.length; i++)
          Positioned(
            left: at(i).dx,
            top: at(i).dy,
            child: placed(
              i,
              DecoratedBox(
                decoration: BoxDecoration(
                  color: scheme.onSurface.withValues(alpha: 0.07),
                  borderRadius: BorderRadius.circular(m.cell * 0.12),
                ),
              ),
            ),
          ),
        for (final MapEntry(key: id, value: (from, to, value)) in _ghosts.entries)
          TweenAnimationBuilder<double>(
            key: ValueKey('g$id'),
            tween: Tween(begin: 0, end: 1),
            duration: _slide,
            curve: Curves.easeOut,
            onEnd: () => setState(() => _ghosts.remove(id)),
            builder: (context, t, child) {
              final o = Offset.lerp(at(from), at(to), t)!;
              return Positioned(left: o.dx, top: o.dy, child: child!);
            },
            child: placed(from, _Tile(value: value, size: m.cell)),
          ),
        for (var i = 0; i < w.cells.length; i++)
          if (w.ids[i] >= 0)
            AnimatedPositioned(
              key: ValueKey(w.ids[i]),
              duration: _slide,
              curve: Curves.easeOut,
              left: at(i).dx,
              top: at(i).dy,
              width: m.cell,
              height: m.cell,
              child: _WinBump(
                win: w.win,
                delay: (i ~/ w.cols + i % w.cols) / max(1, w.rows + w.cols - 2),
                child: _Tile(value: w.cells[i], size: m.cell, ring: w.hinted.contains(i) ? scheme.onSurface : null),
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
            onTap: _focus.requestFocus,
            onPanStart: (_) {
              _drag = Offset.zero;
              _fired = false;
            },
            onPanUpdate: w.onMove == null
                ? null
                : (d) {
                    if (_fired) return;
                    _drag += d.delta;
                    if (_drag.distance < max(18.0, m.cell * 0.3)) return;
                    _fired = true;
                    _move(_drag.dx.abs() > _drag.dy.abs()
                        ? (_drag.dx > 0 ? MergeDir.right : MergeDir.left)
                        : (_drag.dy > 0 ? MergeDir.down : MergeDir.up));
                  },
            child: Container(
              width: m.width - m.ox + pad * 2,
              height: m.height - m.oy + pad * 2,
              decoration: BoxDecoration(
                color: scheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(m.cell * 0.16),
              ),
              child: Stack(clipBehavior: Clip.none, children: children),
            ),
          ),
        ),
      );
    });
  }
}

/// One tile; grows in when new and pulses when its value goes up.
class _Tile extends StatefulWidget {
  const _Tile({required this.value, required this.size, this.ring});

  final int value;
  final double size;
  final Color? ring;

  @override
  State<_Tile> createState() => _TileState();
}

class _TileState extends State<_Tile> with SingleTickerProviderStateMixin {
  late final _anim = AnimationController(vsync: this, duration: const Duration(milliseconds: 180))..forward();
  bool _grown = false;

  @override
  void didUpdateWidget(_Tile old) {
    super.didUpdateWidget(old);
    if (widget.value > old.value) {
      _grown = true;
      _anim.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _anim.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = MergeBoard.colorOf(widget.value);
    final text = '${widget.value}';
    final ink = color.computeLuminance() > 0.45 ? const Color(0xFF1B2230) : Colors.white;
    final font = widget.size * switch (text.length) { 1 || 2 => 0.44, 3 => 0.36, 4 => 0.28, _ => 0.23 };
    return AnimatedBuilder(
      animation: _anim,
      builder: (context, child) {
        final t = Curves.easeOut.transform(_anim.value);
        // New tiles grow from small; merged ones overshoot and settle.
        final scale = _grown ? 1 + 0.14 * sin(pi * t) : 0.3 + 0.7 * t;
        return Transform.scale(scale: scale, child: child);
      },
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(widget.size * 0.12),
          border: widget.ring == null ? null : Border.all(color: widget.ring!, width: 3),
          boxShadow: widget.value >= 1024 ? [BoxShadow(color: color.withValues(alpha: 0.55), blurRadius: widget.size * 0.18)] : null,
        ),
        alignment: Alignment.center,
        child: Text(
          text,
          maxLines: 1,
          style: TextStyle(color: ink, fontSize: font, fontWeight: FontWeight.w800, height: 1),
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
