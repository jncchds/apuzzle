import 'package:apuzzle/core/difficulty.dart';
import 'package:apuzzle/core/grid.dart';
import 'package:apuzzle/core/recall.dart';
import 'package:apuzzle/puzzles/rebound/rebound_type.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/timing.dart';

/// An independent walk of the ball, cell by cell, for checking [reboundRun].
int _walk(RecallPuzzle p, List<int> round) {
  final n = p.rows, m = p.cols;
  final grid = List<String>.filled(n * m, '.');
  for (final b in round.skip(1)) {
    grid[b >> 1] = b & 1 == 0 ? '/' : r'\';
  }
  final e = round.first;
  // Position and heading (dx right, dy down).
  var (x, y, dx, dy) = e < m
      ? (e, -1, 0, 1)
      : e < m + n
      ? (m, e - m, -1, 0)
      : e < 2 * m + n
      ? (e - m - n, n, 0, -1)
      : (-1, e - 2 * m - n, 1, 0);
  while (true) {
    x += dx;
    y += dy;
    if (y < 0) return x;
    if (x >= m) return m + y;
    if (y >= n) return m + n + x;
    if (x < 0) return 2 * m + n + y;
    final g = grid[y * m + x];
    // '/': right → up, up → right, left → down, down → left.
    if (g == '/') (dx, dy) = (-dy, -dx);
    if (g == r'\') (dx, dy) = (dy, dx);
  }
}

void main() {
  const type = ReboundType();

  test('slots number the edge clockwise from the top', () {
    final p = type.generate(const GenParams(size: GridSize.square(4), difficulty: Difficulty.easy, seed: 1));
    expect(reboundSlot(p, -1, 0), 0);
    expect(reboundSlot(p, 0, 4), 4);
    expect(reboundSlot(p, 4, 3), 11);
    expect(reboundSlot(p, 3, -1), 15);
    expect(reboundSlot(p, -1, -1), isNull);
    expect(reboundSlot(p, 2, 2), isNull);
    for (var s = 0; s < 16; s++) {
      final (r, c) = reboundSlotCell(p, s);
      expect(reboundSlot(p, r, c), s);
    }
  });

  test('the answer matches a walk of the ball, and the ball meets most bumpers', () {
    final watch = Stopwatch()..start();
    var met = 0, placed = 0;
    for (final size in type.sizes) {
      for (final d in type.difficulties) {
        for (var seed = 0; seed < 6; seed++) {
          final p = type.generate(GenParams(size: size, difficulty: d, seed: seed));
          expect(p.start, inInclusiveRange(p.min, p.max));
          for (var level = p.min; level <= p.max; level++) {
            final round = type.roundOf(p, RecallState(round: seed, level: level));
            expect(round.length, level + 1);
            expect(round.first, inInclusiveRange(0, 2 * (p.rows + p.cols) - 1));
            final cells = round.skip(1).map((b) => b >> 1).toSet();
            expect(cells.length, level);
            expect(cells.every((c) => c >= 0 && c < p.cells), isTrue);
            final run = reboundRun(p, round);
            expect(run.exit, _walk(p, round));
            expect(type.nextTap(p, round, const []), run.exit);
            expect(run.path.first, reboundSlotCell(p, round.first));
            expect(run.path.last, reboundSlotCell(p, run.exit));
            expect(run.hits, greaterThanOrEqualTo(1));
            met += run.hits;
            placed += level;
          }
        }
      }
    }
    expect(met / placed, greaterThan(0.5), reason: 'most bumpers are on the way');
    expect(watch.elapsedMilliseconds, lessThan(timeLimit(5000)));
  });

  test('a tap on the exit passes, any other slot misses; the grid is no answer', () {
    final p = type.generate(const GenParams(size: GridSize.square(5), difficulty: Difficulty.medium, seed: 8));
    final s = recallHide(type.initialState(p));
    final exit = reboundRun(p, type.roundOf(p, s)).exit;
    expect(recallTap(type, p, s, exit).passed, isTrue);
    expect(recallTap(type, p, s, (exit + 1) % 20).passed, isFalse);
    expect(type.targetAt(p, 2, 2), isNull);
    expect(type.targetAt(p, -1, 2), 2);
  });

  test('the tutorial boards go where the texts say', () {
    final first = type.tutorial().first.puzzle as RecallPuzzle;
    expect(reboundRun(first, first.fixed.first).exit, 2);
    final second = type.tutorial()[1].puzzle as RecallPuzzle;
    final run = reboundRun(second, second.fixed.first);
    expect((run.exit, run.hits), (3, 2));
  });
}
