import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/daily.dart';
import '../core/day.dart';
import '../core/persistence.dart';
import '../core/puzzle_type.dart';
import '../core/registry.dart';
import '../l10n/l10n.dart';
import 'app_router.dart';
import 'daily_screen.dart';
import 'new_game_sheet.dart';
import 'puzzle_code_ui.dart';
import 'version_pill.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<void> _open(PuzzleType type) async {
    await showNewGameSheet(context, type);
    if (mounted) setState(() {}); // refresh "in progress" badges
  }

  @override
  Widget build(BuildContext context) {
    final store = context.read<GameStore>();
    final l = context.l10n;
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [Text('APuzzle by CHDS'), SizedBox(width: 8), VersionPill()],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.pin_outlined),
            tooltip: l.playCode,
            onPressed: () async {
              await showEnterCodeDialog(context);
              if (mounted) setState(() {});
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            tooltip: l.settings,
            onPressed: () => AppRouterDelegate.of(context).openSettings(),
          ),
        ],
      ),
      body: CustomScrollView(slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
          sliver: SliverToBoxAdapter(
            child: ValueListenableBuilder(
              valueListenable: store.dailyRevision,
              builder: (context, _, _) => const _DailyBanner(),
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.all(16),
          sliver: SliverGrid.extent(
            maxCrossAxisExtent: 240,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 0.95,
            children: [
              for (final t in puzzleTypes) _TypeCard(type: t, inProgress: store.hasSave(t.id), onTap: () => _open(t)),
            ],
          ),
        ),
      ]),
    );
  }
}

class _TypeCard extends StatelessWidget {
  const _TypeCard({required this.type, required this.inProgress, required this.onTap});

  final PuzzleType type;
  final bool inProgress;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l = context.l10n;
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: type.accent.withValues(alpha: 0.18),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(type.icon, color: type.accent, size: 30),
                  ),
                  const Spacer(),
                  if (inProgress)
                    Chip(
                      label: Text(l.inProgress),
                      visualDensity: VisualDensity.compact,
                      labelStyle: theme.textTheme.labelSmall,
                    ),
                ],
              ),
              const Spacer(),
              Text(type.name(l),
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis),
              const SizedBox(height: 4),
              Flexible(
                child: Text(type.tagline(l), style: theme.textTheme.bodySmall, maxLines: 2, overflow: TextOverflow.ellipsis),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Today's daily challenge: its games and progress; opens the calendar.
class _DailyBanner extends StatelessWidget {
  const _DailyBanner();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l = context.l10n;
    final today = Day.today();
    final p = dailyProgress(context.read<GameStore>(), today);
    final complete = p.done == p.total;
    return Card(
      clipBehavior: Clip.antiAlias,
      color: theme.colorScheme.primaryContainer,
      child: InkWell(
        onTap: () => AppRouterDelegate.of(context).openDaily(),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(children: [
            SizedBox.square(
              dimension: 44,
              child: Stack(alignment: Alignment.center, children: [
                CircularProgressIndicator(
                  value: p.total == 0 ? 0 : p.done / p.total,
                  strokeWidth: 4,
                  backgroundColor: theme.colorScheme.onPrimaryContainer.withValues(alpha: 0.15),
                ),
                Icon(complete ? Icons.emoji_events_rounded : Icons.calendar_month_rounded,
                    color: theme.colorScheme.onPrimaryContainer),
              ]),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(l.dailyTitle,
                    style: theme.textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.w700, color: theme.colorScheme.onPrimaryContainer)),
                const SizedBox(height: 2),
                Text(
                  [for (final t in dailyGames(today)) t.name(l)].join(' · '),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onPrimaryContainer),
                ),
                Text(
                  complete ? l.dailyDayComplete : l.dailyProgress(p.done, p.total),
                  style: theme.textTheme.labelMedium?.copyWith(color: theme.colorScheme.onPrimaryContainer),
                ),
              ]),
            ),
            Icon(Icons.chevron_right_rounded, color: theme.colorScheme.onPrimaryContainer),
          ]),
        ),
      ),
    );
  }
}
