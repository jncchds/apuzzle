// Renders every puzzle's game screen at phone size to build/snapshots/*.png
// (real fonts), for visual review without a device.
//
//   flutter test test/snapshots --run-skipped --tags snapshot
@Tags(['snapshot'])
library;

import 'dart:io';
import 'dart:ui' as ui;

import 'package:apuzzle/app.dart';
import 'package:apuzzle/core/difficulty.dart';
import 'package:apuzzle/core/persistence.dart';
import 'package:apuzzle/core/puzzle_type.dart';
import 'package:apuzzle/core/registry.dart';
import 'package:apuzzle/core/settings.dart';
import 'package:apuzzle/ui/game_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _fontsDir = 'C:/flutter/bin/cache/artifacts/material_fonts';

Future<void> _loadFont(String family, List<String> files) async {
  final loader = FontLoader(family);
  for (final f in files) {
    final bytes = File('$_fontsDir/$f').readAsBytesSync();
    loader.addFont(Future.value(ByteData.view(bytes.buffer)));
  }
  await loader.load();
}

/// How many hint steps to apply so the board shows some progress.
int _progressSteps(PuzzleType t) => switch (t.id) {
      'mosaic' => 3,
      'trail' => 8,
      _ => 6,
    };

void main() {
  setUpAll(() async {
    await _loadFont('Roboto', ['roboto-regular.ttf', 'roboto-medium.ttf', 'roboto-bold.ttf']);
    await _loadFont('MaterialIcons', ['materialicons-regular.otf']);
  });

  final outDir = Directory('build/snapshots')..createSync(recursive: true);

  for (final brightness in [Brightness.dark, Brightness.light]) {
    for (final type in puzzleTypes) {
      testWidgets('snapshot ${type.id} ${brightness.name}', (tester) async {
        tester.view.physicalSize = const Size(1080, 2280);
        tester.view.devicePixelRatio = 3;
        addTearDown(tester.view.reset);

        SharedPreferences.setMockInitialValues({'set.theme': brightness == Brightness.dark ? 'dark' : 'light'});
        final store = await GameStore.open();
        final settings = Settings(store.prefs);
        final params = GenParams(size: type.defaultSize, difficulty: Difficulty.medium, seed: 7);
        final puzzle = await tester.runAsync(() async => type.generate(params) as Object);
        var state = type.initialState(puzzle) as Object;
        for (var i = 0; i < _progressSteps(type); i++) {
          final h = type.hint(puzzle, state);
          if (h == null) break;
          state = h.state as Object;
        }

        final key = GlobalKey();
        await tester.pumpWidget(MultiProvider(
          providers: [Provider.value(value: store), ChangeNotifierProvider.value(value: settings)],
          child: RepaintBoundary(
            key: key,
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              themeMode: settings.themeMode,
              theme: ThemeData(
                useMaterial3: true,
                fontFamily: 'Roboto',
                colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF5B6CFF)),
              ),
              darkTheme: ThemeData(
                useMaterial3: true,
                fontFamily: 'Roboto',
                colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF5B6CFF), brightness: Brightness.dark),
              ),
              home: GameScreen(type: type, params: params, presetPuzzle: puzzle, presetState: state),
            ),
          ),
        ));
        await tester.pump(const Duration(seconds: 1));
        await tester.pump(const Duration(seconds: 1));

        await tester.runAsync(() async {
          final boundary = key.currentContext!.findRenderObject()! as RenderRepaintBoundary;
          final image = await boundary.toImage(pixelRatio: 1);
          final png = await image.toByteData(format: ui.ImageByteFormat.png);
          File('${outDir.path}/${type.id}_${brightness.name}.png').writeAsBytesSync(png!.buffer.asUint8List());
        });
        // Leave the screen so its timers are cancelled.
        await tester.pumpWidget(const SizedBox());
        await tester.pump(const Duration(seconds: 2));
      });
    }
  }

  // Keep the app import used (home screen snapshot).
  testWidgets('snapshot home', (tester) async {
    tester.view.physicalSize = const Size(1080, 2280);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    SharedPreferences.setMockInitialValues({'set.theme': 'dark'});
    final store = await GameStore.open();
    final key = GlobalKey();
    await tester.pumpWidget(MultiProvider(
      providers: [Provider.value(value: store), ChangeNotifierProvider(create: (_) => Settings(store.prefs))],
      child: RepaintBoundary(key: key, child: const APuzzleApp()),
    ));
    await tester.pump(const Duration(milliseconds: 500));
    await tester.runAsync(() async {
      final boundary = key.currentContext!.findRenderObject()! as RenderRepaintBoundary;
      final image = await boundary.toImage(pixelRatio: 1);
      final png = await image.toByteData(format: ui.ImageByteFormat.png);
      File('${outDir.path}/home.png').writeAsBytesSync(png!.buffer.asUint8List());
    });
  });
}
