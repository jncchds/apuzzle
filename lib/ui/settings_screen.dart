import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../core/puzzle_code.dart';
import '../core/settings.dart';
import '../l10n/l10n.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final s = context.watch<Settings>();
    final l = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l.settings)),
      body: ListView(
        children: [
          SwitchListTile(
            title: Text(l.highlightErrors),
            subtitle: Text(l.highlightErrorsHint),
            value: s.highlightErrors,
            onChanged: (v) => s.highlightErrors = v,
          ),
          SwitchListTile(
            title: Text(l.autoClearMarks),
            subtitle: Text(l.autoClearMarksHint),
            value: s.autoClearMarks,
            onChanged: (v) => s.autoClearMarks = v,
          ),
          SwitchListTile(
            title: Text(l.haptics),
            value: s.haptics,
            onChanged: (v) => s.haptics = v,
          ),
          ListTile(
            title: Text(l.theme),
            trailing: SegmentedButton<ThemeMode>(
              segments: [
                ButtonSegment(value: ThemeMode.system, icon: const Icon(Icons.brightness_auto_outlined), tooltip: l.themeSystem),
                ButtonSegment(value: ThemeMode.light, icon: const Icon(Icons.light_mode_outlined), tooltip: l.themeLight),
                ButtonSegment(value: ThemeMode.dark, icon: const Icon(Icons.dark_mode_outlined), tooltip: l.themeDark),
              ],
              selected: {s.themeMode},
              showSelectedIcon: false,
              onSelectionChanged: (v) => s.themeMode = v.first,
            ),
          ),
          ListTile(
            title: Text(l.language),
            trailing: DropdownButton<String?>(
              value: s.language,
              underline: const SizedBox.shrink(),
              items: [
                DropdownMenuItem(value: null, child: Text(l.languageSystem)),
                for (final e in appLanguages.entries) DropdownMenuItem(value: e.key, child: Text(e.value)),
              ],
              onChanged: (v) => s.language = v,
            ),
          ),
          if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) const _LinksTile(),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: Text(l.aboutLicenses),
            onTap: () => showLicensePage(context: context, applicationName: 'APuzzle'),
          ),
        ],
      ),
    );
  }
}

/// Android: shows whether share links open in the app and jumps to the
/// system "Open by default" screen. Refreshes when the user comes back.
class _LinksTile extends StatefulWidget {
  const _LinksTile();

  @override
  State<_LinksTile> createState() => _LinksTileState();
}

class _LinksTileState extends State<_LinksTile> with WidgetsBindingObserver {
  static const _channel = MethodChannel('apuzzle/links');

  /// Whether links open in the app; null before Android 12 or on error.
  bool? _handled;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _refresh();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) _refresh();
  }

  Future<void> _refresh() async {
    bool? handled;
    try {
      handled = await _channel.invokeMethod<bool>('status');
    } on PlatformException {
      handled = null;
    }
    if (mounted) setState(() => _handled = handled);
  }

  Future<void> _open() async {
    bool ok;
    try {
      ok = await _channel.invokeMethod<bool>('openSettings') ?? false;
    } on PlatformException {
      ok = false;
    }
    if (!ok && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.couldNotOpenSettings)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final host = Uri.parse(PuzzleCode.linkBase).host;
    final subtitle = switch (_handled) {
      true => l.linksOn,
      false => l.linksOff(host),
      null => l.linksUnknown(host),
    };
    return ListTile(
      leading: Icon(_handled == true ? Icons.link : Icons.link_off),
      title: Text(l.linksTitle),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.open_in_new),
      onTap: _open,
    );
  }
}
