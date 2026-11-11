import 'package:apuzzle/core/difficulty.dart';
import 'package:apuzzle/core/grid.dart';
import 'package:apuzzle/puzzles/glades/glades_generator.dart';
import 'package:apuzzle/puzzles/glades/glades_model.dart';
import 'package:apuzzle/puzzles/glades/glades_solver.dart';
import 'package:apuzzle/puzzles/glades/glades_tutorial.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/timing.dart';

List<int> _states(GladesPuzzle p) => [for (final x in p.shaded) x ? gladesShade : gladesKeep];

void main() {
  test('rules: numbered rectangles, no shaded 2×2, joined through corners', () {
    final p = gladesBoard('.2 . #|# # .1|.2 . #');
    expect(gladesValid(p, p.shaded), isTrue);
    // The top 2 left as an area of three: not its size, nor a rectangle.
    final l = List.of(p.shaded)..[3] = false;
    expect(gladesConflicts(p, l, complete: true), containsAll([0, 1, 3]));
    // An unshaded area with no number.
    final extra = gladesBoard('.2 . #|# # .|.2 . #');
    expect(gladesConflicts(extra, extra.shaded, complete: true), contains(5));
    // Cut apart: the two areas don't touch, not even at a corner.
    final apart = gladesBoard('.2 . #|# # #|.2 . #');
    expect(gladesConflicts(apart, apart.shaded, complete: true), isNotEmpty);
    // Before the board is complete only sure mistakes count.
    expect(gladesConflicts(p, List.filled(9, false), complete: false), isEmpty);
    final shade = List.filled(9, false)
      ..[3] = true
      ..[4] = true
      ..[6] = true
      ..[7] = true;
    expect(gladesConflicts(p, shade, complete: false), containsAll([3, 4, 6, 7]));
    final big = List.filled(9, false)..[4] = true;
    final kept = List.filled(9, false)
      ..[1] = true
      ..[2] = true;
    expect(gladesConflicts(p, big, kept: kept, complete: false), containsAll([0, 1, 2]));
  });

  bool solves(GladesPuzzle p, int tier, [Set<GladesRule> off = const {}]) =>
      GladesSolver(p, disabled: off).slack(tier) == 0;

  test('tutorial boards need the rule they teach', () {
    final steps = [for (final s in gladesTutorial.take(4)) s.puzzle as GladesPuzzle];
    for (final p in steps) {
      final s = GladesSolver(p);
      expect(s.grade(), 1);
      final st = s.start();
      expect(s.solve(st, 1), isTrue);
      expect(st, _states(p));
      expect(s.countSolutions(), 1);
    }
    expect(
      solves(steps[0], 1, {
        GladesRule.pool,
        GladesRule.joinMix,
        GladesRule.joinBig,
        GladesRule.corner,
        GladesRule.isolated,
        GladesRule.escape,
      }),
      isTrue,
    );
    expect(solves(steps[1], 1, {GladesRule.pool}), isFalse);
    expect(solves(steps[2], 1, {GladesRule.isolated, GladesRule.escape}), isFalse);
    expect(solves(steps[3], 1, {GladesRule.joinMix, GladesRule.joinBig, GladesRule.corner}), isFalse);
    // Every rectangle a number can be: tier 1 gets stuck, tier 2 needs it.
    expect(solves(gladesRectBoard, 1), isFalse);
    expect(solves(gladesRectBoard, 2), isTrue);
    expect(solves(gladesRectBoard, 2, {GladesRule.rectIn, GladesRule.rectOut, GladesRule.orphan}), isFalse);
    expect(GladesSolver(gladesRectBoard).countSolutions(), 1);
  });

  for (final n in [5, 6, 7, 8, 9, 10]) {
    for (final d in [Difficulty.easy, Difficulty.medium, Difficulty.hard]) {
      test('glades ${n}x$n ${d.name}: valid, unique, tiered, deterministic', () {
        final info = <String>[];
        final tier = gladesTier(d);
        for (var seed = 1; seed <= 4; seed++) {
          final params = GenParams(size: GridSize.square(n), difficulty: d, seed: seed);
          final sw = Stopwatch()..start();
          final p = generateGlades(params);
          sw.stop();
          expect(gladesValid(p, p.shaded), isTrue);
          final s = GladesSolver(p);
          expect(s.grade(), tier);
          final st = s.start();
          expect(s.solve(st, tier), isTrue);
          expect(st, _states(p));
          expect(s.countSolutions(), 1);
          if (seed == 1) expect(generateGlades(params).toJson(), p.toJson(), reason: 'not deterministic');
          expect(GladesPuzzle.fromJson(p.toJson()).toJson(), p.toJson());
          expect(sw.elapsedMilliseconds, lessThan(timeLimit(2500)));
          info.add('${sw.elapsedMilliseconds}ms areas ${p.clues.where((c) => c != null).length}');
        }
        // ignore: avoid_print
        print('glades $n ${d.name}: $info');
      });
    }
  }

  test('strategy boards need their technique', () {
    for (final params in gladesStrategyParams) {
      expect(GladesSolver(generateGlades(params)).grade(), gladesTier(params.difficulty));
    }
  });
}
