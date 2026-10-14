import 'dart:math';

import 'package:apuzzle/core/difficulty.dart';
import 'package:apuzzle/core/grid.dart';
import 'package:apuzzle/puzzles/blockade/blockade_generator.dart';
import 'package:apuzzle/puzzles/blockade/blockade_model.dart';
import 'package:apuzzle/puzzles/blockade/blockade_solver.dart';
import 'package:apuzzle/puzzles/blockade/blockade_tutorial.dart';
import 'package:apuzzle/puzzles/blockade/blockade_type.dart';
import 'package:flutter_test/flutter_test.dart';

/// Whether some passage of at most [depth] turns reaches the harbour, by
/// trying every sequence of moves and waits (no search state shared).
bool _anyPassage(BlockadePuzzle p, int depth) {
  final route = [p.start];
  bool go(int left) {
    if (route.last == p.goal) return true;
    if (left == 0) return false;
    final at = route.last, t = route.length - 1;
    for (final v in [at, ...p.neighbours(at)]) {
      if (blockadeCaught(p.patrols, at, v, t)) continue;
      route.add(v);
      final ok = go(left - 1);
      route.removeLast();
      if (ok) return true;
    }
    return false;
  }

  return go(depth);
}

BlockadeState _playHints(BlockadeType type, BlockadePuzzle p, BlockadeState s) {
  for (var k = 0; k < 400 && !type.isSolved(p, s); k++) {
    s = type.hint(p, s)!.state;
  }
  return s;
}

void main() {
  const type = BlockadeType();

  test('ships sail their beats: back and forth, or round a loop', () {
    const line = Patrol([0, 1, 2], loop: false);
    expect([for (var t = 0; t < 6; t++) line.at(t)], [0, 1, 2, 1, 0, 1]);
    expect(line.period, 4);
    const loop = Patrol([0, 1, 5, 4], loop: true, phase: 2);
    expect([for (var t = 0; t < 5; t++) loop.at(t)], [5, 4, 0, 1, 5]);
    expect(
      patrolCycle(const [
        line,
        loop,
        Patrol([7, 8, 9, 10], loop: false),
      ]),
      12,
    );
  });

  test('caught on a ship cell or by swapping, not when slipping in behind', () {
    // 1 × 5, a ship going back and forth on cells 1..3.
    const ships = [
      Patrol([1, 2, 3], loop: false),
    ];
    expect(blockadeCaught(ships, 0, 1, 1), isFalse); // the ship goes 2 → 3
    expect(blockadeCaught(ships, 0, 0, 0), isFalse);
    expect(blockadeCaught(ships, 1, 2, 0), isTrue); // ends where the ship ends
    expect(blockadeCaught(ships, 0, 1, 3), isTrue); // 2 → 1
    expect(blockadeCaught(ships, 3, 2, 2), isTrue); // head-on: both end on 2
    expect(blockadeCaught(ships, 1, 2, 1), isFalse); // boat follows the ship 2 → 3
    expect(blockadeCaught(ships, 2, 1, 0), isTrue); // boat 2 → 1 while the ship 1 → 2
  });

  for (final size in type.sizes) {
    for (final d in type.difficulties) {
      test('blockade ${size.label} ${d.name}: fastest passage fits, needs the ships, deterministic, fast', () {
        for (var seed = 1; seed <= 4; seed++) {
          final params = GenParams(size: size, difficulty: d, seed: seed);
          final sw = Stopwatch()..start();
          final p = type.generate(params);
          expect(sw.elapsedMilliseconds, lessThan(1500));
          expect(p.patrols, isNotEmpty);
          expect(p.cycle, lessThanOrEqualTo(blockadeMaxCycle));
          for (final s in p.patrols) {
            expect(s.route, isNot(contains(p.start)));
            expect(s.route, isNot(contains(p.goal)));
            for (var k = 0; k < s.route.length; k++) {
              expect(p.rocks[s.route[k]], isFalse);
              if (k > 0 || s.loop) {
                final prev = s.route[(k - 1 + s.route.length) % s.route.length];
                expect(p.canSail(prev, s.route[k]) && prev != s.route[k], isTrue);
              }
            }
          }
          final solver = BlockadeSolver(p);
          final plan = solver.plan();
          expect(plan.length - 1, p.best);
          expect(p.limit, p.best + blockadeShape(size.rows, size.cols, d).slack);
          expect(blockadeSolved(p, plan), isTrue);
          // The shortest way, ignoring the ships, always gets caught.
          expect(p.best, greaterThan(solver.plain()));
          expect(type.isSolved(p, type.initialState(p)), isFalse);
          expect(type.generate(params).toJson(), p.toJson());
          expect(type.decodePuzzle(type.encodePuzzle(p)).toJson(), p.toJson());
        }
      });
    }
  }

  test('the fastest passage is really the fastest (every passage tried on small seas)', () {
    var checked = 0;
    for (var seed = 1; checked < 12 && seed < 400; seed++) {
      final rng = Random(seed);
      final p = blockadeSea(3 + seed % 2, 4, 1 + seed % 2, 3, rng);
      if (p == null) continue;
      final best = BlockadeSolver(p).best();
      if (best == null || best > 9) continue;
      checked++;
      expect(_anyPassage(p, best), isTrue, reason: 'seed $seed: no passage of $best turns');
      expect(_anyPassage(p, best - 1), isFalse, reason: 'seed $seed: a passage shorter than $best');
    }
    expect(checked, 12);
  });

  test('medium and hard boards need more than sailing on and waiting when blocked', () {
    for (final d in [Difficulty.medium, Difficulty.hard]) {
      var fails = 0, detours = 0;
      for (var seed = 1; seed <= 10; seed++) {
        final p = type.generate(GenParams(size: const GridSize.square(7), difficulty: d, seed: seed));
        final solver = BlockadeSolver(p);
        if (solver.greedy(cap: p.limit) == null) fails++;
        if (solver.waitThenGo(cap: p.best) == null) detours++;
      }
      expect(fails, greaterThanOrEqualTo(8), reason: d.name);
      expect(detours, greaterThanOrEqualTo(8), reason: d.name);
    }
  });

  test('tutorial boards teach what they say', () {
    final wait = blockadeTutorial[1].puzzle as BlockadePuzzle;
    final s = BlockadeSolver(wait);
    expect(wait.best, greaterThan(s.plain()));
    expect(s.waitThenGo(cap: wait.best), wait.best);
    final round = blockadeTutorial[2].puzzle as BlockadePuzzle;
    expect(round.limit, round.best);
    expect(BlockadeSolver(round).waitThenGo(cap: round.best), isNull);
    final beats = blockadeStrategies[0].puzzle as BlockadePuzzle;
    final b = BlockadeSolver(beats);
    expect(b.greedy(cap: beats.limit), isNull);
    expect(b.waitThenGo(cap: beats.best), isNull);
  });

  test('hints finish within the turns, also after being caught or running out', () {
    final p = type.generate(const GenParams(size: GridSize.square(7), difficulty: Difficulty.hard, seed: 3));
    final end = _playHints(type, p, type.initialState(p));
    expect(type.isSolved(p, end), isTrue);
    expect(end.turn, p.best);

    // Wait at the start until the turns run out.
    final idle = BlockadeState(List.filled(p.limit + 1, p.start));
    expect(type.isSolved(p, _playHints(type, p, idle)), isTrue);

    // Sail into a ship somewhere along the fastest passage.
    final plan = BlockadeSolver(p).plan();
    BlockadeState? caught;
    for (var t = 0; t < plan.length - 1 && caught == null; t++) {
      for (final v in [plan[t], ...p.neighbours(plan[t])]) {
        if (blockadeCaught(p.patrols, plan[t], v, t)) {
          caught = BlockadeState([...plan.sublist(0, t + 1), v]);
          break;
        }
      }
    }
    expect(caughtTurn(p, caught!.route), caught.turn);
    expect(type.isSolved(p, _playHints(type, p, caught)), isTrue);
  });
}
