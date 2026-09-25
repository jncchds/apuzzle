import 'dart:math';

import '../../core/difficulty.dart';
import '../../core/lattice_loop.dart';
import 'pearls_model.dart';
import 'pearls_solver.dart';

/// Random loop through cell centres → a pearl wherever the loop allows one →
/// reshape the loop where the logic stays undecided → drop pearls while the
/// difficulty's tier still solves it.
PearlsPuzzle generatePearls(GenParams params) {
  final rows = params.size.rows, cols = params.size.cols, n = rows * cols;
  final rng = Random(params.seed);
  final d = params.difficulty;
  final tier = d == Difficulty.easy ? 1 : 2;
  final g = LatticeLoop(rows, cols);
  PearlsPuzzle? fallback;

  final fc = cols - 1;
  for (var attempt = 0; attempt < 30; attempt++) {
    final region = LoopRegion(rows - 1, fc)..grow(rng, 0.45 + rng.nextDouble() * 0.2);
    var lines = g.boundary(region.inside);
    var pearls = _allPearls(g, lines);

    // Local search on the loop's shape: flip squares next to undecided edges
    // while that doesn't leave more undecided.
    List<int> decide() {
      final s = PearlsSolver(rows, cols, pearls);
      final st = s.initial();
      s.solve(st, 2);
      return st;
    }

    var st = decide();
    var score = st.where((x) => x == -1).length;
    for (var step = 0; step < n * 2 && score > 0; step++) {
      final options = <int>{
        for (var e = 0; e < st.length; e++)
          if (st[e] == -1)
            for (final f in _faces(g, e, rows - 1, fc))
              if (region.canToggle(f)) f,
      }.toList();
      if (options.isEmpty) break;
      final f = options[rng.nextInt(options.length)];
      region.inside[f] = !region.inside[f];
      final oldLines = lines, oldPearls = pearls;
      lines = g.boundary(region.inside);
      pearls = _allPearls(g, lines);
      final nextSt = decide();
      final next = nextSt.where((x) => x == -1).length;
      if (next <= score) {
        score = next;
        st = nextSt;
      } else {
        region.inside[f] = !region.inside[f];
        lines = oldLines;
        pearls = oldPearls;
      }
    }
    if (score > 0) continue;

    bool solvesAt(int t) {
      final s = PearlsSolver(rows, cols, pearls);
      return s.solve(s.initial(), t);
    }

    // Tier-1 logic is much cheaper, so try it first.
    bool solvable(int t) => solvesAt(1) || (t > 1 && solvesAt(t));

    if (!solvable(tier)) continue;
    final keep = switch (d) {
      Difficulty.easy => 0.3,
      Difficulty.medium => 0.15,
      _ => 0.0,
    };
    for (final p in [for (var p = 0; p < n; p++) if (pearls[p] != pearlNone) p]..shuffle(rng)) {
      if (rng.nextDouble() < keep) continue;
      final v = pearls[p];
      pearls[p] = pearlNone;
      if (!solvable(tier)) pearls[p] = v;
    }
    final puzzle = PearlsPuzzle(rows: rows, cols: cols, pearls: pearls, lines: lines);
    if (tier == 2 && solvesAt(1)) {
      fallback ??= puzzle;
      continue;
    }
    return puzzle;
  }
  return fallback ?? generatePearls(params.withSeed(params.seed + 1));
}

/// A pearl on every loop cell that allows one.
List<int> _allPearls(LatticeLoop g, List<bool> lines) => [
      for (var p = 0; p < g.vertexCount; p++)
        if (!g.incident[p].any((e) => lines[e]))
          pearlNone
        else if (pearlMet(g, lines, p, pearlBlack))
          pearlBlack
        else if (pearlMet(g, lines, p, pearlWhite))
          pearlWhite
        else
          pearlNone,
    ];

/// The (up to two) unit squares on either side of edge [e].
List<int> _faces(LatticeLoop g, int e, int fr, int fc) {
  final (a, _) = g.ends(e);
  final r = a ~/ g.vc, c = a % g.vc;
  final sides = g.isHorizontal(e) ? [(r - 1, c), (r, c)] : [(r, c - 1), (r, c)];
  return [for (final (fr0, fc0) in sides) if (fr0 >= 0 && fc0 >= 0 && fr0 < fr && fc0 < fc) fr0 * fc + fc0];
}
