import 'dart:math';

import '../../core/difficulty.dart';
import '../../core/lattice_loop.dart';
import 'arrows_model.dart';
import 'arrows_solver.dart';

/// A random loop through cell centres; the cells it skips are shaded where
/// they don't touch and the rest become clues, each aimed where it says the
/// most. Then:
///  1. reshape the loop next to what tier-1 logic leaves undecided, while
///     that doesn't leave more undecided;
///  2. where logic still stalls, a shaded cell next to the stuck part turns
///     into a clue;
///  3. clues turn back into shaded cells while logic at the difficulty's
///     tier still solves the board (fewer kept on harder levels).
ArrowsPuzzle generateArrows(GenParams params) {
  final rows = params.size.rows, cols = params.size.cols, n = rows * cols;
  final rng = Random(params.seed);
  final d = params.difficulty;
  final tier = d == Difficulty.easy ? 1 : 2;
  final g = LatticeLoop(rows, cols);

  for (var attempt = 0; attempt < 30; attempt++) {
    final region = LoopRegion(rows - 1, cols - 1)..grow(rng, 0.5 + rng.nextDouble() * 0.15);
    // Fixed tie-breaks, so a layout always gets the same clues.
    final order = [for (var i = 0; i < n; i++) i]..shuffle(rng);
    var b = _Board.build(g, rows, cols, region.inside, order);
    // Shaping and stall clues use the cheap tier-1 logic; harder levels
    // then drop clues that only the higher tier can do without.
    int open(_Board b) => ArrowsSolver(rows, cols, b.arrows, b.counts).slack(1);
    bool fits(_Board b) => b.loopCells >= n * 0.55 && b.clues <= n * 0.2;
    if (!fits(b)) continue;

    // 1. Reshape the loop where the logic stays undecided.
    var score = open(b);
    for (var step = 0; step < 2 * n && score > 0; step++) {
      final s = ArrowsSolver(rows, cols, b.arrows, b.counts);
      final st = s.initial();
      s.solve(st, 1);
      final stuck = {
        for (var e = 0; e < g.edgeCount; e++)
          if (st[e] == -1) ...[g.ends(e).$1, g.ends(e).$2],
        for (var i = 0; i < n; i++)
          if (st[g.edgeCount + i] == -1) i,
      };
      final faces = <int>{
        for (final i in stuck)
          for (final (dr, dc) in const [(-1, -1), (-1, 0), (0, -1), (0, 0)])
            if (i ~/ cols + dr >= 0 && i % cols + dc >= 0 && i ~/ cols + dr < rows - 1 && i % cols + dc < cols - 1)
              (i ~/ cols + dr) * (cols - 1) + i % cols + dc,
      }.where(region.canToggle).toList();
      if (faces.isEmpty) break;
      final f = faces[rng.nextInt(faces.length)];
      region.inside[f] = !region.inside[f];
      final next = _Board.build(g, rows, cols, region.inside, order);
      final nextScore = fits(next) ? open(next) : 1 << 30;
      if (nextScore <= score) {
        b = next;
        score = nextScore;
      } else {
        region.inside[f] = !region.inside[f];
      }
    }

    final arrows = b.arrows, shaded = b.shaded;
    List<int> countsFor() => [
      for (var i = 0; i < n; i++)
        if (arrows[i] < 0) 0 else arrowsRay(rows, cols, arrows, i).where((j) => shaded[j]).length,
    ];
    bool solvesAt(int t) => ArrowsSolver(rows, cols, arrows, countsFor()).slack(t) == 0;
    // Tier-1 logic is much cheaper, so try it first.
    bool solvable() => solvesAt(1) || (tier > 1 && solvesAt(tier));

    // 2. Clues where the logic stalls.
    var ok = true;
    while (true) {
      final s = ArrowsSolver(rows, cols, arrows, countsFor());
      final st = s.initial();
      if (s.solve(st, 1)) break;
      final stuck = {
        for (var e = 0; e < g.edgeCount; e++)
          if (st[e] == -1) ...[g.ends(e).$1, g.ends(e).$2],
        for (var i = 0; i < n; i++)
          if (st[g.edgeCount + i] == -1) i,
      };
      final near = [
        for (var i = 0; i < n; i++)
          if (shaded[i] && (stuck.contains(i) || _orth(i, rows, cols).any(stuck.contains))) i,
      ];
      if (near.isEmpty) {
        ok = false;
        break;
      }
      final i = near[rng.nextInt(near.length)];
      shaded[i] = false;
      _aim(rows, cols, arrows, shaded, i, order);
    }
    if (!ok) continue;

    // 3. Clues back to shaded cells while the logic still solves the board.
    final keep = switch (d) {
      Difficulty.easy => 0.35,
      Difficulty.medium => 0.15,
      _ => 0.0,
    };
    for (final i in [
      for (var i = 0; i < n; i++)
        if (arrows[i] >= 0) i,
    ]..shuffle(rng)) {
      if (rng.nextDouble() < keep || _orth(i, rows, cols).any((j) => shaded[j])) continue;
      final dir = arrows[i];
      arrows[i] = -1;
      shaded[i] = true;
      if (!solvable()) {
        shaded[i] = false;
        arrows[i] = dir;
      }
    }
    // 4. Harder levels: turn clues to say less while the tier still solves
    // the board and the basic logic gets more stuck.
    if (tier > 1) {
      final goal = d == Difficulty.hard ? n : 1;
      var stuck = ArrowsSolver(rows, cols, arrows, countsFor()).slack(1);
      for (final i in [
        for (var i = 0; i < n; i++)
          if (arrows[i] >= 0) i,
      ]..shuffle(rng)) {
        if (stuck >= goal) break;
        final dir = arrows[i];
        for (final other in [0, 1, 2, 3]..shuffle(rng)) {
          if (other == dir) continue;
          arrows[i] = other;
          if (arrowsRay(rows, cols, arrows, i).isNotEmpty) {
            final s1 = ArrowsSolver(rows, cols, arrows, countsFor()).slack(1);
            if (s1 > stuck && solvesAt(tier)) {
              stuck = s1;
              break;
            }
          }
          arrows[i] = dir;
        }
      }
    }
    return ArrowsPuzzle(rows: rows, cols: cols, arrows: arrows, counts: countsFor(), shaded: shaded, lines: b.lines);
  }
  return generateArrows(params.withSeed(params.seed + 7919));
}

/// A loop with its shading and clues.
class _Board {
  _Board(this.lines, this.shaded, this.arrows, this.counts, this.loopCells, this.clues);

  /// Off-loop cells in [order] are shaded unless that would touch a shaded
  /// cell; those become clues.
  factory _Board.build(LatticeLoop g, int rows, int cols, List<bool> faces, List<int> order) {
    final n = rows * cols;
    final lines = g.boundary(faces);
    final onLoop = [for (var i = 0; i < n; i++) g.incident[i].any((e) => lines[e])];
    final shaded = List<bool>.filled(n, false);
    final arrows = List<int>.filled(n, -1);
    for (final i in order) {
      if (onLoop[i]) continue;
      if (_orth(i, rows, cols).any((j) => shaded[j])) {
        arrows[i] = 0;
      } else {
        shaded[i] = true;
      }
    }
    for (var i = 0; i < n; i++) {
      if (arrows[i] >= 0) _aim(rows, cols, arrows, shaded, i, order);
    }
    final counts = [
      for (var i = 0; i < n; i++)
        if (arrows[i] < 0) 0 else arrowsRay(rows, cols, arrows, i).where((j) => shaded[j]).length,
    ];
    return _Board(lines, shaded, arrows, counts, onLoop.where((x) => x).length, arrows.where((a) => a >= 0).length);
  }

  final List<bool> lines;
  final List<bool> shaded;
  final List<int> arrows;
  final List<int> counts;
  final int loopCells;
  final int clues;
}

/// Points clue [i] where it says the most: a count above zero, else a zero
/// along a long ray; ties broken by the cell's place in [order].
void _aim(int rows, int cols, List<int> arrows, List<bool> shaded, int i, List<int> order) {
  final options = <int>[];
  var best = -1;
  for (var dir = 0; dir < 4; dir++) {
    arrows[i] = dir;
    final ray = arrowsRay(rows, cols, arrows, i);
    if (ray.isEmpty) continue;
    final k = ray.where((j) => shaded[j]).length;
    final score = k > 0 ? 2 : (ray.length >= 3 ? 1 : 0);
    if (score > best) {
      best = score;
      options.clear();
    }
    if (score == best) options.add(dir);
  }
  arrows[i] = options.isEmpty ? 0 : options[order[i] % options.length];
}

List<int> _orth(int i, int rows, int cols) {
  final r = i ~/ cols, c = i % cols;
  return [if (r > 0) i - cols, if (c + 1 < cols) i + 1, if (r + 1 < rows) i + cols, if (c > 0) i - 1];
}
