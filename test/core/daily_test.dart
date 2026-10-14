import 'package:apuzzle/core/daily.dart';
import 'package:apuzzle/core/day.dart';
import 'package:apuzzle/core/difficulty.dart';
import 'package:apuzzle/core/persistence.dart';
import 'package:apuzzle/core/puzzle_code.dart';
import 'package:apuzzle/core/puzzle_type.dart';
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
  setUp(() => dailyChoices = const []);
  tearDown(() => dailyChoices = const []);

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
      for (final d in t.dailyDifficulties) {
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

  test('a code finds its day, and only up to today', () {
    const day = Day(2026, 9, 20);
    const today = Day(2026, 9, 25);
    for (final p in dailyPuzzles(day)) {
      final code = PuzzleCode(p.type, dailyParams(day, p.type, p.difficulty));
      expect(dailyDayOf(code, today: today), day);
      expect(dailyDayOf(code, today: day.addDays(-1)), isNull);
      final params = code.params;
      final free = GenParams(
        size: params.size,
        difficulty: params.difficulty,
        seed: params.seed + 1,
        options: params.options,
      );
      expect(dailyDayOf(PuzzleCode(p.type, free), today: today), isNull);
    }
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

  test('2048 is played at one difficulty, Snake at a size per difficulty', () {
    final merge = puzzleTypeById('merge'), snake = puzzleTypeById('snake');
    expect(merge.dailyDifficulties, [Difficulty.medium]);
    var d = dailyLaunch;
    while (!dailyGames(d).contains(merge)) {
      d = d.addDays(1);
    }
    expect(dailyPuzzles(d).where((p) => p.type == merge).map((p) => p.difficulty), [Difficulty.medium]);
    final easy = PuzzleCode(merge, dailyParams(d, merge, Difficulty.easy));
    expect(isDailyPuzzle(d, easy, today: d), isFalse);
    expect({for (final x in snake.dailyDifficulties) snake.dailySize(x)}.length, 3);
  });

  test('chosen games count from their day on and never change earlier days', () async {
    SharedPreferences.setMockInitialValues({});
    final store = await GameStore.open();
    const first = Day(2026, 9, 10);
    const second = Day(2026, 9, 20);
    final before = [for (var d = dailyLaunch; d < dailyLaunch.addDays(40); d = d.addDays(1)) dailyGames(d)];

    final keep = {'kings', 'sudoku', 'mambo', 'lits'};
    final off = {
      for (final t in puzzleTypes)
        if (!keep.contains(t.id)) t.id,
    };
    await store.setDailyExcluded(off, today: first);
    await store.setDailyExcluded({'kings'}, today: second);

    for (var i = 0; i < before.length; i++) {
      final d = dailyLaunch.addDays(i);
      final games = dailyGames(d);
      expect(games.length, dailyGamesPerDay);
      if (d < first) {
        expect(games, before[i], reason: '$d');
      } else if (d < second) {
        expect(games.every((t) => keep.contains(t.id)), isTrue, reason: '$d');
      } else {
        expect(games.any((t) => t.id == 'kings'), isFalse, reason: '$d');
      }
    }
    // A puzzle of a game that was left out is no daily one.
    final out = puzzleTypes.firstWhere((t) => t.id == 'pipes');
    expect(isDailyPuzzle(first, PuzzleCode(out, dailyParams(first, out, Difficulty.easy)), today: second), isFalse);

    // The history survives a restart.
    dailyChoices = const [];
    final again = GameStore(store.prefs);
    expect(dailyExcluded(first), off);
    expect(dailyExcluded(second.addDays(5)), {'kings'});
    expect(dailyExcluded(first.addDays(-1)), isEmpty);

    // Changing the same day again replaces that day's choice; going back to
    // the choice before it drops the entry.
    await again.setDailyExcluded({'sudoku'}, today: second);
    expect(dailyChoices.length, 2);
    expect(dailyExcluded(second), {'sudoku'});
    await again.setDailyExcluded(off, today: second);
    expect(dailyChoices.length, 1);
    expect(dailyExcluded(second), off);
  });

  test('a new opt-in game starts left out for players who already chose', () async {
    final optIn = [
      for (final t in puzzleTypes)
        if (t.dailyOptIn) t,
    ];
    expect(optIn, isNotEmpty);
    expect(optIn.every((t) => t.dailySince > dailyLaunch), isTrue);
    expect(puzzleTypeById('snake').dailyOptIn, isFalse, reason: 'released before opt-in existed');
    final since = optIn.map((t) => t.dailySince).reduce((a, b) => a < b ? a : b);
    final later = since.addDays(30);
    final ids = {for (final t in optIn) t.id};

    // Never chose: the new games join the pool like any other.
    SharedPreferences.setMockInitialValues({});
    final store = await GameStore.open();
    expect(dailyExcluded(later), isEmpty);
    final drawn = <String>{};
    for (var d = since; d < since.addDays(200); d = d.addDays(1)) {
      drawn.addAll(dailyGames(d).map((t) => t.id));
    }
    expect(drawn.intersection(ids), isNotEmpty);

    // Chose before they came out: they stay left out, and nothing else changes.
    final before = since.addDays(-5);
    await store.setDailyExcluded({'kings'}, today: before);
    expect(dailyExcluded(before.addDays(1)), {'kings'}, reason: 'not out yet');
    expect(dailyExcluded(later), {'kings', ...ids});
    for (var d = since; d < since.addDays(200); d = d.addDays(1)) {
      expect(dailyGames(d).any((t) => ids.contains(t.id) || t.id == 'kings'), isFalse, reason: '$d');
    }

    // Saving the same selection again later changes nothing.
    await store.setDailyExcluded(dailyExcluded(later), today: later);
    expect(dailyChoices.length, 1);

    // Picking a new game later takes it in from then on.
    final pick = optIn.first.id;
    await store.setDailyExcluded(dailyExcluded(later).difference({pick}), today: later);
    expect(dailyExcluded(later).contains(pick), isFalse);
    expect(dailyExcluded(later.addDays(-1)).contains(pick), isTrue);
    // Choices made once the game is out are taken as they are.
    dailyChoices = [(from: later, excluded: const {})];
    expect(dailyExcluded(later), isEmpty);
  });
}
