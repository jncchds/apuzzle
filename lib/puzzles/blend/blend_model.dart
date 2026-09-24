import 'dart:collection';
import 'dart:math';

import '../../core/grid.dart';

/// A move: repaint the patch containing [cell] with [color].
typedef BlendMove = (int cell, int color);

class BlendPuzzle {
  const BlendPuzzle({
    required this.rows,
    required this.cols,
    required this.colors,
    required this.start,
    required this.limit,
    required this.plan,
  });

  final int rows;
  final int cols;
  final int colors;
  final List<int> start;
  final int limit;

  /// A known move sequence within the limit (used for hints).
  final List<BlendMove> plan;

  GridSize get size => GridSize(rows, cols);

  Map<String, dynamic> toJson() => {
        'rows': rows,
        'cols': cols,
        'colors': colors,
        'start': start,
        'limit': limit,
        'plan': [for (final (c, k) in plan) [c, k]],
      };

  factory BlendPuzzle.fromJson(Map<String, dynamic> j) => BlendPuzzle(
        rows: j['rows'] as int,
        cols: j['cols'] as int,
        colors: j['colors'] as int,
        start: (j['start'] as List).cast<int>(),
        limit: j['limit'] as int,
        plan: [for (final m in j['plan'] as List) ((m as List)[0] as int, m[1] as int)],
      );
}

class BlendState {
  const BlendState(this.cells, this.moves);
  final List<int> cells;
  final int moves;

  Map<String, dynamic> toJson() => {'cells': cells, 'moves': moves};
  factory BlendState.fromJson(Map<String, dynamic> j) => BlendState((j['cells'] as List).cast<int>(), j['moves'] as int);
}

List<int> _nb(int i, int rows, int cols) {
  final r = i ~/ cols, c = i % cols;
  return [if (r > 0) i - cols, if (r < rows - 1) i + cols, if (c > 0) i - 1, if (c < cols - 1) i + 1];
}

/// Connected same-color patches: component id per cell.
List<int> blendComponents(List<int> cells, int rows, int cols) {
  final comp = List<int>.filled(cells.length, -1);
  var id = 0;
  for (var s = 0; s < cells.length; s++) {
    if (comp[s] >= 0) continue;
    comp[s] = id;
    final q = Queue<int>()..add(s);
    while (q.isNotEmpty) {
      final i = q.removeFirst();
      for (final j in _nb(i, rows, cols)) {
        if (comp[j] < 0 && cells[j] == cells[s]) {
          comp[j] = id;
          q.add(j);
        }
      }
    }
    id++;
  }
  return comp;
}

/// Repaints the patch containing [cell].
List<int> blendApply(List<int> cells, int rows, int cols, int cell, int color) {
  if (cells[cell] == color) return cells;
  final comp = blendComponents(cells, rows, cols);
  final target = comp[cell];
  return [for (var i = 0; i < cells.length; i++) comp[i] == target ? color : cells[i]];
}

bool blendDone(List<int> cells) => cells.every((c) => c == cells[0]);

/// Greedy solver: each step picks the (patch, color) that merges the most
/// neighbouring patches (ties: bigger resulting patch, then random).
List<BlendMove> blendSolve(List<int> start, int rows, int cols, int colors, Random rng) {
  var cells = start;
  final moves = <BlendMove>[];
  while (!blendDone(cells) && moves.length < cells.length) {
    final comp = blendComponents(cells, rows, cols);
    final count = comp.reduce(max) + 1;
    final size = List<int>.filled(count, 0);
    final color = List<int>.filled(count, 0);
    final rep = List<int>.filled(count, -1);
    final adj = List.generate(count, (_) => <int>{});
    for (var i = 0; i < cells.length; i++) {
      final a = comp[i];
      size[a]++;
      color[a] = cells[i];
      if (rep[a] < 0) rep[a] = i;
      for (final j in _nb(i, rows, cols)) {
        if (comp[j] != a) adj[a].add(comp[j]);
      }
    }
    BlendMove? best;
    var bestMerge = -1, bestSize = -1;
    var ties = 0;
    for (var a = 0; a < count; a++) {
      final byColor = <int, (int, int)>{};
      for (final b in adj[a]) {
        final (m, s) = byColor[color[b]] ?? (0, 0);
        byColor[color[b]] = (m + 1, s + size[b]);
      }
      for (final e in byColor.entries) {
        final merge = e.value.$1, merged = size[a] + e.value.$2;
        if (merge > bestMerge || (merge == bestMerge && merged > bestSize)) {
          bestMerge = merge;
          bestSize = merged;
          best = (rep[a], e.key);
          ties = 1;
        } else if (merge == bestMerge && merged == bestSize && rng.nextInt(++ties) == 0) {
          best = (rep[a], e.key);
        }
      }
    }
    moves.add(best!);
    cells = blendApply(cells, rows, cols, best.$1, best.$2);
  }
  return moves;
}
