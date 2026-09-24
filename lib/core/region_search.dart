import 'dart:math';

/// Local search over a region map on an n×n grid, for generators whose puzzle
/// is the region layout itself (the solution stays fixed).
///
/// A move hands one unpinned cell to a neighbouring region, keeping the
/// region it leaves connected. Pinned cells (the solution's own cells) never
/// move, so every region keeps its part of the solution.
class RegionSearch {
  RegionSearch(this.n, this.regions, this.pinned, this.rng)
      : nb = List.generate(n * n, (i) {
          final r = i ~/ n, c = i % n;
          return [if (r > 0) i - n, if (r < n - 1) i + n, if (c > 0) i - 1, if (c < n - 1) i + 1];
        }),
        movable = [for (var i = 0; i < n * n; i++) if (!pinned[i]) i];

  final int n;
  final List<int> regions;
  final List<bool> pinned;
  final Random rng;
  final List<List<int>> nb;
  final List<int> movable;

  /// Applies a random legal move and returns an undo callback, or null if the
  /// sampled cell couldn't move.
  void Function()? randomMove() {
    if (movable.isEmpty) return null;
    final x = movable[rng.nextInt(movable.length)];
    final from = regions[x];
    return moveCell(x) ? () => regions[x] = from : null;
  }

  /// Hands unpinned cell [x] to a random neighbouring region if that keeps
  /// its current region connected.
  bool moveCell(int x) {
    if (pinned[x]) return false;
    final from = regions[x];
    final targets = {for (final j in nb[x]) if (regions[j] != from && regions[j] >= 0) regions[j]}.toList();
    if (targets.isEmpty || !_connectedWithout(from, x)) return false;
    regions[x] = targets[rng.nextInt(targets.length)];
    return true;
  }

  /// Drives [cost] down to 0 with random moves, accepting sideways ones so the
  /// search can cross plateaus. With a [temperature] > 0 it anneals: worse
  /// moves are sometimes taken early on, and the best layout seen is kept.
  /// Returns whether it reached 0.
  bool minimize(int Function() cost, {required int budget, double temperature = 0}) {
    var current = cost();
    var best = current;
    var bestLayout = temperature > 0 ? List.of(regions) : null;
    for (var it = 0; it < budget && current > 0; it++) {
      final undo = randomMove();
      if (undo == null) continue;
      final c = cost();
      final t = temperature * (1 - it / budget);
      if (c <= current || (t > 0 && rng.nextDouble() < exp((current - c) / t))) {
        current = c;
        if (c < best && bestLayout != null) {
          best = c;
          bestLayout = List.of(regions);
        }
      } else {
        undo();
      }
    }
    if (bestLayout != null && current > best) regions.setAll(0, bestLayout);
    return current == 0 || best == 0;
  }

  /// Raises [score] to at least [goal], only accepting moves that keep [valid]
  /// true and don't lower the score. Returns whether the goal was reached.
  bool harden(bool Function() valid, int Function() score, {required int budget, int goal = 1}) {
    var current = score();
    for (var it = 0; it < budget && current < goal; it++) {
      final undo = randomMove();
      if (undo == null) continue;
      final s = score();
      if (s >= current && valid()) {
        current = s;
      } else {
        undo();
      }
    }
    return current >= goal;
  }

  bool _connectedWithout(int region, int removed) {
    var start = -1, total = 0;
    for (var i = 0; i < n * n; i++) {
      if (regions[i] == region && i != removed) {
        total++;
        start = i;
      }
    }
    if (start < 0) return false;
    final seen = {start};
    final stack = [start];
    while (stack.isNotEmpty) {
      for (final j in nb[stack.removeLast()]) {
        if (j != removed && regions[j] == region && seen.add(j)) stack.add(j);
      }
    }
    return seen.length == total;
  }
}
