import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'persistence.dart';

/// Moving progress between devices: [GameStore.exportProgress] packs stats,
/// daily results, saved games and tutorial marks into a text code, and
/// [GameStore.importProgress] merges such a code into this device, so the
/// best of both is kept.
///
/// The code is scrambled with a fixed key. It is no secret (it is right
/// here), just enough that editing your best times takes more than a text
/// editor.
class ProgressCode {
  static const _prefix = 'APUZZLE1:';
  static const _key = 0x5A17C0DE;

  /// The text form of [data], with a random [nonce] unless given.
  static String encode(Map<String, dynamic> data, {int? nonce}) {
    final plain = utf8.encode(jsonEncode(data));
    final r = Random.secure();
    // Two halves: the web can't draw 32 bits at once.
    final n = (nonce ?? r.nextInt(1 << 16) << 16 | r.nextInt(1 << 16)) & 0xFFFFFFFF;
    final out = Uint8List(4 + plain.length + 4);
    _put32(out, 0, n);
    _put32(out, 4 + plain.length, _checksum(plain));
    out.setRange(4, 4 + plain.length, plain);
    _scramble(out, n);
    return '$_prefix${base64Url.encode(out)}';
  }

  /// The data of a code from [encode], or null if [text] isn't one (or was
  /// damaged). Whitespace is ignored, since chat apps like to wrap it.
  static Map<String, dynamic>? decode(String text) {
    final t = text.replaceAll(RegExp(r'\s'), '');
    if (!t.startsWith(_prefix)) return null;
    try {
      final bytes = base64Url.decode(base64Url.normalize(t.substring(_prefix.length)));
      if (bytes.length < 8) return null;
      final n = _get32(bytes, 0);
      _scramble(bytes, n);
      final plain = Uint8List.sublistView(bytes, 4, bytes.length - 4);
      if (_get32(bytes, bytes.length - 4) != _checksum(plain)) return null;
      final j = jsonDecode(utf8.decode(plain));
      return j is Map<String, dynamic> ? j : null;
    } on FormatException {
      return null;
    }
  }

  /// XORs everything after the nonce with an xorshift32 stream. Every step
  /// is masked to 32 bits, so native and web agree.
  static void _scramble(Uint8List b, int nonce) {
    var x = (nonce ^ _key) & 0xFFFFFFFF;
    if (x == 0) x = _key;
    for (var i = 4; i < b.length; i++) {
      x = (x ^ (x << 13)) & 0xFFFFFFFF;
      x ^= x >>> 17;
      x = (x ^ (x << 5)) & 0xFFFFFFFF;
      b[i] ^= x & 0xFF;
    }
  }

  static int _checksum(List<int> bytes) {
    var h = 0x811C9DC5;
    for (final c in bytes) {
      h ^= c;
      h = (h ^ (h << 7)) & 0xFFFFFFFF;
      h ^= h >>> 9;
      h = (h ^ (h << 8)) & 0xFFFFFFFF;
    }
    return h;
  }

  static void _put32(Uint8List b, int at, int v) {
    for (var i = 0; i < 4; i++) {
      b[at + i] = (v >>> (8 * i)) & 0xFF;
    }
  }

  static int _get32(Uint8List b, int at) => b[at] | b[at + 1] << 8 | b[at + 2] << 16 | (b[at + 3] << 24 & 0xFFFFFFFF);
}

extension ProgressTransfer on GameStore {
  /// Preference keys that travel between devices. Settings stay, since they
  /// are usually about the device (theme, haptics, language).
  static const _prefixes = ['stats.', 'daily.', 'save.', 'tutorial.', 'strategies.', 'last.'];

  static bool _travels(String key) => _prefixes.any(key.startsWith);

  /// All progress of this device, for [ProgressCode.encode].
  Map<String, dynamic> exportProgress() {
    final data = <String, dynamic>{};
    for (final k in prefs.getKeys()) {
      if (!_travels(k)) continue;
      final v = prefs.get(k);
      // Old stats get their device ids, so the other device can merge them.
      data[k] = k.startsWith('stats.') && v is String ? _statsJson(v, deviceId) : v;
    }
    return {'v': 1, 'device': deviceId, 'data': data};
  }

  /// Merges [export] (from another device's [exportProgress]) into this one
  /// and returns how many entries changed. Best times, win counts, daily
  /// results and tutorial marks keep the best of both; a saved game is
  /// taken if it is newer than the one here. Throws [FormatException] if
  /// [export] is not progress data.
  Future<int> importProgress(Map<String, dynamic> export) async {
    final data = export['data'];
    final from = export['device'];
    if (export['v'] != 1 || data is! Map<String, dynamic> || from is! String) {
      throw const FormatException('not progress data');
    }
    var changed = 0;
    Future<void> put(String k, Object v) async {
      if (v is bool) {
        await prefs.setBool(k, v);
      } else {
        await prefs.setString(k, v as String);
      }
      changed++;
    }

    // Daily results first: a daily save is dropped if that puzzle is solved.
    final keys = data.keys.where(_travels).toList()
      ..sort((a, b) => (a.startsWith('save.') ? 1 : 0) - (b.startsWith('save.') ? 1 : 0));
    for (final k in keys) {
      final v = data[k];
      final local = prefs.get(k);
      if (v is! String && v is! bool) continue;
      final Object? merged;
      try {
        merged = switch (k) {
          _ when local == null => k.startsWith('save.') && _solvedDaily(k) ? null : _imported(k, v, from),
          _ when local == v => null,
          _ when k.startsWith('stats.') => _mergeStats(local as String, v as String, from),
          _ when k.startsWith('daily.') => _mergeDaily(local as String, v as String),
          _ when k.startsWith('save.') => _newer(local as String, v as String),
          _ when k.startsWith('tutorial.') => v == 'done' ? v : null,
          _ when k.startsWith('strategies.') => v == true ? v : null,
          _ => null, // last choices: this device's own win
        };
      } on Object {
        continue; // a damaged entry
      }
      if (merged != null && merged != local) await put(k, merged);
    }
    dailyRevision.value++;
    tutorialRevision.value++;
    return changed;
  }

  Object _imported(String k, Object v, String from) => k.startsWith('stats.') ? _statsJson(v as String, from) : v;

  String _statsJson(String s, String device) =>
      jsonEncode(PuzzleStats.fromJson(jsonDecode(s) as Map<String, dynamic>, device: device).toJson());

  String _mergeStats(String local, String other, String from) {
    final a = PuzzleStats.fromJson(jsonDecode(local) as Map<String, dynamic>, device: deviceId);
    final b = PuzzleStats.fromJson(jsonDecode(other) as Map<String, dynamic>, device: from);
    return jsonEncode(a.merge(b).toJson());
  }

  String? _mergeDaily(String local, String other) {
    final a = jsonDecode(local) as Map<String, dynamic>;
    final b = jsonDecode(other) as Map<String, dynamic>;
    var changed = false;
    for (final e in b.entries) {
      final mine = a[e.key];
      if (e.value is! Map<String, dynamic>) continue;
      final theirs = DailyResult.fromJson(e.value as Map<String, dynamic>);
      if (mine is! Map<String, dynamic> || theirs.bestMs < DailyResult.fromJson(mine).bestMs) {
        a[e.key] = e.value;
        changed = true;
      }
    }
    return changed ? jsonEncode(a) : null;
  }

  String? _newer(String local, String other) {
    int at(String s) => (jsonDecode(s) as Map<String, dynamic>)['at'] as int? ?? 0;
    return at(other) > at(local) ? other : null;
  }

  /// Whether [saveKey] is a daily save whose puzzle is already solved here.
  bool _solvedDaily(String saveKey) {
    final slot = saveKey.substring('save.'.length);
    if (!slot.startsWith('daily.')) return false;
    final code = slot.substring('daily.'.length);
    return prefs.getKeys().any((k) => k.startsWith('daily.') && (prefs.getString(k)?.contains('"$code"') ?? false));
  }
}
