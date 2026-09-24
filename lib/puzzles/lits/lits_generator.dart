import 'dart:math';

import '../../core/difficulty.dart';
import 'lits_model.dart';
import 'lits_solver.dart';

/// Uniqueness-guided construction:
///  1. place a connected set of tetrominoes (a valid LITS shading) and make
///     each one its own region;
///  2. hand out the remaining cells one at a time, most constrained first,
///     only where the shading stays the unique solution (cells without a
///     region count as unshaded). Joining a region only adds solutions, so a
///     rejected (cell, region) pair stays rejected and is never re-checked;
///  3. if some cell fits nowhere, grow again with that cell first (while
///     regions are small); if it still fits nowhere, pick new pieces.
/// Difficulty is a region-shape knob: harder levels prefer growth that
/// creates more candidate placements.
LitsPuzzle generateLits(GenParams params) {
  final n = params.size.rows;
  final rng = Random(params.seed);
  final greed = switch (params.difficulty) {
    Difficulty.easy => 1.0,
    Difficulty.medium => 0.3,
    _ => -0.3,
  };

  for (var attempt = 0; attempt < 20; attempt++) {
    final pieces = _placePieces(n, n * n, rng);
    if (pieces.length < 3) continue;
    final shaded = List<bool>.filled(n * n, false);
    for (final p in pieces) {
      for (final i in p) {
        shaded[i] = true;
      }
    }
    // A cell that fits nowhere is handled first on the next try, while the
    // regions are still small; if it dies even then, the pieces are to blame.
    final first = <int>[];
    for (var retry = 0; retry < 6; retry++) {
      final (regions, dead) = _growRegions(n, pieces, greed, first, rng);
      if (regions != null) return LitsPuzzle(n: n, regions: regions, shaded: shaded);
      if (first.contains(dead)) break;
      first.add(dead);
    }
  }
  return generateLits(params.withSeed(params.seed + 15485863));
}

List<int> _nb(int n, int i) {
  final r = i ~/ n, c = i % n;
  return [if (r > 0) i - n, if (r < n - 1) i + n, if (c > 0) i - 1, if (c < n - 1) i + 1];
}

/// All tetromino placements (L/I/T/S) anywhere on the board.
List<List<int>> _allTetros(int n) => List.of(_tetroCache.putIfAbsent(n, () => _enumerateTetros(n)));
final _tetroCache = <int, List<List<int>>>{};

List<List<int>> _enumerateTetros(int n) {
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

/// Adds random tetrominoes that touch the shading so far, never a 2×2 block
/// and never next to the same shape, until [target] pieces or nothing fits.
List<List<int>> _placePieces(int n, int target, Random rng) {
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
    bool sh(int x) => set.contains(x) || owner[x] >= 0;
    for (final i in t) {
      final r = i ~/ n, c = i % n;
      for (final (dr, dc) in const [(0, 0), (-1, 0), (0, -1), (-1, -1)]) {
        final r0 = r + dr, c0 = c + dc;
        if (r0 < 0 || c0 < 0 || r0 + 1 >= n || c0 + 1 >= n) continue;
        final a = r0 * n + c0;
        if (sh(a) && sh(a + 1) && sh(a + n) && sh(a + n + 1)) return false;
      }
    }
    return true;
  }

  while (pieces.length < target) {
    final t = all.firstWhere(fits, orElse: () => const []);
    if (t.isEmpty) break;
    for (final i in t) {
      owner[i] = pieces.length;
    }
    pieces.add(t);
    shapes.add(classify(t, n)!);
    all.shuffle(rng);
  }
  return pieces;
}

/// Unique within the search budget (an exhausted budget counts as ambiguous).
bool _unique(int n, List<int> regions) => LitsSolver(n, regions).solutions(budget: 4000).length == 1;

/// Step 2. Returns the regions, or the first cell that fits nowhere. Cells in
/// [first] go before all others, in that order, once they touch a region.
(List<int>?, int) _growRegions(int n, List<List<int>> pieces, double greed, List<int> first, Random rng) {
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

  final failed = <int>{};
  var free = regions.where((r) => r < 0).length;
  while (free > 0) {
    // (score, cell, region): [first] cells, then fewest live options, then the
    // difficulty's placement preference and small regions.
    final pairs = <(double, int, int)>[];
    for (var u = 0; u < n * n; u++) {
      if (regions[u] >= 0) continue;
      final opts = {for (final j in _nb(n, u)) if (regions[j] >= 0) regions[j]};
      final live = [for (final r in opts) if (!failed.contains(u * 1000 + r)) r];
      if (live.isEmpty && opts.isNotEmpty) return (null, u);
      final rank = first.indexOf(u);
      for (final r in live) {
        final score = (rank >= 0 ? rank - 1000 : live.length * 100) +
            newPlacements(u, r) * greed +
            size[r] * 0.35 +
            rng.nextDouble() * 1.5;
        pairs.add((score, u, r));
      }
    }
    pairs.sort((a, b) => a.$1.compareTo(b.$1));
    for (final (_, u, r) in pairs) {
      regions[u] = r;
      if (_unique(n, regions)) {
        size[r]++;
        free--;
        break;
      }
      regions[u] = -1;
      failed.add(u * 1000 + r);
    }
  }
  return (regions, -1);
}
