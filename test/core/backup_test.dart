import 'dart:convert';

import 'package:apuzzle/core/backup.dart';
import 'package:apuzzle/core/day.dart';
import 'package:apuzzle/core/difficulty.dart';
import 'package:apuzzle/core/persistence.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Two installs: each gets its own prefs, read back through a fresh store.
Future<GameStore> device(String id, [Map<String, Object> prefs = const {}]) async {
  SharedPreferences.setMockInitialValues({'device.id': id, ...prefs});
  return GameStore(await SharedPreferences.getInstance());
}

/// [from]'s progress through the text code, as the other device sees it.
Map<String, dynamic> carry(GameStore from) => ProgressCode.decode(ProgressCode.encode(from.exportProgress()))!;

void main() {
  group('ProgressCode', () {
    test('round-trips and is not plain JSON', () {
      final data = {'v': 1, 'name': 'Пазл ✓', 'n': 42};
      final code = ProgressCode.encode(data, nonce: 7);
      expect(code, startsWith('APUZZLE1:'));
      expect(code.contains('name'), isFalse);
      expect(ProgressCode.encode(data, nonce: 8), isNot(code));
      expect(ProgressCode.decode(code), data);
      // Chat apps wrap long text.
      expect(ProgressCode.decode('  ${code.substring(0, 20)}\n${code.substring(20)} '), data);
    });

    test('is the same on every platform', () {
      expect(ProgressCode.encode({'v': 1, 'd': 'ü'}, nonce: 0xDEADBEEF), _vector);
      expect(ProgressCode.decode(_vector), {'v': 1, 'd': 'ü'});
    });

    test('rejects other text and damaged codes', () {
      final code = ProgressCode.encode({'v': 1}, nonce: 1);
      expect(ProgressCode.decode('hello'), isNull);
      expect(ProgressCode.decode('APUZZLE1:'), isNull);
      expect(ProgressCode.decode('APUZZLE1:!!!'), isNull);
      final last = code.length - 3;
      final flipped = code.replaceRange(last, last + 1, code[last] == 'A' ? 'B' : 'A');
      expect(ProgressCode.decode(flipped), isNull);
    });
  });

  group('importProgress', () {
    test('adds wins of both devices and keeps the best time, once', () async {
      final a = await device('a');
      await a.recordWin('sudoku', 'easy', const Duration(seconds: 50));
      await a.recordWin('sudoku', 'easy', const Duration(seconds: 70));
      final fromA = carry(a);

      final b = await device('b');
      await b.recordWin('sudoku', 'easy', const Duration(seconds: 40));
      expect(await b.importProgress(fromA), greaterThan(0));
      var s = b.stats('sudoku', 'easy');
      expect((s.solved, s.bestMs, s.totalMs), (3, 40000, 160000));

      // Importing again, or a round trip back and forth, changes nothing.
      expect(await b.importProgress(fromA), 0);
      final fromB = carry(b);
      final a2 = await device('a', {for (final e in fromA['data'].entries) e.key: e.value});
      await a2.importProgress(fromB);
      s = a2.stats('sudoku', 'easy');
      expect((s.solved, s.bestMs), (3, 40000));
      expect(await b.importProgress(carry(a2)), 0);
    });

    test('stats saved before per-device counts belong to their device', () async {
      final old = jsonEncode({'solved': 4, 'best': 9000, 'total': 60000});
      final a = await device('a', {'stats.kings.hard': old});
      final b = await device('b', {
        'stats.kings.hard': jsonEncode({'solved': 1, 'best': 5000, 'total': 5000}),
      });
      await b.importProgress(carry(a));
      final s = b.stats('kings', 'hard');
      expect((s.solved, s.bestMs, s.totalMs), (5, 5000, 65000));
    });

    test('daily results keep the faster solve per puzzle', () async {
      final day = Day(2026, 9, 30);
      final a = await device('a');
      await a.recordDaily(day, 'kings', Difficulty.easy, 'k1', const Duration(seconds: 30), 0);
      await a.recordDaily(day, 'mines', Difficulty.hard, 'm1', const Duration(seconds: 90), 1);
      final b = await device('b');
      await b.recordDaily(day, 'kings', Difficulty.easy, 'k1', const Duration(seconds: 20), 0);
      await b.importProgress(carry(a));
      final r = b.dailyResults(day);
      expect(r['kings.easy']!.bestMs, 20000);
      expect(r['mines.hard']!.bestMs, 90000);
    });

    test('the newer saved game wins; a solved daily is not resumed', () async {
      final a = await device('a', {
        'save.pipes': jsonEncode({'elapsed': 1, 'at': 100}),
        'save.lits': jsonEncode({'elapsed': 2, 'at': 300}),
        'save.daily.k1': jsonEncode({'elapsed': 3}),
      });
      final b = await device('b', {
        'save.pipes': jsonEncode({'elapsed': 10, 'at': 200}),
        'save.lits': jsonEncode({'elapsed': 20, 'at': 200}),
        'daily.2026-09-30': jsonEncode({
          'kings.easy': {'code': 'k1', 'ms': 1000},
        }),
      });
      await b.importProgress(carry(a));
      expect(b.readSave('pipes')!['elapsed'], 10);
      expect(b.readSave('lits')!['elapsed'], 2);
      expect(b.hasSave('daily.k1'), isFalse);
    });

    test('tutorials: done beats skipped; settings stay on the device', () async {
      final a = await device('a', {
        'tutorial.kings': 'done',
        'tutorial.lits': 'skipped',
        'strategies.kings': true,
        'set.theme': 'dark',
        'last.kings': '{"size":8}',
      });
      final b = await device('b', {'tutorial.kings': 'skipped', 'tutorial.lits': 'done', 'last.kings': '{"size":6}'});
      await b.importProgress(carry(a));
      expect(b.tutorialDone('kings'), isTrue);
      expect(b.tutorialDone('lits'), isTrue);
      expect(b.strategiesDone('kings'), isTrue);
      expect(b.prefs.getString('set.theme'), isNull);
      expect(b.prefs.getString('last.kings'), '{"size":6}');
    });

    test('rejects data that is not progress', () async {
      final b = await device('b');
      expect(() => b.importProgress({'v': 2}), throwsFormatException);
    });
  });
}

/// A code made on native; the web must read and write the same bytes.
const _vector = 'APUZZLE1:776t3hQWVg2CMXQ8-p8TkTNKN2g4pQuR';
