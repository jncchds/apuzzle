import 'dart:math';

import '../../core/difficulty.dart';
import 'merge_model.dart';

/// Tile to build: 2048 on a 4×4 hard game, one step less per difficulty
/// below that, one step up per extra row, and 256 on a cramped 3×3.
int mergeTarget(int rows, int cols, Difficulty d) {
  final side = min(rows, cols);
  final hard = side <= 3 ? 8 : 11 + (side - 4); // 2^11 = 2048 on 4×4
  final drop = switch (d) {
    Difficulty.easy => 2,
    Difficulty.medium => 1,
    _ => 0,
  };
  return 1 << max(5, hard - drop);
}

MergePuzzle generateMerge(GenParams params, MergeGoal goal) {
  final rows = params.size.rows, cols = params.size.cols;
  var cells = List<int>.filled(rows * cols, 0);
  for (var k = 0; k < 2; k++) {
    final (at, v) = mergeSpawn(cells, params.seed, -k)!;
    cells = [...cells]..[at] = v;
  }
  return MergePuzzle(
    rows: rows,
    cols: cols,
    goal: goal,
    target: goal == MergeGoal.target ? mergeTarget(rows, cols, params.difficulty) : 0,
    seed: params.seed,
    start: cells,
  );
}

/// The move a short expectimax search likes best, or null when stuck.
MergeDir? mergeSuggest(MergePuzzle p, MergeState s) {
  MergeDir? best;
  var bestScore = double.negativeInfinity;
  for (final dir in MergeDir.values) {
    final (cells, gained, moved) = mergeSlide(s.cells, p.rows, p.cols, dir);
    if (!moved) continue;
    final v = gained / 8 + _chance(cells, p.rows, p.cols, 1);
    if (v > bestScore) {
      bestScore = v;
      best = dir;
    }
  }
  return best;
}

/// Expected value over new tiles (a sample of empty cells on big boards).
double _chance(List<int> cells, int rows, int cols, int depth) {
  final empty = [for (var i = 0; i < cells.length; i++) if (cells[i] == 0) i];
  if (empty.isEmpty) return _heuristic(cells, rows, cols);
  final step = max(1, empty.length ~/ 6);
  var sum = 0.0;
  var n = 0;
  for (var k = 0; k < empty.length; k += step) {
    final i = empty[k];
    for (final (v, w) in const [(2, 0.9), (4, 0.1)]) {
      final next = [...cells]..[i] = v;
      sum += w * _max(next, rows, cols, depth);
    }
    n++;
  }
  return sum / n;
}

double _max(List<int> cells, int rows, int cols, int depth) {
  var best = double.negativeInfinity;
  for (final dir in MergeDir.values) {
    final (next, gained, moved) = mergeSlide(cells, rows, cols, dir);
    if (!moved) continue;
    final v = gained / 8 + (depth > 0 ? _chance(next, rows, cols, depth - 1) : _heuristic(next, rows, cols));
    if (v > best) best = v;
  }
  return best == double.negativeInfinity ? -1000 : best;
}

/// Likes empty cells, rows and columns that rise or fall steadily, smooth
/// neighbours and the biggest tile in a corner.
double _heuristic(List<int> cells, int rows, int cols) {
  final lg = [for (final v in cells) v == 0 ? 0.0 : log(v) / ln2];
  var empty = 0;
  var smooth = 0.0;
  for (var i = 0; i < cells.length; i++) {
    if (cells[i] == 0) {
      empty++;
      continue;
    }
    if (i % cols < cols - 1 && cells[i + 1] != 0) smooth -= (lg[i] - lg[i + 1]).abs();
    if (i ~/ cols < rows - 1 && cells[i + cols] != 0) smooth -= (lg[i] - lg[i + cols]).abs();
  }
  double mono(Iterable<List<int>> lines) {
    var total = 0.0;
    for (final line in lines) {
      var up = 0.0, down = 0.0;
      for (var k = 1; k < line.length; k++) {
        final d = lg[line[k]] - lg[line[k - 1]];
        if (d > 0) {
          up += d;
        } else {
          down -= d;
        }
      }
      total -= min(up, down);
    }
    return total;
  }

  final top = lg.reduce(max);
  final corners = [0, cols - 1, (rows - 1) * cols, rows * cols - 1];
  final cornered = corners.any((i) => lg[i] == top) ? top : 0.0;
  return 2.7 * empty +
      1.0 * (mono(mergeLines(rows, cols, MergeDir.left)) + mono(mergeLines(rows, cols, MergeDir.up))) +
      0.1 * smooth +
      1.0 * cornered;
}
