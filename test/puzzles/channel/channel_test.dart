import 'dart:convert';
import 'dart:math';

import 'package:apuzzle/core/difficulty.dart';
import 'package:apuzzle/core/grid.dart';
import 'package:apuzzle/puzzles/channel/channel_generator.dart';
import 'package:apuzzle/puzzles/channel/channel_model.dart';
import 'package:apuzzle/puzzles/channel/channel_solver.dart';
import 'package:apuzzle/puzzles/channel/channel_type.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/timing.dart';

const type = ChannelType();

/// Plays hints from [s] until the drain has water; returns the steps taken.
int playHints(ChannelPuzzle p, PipesState s, {int limit = 400}) {
  var steps = 0;
  while (!type.isSolved(p, s)) {
    final h = type.hint(p, s);
    expect(h, isNotNull, reason: 'no hint on an unsolved board');
    s = h!.state;
    expect(++steps, lessThan(limit), reason: 'hints go round in circles');
  }
  return steps;
}

void main() {
  for (final n in [5, 7, 10]) {
    for (final d in type.difficulties) {
      test('channel ${n}x$n ${d.name}: route connects, starts dry, deterministic', () {
        for (var seed = 1; seed <= 6; seed++) {
          final params = GenParams(size: GridSize.square(n), difficulty: d, seed: seed);
          final p = generateChannel(params);
          expect(channelSolved(p, p.masks), isTrue, reason: 'the solved board has no route');
          expect(type.isSolved(p, type.initialState(p)), isFalse, reason: 'starts solved');
          expect(p.locked[p.source] && p.locked[p.target], isTrue);
          expect(p.masks[p.source], isIn(dirs));
          expect(p.masks[p.target], isIn(dirs));
          for (var i = 0; i < p.cells; i++) {
            if (p.locked[i] || p.isBridge(i)) expect(p.start[i] % 4, 0);
          }
          if (d != Difficulty.hard) expect(p.masks.contains(bridgeMask), isFalse);
          final route = solvedRoute(p);
          expect(route.length, greaterThanOrEqualTo(4));
          if (seed == 1) expect(generateChannel(params).toJson(), p.toJson());
        }
      });
    }
  }

  test('hard boards cross over bridges', () {
    var bridges = 0;
    for (var seed = 1; seed <= 10; seed++) {
      final p = generateChannel(GenParams(size: const GridSize.square(8), difficulty: Difficulty.hard, seed: seed));
      bridges += p.masks.where((m) => m == bridgeMask).length;
    }
    expect(bridges, greaterThan(0));
  });

  test('hints solve from the start and from a scrambled middle', () {
    for (final d in type.difficulties) {
      for (var seed = 1; seed <= 8; seed++) {
        final p = generateChannel(GenParams(size: const GridSize.square(8), difficulty: d, seed: seed));
        playHints(p, type.initialState(p));
        // Halfway along the solved board, then a few random turns.
        final rng = Random(seed);
        final turns = [
          for (var i = 0; i < p.cells; i++)
            p.turnable(i) ? (rng.nextBool() ? 0 : rng.nextInt(4)) + 4 * rng.nextInt(2) : p.start[i],
        ];
        final s = PipesState(turns);
        if (!type.isSolved(p, s)) playHints(p, s);
      }
    }
  });

  test('a hint keeps a pipe that already carries the water', () {
    final p = generateChannel(const GenParams(size: GridSize.square(7), difficulty: Difficulty.medium, seed: 3));
    // Lay the solved route's first half; hints never turn those tiles.
    final route = solvedRoute(p);
    final turns = List.of(p.start);
    final kept = <int>{};
    for (final (i, _, _) in route.take(route.length ~/ 2)) {
      if (p.turnable(i)) turns[i] = 4;
      kept.add(i);
    }
    var s = PipesState(turns);
    while (!type.isSolved(p, s)) {
      final h = type.hint(p, s)!;
      final i = p.size.index(h.cells.single);
      expect(kept.contains(i), isFalse, reason: 'turned a tile of the laid pipe');
      s = h.state;
    }
  });

  test('flow goes straight over a bridge and through every arm elsewhere', () {
    // S → bridge (west to east) → drain; the bridge's north-south pipe stays dry.
    const p = ChannelPuzzle(
      rows: 1,
      cols: 3,
      source: 0,
      target: 2,
      masks: [dE, bridgeMask, dW],
      start: [0, 0, 0],
      locked: [true, false, true],
    );
    final flow = channelFlow(p, p.masks);
    expect(flow[1] & flowEW, isNot(0));
    expect(flow[1] & flowNS, 0);
    expect(channelSolved(p, p.masks), isTrue);
    expect(p.turnable(1), isFalse);
  });

  test('encode and decode round-trip', () {
    final p = generateChannel(const GenParams(size: GridSize.square(6), difficulty: Difficulty.hard, seed: 9));
    final back = type.decodePuzzle(jsonDecode(jsonEncode(type.encodePuzzle(p))) as Map<String, dynamic>);
    expect(back.toJson(), p.toJson());
    final s = PipesState([for (var i = 0; i < p.cells; i++) i % 5]);
    expect(type.decodeState(jsonDecode(jsonEncode(type.encodeState(s))) as Map<String, dynamic>).turns, s.turns);
  });

  test('generation is fast', () {
    final sw = Stopwatch()..start();
    var worst = 0;
    for (final d in type.difficulties) {
      for (var seed = 1; seed <= 5; seed++) {
        final t = sw.elapsedMilliseconds;
        generateChannel(GenParams(size: const GridSize.square(10), difficulty: d, seed: seed));
        worst = max(worst, sw.elapsedMilliseconds - t);
      }
    }
    expect(worst, lessThan(timeLimit(1500)));
  });
}
