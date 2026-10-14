import 'dart:math';

import '../../core/difficulty.dart';
import 'channel_model.dart';
import 'channel_solver.dart';

/// How a difficulty builds its board.
class _Recipe {
  const _Recipe({
    required this.length,
    required this.tries,
    required this.shown,
    required this.lockRatio,
    required this.bridges,
    required this.weights,
  });

  /// Route length as a share of the board's tiles.
  final double length;

  /// Boards made; medium and hard keep the one hardest to follow.
  final int tries;

  /// Share of route tiles that start the right way round.
  final double shown;

  /// Share of other tiles fixed in place.
  final double lockRatio;

  /// Times the route may pass over itself (on a bridge).
  final int bridges;

  /// Weights of the tiles off the route: empty, dead end, straight, bend, T, bridge.
  final List<double> weights;
}

const _recipes = {
  Difficulty.easy: _Recipe(
    length: 0.3,
    tries: 3,
    shown: 0.3,
    lockRatio: 0.12,
    bridges: 0,
    weights: [3, 3, 2, 2, 0.5, 0],
  ),
  Difficulty.medium: _Recipe(
    length: 0.4,
    tries: 20,
    shown: 0.12,
    lockRatio: 0.04,
    bridges: 0,
    weights: [1, 1.5, 3, 4, 1.5, 0],
  ),
  Difficulty.hard: _Recipe(
    length: 0.48,
    tries: 40,
    shown: 0,
    lockRatio: 0,
    bridges: 3,
    weights: [0.4, 1, 3, 4.5, 1.2, 0.4],
  ),
};

const _shapes = [0, dN, dN | dS, dN | dE, dN | dE | dS, bridgeMask];

/// A random winding route from a source on the edge to a drain wherever it
/// ends (well away from the source), other tiles drawn by the difficulty's weights, all scrambled. Of
/// several boards it keeps the one whose route is longest to find: the
/// shortest route the tiles allow, and the dead ends a depth-first search
/// from the source walks into.
ChannelPuzzle generateChannel(GenParams params) {
  final rows = params.size.rows, cols = params.size.cols;
  final rng = Random(params.seed);
  final recipe = _recipes[params.difficulty] ?? _recipes[Difficulty.hard]!;
  ChannelPuzzle? best;
  var bestScore = -1.0;
  for (var t = 0; t < recipe.tries; t++) {
    final p = _board(rows, cols, recipe, rng);
    if (p == null) continue;
    final route = solvedRoute(p).length;
    final shortest = shortestRoute(p) ?? route;
    var effort = 0;
    for (var k = 0; k < 2; k++) {
      final search = RouteSearch(p, rng: Random(rng.nextInt(1 << 30)), cap: 3000);
      search.run();
      effort += search.nodes;
    }
    final score = shortest + effort / (2 * route);
    if (score > bestScore) {
      best = p;
      bestScore = score;
    }
  }
  while (best == null) {
    best = _board(rows, cols, recipe, rng, plain: true);
  }
  return best;
}

ChannelPuzzle? _board(int rows, int cols, _Recipe recipe, Random rng, {bool plain = false}) {
  final n = rows * cols;
  final want = max(4, (n * recipe.length).round());
  final path = _walk(rows, cols, want, plain ? 0 : recipe.bridges, rng);
  if (path == null) return null;
  final masks = List<int>.filled(n, -1);
  final onPath = List<bool>.filled(n, false);
  for (var k = 0; k < path.length; k++) {
    final i = path[k];
    if (onPath[i]) {
      masks[i] = bridgeMask;
      continue;
    }
    onPath[i] = true;
    var m = 0;
    if (k > 0) m |= _dirTo(i, path[k - 1], cols);
    if (k < path.length - 1) m |= _dirTo(i, path[k + 1], cols);
    masks[i] = m;
  }
  final total = recipe.weights.fold(0.0, (a, b) => a + b);
  for (var i = 0; i < n; i++) {
    if (onPath[i]) continue;
    var x = rng.nextDouble() * total, k = 0;
    while (k < _shapes.length - 1 && x >= recipe.weights[k]) {
      x -= recipe.weights[k];
      k++;
    }
    masks[i] = rotateMask(_shapes[k], rng.nextInt(4));
  }
  final source = path.first, target = path.last;
  // The drain lies well away from the source.
  final apart = (source ~/ cols - target ~/ cols).abs() + (source % cols - target % cols).abs();
  if (!plain && apart < (rows + cols) ~/ 3) return null;
  final p0 = ChannelPuzzle(
    rows: rows,
    cols: cols,
    source: source,
    target: target,
    masks: masks,
    start: List.filled(n, 0),
    locked: List.filled(n, false),
  );
  final locked = [
    for (var i = 0; i < n; i++) i == source || i == target || (p0.turnable(i) && rng.nextDouble() < recipe.lockRatio),
  ];
  final start = [
    for (var i = 0; i < n; i++)
      if (locked[i] || masks[i] == bridgeMask || masks[i] == 0)
        0
      else if (onPath[i] && rng.nextDouble() < recipe.shown)
        0
      else
        _scramble(masks[i], rng),
  ];
  final p = ChannelPuzzle(
    rows: rows,
    cols: cols,
    source: source,
    target: target,
    masks: masks,
    start: start,
    locked: locked,
  );
  // Never start solved: turn route tiles until the drain is dry.
  final s = PipesState(start);
  for (final i in path) {
    if (!channelSolved(p, channelMasks(p, s))) break;
    if (p.turnable(i)) start[i] = (start[i] + 1) % 4;
  }
  return channelSolved(p, channelMasks(p, s)) ? null : p;
}

/// A turn that changes how [mask] lies (straights have only one).
int _scramble(int mask, Random rng) {
  final t = 1 + rng.nextInt(3);
  return rotateMask(mask, t) == mask ? 1 : t;
}

int _dirTo(int i, int j, int cols) {
  if (j == i - cols) return dN;
  if (j == i + cols) return dS;
  if (j == i - 1) return dW;
  return dE;
}

/// A self-avoiding walk of [want] tiles from a random edge tile, found by
/// depth-first search with backtracking. It may pass straight over a stretch
/// of itself up to [bridges] times (that tile appears twice). Null if the
/// budget runs out.
List<int>? _walk(int rows, int cols, int want, int bridges, Random rng) {
  final n = rows * cols;
  for (var attempt = 0; attempt < 20; attempt++) {
    final edge = [
      for (var i = 0; i < n; i++)
        if (i ~/ cols == 0 || i ~/ cols == rows - 1 || i % cols == 0 || i % cols == cols - 1) i,
    ];
    final start = edge[rng.nextInt(edge.length)];
    final visits = List<int>.filled(n, 0)..[start] = 1;
    final path = <int>[start];
    var crossed = 0;
    var budget = 4000;
    // Each frame: the moves left to try from the head (a move = 1 or 2 tiles).
    final frames = <List<List<int>>>[];
    List<List<int>> movesFrom(int h) {
      final moves = <List<int>>[];
      for (final d in dirs) {
        final j = neighbor(h, d, rows, cols);
        if (j == null) continue;
        if (visits[j] == 0) {
          moves.add([j]);
        } else if (crossed < bridges && visits[j] == 1 && j != start) {
          // Over a straight stretch running across: the walk goes on beyond.
          final k = neighbor(j, d, rows, cols);
          final at = path.indexOf(j);
          if (k == null || visits[k] != 0 || at <= 0 || at >= path.length - 1) continue;
          final across = d == dN || d == dS ? [j - 1, j + 1] : [j - cols, j + cols];
          final ends = {path[at - 1], path[at + 1]};
          if (ends.length == 2 && ends.containsAll(across)) moves.add([j, k]);
        }
      }
      moves.shuffle(rng);
      // Take a bridge when one is offered, more often than not.
      moves.sort((a, b) => b.length - a.length);
      if (moves.isNotEmpty && moves.first.length == 2 && rng.nextBool()) moves.add(moves.removeAt(0));
      return moves;
    }

    frames.add(movesFrom(start));
    while (path.length < want && budget-- > 0) {
      final moves = frames.last;
      if (moves.isEmpty) {
        frames.removeLast();
        if (frames.isEmpty) break;
        // Undo the move that led here.
        final last = path.removeLast();
        visits[last]--;
        if (visits[path.last] == 2) {
          visits[path.removeLast()]--;
          crossed--;
        }
        continue;
      }
      final move = moves.removeAt(0);
      for (final j in move) {
        visits[j]++;
        path.add(j);
      }
      if (move.length == 2) crossed++;
      frames.add(movesFrom(path.last));
    }
    if (path.length >= want) return path;
  }
  return null;
}
