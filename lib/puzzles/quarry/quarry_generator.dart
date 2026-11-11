import 'dart:math';

import '../../core/difficulty.dart';
import '../../core/grid_graph.dart';
import 'quarry_model.dart';
import 'quarry_solver.dart';

int quarryTier(Difficulty d) => switch (d) {
  Difficulty.easy => 1,
  Difficulty.medium => 2,
  _ => 3,
};

/// The stone sizes of an n × n board, biggest first (about a third of the
/// cells).
List<int> quarrySizes(int n) => switch (n) {
  <= 5 => const [4, 4, 3],
  6 => const [5, 4, 4],
  7 => const [5, 5, 4, 4],
  8 => const [5, 5, 5, 4, 4],
  9 => const [5, 5, 5, 5, 4, 4],
  _ => const [5, 5, 5, 5, 5, 5, 4, 4],
};

/// Distinct random stones of the sizes [quarrySizes] asks for.
List<int> quarryPickPieces(int n, Random rng) {
  final out = <int>[];
  for (final size in quarrySizes(n)) {
    final options = [
      for (var k = 0; k < quarryShapes.length; k++)
        if (quarryShapes[k].size == size && !out.contains(k)) k,
    ];
    out.add(options[rng.nextInt(options.length)]);
  }
  return out;
}

/// The stones laid at random, apart and not touching, with the other cells
/// in one area; null when it doesn't work out.
List<bool>? quarryLayout(int n, List<int> pieces, Random rng) {
  final cells = n * n;
  final nb = orthNeighbors(n, n);
  for (var attempt = 0; attempt < 40; attempt++) {
    final shaded = List<bool>.filled(cells, false);
    final blocked = List<bool>.filled(cells, false);
    var ok = true;
    for (final k in pieces) {
      final orients = quarryOrientations(quarryShapes[k].cells);
      var placed = false;
      for (var tries = 0; tries < 200 && !placed; tries++) {
        final o = orients[rng.nextInt(orients.length)];
        final (h, w) = quarryExtent(o);
        final r0 = rng.nextInt(n - h + 1), c0 = rng.nextInt(n - w + 1);
        final cs = [for (final (r, c) in o) (r0 + r) * n + c0 + c];
        if (cs.any((i) => blocked[i])) continue;
        for (final i in cs) {
          shaded[i] = true;
          blocked[i] = true;
          for (final j in nb[i]) {
            blocked[j] = true;
          }
        }
        placed = true;
      }
      if (!placed) {
        ok = false;
        break;
      }
    }
    if (ok && components(nb, (i) => !shaded[i]).length == 1) return shaded;
  }
  return null;
}

/// A random layout, circles added on cells the tier leaves open until it
/// solves the board, then circles taken away in random order while it still
/// does (hard adds with tier 2, then strips with probing). Medium and hard
/// keep the best of several boards by how far the tier below gets.
QuarryPuzzle generateQuarry(GenParams params) {
  final n = params.size.rows, cells = n * n;
  final rng = Random(params.seed);
  final tier = quarryTier(params.difficulty);
  final tries = switch (params.difficulty) {
    Difficulty.easy => 1,
    Difficulty.medium => 6,
    _ => 8,
  };
  // Circles hard tries to take away with probing.
  final probeTries = n <= 7 ? 12 : 8;
  QuarryPuzzle? best;
  var bestScore = -1, scored = 0;
  for (var attempt = 0; attempt < 40; attempt++) {
    final pieces = quarryPickPieces(n, rng);
    final shaded = quarryLayout(n, pieces, rng);
    if (shaded == null) continue;
    final solver = QuarrySolver(
      QuarryPuzzle(n: n, pieces: pieces, clues: List<int?>.filled(cells, null), shaded: shaded),
    );
    final clues = List<int?>.filled(cells, null);
    List<int> st0() => [for (final c in clues) c ?? -1];

    final addTier = min(tier, 2);
    var stuck = false;
    while (true) {
      final st = st0();
      if (!solver.solve(st, addTier)) {
        stuck = true;
        break;
      }
      final open = [
        for (var i = 0; i < cells; i++)
          if (st[i] == -1) i,
      ];
      if (open.isEmpty) break;
      final i = open[rng.nextInt(open.length)];
      clues[i] = shaded[i] ? quarryShade : quarryKeep;
    }
    if (stuck) continue;

    // Strip circles while the tier solves; hard strips with tier 2 first,
    // then tries a few more with probing.
    final order = [
      for (var i = 0; i < cells; i++)
        if (clues[i] != null) i,
    ]..shuffle(rng);
    for (final i in order) {
      final old = clues[i];
      clues[i] = null;
      if (solver.slack(addTier, st0()) != 0) clues[i] = old;
    }
    if (tier == 3) {
      final more = [
        for (var i = 0; i < cells; i++)
          if (clues[i] != null) i,
      ]..shuffle(rng);
      for (final i in more.take(probeTries)) {
        final old = clues[i];
        clues[i] = null;
        if (solver.slack(3, st0()) != 0) clues[i] = old;
      }
    }

    final puzzle = QuarryPuzzle(n: n, pieces: pieces, clues: List.of(clues), shaded: shaded);
    if (tier == 1) return puzzle;
    final below = solver.slack(tier - 1, st0());
    final int score = (below > 0 ? 1000 : 0) + min(below, cells ~/ 2);
    if (score > bestScore) (best, bestScore) = (puzzle, score);
    if (below > 0 && ++scored >= tries) break;
  }
  return best ?? generateQuarry(params.withSeed(params.seed + 1));
}
