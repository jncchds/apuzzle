import 'package:flutter/material.dart';

import '../../ui/board/cell_grid_board.dart';
import 'pipes_model.dart';

/// One rotating pipe tile, shared by the pipe games: the tile's plate, the
/// pipe drawn in its solved orientation and turned by [turns] quarter turns
/// (animated forward), and the water color fading in and out.
class PipeTile extends StatelessWidget {
  const PipeTile({
    super.key,
    required this.bm,
    required this.mask,
    required this.turns,
    required this.lit,
    this.crossLit = false,
    this.source = false,
    this.target = false,
    this.locked = false,
    this.bridge = false,
    this.error = false,
    this.flash = false,
  });

  static const water = Color(0xFF6FA8F5);

  final BoardMetrics bm;
  final int mask;
  final int turns;

  /// Water flows through the tile (through its east-west pipe on a bridge).
  final bool lit;

  /// Water flows through the north-south pipe of a bridge.
  final bool crossLit;
  final bool source;
  final bool target;
  final bool locked;

  /// A crossing whose two pipes pass over each other without joining.
  final bool bridge;
  final bool error;
  final bool flash;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final dry = scheme.outline.withValues(alpha: 0.55);
    Widget tween(bool on, Widget Function(Color) child) => TweenAnimationBuilder<Color?>(
      tween: ColorTween(end: on ? water : dry),
      duration: const Duration(milliseconds: 260),
      builder: (context, color, _) => child(color!),
    );
    return Container(
      decoration: BoxDecoration(
        color: locked ? scheme.surfaceContainerHighest : scheme.surfaceContainer,
        borderRadius: BorderRadius.circular(bm.cell * 0.12),
        border: error
            ? Border.all(color: scheme.error, width: 2)
            : flash
            ? Border.all(color: scheme.tertiary, width: 2)
            : null,
      ),
      child: AnimatedRotation(
        turns: turns / 4,
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        child: tween(
          lit,
          (color) => bridge
              ? tween(
                  crossLit,
                  (cross) => CustomPaint(
                    painter: PipePainter(
                      mask: mask,
                      color: color,
                      crossColor: cross,
                      outline: scheme.onSurface.withValues(alpha: 0.35),
                      bridge: true,
                      locked: locked,
                    ),
                  ),
                )
              : CustomPaint(
                  painter: PipePainter(
                    mask: mask,
                    color: color,
                    outline: scheme.onSurface.withValues(alpha: 0.35),
                    source: source,
                    target: target,
                    locked: locked,
                  ),
                ),
        ),
      ),
    );
  }
}

/// A pipe tile's pipes in a square: arms from the centre to the sides in
/// [mask], a bulb on a dead end, the source's ring, the target's mark, and
/// the dot of a fixed tile. A bridge draws two straight pipes, the
/// north-south one over the east-west one.
class PipePainter extends CustomPainter {
  PipePainter({
    required this.mask,
    required this.color,
    required this.outline,
    this.crossColor,
    this.source = false,
    this.target = false,
    this.locked = false,
    this.bridge = false,
  });

  final int mask;
  final Color color;
  final Color? crossColor;
  final Color outline;
  final bool source;
  final bool target;
  final bool locked;
  final bool bridge;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final c = Offset(w / 2, w / 2);
    final thick = w * 0.26;
    final edge = Paint()
      ..color = outline
      ..strokeWidth = thick + w * 0.06
      ..strokeCap = StrokeCap.butt;
    Paint fill(Color color) => Paint()
      ..color = color
      ..strokeWidth = thick
      ..strokeCap = StrokeCap.butt;
    if (bridge) {
      canvas.drawLine(Offset(0, w / 2), Offset(w, w / 2), edge);
      canvas.drawLine(Offset(0, w / 2), Offset(w, w / 2), fill(color));
      // The upper pipe: a wider rim where it passes over the lower one.
      final rim = Paint()
        ..color = outline
        ..strokeWidth = thick + w * 0.14;
      canvas.drawLine(Offset(w / 2, w * 0.2), Offset(w / 2, w * 0.8), rim);
      canvas.drawLine(Offset(w / 2, 0), Offset(w / 2, w), edge);
      canvas.drawLine(Offset(w / 2, 0), Offset(w / 2, w), fill(crossColor ?? color));
      _lockDot(canvas, w);
      return;
    }
    if (mask == 0) {
      _lockDot(canvas, w);
      return;
    }
    final arms = [
      if (mask & dN != 0) Offset(w / 2, 0),
      if (mask & dE != 0) Offset(w, w / 2),
      if (mask & dS != 0) Offset(w / 2, w),
      if (mask & dW != 0) Offset(0, w / 2),
    ];
    for (final a in arms) {
      canvas.drawLine(c, a, edge);
    }
    final bulb = arms.length == 1 || source || target;
    final hubR = bulb ? w * 0.27 : thick / 2;
    canvas.drawCircle(c, hubR + w * 0.03, Paint()..color = outline);
    for (final a in arms) {
      canvas.drawLine(c, a, fill(color));
    }
    canvas.drawCircle(c, hubR, Paint()..color = color);
    if (source) {
      canvas.drawCircle(c, w * 0.12, Paint()..color = outline.withValues(alpha: 0.9));
      canvas.drawCircle(c, w * 0.08, Paint()..color = color);
    }
    if (target) {
      // A drain: a square with a dot in the middle.
      canvas.drawRRect(
        RRect.fromRectAndRadius(Rect.fromCircle(center: c, radius: w * 0.13), Radius.circular(w * 0.03)),
        Paint()
          ..color = outline.withValues(alpha: 0.9)
          ..style = PaintingStyle.stroke
          ..strokeWidth = w * 0.04,
      );
      canvas.drawCircle(c, w * 0.045, Paint()..color = outline.withValues(alpha: 0.9));
    }
    _lockDot(canvas, w);
  }

  void _lockDot(Canvas canvas, double w) {
    if (locked) {
      canvas.drawCircle(Offset(w * 0.86, w * 0.14), w * 0.05, Paint()..color = outline);
    }
  }

  @override
  bool shouldRepaint(PipePainter old) =>
      old.mask != mask ||
      old.color != color ||
      old.crossColor != crossColor ||
      old.source != source ||
      old.target != target ||
      old.locked != locked ||
      old.bridge != bridge ||
      old.outline != outline;
}
