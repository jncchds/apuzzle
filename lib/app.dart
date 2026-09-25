import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/settings.dart';
import 'l10n/l10n.dart';
import 'ui/home_screen.dart';

class APuzzleApp extends StatelessWidget {
  const APuzzleApp({super.key, this.navigatorKey, this.messengerKey});

  final GlobalKey<NavigatorState>? navigatorKey;
  final GlobalKey<ScaffoldMessengerState>? messengerKey;

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<Settings>();
    return MaterialApp(
      title: 'APuzzle',
      navigatorKey: navigatorKey,
      scaffoldMessengerKey: messengerKey,
      debugShowCheckedModeBanner: false,
      themeMode: settings.themeMode,
      locale: settings.language == null ? null : Locale(settings.language!),
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      localeListResolutionCallback: (locales, _) => resolveAppLocale(locales),
      theme: _theme(Brightness.light),
      darkTheme: _theme(Brightness.dark),
      routes: {'/': (_) => const HomeScreen()},
      // A share link's path (/apuzzle/?p=…) arrives as the initial route; always
      // start at home and let ShareLinkHandler open the puzzle on top.
      onGenerateInitialRoutes: (_) => [MaterialPageRoute<void>(builder: (_) => const HomeScreen(), settings: const RouteSettings(name: '/'))],
    );
  }
}

ThemeData _theme(Brightness brightness) => ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF5B6CFF), brightness: brightness),
    );
