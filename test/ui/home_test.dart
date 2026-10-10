import 'package:apuzzle/app.dart';
import 'package:apuzzle/core/persistence.dart';
import 'package:apuzzle/core/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('a folded group hides its games and stays folded after a restart', (tester) async {
    tester.view.physicalSize = const Size(1080, 2280);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    SharedPreferences.setMockInitialValues({'set.language': 'en'});
    final store = await GameStore.open();

    Future<void> start() async {
      await tester.pumpWidget(
        MultiProvider(
          key: UniqueKey(),
          providers: [
            Provider.value(value: store),
            ChangeNotifierProvider(create: (_) => Settings(store.prefs)),
          ],
          child: const APuzzleApp(),
        ),
      );
      await tester.pump(const Duration(milliseconds: 500));
    }

    await start();
    expect(find.text('Sudoku'), findsOneWidget);
    await tester.tap(find.byIcon(Icons.expand_more_rounded).first);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pump();
    expect(find.text('Sudoku'), findsNothing);
    expect(find.text('Sun & Moon'), findsOneWidget);

    await start();
    expect(find.text('Sudoku'), findsNothing);
    await tester.tap(find.byIcon(Icons.expand_more_rounded).first);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pump();
    expect(find.text('Sudoku'), findsOneWidget);
  });
}
