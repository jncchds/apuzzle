import 'dart:math';

import '../../core/difficulty.dart';
import 'atoms_model.dart';
import 'atoms_solver.dart';

/// Grow a connected bond network island by island (never crossing), derive the
/// numbers, then keep puzzles whose solution is unique and matches the tier.
AtomsPuzzle generateAtoms(GenParams params) {
  final rows = params.size.rows, cols = params.size.cols;
  final rng = Random(params.seed);
  final target = switch (params.difficulty) {
    Difficulty.easy => 1,
    Difficulty.medium => 2,
    _ => 3,
  };
  final islandTarget = (rows * cols * 0.2).round().clamp(4, 40);
  AtomsPuzzle? best;
  var bestScore = 1 << 30;

  for (var attempt = 0; attempt < 120; attempt++) {
    final net = _grow(rows, cols, islandTarget, rng);
    if (net == null) continue;
    final (islands, bonds) = net;
    final edges = atomEdges(rows, cols, islands);
    final solution = List<int>.filled(edges.length, 0);
    for (var e = 0; e < edges.length; e++) {
      final key = _key(islands[edges[e].a], islands[edges[e].b]);
      solution[e] = bonds[key] ?? 0;
    }
    final numbers = List<int>.filled(islands.length, 0);
    for (var e = 0; e < edges.length; e++) {
      numbers[edges[e].a] += solution[e];
      numbers[edges[e].b] += solution[e];
    }
    final puzzle = AtomsPuzzle(rows: rows, cols: cols, islands: islands, numbers: numbers, edges: edges, solution: solution);
    if (!atomsSolved(puzzle, solution)) continue;
    final solver = AtomsSolver(puzzle);
    if (solver.solutions().length != 1) continue;
    final tier = solver.grade();
    if (tier > 3) continue; // needs guessing
    final score = (tier - target).abs();
    if (score == 0) return puzzle;
    if (score < bestScore) {
      bestScore = score;
      best = puzzle;
    }
  }
  return best ?? generateAtoms(params.withSeed(params.seed + 104729));
}

int _key(int a, int b) => a < b ? a * 100000 + b : b * 100000 + a;

/// Returns island cells and bond counts keyed by [_key].
(List<int>, Map<int, int>)? _grow(int rows, int cols, int target, Random rng) {
  final n = rows * cols;
  // 0 free, 1 island, 2 horizontal bridge, 3 vertical bridge
  final cell = List<int>.filled(n, 0);
  final islands = <int>[];
  final bonds = <int, int>{};
  final start = rng.nextInt(n);
  cell[start] = 1;
  islands.add(start);

  bool nearIsland(int i, int except) {
    final r = i ~/ cols, c = i % cols;
    for (final j in [if (r > 0) i - cols, if (r < rows - 1) i + cols, if (c > 0) i - 1, if (c < cols - 1) i + 1]) {
      if (j != except && cell[j] == 1) return true;
    }
    return false;
  }

  var fails = 0;
  while (islands.length < target && fails < 400) {
    final from = islands[rng.nextInt(islands.length)];
    final dir = rng.nextInt(4);
    final dr = [-1, 0, 1, 0][dir], dc = [0, 1, 0, -1][dir];
    final r0 = from ~/ cols, c0 = from % cols;
    final maxLen = max(rows, cols) ~/ 2 + 1;
    final len = 2 + rng.nextInt(max(1, maxLen - 1));
    final r1 = r0 + dr * len, c1 = c0 + dc * len;
    if (r1 < 0 || c1 < 0 || r1 >= rows || c1 >= cols) {
      fails++;
      continue;
    }
    final to = r1 * cols + c1;
    var ok = cell[to] == 0 && !nearIsland(to, -1);
    for (var k = 1; k < len && ok; k++) {
      if (cell[(r0 + dr * k) * cols + c0 + dc * k] != 0) ok = false;
    }
    if (!ok) {
      fails++;
      continue;
    }
    for (var k = 1; k < len; k++) {
      cell[(r0 + dr * k) * cols + c0 + dc * k] = dr == 0 ? 2 : 3;
    }
    cell[to] = 1;
    islands.add(to);
    bonds[_key(from, to)] = rng.nextDouble() < 0.4 ? 2 : 1;
    fails = 0;
  }
  if (islands.length < max(4, target * 2 ~/ 3)) return null;

  // Extra bonds between islands that already see each other (adds loops).
  for (var k = 0; k < islands.length; k++) {
    final i = islands[k], r = i ~/ cols, c = i % cols;
    for (final (dr, dc) in const [(0, 1), (1, 0)]) {
      var rr = r + dr, cc = c + dc;
      final path = <int>[];
      while (rr < rows && cc < cols && cell[rr * cols + cc] == 0) {
        path.add(rr * cols + cc);
        rr += dr;
        cc += dc;
      }
      if (rr >= rows || cc >= cols || cell[rr * cols + cc] != 1 || path.isEmpty) continue;
      if (rng.nextDouble() < 0.3) {
        for (final x in path) {
          cell[x] = dr == 0 ? 2 : 3;
        }
        bonds[_key(i, rr * cols + cc)] = rng.nextDouble() < 0.3 ? 2 : 1;
      }
    }
  }
  islands.sort();
  return (islands, bonds);
}
