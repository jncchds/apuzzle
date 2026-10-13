import 'package:flutter/material.dart';

import 'cell_grid_board.dart';

/// Thick lines between cells of different regions (and around the board),
/// with rounded corners.
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
      painter: _RegionPainter(
        metrics,
        split ?? (a, b) => regionOf!(a) != regionOf!(b),
        color ?? Theme.of(context).colorScheme.onSurface,
        outer,
      ),
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
    final radius = m.cell * 0.18;
    final half = m.gap / 2;
    final rows = m.rows, cols = m.cols;
    double vx(int c) => c < cols ? m.x(c) - half : m.x(cols - 1) + m.cell + half;
    double vy(int r) => r < rows ? m.y(r) - half : m.y(rows - 1) + m.cell + half;
    // Lines along the lattice: below row r - 1 from column c, and right of column c - 1 from row r.
    bool across(int r, int c) => r == 0 || r == rows ? outer : split((r - 1) * cols + c, r * cols + c);
    bool down(int r, int c) => c == 0 || c == cols ? outer : split(r * cols + c - 1, r * cols + c);

    // A lone bend becomes an arc; where three or four lines meet, the inner corners are filled in.
    final lines = Path(), fillets = Path();
    final bends = <int>{};
    const arc = 0.70710678;
    for (var r = 0; r <= rows; r++) {
      for (var c = 0; c <= cols; c++) {
        final up = r > 0 && down(r - 1, c), dn = r < rows && down(r, c);
        final left = c > 0 && across(r, c - 1), right = c < cols && across(r, c);
        final n = (up ? 1 : 0) + (dn ? 1 : 0) + (left ? 1 : 0) + (right ? 1 : 0);
        final x = vx(c), y = vy(r);
        if (n == 2 && up != dn) {
          bends.add(r * (cols + 1) + c);
          final dx = right ? radius : -radius, dy = dn ? radius : -radius;
          lines
            ..moveTo(x + dx, y)
            ..conicTo(x, y, x, y + dy, arc);
        } else if (n > 2) {
          for (final (h, v, dx, dy) in [
            (right, dn, radius, radius),
            (right, up, radius, -radius),
            (left, dn, -radius, radius),
            (left, up, -radius, -radius),
          ]) {
            if (!h || !v) continue;
            fillets
              ..moveTo(x, y)
              ..lineTo(x + dx, y)
              ..conicTo(x, y, x, y + dy, arc)
              ..close();
          }
        }
      }
    }
    double trim(int r, int c) => bends.contains(r * (cols + 1) + c) ? radius : 0;
    for (var r = 0; r <= rows; r++) {
      for (var c = 0; c <= cols; c++) {
        if (c < cols && across(r, c)) {
          lines
            ..moveTo(vx(c) + trim(r, c), vy(r))
            ..lineTo(vx(c + 1) - trim(r, c + 1), vy(r));
        }
        if (r < rows && down(r, c)) {
          lines
            ..moveTo(vx(c), vy(r) + trim(r, c))
            ..lineTo(vx(c), vy(r + 1) - trim(r + 1, c));
        }
      }
    }

    // One layer, so overlapping pieces of a translucent color don't add up.
    final solid = color.withValues(alpha: 1);
    canvas.saveLayer(null, Paint()..color = Color.fromRGBO(0, 0, 0, color.a));
    canvas.drawPath(
      lines,
      Paint()
        ..color = solid
        ..style = PaintingStyle.stroke
        ..strokeWidth = w
        ..strokeCap = StrokeCap.round,
    );
    canvas.drawPath(fillets, Paint()..color = solid);
    canvas.restore();
  }

  @override
  bool shouldRepaint(_RegionPainter old) => true;
}
