import 'dart:collection';
import 'dart:math';

import 'package:apuzzle/core/difficulty.dart';
import 'package:apuzzle/core/grid.dart';
import 'package:apuzzle/puzzles/glide/glide_generator.dart';
import 'package:apuzzle/puzzles/glide/glide_model.dart';
import 'package:apuzzle/puzzles/glide/glide_solver.dart';
import 'package:apuzzle/puzzles/glide/glide_tutorial.dart';
import 'package:apuzzle/puzzles/glide/glide_type.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/timing.dart';

/// Moves from order to every board reachable on [rows] × [cols].
Map<String, int> _distances(int rows, int cols) {
  final start = [for (var i = 1; i < rows * cols; i++) i, 0];
  final dist = {start.join(','): 0};
  final queue = Queue<List<int>>()..add(start);
  while (queue.isNotEmpty) {
    final b = queue.removeFirst();
    final d = dist[b.join(',')]!;
    final g = b.indexOf(0);
    for (final m in glideDirs.split('')) {
      if (glideStep(rows, cols, g, m) < 0) continue;
      final next = glideApply(rows, cols, b, m);
      final key = next.join(',');
      if (dist.containsKey(key)) continue;
      dist[key] = d + 1;
      queue.add(next);
    }
  }
  return dist;
}

List<int> _shuffled(int rows, int cols, Random rng) {
  final t = [for (var i = 0; i < rows * cols; i++) i]..shuffle(rng);
  return t;
}

void main() {
  const type = GlideType();

  test('the parity check tells exactly the reachable boards', () {
    for (final (rows, cols) in [(2, 3), (2, 4), (3, 3)]) {
      final reach = _distances(rows, cols);
      final rng = Random(rows * 10 + cols);
      for (var k = 0; k < 300; k++) {
        final t = _shuffled(rows, cols, rng);
        expect(glideSolvable(rows, cols, t), reach.containsKey(t.join(',')), reason: '$rows×$cols $t');
      }
    }
  });

  test('the exact search finds the fewest moves', () {
    final reach = _distances(3, 3);
    final rng = Random(7);
    final solver = GlideSolver.of(3, 3);
    var checked = 0;
    while (checked < 40) {
      final t = _shuffled(3, 3, rng);
      if (!glideSolvable(3, 3, t)) continue;
      final way = solver.optimal(t)!;
      expect(glideSorted(glideApply(3, 3, t, way)), isTrue);
      expect(way.length, reach[t.join(',')], reason: '$t');
      checked++;
    }
    // A walk back is a way out, so the fewest moves never exceed it.
    for (final seed in [1, 2, 3, 4]) {
      final p = type.generate(GenParams(size: const GridSize.square(3), difficulty: Difficulty.easy, seed: seed));
      expect(p.best, reach[p.start.join(',')]);
    }
  });

  test('the strategy solves random boards of every size', () {
    final rng = Random(3);
    for (final size in type.sizes) {
      final solver = GlideSolver.of(size.rows, size.cols);
      for (var k = 0; k < 5; k++) {
        var t = _shuffled(size.rows, size.cols, rng);
        if (!glideSolvable(size.rows, size.cols, t)) {
          final a = t.indexWhere((x) => x != 0), b = t.indexWhere((x) => x != 0, a + 1);
          t = List.of(t)
            ..[a] = t[b]
            ..[b] = t[a];
        }
        final sw = Stopwatch()..start();
        final way = solver.solve(t);
        expect(sw.elapsedMilliseconds, lessThan(timeLimit(300)));
        expect(glideSorted(glideApply(size.rows, size.cols, t, way)), isTrue, reason: '${size.label} $t');
      }
    }
  });

  for (final size in const GlideType().sizes) {
    for (final d in [Difficulty.easy, Difficulty.medium, Difficulty.hard]) {
      test('glide ${size.label} ${d.name}: the plan sorts the board within the limit', () {
        for (var seed = 1; seed <= 3; seed++) {
          final params = GenParams(size: size, difficulty: d, seed: seed, options: const {'goal': 'moves'});
          final sw = Stopwatch()..start();
          final p = type.generate(params);
          sw.stop();
          expect(sw.elapsedMilliseconds, lessThan(timeLimit(2000)));
          expect(glideSolvable(p.rows, p.cols, p.start), isTrue);
          expect(glideSorted(p.start), isFalse);
          var s = type.initialState(p);
          expect(type.isComplete(p, s), isFalse);
          for (var k = 0; k < p.plan.length; k++) {
            s = glideMove(p, s, p.plan[k]);
          }
          expect(type.isSolved(p, s), isTrue);
          expect(p.limit, glideLimit(p.best, d));
          if (seed == 1) expect(type.generate(params).toJson(), p.toJson());
          expect(type.decodePuzzle(type.encodePuzzle(p)).toJson(), p.toJson());
        }
      });
    }
  }

  test('difficulty raises the best way out', () {
    double mean(Difficulty d) {
      var sum = 0;
      for (var seed = 1; seed <= 8; seed++) {
        sum += type.generate(GenParams(size: const GridSize.square(4), difficulty: d, seed: seed)).best;
      }
      return sum / 8;
    }

    final e = mean(Difficulty.easy), m = mean(Difficulty.medium), h = mean(Difficulty.hard);
    expect(e, lessThan(m));
    expect(m, lessThan(h + 10));
  });

  test('a tap slides the whole line between a tile and the gap', () {
    final p = glideBoard(3, 3, const [1, 2, 3, 4, 5, 6, 0, 7, 8]);
    final s = glideSlide(p, type.initialState(p), 8)!;
    expect(s.tiles, [1, 2, 3, 4, 5, 6, 7, 8, 0]);
    expect(s.moves, 2);
    expect(type.isSolved(p, s), isTrue);
    expect(glideSlide(p, type.initialState(p), 1), isNull, reason: 'not in the gap’s row or column');
    expect(type.encodeState(type.decodeState(type.encodeState(s))), type.encodeState(s));
  });

  test('free play has no limit and hints finish from anywhere', () {
    final p = type.generate(const GenParams(size: GridSize(5, 4), difficulty: Difficulty.medium, seed: 2));
    expect(p.limit, isNull);
    var s = type.initialState(p);
    final rng = Random(1);
    for (var k = 0; k < 40; k++) {
      final d = glideDirs[rng.nextInt(4)];
      if (glideStep(p.rows, p.cols, s.gap, d) >= 0) s = glideMove(p, s, d);
    }
    var guard = 0;
    while (!type.isComplete(p, s) && guard++ < 2000) {
      s = type.hint(p, s)!.state;
    }
    expect(type.isSolved(p, s), isTrue);
  });

  test('hints solve within the limit, taking back stray moves when needed', () {
    for (final size in const [GridSize.square(3), GridSize.square(4)]) {
      final p = type.generate(
        GenParams(size: size, difficulty: Difficulty.hard, seed: 5, options: const {'goal': 'moves'}),
      );
      var s = type.initialState(p);
      // Wander off until the limit is nearly used.
      final rng = Random(2);
      while (s.moves < p.limit! - 1) {
        final d = glideDirs[rng.nextInt(4)];
        if (glideStep(p.rows, p.cols, s.gap, d) >= 0) s = glideMove(p, s, d);
      }
      var guard = 0;
      while (!type.isComplete(p, s) && guard++ < 1000) {
        s = type.hint(p, s)!.state;
        expect(s.moves, lessThanOrEqualTo(p.limit!));
      }
      expect(type.isSolved(p, s), isTrue, reason: size.label);
    }
  });

  test('strategy boards show what they teach', () {
    final s1 = glideStrategies[0].puzzle as GlidePuzzle;
    expect(s1.start.sublist(8), [9, 10, 11, 12, 13, 14, 15, 0], reason: 'only the top two rows are mixed');
    expect(s1.start.sublist(0, 4), isNot([1, 2, 3, 4]));
    final s2 = glideStrategies[1].puzzle as GlidePuzzle;
    expect(s2.start.sublist(0, 3), [1, 2, 3]);
    expect(s2.start[3], isNot(4));
    // The corner cell is a dead end behind 3: the way out moves 3 away and back.
    var tiles = s2.start;
    var moved = false;
    for (var k = 0; k < s2.plan.length; k++) {
      tiles = glideApply(4, 4, tiles, s2.plan[k]);
      if (tiles[2] != 3) moved = true;
    }
    expect(moved, isTrue);
  });
}
