import 'package:apuzzle/core/difficulty.dart';
import 'package:apuzzle/core/grid.dart';
import 'package:apuzzle/puzzles/ripples/ripples_generator.dart';
import 'package:apuzzle/puzzles/ripples/ripples_model.dart';
import 'package:apuzzle/puzzles/ripples/ripples_solver.dart';
import 'package:apuzzle/puzzles/ripples/ripples_tutorial.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/timing.dart';

void main() {
  test('conflicts: region repeats, too big, equal numbers too close', () {
    // One row of two regions: A A | B B B.
    final regions = [0, 0, 1, 1, 1];
    expect(ripplesConflicts(1, 5, regions, [0, 1, 0, 2, 1]), isEmpty);
    // Two 1s side by side.
    expect(ripplesConflicts(1, 5, regions, [1, 0, 0, -1, -1]), {1, 2});
    // Two 2s one cell apart (need two between them).
    expect(ripplesConflicts(1, 5, regions, [1, 0, 1, -1, -1]), {0, 2});
    // A 3 in a region of two.
    expect(ripplesConflicts(1, 5, regions, [2, -1, -1, -1, -1]), {0});
    // Same value twice in a region.
    expect(ripplesConflicts(1, 5, regions, [-1, -1, 0, -1, 0]), {2, 4});
    // Columns count too: 1s one row apart.
    expect(ripplesConflicts(2, 1, [0, 1], [0, 0]), {0, 1});
  });

  test('strategy boards need their technique', () {
    for (final (params, tier) in [(ripplesPointingParams, 2), (ripplesProbeParams, 3)]) {
      final p = generateRipples(params);
      final s = RipplesSolver(p.rows, p.cols, p.regions);
      expect(s.solves(p.givens, tier - 1), isFalse, reason: '$params');
      expect(s.solves(p.givens, tier), isTrue, reason: '$params');
    }
  });

  for (final n in [5, 6, 8, 10]) {
    for (final d in [Difficulty.easy, Difficulty.medium, Difficulty.hard]) {
      test('ripples ${n}x$n ${d.name}: valid, unique, tiered, deterministic', () {
        final info = <String>[];
        final tier = switch (d) {
          Difficulty.easy => 1,
          Difficulty.medium => 2,
          _ => 3,
        };
        for (var seed = 1; seed <= 4; seed++) {
          final params = GenParams(size: GridSize.square(n), difficulty: d, seed: seed);
          final sw = Stopwatch()..start();
          final p = generateRipples(params);
          sw.stop();
          expect(ripplesConflicts(n, n, p.regions, p.solution), isEmpty);
          final sizes = p.regionSizeAt;
          for (var i = 0; i < n * n; i++) {
            expect(p.solution[i], lessThan(sizes[i]));
            if (p.givens[i] != null) expect(p.givens[i], p.solution[i]);
          }
          final s = RipplesSolver(n, n, p.regions);
          final c = s.start(p.givens)!;
          expect(s.solve(c, tier), isTrue);
          expect([for (final m in c) RipplesSolver.valueOf(m)], p.solution);
          expect(s.countSolutions(s.start(p.givens)!), 1);
          if (seed == 1) expect(generateRipples(params).toJson(), p.toJson());
          expect(RipplesPuzzle.fromJson(p.toJson()).toJson(), p.toJson());
          expect(sw.elapsedMilliseconds, lessThan(timeLimit(3000)));
          final lower = tier > 1 && s.solves(p.givens, tier - 1);
          info.add(
            '${sw.elapsedMilliseconds}ms givens ${p.givens.where((g) => g != null).length}'
            ' max ${p.maxRegion}${lower ? ' (easier)' : ''}',
          );
        }
        // ignore: avoid_print
        print('ripples $n ${d.name}: $info');
      });
    }
  }
}
