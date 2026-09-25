import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

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

/// Saved games, stats and small per-type preferences.
class GameStore {
  GameStore(this.prefs);

  final SharedPreferences prefs;

  static Future<GameStore> open() async => GameStore(await SharedPreferences.getInstance());

  String _saveKey(String typeId) => 'save.$typeId';
  String _statsKey(String typeId, String variant) => 'stats.$typeId.$variant';
  String _lastKey(String typeId) => 'last.$typeId';

  bool hasSave(String typeId) => prefs.containsKey(_saveKey(typeId));

  Map<String, dynamic>? readSave(String typeId) => _readJson(_saveKey(typeId));

  Future<void> writeSave(String typeId, Map<String, dynamic> data) =>
      prefs.setString(_saveKey(typeId), jsonEncode(data));

  Future<void> clearSave(String typeId) => prefs.remove(_saveKey(typeId));

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
