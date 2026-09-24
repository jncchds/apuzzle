import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/settings.dart';
import 'ui/home_screen.dart';

class APuzzleApp extends StatelessWidget {
  const APuzzleApp({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<Settings>();
    return MaterialApp(
      title: 'APuzzle',
      debugShowCheckedModeBanner: false,
      themeMode: settings.themeMode,
      theme: _theme(Brightness.light),
      darkTheme: _theme(Brightness.dark),
      home: const HomeScreen(),
    );
  }
}

ThemeData _theme(Brightness brightness) => ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF5B6CFF), brightness: brightness),
    );
