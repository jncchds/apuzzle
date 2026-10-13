import '../../core/grid.dart';
import '../../core/grid_graph.dart';

/// Tentai Show: split the grid into regions, one per star. A region holds
/// its star in its exact middle, looks the same after half a turn around
/// it, and is one connected piece.
///
/// Stars sit on a lattice twice as fine as the cells: cell (r, c) has its
/// centre at (2r + 1, 2c + 1), so a star at (y, x) is on a cell centre (both
/// odd), on a side (one even) or on a corner (both even).
class OrbitsPuzzle {
  const OrbitsPuzzle({required this.rows, required this.cols, required this.stars, required this.solution});

  final int rows;
  final int cols;

  /// Stars as `y * 2 * cols + x`.
  final List<int> stars;

  /// The star (index) of every cell.
  final List<int> solution;

  GridSize get size => GridSize(rows, cols);
  OrbitsGeometry get geo => _geo[this] ??= OrbitsGeometry(rows, cols, stars);
  static final _geo = Expando<OrbitsGeometry>();

  Map<String, dynamic> toJson() => {'rows': rows, 'cols': cols, 'stars': stars, 'solution': solution};

  factory OrbitsPuzzle.fromJson(Map<String, dynamic> j) => OrbitsPuzzle(
    rows: j['rows'] as int,
    cols: j['cols'] as int,
    stars: (j['stars'] as List).cast<int>(),
    solution: (j['solution'] as List).cast<int>(),
  );
}

/// The player's board: the star each cell belongs to, or -1. The cells a
/// star lies on are its own from the start.
class OrbitsState {
  const OrbitsState(this.owner);

  final List<int> owner;

  Map<String, dynamic> toJson() => {'owner': owner};
  factory OrbitsState.fromJson(Map<String, dynamic> j) => OrbitsState((j['owner'] as List).cast<int>());
}

/// Where the stars are, and what that means for cells.
class OrbitsGeometry {
  OrbitsGeometry(this.rows, this.cols, List<int> stars)
    : n = rows * cols,
      count = stars.length,
      nb = orthNeighbors(rows, cols),
      ys = [for (final s in stars) s ~/ (2 * cols)],
      xs = [for (final s in stars) s % (2 * cols)],
      home = List<int>.filled(rows * cols, -1) {
    core = [
      for (var k = 0; k < count; k++)
        [
          for (var r = (ys[k] - 1) >> 1; r <= ys[k] >> 1; r++)
            for (var c = (xs[k] - 1) >> 1; c <= xs[k] >> 1; c++) r * cols + c,
        ],
    ];
    for (var k = 0; k < count; k++) {
      for (final i in core[k]) {
        home[i] = k;
      }
    }
  }

  final int rows;
  final int cols;
  final int n;
  final int count;
  final List<List<int>> nb;
  final List<int> ys;
  final List<int> xs;

  /// The cells each star lies on (1, 2 or 4).
  late final List<List<int>> core;

  /// The star lying on each cell, or -1.
  final List<int> home;

  /// The cell opposite [i] across star [k], or -1 if that is off the board.
  int twin(int i, int k) {
    final r = ys[k] - 1 - i ~/ cols, c = xs[k] - 1 - i % cols;
    return r < 0 || c < 0 || r >= rows || c >= cols ? -1 : r * cols + c;
  }

  /// Whether [i] and its twin are both free for star [k]: on the board and
  /// not under another star.
  bool fits(int i, int k) {
    final j = twin(i, k);
    return j >= 0 && (home[i] < 0 || home[i] == k) && (home[j] < 0 || home[j] == k);
  }

  List<int> initial() => List.of(home);

  /// The cells of [owner] joined to their star's own cells through their
  /// region.
  List<bool> joined(List<int> owner) {
    final seen = List<bool>.filled(n, false);
    for (var k = 0; k < count; k++) {
      final queue = [
        for (final i in core[k])
          if (owner[i] == k) i,
      ];
      for (final i in queue) {
        seen[i] = true;
      }
      for (var q = 0; q < queue.length; q++) {
        for (final j in nb[queue[q]]) {
          if (!seen[j] && owner[j] == k) {
            seen[j] = true;
            queue.add(j);
          }
        }
      }
    }
    return seen;
  }

  /// Cells that break a rule: cut off from their star, or without a twin in
  /// the same region.
  Set<int> bad(List<int> owner) {
    final ok = joined(owner);
    return {
      for (var i = 0; i < n; i++)
        if (owner[i] >= 0 && (!ok[i] || twin(i, owner[i]) < 0 || owner[twin(i, owner[i])] != owner[i])) i,
    };
  }

  bool valid(List<int> owner) => !owner.contains(-1) && bad(owner).isEmpty;

  /// [owner] with [i] and its twin given to star [k] (-1 clears [i] and its
  /// twin). A cell taken from another star takes its twin there along, so
  /// regions stay symmetric. Null if nothing changes or it can't be done.
  List<int>? paint(List<int> owner, int i, int k) {
    final out = List.of(owner);
    void clear(int j) {
      final old = out[j];
      if (old < 0 || home[j] >= 0) return;
      out[j] = -1;
      final t = twin(j, old);
      if (t >= 0 && out[t] == old && home[t] < 0) out[t] = -1;
    }

    if (k < 0) {
      if (owner[i] < 0 || home[i] >= 0) return null;
      clear(i);
      return out;
    }
    if (owner[i] == k || !fits(i, k)) return null;
    final j = twin(i, k);
    clear(i);
    clear(j);
    out[i] = k;
    out[j] = k;
    return out;
  }
}
