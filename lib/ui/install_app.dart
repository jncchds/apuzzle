import 'package:flutter/material.dart';

import '../l10n/l10n.dart';
import 'install_app_stub.dart' if (dart.library.js_interop) 'install_app_web.dart' as impl;

/// How the web version can be installed as an app, if at all.
enum InstallMode {
  /// Not on the web, already installed, or the browser offers no way.
  none,

  /// The browser can show its install dialog (Chrome, Edge, Samsung Internet).
  prompt,

  /// iOS: no API, the user adds it via Share → Add to Home Screen.
  ios,
}

/// Current install mode; changes when the browser allows or completes an install.
final ValueNotifier<InstallMode> installMode = impl.createInstallNotifier();

/// Settings tile, shown only while installing is possible.
class InstallAppTile extends StatelessWidget {
  const InstallAppTile({super.key});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return ValueListenableBuilder(
      valueListenable: installMode,
      builder: (context, mode, _) => mode == InstallMode.none
          ? const SizedBox.shrink()
          : ListTile(
              leading: const Icon(Icons.install_mobile),
              title: Text(l.installApp),
              // iOS has no install API: the instructions stay inline, no dialog.
              subtitle: Text(mode == InstallMode.ios ? l.installAppIos : l.installAppHint),
              onTap: mode == InstallMode.prompt ? impl.promptInstall : null,
            ),
    );
  }
}

/// App bar button, shown only while the browser can install (not on iOS,
/// where the Settings tile explains how).
class InstallAppButton extends StatelessWidget {
  const InstallAppButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: installMode,
      builder: (context, mode, _) => mode != InstallMode.prompt
          ? const SizedBox.shrink()
          : IconButton(
              icon: const Icon(Icons.install_mobile),
              tooltip: context.l10n.installApp,
              onPressed: impl.promptInstall,
            ),
    );
  }
}
