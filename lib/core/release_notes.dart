/// One release from RELEASE_NOTES.md: `## 0.1.0 - 2026-09-25` followed by
/// `- note` lines.
class Release {
  const Release(this.version, this.date, this.notes);

  final String version;
  final String date;
  final List<String> notes;
}

/// The asset bundled from the repository root.
const releaseNotesAsset = 'RELEASE_NOTES.md';

final _header = RegExp(r'^##\s+(\S+)\s+-\s+(\S+)\s*$');

/// Releases in file order (newest first). Other lines are ignored.
List<Release> parseReleaseNotes(String text) {
  final releases = <Release>[];
  for (final line in text.split('\n').map((l) => l.trimRight())) {
    if (_header.firstMatch(line) case final m?) {
      releases.add(Release(m[1]!, m[2]!, []));
    } else if (line.startsWith('- ') && releases.isNotEmpty) {
      releases.last.notes.add(line.substring(2).trim());
    }
  }
  return releases;
}
