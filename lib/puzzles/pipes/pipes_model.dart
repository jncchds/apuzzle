import 'dart:collection';

import '../../core/grid.dart';

/// Direction bits: N=1, E=2, S=4, W=8.
const int dN = 1, dE = 2, dS = 4, dW = 8;
const dirs = [dN, dE, dS, dW];

int opposite(int d) => switch (d) { dN => dS, dE => dW, dS => dN, _ => dE };

/// Rotate a connection mask clockwise [times] quarter turns.
int rotateMask(int mask, int times) {
  var m = mask;
  for (var i = 0; i < times % 4; i++) {
    m = ((m << 1) | (m >> 3)) & 0xF;
  }
  return m;
}

class PipesPuzzle {
  const PipesPuzzle({required this.rows, required this.cols, required this.source, required this.masks, required this.start, required this.locked});

  final int rows;
  final int cols;
  final int source;

  /// Solved connection mask per tile.
  final List<int> masks;

  /// Initial rotation (quarter turns clockwise applied to the solved mask).
  final List<int> start;

  /// Tiles given in the correct orientation (cannot be rotated).
  final List<bool> locked;

  GridSize get size => GridSize(rows, cols);

  Map<String, dynamic> toJson() =>
      {'rows': rows, 'cols': cols, 'source': source, 'masks': masks, 'start': start, 'locked': locked};
  factory PipesPuzzle.fromJson(Map<String, dynamic> j) => PipesPuzzle(
        rows: j['rows'] as int,
        cols: j['cols'] as int,
        source: j['source'] as int,
        masks: (j['masks'] as List).cast<int>(),
        start: (j['start'] as List).cast<int>(),
        locked: (j['locked'] as List).cast<bool>(),
      );
}

/// Cumulative clockwise quarter turns per tile (kept unbounded so the
/// rotation animation always turns forward).
class PipesState {
  const PipesState(this.turns);
  final List<int> turns;

  Map<String, dynamic> toJson() => {'turns': turns};
  factory PipesState.fromJson(Map<String, dynamic> j) => PipesState((j['turns'] as List).cast<int>());
}

int? neighbor(int i, int d, int rows, int cols) {
  final r = i ~/ cols, c = i % cols;
  return switch (d) {
    dN => r > 0 ? i - cols : null,
    dS => r < rows - 1 ? i + cols : null,
    dW => c > 0 ? i - 1 : null,
    _ => c < cols - 1 ? i + 1 : null,
  };
}

List<int> currentMasks(PipesPuzzle p, PipesState s) =>
    [for (var i = 0; i < p.masks.length; i++) rotateMask(p.masks[i], s.turns[i])];

/// Tiles reachable from the source through matching connections.
Set<int> litTiles(PipesPuzzle p, List<int> m) {
  final seen = <int>{p.source};
  final q = Queue<int>()..add(p.source);
  while (q.isNotEmpty) {
    final i = q.removeFirst();
    for (final d in dirs) {
      if (m[i] & d == 0) continue;
      final j = neighbor(i, d, p.rows, p.cols);
      if (j != null && m[j] & opposite(d) != 0 && seen.add(j)) q.add(j);
    }
  }
  return seen;
}

/// Tiles with a connection that leads nowhere (off-board or unmatched).
Set<int> looseTiles(PipesPuzzle p, List<int> m) {
  final bad = <int>{};
  for (var i = 0; i < m.length; i++) {
    for (final d in dirs) {
      if (m[i] & d == 0) continue;
      final j = neighbor(i, d, p.rows, p.cols);
      if (j == null || m[j] & opposite(d) == 0) bad.add(i);
    }
  }
  return bad;
}

/// Every tile lit, no loose ends and no loops (edges = tiles - 1).
bool pipesSolved(PipesPuzzle p, List<int> m) {
  if (litTiles(p, m).length != m.length || looseTiles(p, m).isNotEmpty) return false;
  var edges = 0;
  for (var i = 0; i < m.length; i++) {
    if (m[i] & dE != 0) edges++;
    if (m[i] & dS != 0) edges++;
  }
  return edges == m.length - 1;
}
