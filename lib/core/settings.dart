import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Settings extends ChangeNotifier {
  Settings(this._prefs) {
    _highlightErrors = _prefs.getBool('set.highlightErrors') ?? false;
    _haptics = _prefs.getBool('set.haptics') ?? true;
    _themeMode = ThemeMode.values.asNameMap()[_prefs.getString('set.theme')] ?? ThemeMode.system;
  }

  final SharedPreferences _prefs;

  late bool _highlightErrors;
  late bool _haptics;
  late ThemeMode _themeMode;

  /// Show rule conflicts while playing (off by default: validation on submit).
  bool get highlightErrors => _highlightErrors;
  set highlightErrors(bool v) {
    _highlightErrors = v;
    _prefs.setBool('set.highlightErrors', v);
    notifyListeners();
  }

  bool get haptics => _haptics;
  set haptics(bool v) {
    _haptics = v;
    _prefs.setBool('set.haptics', v);
    notifyListeners();
  }

  ThemeMode get themeMode => _themeMode;
  set themeMode(ThemeMode v) {
    _themeMode = v;
    _prefs.setString('set.theme', v.name);
    notifyListeners();
  }
}
