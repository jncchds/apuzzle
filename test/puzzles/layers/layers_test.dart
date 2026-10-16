import 'package:apuzzle/core/difficulty.dart';
import 'package:apuzzle/core/grid.dart';
import 'package:apuzzle/puzzles/layers/layers_generator.dart';
import 'package:apuzzle/puzzles/layers/layers_model.dart';
import 'package:apuzzle/puzzles/layers/layers_solver.dart';
import 'package:apuzzle/puzzles/layers/layers_tutorial.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/timing.dart';

void main() {
  test('conflicts: a foreign color, a hidden line in two colors, a cycle', () {
    // Rows a, a; columns b, b: every cell says which line came last.
    final p = layersBoard('aa/bb', 'ab|ab');
    expect(layersConflicts(p, [0, 0, 1, 1]), isEmpty);
    expect(layersConflicts(p, [0, -1, -1, -1]), isEmpty);
    // Row 1 after A, B after row 1, A after row 2, row 2 after B: a circle.
    expect(layersConflicts(p, [0, 1, 1, 0]), {0, 1, 2, 3});
    // A color neither line has.
    expect(layersConflicts(layersBoard('ab/ab', 'ab|ab'), [2, -1, -1, -1]), {0});
    // Row 1 hides its color but comes last in two colors.
    final hidden = layersBoard('Aa/bc', 'aa|aa');
    expect(layersConflicts(hidden, [0, 1, -1, -1]), {0, 1});
  });

  test('solver: same color, rectangle, chain', () {
    final p = layersBoard('aba/bab', 'Aaa|bBb|BaA');
    final s = LayersSolver(p);
    final k = s.start();
    expect(s.propagate(k, 1), isTrue);
    // C1 by the rectangle A1, A3, C3.
    expect(LayersSolver.colorOf(k[2]), 0);
    expect(s.grade(s.start()), 1);
    expect(s.countSolutions(s.start()), 1);
  });

  test('tutorial boards are valid pictures', () {
    for (final step in [...layersTutorial, ...layersStrategies]) {
      final p = step.puzzle as LayersPuzzle;
      expect(LayersSolver(p).valid(p.picture), isTrue);
    }
  });

  for (final n in [5, 6, 7, 8, 9, 10]) {
    for (final d in [Difficulty.easy, Difficulty.medium, Difficulty.hard]) {
      test('layers ${n}x$n ${d.name}: valid, unique, tiered, deterministic', () {
        final info = <String>[];
        final tier = layersTier(d);
        for (var seed = 1; seed <= 4; seed++) {
          final params = GenParams(size: GridSize.square(n), difficulty: d, seed: seed);
          final sw = Stopwatch()..start();
          final p = generateLayers(params);
          sw.stop();
          final s = LayersSolver(p);
          expect(s.valid(p.picture), isTrue);
          expect(layersConflicts(p, p.picture), isEmpty);
          final k = s.start();
          final grade = s.grade(k);
          expect(grade, lessThanOrEqualTo(tier));
          expect(s.solve(k, tier), isTrue);
          for (var i = 0; i < p.cells; i++) {
            if (!p.isHole(i)) expect(LayersSolver.colorOf(k[i]), p.picture[i]);
          }
          expect(s.countSolutions(s.start()), 1);
          if (seed == 1) expect(generateLayers(params).toJson(), p.toJson(), reason: 'not deterministic');
          expect(LayersPuzzle.fromJson(p.toJson()).toJson(), p.toJson());
          expect(sw.elapsedMilliseconds, lessThan(timeLimit(3000)));
          info.add('${sw.elapsedMilliseconds}ms grade $grade givens ${p.givens.length} hidden ${p.hidden.length}');
        }
        // ignore: avoid_print
        print('layers $n ${d.name}: $info');
      });
    }
  }
}
