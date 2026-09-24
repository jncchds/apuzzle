import 'package:flutter/material.dart';

/// Hand-drawn symbols used by puzzles (no external assets).
class CrownSymbol extends StatelessWidget {
  const CrownSymbol({super.key, required this.size, this.color});

  final double size;
  final Color? color;

  @override
  Widget build(BuildContext context) => CustomPaint(
        size: Size.square(size),
        painter: _CrownPainter(color ?? Theme.of(context).colorScheme.onSurface),
      );
}

class _CrownPainter extends CustomPainter {
  _CrownPainter(this.color);
  final Color color;

  @override
  void paint(Canvas canvas, Size s) {
    final w = s.width, h = s.height;
    final p = Path()
      ..moveTo(w * 0.12, h * 0.34)
      ..lineTo(w * 0.32, h * 0.52)
      ..lineTo(w * 0.5, h * 0.22)
      ..lineTo(w * 0.68, h * 0.52)
      ..lineTo(w * 0.88, h * 0.34)
      ..lineTo(w * 0.8, h * 0.74)
      ..lineTo(w * 0.2, h * 0.74)
      ..close();
    final paint = Paint()..color = color;
    canvas.drawPath(p, paint);
    canvas.drawRRect(RRect.fromLTRBR(w * 0.2, h * 0.78, w * 0.8, h * 0.86, Radius.circular(h * 0.03)), paint);
    for (final x in [0.12, 0.5, 0.88]) {
      canvas.drawCircle(Offset(w * x, h * (x == 0.5 ? 0.2 : 0.32)), w * 0.06, paint);
    }
  }

  @override
  bool shouldRepaint(_CrownPainter old) => old.color != color;
}

class DotSymbol extends StatelessWidget {
  const DotSymbol({super.key, required this.size, this.color});
  final double size;
  final Color? color;

  @override
  Widget build(BuildContext context) => SizedBox.square(
        dimension: size,
        child: Center(
          child: Container(
            width: size * 0.2,
            height: size * 0.2,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color ?? Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
        ),
      );
}

/// Soft pastel palette for regions (works on light and dark backgrounds).
const regionColors = <Color>[
  Color(0xFFB39DDB), Color(0xFF90CAF9), Color(0xFFA5D6A7), Color(0xFFFFCC80), Color(0xFFEF9A9A),
  Color(0xFF80DEEA), Color(0xFFF48FB1), Color(0xFFE6EE9C), Color(0xFFBCAAA4), Color(0xFFB0BEC5),
  Color(0xFFFFAB91), Color(0xFFCE93D8),
];
