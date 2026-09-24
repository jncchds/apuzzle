import 'package:apuzzle/core/difficulty.dart';
import 'package:apuzzle/core/grid.dart';
import 'package:apuzzle/puzzles/blend/blend_model.dart';
import 'package:apuzzle/puzzles/blend/blend_type.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const type = BlendType();

  test('repainting merges touching patches of the new color', () {
    // 0 1 0
    // 1 1 1
    // 0 1 0  → repaint the center patch (color 1) to 0 → one patch.
    final cells = [0, 1, 0, 1, 1, 1, 0, 1, 0];
    expect(blendComponents(cells, 3, 3).toSet().length, 5);
    final after = blendApply(cells, 3, 3, 4, 0);
    expect(blendDone(after), isTrue);
  });

  for (final n in [5, 8, 14]) {
    for (final d in [Difficulty.easy, Difficulty.medium, Difficulty.hard]) {
      test('blend ${n}x$n ${d.name}: plan solves within limit, deterministic, fast', () {
        for (var seed = 1; seed <= 3; seed++) {
          final params = GenParams(size: GridSize.square(n), difficulty: d, seed: seed);
          final sw = Stopwatch()..start();
          final p = type.generate(params);
          sw.stop();
          var s = type.initialState(p);
          for (final (cell, color) in p.plan) {
            s = BlendState(blendApply(s.cells, n, n, cell, color), s.moves + 1);
          }
          expect(type.isSolved(p, s), isTrue);
          expect(type.generate(params).toJson(), p.toJson());
          expect(sw.elapsedMilliseconds, lessThan(5000), reason: '${sw.elapsedMilliseconds}ms');
        }
      });
    }
  }

  test('hints finish the board', () {
    final p = type.generate(const GenParams(size: GridSize.square(8), difficulty: Difficulty.hard, seed: 4));
    var s = type.initialState(p);
    var guard = 0;
    while (!type.isComplete(p, s) && guard++ < 200) {
      s = type.hint(p, s)!.state;
    }
    expect(type.isComplete(p, s), isTrue);
  });
}
