import 'package:flutter/material.dart';

import '../core/game_controller.dart';
import '../core/value_grid.dart';
import '../l10n/l10n.dart';

/// Bottom palette: one button per value, eraser and (optional) pencil toggle.
class InputPalette extends StatelessWidget {
  const InputPalette({
    super.key,
    required this.values,
    required this.supportsPencil,
    required this.controller,
    required this.onTool,
  });

  final List<ValueSpec> values;
  final bool supportsPencil;
  final GameController controller;
  final void Function(int tool) onTool;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final l = context.l10n;
    final n = values.length + 1 + (supportsPencil ? 1 : 0);
    return LayoutBuilder(builder: (context, cons) {
      final size = ((cons.maxWidth - 8 * (n - 1)) / n).clamp(36.0, 60.0);
      Widget button({required Widget child, required bool active, required VoidCallback onTap, String? tooltip}) {
        return Tooltip(
          message: tooltip ?? '',
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 160),
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: active ? scheme.primaryContainer : scheme.surfaceContainerHigh,
              borderRadius: BorderRadius.circular(size * 0.22),
              border: Border.all(color: active ? scheme.primary : scheme.outlineVariant, width: active ? 3 : 1),
            ),
            child: Material(
              type: MaterialType.transparency,
              child: InkWell(
                borderRadius: BorderRadius.circular(size * 0.22),
                onTap: onTap,
                child: Center(child: child),
              ),
            ),
          ),
        );
      }

      return Wrap(
        alignment: WrapAlignment.center,
        spacing: 8,
        runSpacing: 8,
        children: [
          for (var i = 0; i < values.length; i++)
            button(
              child: values[i].build(context, size * 0.8),
              active: controller.tool == i,
              onTap: () => onTool(i),
              tooltip: valueName(l, values[i].label),
            ),
          button(
            child: Icon(Icons.backspace_outlined, size: size * 0.45),
            active: controller.tool == GameController.eraser,
            onTap: () => onTool(GameController.eraser),
            tooltip: l.erase,
          ),
          if (supportsPencil)
            button(
              child: Icon(Icons.edit_outlined, size: size * 0.45),
              active: controller.pencil,
              onTap: controller.togglePencil,
              tooltip: l.pencilMarks,
            ),
        ],
      );
    });
  }
}
