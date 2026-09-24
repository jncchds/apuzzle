import 'dart:math';

import '../../core/difficulty.dart';
import 'trail_model.dart';
import 'trail_solver.dart';

/// Search budget (solver nodes) per uniqueness check.
const _budget = 250000;

/// Random Hamiltonian path (backbite moves from a serpentine), then add
/// waypoints where alternatives diverge until unique, drop redundant ones,
/// and add extras back for easier levels.
TrailPuzzle generateTrail(GenParams params) {
  final rows = params.size.rows, cols = params.size.cols, n = rows * cols;
  final rng = Random(params.seed);
  final d = params.difficulty;

  final path = _randomHamiltonian(rows, cols, rng);
  final marks = <int>{0, n - 1};
  final initial = (n * 0.1).round();
  while (marks.length < initial + 2) {
    marks.add(1 + rng.nextInt(n - 2));
  }

  List<int?> numbersFor(Set<int> m) {
    final sorted = m.toList()..sort();
    final nums = List<int?>.filled(n, null);
    for (var k = 0; k < sorted.length; k++) {
      nums[path[sorted[k]]] = k + 1;
    }
    return nums;
  }

  bool unique(Set<int> m) => TrailSolver(rows, cols, numbersFor(m)).solutions(budget: _budget).length == 1;

  // 1. Add waypoints where alternatives diverge until the path is unique.
  for (var guard = 0; guard < n; guard++) {
    final sols = TrailSolver(rows, cols, numbersFor(marks)).solutions(budget: _budget);
    if (sols.length == 1) break;
    var diverge = -1;
    if (sols.isNotEmpty) {
      final alt = sols.firstWhere((x) => !_samePath(x, path), orElse: () => sols.last);
      for (var i = 0; i < n; i++) {
        if (alt[i] != path[i]) {
          diverge = i;
          break;
        }
      }
    }
    final free = [for (var i = 1; i < n - 1; i++) if (!marks.contains(i)) i];
    if (free.isEmpty) break;
    if (diverge < 0 || marks.contains(diverge)) {
      marks.add(free[rng.nextInt(free.length)]);
    } else {
      marks.add(diverge);
    }
  }

  // 2. Drop waypoints that are not needed.
  for (final idx in (marks.toList()..shuffle(rng))) {
    if (idx == 0 || idx == n - 1) continue;
    marks.remove(idx);
    if (!unique(marks)) marks.add(idx);
  }

  // 3. Easier levels get extra (redundant) waypoints.
  final target = switch (d) {
    Difficulty.easy => (n * 0.3).round(),
    Difficulty.medium => (n * 0.2).round(),
    _ => 0,
  };
  final free = [for (var i = 1; i < n - 1; i++) if (!marks.contains(i)) i]..shuffle(rng);
  for (final i in free) {
    if (marks.length >= target) break;
    marks.add(i);
  }

  return TrailPuzzle(rows: rows, cols: cols, numbers: numbersFor(marks), solution: path);
}

bool _samePath(List<int> a, List<int> b) {
  for (var i = 0; i < a.length; i++) {
    if (a[i] != b[i]) return false;
  }
  return true;
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
