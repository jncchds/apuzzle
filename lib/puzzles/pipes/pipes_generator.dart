import 'dart:math';

import '../../core/difficulty.dart';
import 'pipes_model.dart';

/// Random spanning tree grown from the central source (randomized Prim),
/// avoiding 4-way crosses on easier levels; tiles are then scrambled.
PipesPuzzle generatePipes(GenParams params) {
  final rows = params.size.rows, cols = params.size.cols, n = rows * cols;
  final rng = Random(params.seed);
  final d = params.difficulty;
  final source = (rows ~/ 2) * cols + cols ~/ 2;
  final masks = List<int>.filled(n, 0);
  final inTree = List<bool>.filled(n, false)..[source] = true;
  final frontier = <(int, int)>[]; // (from, dir)
  void addFrontier(int i) {
    for (final dd in dirs) {
      final j = neighbor(i, dd, rows, cols);
      if (j != null && !inTree[j]) frontier.add((i, dd));
    }
  }

  addFrontier(source);
  final cap = switch (d) {
    Difficulty.easy => 2,
    Difficulty.medium => 3,
    _ => 4,
  };
  var guard = 0;
  while (frontier.isNotEmpty) {
    final k = rng.nextInt(frontier.length);
    final (i, dd) = frontier[k];
    final j = neighbor(i, dd, rows, cols)!;
    if (inTree[j]) {
      frontier.removeAt(k);
      continue;
    }
    // Prefer other edges when this tile already has many arms.
    if (_arms(masks[i]) + 1 > cap && guard++ < 40) continue;
    guard = 0;
    frontier.removeAt(k);
    masks[i] |= dd;
    masks[j] |= opposite(dd);
    inTree[j] = true;
    addFrontier(j);
  }

  final lockRatio = switch (d) {
    Difficulty.easy => 0.3,
    Difficulty.medium => 0.12,
    _ => 0.0,
  };
  final locked = [for (var i = 0; i < n; i++) i != source && rng.nextDouble() < lockRatio];
  final start = [
    for (var i = 0; i < n; i++) locked[i] ? 0 : rng.nextInt(4),
  ];
  // Make sure the puzzle doesn't start solved.
  if (pipesSolved(
      PipesPuzzle(rows: rows, cols: cols, source: source, masks: masks, start: start, locked: locked),
      [for (var i = 0; i < n; i++) rotateMask(masks[i], start[i])])) {
    for (var i = 0; i < n; i++) {
      if (!locked[i] && masks[i] != 5 && masks[i] != 10 && masks[i] != 15) {
        start[i] = (start[i] + 1) % 4;
        break;
      }
    }
  }
  return PipesPuzzle(rows: rows, cols: cols, source: source, masks: masks, start: start, locked: locked);
}

int _arms(int m) => (m & 1) + ((m >> 1) & 1) + ((m >> 2) & 1) + ((m >> 3) & 1);
