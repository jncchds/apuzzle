import 'dart:math';

import '../../core/difficulty.dart';
import 'waymarks_model.dart';
import 'waymarks_solver.dart';

int waymarksTier(Difficulty d) => switch (d) {
  Difficulty.easy => 1,
  Difficulty.medium => 2,
  _ => 3,
};

/// A random path through every cell, each step any distance along one of
/// eight lines, every number shown; then numbers taken away in random order
/// while the difficulty's tier still solves the board (on hard first with
/// tier 2, then with probing). Medium and hard keep the best of several
/// boards by how far the tier below gets.
WaymarksPuzzle generateWaymarks(GenParams params) {
  final n = params.size.rows, cells = n * n;
  final rng = Random(params.seed);
  final tier = waymarksTier(params.difficulty);
  final tries = switch (params.difficulty) {
    Difficulty.easy => 1,
    Difficulty.medium => 10,
    _ => 16,
  };
  WaymarksPuzzle? best;
  var bestScore = -1 << 30;

  for (var attempt = 0; attempt < tries; attempt++) {
    final path = waymarksPath(n, rng);
    final shown = List<bool>.filled(cells, true);
    WaymarksPuzzle board() => WaymarksPuzzle(n: n, path: path, shown: List.of(shown));
    bool solves(int t) => WaymarksSolver(board()).slack(t) == 0;

    final order = [for (var x = 1; x + 1 < cells; x++) x]..shuffle(rng);
    for (final t in {min(tier, 2), tier}) {
      // Probing is slow on big boards: a few numbers taken away are enough
      // to need it.
      var left = t == 3 ? 4 : cells;
      for (final x in order) {
        if (!shown[x]) continue;
        shown[x] = false;
        if (!solves(t)) {
          shown[x] = true;
        } else if (--left == 0) {
          break;
        }
      }
    }
    final puzzle = board();
    if (tier == 1) return puzzle;
    // Score: the tier below should get stuck, the further behind the better.
    final below = WaymarksSolver(puzzle).slack(tier - 1);
    final score = (below > 0 ? 1000 : 0) + min(below, cells ~/ 3) * 4 - shown.where((s) => s).length;
    if (score > bestScore) (best, bestScore) = (puzzle, score);
    if (below >= cells ~/ 3) break;
  }
  return best!;
}

/// A random path through all n × n cells, each step to a cell on one of the
/// eight lines from the last (any distance): depth first, trying cells with
/// the fewest ways on first (ties at random), with backtracking.
List<int> waymarksPath(int n, Random rng) {
  final cells = n * n;
  final rays = [
    for (var i = 0; i < cells; i++) [for (var d = 0; d < 8; d++) ...waymarksRay(n, i, d)],
  ];
  while (true) {
    final used = List<bool>.filled(cells, false);
    final path = <int>[rng.nextInt(cells)];
    used[path.first] = true;
    var nodes = 0;
    bool rec() {
      if (path.length == cells) return true;
      if (++nodes > 20000) return false;
      final here = path.last;
      int onward(int j) => rays[j].where((x) => !used[x]).length;
      final next = [
        for (final j in rays[here])
          if (!used[j]) (j, onward(j) * 4 + rng.nextInt(6)),
      ]..sort((a, b) => a.$2.compareTo(b.$2));
      for (final (j, _) in next) {
        used[j] = true;
        path.add(j);
        if (rec()) return true;
        path.removeLast();
        used[j] = false;
        if (nodes > 20000) return false;
      }
      return false;
    }

    if (rec()) return path;
  }
}
