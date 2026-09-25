import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

const repoUrl = 'https://github.com/jncchds/apuzzle';

/// A small accent-tinted `v1.2.3` pill that opens the GitHub repo, shown next
/// to the app name (same look as the version pill in the other A* apps). The
/// version is whatever the build was given via `--build-name`.
class VersionPill extends StatefulWidget {
  const VersionPill({super.key});

  @override
  State<VersionPill> createState() => _VersionPillState();
}

class _VersionPillState extends State<VersionPill> {
  static final Future<PackageInfo> _info = PackageInfo.fromPlatform();
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return FutureBuilder<PackageInfo>(
      future: _info,
      builder: (context, snap) {
        final version = snap.data?.version ?? '';
        if (version.isEmpty) return const SizedBox.shrink();
        return Tooltip(
          message: repoUrl,
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            onEnter: (_) => setState(() => _hover = true),
            onExit: (_) => setState(() => _hover = false),
            child: GestureDetector(
              onTap: () => launchUrl(Uri.parse(repoUrl), mode: LaunchMode.externalApplication),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 120),
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 1),
                decoration: BoxDecoration(
                  color: scheme.primary.withValues(alpha: _hover ? 0.28 : 0.15),
                  border: Border.all(color: scheme.primary.withValues(alpha: 0.25)),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  'v$version',
                  style: TextStyle(
                    fontSize: 11,
                    height: 1.4,
                    fontWeight: FontWeight.w500,
                    color: _hover ? scheme.primary : scheme.onSurfaceVariant,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
