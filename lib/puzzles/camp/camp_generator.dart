import 'dart:math';

import '../../core/difficulty.dart';
import '../../core/grid_graph.dart';
import 'camp_model.dart';
import 'camp_solver.dart';

/// Random tent/tree pairs → all counts → must be solvable at the difficulty's
/// tier (retry, then reveal a tent where the logic stalls). Hard hides some
/// counts while it stays solvable.
CampPuzzle generateCamp(GenParams params) {
  final rows = params.size.rows, cols = params.size.cols, n = rows * cols;
  final rng = Random(params.seed);
  final d = params.difficulty;
  final tier = d == Difficulty.easy ? 1 : 2;
  final on = orthNeighbors(rows, cols);
  final kn = kingNeighbors(rows, cols);
  CampPuzzle? fallback;

  for (var attempt = 0; attempt < 12; attempt++) {
    final trees = List<bool>.filled(n, false);
    final tents = List<bool>.filled(n, false);
    final target = (n * (0.17 + rng.nextDouble() * 0.04)).round();
    var placed = 0;
    for (final i in [for (var i = 0; i < n; i++) i]..shuffle(rng)) {
      if (placed >= target) break;
      if (trees[i] || tents[i] || kn[i].any((j) => tents[j])) continue;
      final spots = [for (final j in on[i]) if (!trees[j] && !tents[j]) j];
      if (spots.isEmpty) continue;
      tents[i] = true;
      trees[spots[rng.nextInt(spots.length)]] = true;
      placed++;
    }
    List<int?> counts(bool byRow) => [
          for (var a = 0; a < (byRow ? rows : cols); a++)
            [for (var b = 0; b < (byRow ? cols : rows); b++) byRow ? a * cols + b : b * cols + a].where((i) => tents[i]).length,
        ];
    final rc = counts(true), cc = counts(false);
    final given = <int>[];

    CampSolver solver() => CampSolver(rows, cols, trees, rc, cc);
    bool solvable(int t) => solver().solve(solver().initial(givenTents: given), t);

    // Late attempts reveal tents where the logic gets stuck.
    if (!solvable(tier)) {
      if (attempt < 8) continue;
      while (true) {
        final s = solver();
        final st = s.initial(givenTents: given);
        if (s.solve(st, tier)) break;
        final open = [for (var i = 0; i < n; i++) if (tents[i] && st[i] == -1) i];
        if (open.isEmpty) break;
        given.add(open[rng.nextInt(open.length)]);
      }
      if (!solvable(tier)) continue;
    }

    if (d == Difficulty.hard) {
      final hideMax = (rows + cols) ~/ 3;
      var hidden = 0;
      for (final k in [for (var k = 0; k < rows + cols; k++) k]..shuffle(rng)) {
        if (hidden >= hideMax) break;
        final list = k < rows ? rc : cc;
        final at = k < rows ? k : k - rows;
        final keep = list[at];
        list[at] = null;
        if (solvable(tier)) {
          hidden++;
        } else {
          list[at] = keep;
        }
      }
    }

    final puzzle = CampPuzzle(
      rows: rows,
      cols: cols,
      trees: trees,
      tents: tents,
      rowCounts: rc,
      colCounts: cc,
      givenTents: given..sort(),
    );
    if (tier == 2 && solvable(1)) {
      fallback ??= puzzle;
      continue;
    }
    return puzzle;
  }
  return fallback ?? generateCamp(params.withSeed(params.seed + 1));
}
