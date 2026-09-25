import 'dart:convert';
import 'dart:io';

import 'package:apuzzle/app.dart';
import 'package:apuzzle/core/persistence.dart';
import 'package:apuzzle/core/puzzle_code.dart';
import 'package:apuzzle/core/registry.dart';
import 'package:apuzzle/core/settings.dart';
import 'package:apuzzle/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

Map<String, dynamic> _arb(String lang) =>
    jsonDecode(File('lib/l10n/app_$lang.arb').readAsStringSync()) as Map<String, dynamic>;

Future<Settings> _pumpApp(WidgetTester tester, {Map<String, Object> prefs = const {}}) async {
  SharedPreferences.setMockInitialValues(prefs);
  final store = await GameStore.open();
  final settings = Settings(store.prefs);
  await tester.pumpWidget(MultiProvider(
    providers: [Provider.value(value: store), ChangeNotifierProvider.value(value: settings)],
    child: const APuzzleApp(),
  ));
  await tester.pumpAndSettle();
  return settings;
}

void main() {
  group('resolveAppLocale', () {
    Locale resolve(List<String> tags) => resolveAppLocale([for (final t in tags) Locale.fromSubtags(languageCode: t)]);

    test('supported languages are used as is', () {
      for (final lang in appLanguages.keys) {
        expect(resolve([lang]), Locale(lang));
      }
      expect(resolveAppLocale(const [Locale('de', 'AT')]), const Locale('de'));
    });

    test('Russian falls back to Ukrainian', () => expect(resolve(['ru']), const Locale('uk')));

    test('the first supported (or Russian) preference wins', () {
      expect(resolve(['fr', 'pl', 'de']), const Locale('pl'));
      expect(resolve(['fr', 'ru', 'en']), const Locale('uk'));
      expect(resolve(['en', 'ru']), const Locale('en'));
    });

    test('anything else is English', () {
      expect(resolve(['fr', 'ja']), const Locale('en'));
      expect(resolveAppLocale(const []), const Locale('en'));
      expect(resolveAppLocale(null), const Locale('en'));
    });
  });

  test('every language translates every message', () {
    final keys = _arb('en').keys.where((k) => !k.startsWith('@')).toSet();
    for (final lang in appLanguages.keys) {
      expect(_arb(lang).keys.where((k) => !k.startsWith('@')).toSet(), keys, reason: lang);
      expect(AppLocalizations.supportedLocales, contains(Locale(lang)));
    }
  });

  test('every puzzle has a name, tagline and rules in every language', () async {
    for (final lang in appLanguages.keys) {
      final l = await AppLocalizations.delegate.load(Locale(lang));
      for (final t in puzzleTypes) {
        expect(t.name(l), isNotEmpty);
        expect(t.tagline(l), isNotEmpty);
        expect(t.rulesText(l), isNotEmpty);
      }
    }
  });

  test('puzzle code errors are localized', () async {
    final uk = await AppLocalizations.delegate.load(const Locale('uk'));
    try {
      PuzzleCode.parse('kings-99x99-hard-4FZ8K1-v1', puzzleTypes);
      fail('should throw');
    } on PuzzleCodeException catch (e) {
      expect(e.message, 'Crowns has no 99x99 size');
      expect(e.describe(uk), '«Корони» не має розміру 99x99');
    }
  });

  testWidgets('follows the system language, Russian shows Ukrainian', (tester) async {
    tester.platformDispatcher.localesTestValue = const [Locale('ru', 'RU')];
    addTearDown(tester.platformDispatcher.clearLocalesTestValue);
    await _pumpApp(tester);
    expect(find.text('Корони'), findsOneWidget);
  });

  testWidgets('the language setting overrides the system', (tester) async {
    tester.platformDispatcher.localesTestValue = const [Locale('pl')];
    addTearDown(tester.platformDispatcher.clearLocalesTestValue);
    final settings = await _pumpApp(tester, prefs: {'set.language': 'de'});
    expect(find.text('Kronen'), findsOneWidget);

    settings.language = null;
    await tester.pumpAndSettle();
    expect(find.text('Korony'), findsOneWidget);

    settings.language = 'en';
    await tester.pumpAndSettle();
    expect(find.text('Crowns'), findsOneWidget);
  });
}
