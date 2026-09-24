import 'dart:math';

import '../../core/difficulty.dart';
import 'lits_model.dart';
import 'lits_solver.dart';

/// Place a connected set of tetrominoes (valid LITS shading), grow one region
/// around each, then reshape region borders until the solution is unique.
LitsPuzzle generateLits(GenParams params) {
  final n = params.size.rows;
  final rng = Random(params.seed);
  // Harder levels get less constrained regions (more candidate placements).
  final greed = switch (params.difficulty) {
    Difficulty.easy => 1.0,
    Difficulty.medium => 0.5,
    _ => 0.2,
  };

  for (var attempt = 0; attempt < 40; attempt++) {
    final pieces = _placePieces(n, n * n, rng);
    if (pieces == null || pieces.length < 3) continue;
    final regions = _growRegions(n, pieces, greed, rng);
    final shaded = List<bool>.filled(n * n, false);
    for (final p in pieces) {
      for (final i in p) {
        shaded[i] = true;
      }
    }
    if (litsConflicts(n, regions, shaded, complete: true).isNotEmpty) continue;
    if (!_makeUnique(n, regions, shaded, rng)) continue;
    return LitsPuzzle(n: n, regions: regions, shaded: shaded);
  }
  return generateLits(params.withSeed(params.seed + 15485863));
}

List<int> _nb(int n, int i) {
  final r = i ~/ n, c = i % n;
  return [if (r > 0) i - n, if (r < n - 1) i + n, if (c > 0) i - 1, if (c < n - 1) i + 1];
}

/// All tetromino placements (L/I/T/S) anywhere on the board.
List<List<int>> _allTetros(int n) {
  final seen = <String>{};
  final out = <List<int>>[];
  void grow(List<int> cur) {
    if (cur.length == 4) {
      final s = List.of(cur)..sort();
      if (seen.add(s.join(',')) && classify(s, n) != null) out.add(s);
      return;
    }
    final f = <int>{};
    for (final i in cur) {
      for (final j in _nb(n, i)) {
        if (!cur.contains(j) && j > cur.first) f.add(j);
      }
    }
    for (final j in f) {
      grow([...cur, j]);
    }
  }

  for (var i = 0; i < n * n; i++) {
    grow([i]);
  }
  return out;
}

List<List<int>>? _placePieces(int n, int target, Random rng) {
  final all = _allTetros(n)..shuffle(rng);
  final owner = List<int>.filled(n * n, -1);
  final pieces = <List<int>>[];
  final shapes = <Tetro>[];

  bool fits(List<int> t) {
    if (t.any((i) => owner[i] >= 0)) return false;
    final shape = classify(t, n)!;
    var touches = pieces.isEmpty;
    final set = t.toSet();
    for (final i in t) {
      for (final j in _nb(n, i)) {
        if (set.contains(j) || owner[j] < 0) continue;
        touches = true;
        if (shapes[owner[j]] == shape) return false;
      }
    }
    if (!touches) return false;
    // no 2×2
    for (final i in t) {
      final r = i ~/ n, c = i % n;
      for (final (dr, dc) in const [(0, 0), (-1, 0), (0, -1), (-1, -1)]) {
        final r0 = r + dr, c0 = c + dc;
        if (r0 < 0 || c0 < 0 || r0 + 1 >= n || c0 + 1 >= n) continue;
        final a = r0 * n + c0;
        bool sh(int x) => set.contains(x) || owner[x] >= 0;
        if (sh(a) && sh(a + 1) && sh(a + n) && sh(a + n + 1)) return false;
      }
    }
    // Keep a free cell next to every piece so regions can have spare room.
    return true;
  }

  var misses = 0;
  while (pieces.length < target && misses < 3) {
    var placed = false;
    for (final t in all) {
      if (fits(t)) {
        for (final i in t) {
          owner[i] = pieces.length;
        }
        pieces.add(t);
        shapes.add(classify(t, n)!);
        placed = true;
        all.shuffle(rng);
        break;
      }
    }
    if (!placed) misses++;
  }
  return pieces.isEmpty ? null : pieces;
}

/// Grows regions over unshaded cells, each step choosing the (cell, region)
/// pair that adds the fewest new tetromino placements, which keeps alternative
/// solutions rare. Small regions are slightly preferred for balance.
List<int> _growRegions(int n, List<List<int>> pieces, double greed, Random rng) {
  final regions = List<int>.filled(n * n, -1);
  final size = List<int>.filled(pieces.length, 4);
  for (var k = 0; k < pieces.length; k++) {
    for (final i in pieces[k]) {
      regions[i] = k;
    }
  }

  // Tetromino placements indexed by cell (other 3 cells).
  final byCell = List.generate(n * n, (_) => <List<int>>[]);
  for (final t in _allTetros(n)) {
    for (final i in t) {
      byCell[i].add([for (final j in t) if (j != i) j]);
    }
  }

  /// Tetrominoes inside region r ∪ {u} that contain u.
  int newPlacements(int u, int r) {
    var count = 0;
    for (final others in byCell[u]) {
      if (regions[others[0]] == r && regions[others[1]] == r && regions[others[2]] == r) count++;
    }
    return count;
  }

  while (regions.contains(-1)) {
    var bestScore = double.infinity;
    final best = <(int, int)>[];
    for (var u = 0; u < n * n; u++) {
      if (regions[u] >= 0) continue;
      final opts = {for (final j in _nb(n, u)) if (regions[j] >= 0) regions[j]};
      for (final r in opts) {
        final score = newPlacements(u, r) * greed + size[r] * 0.35 + rng.nextDouble() * (0.5 + 3 * (1 - greed));
        if (score < bestScore - 1e-9) {
          bestScore = score;
          best
            ..clear()
            ..add((u, r));
        } else if ((score - bestScore).abs() < 1e-9) {
          best.add((u, r));
        }
      }
    }
    final (u, r) = best[rng.nextInt(best.length)];
    regions[u] = r;
    size[r]++;
  }
  return regions;
}

bool _connectedWithout(int n, List<int> regions, int region, int removed) {
  final cells = [for (var i = 0; i < n * n; i++) if (regions[i] == region && i != removed) i];
  if (cells.isEmpty) return false;
  final seen = {cells.first};
  final stack = [cells.first];
  while (stack.isNotEmpty) {
    for (final j in _nb(n, stack.removeLast())) {
      if (j != removed && regions[j] == region && seen.add(j)) stack.add(j);
    }
  }
  return seen.length == cells.length;
}

/// Reshapes regions until a (budgeted) search proves the solution unique,
/// moving cells that an alternative solution relies on.
bool _makeUnique(int n, List<int> regions, List<bool> shaded, Random rng) {
  for (var it = 0; it < 80; it++) {
    final sols = LitsSolver(n, regions).solutions(budget: 4000);
    if (sols.length == 1) return true;
    if (sols.isEmpty) return false;
    final alt = sols.firstWhere((x) => !_same(x, shaded), orElse: () => sols.last);
    final diff = <int>{};
    for (var i = 0; i < n * n; i++) {
      if (alt[i] != shaded[i]) diff.add(regions[i]);
    }
    final primary = [for (var i = 0; i < n * n; i++) if (alt[i] && !shaded[i]) i]..shuffle(rng);
    final secondary = [
      for (var i = 0; i < n * n; i++)
        if (!shaded[i] && (diff.isEmpty || diff.contains(regions[i])) && !primary.contains(i)) i,
    ]..shuffle(rng);
    var moved = false;
    for (final x in [...primary, ...secondary]) {
      final from = regions[x];
      final opts = {for (final j in _nb(n, x)) if (regions[j] != from) regions[j]}.toList();
      if (opts.isEmpty || !_connectedWithout(n, regions, from, x)) continue;
      regions[x] = opts[rng.nextInt(opts.length)];
      moved = true;
      break;
    }
    if (!moved) return false;
  }
  return false;
}

bool _same(List<bool> a, List<bool> b) {
  for (var i = 0; i < a.length; i++) {
    if (a[i] != b[i]) return false;
  }
  return true;
}
