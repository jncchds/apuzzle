// Times every type's daily puzzles for a few days.
//   flutter test test/bench/daily_probe_test.dart --run-skipped --tags bench -r expanded
@Tags(['bench'])
library;

import 'package:apuzzle/core/daily.dart';
import 'package:apuzzle/core/registry.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('daily generation times', () {
    for (final type in puzzleTypes) {
      for (final d in type.difficulties) {
        final times = <int>[];
        for (var i = 0; i < 5; i++) {
          final sw = Stopwatch()..start();
          type.generate(dailyParams(dailyLaunch.addDays(i), type, d));
          times.add(sw.elapsedMilliseconds);
        }
        times.sort();
        // ignore: avoid_print
        print('${type.id.padRight(10)} ${d.name.padRight(7)} ${type.dailySize(d).label.padRight(6)} median ${times[2]} ms, max ${times.last} ms');
      }
    }
  });
}
