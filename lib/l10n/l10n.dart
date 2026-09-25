import 'package:flutter/widgets.dart';

import 'app_localizations.dart';

export 'app_localizations.dart';

/// A text picked once the language is known (toasts and errors raised
/// outside the widget tree).
typedef Tr = String Function(AppLocalizations l);

extension L10nContext on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}

/// App languages (code → native name), in settings order.
const appLanguages = {'en': 'English', 'uk': 'Українська', 'pl': 'Polski', 'de': 'Deutsch'};

/// The app locale for the user's [preferred] locales: the first supported
/// language wins, Russian falls back to Ukrainian, anything else to English.
Locale resolveAppLocale(Iterable<Locale>? preferred) {
  for (final l in preferred ?? const <Locale>[]) {
    if (appLanguages.containsKey(l.languageCode)) return Locale(l.languageCode);
    if (l.languageCode == 'ru') return const Locale('uk');
  }
  return const Locale('en');
}

/// Tooltip name of a palette value ([ValueSpec.label] is a key for
/// non-text values, and the text itself for text ones).
String valueName(AppLocalizations l, String key) => switch (key) {
      'sun' => l.valueSun,
      'moon' => l.valueMoon,
      'dot' => l.valueDot,
      'crown' => l.valueCrown,
      'shade' => l.valueShade,
      'grass' => l.valueGrass,
      'tent' => l.valueTent,
      'sea' => l.valueSea,
      'lamp' => l.valueLamp,
      'blue' => l.colorBlue,
      'pink' => l.colorPink,
      'yellow' => l.colorYellow,
      'green' => l.colorGreen,
      _ => key,
    };
