import 'dart:math';

import '../../core/difficulty.dart';
import 'trail_logic.dart';
import 'trail_model.dart';

/// Random Hamiltonian path (backbite moves from a serpentine), then:
///  1. start from the two ends and add a waypoint wherever the edge logic gets
///     stuck, until logic at the difficulty's tier traces the whole path;
///  2. drop waypoints the logic doesn't need;
///  3. add redundant waypoints back for easier levels.
/// Logic solves are polynomial and sound, so no search over paths is needed.
TrailPuzzle generateTrail(GenParams params) {
  final rows = params.size.rows, cols = params.size.cols, n = rows * cols;
  final rng = Random(params.seed);
  final d = params.difficulty;
  final tier = d == Difficulty.easy ? 1 : 2;

  final path = _randomHamiltonian(rows, cols, rng);
  final pos = List<int>.filled(n, 0);
  for (var k = 0; k < n; k++) {
    pos[path[k]] = k;
  }
  final marks = <int>{0, n - 1};

  List<int?> numbersFor(Set<int> m) {
    final sorted = m.toList()..sort();
    final nums = List<int?>.filled(n, null);
    for (var k = 0; k < sorted.length; k++) {
      nums[path[sorted[k]]] = k + 1;
    }
    return nums;
  }

  TrailLogic logic(Set<int> m) => TrailLogic(rows, cols, numbersFor(m));

  // 1. Add waypoints where the logic stalls.
  while (true) {
    final open = logic(marks).openCells(tier);
    if (open.isEmpty) break;
    var pick = [for (final c in open) if (!marks.contains(pos[c])) pos[c]];
    if (pick.isEmpty) pick = [for (var i = 1; i < n - 1; i++) if (!marks.contains(i)) i];
    marks.add(pick[rng.nextInt(pick.length)]);
  }

  // 2. Drop waypoints that are not needed.
  for (final idx in (marks.toList()..shuffle(rng))) {
    if (idx == 0 || idx == n - 1) continue;
    marks.remove(idx);
    if (logic(marks).solve(tier) == null) marks.add(idx);
  }

  // 3. Easier levels get extra (redundant) waypoints.
  final target = switch (d) {
    Difficulty.easy => max(marks.length, (n * 0.25).round()),
    Difficulty.medium => marks.length + (n * 0.06).round(),
    _ => 0,
  };
  final free = [for (var i = 1; i < n - 1; i++) if (!marks.contains(i)) i]..shuffle(rng);
  for (final i in free) {
    if (marks.length >= target) break;
    marks.add(i);
  }

  return TrailPuzzle(rows: rows, cols: cols, numbers: numbersFor(marks), solution: path);
}

List<int> _randomHamiltonian(int rows, int cols, Random rng) {
  var path = <int>[
    for (var r = 0; r < rows; r++)
      for (var k = 0; k < cols; k++) r * cols + (r.isEven ? k : cols - 1 - k),
  ];
  List<int> neighbors(int i) {
    final r = i ~/ cols, c = i % cols;
    return [if (r > 0) i - cols, if (r < rows - 1) i + cols, if (c > 0) i - 1, if (c < cols - 1) i + 1];
  }

  final steps = rows * cols * 40;
  final pos = List<int>.filled(rows * cols, 0);
  for (var s = 0; s < steps; s++) {
    if (rng.nextBool()) path = path.reversed.toList();
    for (var k = 0; k < path.length; k++) {
      pos[path[k]] = k;
    }
    final endCell = path.last;
    final opts = [for (final x in neighbors(endCell)) if (pos[x] != path.length - 2) x];
    if (opts.isEmpty) continue;
    final x = opts[rng.nextInt(opts.length)];
    final i = pos[x];
    // p0..pi, pL, pL-1, ..., p(i+1)
    path = [...path.sublist(0, i + 1), ...path.sublist(i + 1).reversed];
  }
  return path;
}
