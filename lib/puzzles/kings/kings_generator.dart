import 'dart:math';

import '../../core/difficulty.dart';
import '../../core/region_growth.dart';
import 'kings_model.dart';
import 'kings_solver.dart';

/// Place non-touching kings, grow random regions around them, then locally
/// reshape regions until the solution is unique; finally grade by logic tier.
KingsPuzzle generateKings(GenParams params) {
  final n = params.size.rows;
  final rng = Random(params.seed);
  final target = switch (params.difficulty) {
    Difficulty.easy => 1,
    Difficulty.medium => 2,
    _ => 3,
  };
  KingsPuzzle? best;
  var bestScore = 1 << 30;

  for (var attempt = 0; attempt < 80; attempt++) {
    final sol = _placeKings(n, rng);
    if (sol == null) continue;
    final regions = _growRegions(n, sol, rng);
    if (!_makeUnique(n, regions, sol, rng)) continue;
    final tier = KingsSolver(n, regions).grade();
    final puzzle = KingsPuzzle(n: n, regions: regions, solution: sol);
    final score = (tier - target).abs();
    if (score == 0) return puzzle;
    if (score < bestScore) {
      bestScore = score;
      best = puzzle;
    }
  }
  return best ?? _fallback(n, rng);
}

KingsPuzzle _fallback(int n, Random rng) {
  // Extremely unlikely; loop until something unique appears.
  while (true) {
    final sol = _placeKings(n, rng);
    if (sol == null) continue;
    final regions = _growRegions(n, sol, rng);
    if (_makeUnique(n, regions, sol, rng)) return KingsPuzzle(n: n, regions: regions, solution: sol);
  }
}

List<int>? _placeKings(int n, Random rng) {
  final cols = List<int>.filled(n, -1);
  final used = List<bool>.filled(n, false);
  bool rec(int r) {
    if (r == n) return true;
    final order = [for (var c = 0; c < n; c++) c]..shuffle(rng);
    for (final c in order) {
      if (used[c] || (r > 0 && (cols[r - 1] - c).abs() <= 1)) continue;
      cols[r] = c;
      used[c] = true;
      if (rec(r + 1)) return true;
      used[c] = false;
    }
    return false;
  }

  return rec(0) ? cols : null;
}

List<int> _neighbors4(int n, int i) {
  final r = i ~/ n, c = i % n;
  return [
    if (r > 0) i - n,
    if (r < n - 1) i + n,
    if (c > 0) i - 1,
    if (c < n - 1) i + 1,
  ];
}

List<int> _growRegions(int n, List<int> sol, Random rng) {
  final regions = List<int>.filled(n * n, -1);
  for (var r = 0; r < n; r++) {
    regions[r * n + sol[r]] = r;
  }
  growBalancedRegions(n, regions, rng, bias: 1.5);
  return regions;
}

bool _connectedWithout(int n, List<int> regions, int region, int removed) {
  final cells = [for (var i = 0; i < n * n; i++) if (regions[i] == region && i != removed) i];
  if (cells.isEmpty) return false;
  final seen = {cells.first};
  final stack = [cells.first];
  while (stack.isNotEmpty) {
    final i = stack.removeLast();
    for (final j in _neighbors4(n, i)) {
      if (j != removed && regions[j] == region && seen.add(j)) stack.add(j);
    }
  }
  return seen.length == cells.length;
}

/// Moves cells between regions to kill alternative solutions.
bool _makeUnique(int n, List<int> regions, List<int> sol, Random rng) {
  final kingCells = {for (var r = 0; r < n; r++) r * n + sol[r]};
  for (var it = 0; it < 400; it++) {
    final sols = KingsSolver(n, regions).solutions();
    if (sols.length == 1) return true;
    final alt = sols.firstWhere((s) => !_same(s, sol), orElse: () => sols.last);
    final targets = [for (var r = 0; r < n; r++) if (alt[r] != sol[r]) r * n + alt[r]]..shuffle(rng);
    var moved = false;
    for (final x in targets) {
      if (kingCells.contains(x)) continue;
      final from = regions[x];
      final opts = {for (final j in _neighbors4(n, x)) if (regions[j] != from) regions[j]}.toList();
      if (opts.isEmpty || !_connectedWithout(n, regions, from, x)) continue;
      regions[x] = opts[rng.nextInt(opts.length)];
      moved = true;
      break;
    }
    if (!moved) return false;
  }
  return false;
}

bool _same(List<int> a, List<int> b) {
  for (var i = 0; i < a.length; i++) {
    if (a[i] != b[i]) return false;
  }
  return true;
}
