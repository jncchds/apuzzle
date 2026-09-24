import 'dart:collection';

import '../../core/grid.dart';

class MosaicPuzzle {
  const MosaicPuzzle({required this.rows, required this.cols, required this.colors, required this.start, required this.limit, required this.plan});

  final int rows;
  final int cols;
  final int colors;
  final List<int> start;

  /// Maximum number of moves allowed.
  final int limit;

  /// A known good move sequence (used for hints).
  final List<int> plan;

  GridSize get size => GridSize(rows, cols);

  Map<String, dynamic> toJson() => {'rows': rows, 'cols': cols, 'colors': colors, 'start': start, 'limit': limit, 'plan': plan};
  factory MosaicPuzzle.fromJson(Map<String, dynamic> j) => MosaicPuzzle(
        rows: j['rows'] as int,
        cols: j['cols'] as int,
        colors: j['colors'] as int,
        start: (j['start'] as List).cast<int>(),
        limit: j['limit'] as int,
        plan: (j['plan'] as List).cast<int>(),
      );
}

class MosaicState {
  const MosaicState(this.cells, this.moves);

  final List<int> cells;
  final int moves;

  Map<String, dynamic> toJson() => {'cells': cells, 'moves': moves};
  factory MosaicState.fromJson(Map<String, dynamic> j) => MosaicState((j['cells'] as List).cast<int>(), j['moves'] as int);
}

/// Flood region from the top-left corner: index → BFS distance (only region cells).
Map<int, int> floodRegion(List<int> cells, int rows, int cols) {
  final color = cells[0];
  final dist = <int, int>{0: 0};
  final q = Queue<int>()..add(0);
  while (q.isNotEmpty) {
    final i = q.removeFirst();
    final r = i ~/ cols, c = i % cols;
    for (final j in [if (r > 0) i - cols, if (r < rows - 1) i + cols, if (c > 0) i - 1, if (c < cols - 1) i + 1]) {
      if (cells[j] == color && !dist.containsKey(j)) {
        dist[j] = dist[i]! + 1;
        q.add(j);
      }
    }
  }
  return dist;
}

List<int> floodApply(List<int> cells, int rows, int cols, int color) {
  if (cells[0] == color) return cells;
  final next = List.of(cells);
  for (final i in floodRegion(cells, rows, cols).keys) {
    next[i] = color;
  }
  return next;
}

bool floodDone(List<int> cells) => cells.every((c) => c == cells[0]);

/// Greedy solver with 2-move lookahead. Returns the move sequence.
List<int> floodSolve(List<int> start, int rows, int cols, int colors) {
  var cells = start;
  final moves = <int>[];
  while (!floodDone(cells) && moves.length < rows * cols) {
    var best = -1;
    var bestScore = -1.0;
    for (var a = 0; a < colors; a++) {
      if (a == cells[0]) continue;
      final c1 = floodApply(cells, rows, cols, a);
      if (floodDone(c1)) {
        best = a;
        break;
      }
      final s1 = floodRegion(c1, rows, cols).length;
      var s2 = 0;
      for (var b = 0; b < colors; b++) {
        if (b == a) continue;
        final l = floodRegion(floodApply(c1, rows, cols, b), rows, cols).length;
        if (l > s2) s2 = l;
      }
      // Bonus for wiping a color out entirely.
      var gone = 0;
      for (var x = 0; x < colors; x++) {
        if (!c1.contains(x)) gone++;
      }
      final score = s2 + s1 * 0.5 + gone * 3;
      if (score > bestScore) {
        bestScore = score;
        best = a;
      }
    }
    moves.add(best);
    cells = floodApply(cells, rows, cols, best);
  }
  return moves;
}
