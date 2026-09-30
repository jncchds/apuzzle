import 'dart:io';

import 'package:apuzzle/core/release_notes.dart';
import 'package:apuzzle/ui/app_router.dart';
import 'package:flutter_test/flutter_test.dart';

List<int> _parts(String version) => version.split('.').map(int.parse).toList();

int _compare(String a, String b) {
  final x = _parts(a), y = _parts(b);
  for (var i = 0; i < 3; i++) {
    if (x[i] != y[i]) return x[i].compareTo(y[i]);
  }
  return 0;
}

void main() {
  test('parses headers and notes', () {
    final r = parseReleaseNotes(
      '# Release notes\n\n## 1.2.0 - 2026-10-01\n- one\n- two\n\n## 1.1.0 - 2026-09-01\n- three\n',
    );
    expect(r.map((e) => e.version), ['1.2.0', '1.1.0']);
    expect(r.first.date, '2026-10-01');
    expect(r.first.notes, ['one', 'two']);
    expect(r.last.notes, ['three']);
  });

  test('RELEASE_NOTES.md is well formed, newest first', () {
    final releases = parseReleaseNotes(File(releaseNotesAsset).readAsStringSync());
    expect(releases, isNotEmpty);
    for (final r in releases) {
      expect(r.version, matches(RegExp(r'^\d+\.\d+\.\d+$')));
      expect(DateTime.tryParse(r.date), isNotNull, reason: r.version);
      expect(r.notes, isNotEmpty, reason: r.version);
    }
    for (var i = 1; i < releases.length; i++) {
      expect(_compare(releases[i - 1].version, releases[i].version), greaterThan(0));
      expect(releases[i - 1].date.compareTo(releases[i].date), greaterThanOrEqualTo(0));
    }
  });

  test('route', () {
    final route = AppRoute.parse(Uri.parse('/release-notes'));
    expect(route.releaseNotes, isTrue);
    expect(route.settings, isTrue);
    expect(route.uri.path, '/release-notes');
  });
}
