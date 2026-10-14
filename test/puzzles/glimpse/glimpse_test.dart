import 'package:apuzzle/core/difficulty.dart';
import 'package:apuzzle/core/grid.dart';
import 'package:apuzzle/core/recall.dart';
import 'package:apuzzle/puzzles/glimpse/glimpse_type.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/timing.dart';

void main() {
  const type = GlimpseType();

  test('rounds light distinct cells, as many as the level', () {
    final watch = Stopwatch()..start();
    var rounds = 0;
    for (final size in type.sizes) {
      for (final d in type.difficulties) {
        for (var seed = 0; seed < 5; seed++) {
          final p = type.generate(GenParams(size: size, difficulty: d, seed: seed));
          expect(p.start, inInclusiveRange(p.min, p.max));
          expect(p.max, lessThan(p.cells));
          for (var level = p.min; level <= p.max; level++) {
            final round = type.roundOf(p, RecallState(round: seed, level: level));
            rounds++;
            expect(round.length, level);
            expect(round.toSet().length, level);
            expect(round.every((c) => c >= 0 && c < p.cells), isTrue);
            expect(type.showMs(p, round), greaterThan(800));
          }
        }
      }
    }
    expect(watch.elapsedMilliseconds, lessThan(timeLimit(2000)), reason: '$rounds rounds');
  });

  test('a tap on an unlit cell fails at once, the last lit cell passes', () {
    final p = type.generate(const GenParams(size: GridSize.square(4), difficulty: Difficulty.easy, seed: 3));
    final round = type.roundOf(p, type.initialState(p));
    final off = List.generate(p.cells, (i) => i).firstWhere((i) => !round.contains(i));
    expect(type.verdict(p, round, [round.first, off]), RecallVerdict.failed);
    expect(type.verdict(p, round, round.sublist(1)), RecallVerdict.going);
    expect(type.verdict(p, round, round.reversed.toList()), RecallVerdict.passed);
  });

  test('easy shows longer than hard', () {
    GenParams at(Difficulty d) => GenParams(size: type.defaultSize, difficulty: d, seed: 1);
    final easy = type.generate(at(Difficulty.easy)), hard = type.generate(at(Difficulty.hard));
    const round = [0, 1, 2, 3];
    expect(type.showMs(easy, round)!, greaterThan(type.showMs(hard, round)!));
    expect(easy.start, lessThan(hard.start));
  });
}
