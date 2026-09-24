import 'dart:typed_data';

import 'lits_model.dart';

class Placement {
  Placement(this.cells, this.shape, int size) : mask = Uint8List(size) {
    for (final i in cells) {
      mask[i] = 1;
    }
  }
  final List<int> cells;
  final Uint8List mask;
  final Tetro shape;

  bool has(int i) => mask[i] == 1;
}

/// Candidate-placement solver.
///  Tier 1: filter placements against known cells, the 2×2 rule, shaded-area
///          connectivity and pairwise consistency with neighbouring regions
///          (a placement clashing with every option of a neighbour is out);
///          cells in all/none of a region's placements become known.
///  Tier 2: + probing placements.
class LitsSolver {
  LitsSolver(this.n, this.regions) : regionCount = regions.reduce((a, b) => a > b ? a : b) + 1 {
    cellsOf = List.generate(regionCount, (_) => <int>[]);
    for (var i = 0; i < n * n; i++) {
      cellsOf[regions[i]].add(i);
    }
    nbs = List.generate(n * n, (i) {
      final r = i ~/ n, c = i % n;
      return [if (r > 0) i - n, if (r < n - 1) i + n, if (c > 0) i - 1, if (c < n - 1) i + 1];
    });
    candidates = [for (var r = 0; r < regionCount; r++) _enumerate(r)];
    neighbours = List.generate(regionCount, (_) => <int>{});
    for (var i = 0; i < n * n; i++) {
      for (final j in nbs[i]) {
        if (regions[j] != regions[i]) neighbours[regions[i]].add(regions[j]);
      }
    }
  }

  late final List<Set<int>> neighbours;

  /// Whether placements [a] and [b] (different regions) can't coexist.
  bool _clash(Placement a, Placement b, List<int> known) {
    for (final i in a.cells) {
      for (final j in nbs[i]) {
        if (b.mask[j] == 1 && a.shape == b.shape) return true;
      }
    }
    bool sh(int x) => known[x] == 1 || a.mask[x] == 1 || b.mask[x] == 1;
    for (final i in a.cells) {
      final r = i ~/ n, c = i % n;
      for (final (dr, dc) in const [(0, 0), (-1, 0), (0, -1), (-1, -1)]) {
        final r0 = r + dr, c0 = c + dc;
        if (r0 < 0 || c0 < 0 || r0 + 1 >= n || c0 + 1 >= n) continue;
        final q = r0 * n + c0;
        if (sh(q) && sh(q + 1) && sh(q + n) && sh(q + n + 1)) return true;
      }
    }
    return false;
  }

  /// Known shaded cells plus [pl] must be connectable through cells that are
  /// neither known empty nor the rest of [pl]'s region.
  bool _placementConnects(Placement pl, int region, List<int> known) {
    bool open(int x) => pl.mask[x] == 1 || (known[x] != -1 && regions[x] != region);
    final start = pl.cells.first;
    final seen = Uint8List(n * n)..[start] = 1;
    final stack = [start];
    while (stack.isNotEmpty) {
      for (final j in nbs[stack.removeLast()]) {
        if (seen[j] == 0 && open(j)) {
          seen[j] = 1;
          stack.add(j);
        }
      }
    }
    for (var i = 0; i < n * n; i++) {
      if ((known[i] == 1 || pl.mask[i] == 1) && seen[i] == 0) return false;
    }
    return true;
  }

  late final List<List<int>> nbs;

  final int n;
  final List<int> regions;
  final int regionCount;
  late final List<List<int>> cellsOf;
  late final List<List<Placement>> candidates;

  List<int> _nb(int i) => nbs[i];

  List<Placement> _enumerate(int region) {
    final seen = <String>{};
    final out = <Placement>[];
    void grow(List<int> cur) {
      if (cur.length == 4) {
        final key = (List.of(cur)..sort()).join(',');
        if (!seen.add(key)) return;
        final shape = classify(cur, n);
        if (shape != null) out.add(Placement(List.of(cur)..sort(), shape, n * n));
        return;
      }
      final frontier = <int>{};
      for (final i in cur) {
        for (final j in _nb(i)) {
          if (regions[j] == region && !cur.contains(j)) frontier.add(j);
        }
      }
      for (final j in frontier) {
        if (j < cur.first) continue; // anchor = smallest cell
        grow([...cur, j]);
      }
    }

    for (final i in cellsOf[region]) {
      grow([i]);
    }
    return out;
  }

  /// Whether shading [pl] completes a 2×2 block together with known shaded cells.
  bool _makes2x2(Placement pl, List<int> known) {
    bool sh(int x) => known[x] == 1 || pl.mask[x] == 1;
    for (final i in pl.cells) {
      final r = i ~/ n, c = i % n;
      for (final (dr, dc) in const [(0, 0), (-1, 0), (0, -1), (-1, -1)]) {
        final r0 = r + dr, c0 = c + dc;
        if (r0 < 0 || c0 < 0 || r0 + 1 >= n || c0 + 1 >= n) continue;
        final a = r0 * n + c0;
        if (sh(a) && sh(a + 1) && sh(a + n) && sh(a + n + 1)) return true;
      }
    }
    return false;
  }

  /// known: 1 shaded, -1 empty, 0 unknown.
  bool _propagate(List<List<Placement>> cand, List<int> known, {bool deep = true}) {
    final shadedIn = List<int>.filled(regionCount, 0);
    final cover = Int32List(n * n);
    var changed = true;
    while (changed) {
      changed = false;
      shadedIn.fillRange(0, regionCount, 0);
      for (var i = 0; i < n * n; i++) {
        if (known[i] == 1) shadedIn[regions[i]]++;
      }
      for (var r = 0; r < regionCount; r++) {
        final before = cand[r].length;
        cand[r].removeWhere((pl) {
          var hits = 0;
          for (final i in pl.cells) {
            final k = known[i];
            if (k == -1) return true;
            if (k == 1) hits++;
          }
          if (hits != shadedIn[r]) return true;
          if (_makes2x2(pl, known)) return true;
          for (final o in neighbours[r]) {
            final others = cand[o];
            if (others.length <= (deep ? 60 : 10) && others.every((q) => _clash(pl, q, known))) return true;
          }
          if (deep && !_placementConnects(pl, r, known)) return true;
          for (final i in pl.cells) {
            for (final j in _nb(i)) {
              final o = regions[j];
              if (o != r && cand[o].length == 1 && cand[o].single.shape == pl.shape && cand[o].single.has(j)) {
                return true;
              }
            }
          }
          return false;
        });
        final list = cand[r];
        if (list.isEmpty) return false;
        if (list.length != before) changed = true;
        for (final pl in list) {
          for (final i in pl.cells) {
            cover[i]++;
          }
        }
        for (final i in cellsOf[r]) {
          final count = cover[i];
          cover[i] = 0;
          if (known[i] != 0) continue;
          if (count == list.length) {
            known[i] = 1;
            shadedIn[r]++;
            changed = true;
          } else if (count == 0) {
            known[i] = -1;
            changed = true;
          }
        }
      }
      if (!changed && !_canConnect(known)) return false;
    }
    return true;
  }

  /// Known shaded cells must be connectable through non-empty cells.
  bool _canConnect(List<int> known) {
    final shaded = [for (var i = 0; i < n * n; i++) if (known[i] == 1) i];
    if (shaded.isEmpty) return true;
    final seen = {shaded.first};
    final stack = [shaded.first];
    while (stack.isNotEmpty) {
      for (final j in _nb(stack.removeLast())) {
        if (known[j] != -1 && seen.add(j)) stack.add(j);
      }
    }
    return shaded.every(seen.contains);
  }

  List<List<Placement>> _copy(List<List<Placement>> c) => [for (final l in c) List.of(l)];

  /// Shading if solved by logic up to [tier].
  List<bool>? solveLogic(int tier) {
    final cand = logicCandidates(tier);
    if (cand == null || cand.any((c) => c.length != 1)) return null;
    final shaded = List<bool>.filled(n * n, false);
    for (final c in cand) {
      for (final i in c.single.cells) {
        shaded[i] = true;
      }
    }
    return litsConflicts(n, regions, shaded, complete: true).isEmpty ? shaded : null;
  }

  /// Remaining placements per region after logic up to [tier] (null on contradiction).
  List<List<Placement>>? logicCandidates(int tier) {
    final cand = _copy(candidates);
    final known = List<int>.filled(n * n, 0);
    if (!_propagate(cand, known)) return null;
    if (tier >= 2) {
      var progress = true;
      while (progress && cand.any((c) => c.length > 1)) {
        progress = false;
        for (var r = 0; r < regionCount && !progress; r++) {
          if (cand[r].length < 2) continue;
          for (final pl in List.of(cand[r])) {
            final c2 = _copy(cand)..[r] = [pl];
            if (!_propagate(c2, List.of(known))) {
              cand[r].remove(pl);
              if (!_propagate(cand, known)) return null;
              progress = true;
              break;
            }
          }
        }
      }
    }
    return cand;
  }

  /// Up to [limit] solutions (as shadings).
  List<List<bool>> solutions({int limit = 2, int budget = 300000}) {
    final out = <List<bool>>[];
    var nodes = 0;
    void rec(List<List<Placement>> cand, List<int> known) {
      if (out.length >= limit || ++nodes > budget) return;
      if (!_propagate(cand, known)) return;
      var best = -1;
      for (var r = 0; r < regionCount; r++) {
        if (cand[r].length > 1 && (best < 0 || cand[r].length < cand[best].length)) best = r;
      }
      if (best < 0) {
        final shaded = List<bool>.filled(n * n, false);
        for (final c in cand) {
          for (final i in c.single.cells) {
            shaded[i] = true;
          }
        }
        if (litsConflicts(n, regions, shaded, complete: true).isEmpty) out.add(shaded);
        return;
      }
      for (final pl in List.of(cand[best])) {
        rec(_copy(cand)..[best] = [pl], List.of(known));
        if (out.length >= limit) return;
      }
    }

    rec(_copy(candidates), List<int>.filled(n * n, 0));
    if (nodes > budget && out.length == 1) out.add(out.first);
    return out;
  }
}
