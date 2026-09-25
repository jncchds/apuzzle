import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/persistence.dart';
import '../core/puzzle_type.dart';
import '../core/registry.dart';
import '../l10n/l10n.dart';
import 'app_router.dart';
import 'new_game_sheet.dart';
import 'puzzle_code_ui.dart';

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
        title: const Text('APuzzle'),
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
      body: GridView.extent(
        padding: const EdgeInsets.all(16),
        maxCrossAxisExtent: 240,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.95,
        children: [
          for (final t in puzzleTypes) _TypeCard(type: t, inProgress: store.hasSave(t.id), onTap: () => _open(t)),
        ],
      ),
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
