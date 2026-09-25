import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/settings.dart';
import 'l10n/l10n.dart';
import 'ui/app_router.dart';

class APuzzleApp extends StatefulWidget {
  const APuzzleApp({super.key});

  @override
  State<APuzzleApp> createState() => _APuzzleAppState();
}

class _APuzzleAppState extends State<APuzzleApp> {
  final _messengerKey = GlobalKey<ScaffoldMessengerState>();
  late final _router = AppRouterDelegate(messengerKey: _messengerKey);

  @override
  void dispose() {
    _router.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<Settings>();
    return MaterialApp.router(
      title: 'APuzzle',
      routerDelegate: _router,
      routeInformationParser: const AppRouteParser(),
      scaffoldMessengerKey: _messengerKey,
      debugShowCheckedModeBanner: false,
      themeMode: settings.themeMode,
      locale: settings.language == null ? null : Locale(settings.language!),
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      localeListResolutionCallback: (locales, _) => resolveAppLocale(locales),
      theme: _theme(Brightness.light),
      darkTheme: _theme(Brightness.dark),
    );
  }
}

ThemeData _theme(Brightness brightness) => ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF5B6CFF), brightness: brightness),
    );
