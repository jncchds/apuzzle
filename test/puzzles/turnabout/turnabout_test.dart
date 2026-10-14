import 'package:apuzzle/core/difficulty.dart';
import 'package:apuzzle/core/grid.dart';
import 'package:apuzzle/core/puzzle_code.dart';
import 'package:apuzzle/core/registry.dart';
import 'package:apuzzle/puzzles/labyrinth/labyrinth_model.dart';
import 'package:apuzzle/puzzles/turnabout/turnabout_generator.dart';
import 'package:apuzzle/puzzles/turnabout/turnabout_model.dart';
import 'package:apuzzle/puzzles/turnabout/turnabout_tutorial.dart';
import 'package:apuzzle/puzzles/turnabout/turnabout_type.dart';
import 'package:flutter_test/flutter_test.dart';

const type = TurnaboutType();

/// Plays the perfect player to the end of the game.
TurnaboutState _auto(TurnaboutPuzzle p) {
  var s = type.initialState(p);
  for (var k = 0; k < 100000; k++) {
    final next = turnaboutAuto(p, s);
    if (next == null) return s;
    s = next;
  }
  fail('did not finish');
}

/// A practice race on 6×6 with no turns and a rival at [pace] steps per cell.
TurnaboutPuzzle _race({int pace = 3, List<(int, int)> turns = const []}) =>
    turnaboutPractice(6, 5, rivalTicks: pace, turns: turns);

void main() {
  test('screen directions map to maze directions by the turn', () {
    for (var o = 0; o < 4; o++) {
      for (var d = 0; d < 4; d++) {
        expect(turnaboutScreenDir(turnaboutMazeDir(d, o), o), d);
      }
    }
    // Straight: up is north. A quarter turn clockwise brings west to the top
    // and north to the right; a half turn brings south up; three quarters, east.
    expect(turnaboutMazeDir(0, 0), 0);
    expect(turnaboutMazeDir(0, 1), 3);
    expect(turnaboutMazeDir(1, 1), 0);
    expect(turnaboutMazeDir(0, 2), 2);
    expect(turnaboutMazeDir(0, 3), 1);
    expect(turnaboutMazeDir(3, 3), 0);
  });

  test('a swipe moves the runner the way the turned maze shows it', () {
    final p = _race(pace: 50);
    final round = p.round(0);
    final s0 = type.initialState(p);
    // Every orientation: each screen direction moves to the maze neighbour it points at.
    for (var o = 0; o < 4; o++) {
      final s = s0.copyWith(orient: o);
      for (var screen = 0; screen < 4; screen++) {
        final maze = turnaboutMazeDir(screen, o);
        final next = turnaboutMove(p, s, screen);
        if (round.open[s.player] & dirs[maze] == 0) {
          expect(next, same(s), reason: 'a wall');
        } else {
          expect(next.player, neighbor(s.player, dirs[maze], p.n, p.n));
          expect(next.readyAt, turnaboutPlayerTicks);
          expect(turnaboutMove(p, next, (screen + 2) & 3), same(next), reason: 'not ready yet');
        }
      }
    }
  });

  test('the rival runs its shortest way at its pace', () {
    final p = _race(pace: 3);
    final round = p.round(0);
    final dist = turnaboutDistances(p.n, round.open, round.rival);
    expect(round.rivalPath.first, round.rival);
    expect(round.rivalPath.last, round.prize);
    expect(round.rivalPath.length, dist[round.prize] + 1, reason: 'shortest');
    for (var k = 1; k < round.rivalPath.length; k++) {
      expect(dist[round.rivalPath[k]], k);
    }
    var s = type.initialState(p);
    for (var t = 1; s.result == TurnaboutResult.running; t++) {
      s = turnaboutStep(p, s);
      expect(s.tick, t);
      expect(s.rival, t ~/ 3);
      expect(turnaboutRivalCell(p, s), round.rivalPath[t ~/ 3]);
    }
    expect(s.result, TurnaboutResult.lost);
    expect(s.tick, 3 * dist[round.prize]);
    expect(turnaboutRivalCell(p, s), round.prize);
    expect(turnaboutOver(p, s), isTrue);
    expect(type.isSolved(p, s), isFalse, reason: 'a lost practice race');
  });

  test('the maze turns on time, after a warning, and nobody moves meanwhile', () {
    final p = _race(pace: 5, turns: const [(10, 1), (20, 2)]);
    var s = type.initialState(p);
    for (var t = 1; t < 10; t++) {
      s = turnaboutStep(p, s);
      expect(turnaboutWarning(p, s), t >= 10 - turnaboutWarnTicks ? (10, 1) : null);
    }
    final rival = s.rival;
    s = turnaboutStep(p, s);
    expect(s.orient, 1);
    expect(turnaboutTurning(s), isTrue);
    expect(turnaboutCanMove(s), isFalse);
    expect(turnaboutMove(p, s, 0), same(s));
    for (var t = 1; t < turnaboutTurnTicks(1); t++) {
      s = turnaboutStep(p, s);
      expect(turnaboutTurning(s), isTrue);
      expect(s.rival, rival, reason: 'the rival waits for the turn');
    }
    s = turnaboutStep(p, s);
    expect(turnaboutTurning(s), isFalse);
    expect(turnaboutCanMove(s), isTrue);
    while (s.tick < 20) {
      s = turnaboutStep(p, s);
    }
    expect(s.orient, 3, reason: 'then a half turn');
    expect(s.turnBy, 2);
  });

  test('the next round starts fresh and keeps the score; the game ends after the last', () {
    final p = type.generate(const GenParams(size: GridSize.square(7), difficulty: Difficulty.easy, seed: 3));
    var s = type.initialState(p);
    while (s.result == TurnaboutResult.running) {
      s = turnaboutStep(p, s); // never moving
    }
    expect(s.result, TurnaboutResult.lost);
    expect(turnaboutOver(p, s), isFalse);
    expect(turnaboutStep(p, s), same(s));
    s = turnaboutNext(p, s);
    expect(s.round, 1);
    expect(s.losses, 1);
    expect(s.fresh, isTrue);
    expect(s.player, p.round(1).player);
    for (var r = 1; r < turnaboutRounds; r++) {
      while (s.result == TurnaboutResult.running) {
        s = turnaboutStep(p, s);
      }
      if (r < turnaboutRounds - 1) s = turnaboutNext(p, s);
    }
    expect(s.losses, turnaboutRounds);
    expect(type.isComplete(p, s), isTrue);
    expect(type.isSolved(p, s), isTrue, reason: 'a score game');
    expect(type.score(p, s), 0);
  });

  test('a lives game ends at the third lost round, and its rival speeds up', () {
    final p = type.generate(
      const GenParams(size: GridSize.square(7), difficulty: Difficulty.easy, seed: 3, options: {'goal': 'lives'}),
    );
    expect(p.goal, TurnaboutGoal.lives);
    expect(p.rounds, isNull);
    expect(p.rivalPace(0), turnaboutRivalTicks(Difficulty.easy));
    expect(p.rivalPace(3), turnaboutRivalTicks(Difficulty.easy) - 1);
    expect(p.rivalPace(100), turnaboutPlayerTicks + 1);
    var s = type.initialState(p);
    var rounds = 0;
    while (!type.isComplete(p, s)) {
      s = turnaboutStep(p, s);
      if (s.result != TurnaboutResult.running && !type.isComplete(p, s)) {
        s = turnaboutNext(p, s);
        rounds++;
      }
    }
    expect(rounds, turnaboutLives - 1);
    expect(s.losses, turnaboutLives);
    expect(type.isSolved(p, s), isTrue);
  });

  for (final d in Difficulty.values) {
    for (final size in type.sizes) {
      test('${size.label} ${d.name}: fair rounds, and the perfect player wins them all', () {
        for (var seed = 1; seed <= 4; seed++) {
          final params = GenParams(size: size, difficulty: d, seed: seed);
          final p = type.generate(params);
          final again = type.generate(params);
          expect(again.toJson(), p.toJson(), reason: 'deterministic');
          for (var r = 0; r < turnaboutRounds; r++) {
            final a = p.round(r), b = again.round(r);
            expect(b.toJson(), a.toJson(), reason: 'round $r is deterministic');
            _checkRound(a);
          }
          expect(p.round(1).open, isNot(p.round(0).open), reason: 'a new maze every round');
          final s = _auto(p);
          expect(s.wins, turnaboutRounds, reason: 'seed $seed');
          expect(s.losses, 0);
          expect(type.isSolved(p, s), isTrue);
          expect(_auto(p).toJson(), s.toJson(), reason: 'replays the same game');
        }
      });
    }
  }

  test('harder levels: a faster rival, more winding mazes, more turns', () {
    expect(turnaboutRivalTicks(Difficulty.hard), lessThan(turnaboutRivalTicks(Difficulty.easy)));
    expect(turnaboutRivalTicks(Difficulty.hard), greaterThan(turnaboutPlayerTicks));
    expect(turnaboutTurns(Difficulty.hard).gap.$2, lessThan(turnaboutTurns(Difficulty.easy).gap.$1));
    expect(turnaboutTurns(Difficulty.hard).half, isTrue);
    expect(turnaboutTurns(Difficulty.medium).half, isFalse);
    for (final d in Difficulty.values) {
      final size = type.dailySize(d);
      expect(type.sizes, contains(size));
      expect(size.rows, size.cols, reason: 'square, so it fits however it is turned');
      expect(size.rows * type.minCellSize, lessThanOrEqualTo(360));
    }
  });

  test('generation is fast', () {
    final watch = Stopwatch()..start();
    var n = 0;
    for (final size in type.sizes) {
      for (final d in Difficulty.values) {
        for (var seed = 20; seed < 23; seed++) {
          final p = type.generate(GenParams(size: size, difficulty: d, seed: seed));
          for (var r = 0; r < turnaboutRounds; r++) {
            p.round(r).rivalPath;
          }
          n++;
        }
      }
    }
    expect(watch.elapsedMilliseconds / n, lessThan(50));
  });

  test('state and puzzle survive a save round trip', () {
    final p = type.generate(const GenParams(size: GridSize.square(9), difficulty: Difficulty.hard, seed: 9));
    var s = type.initialState(p);
    for (var k = 0; k < 40; k++) {
      s = type.hint(p, s)!.state;
    }
    expect(s.tick, greaterThan(0));
    expect(type.decodeState(type.encodeState(s)).toJson(), s.toJson());
    final q = type.decodePuzzle(type.encodePuzzle(p));
    expect(q.toJson(), p.toJson());
    expect(q.round(2).toJson(), p.round(2).toJson());
    for (final step in type.tutorial()) {
      final t = step.puzzle as TurnaboutPuzzle;
      final back = type.decodePuzzle(type.encodePuzzle(t));
      expect(back.toJson(), t.toJson());
      expect(back.round(0).rivalPath, t.round(0).rivalPath);
    }
  });

  test('share codes carry the goal', () {
    const params = GenParams(
      size: GridSize.square(8),
      difficulty: Difficulty.medium,
      seed: 77,
      options: {'goal': 'lives'},
    );
    final code = PuzzleCode.format(type, params);
    expect(PuzzleCode.parse(code, puzzleTypes).params.options, {'goal': 'lives'});
  });
}

/// A perfect maze; runner and rival in opposite corners; the star as far
/// from both, and not on either start.
void _checkRound(TurnaboutRound r) {
  final n = r.n;
  var passages = 0;
  for (var i = 0; i < n * n; i++) {
    for (final d in dirs) {
      if (r.open[i] & d == 0) continue;
      final j = neighbor(i, d, n, n);
      expect(j, isNotNull, reason: 'no passage out of the board');
      expect(r.open[j!] & opposite(d), isNot(0));
      passages++;
    }
  }
  expect(passages ~/ 2, n * n - 1, reason: 'a tree');
  final dp = turnaboutDistances(n, r.open, r.player), dr = turnaboutDistances(n, r.open, r.rival);
  expect(dp.every((x) => x >= 0), isTrue, reason: 'connected');
  final corners = {0, n - 1, n * n - 1, n * (n - 1)};
  expect(corners, contains(r.player));
  expect(corners, contains(r.rival));
  final (pr, pc, rr, rc) = (r.player ~/ n, r.player % n, r.rival ~/ n, r.rival % n);
  expect((pr - rr).abs() + (pc - rc).abs(), 2 * (n - 1), reason: 'opposite corners');
  expect(dp[r.prize], dr[r.prize], reason: 'fair');
  expect(dp[r.prize], greaterThanOrEqualTo(n - 1));
  expect(r.turns, isNotEmpty);
  for (var k = 1; k < r.turns.length; k++) {
    expect(r.turns[k].$1, greaterThan(r.turns[k - 1].$1 + turnaboutTurnTicks(r.turns[k - 1].$2)));
  }
}
