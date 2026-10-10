import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Settings extends ChangeNotifier {
  Settings(this._prefs) {
    _highlightErrors = _prefs.getBool('set.highlightErrors') ?? false;
    _haptics = _prefs.getBool('set.haptics') ?? true;
    _autoClearMarks = _prefs.getBool('set.autoClearMarks') ?? false;
    _themeMode = ThemeMode.values.asNameMap()[_prefs.getString('set.theme')] ?? ThemeMode.system;
    _language = _prefs.getString('set.language');
    _collapsed = {...?_prefs.getStringList('set.collapsed')};
  }

  final SharedPreferences _prefs;

  late bool _highlightErrors;
  late bool _haptics;
  late bool _autoClearMarks;
  late ThemeMode _themeMode;
  String? _language;
  late Set<String> _collapsed;

  /// Show rule conflicts while playing (off by default: validation on submit).
  bool get highlightErrors => _highlightErrors;
  set highlightErrors(bool v) {
    _highlightErrors = v;
    _prefs.setBool('set.highlightErrors', v);
    notifyListeners();
  }

  /// Placing a number removes that pencil mark from its row/column/box.
  bool get autoClearMarks => _autoClearMarks;
  set autoClearMarks(bool v) {
    _autoClearMarks = v;
    _prefs.setBool('set.autoClearMarks', v);
    notifyListeners();
  }

  bool get haptics => _haptics;
  set haptics(bool v) {
    _haptics = v;
    _prefs.setBool('set.haptics', v);
    notifyListeners();
  }

  /// App language code (see [appLanguages]), or null to follow the system.
  String? get language => _language;
  set language(String? v) {
    _language = v;
    v == null ? _prefs.remove('set.language') : _prefs.setString('set.language', v);
    notifyListeners();
  }

  ThemeMode get themeMode => _themeMode;
  set themeMode(ThemeMode v) {
    _themeMode = v;
    _prefs.setString('set.theme', v.name);
    notifyListeners();
  }

  /// Whether the home screen's game group [id] is folded away.
  bool isCollapsed(String id) => _collapsed.contains(id);
  void toggleCollapsed(String id) {
    if (!_collapsed.remove(id)) _collapsed.add(id);
    _prefs.setStringList('set.collapsed', _collapsed.toList());
    notifyListeners();
  }
}
