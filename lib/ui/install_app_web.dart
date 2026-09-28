import 'dart:js_interop';

import 'package:flutter/foundation.dart';

import 'install_app.dart';

// Defined in web/index.html.
@JS('apuzzleInstallState')
external JSString? _state();

@JS('apuzzleInstall')
external JSPromise<JSBoolean> _install();

@JS('apuzzleInstallChanged')
external set _onChanged(JSFunction? f);

InstallMode _read() {
  try {
    return switch (_state()?.toDart) {
      'prompt' => InstallMode.prompt,
      'ios' => InstallMode.ios,
      _ => InstallMode.none,
    };
  } catch (_) {
    return InstallMode.none; // an old cached index.html without the hook
  }
}

ValueNotifier<InstallMode> createInstallNotifier() {
  final notifier = ValueNotifier(_read());
  _onChanged = () {
    notifier.value = _read();
  }.toJS;
  return notifier;
}

Future<bool> promptInstall() async {
  try {
    return (await _install().toDart).toDart;
  } catch (_) {
    return false;
  }
}
