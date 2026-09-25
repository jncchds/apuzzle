import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../core/settings.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final s = context.watch<Settings>();
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('Highlight errors while playing'),
            subtitle: const Text('Off: mistakes are only shown when you press Submit'),
            value: s.highlightErrors,
            onChanged: (v) => s.highlightErrors = v,
          ),
          SwitchListTile(
            title: const Text('Auto-remove pencil marks'),
            subtitle: const Text('Placing a number clears that note from its row, column and box'),
            value: s.autoClearMarks,
            onChanged: (v) => s.autoClearMarks = v,
          ),
          SwitchListTile(
            title: const Text('Haptic feedback'),
            value: s.haptics,
            onChanged: (v) => s.haptics = v,
          ),
          ListTile(
            title: const Text('Theme'),
            trailing: SegmentedButton<ThemeMode>(
              segments: const [
                ButtonSegment(value: ThemeMode.system, icon: Icon(Icons.brightness_auto_outlined)),
                ButtonSegment(value: ThemeMode.light, icon: Icon(Icons.light_mode_outlined)),
                ButtonSegment(value: ThemeMode.dark, icon: Icon(Icons.dark_mode_outlined)),
              ],
              selected: {s.themeMode},
              showSelectedIcon: false,
              onSelectionChanged: (v) => s.themeMode = v.first,
            ),
          ),
          if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) const _LinksTile(),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('About & licenses'),
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
        const SnackBar(content: Text('Could not open the system settings')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final subtitle = switch (_handled) {
      true => 'Shared puzzle links open in APuzzle',
      false => 'Off: tap, then add jncchds.github.io under "Open supported links"',
      null => 'Choose APuzzle for jncchds.github.io links',
    };
    return ListTile(
      leading: Icon(_handled == true ? Icons.link : Icons.link_off),
      title: const Text('Open puzzle links in the app'),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.open_in_new),
      onTap: _open,
    );
  }
}
