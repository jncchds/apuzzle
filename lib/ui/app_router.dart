import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../core/difficulty.dart';
import '../core/puzzle_code.dart';
import '../core/puzzle_type.dart';
import '../core/registry.dart';
import '../l10n/l10n.dart';
import 'game_screen.dart';
import 'home_screen.dart';
import 'settings_screen.dart';

/// What the address bar shows: home (`/`), settings (`/settings`) or a puzzle
/// by its share code (`/?p=kings-8x8-hard-4FZ8K1-v1`, the share link itself).
/// On the web this gives the browser's back and forward buttons real history;
/// on Android the same parser opens share links.
class AppRoute {
  const AppRoute({this.settings = false, this.game, this.error});

  final bool settings;
  final PuzzleCode? game;

  /// A puzzle link that didn't parse.
  final Tr? error;

  static AppRoute parse(Uri uri) {
    // Android passes the link's full path (/apuzzle/?p=…), the web the path
    // below the base href (/?p=…).
    final link = uri.toString();
    if (PuzzleCode.find(link) != null) {
      try {
        return AppRoute(game: PuzzleCode.parse(link, puzzleTypes));
      } on PuzzleCodeException catch (e) {
        return AppRoute(error: e.describe);
      }
    }
    return AppRoute(settings: uri.pathSegments.lastOrNull == 'settings');
  }

  Uri get uri => game != null
      ? Uri(path: '/', queryParameters: {'p': game.toString()})
      : Uri(path: settings ? '/settings' : '/');
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
  _Game(this.code, this.id);

  PuzzleCode code;

  /// Keeps the page (and its [GameScreen] state) while the in-game "new
  /// puzzle" changes [code].
  final int id;
}

/// Home, with settings or one game on top. Dialogs and sheets stay pageless.
class AppRouterDelegate extends RouterDelegate<AppRoute> with ChangeNotifier, PopNavigatorRouterDelegateMixin<AppRoute> {
  AppRouterDelegate({this.messengerKey});

  final GlobalKey<ScaffoldMessengerState>? messengerKey;

  @override
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey();

  static AppRouterDelegate of(BuildContext context) => Router.of(context).routerDelegate as AppRouterDelegate;

  bool _settings = false;
  _Game? _game;
  int _games = 0;

  @override
  AppRoute get currentConfiguration => AppRoute(settings: _settings, game: _game?.code);

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
    _show(settings: configuration.settings, game: configuration.game);
    return SynchronousFuture(null);
  }

  void _show({bool settings = false, PuzzleCode? game}) {
    _settings = settings;
    if (game?.toString() != _game?.code.toString()) _game = game == null ? null : _Game(game, ++_games);
    notifyListeners();
  }

  void openSettings() => _show(settings: true);

  /// Opens a puzzle; if it is the saved one, the game resumes.
  void openGame(PuzzleType type, GenParams params) => _show(game: PuzzleCode(type, params));

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
        const MaterialPage(key: ValueKey('home'), child: HomeScreen()),
        if (_settings) const MaterialPage(key: ValueKey('settings'), child: SettingsScreen()),
        if (game != null)
          MaterialPage(
            key: ValueKey(game.id),
            child: GameScreen(
              type: game.code.type,
              params: game.code.params,
              onPuzzleChanged: (params) => _puzzleChanged(game, params),
            ),
          ),
      ],
      onDidRemovePage: (page) {
        if (page.key == const ValueKey('settings')) _settings = false;
        if (_game case final g? when page.key == ValueKey(g.id)) _game = null;
        notifyListeners();
      },
    );
  }
}
