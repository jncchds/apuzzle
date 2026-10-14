import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/persistence.dart';
import '../core/puzzle_type.dart';
import '../core/registry.dart';
import '../l10n/l10n.dart';
import 'app_router.dart';
import 'new_game_sheet.dart';

/// Pins [type] to the home screen's "your games", or unpins it.
Future<void> togglePinned(BuildContext context, PuzzleType type) async {
  final store = context.read<GameStore>();
  final messenger = ScaffoldMessenger.of(context);
  final l = context.l10n;
  final pin = !store.isPinned(type.id);
  await store.setPinned(type.id, pin);
  messenger
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(pin ? l.pinnedToast(type.name(l)) : l.unpinnedToast(type.name(l)))));
}

/// Rebuilds when games are played, pinned or saved.
class GamesListener extends StatelessWidget {
  const GamesListener({super.key, required this.builder});

  final WidgetBuilder builder;

  @override
  Widget build(BuildContext context) => ValueListenableBuilder(
    valueListenable: context.read<GameStore>().gamesRevision,
    builder: (context, _, _) => builder(context),
  );
}

/// The game's icon on a tinted rounded square.
class GameIcon extends StatelessWidget {
  const GameIcon({super.key, required this.icon, required this.accent, this.size = 30});

  final IconData icon;
  final Color accent;
  final double size;

  @override
  Widget build(BuildContext context) => Container(
    padding: EdgeInsets.all(size / 3),
    decoration: BoxDecoration(color: accent.withValues(alpha: 0.18), borderRadius: BorderRadius.circular(size / 2)),
    child: Icon(icon, color: accent, size: size),
  );
}

/// Size of the card grids: smaller cards on a turned phone, so more than
/// one row shows.
SliverGridDelegate cardGrid(BuildContext context) => SliverGridDelegateWithMaxCrossAxisExtent(
  maxCrossAxisExtent: MediaQuery.sizeOf(context).height < 480 ? 200 : 240,
  mainAxisSpacing: 12,
  crossAxisSpacing: 12,
  childAspectRatio: 0.95,
);

/// A card that opens a game's new-game sheet; a long press pins it.
class GameCard extends StatelessWidget {
  const GameCard({super.key, required this.type});

  final PuzzleType type;

  @override
  Widget build(BuildContext context) {
    final store = context.read<GameStore>();
    return _Card(
      icons: [GameIcon(icon: type.icon, accent: type.accent)],
      name: type.name(context.l10n),
      text: type.tagline(context.l10n),
      inProgress: store.hasSave(type.id),
      pinned: store.isPinned(type.id),
      onTap: () => showNewGameSheet(context, type),
      onLongPress: () => togglePinned(context, type),
    );
  }
}

/// A card for a family: its games' icons, name and count.
class FamilyCard extends StatelessWidget {
  const FamilyCard({super.key, required this.family});

  final PuzzleFamily family;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    if (family.single) return GameCard(type: family.types.single);
    final store = context.read<GameStore>();
    return _Card(
      icons: [for (final t in family.types) GameIcon(icon: t.icon, accent: t.accent, size: 22)],
      name: family.name(l),
      text: l.gamesCount(family.types.length),
      inProgress: family.types.any((t) => store.hasSave(t.id)),
      pinned: false,
      onTap: () => AppRouterDelegate.of(context).openFamily(family),
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({
    required this.icons,
    required this.name,
    required this.text,
    required this.inProgress,
    required this.pinned,
    required this.onTap,
    this.onLongPress,
  });

  final List<Widget> icons;
  final String name;
  final String text;
  final bool inProgress;
  final bool pinned;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l = context.l10n;
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Wrap(spacing: 6, runSpacing: 6, children: icons),
                  ),
                  if (pinned) Icon(Icons.push_pin_rounded, size: 18, color: theme.colorScheme.onSurfaceVariant),
                ],
              ),
              const Spacer(),
              if (inProgress)
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text(
                    l.inProgress,
                    style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.primary),
                  ),
                ),
              Text(
                name,
                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(text, style: theme.textTheme.bodySmall, maxLines: 2, overflow: TextOverflow.ellipsis),
            ],
          ),
        ),
      ),
    );
  }
}

/// One game as a list row: icon, name, tagline and, with [label], a small
/// label under them (its category).
class GameRow extends StatelessWidget {
  const GameRow({super.key, required this.type, this.label});

  final PuzzleType type;
  final String? label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l = context.l10n;
    final store = context.read<GameStore>();
    final inProgress = store.hasSave(type.id);
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => showNewGameSheet(context, type),
        onLongPress: () => togglePinned(context, type),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              GameIcon(icon: type.icon, accent: type.accent, size: 26),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      type.name(l),
                      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      type.tagline(l),
                      style: theme.textTheme.bodySmall,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (label case final label?)
                      Text(
                        label,
                        style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                      ),
                    if (inProgress)
                      Text(l.inProgress, style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.primary)),
                  ],
                ),
              ),
              if (store.isPinned(type.id)) ...[
                const SizedBox(width: 8),
                Icon(Icons.push_pin_rounded, size: 18, color: theme.colorScheme.onSurfaceVariant),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// A category's families and games (`/c/<id>`).
class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key, required this.category});

  final PuzzleCategory category;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(category.name(l))),
      body: GamesListener(
        builder: (context) => GridView(
          padding: const EdgeInsets.all(16),
          gridDelegate: cardGrid(context),
          children: [for (final f in category.families) FamilyCard(family: f)],
        ),
      ),
    );
  }
}

/// A family's games, with what they share (`/f/<id>`).
class FamilyScreen extends StatelessWidget {
  const FamilyScreen({super.key, required this.family});

  final PuzzleFamily family;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(family.name(l))),
      body: GamesListener(
        builder: (context) => ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(4, 0, 4, 12),
              child: Text(family.about(l), style: theme.textTheme.bodyLarge),
            ),
            for (final t in family.types) GameRow(type: t),
          ],
        ),
      ),
    );
  }
}
