import 'package:apuzzle/core/difficulty.dart';
import 'package:apuzzle/core/grid.dart';
import 'package:apuzzle/core/recall.dart';
import 'package:apuzzle/puzzles/vanish/vanish_type.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const type = VanishType();

  test('rounds put the numbers on distinct cells, as many as the level', () {
    final watch = Stopwatch()..start();
    for (final size in type.sizes) {
      for (final d in type.difficulties) {
        for (var seed = 0; seed < 5; seed++) {
          final p = type.generate(GenParams(size: size, difficulty: d, seed: seed));
          expect(p.start, inInclusiveRange(p.min, p.max));
          expect(p.max, lessThanOrEqualTo(p.cells));
          for (var level = p.min; level <= p.max; level++) {
            final round = type.roundOf(p, RecallState(round: seed, level: level));
            expect(round.length, level);
            expect(round.toSet().length, level);
            expect(round.every((c) => c >= 0 && c < p.cells), isTrue);
          }
        }
      }
    }
    expect(watch.elapsedMilliseconds, lessThan(2000));
  });

  test('tapping 1 hides the rest; the numbers go in order', () {
    final p = type.generate(const GenParams(size: GridSize.square(5), difficulty: Difficulty.easy, seed: 3));
    var s = type.initialState(p);
    final round = type.roundOf(p, s);
    final empty = List.generate(p.cells, (i) => i).firstWhere((i) => !round.contains(i));
    expect(recallTap(type, p, s, empty), same(s), reason: 'empty cells are no answer');
    expect(recallTap(type, p, s, round[1]).phase, RecallPhase.result, reason: '2 before 1 misses');
    s = recallTap(type, p, s, round[0]);
    expect(s.phase, RecallPhase.answer);
    expect(s.taps, [round[0]]);
    expect(recallTap(type, p, s, round[0]), same(s), reason: 'a cleared number is no answer');
    for (final c in round.skip(1)) {
      s = recallTap(type, p, s, c);
    }
    expect((s.phase, s.passed, s.score), (RecallPhase.result, true, round.length));
  });

  test('the numbers stay on show until the first tap', () {
    final p = type.generate(const GenParams(size: GridSize.square(5), difficulty: Difficulty.hard, seed: 1));
    expect(type.showMs(p, type.roundOf(p, type.initialState(p))), isNull);
    expect(type.answerWhileShown, isTrue);
  });
}
