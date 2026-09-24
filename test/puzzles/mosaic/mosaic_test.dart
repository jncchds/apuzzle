import 'package:apuzzle/core/difficulty.dart';
import 'package:apuzzle/core/grid.dart';
import 'package:apuzzle/puzzles/mosaic/mosaic_model.dart';
import 'package:apuzzle/puzzles/mosaic/mosaic_type.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const type = MosaicType();
  for (final n in [6, 12, 18]) {
    for (final d in [Difficulty.easy, Difficulty.medium, Difficulty.hard]) {
      test('mosaic ${n}x$n ${d.name}: plan solves within limit', () {
        for (var seed = 1; seed <= 3; seed++) {
          final params = GenParams(size: GridSize.square(n), difficulty: d, seed: seed);
          final sw = Stopwatch()..start();
          final p = type.generate(params);
          sw.stop();
          var s = type.initialState(p);
          for (final c in p.plan) {
            s = MosaicState(floodApply(s.cells, n, n, c), s.moves + 1);
          }
          expect(type.isSolved(p, s), isTrue);
          expect(p.plan.length, lessThanOrEqualTo(p.limit));
          expect(type.generate(params).toJson(), p.toJson());
          expect(sw.elapsedMilliseconds, lessThan(5000));
        }
      });
    }
  }

  test('hint advances toward a solution', () {
    final p = type.generate(const GenParams(size: GridSize.square(10), difficulty: Difficulty.medium, seed: 9));
    var s = type.initialState(p);
    var guard = 0;
    while (!type.isComplete(p, s) && guard++ < 200) {
      s = type.hint(p, s)!.state;
    }
    expect(type.isComplete(p, s), isTrue);
  });
}
