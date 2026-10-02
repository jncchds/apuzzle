// Times every type's daily puzzles for a few days, and for types with explain
// mode the slowest explained step while solving them.
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
        var slowest = 0;
        for (var i = 0; i < 5; i++) {
          final sw = Stopwatch()..start();
          final puzzle = type.generate(dailyParams(dailyLaunch.addDays(i), type, d)) as Object;
          times.add(sw.elapsedMilliseconds);
          if (!type.canExplain) continue;
          var state = type.initialState(puzzle) as Object;
          while (true) {
            sw.reset();
            final e = type.explain(puzzle, state);
            if (sw.elapsedMilliseconds > slowest) slowest = sw.elapsedMilliseconds;
            if (e?.next == null) break;
            state = e!.next!;
          }
        }
        times.sort();
        // ignore: avoid_print
        print(
          '${type.id.padRight(10)} ${d.name.padRight(7)} ${type.dailySize(d).label.padRight(6)} median ${times[2]} ms, max ${times.last} ms'
          '${type.canExplain ? ', slowest explain step $slowest ms' : ''}',
        );
      }
    }
  });
}
