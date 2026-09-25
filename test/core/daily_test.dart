import 'package:apuzzle/core/daily.dart';
import 'package:apuzzle/core/day.dart';
import 'package:apuzzle/core/difficulty.dart';
import 'package:apuzzle/core/persistence.dart';
import 'package:apuzzle/core/puzzle_code.dart';
import 'package:apuzzle/core/registry.dart';
import 'package:apuzzle/ui/app_router.dart';
import 'package:apuzzle/ui/new_game_sheet.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Types released with daily challenges. Any other type must override
/// [PuzzleType.dailySince] with its own release date.
const _launchTypes = {
  'mambo', 'sudoku', 'kings', 'hues', 'mosaic', 'blend', 'pop', 'merge', 'pipes', 'shikaku', //
  'trail', 'labyrinth', 'atoms', 'lits', 'camp', 'islands', 'lamps', 'fence', 'pearls', 'mines',
};

/// Plain 64-bit FNV-1a plus the same finalizer, as a reference for [hash31].
int _reference(String s) {
  var h = 0x811C9DC5;
  for (final c in s.codeUnits) {
    h = ((h ^ c) * 0x01000193) & 0xFFFFFFFF;
  }
  h = ((h ^ (h >> 16)) * 0x85EBCA6B) & 0xFFFFFFFF;
  h = ((h ^ (h >> 13)) * 0xC2B2AE35) & 0xFFFFFFFF;
  return (h ^ (h >> 16)) & 0x7FFFFFFF;
}

void main() {
  test('Day parses, prints and steps', () {
    expect(Day.tryParse('2026-09-25'), const Day(2026, 9, 25));
    expect(Day.tryParse('2026-02-31'), isNull);
    expect(Day.tryParse('x'), isNull);
    expect(const Day(2026, 9, 30).addDays(1).toString(), '2026-10-01');
    expect(const Day(2026, 12, 15).addMonths(1), const Day(2027, 1, 1));
    expect(const Day(2026, 2, 3).daysInMonth, 28);
    expect(const Day(2026, 9, 1) < const Day(2026, 9, 2), isTrue);
  });

  test('hash31 matches the 64-bit reference', () {
    for (var d = dailyLaunch; d < dailyLaunch.addDays(400); d = d.addDays(1)) {
      final s = d.toString();
      expect(hash31(s), _reference(s), reason: s);
      expect(hash31(s), inInclusiveRange(0, PuzzleCode.maxSeed));
    }
  });

  test('each day picks distinct released games, deterministically', () {
    final seen = <String>{};
    for (var d = dailyLaunch; d < dailyLaunch.addDays(60); d = d.addDays(1)) {
      final games = dailyGames(d);
      expect(games.length, dailyGamesPerDay);
      expect(games.toSet().length, dailyGamesPerDay);
      expect(games.every((t) => t.dailySince <= d), isTrue);
      expect(dailyGames(d), games);
      seen.addAll(games.map((t) => t.id));
    }
    expect(seen.length, greaterThan(15), reason: 'the rotation reaches most games');
  });

  test('games after the launch declare their own release date', () {
    for (final t in puzzleTypes) {
      expect(t.dailySince == dailyLaunch, _launchTypes.contains(t.id), reason: t.id);
    }
  });

  test('daily sizes are offered and fit a small phone', () {
    for (final t in puzzleTypes) {
      final fits = fittingSizes(t, const Size(360, 760));
      for (final d in t.difficulties) {
        final size = t.dailySize(d);
        expect(t.sizes, contains(size), reason: '${t.id} ${d.name}');
        expect(fits, contains(size), reason: '${t.id} ${d.name} ${size.label} does not fit');
      }
    }
  });

  test('daily codes round-trip and are recognised only on their day', () {
    const day = Day(2026, 9, 20);
    const today = Day(2026, 9, 25);
    for (final p in dailyPuzzles(day)) {
      final code = PuzzleCode(p.type, dailyParams(day, p.type, p.difficulty));
      final parsed = PuzzleCode.parse(code.toString(), puzzleTypes);
      expect(isDailyPuzzle(day, parsed, today: today), isTrue);
      expect(isDailyPuzzle(day.addDays(1), parsed, today: today), isFalse);
      expect(isDailyPuzzle(day, parsed, today: day.addDays(-1)), isFalse, reason: 'future days are closed');
    }
    final other = puzzleTypes.firstWhere((t) => !dailyGames(day).contains(t));
    expect(isDailyPuzzle(day, PuzzleCode(other, dailyParams(day, other, Difficulty.easy)), today: today), isFalse);
  });

  test('daily routes', () {
    const day = Day(2026, 9, 3);
    final p = dailyPuzzles(day).first;
    final code = PuzzleCode(p.type, dailyParams(day, p.type, p.difficulty));
    final r = AppRoute.parse(AppRoute(daily: day, game: code).uri);
    expect(r.daily, day);
    expect(r.game.toString(), code.toString());

    expect(AppRoute.parse(Uri.parse('/daily')).daily, Day.today());
    expect(AppRoute.parse(Uri.parse('/daily?d=2020-01-01')).daily, Day.today(), reason: 'before the launch');
    // A code that isn't the day's puzzle opens as a plain game.
    final plain = AppRoute.parse(Uri.parse('/daily?d=2026-09-03&p=kings-8x8-hard-4FZ8K1-v1'));
    expect(plain.daily, isNull);
    expect(plain.game, isNotNull);
  });

  test('store keeps the best time per daily puzzle', () async {
    SharedPreferences.setMockInitialValues({});
    final store = await GameStore.open();
    const day = Day(2026, 9, 10);
    await store.recordDaily(day, 'kings', Difficulty.hard, 'code', const Duration(seconds: 90), 1);
    await store.recordDaily(day, 'kings', Difficulty.hard, 'code', const Duration(seconds: 120), 0);
    await store.recordDaily(day, 'kings', Difficulty.hard, 'code', const Duration(seconds: 60), 0);
    final r = store.dailyResults(day)[GameStore.dailyEntry('kings', Difficulty.hard)]!;
    expect(r.bestMs, 60000);
    expect(r.hints, 0);
    expect(store.dailyResults(day.addDays(1)), isEmpty);
  });
}
