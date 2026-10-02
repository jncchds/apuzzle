import 'dart:convert';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'day.dart';
import 'difficulty.dart';

class PuzzleStats {
  const PuzzleStats({this.solved = 0, this.bestMs, this.totalMs = 0, this.bestScore, this.devices = const {}});

  /// Stats from per-device counts, with [solved] and [totalMs] their sums.
  factory PuzzleStats.of(Map<String, DeviceCount> devices, {int? bestMs, int? bestScore}) => PuzzleStats(
    solved: devices.values.fold(0, (a, d) => a + d.solved),
    totalMs: devices.values.fold(0, (a, d) => a + d.totalMs),
    bestMs: bestMs,
    bestScore: bestScore,
    devices: devices,
  );

  final int solved;
  final int? bestMs;
  final int totalMs;

  /// Only for score-based games.
  final int? bestScore;

  /// Wins and time by device id. Each device only ever grows its own count,
  /// so merging another device's progress (as often as you like) never
  /// counts a win twice.
  final Map<String, DeviceCount> devices;

  Duration? get best => bestMs == null ? null : Duration(milliseconds: bestMs!);
  Duration? get average => solved == 0 ? null : Duration(milliseconds: totalMs ~/ solved);

  /// Both stats together: every device's larger count, the better best.
  PuzzleStats merge(PuzzleStats o) => PuzzleStats.of(
    {
      for (final id in {...devices.keys, ...o.devices.keys})
        id: DeviceCount.max(devices[id] ?? const DeviceCount(), o.devices[id] ?? const DeviceCount()),
    },
    bestMs: _pick(bestMs, o.bestMs, (a, b) => a < b),
    bestScore: _pick(bestScore, o.bestScore, (a, b) => a > b),
  );

  static int? _pick(int? a, int? b, bool Function(int, int) better) =>
      a == null ? b : (b == null || better(a, b) ? a : b);

  Map<String, dynamic> toJson() => {
    'solved': solved,
    'best': bestMs,
    'total': totalMs,
    if (bestScore != null) 'bestScore': bestScore,
    'dev': {for (final e in devices.entries) e.key: e.value.toJson()},
  };

  /// [device] owns the counts of stats saved before they were kept per device.
  factory PuzzleStats.fromJson(Map<String, dynamic> j, {required String device}) {
    final solved = j['solved'] as int? ?? 0;
    final total = j['total'] as int? ?? 0;
    final dev = j['dev'];
    return PuzzleStats.of(
      dev is Map<String, dynamic>
          ? {
              for (final e in dev.entries)
                if (e.value is List) e.key: DeviceCount.fromJson(e.value as List),
            }
          : {if (solved > 0) device: DeviceCount(solved: solved, totalMs: total)},
      bestMs: j['best'] as int?,
      bestScore: j['bestScore'] as int?,
    );
  }
}

/// One device's share of [PuzzleStats].
class DeviceCount {
  const DeviceCount({this.solved = 0, this.totalMs = 0});

  final int solved;
  final int totalMs;

  static DeviceCount max(DeviceCount a, DeviceCount b) => DeviceCount(
    solved: a.solved > b.solved ? a.solved : b.solved,
    totalMs: a.totalMs > b.totalMs ? a.totalMs : b.totalMs,
  );

  List<int> toJson() => [solved, totalMs];

  factory DeviceCount.fromJson(List j) => DeviceCount(solved: j[0] as int, totalMs: j[1] as int);
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

  /// A random id for this install, which owns the wins played here
  /// ([PuzzleStats.devices]).
  late final String deviceId = prefs.getString(_deviceKey) ?? _newDeviceId();

  static const _deviceKey = 'device.id';

  String _newDeviceId() {
    final r = Random.secure();
    final id = List.generate(10, (_) => '0123456789abcdefghijklmnopqrstuvwxyz'[r.nextInt(36)]).join();
    prefs.setString(_deviceKey, id);
    return id;
  }

  static Future<GameStore> open() async => GameStore(await SharedPreferences.getInstance());

  /// Bumped when a daily result is recorded, so screens can refresh.
  final ValueNotifier<int> dailyRevision = ValueNotifier(0);

  /// Bumped when a tutorial's status changes.
  final ValueNotifier<int> tutorialRevision = ValueNotifier(0);

  String _saveKey(String slot) => 'save.$slot';
  String _statsKey(String typeId, String variant) => 'stats.$typeId.$variant';
  String _lastKey(String typeId) => 'last.$typeId';
  String _dailyKey(Day day) => 'daily.$day';

  /// The save slot of a daily puzzle, apart from the type's free game.
  static String dailySlot(String code) => 'daily.$code';

  /// Saves live in slots: a type id for the free game, or a [dailySlot].
  bool hasSave(String slot) => prefs.containsKey(_saveKey(slot));

  Map<String, dynamic>? readSave(String slot) => _readJson(_saveKey(slot));

  /// Stamps the save with the time ('at'), so the newer one wins when progress
  /// from another device is merged.
  Future<void> writeSave(String slot, Map<String, dynamic> data) =>
      prefs.setString(_saveKey(slot), jsonEncode({...data, 'at': DateTime.now().millisecondsSinceEpoch}));

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
    return j == null ? const PuzzleStats() : PuzzleStats.fromJson(j, device: deviceId);
  }

  Future<PuzzleStats> recordWin(String typeId, String variant, Duration time, {int? score}) async {
    final s = stats(typeId, variant);
    final ms = time.inMilliseconds;
    final own = s.devices[deviceId] ?? const DeviceCount();
    final next = s.merge(
      PuzzleStats(
        bestMs: ms,
        bestScore: score,
        devices: {deviceId: DeviceCount(solved: own.solved + 1, totalMs: own.totalMs + ms)},
      ),
    );
    await prefs.setString(_statsKey(typeId, variant), jsonEncode(next.toJson()));
    return next;
  }

  String _tutorialKey(String typeId) => 'tutorial.$typeId';

  /// Whether the tutorial of [typeId] was played to the end.
  bool tutorialDone(String typeId) => prefs.getString(_tutorialKey(typeId)) == 'done';

  /// Records that the tutorial was finished, or (unless it already was)
  /// turned down or left halfway, so it isn't offered again.
  Future<void> setTutorial(String typeId, {required bool done}) async {
    if (!done && prefs.containsKey(_tutorialKey(typeId))) return;
    await prefs.setString(_tutorialKey(typeId), done ? 'done' : 'skipped');
    tutorialRevision.value++;
  }

  String _strategiesKey(String typeId) => 'strategies.$typeId';

  /// Whether the strategy lessons of [typeId] were played to the end.
  bool strategiesDone(String typeId) => prefs.getBool(_strategiesKey(typeId)) ?? false;

  Future<void> setStrategiesDone(String typeId) async {
    await prefs.setBool(_strategiesKey(typeId), true);
    tutorialRevision.value++;
  }

  /// Whether the player already knows [typeId]: its tutorial was offered, or
  /// they have played it before.
  bool knowsGame(String typeId) =>
      prefs.containsKey(_tutorialKey(typeId)) ||
      hasSave(typeId) ||
      prefs.getKeys().any((k) => k.startsWith('stats.$typeId.'));

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
