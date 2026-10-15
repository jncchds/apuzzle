import 'dart:math';

import '../../core/difficulty.dart';
import '../../core/grid_graph.dart';
import 'pebbles_model.dart';
import 'pebbles_solver.dart';

int pebblesTier(Difficulty d) => switch (d) {
  Difficulty.easy => 1,
  Difficulty.medium => 2,
  _ => 3,
};

/// A random solution: two interlocking combs, then random stones flipped
/// while both kinds stay in one group and no block holds four of a kind.
List<bool> pebblesLayout(int n, Random rng) {
  final filled = List<bool>.generate(n * n, (i) {
    final r = i ~/ n, c = i % n;
    return c == 0 || (r.isEven && c < n - 1);
  });
  final nb = orthNeighbors(n, n);
  bool blockOk(int i) {
    final r = i ~/ n, c = i % n;
    for (var r0 = max(0, r - 1); r0 <= min(r, n - 2); r0++) {
      for (var c0 = max(0, c - 1); c0 <= min(c, n - 2); c0++) {
        final t = r0 * n + c0;
        final v = filled[t];
        if (filled[t + 1] == v && filled[t + n] == v && filled[t + n + 1] == v) return false;
      }
    }
    return true;
  }

  bool connected(bool v) => components(nb, (i) => filled[i] == v).length == 1;
  for (var step = 0; step < n * n * 40; step++) {
    final i = rng.nextInt(n * n);
    final was = filled[i];
    // The stone must not be its group's only link, nor the last of its kind.
    filled[i] = !was;
    if (!blockOk(i) || !connected(was) || !connected(!was)) filled[i] = was;
  }
  // A random turn or mirror, and kinds swapped half the time.
  final swap = rng.nextBool(), turn = rng.nextInt(8);
  return List.generate(n * n, (i) {
    var r = i ~/ n, c = i % n;
    if (turn & 1 != 0) c = n - 1 - c;
    if (turn & 2 != 0) r = n - 1 - r;
    if (turn & 4 != 0) (r, c) = (c, r);
    return filled[r * n + c] != swap;
  });
}

/// A random solution, then stones taken away in random order while logic
/// up to the difficulty's tier still finds the rest. Medium and hard keep
/// the first board the tier below can't finish (about one in five on hard),
/// else their first try.
PebblesPuzzle generatePebbles(GenParams params) {
  final n = params.size.rows, cells = n * n;
  final rng = Random(params.seed);
  final tier = pebblesTier(params.difficulty);
  final solver = PebblesSolver(n);
  PebblesPuzzle? first;

  for (var attempt = 0; attempt < 24; attempt++) {
    final filled = pebblesLayout(n, rng);
    final p0 = PebblesPuzzle(n: n, filled: filled, givens: const []);
    final givens = {for (var i = 0; i < cells; i++) i};

    bool solves(int t) => solver.slack(t, solver.start(p0, givens.toList())) == 0;
    void strip(int t) {
      for (final i in givens.toList()..shuffle(rng)) {
        givens.remove(i);
        if (!solves(t)) givens.add(i);
      }
    }

    strip(tier);
    final puzzle = PebblesPuzzle(n: n, filled: filled, givens: givens.toList()..sort());
    if (tier == 1 || solver.slack(tier - 1, solver.start(puzzle)) > 0) return puzzle;
    first ??= puzzle;
  }
  return first!;
}
