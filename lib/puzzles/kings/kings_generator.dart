import 'dart:math';

import '../../core/difficulty.dart';
import '../../core/region_growth.dart';
import '../../core/region_search.dart';
import 'kings_model.dart';
import 'kings_solver.dart';

/// Place non-touching kings, grow balanced regions around them, reshape the
/// regions where an alternative solution differs until the solution is
/// unique, then run a local search on region borders until logic needs
/// exactly the difficulty's tier. The search replaces regenerating the whole
/// puzzle until the tier happens to match.
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
  for (var attempt = 0; attempt < 10; attempt++) {
    final sol = _placeKings(n, rng);
    if (sol == null) continue;
    final regions = _grow(n, sol, rng);
    if (regions == null) continue;
    _tune(n, regions, sol, target, rng);
    final puzzle = KingsPuzzle(n: n, regions: regions, solution: sol);
    final score = (KingsSolver(n, regions).grade() - target).abs();
    if (score == 0) return puzzle;
    if (score < bestScore) {
      bestScore = score;
      best = puzzle;
    }
  }
  return best ?? generateKings(params.withSeed(params.seed + 104729));
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

/// Balanced random regions around the kings, then the uniqueness repair.
List<int>? _grow(int n, List<int> sol, Random rng) {
  final regions = List<int>.filled(n * n, -1);
  for (var r = 0; r < n; r++) {
    regions[r * n + sol[r]] = r;
  }
  growBalancedRegions(n, regions, rng, bias: 1.5);
  return _makeUnique(n, regions, sol, rng) ? regions : null;
}

/// Moves cells an alternative solution relies on into other regions.
bool _makeUnique(int n, List<int> regions, List<int> sol, Random rng) {
  final kingCells = {for (var r = 0; r < n; r++) r * n + sol[r]};
  final search = RegionSearch(n, regions, [for (var i = 0; i < n * n; i++) kingCells.contains(i)], rng);
  for (var it = 0; it < 400; it++) {
    final sols = KingsSolver(n, regions).solutions();
    if (sols.length == 1) return true;
    final alt = sols.firstWhere((s) => !_same(s, sol), orElse: () => sols.last);
    final targets = [for (var r = 0; r < n; r++) if (alt[r] != sol[r]) r * n + alt[r]]..shuffle(rng);
    if (!targets.any(search.moveCell)) return false;
  }
  return false;
}

/// Reshapes regions until the logic tier matches [target]. Regions below a
/// minimum size (they read like givens) are penalised.
void _tune(int n, List<int> regions, List<int> sol, int target, Random rng) {
  final pinned = List<bool>.filled(n * n, false);
  for (var r = 0; r < n; r++) {
    pinned[r * n + sol[r]] = true;
  }
  final minSize = n >= 7 ? 3 : 2;
  int tiny() {
    final s = List<int>.filled(n, 0);
    for (final r in regions) {
      s[r]++;
    }
    return s.fold(0, (a, x) => a + max(0, minSize - x));
  }

  final search = RegionSearch(n, regions, pinned, rng);
  final grade = KingsSolver(n, regions).grade();
  if (grade > target) {
    // Too hard: shrink what logic at the target tier leaves open.
    final saved = List.of(regions);
    // Tier-1 checks are cheap, so easy gets a longer search.
    final budget = (target == 1 ? 400 : 40) * n;
    if (!search.minimize(() => KingsSolver(n, regions).slack(target) * 100 + tiny(), budget: budget, temperature: 20.0 * n * n) &&
        KingsSolver(n, regions).slack(target) != 0) {
      regions.setAll(0, saved);
    }
  } else if (grade < target) {
    // Too easy: stay solvable at the target tier (hence unique) while the
    // easier tier gets stuck.
    final limit = tiny();
    search.harden(
      () => tiny() <= limit && KingsSolver(n, regions).slack(target) == 0,
      () => KingsSolver(n, regions).slack(target - 1),
      budget: 40 * n,
    );
  }
}

bool _same(List<int> a, List<int> b) {
  for (var i = 0; i < a.length; i++) {
    if (a[i] != b[i]) return false;
  }
  return true;
}
