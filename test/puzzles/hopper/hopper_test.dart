import 'package:apuzzle/core/difficulty.dart';
import 'package:apuzzle/core/grid.dart';
import 'package:apuzzle/core/recall.dart';
import 'package:apuzzle/puzzles/hopper/hopper_type.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/timing.dart';

void main() {
  const type = HopperType();

  test('rounds hop between pads, never twice in a row on one', () {
    final watch = Stopwatch()..start();
    for (final size in type.sizes) {
      for (final d in type.difficulties) {
        for (final order in ['fwd', 'rev']) {
          for (var seed = 0; seed < 5; seed++) {
            final p = type.generate(GenParams(size: size, difficulty: d, seed: seed, options: {'order': order}));
            expect(p.variant, order);
            expect(p.start, inInclusiveRange(p.min, p.max));
            for (var level = p.min; level <= p.max; level++) {
              final round = type.roundOf(p, RecallState(round: seed, level: level));
              expect(round.length, level);
              expect(round.every((c) => c >= 0 && c < p.cells), isTrue);
              for (var k = 1; k < round.length; k++) {
                expect(round[k], isNot(round[k - 1]));
              }
              expect(type.showMs(p, round), greaterThan(HopperType.jumpMs(p) * level));
            }
          }
        }
      }
    }
    expect(watch.elapsedMilliseconds, lessThan(timeLimit(2000)));
  });

  test('the pads go in jump order, or backwards', () {
    for (final order in ['fwd', 'rev']) {
      final p = type.generate(
        GenParams(size: const GridSize.square(4), difficulty: Difficulty.medium, seed: 2, options: {'order': order}),
      );
      var s = recallHide(type.initialState(p));
      final round = type.roundOf(p, s);
      final want = order == 'rev' ? round.reversed.toList() : round;
      expect(recallTap(type, p, s, want[1]).passed, isFalse);
      for (final c in want) {
        s = recallTap(type, p, s, c);
      }
      expect((s.phase, s.passed), (RecallPhase.result, true), reason: order);
    }
  });

  test('the order is a game option and part of the share code', () {
    expect(type.resolveOptions(const {}), {'order': 'fwd', 'goal': 'rounds'});
    final rev = GenParams(
      size: type.defaultSize,
      difficulty: Difficulty.easy,
      seed: 1,
      options: const {'order': 'rev', 'goal': 'lives'},
    );
    expect(rev.variant, 'easy.rev.lives');
    final p = type.generate(rev);
    expect(HopperType.reversed(p), isTrue);
    expect(p.goal, RecallGoal.lives);
  });
}
