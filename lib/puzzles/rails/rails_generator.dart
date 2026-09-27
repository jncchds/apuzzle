import 'dart:math';

import '../../core/difficulty.dart';
import '../../core/lattice_loop.dart';
import 'rails_model.dart';
import 'rails_solver.dart';

/// A random loop through cell centres, cut between a cell on the left edge and
/// one on the bottom edge → the longer arc is the track, every piece shown →
/// hide pieces while the difficulty's tier still solves it.
RailsPuzzle generateRails(GenParams params) {
  final rows = params.size.rows, cols = params.size.cols, n = rows * cols;
  final rng = Random(params.seed);
  final d = params.difficulty;
  final tier = d == Difficulty.easy ? 1 : 2;
  final g = LatticeLoop(rows, cols);
  RailsPuzzle? fallback;

  for (var attempt = 0; attempt < 40; attempt++) {
    final region = randomLoopRegion(rows - 1, cols - 1, rng, 0.45 + rng.nextDouble() * 0.25);
    final cycle = _cycle(g, g.boundary(region));
    final lefts = [
      for (var k = 0; k < cycle.length; k++)
        if (cycle[k] % cols == 0) k,
    ];
    final bottoms = [
      for (var k = 0; k < cycle.length; k++)
        if (cycle[k] ~/ cols == rows - 1) k,
    ];
    if (lefts.isEmpty || bottoms.isEmpty) continue;
    final a = lefts[rng.nextInt(lefts.length)], b = bottoms[rng.nextInt(bottoms.length)];
    if (a == b) continue;
    // The two arcs from a to b; keep the longer one.
    final len = cycle.length;
    final forward = [for (var k = a; k != b; k = (k + 1) % len) cycle[k], cycle[b]];
    final backward = [for (var k = a; k != b; k = (k - 1 + len) % len) cycle[k], cycle[b]];
    final track = forward.length >= backward.length ? forward : backward;
    if (track.length < n * 0.3) continue;

    final lines = List<bool>.filled(g.edgeCount, false);
    for (var k = 1; k < track.length; k++) {
      lines[g.between(track[k - 1], track[k])] = true;
    }
    final given = List<bool>.filled(n, false);
    for (final i in track) {
      given[i] = true;
    }
    RailsPuzzle build() => RailsPuzzle(
      rows: rows,
      cols: cols,
      entry: track.first,
      exit: track.last,
      rowCounts: [for (var r = 0; r < rows; r++) track.where((i) => i ~/ cols == r).length],
      colCounts: [for (var c = 0; c < cols; c++) track.where((i) => i % cols == c).length],
      given: List.of(given),
      lines: lines,
    );

    bool solvesAt(int t) {
      final s = RailsSolver(build());
      return s.solve(s.initial(), t);
    }

    // Tier-1 logic is much cheaper, so try it first.
    bool solvable(int t) => solvesAt(1) || (t > 1 && solvesAt(t));

    final keep = switch (d) {
      Difficulty.easy => 0.25,
      Difficulty.medium => 0.08,
      _ => 0.0,
    };
    for (final i in List.of(track)..shuffle(rng)) {
      if (rng.nextDouble() < keep) continue;
      given[i] = false;
      if (!solvable(tier)) given[i] = true;
    }
    final puzzle = build();
    if (tier == 2 && solvesAt(1)) {
      fallback ??= puzzle;
      continue;
    }
    return puzzle;
  }
  return fallback ?? generateRails(params.withSeed(params.seed + 1));
}

/// Cells of the loop [lines] in order around it.
List<int> _cycle(LatticeLoop g, List<bool> lines) {
  final start = List.generate(g.vertexCount, (p) => p).firstWhere((p) => g.incident[p].any((e) => lines[e]));
  final out = <int>[];
  var prev = -1, cur = start;
  do {
    out.add(cur);
    final next = [
      for (final e in g.incident[cur])
        if (lines[e])
          if (g.ends(e) case (final a, final b)) a == cur ? b : a,
    ].firstWhere((q) => q != prev);
    prev = cur;
    cur = next;
  } while (cur != start);
  return out;
}
