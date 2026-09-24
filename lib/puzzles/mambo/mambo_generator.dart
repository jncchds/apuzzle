import 'dart:math';

import '../../core/difficulty.dart';
import 'mambo_model.dart';
import 'mambo_solver.dart';

/// Clue = either a given cell (index) or an edge constraint.
class _Clue {
  const _Clue.cell(this.cell) : edge = null;
  const _Clue.edge(this.edge) : cell = -1;
  final int cell;
  final MamboEdge? edge;
}

/// Builds a random solution, then strips clues while the puzzle stays solvable
/// by the tier of logic allowed for the difficulty.
MamboPuzzle generateMambo(GenParams params) {
  final n = params.size.rows;
  final rng = Random(params.seed);
  final d = params.difficulty;
  MamboPuzzle? fallback;

  for (var attempt = 0; attempt < 6; attempt++) {
    final solution = MamboSolver(n, const []).randomSolution(rng)!;

    // Candidate edges: a random subset of all adjacent pairs.
    final allEdges = <MamboEdge>[];
    for (var r = 0; r < n; r++) {
      for (var c = 0; c < n; c++) {
        final i = r * n + c;
        if (c + 1 < n) allEdges.add(MamboEdge(i, i + 1, solution[i] == solution[i + 1]));
        if (r + 1 < n) allEdges.add(MamboEdge(i, i + n, solution[i] == solution[i + n]));
      }
    }
    allEdges.shuffle(rng);
    final edgeCount = (n * n * 0.3).round();

    // Try removing given cells before edge clues so puzzles keep some =/×.
    final clues = <_Clue>[
      ...([for (var i = 0; i < n * n; i++) _Clue.cell(i)]..shuffle(rng)),
      ...([for (final e in allEdges.take(edgeCount)) _Clue.edge(e)]..shuffle(rng)),
    ];
    final active = List<bool>.filled(clues.length, true);

    bool solvable(int tier) {
      final g = List.filled(n * n, -1);
      final edges = <MamboEdge>[];
      for (var k = 0; k < clues.length; k++) {
        if (!active[k]) continue;
        final cl = clues[k];
        if (cl.edge != null) {
          edges.add(cl.edge!);
        } else {
          g[cl.cell] = solution[cl.cell];
        }
      }
      return MamboSolver(n, edges).solveLogic(g, tier);
    }

    int activeCount() => active.where((a) => a).length;

    // Easy keeps extra clues; medium/hard strip to a minimal set.
    final keep = switch (d) {
      Difficulty.easy => (n * n * 0.42).round(),
      _ => 0,
    };

    // Pass 1: tier-1 logic only (cheap).
    for (var k = 0; k < clues.length && activeCount() > keep; k++) {
      active[k] = false;
      if (!solvable(1)) active[k] = true;
    }
    // Pass 2 (hard+): allow probing for the remaining clues.
    if (d.index >= Difficulty.hard.index) {
      for (var k = 0; k < clues.length; k++) {
        if (!active[k]) continue;
        active[k] = false;
        if (!solvable(2)) active[k] = true;
      }
    }

    final givens = List<int?>.filled(n * n, null);
    final edges = <MamboEdge>[];
    for (var k = 0; k < clues.length; k++) {
      if (!active[k]) continue;
      final cl = clues[k];
      if (cl.edge != null) {
        edges.add(cl.edge!);
      } else {
        givens[cl.cell] = solution[cl.cell];
      }
    }
    edges.sort((a, b) => a.a != b.a ? a.a.compareTo(b.a) : a.b.compareTo(b.b));
    final puzzle = MamboPuzzle(n: n, givens: givens, solution: solution, edges: edges);

    // Hard should genuinely need tier 2; retry a few times if it doesn't.
    if (d.index >= Difficulty.hard.index && n >= 6) {
      final g = [for (final v in givens) v ?? -1];
      if (MamboSolver(n, edges).solveLogic(g, 1)) {
        fallback ??= puzzle;
        continue;
      }
    }
    return puzzle;
  }
  return fallback!;
}
