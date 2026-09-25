// Pop "clear the board" generation timings per size and difficulty.
//
//   flutter test test/bench/pop_probe_test.dart --run-skipped --tags bench -r expanded
@Tags(['bench'])
library;

import 'package:apuzzle/core/difficulty.dart';
import 'package:apuzzle/puzzles/pop/pop_type.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('pop clear timings', () {
    const type = PopType();
    for (final size in type.sizes) {
      for (final d in type.difficulties) {
        final times = <int>[];
        for (var seed = 1; seed <= 10; seed++) {
          final sw = Stopwatch()..start();
          type.generate(GenParams(size: size, difficulty: d, seed: seed, options: const {'mode': 'std', 'goal': 'clear'}));
          times.add(sw.elapsedMilliseconds);
        }
        times.sort();
        // ignore: avoid_print
        print('${size.label} ${d.name}: median ${times[5]}ms max ${times.last}ms');
      }
    }
  });
}
