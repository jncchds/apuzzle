import 'package:flutter/material.dart';
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
