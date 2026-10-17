import 'dart:math';

import 'day.dart';
import 'difficulty.dart';
import 'puzzle_code.dart';
import 'puzzle_type.dart';
import 'registry.dart';

/// Daily challenges: every date picks [dailyGamesPerDay] games from the ones
/// released by then, each played at its [PuzzleType.dailyDifficulties] with a fixed size
/// ([PuzzleType.dailySize]) and one seed per date. The puzzles are plain
/// [GenParams], so they have ordinary share codes.

/// The first day of daily challenges, the release date of the original games.
const dailyLaunch = Day(2026, 9, 1);

const dailyGamesPerDay = 3;

/// One daily puzzle.
typedef DailyPuzzle = ({PuzzleType type, Difficulty difficulty});

/// The seed of every puzzle of [day].
int dailySeed(Day day) => hash31(day.toString());

/// The games the player left out of daily challenges from [from] on, until
/// the next choice.
typedef DailyChoice = ({Day from, Set<String> excluded});

/// The player's choices, oldest first; [GameStore] loads and saves them.
/// Days before the first one draw from every game.
List<DailyChoice> dailyChoices = const [];

/// Type ids left out of [day]'s draw.
Set<String> dailyExcluded(Day day, [List<PuzzleType> types = puzzleTypes]) {
  DailyChoice? choice;
  for (final c in dailyChoices) {
    if (c.from <= day) choice = c;
  }
  return choice == null ? const {} : choiceExcluded(choice, day, types);
}

/// What [choice] leaves out on [day]: the games the player left out, plus
/// every [PuzzleType.dailyOptIn] game in [day]'s pool that only joined it
/// after the choice was made, so the player never got to pick it. Players
/// who never chose get those games like any other.
Set<String> choiceExcluded(DailyChoice choice, Day day, [List<PuzzleType> types = puzzleTypes]) => {
  ...choice.excluded,
  for (final t in types)
    if (t.dailyOptIn && choice.from < t.dailySince && t.dailySince <= day) t.id,
};

/// The games that can be chosen for daily challenges on [day].
List<PuzzleType> dailyPool(Day day, [List<PuzzleType> types = puzzleTypes]) => [
  for (final t in types)
    if (t.dailySince <= day) t,
];

/// The games of [day], in pick order. A type only joins the pool from its
/// [PuzzleType.dailySince], so releasing one never changes earlier days, and
/// a [DailyChoice] only counts from its own day on.
List<PuzzleType> dailyGames(Day day, [List<PuzzleType> types = puzzleTypes]) {
  final excluded = dailyExcluded(day, types);
  // By id, so reordering the home screen doesn't reshuffle past days.
  final pool = [
    for (final t in dailyPool(day, types))
      if (!excluded.contains(t.id)) t,
  ]..sort((a, b) => a.id.compareTo(b.id));
  final rng = Random(dailySeed(day));
  final picked = <PuzzleType>[];
  while (picked.length < dailyGamesPerDay && pool.isNotEmpty) {
    picked.add(pool.removeAt(rng.nextInt(pool.length)));
  }
  return picked;
}

List<DailyPuzzle> dailyPuzzles(Day day) => [
  for (final t in dailyGames(day))
    for (final d in t.dailyDifficulties) (type: t, difficulty: d),
];

GenParams dailyParams(Day day, PuzzleType type, Difficulty difficulty) => GenParams(
  size: type.dailySize(difficulty),
  difficulty: difficulty,
  seed: dailySeed(day),
  options: type.resolveOptions(const {}),
  version: type.versionOn(day),
);

/// Whether [code] is one of [day]'s puzzles and [day] is playable.
bool isDailyPuzzle(Day day, PuzzleCode code, {Day? today}) =>
    dailyLaunch <= day &&
    day <= (today ?? Day.today()) &&
    dailyGames(day).contains(code.type) &&
    code.type.dailyDifficulties.contains(code.params.difficulty) &&
    code.toString() == PuzzleCode.format(code.type, dailyParams(day, code.type, code.params.difficulty));

/// The day whose puzzle [code] is (up to [today]), or null. A free game can
/// be a daily one too, opened from a plain share link or (rarely) by chance.
Day? dailyDayOf(PuzzleCode code, {Day? today}) {
  final p = code.params;
  // Most free games differ in size, so the days aren't even looked at.
  if (p.size != code.type.dailySize(p.difficulty)) return null;
  final last = today ?? Day.today();
  for (var d = dailyLaunch; d <= last; d = d.addDays(1)) {
    if (dailySeed(d) == p.seed && isDailyPuzzle(d, code, today: last)) return d;
  }
  return null;
}

/// 31-bit FNV-1a hash of [s] that gives the same result on native and web
/// (products stay below 2^53).
int hash31(String s) {
  var h = 0x811C9DC5;
  for (final c in s.codeUnits) {
    h = (h ^ c) & 0xFFFFFFFF;
    h = _mul32(h, 0x01000193);
  }
  // Final avalanche, so neighbouring dates land far apart.
  h = _mul32(h ^ (h >>> 16), 0x85EBCA6B);
  h = _mul32(h ^ (h >>> 13), 0xC2B2AE35);
  h = (h ^ (h >>> 16)) & 0xFFFFFFFF;
  return h & PuzzleCode.maxSeed;
}

/// `a * b mod 2^32` for 32-bit [a] and [b], exact on the web too.
int _mul32(int a, int b) {
  final lo = (a & 0xFFFF) * b;
  final hi = ((a >>> 16) * b) & 0xFFFF;
  return (lo + hi * 0x10000) & 0xFFFFFFFF;
}
