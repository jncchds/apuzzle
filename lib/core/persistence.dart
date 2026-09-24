import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'difficulty.dart';

class PuzzleStats {
  const PuzzleStats({this.solved = 0, this.bestMs, this.totalMs = 0});

  final int solved;
  final int? bestMs;
  final int totalMs;

  Duration? get best => bestMs == null ? null : Duration(milliseconds: bestMs!);
  Duration? get average => solved == 0 ? null : Duration(milliseconds: totalMs ~/ solved);

  Map<String, dynamic> toJson() => {'solved': solved, 'best': bestMs, 'total': totalMs};

  factory PuzzleStats.fromJson(Map<String, dynamic> j) =>
      PuzzleStats(solved: j['solved'] as int? ?? 0, bestMs: j['best'] as int?, totalMs: j['total'] as int? ?? 0);
}

/// Saved games, stats and small per-type preferences.
class GameStore {
  GameStore(this.prefs);

  final SharedPreferences prefs;

  static Future<GameStore> open() async => GameStore(await SharedPreferences.getInstance());

  String _saveKey(String typeId) => 'save.$typeId';
  String _statsKey(String typeId, Difficulty d) => 'stats.$typeId.${d.name}';
  String _lastKey(String typeId) => 'last.$typeId';

  bool hasSave(String typeId) => prefs.containsKey(_saveKey(typeId));

  Map<String, dynamic>? readSave(String typeId) => _readJson(_saveKey(typeId));

  Future<void> writeSave(String typeId, Map<String, dynamic> data) =>
      prefs.setString(_saveKey(typeId), jsonEncode(data));

  Future<void> clearSave(String typeId) => prefs.remove(_saveKey(typeId));

  PuzzleStats stats(String typeId, Difficulty d) {
    final j = _readJson(_statsKey(typeId, d));
    return j == null ? const PuzzleStats() : PuzzleStats.fromJson(j);
  }

  Future<PuzzleStats> recordWin(String typeId, Difficulty d, Duration time) async {
    final s = stats(typeId, d);
    final ms = time.inMilliseconds;
    final next = PuzzleStats(
      solved: s.solved + 1,
      bestMs: s.bestMs == null || ms < s.bestMs! ? ms : s.bestMs,
      totalMs: s.totalMs + ms,
    );
    await prefs.setString(_statsKey(typeId, d), jsonEncode(next.toJson()));
    return next;
  }

  /// Last chosen size/difficulty for the new-game sheet.
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
