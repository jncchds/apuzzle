import 'package:apuzzle/core/persistence.dart';
import 'package:apuzzle/core/puzzle_type.dart';
import 'package:apuzzle/core/settings.dart';
import 'package:apuzzle/l10n/l10n.dart';
import 'package:apuzzle/puzzles/fence/fence_type.dart';
import 'package:apuzzle/puzzles/mambo/mambo_type.dart';
import 'package:apuzzle/puzzles/mines/mines_type.dart';
import 'package:apuzzle/ui/app_router.dart';
import 'package:apuzzle/ui/tutorial_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<GameStore> _pump(WidgetTester tester, Widget home, {Map<String, Object> prefs = const {}}) async {
  tester.view.physicalSize = const Size(1080, 2280);
  tester.view.devicePixelRatio = 3;
  addTearDown(tester.view.reset);
  SharedPreferences.setMockInitialValues(prefs);
  final store = await GameStore.open();
  await tester.pumpWidget(MultiProvider(
    providers: [Provider.value(value: store), ChangeNotifierProvider(create: (_) => Settings(store.prefs))],
    child: MaterialApp(
      locale: const Locale('en'),
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      home: home,
    ),
  ));
  await tester.pump();
  return store;
}

/// Presses "Show me" until the step is done, then Next (or Finish).
Future<void> _finishStep(WidgetTester tester) async {
  for (var k = 0; k < 60; k++) {
    // Next / Finish is the step's only filled button.
    final next = tester.widget<FilledButton>(find.byWidgetPredicate((w) => w is FilledButton));
    if (next.onPressed != null) {
      next.onPressed!();
      await tester.pump(const Duration(milliseconds: 300));
      return;
    }
    await tester.tap(find.text('Show me'));
    await tester.pump(const Duration(milliseconds: 300));
  }
  fail('the step never finished');
}

void main() {
  for (final type in const <PuzzleType>[MamboType(), FenceType(), MinesType()]) {
    testWidgets('${type.id}: "Show me" and Next walk through every step to the end', (tester) async {
      final store = await _pump(tester, TutorialScreen(type: type, onPlay: () {}));
      final steps = type.tutorial().length;
      for (var k = 0; k < steps; k++) {
        expect(find.text('Step ${k + 1} of $steps'), findsOneWidget);
        await _finishStep(tester);
      }
      await tester.pump(const Duration(seconds: 2));
      expect(find.text("You've got it!"), findsOneWidget);
      expect(find.text('Play now'), findsOneWidget);
      expect(store.tutorialDone(type.id), isTrue);
      await tester.pumpWidget(const SizedBox());
      await tester.pump(const Duration(seconds: 2));
    });
  }

  group('offerTutorial', () {
    Future<(GameStore, List<String>)> offer(WidgetTester tester, {Map<String, Object> prefs = const {}}) async {
      final played = <String>[];
      final router = AppRouterDelegate();
      addTearDown(router.dispose);
      tester.view.physicalSize = const Size(1080, 2280);
      tester.view.devicePixelRatio = 3;
      addTearDown(tester.view.reset);
      SharedPreferences.setMockInitialValues(prefs);
      final store = await GameStore.open();
      await tester.pumpWidget(MultiProvider(
        providers: [Provider.value(value: store), ChangeNotifierProvider(create: (_) => Settings(store.prefs))],
        child: MaterialApp.router(
          locale: const Locale('en'),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          routerDelegate: router,
          routeInformationParser: const AppRouteParser(),
        ),
      ));
      await tester.pumpAndSettle();
      final context = router.navigatorKey.currentContext!;
      offerTutorial(context, const MamboType(), play: () => played.add('mambo'));
      await tester.pumpAndSettle();
      return (store, played);
    }

    testWidgets('"No, thanks" plays and never asks again', (tester) async {
      final (store, played) = await offer(tester);
      expect(find.text('New to Sun & Moon?'), findsOneWidget);
      await tester.tap(find.text('No, thanks'));
      await tester.pumpAndSettle();
      expect(played, ['mambo']);
      expect(store.knowsGame('mambo'), isTrue);
      expect(store.tutorialDone('mambo'), isFalse);
    });

    testWidgets('"Show me how" opens the tutorial first', (tester) async {
      final (_, played) = await offer(tester);
      await tester.tap(find.text('Show me how'));
      await tester.pumpAndSettle();
      expect(played, isEmpty);
      expect(find.text('How to play Sun & Moon'), findsOneWidget);
    });

    testWidgets('players who know the game go straight in', (tester) async {
      final (_, played) = await offer(tester, prefs: {'stats.mambo.easy': '{"solved":1}'});
      expect(find.text('New to Sun & Moon?'), findsNothing);
      expect(played, ['mambo']);
    });
  });
}
