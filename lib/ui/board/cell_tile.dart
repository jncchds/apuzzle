import 'package:flutter/material.dart';

/// Standard animated cell: rounded tile with color tween, pop-in content,
/// selection ring and error/hint overlays.
class CellTile extends StatelessWidget {
  const CellTile({
    super.key,
    required this.size,
    required this.content,
    this.color,
    this.given = false,
    this.showLock = true,
    this.selected = false,
    this.emphasis = false,
    this.error = false,
    this.hinted = false,
  });

  final double size;

  /// Must carry a key that changes with the value so the pop animation plays.
  final Widget content;
  final Color? color;
  final bool given;
  final bool showLock;
  final bool selected;

  /// Subtle tint, e.g. cells sharing the selected value.
  final bool emphasis;
  final bool error;
  final bool hinted;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final radius = BorderRadius.circular(size * 0.18);
    final bg = color ??
        (given
            ? Color.alphaBlend(scheme.primary.withValues(alpha: 0.14), scheme.surfaceContainerHighest)
            : scheme.surfaceContainer);
    final tinted = emphasis && color == null ? Color.alphaBlend(scheme.primary.withValues(alpha: 0.22), bg) : bg;
    final borderColor = selected
        ? scheme.primary
        : hinted
            ? scheme.tertiary
            : given
                ? scheme.outline.withValues(alpha: 0.55)
                : scheme.outlineVariant.withValues(alpha: 0.6);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOut,
      decoration: BoxDecoration(
        color: tinted,
        borderRadius: radius,
        border: Border.all(color: borderColor, width: selected || hinted ? size * 0.06 : 1.2),
        boxShadow: given
            ? null
            : [BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 2, offset: const Offset(0, 1))],
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Center(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 240),
              switchInCurve: Curves.easeOutBack,
              switchOutCurve: Curves.easeIn,
              transitionBuilder: (child, anim) => ScaleTransition(
                scale: anim,
                child: FadeTransition(opacity: anim, child: child),
              ),
              child: content,
            ),
          ),
          if (given && showLock)
            Positioned(
              right: size * 0.08,
              bottom: size * 0.06,
              child: Icon(Icons.lock_rounded, size: size * 0.14, color: scheme.outline.withValues(alpha: 0.6)),
            ),
          IgnorePointer(
            child: AnimatedOpacity(
              opacity: error ? 1 : 0,
              duration: const Duration(milliseconds: 180),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: scheme.error.withValues(alpha: 0.28),
                  borderRadius: radius,
                  border: Border.all(color: scheme.error, width: size * 0.05),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
