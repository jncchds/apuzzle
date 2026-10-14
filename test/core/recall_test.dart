import 'package:apuzzle/core/difficulty.dart';
import 'package:apuzzle/core/grid.dart';
import 'package:apuzzle/core/recall.dart';
import 'package:apuzzle/core/registry.dart';
import 'package:apuzzle/puzzles/glimpse/glimpse_type.dart';
import 'package:flutter_test/flutter_test.dart';

/// The memory games' shared round flow, played on Glimpse.
void main() {
  const type = GlimpseType();
  RecallPuzzle make({String goal = 'rounds', Difficulty d = Difficulty.medium, int seed = 5}) =>
      type.generate(GenParams(size: const GridSize.square(5), difficulty: d, seed: seed, options: {'goal': goal}));

  /// A wrong tap: a cell the round doesn't hold.
  int wrong(RecallPuzzle p, RecallState s) => List.generate(p.cells, (i) => i).firstWhere(
    (i) => !type.roundOf(p, s).contains(i),
  );

  test('every memory game is a real-time score game in the daily opt-in', () {
    final recall = puzzleTypes.whereType<RecallType>().toList();
    expect(recall, isNotEmpty);
    for (final t in recall) {
      expect(t.realTime, isTrue, reason: t.id);
      expect(t.dailyOptIn, isTrue, reason: t.id);
      expect(categoryOf(t).id, 'casual', reason: t.id);
    }
  });

  test('a right round goes one level up and scores its level', () {
    final p = make();
    var s = type.initialState(p);
    expect(s.level, 4);
    s = recallHide(s);
    expect(s.phase, RecallPhase.answer);
    for (final c in type.roundOf(p, s)) {
      s = recallTap(type, p, s, c);
    }
    expect(s.phase, RecallPhase.result);
    expect(s.passed, isTrue);
    expect(s.score, 4);
    s = recallNext(p, s);
    expect((s.round, s.level, s.phase), (1, 5, RecallPhase.show));
    expect(s.taps, isEmpty);
  });

  test('a miss goes one level down and keeps the score', () {
    final p = make();
    var s = recallHide(type.initialState(p));
    s = recallTap(type, p, s, wrong(p, s));
    expect((s.phase, s.passed, s.misses, s.score), (RecallPhase.result, false, 1, 0));
    s = recallNext(p, s);
    expect((s.round, s.level), (1, 3));
  });

  test('taps are ignored while a round is on show, and a tap twice counts once', () {
    final p = make();
    var s = type.initialState(p);
    final c = type.roundOf(p, s).first;
    expect(recallTap(type, p, s, c), same(s));
    s = recallTap(type, p, recallHide(s), c);
    expect(recallTap(type, p, s, c), same(s));
  });

  test('a game of rounds ends after its rounds, a game of lives after the misses', () {
    final p = make();
    var s = type.initialState(p);
    var levels = 0;
    while (s.phase != RecallPhase.done) {
      if (s.phase == RecallPhase.show) levels += s.level;
      s = recallAuto(type, p, s)!;
    }
    expect(s.correct, recallRounds);
    expect(s.score, levels);
    expect(type.isComplete(p, s) && type.isSolved(p, s), isTrue);
    expect(recallAuto(type, p, s), isNull);

    final q = make(goal: 'lives');
    s = type.initialState(q);
    for (var miss = 0; miss < recallLives; miss++) {
      expect(s.phase, RecallPhase.show);
      s = recallHide(s);
      s = recallTap(type, q, s, wrong(q, s));
      s = recallNext(q, s);
    }
    expect(s.phase, RecallPhase.done);
    expect(s.level, q.min);
  });

  test('levels stay in range', () {
    final p = make(d: Difficulty.hard);
    var s = type.initialState(p);
    for (var k = 0; k < 40; k++) {
      s = recallHide(s);
      s = recallTap(type, p, s, wrong(p, s));
      s = RecallState(round: 0, level: recallNext(p, s).level);
    }
    expect(s.level, p.min);
  });

  test('a practice round replays after a miss and ends after its right rounds', () {
    final p = recallPractice(
      type,
      const GridSize.square(3),
      fixed: const [
        [0, 4, 8],
      ],
    );
    var s = recallHide(type.initialState(p));
    s = recallNext(p, recallTap(type, p, s, 1));
    expect((s.round, s.phase), (0, RecallPhase.show));
    expect(type.roundOf(p, s), [0, 4, 8]);
    while (s.phase != RecallPhase.done) {
      s = recallAuto(type, p, s)!;
    }
    expect(s.correct, 1);
  });

  test('rounds come from the seed, the round and the level', () {
    final a = make(seed: 9), b = make(seed: 9), c = make(seed: 10);
    expect(type.encodePuzzle(a), type.encodePuzzle(b));
    for (var r = 0; r < 10; r++) {
      final s = RecallState(round: r, level: 3 + r % 4);
      expect(type.roundOf(a, s), type.roundOf(b, s));
    }
    final rounds = [for (var r = 0; r < 10; r++) type.roundOf(a, RecallState(round: r, level: 6))];
    expect(rounds.toSet().length, greaterThan(1));
    expect(
      [for (var r = 0; r < 10; r++) type.roundOf(c, RecallState(round: r, level: 6))].join(),
      isNot(rounds.join()),
    );
  });

  test('puzzles and states survive (de)serialization', () {
    final p = make(goal: 'lives');
    expect(type.encodePuzzle(type.decodePuzzle(type.encodePuzzle(p))), type.encodePuzzle(p));
    var s = type.initialState(p);
    for (var k = 0; k < 4; k++) {
      s = recallAuto(type, p, s)!;
      expect(type.encodeState(type.decodeState(type.encodeState(s))), type.encodeState(s));
    }
  });
}
