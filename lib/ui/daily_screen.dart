import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/daily.dart';
import '../core/day.dart';
import '../core/persistence.dart';
import '../core/puzzle_code.dart';
import '../core/puzzle_type.dart';
import '../l10n/l10n.dart';
import 'app_router.dart';
import 'new_game_sheet.dart' show formatDuration;
import 'tutorial_screen.dart';

/// Solved and total puzzles of [day].
({int done, int total}) dailyProgress(GameStore store, Day day) {
  final results = store.dailyResults(day);
  final puzzles = dailyPuzzles(day);
  final done = puzzles.where((p) => results.containsKey(GameStore.dailyEntry(p.type.id, p.difficulty))).length;
  return (done: done, total: puzzles.length);
}

/// A month calendar of daily challenges and the selected day's puzzles.
class DailyScreen extends StatefulWidget {
  const DailyScreen({super.key, required this.day});

  final Day day;

  @override
  State<DailyScreen> createState() => _DailyScreenState();
}

class _DailyScreenState extends State<DailyScreen> {
  /// First day of the month on show.
  late Day _month = widget.day.addMonths(0);

  @override
  void didUpdateWidget(DailyScreen old) {
    super.didUpdateWidget(old);
    if (old.day != widget.day) _month = widget.day.addMonths(0);
  }

  @override
  Widget build(BuildContext context) {
    final store = context.read<GameStore>();
    final l = context.l10n;
    final today = Day.today();
    final router = AppRouterDelegate.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(l.dailyTitle),
        actions: [
          if (widget.day != today)
            TextButton(onPressed: () => router.selectDailyDay(today), child: Text(l.dailyToday)),
        ],
      ),
      body: ValueListenableBuilder(
        valueListenable: store.dailyRevision,
        builder: (context, _, _) => Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              children: [
                _MonthCalendar(
                  month: _month,
                  selected: widget.day,
                  today: today,
                  onMonth: (m) => setState(() => _month = m),
                  onDay: router.selectDailyDay,
                ),
                const SizedBox(height: 16),
                _DayHeader(day: widget.day),
                const SizedBox(height: 8),
                for (final type in dailyGames(widget.day)) _GameRow(day: widget.day, type: type),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MonthCalendar extends StatelessWidget {
  const _MonthCalendar({
    required this.month,
    required this.selected,
    required this.today,
    required this.onMonth,
    required this.onDay,
  });

  final Day month;
  final Day selected;
  final Day today;
  final ValueChanged<Day> onMonth;
  final ValueChanged<Day> onDay;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ml = MaterialLocalizations.of(context);
    final store = context.read<GameStore>();
    final firstWeekday = ml.firstDayOfWeekIndex; // 0 = Sunday
    final lead = (month.date.weekday % 7 - firstWeekday) % 7;
    final canBack = dailyLaunch.addMonths(0) < month;
    final canForward = month < today.addMonths(0);
    return Column(children: [
      Row(children: [
        IconButton(
          icon: const Icon(Icons.chevron_left_rounded),
          tooltip: ml.previousMonthTooltip,
          onPressed: canBack ? () => onMonth(month.addMonths(-1)) : null,
        ),
        Expanded(
          child: Text(
            ml.formatMonthYear(month.date),
            textAlign: TextAlign.center,
            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.chevron_right_rounded),
          tooltip: ml.nextMonthTooltip,
          onPressed: canForward ? () => onMonth(month.addMonths(1)) : null,
        ),
      ]),
      const SizedBox(height: 4),
      Row(children: [
        for (var i = 0; i < 7; i++)
          Expanded(
            child: Text(
              ml.narrowWeekdays[(firstWeekday + i) % 7],
              textAlign: TextAlign.center,
              style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
            ),
          ),
      ]),
      const SizedBox(height: 4),
      GridView.count(
        crossAxisCount: 7,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          for (var i = 0; i < lead; i++) const SizedBox.shrink(),
          for (var d = 1; d <= month.daysInMonth; d++)
            _dayCell(context, store, Day(month.year, month.month, d)),
        ],
      ),
    ]);
  }

  Widget _dayCell(BuildContext context, GameStore store, Day day) {
    final playable = dailyLaunch <= day && day <= today;
    final progress = playable ? dailyProgress(store, day) : null;
    return _DayCell(
      day: day.day,
      fraction: progress == null || progress.total == 0 ? 0 : progress.done / progress.total,
      enabled: playable,
      selected: day == selected,
      today: day == today,
      onTap: playable ? () => onDay(day) : null,
    );
  }
}

class _DayCell extends StatelessWidget {
  const _DayCell({
    required this.day,
    required this.fraction,
    required this.enabled,
    required this.selected,
    required this.today,
    required this.onTap,
  });

  final int day;

  /// Share of the day's puzzles solved.
  final double fraction;
  final bool enabled;
  final bool selected;
  final bool today;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final complete = fraction >= 1;
    final color = !enabled
        ? scheme.onSurface.withValues(alpha: 0.3)
        : complete
            ? scheme.onPrimary
            : today
                ? scheme.primary
                : scheme.onSurface;
    return Padding(
      padding: const EdgeInsets.all(2),
      child: Material(
        color: selected ? scheme.secondaryContainer : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(4),
            child: CustomPaint(
              painter: enabled ? _RingPainter(fraction, scheme) : null,
              child: Center(
                child: Text(
                  '$day',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: color,
                    fontWeight: today || complete ? FontWeight.w800 : FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// A progress ring around a day; a full day is a filled disc.
class _RingPainter extends CustomPainter {
  _RingPainter(this.fraction, this.scheme);

  final double fraction;
  final ColorScheme scheme;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = min(size.width, size.height) / 2 - 2;
    if (fraction >= 1) {
      canvas.drawCircle(center, radius + 1, Paint()..color = scheme.primary);
      return;
    }
    final stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;
    canvas.drawCircle(center, radius, stroke..color = scheme.outlineVariant.withValues(alpha: 0.5));
    if (fraction > 0) {
      canvas.drawArc(Rect.fromCircle(center: center, radius: radius), -pi / 2, 2 * pi * fraction, false,
          stroke..color = scheme.primary);
    }
  }

  @override
  bool shouldRepaint(_RingPainter old) => old.fraction != fraction || old.scheme != scheme;
}

class _DayHeader extends StatelessWidget {
  const _DayHeader({required this.day});

  final Day day;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l = context.l10n;
    final p = dailyProgress(context.read<GameStore>(), day);
    return Row(children: [
      Expanded(
        child: Text(
          MaterialLocalizations.of(context).formatFullDate(day.date),
          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
        ),
      ),
      Text(
        p.done == p.total ? l.dailyDayComplete : l.dailyProgress(p.done, p.total),
        style: theme.textTheme.labelLarge?.copyWith(color: p.done == p.total ? theme.colorScheme.primary : null),
      ),
    ]);
  }
}

/// One game of the day, with a chip per difficulty.
class _GameRow extends StatelessWidget {
  const _GameRow({required this.day, required this.type});

  final Day day;
  final PuzzleType type;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l = context.l10n;
    final store = context.read<GameStore>();
    final results = store.dailyResults(day);
    final router = AppRouterDelegate.of(context);
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: type.accent.withValues(alpha: 0.18),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(type.icon, color: type.accent, size: 24),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(type.name(l), style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                Text(type.tagline(l), style: theme.textTheme.bodySmall, maxLines: 1, overflow: TextOverflow.ellipsis),
              ]),
            ),
          ]),
          const SizedBox(height: 10),
          Wrap(spacing: 8, runSpacing: 8, children: [
            for (final d in type.difficulties)
              _DifficultyChip(
                label: d.label(l),
                result: results[GameStore.dailyEntry(type.id, d)],
                inProgress: store.hasSave(GameStore.dailySlot(PuzzleCode.format(type, dailyParams(day, type, d)))),
                onTap: () => offerTutorial(context, type, play: () => router.openDailyGame(day, type, d)),
              ),
          ]),
        ]),
      ),
    );
  }
}

class _DifficultyChip extends StatelessWidget {
  const _DifficultyChip({required this.label, required this.result, required this.inProgress, required this.onTap});

  final String label;
  final DailyResult? result;
  final bool inProgress;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final r = result;
    final avatar = r != null
        ? const Icon(Icons.check_circle_rounded)
        : inProgress
            ? Tooltip(message: l.inProgress, child: const Icon(Icons.timelapse_rounded))
            : const Icon(Icons.play_arrow_rounded);
    return ActionChip(
      avatar: avatar,
      label: Text(r == null ? label : '$label · ${formatDuration(r.best)}'),
      backgroundColor: r != null ? Theme.of(context).colorScheme.primaryContainer : null,
      onPressed: onTap,
    );
  }
}
