import 'dart:math';

import 'day.dart';
import 'difficulty.dart';
import 'puzzle_code.dart';
import 'puzzle_type.dart';
import 'registry.dart';

/// Daily challenges: every date picks [dailyGamesPerDay] games from the ones
/// released by then, each played at all its difficulties with a fixed size
/// ([PuzzleType.dailySize]) and one seed per date. The puzzles are plain
/// [GenParams], so they have ordinary share codes.

/// The first day of daily challenges, the release date of the original games.
const dailyLaunch = Day(2026, 9, 1);

const dailyGamesPerDay = 3;

/// One daily puzzle.
typedef DailyPuzzle = ({PuzzleType type, Difficulty difficulty});

/// The seed of every puzzle of [day].
int dailySeed(Day day) => hash31(day.toString());

/// The games of [day], in pick order. A type only joins the pool from its
/// [PuzzleType.dailySince], so releasing one never changes earlier days.
List<PuzzleType> dailyGames(Day day, [List<PuzzleType> types = puzzleTypes]) {
  // By id, so reordering the home screen doesn't reshuffle past days.
  final pool = [for (final t in types) if (t.dailySince <= day) t]..sort((a, b) => a.id.compareTo(b.id));
  final rng = Random(dailySeed(day));
  final picked = <PuzzleType>[];
  while (picked.length < dailyGamesPerDay && pool.isNotEmpty) {
    picked.add(pool.removeAt(rng.nextInt(pool.length)));
  }
  return picked;
}

List<DailyPuzzle> dailyPuzzles(Day day) => [
      for (final t in dailyGames(day))
        for (final d in t.difficulties) (type: t, difficulty: d),
    ];

GenParams dailyParams(Day day, PuzzleType type, Difficulty difficulty) => GenParams(
      size: type.dailySize(difficulty),
      difficulty: difficulty,
      seed: dailySeed(day),
      options: type.resolveOptions(const {}),
    );

/// Whether [code] is one of [day]'s puzzles and [day] is playable.
bool isDailyPuzzle(Day day, PuzzleCode code, {Day? today}) =>
    dailyLaunch <= day &&
    day <= (today ?? Day.today()) &&
    dailyGames(day).contains(code.type) &&
    code.toString() == PuzzleCode.format(code.type, dailyParams(day, code.type, code.params.difficulty));

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
