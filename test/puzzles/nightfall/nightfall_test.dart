import 'dart:math';

import 'package:apuzzle/core/difficulty.dart';
import 'package:apuzzle/core/grid.dart';
import 'package:apuzzle/puzzles/nightfall/nightfall_generator.dart';
import 'package:apuzzle/puzzles/nightfall/nightfall_model.dart';
import 'package:apuzzle/puzzles/nightfall/nightfall_tutorial.dart';
import 'package:apuzzle/puzzles/nightfall/nightfall_type.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/timing.dart';

int _count(List<bool> v) => v.where((b) => b).length;

/// Taps of a chase from [top] (taps in the top row): each later row taps
/// under the lights left in the row above. Returns the lights left.
List<bool> _chase(NightfallPuzzle p, List<int> top) {
  var s = NightfallState.initial(p);
  for (final c in top) {
    s = nightfallTap(p, s, c);
  }
  for (var r = 1; r < p.rows; r++) {
    for (var c = 0; c < p.cols; c++) {
      if (s.on[(r - 1) * p.cols + c]) s = nightfallTap(p, s, r * p.cols + c);
    }
  }
  return s.on;
}

void main() {
  const type = NightfallType();

  test('fewest taps put the lights out and nothing does it with fewer', () {
    final rng = Random(4);
    for (final wrap in [false, true]) {
      for (final n in [3, 4]) {
        final g = NightfallGeometry.of(n, n, wrap);
        for (var k = 0; k < 6; k++) {
          final taps = List.generate(n * n, (_) => rng.nextBool());
          final lights = nightfallLights(g, List.filled(n * n, false), taps);
          final best = g.fewest(lights)!;
          expect(nightfallLights(g, lights, best).contains(true), isFalse);
          // Brute force over every set of taps.
          var least = n * n + 1;
          for (var m = 0; m < 1 << (n * n); m++) {
            final set = [for (var i = 0; i < n * n; i++) (m >> i) & 1 == 1];
            if (!nightfallLights(g, lights, set).contains(true)) least = min(least, _count(set));
          }
          expect(_count(best), least, reason: 'n=$n wrap=$wrap');
        }
      }
    }
  });

  test('unreachable boards have no solution', () {
    final g = NightfallGeometry.of(5, 5, false);
    final one = List.filled(25, false)..[0] = true;
    expect(g.solvable(one), isFalse, reason: 'a lone corner light on 5×5 cannot be put out');
    for (final k in g.kernel) {
      expect(nightfallLights(g, List.filled(25, false), k).contains(true), isFalse);
    }
  });

  for (final n in [4, 5, 7, 9, 10]) {
    for (final d in [Difficulty.easy, Difficulty.medium, Difficulty.hard]) {
      for (final edges in ['flat', 'wrap']) {
        test('nightfall ${n}x$n ${d.name} $edges: the plan is a fewest way out within the limit', () {
          for (var seed = 1; seed <= 3; seed++) {
            final params = GenParams(size: GridSize.square(n), difficulty: d, seed: seed, options: {'edges': edges});
            final sw = Stopwatch()..start();
            final p = type.generate(params);
            sw.stop();
            expect(sw.elapsedMilliseconds, lessThan(timeLimit(1000)));
            expect(p.wrap, edges == 'wrap');
            expect(p.start.contains(true), isTrue);
            var s = type.initialState(p);
            expect(type.isComplete(p, s), isFalse);
            for (final i in p.plan) {
              s = nightfallTap(p, s, i);
            }
            expect(type.isSolved(p, s), isTrue);
            expect(p.limit, p.best + nightfallSlack(d));
            final g = NightfallGeometry.of(n, n, p.wrap);
            expect(_count(g.fewest(p.start)!), p.best);
            if (seed == 1) expect(type.generate(params).toJson(), p.toJson());
            expect(type.decodePuzzle(type.encodePuzzle(p)).toJson(), p.toJson());
          }
        });
      }
    }
  }

  test('difficulty raises the fewest taps', () {
    double mean(Difficulty d) {
      var sum = 0;
      for (var seed = 1; seed <= 10; seed++) {
        sum += type.generate(GenParams(size: const GridSize.square(7), difficulty: d, seed: seed)).best;
      }
      return sum / 10;
    }

    final e = mean(Difficulty.easy), m = mean(Difficulty.medium), h = mean(Difficulty.hard);
    expect(e, lessThan(m));
    expect(m, lessThan(h));
  });

  test('free play has no limit', () {
    final p = type.generate(
      const GenParams(size: GridSize.square(6), difficulty: Difficulty.hard, seed: 2, options: {'goal': 'free'}),
    );
    expect(p.limit, isNull);
    var s = type.initialState(p);
    for (var i = 0; i < 36; i++) {
      s = nightfallTap(p, s, i);
    }
    while (!type.isComplete(p, s)) {
      s = type.hint(p, s)!.state;
    }
    expect(type.isSolved(p, s), isTrue);
  });

  test('hints solve within the limit, taking back stray taps when needed', () {
    final p = type.generate(const GenParams(size: GridSize.square(6), difficulty: Difficulty.medium, seed: 5));
    var s = type.initialState(p);
    // Wander off: taps outside the plan until the limit is nearly used.
    final stray = [
      for (var i = 0; i < 36; i++)
        if (!p.plan.contains(i)) i,
    ];
    for (final i in stray.take(p.limit! - 1)) {
      s = nightfallTap(p, s, i);
    }
    expect(type.encodeState(type.decodeState(type.encodeState(s))), type.encodeState(s));
    var guard = 0;
    while (!type.isComplete(p, s) && guard++ < 100) {
      s = type.hint(p, s)!.state;
      expect(s.moves, lessThanOrEqualTo(p.limit!));
    }
    expect(type.isSolved(p, s), isTrue);
  });

  test('strategy boards need what they teach', () {
    final s1 = nightfallStrategies[0].puzzle as NightfallPuzzle;
    expect(_chase(s1, const []).contains(true), isFalse, reason: 'a plain chase clears the first board');
    final s2 = nightfallStrategies[1].puzzle as NightfallPuzzle;
    expect(_chase(s2, const []).contains(true), isTrue, reason: 'a plain chase leaves lights');
    expect(_chase(s2, const [1]).contains(true), isFalse, reason: 'the marked top tap fixes it');
  });
}
