import 'package:apuzzle/app.dart';
import 'package:apuzzle/core/persistence.dart';
import 'package:apuzzle/core/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  Future<GameStore> start(WidgetTester tester, {Map<String, Object> prefs = const {}}) async {
    tester.view.physicalSize = const Size(1080, 2280);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    SharedPreferences.setMockInitialValues({'set.language': 'en', ...prefs});
    final store = await GameStore.open();
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          Provider.value(value: store),
          ChangeNotifierProvider(create: (_) => Settings(store.prefs)),
        ],
        child: const APuzzleApp(),
      ),
    );
    await tester.pumpAndSettle();
    return store;
  }

  testWidgets('categories open their games, and a family its variants', (tester) async {
    await start(tester);
    expect(find.text('Sudoku'), findsNothing);
    await tester.tap(find.text('Numbers'));
    await tester.pumpAndSettle();
    expect(find.text('Sudoku'), findsOneWidget);
    await tester.pageBack();
    await tester.pumpAndSettle();
    await tester.tap(find.text('Casual'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Flood'));
    await tester.pumpAndSettle();
    expect(find.text('Mosaic'), findsOneWidget);
    expect(find.text('Blend'), findsOneWidget);
  });

  testWidgets('search lists matches, and says when only another name matched', (tester) async {
    await start(tester);
    await tester.enterText(find.byType(TextField), 'loop');
    await tester.pumpAndSettle();
    expect(find.text('Fence'), findsOneWidget);
    expect(find.text('Numbers'), findsNothing);
    await tester.enterText(find.byType(TextField), 'Nurikabe');
    await tester.pumpAndSettle();
    expect(find.textContaining('“Nurikabe”'), findsOneWidget);
    expect(find.text('Islands'), findsOneWidget);
    await tester.enterText(find.byType(TextField), 'zzzz');
    await tester.pumpAndSettle();
    expect(find.textContaining('No games found'), findsOneWidget);
    expect(find.text('Numbers'), findsOneWidget, reason: 'categories to browse instead');
    await tester.enterText(find.byType(TextField), 'sudoko');
    await tester.pumpAndSettle();
    expect(find.textContaining('Did you mean'), findsOneWidget);
    expect(find.text('Sudoku'), findsOneWidget);
  });

  testWidgets('your games: pinned first, then the ones played last', (tester) async {
    await start(
      tester,
      prefs: {
        'games.recent': ['sudoku', 'kings'],
        'games.pinned': ['fence'],
      },
    );
    expect(find.text('Your games'), findsOneWidget);
    final x = [
      for (final n in ['Fence', 'Sudoku', 'Crowns']) tester.getCenter(find.text(n)).dx,
    ];
    expect(x[0] < x[1] && x[1] < x[2], isTrue);
  });

  testWidgets('no "your games" before anything was played', (tester) async {
    await start(tester);
    expect(find.text('Your games'), findsNothing);
  });
}
