import 'package:apuzzle/core/difficulty.dart';
import 'package:apuzzle/core/explain.dart';
import 'package:apuzzle/core/grid.dart';
import 'package:apuzzle/puzzles/pockets/pockets_generator.dart';
import 'package:apuzzle/puzzles/pockets/pockets_model.dart';
import 'package:apuzzle/puzzles/pockets/pockets_solver.dart';
import 'package:apuzzle/puzzles/pockets/pockets_tutorial.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/timing.dart';

/// The rule of the first deduction tier 2 adds once tier 1 is stuck, and
/// the area it is about.
(PocketsRule, PocketsArea?) _firstTier2(PocketsPuzzle p) {
  final s = PocketsSolver(p);
  final c = s.start();
  s.propagate(c, 1);
  final t = ExplainTrace();
  s.propagate(c, 2, t);
  for (final f in t.facts) {
    final rule = PocketsRule.values[f.rule];
    if (rule == PocketsRule.ruledOut || rule == PocketsRule.naked || rule == PocketsRule.hidden) continue;
    final onArea = rule == PocketsRule.combo || rule == PocketsRule.must || rule == PocketsRule.fill;
    final area = onArea ? s.areas[f.args[0]] : null;
    if (area != null && area.pocket >= 0 && rule != PocketsRule.fill) continue;
    return (rule, area);
  }
  throw StateError('tier 2 adds nothing');
}

void main() {
  test('pockets, conflicts and region sums', () {
    final p = pocketsBoard('1234|3412|2143|4321', 'aabb|ccdd|effg|ehhg', '....|3412|2143|4321');
    expect([for (final x in p.pockets) '${x.cells} ${x.sum}'].first, '[0, 1] 3');
    expect(p.pocketOf[12], p.pocketOf[8]);
    expect(pocketsConflicts(p, p.solution), isEmpty);
    final g = List.filled(16, -1);
    // A pocket past its sum, a digit twice; a pocket that can still make it.
    g[0] = 2;
    expect(pocketsConflicts(p, g), isEmpty);
    g[1] = 0;
    expect(pocketsConflicts(p, g), {0, 1});
    g[0] = 0;
    expect(pocketsConflicts(p, g), {0, 1});
    g[0] = 1;
    expect(pocketsConflicts(p, g), isEmpty);
    // A full pocket that misses its sum.
    g[2] = 3;
    g[3] = 3;
    expect(pocketsConflicts(p, g), containsAll([2, 3]));
    expect(PocketsPuzzle.fromJson(p.toJson()).toJson(), p.toJson());
    // Row 0 keeps no cells over (its pockets lie inside it); the band of rows
    // 2–3 leaves nothing either. Column 0 sticks out of its pockets at B1, B2.
    final s = PocketsSolver(p);
    final out = s.areas.where((a) => a.pocket < 0 && a.region == 4 && a.outside).single;
    expect(out.cells, [1, 5]);
    expect(out.sum, 2 + 4);
  });

  for (final n in [4, 6, 9]) {
    for (final d in [Difficulty.easy, Difficulty.medium, Difficulty.hard]) {
      test('pockets ${n}x$n ${d.name}: valid, unique, tiered, deterministic', () {
        final info = <String>[];
        final tier = n < 6 ? 1 : pocketsTier(d);
        for (var seed = 1; seed <= 4; seed++) {
          final params = GenParams(size: GridSize.square(n), difficulty: d, seed: seed);
          final sw = Stopwatch()..start();
          final p = generatePockets(params);
          sw.stop();
          expect(pocketsConflicts(p, p.solution), isEmpty);
          expect(p.givens.every((g) => g == null), isTrue);
          expect(p.pocketOf.every((x) => x >= 0), isTrue);
          final s = PocketsSolver(p);
          final grade = s.grade(s.start());
          if (n == 4) {
            expect(grade, lessThanOrEqualTo(pocketsTier(d)), reason: 'seed $seed');
          } else {
            expect(grade, tier, reason: 'seed $seed');
          }
          expect(s.values(s.start()..setAll(0, [for (final v in p.solution) 1 << v])), p.solution);
          final c = s.start();
          expect(s.solve(c, 3), isTrue);
          expect(s.values(c), p.solution);
          expect(s.countSolutions(s.start()), 1);
          if (seed == 1) expect(generatePockets(params).toJson(), p.toJson(), reason: 'not deterministic');
          expect(PocketsPuzzle.fromJson(p.toJson()).toJson(), p.toJson());
          expect(sw.elapsedMilliseconds, lessThan(timeLimit(4000)));
          final lone = p.pockets.where((x) => x.cells.length == 1).length;
          info.add('${sw.elapsedMilliseconds}ms pockets ${p.pockets.length} lone $lone');
        }
        // ignore: avoid_print
        print('pockets $n ${d.name}: $info');
      });
    }
  }

  test('strategy boards need the tier and the technique they teach', () {
    for (var k = 0; k < pocketsStrategyParams.length; k++) {
      final params = pocketsStrategyParams[k];
      final p = generatePockets(params);
      final s = PocketsSolver(p);
      expect(s.grade(s.start()), pocketsTier(params.difficulty), reason: 'lesson ${k + 1}');
    }
    final (r1, a1) = _firstTier2(generatePockets(pocketsStrategyParams[0]));
    expect(r1 == PocketsRule.combo || r1 == PocketsRule.must, isTrue);
    expect(a1!.pocket < 0 && !a1.outside, isTrue, reason: 'the cells a region keeps');
    final (r2, a2) = _firstTier2(generatePockets(pocketsStrategyParams[1]));
    expect(r2 == PocketsRule.combo || r2 == PocketsRule.must, isTrue);
    expect(a2!.pocket < 0 && a2.outside, isTrue, reason: 'the cells sticking out of a region');
  });
}
