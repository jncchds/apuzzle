import 'dart:math';

import '../../core/difficulty.dart';
import 'inlay_model.dart';
import 'inlay_solver.dart';

/// The share of the grid the shape fills, holes punched in it, piece sizes
/// (weights from size 2 up), whether the tray turns (and mirrors) the
/// pieces, and how many boards to try for few covers, at [d] on a board of
/// [rows] × [cols].
({double fill, int holes, List<int> weights, bool turn, bool flip, int tries}) inlayShape(
  int rows,
  int cols,
  Difficulty d,
) {
  final big = rows * cols >= 49;
  return switch (d) {
    Difficulty.easy => (fill: 0.84, holes: 0, weights: [1, 3, 5], turn: false, flip: false, tries: 1),
    Difficulty.medium => (fill: 0.8, holes: 0, weights: [0, 1, 4, 4], turn: true, flip: false, tries: 12),
    _ => (fill: 0.78, holes: big ? 2 : 1, weights: [0, 0, 2, 6, big ? 2 : 1], turn: true, flip: true, tries: 16),
  };
}

/// Node cap of each cover count while generating (keeps every board fast).
const inlayCountCap = 60000;

/// A random shape cut into random pieces. Medium and hard try several and
/// keep the one with the fewest covers (one, if found).
InlayPuzzle generateInlay(GenParams params) {
  final rows = params.size.rows, cols = params.size.cols;
  final rng = Random(params.seed);
  final shape = inlayShape(rows, cols, params.difficulty);
  InlayPuzzle? best;
  var bestCount = 1 << 20;
  for (var t = 0; t < shape.tries || best == null; t++) {
    final cells = inlayCarve(rows, cols, (rows * cols * shape.fill).round(), shape.holes, rng);
    final parts = inlayPartition(rows, cols, cells, shape.weights, rng);
    if (parts == null) continue;
    final puzzle = inlayFromParts(rows, cols, cells, parts, rng, turn: shape.turn, flip: shape.flip);
    if (shape.tries == 1) return puzzle;
    final count = InlaySolver(puzzle).count(limit: 3, cap: inlayCountCap) ?? 3;
    if (count < bestCount) {
      best = puzzle;
      bestCount = count;
    }
    if (count == 1) break;
  }
  return best!;
}

List<int> _neighbours(int i, int rows, int cols) {
  final r = i ~/ cols, c = i % cols;
  return [if (r > 0) i - cols, if (c < cols - 1) i + 1, if (r < rows - 1) i + cols, if (c > 0) i - 1];
}

bool _connected(List<bool> on, int rows, int cols) {
  final start = on.indexOf(true);
  if (start < 0) return false;
  final seen = List.filled(on.length, false)..[start] = true;
  final stack = [start];
  var n = 1;
  while (stack.isNotEmpty) {
    for (final j in _neighbours(stack.removeLast(), rows, cols)) {
      if (on[j] && !seen[j]) {
        seen[j] = true;
        n++;
        stack.add(j);
      }
    }
  }
  return n == on.where((x) => x).length;
}

/// A connected shape of [size] cells that still reaches all four sides of
/// the grid: cells are bitten off its outline, then [holes] single cells
/// (not next to another hole or the outside, even diagonally) are punched in.
List<bool> inlayCarve(int rows, int cols, int size, int holes, Random rng) {
  final n = rows * cols;
  final on = List.filled(n, true);
  final outside = List.filled(n, false);
  var count = n;
  bool keepsSides(int i) {
    final r = i ~/ cols, c = i % cols;
    bool row(int rr) => List.generate(cols, (cc) => rr * cols + cc).any((j) => j != i && on[j]);
    bool col(int cc) => List.generate(rows, (rr) => rr * cols + cc).any((j) => j != i && on[j]);
    return (r != 0 || row(0)) &&
        (r != rows - 1 || row(rows - 1)) &&
        (c != 0 || col(0)) &&
        (c != cols - 1 || col(cols - 1));
  }

  var stuck = 0;
  while (count > size && stuck < 200) {
    // Cells open on more sides (corners, the tips of spikes) weigh more, so
    // the outline gets notches and steps rather than a ragged rim.
    final cand = <int>[];
    for (var i = 0; i < n; i++) {
      if (!on[i]) continue;
      // Sides off the grid or onto the outside.
      final open = 4 - _neighbours(i, rows, cols).where((j) => !outside[j]).length;
      for (var w = 0; w < open * open; w++) {
        cand.add(i);
      }
    }
    final i = cand[rng.nextInt(cand.length)];
    if (!keepsSides(i)) {
      stuck++;
      continue;
    }
    on[i] = false;
    outside[i] = true;
    // No one-cell spikes: every cell next to the bite keeps two closed sides.
    final spike = _neighbours(
      i,
      rows,
      cols,
    ).any((j) => on[j] && _neighbours(j, rows, cols).where((k) => !outside[k]).length < 2);
    if (spike || !_connected(on, rows, cols)) {
      on[i] = true;
      outside[i] = false;
      stuck++;
      continue;
    }
    count--;
  }
  for (var h = 0, tries = 0; h < holes && tries < 100; tries++) {
    final i = rng.nextInt(n);
    final r = i ~/ cols, c = i % cols;
    if (!on[i] || r == 0 || c == 0 || r == rows - 1 || c == cols - 1) continue;
    var clear = true;
    for (var dr = -1; dr <= 1 && clear; dr++) {
      for (var dc = -1; dc <= 1; dc++) {
        if (!on[(r + dr) * cols + c + dc]) clear = false;
      }
    }
    if (!clear) continue;
    on[i] = false;
    if (_connected(on, rows, cols)) {
      h++;
    } else {
      on[i] = true;
    }
  }
  return on;
}

/// [shape] cut into connected pieces with sizes drawn by [weights] (weight k
/// for size k + 2), or null if the cutting got stuck. Each piece starts at
/// the most hemmed-in free cell and grows into hemmed-in cells first, and
/// no piece may leave a pocket that pieces of the allowed sizes can't fill.
List<List<int>>? inlayPartition(int rows, int cols, List<bool> shape, List<int> weights, Random rng) {
  final lo = weights.indexWhere((w) => w > 0) + 2, hi = weights.length + 1;
  final free = List.of(shape);
  final total = weights.reduce((a, b) => a + b);
  int freeAround(int i) => _neighbours(i, rows, cols).where((j) => free[j]).length;

  /// Whether every pocket of free cells can be cut into sizes lo..hi.
  bool fillable() {
    final seen = List.filled(free.length, false);
    for (var s = 0; s < free.length; s++) {
      if (!free[s] || seen[s]) continue;
      seen[s] = true;
      final stack = [s];
      var size = 0;
      while (stack.isNotEmpty) {
        size++;
        for (final j in _neighbours(stack.removeLast(), rows, cols)) {
          if (free[j] && !seen[j]) {
            seen[j] = true;
            stack.add(j);
          }
        }
      }
      var ok = false;
      for (var k = 1; k * lo <= size && !ok; k++) {
        ok = size <= k * hi;
      }
      if (!ok) return false;
    }
    return true;
  }

  if (!fillable()) return null;
  final parts = <List<int>>[];
  while (free.contains(true)) {
    var start = -1, fewest = 9;
    for (var i = 0; i < free.length; i++) {
      if (!free[i]) continue;
      final f = freeAround(i) * 4 + rng.nextInt(4);
      if (start < 0 || f < fewest) {
        start = i;
        fewest = f;
      }
    }
    List<int>? piece;
    for (var attempt = 0; attempt < 12 && piece == null; attempt++) {
      var pick = rng.nextInt(total), target = lo;
      for (var k = 0; k < weights.length; k++) {
        pick -= weights[k];
        if (pick < 0) {
          target = k + 2;
          break;
        }
      }
      final cells = [start];
      free[start] = false;
      while (cells.length < target) {
        final next = <int>{
          for (final i in cells)
            for (final j in _neighbours(i, rows, cols))
              if (free[j]) j,
        }.toList();
        if (next.isEmpty) break;
        next.sort((a, b) => freeAround(a) - freeAround(b));
        // Mostly the most hemmed-in cell, sometimes any.
        final j = rng.nextInt(3) == 0 ? next[rng.nextInt(next.length)] : next.first;
        free[j] = false;
        cells.add(j);
      }
      if (cells.length >= lo && fillable()) {
        piece = cells;
      } else {
        for (final i in cells) {
          free[i] = true;
        }
      }
    }
    if (piece == null) return null;
    parts.add(piece);
  }
  return parts;
}

/// The puzzle for [parts] of [shape]: pieces in random order, each shown
/// as it lies in the cover, or turned at random if [turn] (and mirrored at
/// random if [flip], which then allows mirroring).
InlayPuzzle inlayFromParts(
  int rows,
  int cols,
  List<bool> shape,
  List<List<int>> parts,
  Random rng, {
  required bool turn,
  required bool flip,
}) {
  final order = List.generate(parts.length, (k) => k)..shuffle(rng);
  return inlayPuzzleOf(
    rows,
    cols,
    shape,
    [for (final k in order) parts[k]],
    [for (final _ in order) turn ? rng.nextInt(flip ? 8 : 4) : 0],
    flip: flip,
  );
}

/// The puzzle whose piece k lies on the cells [parts][k] in the cover and
/// waits in the tray in orientation [shown][k].
InlayPuzzle inlayPuzzleOf(
  int rows,
  int cols,
  List<bool> shape,
  List<List<int>> parts,
  List<int> shown, {
  required bool flip,
}) {
  final pieces = <List<Cell>>[];
  final solution = <(int, int)>[];
  for (var k = 0; k < parts.length; k++) {
    final part = parts[k];
    final r0 = part.map((i) => i ~/ cols).reduce(min), c0 = part.map((i) => i % cols).reduce(min);
    final laid = [for (final i in part) (i ~/ cols - r0, i % cols - c0)];
    final base = orientCells(laid, shown[k]);
    // The orientation that lays the shown piece back as it lies in the cover.
    final want = cellsKey(laid);
    var o = 0;
    while (cellsKey(orientCells(base, o)) != want) {
      o++;
    }
    pieces.add(base);
    solution.add((o, r0 * cols + c0));
  }
  return InlayPuzzle(rows: rows, cols: cols, shape: shape, pieces: pieces, flip: flip, solution: solution);
}
