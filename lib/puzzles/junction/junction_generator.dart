import 'dart:math';

import '../../core/difficulty.dart';
import '../../core/grid.dart';
import 'junction_model.dart';

/// Stations (symbols) on a board: more with the difficulty and the board
/// size, so bigger boards get more switches. At most 8.
int junctionStations(GridSize size, Difficulty d) {
  final side = min(size.rows, size.cols);
  final base = switch (d) {
    Difficulty.easy => 3,
    Difficulty.medium => 4,
    _ => 5,
  };
  final bonus = side >= 12
      ? 3
      : side >= 10
      ? 2
      : side >= 8
      ? 1
      : 0;
  return min(8, base + bonus);
}

/// Milliseconds from one cell to the next.
int junctionSpeed(Difficulty d) => switch (d) {
  Difficulty.easy => 700,
  Difficulty.medium => 520,
  _ => 400,
};

/// Steps between departures.
(int, int) junctionGaps(Difficulty d) => switch (d) {
  Difficulty.easy => (5, 8),
  Difficulty.medium => (4, 7),
  _ => (3, 5),
};

/// Switches stay this many steps from the depot, so the first train gives the
/// player a moment.
const junctionFirstSwitch = 3;

JunctionPuzzle generateJunction(GenParams params, JunctionGoal goal) {
  final rows = params.size.rows, cols = params.size.cols;
  final stations = junctionStations(params.size, params.difficulty);
  final rng = Random(params.seed);
  // The best of a few networks: the one that covers the most of the board.
  List<int>? best;
  var bestScore = -1, found = 0;
  for (var attempt = 0; attempt < 2000 && found < 24; attempt++) {
    final net = junctionNetwork(rows, cols, stations, rng);
    if (net == null) continue;
    found++;
    final score = net.where((p) => p != junctionOff).length;
    if (score > bestScore) {
      bestScore = score;
      best = net;
    }
  }
  final parent = best!;
  final leaves = [
    for (var i = 0; i < parent.length; i++)
      if (parent[i] != junctionOff && !parent.contains(i)) i,
  ]..shuffle(rng);
  final switches = [
    for (var i = 0; i < parent.length; i++)
      if (parent.where((p) => p == i).length > 1) i,
  ];
  final ms = junctionSpeed(params.difficulty);
  final (gapMin, gapMax) = junctionGaps(params.difficulty);
  return JunctionPuzzle(
    rows: rows,
    cols: cols,
    goal: goal,
    trains: goal == JunctionGoal.trains ? junctionTrainCount : 0,
    ticks: goal == JunctionGoal.timed ? (junctionRoundSeconds * 1000 / ms).round() : 0,
    seed: params.seed,
    stepMs: ms,
    gapMin: gapMin,
    gapMax: gapMax,
    parent: parent,
    stations: leaves,
    start: [for (final _ in switches) rng.nextInt(2)],
  );
}

/// A random track tree with [stations] leaves, or null if this try got
/// stuck: a trunk from a depot on the edge, then branches grown from plain
/// track cells. Track cells only touch the cells before and after them on
/// the track, switches never touch each other, and every branch is at least
/// two cells long.
List<int>? junctionNetwork(int rows, int cols, int stations, Random rng) {
  final n = rows * cols;
  final parent = List.filled(n, junctionOff);
  var depotCell = -1;
  final depth = List.filled(n, 0);
  final kids = List.filled(n, 0);
  bool on(int r, int c) => r >= 0 && c >= 0 && r < rows && c < cols;
  bool track(int i) => parent[i] != junctionOff;

  // The cell [d] away from [i], or -1 off the board.
  int step(int i, int d) {
    final (dr, dc) = junctionDirs[d];
    final r = i ~/ cols + dr, c = i % cols + dc;
    return on(r, c) ? r * cols + c : -1;
  }

  // A free cell whose only track neighbour would be [from].
  bool free(int i, int from) {
    if (i < 0 || track(i)) return false;
    for (var d = 0; d < 4; d++) {
      final m = step(i, d);
      if (m >= 0 && m != from && track(m)) return false;
    }
    return true;
  }

  // Grows a track from [from] heading [dir], up to [len] cells, mostly
  // straight. Returns the new cells.
  List<int> grow(int from, int dir, int len) {
    final cells = <int>[];
    var at = from, d = dir;
    while (cells.length < len) {
      final options = [
        for (final (turn, weight) in [(0, 4.0), (1, 1.0), (3, 1.0)])
          // Out of the depot straight in, never along the edge.
          if ((turn == 0 || from != depotCell || cells.isNotEmpty) && free(step(at, (d + turn) % 4), at))
            ((d + turn) % 4, weight),
      ];
      if (options.isEmpty) break;
      var pick = rng.nextDouble() * options.fold(0.0, (a, o) => a + o.$2);
      var nd = options.last.$1;
      for (final (od, w) in options) {
        pick -= w;
        if (pick < 0) {
          nd = od;
          break;
        }
      }
      final next = step(at, nd);
      parent[next] = at;
      depth[next] = depth[at] + 1;
      kids[at]++;
      cells.add(next);
      at = next;
      d = nd;
    }
    return cells;
  }

  void undo(List<int> cells) {
    for (final i in cells.reversed) {
      kids[parent[i]]--;
      parent[i] = junctionOff;
    }
  }

  // The depot: on a random side, not in a corner, heading in.
  final side = rng.nextInt(4);
  final along = side.isEven ? cols : rows;
  final k = 1 + rng.nextInt(along - 2);
  final depot = switch (side) {
    0 => k, // top
    1 => k * cols + cols - 1, // right
    2 => (rows - 1) * cols + k, // bottom
    _ => k * cols, // left
  };
  parent[depot] = junctionDepot;
  depotCell = depot;
  final trunk = grow(depot, (side + 2) % 4, (rows + cols) ~/ 2 + rng.nextInt(rows + cols));
  if (trunk.length < junctionFirstSwitch + 2) return null;

  var leaves = 1;
  while (leaves < stations) {
    // Plain track cells far enough from the depot, next to no switch, whose
    // track goes on for at least two more cells, with a free side.
    final spots = <(int, int)>[];
    for (var i = 0; i < n; i++) {
      if (parent[i] < 0 || kids[i] != 1 || depth[i] < junctionFirstSwitch || kids[parent[i]] > 1) continue;
      final child = parent.indexOf(i);
      if (kids[child] != 1) continue;
      for (var d = 0; d < 4; d++) {
        if (free(step(i, d), i)) spots.add((i, d));
      }
    }
    var grown = false;
    while (spots.isNotEmpty && !grown) {
      final (at, d) = spots.removeAt(rng.nextInt(spots.length));
      if (!free(step(at, d), at)) continue;
      final branch = grow(at, d, 2 + rng.nextInt(rows + cols));
      if (branch.length >= 2) {
        grown = true;
      } else {
        undo(branch);
      }
    }
    if (!grown) return null;
    leaves++;
  }
  return parent;
}
