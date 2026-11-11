import 'package:flutter/material.dart';

import '../core/explain.dart';
import '../core/game_controller.dart';
import '../l10n/l10n.dart';

/// Explain mode under the board: the next step, its reasons, and buttons to
/// do it or to go back to playing.
class ExplainPanel extends StatefulWidget {
  const ExplainPanel({
    super.key,
    required this.controller,
    this.tutor = false,
    this.teaches = const {},
    this.capHeight = true,
  });

  final GameController controller;

  /// A tutorial's "Show me": reasons open from the start, and doing the
  /// step closes the panel.
  final bool tutor;

  /// The rules a strategy lesson teaches: a step that uses one says so, and
  /// its lines stand out.
  final Set<int> teaches;

  /// Caps the height at a share of the screen (else the parent bounds it).
  final bool capHeight;

  @override
  State<ExplainPanel> createState() => _ExplainPanelState();
}

class _ExplainPanelState extends State<ExplainPanel> {
  late bool _why = widget.tutor;

  /// The first line of the lesson's trick, scrolled into view once per step.
  final _taughtKey = GlobalKey();
  Explanation? _scrolledFor;

  @override
  Widget build(BuildContext context) {
    final c = widget.controller;
    final e = c.explanation;
    final l = context.l10n;
    final theme = Theme.of(context);
    final details = e != null && e.hasDetails;
    final taught = e != null && e.uses(widget.teaches);
    bool strong(ExplainLine line) => taught && e.teaches(line, widget.teaches);
    // One sentence can back several ruled-out cells: tell it once.
    final seen = <String>{};
    final why = [
      for (final line in e?.why ?? const <ExplainLine>[])
        if (seen.add(line.text(l))) line,
    ];
    final suppose = e?.suppose;
    final firstTaught = !taught || !_why
        ? null
        : why.where(strong).firstOrNull ?? (suppose != null && strong(suppose) ? suppose : null);
    if (firstTaught != null && !identical(_scrolledFor, e)) {
      _scrolledFor = e;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final target = _taughtKey.currentContext;
        if (target != null && target.mounted) {
          Scrollable.ensureVisible(target, alignment: 0.5, duration: const Duration(milliseconds: 250));
        }
      });
    }
    return Container(
      constraints: widget.capHeight
          ? BoxConstraints(
              maxHeight:
                  MediaQuery.sizeOf(context).height *
                  (MediaQuery.orientationOf(context) == Orientation.landscape ? 0.5 : 0.36),
            )
          : const BoxConstraints(),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.fromLTRB(14, 10, 6, 4),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(right: 8),
              child: AnimatedSize(
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeOutCubic,
                alignment: Alignment.topCenter,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (taught) _LessonBadge(text: l.tutorialLessonTrick),
                    if (e == null)
                      Text(l.explainNone, style: theme.textTheme.bodyMedium)
                    else
                      ExplainText(
                        controller: c,
                        line: e.headline,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: strong(e.headline) ? FontWeight.w600 : null,
                        ),
                      ),
                    if (details && _why) ...[
                      const SizedBox(height: 6),
                      for (final line in why)
                        _Reason(
                          key: identical(line, firstTaught) ? _taughtKey : null,
                          controller: c,
                          line: line,
                          strong: strong(line),
                        ),
                      if (suppose != null)
                        _Reason(
                          key: identical(suppose, firstTaught) ? _taughtKey : null,
                          controller: c,
                          line: suppose,
                          strong: true,
                        ),
                      for (final (i, line) in e.probe.indexed)
                        _Reason(controller: c, line: line, indent: true, last: i == e.probe.length - 1),
                    ],
                  ],
                ),
              ),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: details
                    ? Align(
                        alignment: AlignmentDirectional.centerStart,
                        child: TextButton.icon(
                          onPressed: () => setState(() => _why = !_why),
                          icon: Icon(_why ? Icons.expand_less_rounded : Icons.expand_more_rounded),
                          label: Text(l.explainWhy, maxLines: 1, overflow: TextOverflow.ellipsis),
                        ),
                      )
                    : const SizedBox.shrink(),
              ),
              // The tutorial's panel is narrower: Close as an icon.
              if (widget.tutor)
                IconButton(onPressed: c.closeExplain, tooltip: l.explainClose, icon: const Icon(Icons.close_rounded))
              else
                TextButton(onPressed: c.closeExplain, child: Text(l.explainClose)),
              const SizedBox(width: 4),
              FilledButton.icon(
                onPressed: e?.next == null ? null : () => c.applyExplanation(close: widget.tutor),
                icon: const Icon(Icons.check_rounded),
                label: Text(l.explainApply),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Says that the step uses the trick a strategy lesson teaches.
class _LessonBadge extends StatelessWidget {
  const _LessonBadge({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = theme.colorScheme.primary;
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 6),
        padding: const EdgeInsets.fromLTRB(6, 3, 10, 3),
        decoration: BoxDecoration(color: color.withValues(alpha: 0.14), borderRadius: BorderRadius.circular(12)),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.psychology_alt_rounded, size: 16, color: color),
            const SizedBox(width: 4),
            Flexible(
              child: Text(text, style: theme.textTheme.labelMedium?.copyWith(color: color)),
            ),
          ],
        ),
      ),
    );
  }
}

/// One supporting line: tap it to see its cells on the board.
class _Reason extends StatelessWidget {
  const _Reason({
    super.key,
    required this.controller,
    required this.line,
    this.indent = false,
    this.strong = false,
    this.last = false,
  });

  final GameController controller;
  final ExplainLine line;
  final bool indent;
  final bool strong;

  /// The contradiction that ends a probe.
  final bool last;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final focused = line.cells.isNotEmpty && identical(controller.explainFocus, line.cells);
    final style = theme.textTheme.bodySmall?.copyWith(
      fontWeight: strong || last ? FontWeight.w600 : null,
      color: last ? theme.colorScheme.error : null,
    );
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: line.cells.isEmpty ? null : () => controller.focusExplain(line.cells),
      child: Container(
        padding: EdgeInsets.fromLTRB(indent ? 16 : 4, 3, 4, 3),
        decoration: BoxDecoration(
          color: focused ? theme.colorScheme.tertiary.withValues(alpha: 0.14) : null,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 6),
              child: Text(last ? '✗' : (indent ? '→' : '•'), style: style),
            ),
            Expanded(
              child: ExplainText(controller: controller, line: line, style: style),
            ),
          ],
        ),
      ),
    );
  }
}

/// An explanation text with its tokens drawn as chips: cells, rows and
/// columns as labels (tap to see them on the board), values as the board's
/// own symbols.
class ExplainText extends StatelessWidget {
  const ExplainText({super.key, required this.controller, required this.line, this.style});

  final GameController controller;
  final ExplainLine line;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final base = style ?? DefaultTextStyle.of(context).style;
    final fontSize = base.fontSize ?? 14;
    final size = controller.explanation?.size;
    final spans = <InlineSpan>[];
    final parts = parseExplainText(line.text(context.l10n));
    // Punctuation right after a chip stays on its line.
    final glued = RegExp(r'^[.,:;!?)»“”]+');
    String? tail(int k) => k + 1 < parts.length && parts[k + 1] is ExplainWords
        ? glued.stringMatch((parts[k + 1] as ExplainWords).text)
        : null;
    Widget withTail(Widget chip, String? t) => t == null
        ? chip
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              chip,
              Text(t, style: base),
            ],
          );
    var skip = 0;
    for (final (k, part) in parts.indexed) {
      switch (part) {
        case ExplainWords(:final text):
          spans.add(TextSpan(text: text.substring(skip)));
          skip = 0;
        case ExplainChip(kind: 'v', :final args):
          final t = tail(k);
          skip = t?.length ?? 0;
          spans.add(
            WidgetSpan(
              alignment: PlaceholderAlignment.middle,
              child: withTail(
                SizedBox(
                  width: fontSize * 1.5,
                  height: fontSize * 1.5,
                  child: Center(
                    child: controller.type.buildValueChip(context, controller.puzzle, args[0], fontSize * 1.5),
                  ),
                ),
                t,
              ),
            ),
          );
        case final ExplainChip chip:
          final cells = size == null ? const <Never>{} : chip.cells(size);
          final t = tail(k);
          skip = t?.length ?? 0;
          spans.add(
            WidgetSpan(
              alignment: PlaceholderAlignment.middle,
              child: withTail(
                GestureDetector(
                  onTap: cells.isEmpty ? null : () => controller.focusExplain(cells),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 1),
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.tertiary.withValues(alpha: 0.16),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          chip.label,
                          style: base.copyWith(fontWeight: FontWeight.w700, color: theme.colorScheme.tertiary),
                        ),
                        if (chip.side case final side?)
                          Icon(
                            const [
                              Icons.north_rounded,
                              Icons.south_rounded,
                              Icons.west_rounded,
                              Icons.east_rounded,
                            ][side],
                            size: fontSize,
                            color: theme.colorScheme.tertiary,
                          ),
                        if (chip.corner case final corner?)
                          Icon(
                            const [
                              Icons.north_west_rounded,
                              Icons.north_east_rounded,
                              Icons.south_west_rounded,
                              Icons.south_east_rounded,
                            ][corner],
                            size: fontSize,
                            color: theme.colorScheme.tertiary,
                          ),
                      ],
                    ),
                  ),
                ),
                t,
              ),
            ),
          );
      }
    }
    return Text.rich(TextSpan(style: base, children: spans));
  }
}
