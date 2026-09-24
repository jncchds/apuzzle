import 'package:flutter/material.dart';

import 'cell_grid_board.dart';

/// Thick lines between cells of different regions (and around the board).
/// [regionOf] maps a flat index (r * cols + c) to a region id.
class RegionBorders extends StatelessWidget {
  const RegionBorders({super.key, required this.metrics, required this.regionOf, this.color, this.outer = true});

  final BoardMetrics metrics;
  final int Function(int index) regionOf;
  final Color? color;
  final bool outer;

  @override
  Widget build(BuildContext context) => Positioned.fill(
        child: CustomPaint(
          painter: _RegionPainter(metrics, regionOf, color ?? Theme.of(context).colorScheme.onSurface, outer),
        ),
      );
}

class _RegionPainter extends CustomPainter {
  _RegionPainter(this.m, this.regionOf, this.color, this.outer);

  final BoardMetrics m;
  final int Function(int) regionOf;
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
        final id = regionOf(r * m.cols + c);
        final x0 = m.x(c) - half, y0 = m.y(r) - half;
        final x1 = m.x(c) + m.cell + half, y1 = m.y(r) + m.cell + half;
        if (c + 1 < m.cols && regionOf(r * m.cols + c + 1) != id) {
          canvas.drawLine(Offset(x1, y0), Offset(x1, y1), paint);
        }
        if (r + 1 < m.rows && regionOf((r + 1) * m.cols + c) != id) {
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
  bool shouldRepaint(_RegionPainter old) => old.m.cell != m.cell || old.color != color;
}
