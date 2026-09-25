import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'day.dart';
import 'difficulty.dart';

class PuzzleStats {
  const PuzzleStats({this.solved = 0, this.bestMs, this.totalMs = 0, this.bestScore});

  final int solved;
  final int? bestMs;
  final int totalMs;

  /// Only for score-based games.
  final int? bestScore;

  Duration? get best => bestMs == null ? null : Duration(milliseconds: bestMs!);
  Duration? get average => solved == 0 ? null : Duration(milliseconds: totalMs ~/ solved);

  Map<String, dynamic> toJson() =>
      {'solved': solved, 'best': bestMs, 'total': totalMs, if (bestScore != null) 'bestScore': bestScore};

  factory PuzzleStats.fromJson(Map<String, dynamic> j) => PuzzleStats(
        solved: j['solved'] as int? ?? 0,
        bestMs: j['best'] as int?,
        totalMs: j['total'] as int? ?? 0,
        bestScore: j['bestScore'] as int?,
      );
}

/// A solved daily puzzle.
class DailyResult {
  const DailyResult({required this.code, required this.bestMs, this.hints = 0});

  final String code;

  /// Best time on this puzzle.
  final int bestMs;

  /// Hints used in that best solve.
  final int hints;

  Duration get best => Duration(milliseconds: bestMs);

  Map<String, dynamic> toJson() => {'code': code, 'ms': bestMs, if (hints > 0) 'hints': hints};

  factory DailyResult.fromJson(Map<String, dynamic> j) =>
      DailyResult(code: j['code'] as String, bestMs: j['ms'] as int, hints: j['hints'] as int? ?? 0);
}

/// Saved games, stats, daily results and small per-type preferences.
class GameStore {
  GameStore(this.prefs);

  final SharedPreferences prefs;

  static Future<GameStore> open() async => GameStore(await SharedPreferences.getInstance());

  /// Bumped when a daily result is recorded, so screens can refresh.
  final ValueNotifier<int> dailyRevision = ValueNotifier(0);

  String _saveKey(String slot) => 'save.$slot';
  String _statsKey(String typeId, String variant) => 'stats.$typeId.$variant';
  String _lastKey(String typeId) => 'last.$typeId';
  String _dailyKey(Day day) => 'daily.$day';

  /// The save slot of a daily puzzle, apart from the type's free game.
  static String dailySlot(String code) => 'daily.$code';

  /// Saves live in slots: a type id for the free game, or a [dailySlot].
  bool hasSave(String slot) => prefs.containsKey(_saveKey(slot));

  Map<String, dynamic>? readSave(String slot) => _readJson(_saveKey(slot));

  Future<void> writeSave(String slot, Map<String, dynamic> data) => prefs.setString(_saveKey(slot), jsonEncode(data));

  Future<void> clearSave(String slot) => prefs.remove(_saveKey(slot));

  /// Solved puzzles of [day], by [dailyEntry].
  Map<String, DailyResult> dailyResults(Day day) {
    final j = _readJson(_dailyKey(day)) ?? const {};
    return {
      for (final e in j.entries)
        if (e.value is Map<String, dynamic>) e.key: DailyResult.fromJson(e.value as Map<String, dynamic>),
    };
  }

  static String dailyEntry(String typeId, Difficulty difficulty) => '$typeId.${difficulty.name}';

  /// Records a solve of one of [day]'s puzzles, keeping the best time.
  Future<void> recordDaily(Day day, String typeId, Difficulty difficulty, String code, Duration time, int hints) async {
    final results = dailyResults(day);
    final key = dailyEntry(typeId, difficulty);
    final old = results[key];
    if (old == null || time.inMilliseconds < old.bestMs) {
      results[key] = DailyResult(code: code, bestMs: time.inMilliseconds, hints: hints);
      await prefs.setString(_dailyKey(day), jsonEncode({for (final e in results.entries) e.key: e.value.toJson()}));
    }
    dailyRevision.value++;
  }

  /// Stats for one [GenParams.variant] (difficulty plus options).
  PuzzleStats stats(String typeId, String variant) {
    final j = _readJson(_statsKey(typeId, variant));
    return j == null ? const PuzzleStats() : PuzzleStats.fromJson(j);
  }

  Future<PuzzleStats> recordWin(String typeId, String variant, Duration time, {int? score}) async {
    final s = stats(typeId, variant);
    final ms = time.inMilliseconds;
    final next = PuzzleStats(
      solved: s.solved + 1,
      bestMs: s.bestMs == null || ms < s.bestMs! ? ms : s.bestMs,
      totalMs: s.totalMs + ms,
      bestScore: score == null ? s.bestScore : (s.bestScore == null || score > s.bestScore! ? score : s.bestScore),
    );
    await prefs.setString(_statsKey(typeId, variant), jsonEncode(next.toJson()));
    return next;
  }

  /// Last chosen size/difficulty/options for the new-game sheet.
  Map<String, dynamic>? lastChoice(String typeId) => _readJson(_lastKey(typeId));
  Future<void> setLastChoice(String typeId, Map<String, dynamic> j) => prefs.setString(_lastKey(typeId), jsonEncode(j));

  Map<String, dynamic>? _readJson(String key) {
    final s = prefs.getString(key);
    if (s == null) return null;
    try {
      return jsonDecode(s) as Map<String, dynamic>;
    } catch (_) {
      return null;
    }
  }
}
