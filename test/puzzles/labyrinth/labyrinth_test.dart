import 'package:apuzzle/core/difficulty.dart';
import 'package:apuzzle/core/grid.dart';
import 'package:apuzzle/puzzles/labyrinth/labyrinth_generator.dart';
import 'package:apuzzle/puzzles/labyrinth/labyrinth_model.dart';
import 'package:apuzzle/puzzles/labyrinth/labyrinth_type.dart';
import 'package:flutter_test/flutter_test.dart';

/// Every cell reachable from the start, and edges = cells - 1 (so no loops).
bool _perfectMaze(LabyrinthPuzzle p) {
  final n = p.rows * p.cols;
  var edges = 0;
  for (var i = 0; i < n; i++) {
    for (final d in dirs) {
      if (p.open[i] & d == 0) continue;
      final j = neighbor(i, d, p.rows, p.cols);
      if (j == null || p.open[j] & opposite(d) == 0) return false;
      if (d == dE || d == dS) edges++;
    }
  }
  final seen = <int>{0};
  final queue = [0];
  for (var q = 0; q < queue.length; q++) {
    for (final d in dirs) {
      if (p.open[queue[q]] & d == 0) continue;
      final j = neighbor(queue[q], d, p.rows, p.cols)!;
      if (seen.add(j)) queue.add(j);
    }
  }
  return seen.length == n && edges == n - 1;
}

void main() {
  const type = LabyrinthType();
  for (final size in type.sizes) {
    for (final d in type.difficulties) {
      test('labyrinth ${size.label} ${d.name}: perfect maze, valid way out, deterministic, fast', () {
        for (var seed = 1; seed <= 5; seed++) {
          final params = GenParams(size: size, difficulty: d, seed: seed);
          final sw = Stopwatch()..start();
          final p = generateLabyrinth(params);
          expect(sw.elapsedMilliseconds, lessThan(500));
          expect(_perfectMaze(p), isTrue, reason: 'not a perfect maze');
          expect(labyrinthSolved(p, p.solution), isTrue);
          expect(type.isSolved(p, type.initialState(p)), isFalse);
          expect(generateLabyrinth(params).toJson(), p.toJson());
        }
      });
    }
  }

  test('hints walk out, and step back from a dead end', () {
    final p = generateLabyrinth(const GenParams(size: GridSize.square(10), difficulty: Difficulty.hard, seed: 3));
    // Wander into a side passage first.
    final side = [
      for (final i in p.solution)
        for (final d in dirs)
          if (p.open[i] & d != 0) neighbor(i, d, p.rows, p.cols)!
    ].firstWhere((j) => !p.solution.contains(j));
    final branch = p.solution.indexWhere((i) => passable(p, i, side));
    var s = LabyrinthState([...p.solution.sublist(0, branch + 1), side]);
    var guard = 0;
    while (!type.isComplete(p, s) && guard++ < 200) {
      s = type.hint(p, s)!.state;
    }
    expect(type.isSolved(p, s), isTrue);
    expect(s.path, p.solution);
  });

  test('corridor follows straight open passages only', () {
    final p = generateLabyrinth(const GenParams(size: GridSize.square(8), difficulty: Difficulty.medium, seed: 1));
    for (var i = 0; i < 64; i++) {
      for (final d in dirs) {
        final j = neighbor(i, d, 8, 8);
        if (j == null) continue;
        expect(corridor(p, i, j), p.open[i] & d != 0 ? [j] : null);
      }
    }
    expect(corridor(p, 0, 9), isNull); // diagonal
  });
}
