import 'dart:math';

import '../../core/difficulty.dart';
import '../../core/grid_graph.dart';
import 'layers_model.dart';
import 'layers_solver.dart';

int layersTier(Difficulty d) => switch (d) {
  Difficulty.easy => 1,
  Difficulty.medium => 2,
  _ => 3,
};

/// Colors on a board of [n] at [d].
int layersColors(int n, Difficulty d) => d == Difficulty.hard && n >= 6 ? 3 : 2;

/// Cells bitten out of the board from its edge: the rest stays one piece,
/// and every line keeps at least [n] / 2 + 1 cells.
Set<int> layersHoles(int rows, int cols, Random rng, int count) {
  final holes = <int>{};
  final nb = orthNeighbors(rows, cols);
  bool outside(int i) {
    final r = i ~/ cols, c = i % cols;
    return r == 0 || c == 0 || r == rows - 1 || c == cols - 1 || nb[i].any(holes.contains);
  }

  int left(int i, bool row) => row
      ? List.generate(cols, (c) => (i ~/ cols) * cols + c).where((j) => !holes.contains(j)).length
      : List.generate(rows, (r) => r * cols + i % cols).where((j) => !holes.contains(j)).length;
  for (var tries = 0; holes.length < count && tries < count * 20; tries++) {
    final i = rng.nextInt(rows * cols);
    if (holes.contains(i) || !outside(i)) continue;
    if (left(i, true) <= cols ~/ 2 + 1 || left(i, false) <= rows ~/ 2 + 1) continue;
    holes.add(i);
    if (components(nb, (j) => !holes.contains(j)).length != 1) holes.remove(i);
  }
  return holes;
}

/// Random line colors (each color on a row and on a column), a random
/// order and shape; then cells taken away in random order while logic up
/// to the difficulty's tier still finds them. Medium and hard then hide
/// line colors and strip more while their tier still solves the board.
/// Medium and hard keep the first board the tier below can't finish, else
/// the one with the fewest givens.
LayersPuzzle generateLayers(GenParams params) {
  final rows = params.size.rows, cols = params.size.cols, cells = rows * cols, lines = rows + cols;
  final rng = Random(params.seed);
  final tier = layersTier(params.difficulty);
  final colors = layersColors(min(rows, cols), params.difficulty);
  LayersPuzzle? best;

  for (var attempt = 0; attempt < 40; attempt++) {
    final holes = layersHoles(rows, cols, rng, rng.nextInt(cells ~/ 8 + 1));
    List<int> lineColors;
    do {
      lineColors = [for (var l = 0; l < lines; l++) rng.nextInt(colors)];
    } while (!List.generate(colors, (v) => v).every(
      (v) => lineColors.take(rows).contains(v) && lineColors.skip(rows).contains(v),
    ));
    final order = List.generate(lines, (l) => l)..shuffle(rng);
    final picture = layersPaint(rows, cols, lineColors, order, holes);
    final givens = {
      for (var i = 0; i < cells; i++)
        if (!holes.contains(i)) i,
    };
    var hidden = <int>[];
    LayersPuzzle make() => LayersPuzzle(
      rows: rows,
      cols: cols,
      colors: colors,
      lineColors: lineColors,
      picture: picture,
      givens: givens.toList()..sort(),
      hidden: hidden..sort(),
    );
    bool solves(int t) {
      final p = make();
      final s = LayersSolver(p);
      return s.slack(t, s.start()) == 0;
    }

    void strip(int t) {
      for (final i in givens.toList()..shuffle(rng)) {
        givens.remove(i);
        if (!solves(t)) givens.add(i);
      }
    }

    strip(min(tier, 2));
    if (tier >= 2) {
      // Hide line colors while the tier still works them out, then strip more.
      for (final l in List.generate(lines, (l) => l)..shuffle(rng)) {
        if (hidden.length >= lines ~/ (tier == 2 ? 4 : 3)) break;
        hidden = [...hidden, l];
        if (!solves(tier)) hidden = hidden.where((x) => x != l).toList();
      }
      strip(tier);
    }
    final puzzle = make();
    if (tier == 1) return puzzle;
    final s = LayersSolver(puzzle);
    if (s.slack(tier - 1, s.start()) > 0) return puzzle;
    if (best == null || puzzle.givens.length < best.givens.length) best = puzzle;
  }
  return best!;
}
