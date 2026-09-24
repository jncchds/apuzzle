import 'dart:math';

import 'package:flutter/material.dart';

import '../core/game_controller.dart';
import 'new_game_sheet.dart' show formatDuration;
import 'puzzle_code_ui.dart';

/// Confetti + result card shown after solving.
class WinOverlay extends StatelessWidget {
  const WinOverlay({super.key, required this.animation, required this.controller, required this.onNew, required this.onHome});

  final Animation<double> animation;
  final GameController controller;
  final VoidCallback onNew;
  final VoidCallback onHome;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final card = CurvedAnimation(parent: animation, curve: const Interval(0.45, 1, curve: Curves.easeOutBack));
    final stats = controller.winStats;
    final time = controller.elapsed;
    final isBest = stats?.bestMs == time.inMilliseconds;
    final hints = controller.hintsUsed;
    final shareText = 'I solved this ${controller.type.name} in ${formatDuration(time)}'
        '${hints > 0 ? ' with $hints hint${hints == 1 ? '' : 's'}' : ''}. Can you beat it? ${controller.link}';

    return Stack(children: [
      Positioned.fill(
        child: IgnorePointer(
          child: AnimatedBuilder(
            animation: animation,
            builder: (context, _) => CustomPaint(painter: _ConfettiPainter(animation.value, theme.colorScheme)),
          ),
        ),
      ),
      Align(
        alignment: Alignment.bottomCenter,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: ScaleTransition(
              scale: card,
              child: Card(
                elevation: 8,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Solved!', style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800)),
                      const SizedBox(height: 8),
                      Text(
                        '${formatDuration(time)}${isBest ? ' · new best!' : stats?.best != null ? ' · best ${formatDuration(stats!.best!)}' : ''}'
                        '${controller.hintsUsed > 0 ? ' · ${controller.hintsUsed} hint${controller.hintsUsed == 1 ? '' : 's'}' : ''}',
                        style: theme.textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 4),
                      Text(controller.code, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                      const SizedBox(height: 16),
                      Row(mainAxisSize: MainAxisSize.min, children: [
                        IconButton(
                          icon: const Icon(Icons.share_rounded),
                          tooltip: 'Copy result to share',
                          onPressed: () => copyWithToast(context, shareText, 'Result copied, paste it to a friend'),
                        ),
                        const SizedBox(width: 4),
                        OutlinedButton(onPressed: onHome, child: const Text('Home')),
                        const SizedBox(width: 12),
                        FilledButton.icon(
                          onPressed: onNew,
                          icon: const Icon(Icons.auto_awesome_rounded),
                          label: const Text('New puzzle'),
                        ),
                      ]),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    ]);
  }
}

class _ConfettiPainter extends CustomPainter {
  _ConfettiPainter(this.t, this.scheme);

  final double t;
  final ColorScheme scheme;

  @override
  void paint(Canvas canvas, Size size) {
    if (t <= 0 || t >= 1) return;
    final rng = Random(7);
    final colors = [scheme.primary, scheme.tertiary, scheme.secondary, const Color(0xFFF5A524), const Color(0xFFE85D75)];
    final paint = Paint();
    for (var i = 0; i < 90; i++) {
      final x0 = rng.nextDouble() * size.width;
      final speed = 0.6 + rng.nextDouble() * 0.8;
      final drift = (rng.nextDouble() - 0.5) * 120;
      final y = -20 + t * speed * (size.height + 60);
      final x = x0 + drift * t + sin(t * 12 + i) * 10;
      paint.color = colors[i % colors.length].withValues(alpha: (1 - t).clamp(0, 1) * 0.9 + 0.1);
      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(t * 10 + i);
      canvas.drawRect(const Rect.fromLTWH(-4, -2, 8, 4), paint);
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(_ConfettiPainter old) => old.t != t;
}
