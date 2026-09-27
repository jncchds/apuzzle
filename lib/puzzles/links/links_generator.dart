import 'dart:math';

import '../../core/difficulty.dart';
import '../../core/grid_graph.dart';
import '../../core/lattice_loop.dart';
import 'links_model.dart';
import 'links_solver.dart';

/// A random path through every cell, cut into pieces (longer on harder
/// levels) → cut again wherever logic at the difficulty's tier stalls →
/// rejoin pieces end to end while logic still solves it, down to a pair
/// count per difficulty.
/// Logic solves are sound, so the solution is unique without a search.
LinksPuzzle generateLinks(GenParams params) {
  final rows = params.size.rows, cols = params.size.cols;
  final rng = Random(params.seed);
  final d = params.difficulty;
  final tier = d == Difficulty.easy ? 1 : 2;
  final (lo, hi, perPair) = switch (d) {
    Difficulty.easy => (4, 8, 5.5),
    Difficulty.medium => (5, 10, 7.0),
    _ => (6, 12, 9.0),
  };
  final g = LatticeLoop(rows, cols);

  bool solvesAt(List<List<int>> segs, int t) {
    final s = LinksSolver(rows, cols, _dots(rows * cols, segs));
    return s.solve(s.start(), t);
  }

  // Tier-1 logic is much cheaper, so try it first.
  bool solves(List<List<int>> segs) => solvesAt(segs, 1) || (tier > 1 && solvesAt(segs, tier));

  for (var attempt = 0; attempt < 20; attempt++) {
    final path = randomHamiltonianPath(rows, cols, rng);
    var segs = <List<int>>[];
    for (var at = 0; at < path.length;) {
      final len = lo + rng.nextInt(hi - lo + 1);
      segs.add(path.sublist(at, min(at + len, path.length)));
      at += len;
    }
    if (segs.length > 1 && segs.last.length < 3) segs[segs.length - 2].addAll(segs.removeLast());

    // Cut where the logic stalls.
    var ok = true;
    while (true) {
      final s = LinksSolver(rows, cols, _dots(rows * cols, segs));
      final st = s.decide(tier);
      if (s.solved(st)) break;
      final stuck = <int>{
        for (var e = 0; e < st.length; e++)
          if (st[e] == -1) ...[g.ends(e).$1, g.ends(e).$2],
      };
      final cuts = <(int, int)>[
        for (var k = 0; k < segs.length; k++)
          for (var i = 1; i + 2 < segs[k].length; i++)
            if (stuck.contains(segs[k][i]) || stuck.contains(segs[k][i + 1])) (k, i),
      ];
      if (cuts.isEmpty) {
        ok = false;
        break;
      }
      final (k, i) = cuts[rng.nextInt(cuts.length)];
      final seg = segs[k];
      segs[k] = seg.sublist(0, i + 1);
      segs.add(seg.sublist(i + 1));
    }
    if (!ok) continue;

    // Rejoin pieces whose ends touch while logic still solves the board,
    // down to about one pair per [perPair] cells.
    final target = (rows * cols / perPair).round();
    var progress = true;
    while (progress && segs.length > target) {
      progress = false;
      final joins = <(int, int)>[
        for (var a = 0; a < segs.length; a++)
          for (var b = a + 1; b < segs.length; b++)
            if (_join(segs[a], segs[b], cols) != null) (a, b),
      ]..shuffle(rng);
      for (final (a, b) in joins) {
        final next = [
          for (var k = 0; k < segs.length; k++)
            if (k != a && k != b) segs[k],
          _join(segs[a], segs[b], cols)!,
        ];
        if (solves(next)) {
          segs = next;
          progress = true;
          break;
        }
      }
    }
    segs.shuffle(rng);
    return LinksPuzzle(rows: rows, cols: cols, paths: segs);
  }
  return generateLinks(params.withSeed(params.seed + 7919));
}

List<int> _dots(int n, List<List<int>> segs) {
  final d = List<int>.filled(n, -1);
  for (var k = 0; k < segs.length; k++) {
    d[segs[k].first] = k;
    d[segs[k].last] = k;
  }
  return d;
}

/// [a] and [b] joined end to end if an end of one touches an end of the other.
List<int>? _join(List<int> a, List<int> b, int cols) {
  for (final x in [a, a.reversed.toList()]) {
    for (final y in [b, b.reversed.toList()]) {
      if (linksAdjacent(x.last, y.first, cols)) return [...x, ...y];
    }
  }
  return null;
}
