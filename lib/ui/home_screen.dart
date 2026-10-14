import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/daily.dart';
import '../core/day.dart';
import '../core/persistence.dart';
import '../core/puzzle_type.dart';
import '../core/registry.dart';
import '../core/search.dart';
import '../l10n/l10n.dart';
import 'app_router.dart';
import 'browse_screens.dart';
import 'daily_screen.dart';
import 'install_app.dart';
import 'new_game_sheet.dart';
import 'puzzle_code_ui.dart';
import 'version_pill.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, this.query = ''});

  /// The search text, kept in the address (`/?q=…`).
  final String query;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final _search = TextEditingController(text: widget.query);

  @override
  void didUpdateWidget(HomeScreen old) {
    super.didUpdateWidget(old);
    if (widget.query != _search.text) _search.text = widget.query;
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final searching = searchWords(widget.query).isNotEmpty;
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(child: Text('APuzzle by CHDS', maxLines: 1, overflow: TextOverflow.ellipsis)),
            SizedBox(width: 8),
            VersionPill(),
          ],
        ),
        actions: [
          const InstallAppButton(),
          IconButton(
            icon: const Icon(Icons.pin_outlined),
            tooltip: l.playCode,
            onPressed: () => showEnterCodeDialog(context),
          ),
          IconButton(
            icon: const Icon(Icons.school_outlined),
            tooltip: l.learnTitle,
            onPressed: () => AppRouterDelegate.of(context).openLearn(),
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            tooltip: l.settings,
            onPressed: () => AppRouterDelegate.of(context).openSettings(),
          ),
        ],
      ),
      body: GamesListener(
        builder: (context) => CustomScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
              sliver: SliverToBoxAdapter(
                child: SearchBar(
                  controller: _search,
                  hintText: l.searchHint,
                  elevation: const WidgetStatePropertyAll(0),
                  leading: const Padding(padding: EdgeInsets.only(left: 4), child: Icon(Icons.search_rounded)),
                  trailing: [
                    if (widget.query.isNotEmpty)
                      IconButton(
                        icon: const Icon(Icons.close_rounded),
                        tooltip: MaterialLocalizations.of(context).deleteButtonTooltip,
                        onPressed: () {
                          _search.clear();
                          AppRouterDelegate.of(context).search('');
                        },
                      ),
                  ],
                  onChanged: AppRouterDelegate.of(context).search,
                ),
              ),
            ),
            if (searching)
              ..._results(context)
            else ...[
              const SliverToBoxAdapter(child: _YourGames()),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
                sliver: SliverToBoxAdapter(
                  child: ValueListenableBuilder(
                    valueListenable: context.read<GameStore>().dailyRevision,
                    builder: (context, _, _) => const _DailyBanner(),
                  ),
                ),
              ),
              _categories(context),
            ],
          ],
        ),
      ),
    );
  }

  List<Widget> _results(BuildContext context) {
    final theme = Theme.of(context);
    final l = context.l10n;
    final r = searchGames(widget.query);
    Widget row(PuzzleType t) => GameRow(type: t, label: categoryOf(t).name(l));
    Widget note(String text) => Padding(
      padding: const EdgeInsets.fromLTRB(4, 12, 4, 8),
      child: Text(text, style: theme.textTheme.titleSmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
    );
    final nothing = r.found.isEmpty && r.alternatives.isEmpty && r.similar.isEmpty;
    return [
      SliverPadding(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
        sliver: SliverList.list(
          children: [
            if (r.similar.isNotEmpty) ...[
              note(l.searchSimilar(widget.query.trim())),
              for (final t in r.similar) row(t),
            ] else if (r.found.isEmpty && r.alternatives.isEmpty)
              note(l.searchNone),
            for (final t in r.found) row(t),
            if (r.alternatives.isNotEmpty) ...[
              note(l.searchAlternatives(widget.query.trim())),
              for (final t in r.alternatives) row(t),
            ],
          ],
        ),
      ),
      if (nothing) _categories(context),
    ];
  }

  Widget _categories(BuildContext context) => SliverPadding(
    padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
    sliver: SliverGrid(
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 220,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        mainAxisExtent: 156,
      ),
      delegate: SliverChildListDelegate([for (final c in puzzleCategories) _CategoryTile(category: c)]),
    ),
  );
}

/// Pinned games, then the ones played last; hidden while there are none.
class _YourGames extends StatelessWidget {
  const _YourGames();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l = context.l10n;
    final store = context.read<GameStore>();
    final ids = {...store.pinnedGames.reversed, ...store.recentGames};
    final games = [
      for (final id in ids) ?puzzleTypes.where((t) => t.id == id).firstOrNull,
    ];
    if (games.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 6),
          child: Text(l.yourGames, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
        ),
        SizedBox(
          height: 100,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: games.length,
            separatorBuilder: (_, _) => const SizedBox(width: 8),
            itemBuilder: (context, i) => _YourGame(type: games[i]),
          ),
        ),
      ],
    );
  }
}

class _YourGame extends StatelessWidget {
  const _YourGame({required this.type});

  final PuzzleType type;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l = context.l10n;
    final store = context.read<GameStore>();
    return SizedBox(
      width: 92,
      child: Card(
        margin: EdgeInsets.zero,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () => showNewGameSheet(context, type),
          onLongPress: () => togglePinned(context, type),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(6, 10, 6, 8),
                child: Column(
                  children: [
                    GameIcon(icon: type.icon, accent: type.accent, size: 24),
                    const Spacer(),
                    Text(
                      type.name(l),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.labelMedium,
                    ),
                  ],
                ),
              ),
              if (store.isPinned(type.id))
                Positioned(
                  top: 4,
                  right: 4,
                  child: Icon(Icons.push_pin_rounded, size: 14, color: theme.colorScheme.onSurfaceVariant),
                ),
              if (store.hasSave(type.id))
                Positioned(
                  top: 6,
                  left: 6,
                  child: Tooltip(
                    message: l.inProgress,
                    child: CircleAvatar(radius: 4, backgroundColor: theme.colorScheme.primary),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// A big tile that opens a category: its name, game count and icons.
class _CategoryTile extends StatelessWidget {
  const _CategoryTile({required this.category});

  final PuzzleCategory category;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l = context.l10n;
    final types = category.types;
    return Card(
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => AppRouterDelegate.of(context).openCategory(category),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  GameIcon(icon: category.icon, accent: category.accent, size: 26),
                  const Spacer(),
                  Icon(Icons.chevron_right_rounded, color: theme.colorScheme.onSurfaceVariant),
                ],
              ),
              const Spacer(),
              Text(
                category.name(l),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
              Text(
                l.gamesCount(types.length),
                style: theme.textTheme.labelMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
              ),
              const SizedBox(height: 8),
              ClipRect(
                child: SizedBox(
                  height: 20,
                  child: Wrap(
                    spacing: 6,
                    clipBehavior: Clip.hardEdge,
                    children: [for (final t in types) Icon(t.icon, size: 18, color: t.accent)],
                  ),
                ),
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
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      color: theme.colorScheme.primaryContainer,
      child: InkWell(
        onTap: () => AppRouterDelegate.of(context).openDaily(),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              SizedBox.square(
                dimension: 44,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CircularProgressIndicator(
                      value: p.total == 0 ? 0 : p.done / p.total,
                      strokeWidth: 4,
                      backgroundColor: theme.colorScheme.onPrimaryContainer.withValues(alpha: 0.15),
                    ),
                    Icon(
                      complete ? Icons.emoji_events_rounded : Icons.calendar_month_rounded,
                      color: theme.colorScheme.onPrimaryContainer,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l.dailyTitle,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: theme.colorScheme.onPrimaryContainer,
                      ),
                    ),
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
                  ],
                ),
              ),
              Icon(Icons.chevron_right_rounded, color: theme.colorScheme.onPrimaryContainer),
            ],
          ),
        ),
      ),
    );
  }
}
