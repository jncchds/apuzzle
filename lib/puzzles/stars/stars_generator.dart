import 'dart:math';

import '../../core/difficulty.dart';
import '../../core/region_growth.dart';
import '../../core/region_search.dart';
import 'stars_model.dart';
import 'stars_solver.dart';

/// The logic tier a difficulty aims for.
int starsTier(Difficulty d) => switch (d) {
  Difficulty.easy => 1,
  Difficulty.medium => 2,
  _ => 3,
};

/// Place non-touching stars (k per row and column), grow one piece around
/// every star and join neighbouring pieces in pairs into regions, reshape the
/// regions where another solution differs until the solution is unique, then
/// tune the region borders until logic needs the difficulty's tier (as in
/// Crowns). Medium and hard keep the best of a few boards.
StarsPuzzle generateStars(GenParams params) {
  final n = params.size.rows;
  final rng = Random(params.seed);
  final target = starsTier(params.difficulty);

  StarsPuzzle? best;
  var bestScore = 1 << 30;
  for (var attempt = 0; attempt < 12; attempt++) {
    final sol = starsLayout(n, starsPerUnit, rng);
    if (sol == null) continue;
    final regions = _regions(n, sol, rng);
    if (regions == null) continue;
    _tune(n, regions, sol, target, rng);
    final puzzle = StarsPuzzle(n: n, regions: regions, solution: sol);
    final solver = StarsSolver(n, regions);
    if (solver.countSolutions() != 1) continue;
    final score = (solver.grade() - target).abs();
    if (score == 0) return puzzle;
    if (score < bestScore) {
      bestScore = score;
      best = puzzle;
    }
  }
  return best ?? generateStars(params.withSeed((params.seed + 104729) % 0x7FFFFFFF));
}

/// Random star cells, [k] per row and column and none touching, or null when
/// the search runs out of tries.
List<int>? starsLayout(int n, int k, Random rng) {
  final rows = List<List<int>>.filled(n, const []);
  final colCount = List<int>.filled(n, 0);
  // Every way to put k non-touching stars into one row.
  final choices = <List<int>>[];
  void pick(List<int> cur, int from) {
    if (cur.length == k) {
      choices.add(List.of(cur));
      return;
    }
    for (var c = from; c < n; c++) {
      pick([...cur, c], c + 2);
    }
  }

  pick([], 0);
  var nodes = 0;
  bool rec(int r) {
    if (r == n) return true;
    if (++nodes > 20000) return false;
    final left = n - r - 1;
    final order = List.of(choices)..shuffle(rng);
    for (final cols in order) {
      if (cols.any((c) => colCount[c] >= k)) continue;
      if (r > 0 && cols.any((c) => rows[r - 1].any((p) => (p - c).abs() <= 1))) continue;
      for (final c in cols) {
        colCount[c]++;
      }
      // A column's stars can't sit in neighbouring rows.
      var ok = true;
      for (var c = 0; c < n && ok; c++) {
        final need = k - colCount[c];
        ok = need <= (cols.contains(c) ? left ~/ 2 : (left + 1) ~/ 2);
      }
      rows[r] = cols;
      if (ok && rec(r + 1)) return true;
      for (final c in cols) {
        colCount[c]--;
      }
    }
    return false;
  }

  if (!rec(0)) return null;
  return [
    for (var r = 0; r < n; r++)
      for (final c in rows[r]) r * n + c,
  ];
}

/// A piece grown around every star, neighbouring pieces joined in pairs, then
/// the uniqueness repair; null when the pieces don't pair up or the repair
/// gets stuck.
List<int>? _regions(int n, List<int> sol, Random rng) {
  final k = starsPerUnit;
  final pieces = List<int>.filled(n * n, -1);
  for (var s = 0; s < sol.length; s++) {
    pieces[sol[s]] = s;
  }
  growBalancedRegions(n, pieces, rng, bias: 1.5);
  final m = sol.length;
  final adj = List.generate(m, (_) => <int>{});
  for (var i = 0; i < n * n; i++) {
    final r = i ~/ n, c = i % n;
    for (final j in [if (r < n - 1) i + n, if (c < n - 1) i + 1]) {
      if (pieces[i] != pieces[j]) {
        adj[pieces[i]].add(pieces[j]);
        adj[pieces[j]].add(pieces[i]);
      }
    }
  }
  final groups = _group(m, k, adj, rng);
  if (groups == null) return null;
  final regions = [for (final p in pieces) groups[p]];
  return _makeUnique(n, regions, sol, rng) ? regions : null;
}

/// Splits [m] pieces into groups of [k] connected ones (by [adj]): a group
/// id per piece, or null. Grows a group from the piece with the fewest free
/// neighbours, with backtracking.
List<int>? _group(int m, int k, List<Set<int>> adj, Random rng) {
  final group = List<int>.filled(m, -1);
  var next = 0, nodes = 0;
  bool rec() {
    if (++nodes > 5000) return false;
    var first = -1, fewest = 1 << 30;
    for (var p = 0; p < m; p++) {
      if (group[p] >= 0) continue;
      final free = adj[p].where((q) => group[q] < 0).length;
      if (free < fewest) {
        fewest = free;
        first = p;
      }
    }
    if (first < 0) return true;
    final id = next++;
    group[first] = id;
    // Grow the group to k pieces, trying every frontier piece in turn.
    bool grow(List<int> members) {
      if (members.length == k) return rec();
      final frontier = {
        for (final p in members)
          for (final q in adj[p])
            if (group[q] < 0) q,
      }.toList()..shuffle(rng);
      for (final q in frontier) {
        group[q] = id;
        if (grow([...members, q])) return true;
        group[q] = -1;
      }
      return false;
    }

    if (grow([first])) return true;
    group[first] = -1;
    next--;
    return false;
  }

  return rec() ? group : null;
}

/// Moves cells another solution relies on into other regions.
bool _makeUnique(int n, List<int> regions, List<int> sol, Random rng) {
  final stars = sol.toSet();
  final search = RegionSearch(n, regions, [for (var i = 0; i < n * n; i++) stars.contains(i)], rng);
  for (var it = 0; it < 100; it++) {
    final sols = StarsSolver(n, regions).solutions();
    if (sols.length == 1) return true;
    final alt = sols.firstWhere((s) => !_same(s, sol), orElse: () => sols.last);
    final targets = [
      for (final i in alt)
        if (!stars.contains(i)) i,
    ]..shuffle(rng);
    if (!targets.any(search.moveCell)) {
      // Loosen the regions around the targets with a few random moves.
      for (var tries = 0, moved = 0; tries < 40 && moved < 3; tries++) {
        if (search.randomMove() != null) moved++;
      }
    }
  }
  return false;
}

/// Reshapes regions until the logic tier matches [target]. Regions below a
/// minimum size are penalised.
void _tune(int n, List<int> regions, List<int> sol, int target, Random rng) {
  final pinned = List<bool>.filled(n * n, false);
  for (final i in sol) {
    pinned[i] = true;
  }
  const minSize = 5;
  int tiny() {
    final s = List<int>.filled(n, 0);
    for (final r in regions) {
      s[r]++;
    }
    return s.fold(0, (a, x) => a + max(0, minSize - x));
  }

  final search = RegionSearch(n, regions, pinned, rng);
  final grade = StarsSolver(n, regions).grade();
  if (grade > target) {
    // Too hard: shrink what logic at the target tier leaves open.
    final saved = List.of(regions);
    final budget = (target == 1 ? 200 : 40) * n;
    if (!search.minimize(
          () => StarsSolver(n, regions).slack(target) * 100 + tiny(),
          budget: budget,
          temperature: 20.0 * n * n,
        ) &&
        StarsSolver(n, regions).slack(target) != 0) {
      regions.setAll(0, saved);
    }
  } else if (grade < target) {
    // Too easy: stay solvable at the target tier (hence unique) while the
    // easier tier gets stuck.
    final limit = tiny();
    search.harden(
      () => tiny() <= limit && StarsSolver(n, regions).slack(target) == 0,
      () => StarsSolver(n, regions).slack(target - 1),
      budget: 40 * n,
    );
  }
}

bool _same(List<int> a, List<int> b) {
  if (a.length != b.length) return false;
  for (var i = 0; i < a.length; i++) {
    if (a[i] != b[i]) return false;
  }
  return true;
}
