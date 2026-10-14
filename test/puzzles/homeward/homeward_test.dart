import 'dart:math';

import 'package:apuzzle/core/difficulty.dart';
import 'package:apuzzle/core/grid.dart';
import 'package:apuzzle/puzzles/homeward/homeward_generator.dart';
import 'package:apuzzle/puzzles/homeward/homeward_model.dart';
import 'package:apuzzle/puzzles/homeward/homeward_solver.dart';
import 'package:apuzzle/puzzles/homeward/homeward_type.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/timing.dart';

/// Every crossing reachable from the start, roads the same from both ends.
bool _connected(HomewardPuzzle p) {
  final n = p.rows * p.cols;
  for (var i = 0; i < n; i++) {
    for (final d in roadDirs) {
      if (p.roads[i] & d == 0) continue;
      final j = roadStep(i, d, p.rows, p.cols);
      if (j == null || p.roads[j] & roadOpposite(d) == 0) return false;
    }
  }
  final seen = {p.start};
  final queue = [p.start];
  for (var q = 0; q < queue.length; q++) {
    for (final j in p.neighbours(queue[q])) {
      if (seen.add(j)) queue.add(j);
    }
  }
  return seen.length == n;
}

/// Whether some drive of at most [depth] roads brings every pet home, by
/// trying every route (no search state is shared between routes).
bool _anyRoute(HomewardPuzzle p, int depth) {
  final route = [p.start];
  bool go(int left) {
    if (HomewardTrip.of(p, route).allHome(p.petCount)) return true;
    if (left == 0) return false;
    for (final j in p.neighbours(route.last)) {
      route.add(j);
      final ok = go(left - 1);
      route.removeLast();
      if (ok) return true;
    }
    return false;
  }

  return go(depth);
}

HomewardState _playHints(HomewardType type, HomewardPuzzle p, HomewardState s) {
  for (var k = 0; k < 400 && !type.isComplete(p, s); k++) {
    s = type.hint(p, s)!.state;
  }
  return s;
}

void main() {
  const type = HomewardType();

  for (final size in type.sizes) {
    for (final d in type.difficulties) {
      test('homeward ${size.label} ${d.name}: connected, best plan fits the fuel, deterministic, fast', () {
        for (var seed = 1; seed <= 4; seed++) {
          final params = GenParams(size: size, difficulty: d, seed: seed);
          final sw = Stopwatch()..start();
          final p = type.generate(params);
          expect(sw.elapsedMilliseconds, lessThan(timeLimit(1500)));
          expect(_connected(p), isTrue);
          final shape = homewardShape(size.rows, size.cols, d);
          expect(p.petCount, shape.pets);
          expect({p.start, ...p.pets, ...p.homes}.length, 1 + 2 * p.petCount);
          final plan = HomewardSolver(p).plan();
          expect(plan.length - 1, p.best);
          expect(p.limit, p.best + shape.slack);
          expect(homewardSolved(p, plan), isTrue);
          expect(type.isSolved(p, type.initialState(p)), isFalse);
          if (seed == 1) expect(type.generate(params).toJson(), p.toJson());
          expect(type.decodePuzzle(type.encodePuzzle(p)).toJson(), p.toJson());
        }
      });
    }
  }

  test('the shortest plan is really the shortest (every route tried on small towns)', () {
    var checked = 0;
    for (var seed = 1; checked < 12 && seed < 400; seed++) {
      final rng = Random(seed);
      final rows = 2 + seed % 2, cols = 3 + seed % 2;
      final p = homewardTown(rows, cols, 2, 1 + seed % 2, rng);
      final best = HomewardSolver(p).best();
      if (best > 10) continue;
      checked++;
      expect(_anyRoute(p, best), isTrue, reason: 'seed $seed: no route of $best roads');
      expect(_anyRoute(p, best - 1), isFalse, reason: 'seed $seed: a route shorter than $best');
    }
    expect(checked, 12);
  });

  test('medium and hard boards punish heading for the nearest pet', () {
    for (final d in [Difficulty.medium, Difficulty.hard]) {
      var gaps = 0;
      for (var seed = 1; seed <= 10; seed++) {
        final p = type.generate(GenParams(size: const GridSize.square(7), difficulty: d, seed: seed));
        final greedy = HomewardSolver(p).greedy();
        expect(greedy, greaterThanOrEqualTo(p.best));
        if (greedy > p.limit) gaps++;
      }
      expect(gaps, greaterThanOrEqualTo(8), reason: d.name);
    }
  });

  test('pets get on only with a seat free and off only at their home', () {
    // 1 × 5: car, pet 0, pet 1, home 0, home 1; one seat.
    final p = HomewardPuzzle(
      rows: 1,
      cols: 5,
      roads: const [rE, rE | rW, rE | rW, rE | rW, rW],
      start: 0,
      pets: const [1, 2],
      homes: const [3, 4],
      seats: 1,
      limit: 20,
      best: 0,
    );
    var trip = HomewardTrip.of(p, [0, 1, 2]);
    expect(trip.status(0), PetStatus.aboard);
    expect(trip.status(1), PetStatus.waiting);
    trip = HomewardTrip.of(p, [0, 1, 2, 3, 2]);
    expect(trip.status(0), PetStatus.home);
    expect(trip.status(1), PetStatus.aboard);
    expect(trip.seated, [1]);
    expect(HomewardSolver(p).best(), 6);
  });

  test('hints finish within the fuel, also after running it dry', () {
    final p = type.generate(const GenParams(size: GridSize.square(7), difficulty: Difficulty.hard, seed: 3));
    final end = _playHints(type, p, type.initialState(p));
    expect(type.isSolved(p, end), isTrue);
    expect(end.used, p.best);

    // Waste fuel driving back and forth until the tank is empty.
    final start = p.start, next = p.neighbours(start).first;
    final route = [start];
    while (route.length - 1 < p.limit) {
      route.add(route.last == start ? next : start);
    }
    final rescued = _playHints(type, p, HomewardState(route));
    expect(type.isSolved(p, rescued), isTrue);
  });
}
