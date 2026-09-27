import 'package:flutter/material.dart';

import 'cell_grid_board.dart';

/// Thick lines between cells of different regions (and around the board).
/// [regionOf] maps a flat index (r * cols + c) to a region id; or [split]
/// says directly whether two neighbouring cells get a line between them.
class RegionBorders extends StatelessWidget {
  const RegionBorders({super.key, required this.metrics, this.regionOf, this.split, this.color, this.outer = true})
      : assert(regionOf != null || split != null);

  final BoardMetrics metrics;
  final int Function(int index)? regionOf;
  final bool Function(int a, int b)? split;
  final Color? color;
  final bool outer;

  @override
  Widget build(BuildContext context) => Positioned.fill(
        child: CustomPaint(
          painter: _RegionPainter(metrics, split ?? (a, b) => regionOf!(a) != regionOf!(b), color ?? Theme.of(context).colorScheme.onSurface, outer),
        ),
      );
}

class _RegionPainter extends CustomPainter {
  _RegionPainter(this.m, this.split, this.color, this.outer);

  final BoardMetrics m;
  final bool Function(int a, int b) split;
  final Color color;
  final bool outer;

  @override
  void paint(Canvas canvas, Size size) {
    final w = (m.cell * 0.07).clamp(2.0, 4.0);
    final paint = Paint()
      ..color = color
      ..strokeWidth = w
      ..strokeCap = StrokeCap.round;
    final half = m.gap / 2;
    for (var r = 0; r < m.rows; r++) {
      for (var c = 0; c < m.cols; c++) {
        final i = r * m.cols + c;
        final x0 = m.x(c) - half, y0 = m.y(r) - half;
        final x1 = m.x(c) + m.cell + half, y1 = m.y(r) + m.cell + half;
        if (c + 1 < m.cols && split(i, i + 1)) {
          canvas.drawLine(Offset(x1, y0), Offset(x1, y1), paint);
        }
        if (r + 1 < m.rows && split(i, i + m.cols)) {
          canvas.drawLine(Offset(x0, y1), Offset(x1, y1), paint);
        }
      }
    }
    if (outer) {
      final rect = Rect.fromLTWH(-half, -half, m.width + m.gap, m.height + m.gap);
      canvas.drawRRect(
        RRect.fromRectAndRadius(rect, Radius.circular(m.cell * 0.18)),
        paint..style = PaintingStyle.stroke,
      );
    }
  }

  @override
  bool shouldRepaint(_RegionPainter old) => true;
}
