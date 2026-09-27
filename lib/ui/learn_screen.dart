import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/persistence.dart';
import '../core/puzzle_type.dart';
import '../core/registry.dart';
import '../l10n/l10n.dart';
import 'app_router.dart';
import 'new_game_sheet.dart' show quickParams;

/// Every game's lessons in two tabs, the basics and the strategies, with the
/// ones played to the end ticked.
class LearnScreen extends StatelessWidget {
  const LearnScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(l.learnTitle),
          bottom: TabBar(
            tabs: [
              Tab(text: l.learnBasicsTab),
              Tab(text: l.learnStrategiesTab),
            ],
          ),
        ),
        body: const TabBarView(children: [_LessonList(strategies: false), _LessonList(strategies: true)]),
      ),
    );
  }
}

class _LessonList extends StatelessWidget {
  const _LessonList({required this.strategies});

  final bool strategies;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final store = context.read<GameStore>();
    final router = AppRouterDelegate.of(context);
    final screen = MediaQuery.sizeOf(context);
    List<Object> steps(PuzzleType t) => strategies ? t.strategies() : t.tutorial();
    final types = [
      for (final t in puzzleTypes)
        if (steps(t).isNotEmpty) t,
    ];
    return ValueListenableBuilder(
      valueListenable: store.tutorialRevision,
      builder: (context, _, _) => ListView(
        padding: const EdgeInsets.symmetric(vertical: 8),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
            child: Text(strategies ? l.learnStrategiesIntro : l.learnIntro, style: theme.textTheme.bodyMedium),
          ),
          for (final t in types)
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: t.accent.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(t.icon, color: t.accent),
              ),
              title: Text(t.name(l)),
              subtitle: Text(l.learnSteps(steps(t).length)),
              trailing: (strategies ? store.strategiesDone(t.id) : store.tutorialDone(t.id))
                  ? Tooltip(
                      message: l.learnDone,
                      child: Icon(Icons.check_circle_rounded, color: theme.colorScheme.primary),
                    )
                  : const Icon(Icons.chevron_right_rounded),
              onTap: () => router.openTutorial(
                t,
                strategies: strategies,
                play: () => router.openGame(t, quickParams(t, store, screen)),
              ),
            ),
        ],
      ),
    );
  }
}
