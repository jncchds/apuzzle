import 'package:flutter/material.dart';

import '../core/release_notes.dart';
import '../l10n/l10n.dart';

/// RELEASE_NOTES.md, newest release first.
class ReleaseNotesScreen extends StatelessWidget {
  const ReleaseNotesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.releaseNotes)),
      body: FutureBuilder<String>(
        future: DefaultAssetBundle.of(context).loadString(releaseNotesAsset),
        builder: (context, snapshot) {
          final text = snapshot.data;
          if (text == null) return const Center(child: CircularProgressIndicator());
          final releases = parseReleaseNotes(text);
          return ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            itemCount: releases.length,
            itemBuilder: (context, i) {
              final r = releases[i];
              return Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text.rich(
                      TextSpan(
                        text: r.version,
                        style: theme.textTheme.titleMedium,
                        children: [
                          TextSpan(
                            text: '  ${r.date}',
                            style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 4),
                    for (final note in r.notes)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('•  '),
                            Expanded(child: Text(note)),
                          ],
                        ),
                      ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
