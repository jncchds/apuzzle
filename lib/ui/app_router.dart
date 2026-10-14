import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../core/daily.dart';
import '../core/day.dart';
import '../core/difficulty.dart';
import '../core/puzzle_code.dart';
import '../core/puzzle_type.dart';
import '../core/registry.dart';
import '../l10n/l10n.dart';
import 'browse_screens.dart';
import 'daily_screen.dart';
import 'game_screen.dart';
import 'home_screen.dart';
import 'learn_screen.dart';
import 'release_notes_screen.dart';
import 'settings_screen.dart';
import 'tutorial_screen.dart';

/// What the address bar shows: home (`/`, searching `/?q=text`), a category
/// (`/c/numbers`), a family of several games (`/f/flood`, over its category),
/// settings (`/settings`), the
/// release notes (`/release-notes`, over settings), the
/// tutorials (`/learn`; one game's is `/learn?t=mambo`, its strategy
/// lessons `/learn?t=mambo&s=1`), daily
/// challenges (`/daily?d=2026-09-25`) or a puzzle by its share code
/// (`/?p=kings-8x8-hard-4FZ8K1-v1`, the share link itself; a daily one is
/// `/daily?d=…&p=…`; one opened while browsing keeps the page below it:
/// `/c/numbers?p=…`). On the web this gives the browser's back and forward
/// buttons real history; on Android the same parser opens share links.
class AppRoute {
  const AppRoute({
    this.settings = false,
    this.releaseNotes = false,
    this.learn = false,
    this.tutorial,
    this.strategies = false,
    this.daily,
    this.game,
    this.error,
    this.category,
    this.family,
    this.query = '',
  });

  /// The category page, under [family] if that is open too.
  final PuzzleCategory? category;
  final PuzzleFamily? family;

  /// The home screen's search text.
  final String query;

  final bool settings;

  /// RELEASE_NOTES.md, opened from settings.
  final bool releaseNotes;

  /// The list of tutorials.
  final bool learn;

  /// One game's tutorial, shown over whatever is open.
  final PuzzleType? tutorial;

  /// With [tutorial]: its strategy lessons instead of the basics.
  final bool strategies;

  /// The daily challenges page with this day selected. With [game], that
  /// game is one of the day's puzzles.
  final Day? daily;
  final PuzzleCode? game;

  /// A puzzle link that didn't parse.
  final Tr? error;

  static AppRoute parse(Uri uri) {
    // Android passes the link's full path (/apuzzle/?p=…), the web the path
    // below the base href (/?p=…).
    final link = uri.toString();
    PuzzleCode? game;
    if (PuzzleCode.find(link) != null) {
      try {
        game = PuzzleCode.parse(link, puzzleTypes);
      } on PuzzleCodeException catch (e) {
        return AppRoute(error: e.describe);
      }
    }
    final segments = uri.pathSegments.where((s) => s.isNotEmpty).toList();
    final page = segments.lastOrNull;
    if (page == 'learn') {
      final tutorial = puzzleTypes.where((t) => t.id == uri.queryParameters['t']).firstOrNull;
      return AppRoute(
        learn: tutorial == null,
        tutorial: tutorial,
        strategies: tutorial != null && uri.queryParameters['s'] == '1' && tutorial.strategies().isNotEmpty,
      );
    }
    if (page == 'daily') {
      final today = Day.today();
      var day = Day.tryParse(uri.queryParameters['d']) ?? today;
      if (day > today || day < dailyLaunch) day = today;
      // Only the day's own puzzles count as its challenges.
      if (game != null && !isDailyPuzzle(day, game, today: today)) return AppRoute(game: game);
      return AppRoute(daily: day, game: game);
    }
    if (page == 'release-notes') return const AppRoute(settings: true, releaseNotes: true);
    final parent = segments.length >= 2 ? segments[segments.length - 2] : null;
    if (parent == 'c' || parent == 'f') {
      final family = parent == 'f' ? familyById(page) : null;
      final category = family != null
          ? categoryOfFamily(family)
          : parent == 'c'
          ? categoryById(page)
          // A family of one has no page: show its category.
          : puzzleTypes.where((t) => t.id == page).map(categoryOf).firstOrNull;
      return AppRoute(category: category, family: family, game: game);
    }
    if (page == 'settings') return const AppRoute(settings: true);
    return AppRoute(game: game, query: uri.queryParameters['q'] ?? '');
  }

  Uri get uri => tutorial != null || learn
      ? Uri(path: '/learn', queryParameters: tutorial == null ? null : {'t': tutorial!.id, if (strategies) 's': '1'})
      : daily != null
      ? Uri(path: '/daily', queryParameters: {'d': daily.toString(), if (game != null) 'p': game.toString()})
      : releaseNotes
      ? Uri(path: '/release-notes')
      : settings
      ? Uri(path: '/settings')
      : Uri(
          path: family != null
              ? '/f/${family!.id}'
              : category != null
              ? '/c/${category!.id}'
              : '/',
          queryParameters: _orNull({
            if (query.isNotEmpty && category == null) 'q': query,
            if (game != null) 'p': game.toString(),
          }),
        );

  static Map<String, String>? _orNull(Map<String, String> m) => m.isEmpty ? null : m;
}

class AppRouteParser extends RouteInformationParser<AppRoute> {
  const AppRouteParser();

  @override
  Future<AppRoute> parseRouteInformation(RouteInformation routeInformation) =>
      SynchronousFuture(AppRoute.parse(routeInformation.uri));

  @override
  RouteInformation restoreRouteInformation(AppRoute configuration) => RouteInformation(uri: configuration.uri);
}

class _Game {
  _Game(this.code, this.id, this.daily);

  PuzzleCode code;

  /// The day whose challenge this is, or null.
  final Day? daily;

  /// Keeps the page (and its [GameScreen] state) while the in-game "new
  /// puzzle" changes [code].
  final int id;
}

/// Home, with settings or daily challenges, then one game on top. Dialogs and sheets stay pageless.
class AppRouterDelegate extends RouterDelegate<AppRoute>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<AppRoute> {
  AppRouterDelegate({this.messengerKey});

  final GlobalKey<ScaffoldMessengerState>? messengerKey;

  @override
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey();

  static AppRouterDelegate of(BuildContext context) => Router.of(context).routerDelegate as AppRouterDelegate;

  bool _settings = false;
  bool _releaseNotes = false;
  bool _learn = false;
  Day? _daily;
  _Game? _game;
  int _games = 0;
  PuzzleType? _tutorial;
  bool _strategies = false;
  PuzzleCategory? _category;
  PuzzleFamily? _family;
  String _query = '';

  /// Where the tutorial's "Play" button leads (the game it was offered for).
  VoidCallback? _tutorialPlay;

  @override
  AppRoute get currentConfiguration => AppRoute(
    settings: _settings,
    releaseNotes: _releaseNotes,
    learn: _learn,
    tutorial: _tutorial,
    strategies: _strategies,
    daily: _daily,
    game: _game?.code,
    category: _category,
    family: _family,
    query: _query,
  );

  @override
  Future<void> setNewRoutePath(AppRoute configuration) {
    if (configuration.error case final error?) {
      // The navigator may not exist yet (a bad link at startup).
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final context = navigatorKey.currentContext;
        if (context == null) return;
        final l = AppLocalizations.of(context);
        messengerKey?.currentState?.showSnackBar(SnackBar(content: Text(l.couldNotOpenLink(error(l)))));
      });
      return SynchronousFuture(null);
    }
    if (configuration.tutorial case final type?) {
      openTutorial(type, strategies: configuration.strategies);
    } else {
      _show(
        settings: configuration.settings,
        releaseNotes: configuration.releaseNotes,
        learn: configuration.learn,
        daily: configuration.daily,
        game: configuration.game,
        category: configuration.category,
        family: configuration.family,
        query: configuration.query,
      );
    }
    return SynchronousFuture(null);
  }

  /// With [daily] and [game], the game is that day's challenge.
  void _show({
    bool settings = false,
    bool releaseNotes = false,
    bool learn = false,
    Day? daily,
    PuzzleCode? game,
    PuzzleCategory? category,
    PuzzleFamily? family,
    String query = '',
  }) {
    _category = category;
    _family = family;
    _query = category == null ? query : '';
    _settings = settings || releaseNotes;
    _releaseNotes = releaseNotes;
    _learn = learn;
    _daily = daily;
    _tutorial = null;
    _tutorialPlay = null;
    final gameDaily = game == null ? null : daily;
    if (game?.toString() != _game?.code.toString() || gameDaily != _game?.daily) {
      _game = game == null ? null : _Game(game, ++_games, gameDaily);
    }
    notifyListeners();
  }

  void openSettings() => _show(settings: true);

  /// The release notes, over settings.
  void openReleaseNotes() => _show(releaseNotes: true);

  /// The list of tutorials.
  void openLearn() => _show(learn: true);

  /// Opens [type]'s tutorial (or with [strategies], its strategy lessons)
  /// over the current page. [play] is what its "Play" button starts (none:
  /// the tutorial just closes).
  void openTutorial(PuzzleType type, {VoidCallback? play, bool strategies = false}) {
    _tutorial = type;
    _strategies = strategies;
    _tutorialPlay = play;
    notifyListeners();
  }

  /// Opens a puzzle over the page it was picked on; if it is the saved one,
  /// the game resumes.
  void openGame(PuzzleType type, GenParams params) =>
      _show(game: PuzzleCode(type, params), category: _category, family: _family, query: _query);

  void openCategory(PuzzleCategory category) => _show(category: category);

  /// A family of several games, over its category.
  void openFamily(PuzzleFamily family) => _show(category: categoryOfFamily(family), family: family);

  /// Changes the home screen's search text, without a history entry.
  void search(String query) {
    final context = navigatorKey.currentContext;
    if (context == null || query == _query) return;
    Router.neglect(context, () {
      _query = query;
      notifyListeners();
    });
  }

  /// Opens the daily challenges of [day] (today by default).
  void openDaily([Day? day]) => _show(daily: day ?? Day.today());

  /// Picks another day on the open daily page, without a history entry.
  void selectDailyDay(Day day) {
    final context = navigatorKey.currentContext;
    if (context == null || _daily == null) return;
    Router.neglect(context, () {
      _daily = day;
      notifyListeners();
    });
  }

  /// Opens one of [day]'s puzzles (over the daily page); a saved one resumes.
  void openDailyGame(Day day, PuzzleType type, Difficulty difficulty) =>
      _show(daily: day, game: PuzzleCode(type, dailyParams(day, type, difficulty)));

  /// The game screen started another puzzle: update the address in place, so
  /// back still leads home.
  void _puzzleChanged(_Game game, GenParams params) {
    final code = PuzzleCode(game.code.type, params);
    final context = navigatorKey.currentContext;
    if (code.toString() == game.code.toString() || _game != game || context == null) return;
    Router.neglect(context, () {
      game.code = code;
      notifyListeners();
    });
  }

  @override
  Widget build(BuildContext context) {
    final game = _game;
    return Navigator(
      key: navigatorKey,
      pages: [
        MaterialPage(
          key: const ValueKey('home'),
          child: HomeScreen(query: _query),
        ),
        if (_category case final category?)
          MaterialPage(
            key: const ValueKey('category'),
            child: CategoryScreen(category: category),
          ),
        if (_family case final family?)
          MaterialPage(
            key: const ValueKey('family'),
            child: FamilyScreen(family: family),
          ),
        if (_settings) const MaterialPage(key: ValueKey('settings'), child: SettingsScreen()),
        if (_releaseNotes) const MaterialPage(key: ValueKey('release-notes'), child: ReleaseNotesScreen()),
        if (_learn) const MaterialPage(key: ValueKey('learn'), child: LearnScreen()),
        if (_daily case final day?)
          MaterialPage(
            key: const ValueKey('daily'),
            child: DailyScreen(day: day),
          ),
        if (game != null)
          MaterialPage(
            key: ValueKey(game.id),
            child: GameScreen(
              type: game.code.type,
              params: game.code.params,
              daily: game.daily,
              onPuzzleChanged: game.daily != null ? null : (params) => _puzzleChanged(game, params),
            ),
          ),
        if (_tutorial case final type?)
          MaterialPage(
            key: ValueKey('tutorial.${type.id}.$_strategies'),
            child: TutorialScreen(type: type, strategies: _strategies, onPlay: _tutorialPlay),
          ),
      ],
      onDidRemovePage: (page) {
        if (page.key == const ValueKey('category')) {
          _category = null;
          _family = null;
        }
        if (page.key == const ValueKey('family')) _family = null;
        if (page.key == const ValueKey('settings')) _settings = false;
        if (page.key == const ValueKey('release-notes')) _releaseNotes = false;
        if (page.key == const ValueKey('learn')) _learn = false;
        if (page.key == ValueKey('tutorial.${_tutorial?.id}.$_strategies')) {
          _tutorial = null;
          _tutorialPlay = null;
        }
        if (page.key == const ValueKey('daily')) _daily = null;
        if (_game case final g? when page.key == ValueKey(g.id)) _game = null;
        notifyListeners();
      },
    );
  }
}
