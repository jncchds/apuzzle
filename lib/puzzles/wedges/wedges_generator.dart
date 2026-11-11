import 'dart:math';

import '../../core/difficulty.dart';
import 'wedges_model.dart';
import 'wedges_solver.dart';

/// The logic tier a difficulty aims for.
int wedgesTier(Difficulty d) => switch (d) {
  Difficulty.easy => 1,
  Difficulty.medium => 2,
  _ => 3,
};

/// Weights per value while filling a layout: four wedges, open, wall.
const _weights = [3, 3, 3, 3, 9, 3];

/// Fills every unsettled cell of [st] (candidate masks, walls allowed) in
/// random order, each with a random value the points round it still allow;
/// null when the cells can't be filled.
List<int>? _fill(WedgesSolver solver, List<int> st, Random rng) {
  if (!solver.propagate(st, 1)) return null;
  final order = List.generate(st.length, (i) => i)..shuffle(rng);
  for (final i in order) {
    while (st[i] & (st[i] - 1) != 0) {
      final opts = [
        for (var v = 0; v < 6; v++)
          if (st[i] & (1 << v) != 0) v,
      ];
      var total = 0;
      for (final v in opts) {
        total += _weights[v];
      }
      var pick = rng.nextInt(total);
      var v = opts.last;
      for (final o in opts) {
        pick -= _weights[o];
        if (pick < 0) {
          v = o;
          break;
        }
      }
      final w = List.of(st)..[i] = 1 << v;
      if (solver.propagate(w, 1)) {
        st.setAll(0, w);
      } else {
        st[i] &= ~(1 << v);
        if (!solver.propagate(st, 1)) return null;
      }
    }
  }
  return [for (final m in st) m.bitLength - 1];
}

WedgesSolver _blankSolver(int rows, int cols) => WedgesSolver(
  WedgesPuzzle(
    rows: rows,
    cols: cols,
    clues: List.filled(rows * cols, wedgesOpen),
    solution: List.filled(rows * cols, wedgeDot),
  ),
);

/// A random layout (walls, wedges and open cells with every open area a
/// rectangle): cells in random order each take a random value the points
/// round it still allow, walls and wedges weighted against open cells.
List<int> wedgesLayout(int rows, int cols, Random rng) {
  final solver = _blankSolver(rows, cols);
  while (true) {
    final v = _fill(solver, List<int>.filled(rows * cols, 0x3F), rng);
    if (v != null) return v;
  }
}

/// [sol] with a wall at [cell] and the cells round it drawn again (the rest
/// kept), or null when that doesn't work out.
List<int>? _wallAt(List<int> sol, int rows, int cols, int cell, Random rng) {
  final r0 = cell ~/ cols, c0 = cell % cols;
  for (final reach in const [1, 2]) {
    final st = [
      for (var i = 0; i < sol.length; i++)
        if (i == cell)
          1 << wedgeWall
        else if ((i ~/ cols - r0).abs() <= reach && (i % cols - c0).abs() <= reach)
          0x3F
        else
          1 << sol[i],
    ];
    final v = _fill(_blankSolver(rows, cols), st, rng);
    if (v != null) return v;
  }
  return null;
}

/// Every wall's number for [sol].
List<int> wedgesClues(WedgesGeometry g, List<int> sol) => [
  for (var i = 0; i < g.cells; i++) sol[i] == wedgeWall ? wedgesAround(g, sol, i) : wedgesOpen,
];

/// A random layout with every wall numbered, cells shown where the tier
/// still stalls, then numbers (and those cells) taken away in random order
/// while logic up to the tier solves the board (easy keeps at least half of
/// them; hard first strips at tier 2, then with probing). Medium and hard
/// keep the first of 24/40 boards the tier below can't finish, else the one
/// it gets least far with (for hard, then the one tier 1 gets least far
/// with).
WedgesPuzzle generateWedges(GenParams params) {
  final rows = params.size.rows, cols = params.size.cols;
  final rng = Random(params.seed);
  final target = wedgesTier(params.difficulty);
  final g = WedgesGeometry.of(rows, cols);
  final tries = switch (params.difficulty) {
    Difficulty.easy => 1,
    Difficulty.medium => 24,
    _ => 40,
  };

  WedgesPuzzle? best;
  var bestScore = -1;
  for (var attempt = 0; attempt < tries || best == null; attempt++) {
    var sol = wedgesLayout(rows, cols, rng);
    var clues = wedgesClues(g, sol);
    final givens = <int>[];
    WedgesPuzzle make() => WedgesPuzzle(rows: rows, cols: cols, clues: clues, solution: sol, givens: List.of(givens));
    bool solves(int tier) => WedgesSolver(make()).solveLogic(tier) != null;

    // Where even every number leaves the tier stuck, put a wall into a stuck
    // cell (drawing the cells round it again); as a last resort show cells.
    var repairs = 0;
    while (!solves(target)) {
      final st = WedgesSolver(make()).start();
      WedgesSolver(make()).propagate(st, target);
      final open = [
        for (var i = 0; i < g.cells; i++)
          if (st[i] & (st[i] - 1) != 0) i,
      ];
      final cell = open[rng.nextInt(open.length)];
      final fixed = repairs++ < 4 * rows ? _wallAt(sol, rows, cols, cell, rng) : null;
      if (fixed != null) {
        sol = fixed;
        clues = wedgesClues(g, sol);
        givens.removeWhere((i) => sol[i] == wedgeWall);
      } else {
        givens.add(cell);
      }
    }
    for (final tier in [if (target == 3) 2, target]) {
      final order = [
        for (var i = 0; i < g.cells; i++)
          if (clues[i] >= 0) i,
      ]..shuffle(rng);
      // Easy keeps at least half of the numbers.
      final strip = target == 1 ? order.length ~/ 2 : order.length;
      for (final i in order.take(strip)) {
        final keep = clues[i];
        clues[i] = wedgesPlain;
        if (!solves(tier)) clues[i] = keep;
      }
    }
    for (final i in List.of(givens)..shuffle(rng)) {
      givens.remove(i);
      if (!solves(target)) givens.add(i);
    }
    final puzzle = make();
    if (target == 1) return puzzle;
    // How far the tier below gets, then (for hard) how far tier 1 gets.
    final solver = WedgesSolver(puzzle);
    final slack = solver.slack(target - 1);
    final int score = slack * 4096 + (target == 3 ? min<int>(solver.slack(1), 4095) : 0);
    if (score > bestScore) {
      bestScore = score;
      best = puzzle;
    }
    if (slack > 0) break;
  }
  return best!;
}
