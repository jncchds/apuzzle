import '../../core/explain.dart';
import '../../core/grid_graph.dart';
import 'islands_model.dart';

/// What a traced [IslandsSolver.propagate] records ([Fact.rule]); [Fact.value]
/// is [islandsSea] or [islandsLand]. Island rules have the island's number
/// cell (or first cell) as their first arg.
enum IslandsRule {
  total,
  pool,
  complete,
  exit,
  between,
  unreachable,
  seaExit,
  failTotal,
  failInvalid,
  failPool,
  failTwoClues,
  failBig,
  failShut,
  failUnreachable,
  failSeaShut,
}

const int _unk = -1;

/// Cell states: -1 unknown, [islandsSea], [islandsLand].
/// Tier 1: island completion/expansion, cells no island can reach, cells
/// between two islands, 2×2 pools, sea connectivity, land/sea totals.
/// Tier 2: + probing (try a value, refute it by propagation).
class IslandsSolver {
  IslandsSolver(this.rows, this.cols, this.clues)
    : nb = orthNeighbors(rows, cols),
      totalLand = clues.fold(0, (a, b) => a + (b ?? 0));

  final int rows;
  final int cols;
  final List<int?> clues;
  final List<List<int>> nb;
  final int totalLand;

  int get n => rows * cols;

  List<int> initial() => [for (final c in clues) c == null ? _unk : islandsLand];

  /// Applies tier-1 rules until nothing changes. False on a contradiction.
  /// With [t], every deduction is recorded (see [IslandsRule]).
  bool propagate(List<int> st, [ExplainTrace? t]) {
    List<int> all() => [for (var i = 0; i < n; i++) i];
    List<int> around(List<int> cells) => {
      for (final i in cells) ...[i, ...nb[i]],
    }.toList();
    while (true) {
      var landCount = 0, seaCount = 0;
      for (final v in st) {
        if (v == islandsLand) landCount++;
        if (v == islandsSea) seaCount++;
      }
      if (landCount > totalLand || seaCount > n - totalLand) {
        t?.fail(IslandsRule.failTotal.index, premises: all());
        return false;
      }
      final unknown = n - landCount - seaCount;
      if (unknown == 0) {
        if (_valid(st)) return true;
        t?.fail(IslandsRule.failInvalid.index, premises: all());
        return false;
      }
      if (landCount == totalLand || seaCount == n - totalLand) {
        final v = landCount == totalLand ? islandsSea : islandsLand;
        for (var i = 0; i < n; i++) {
          if (st[i] == _unk) {
            st[i] = v;
            t?.fact(i, v, IslandsRule.total.index, premises: all());
          }
        }
        continue;
      }

      var changed = false;
      // No 2×2 pools.
      for (var r = 0; r + 1 < rows; r++) {
        for (var c = 0; c + 1 < cols; c++) {
          final i = r * cols + c;
          final block = [i, i + 1, i + cols, i + cols + 1];
          var s = 0, u = -1, us = 0;
          for (final j in block) {
            if (st[j] == islandsSea) s++;
            if (st[j] == _unk) {
              u = j;
              us++;
            }
          }
          if (s == 4) {
            t?.fail(IslandsRule.failPool.index, premises: block, args: [i]);
            return false;
          }
          if (s == 3 && us == 1) {
            st[u] = islandsLand;
            t?.fact(u, islandsLand, IslandsRule.pool.index, premises: block, args: [i]);
            changed = true;
          }
        }
      }
      if (changed) continue;

      // Land components: completion and forced expansion.
      final comps = components(nb, (i) => st[i] == islandsLand);
      final compOf = List<int>.filled(n, -1);
      final clueOf = List<int>.filled(comps.length, -1);
      for (var k = 0; k < comps.length; k++) {
        for (final i in comps[k]) {
          compOf[i] = k;
          if (clues[i] != null) {
            if (clueOf[k] >= 0) {
              t?.fail(IslandsRule.failTwoClues.index, premises: comps[k], args: [clueOf[k], i]);
              return false;
            }
            clueOf[k] = i;
          }
        }
      }
      for (var k = 0; k < comps.length && !changed; k++) {
        final exits = <int>{
          for (final i in comps[k])
            for (final j in nb[i])
              if (st[j] == _unk) j,
        };
        final want = clueOf[k] >= 0 ? clues[clueOf[k]]! : null;
        // The island's name: its number, or its first cell.
        final anchor = clueOf[k] >= 0 ? clueOf[k] : comps[k].first;
        if (want != null && comps[k].length > want) {
          t?.fail(IslandsRule.failBig.index, premises: comps[k], args: [anchor, want]);
          return false;
        }
        if (want != null && comps[k].length == want) {
          if (exits.isEmpty) continue;
          for (final j in exits) {
            st[j] = islandsSea;
            t?.fact(j, islandsSea, IslandsRule.complete.index, premises: comps[k], args: [anchor, want]);
          }
          changed = true;
        } else if (exits.isEmpty) {
          t?.fail(IslandsRule.failShut.index, premises: around(comps[k]), args: [anchor, want ?? -1]);
          return false;
        } else if (exits.length == 1) {
          st[exits.first] = islandsLand;
          t?.fact(exits.first, islandsLand, IslandsRule.exit.index, premises: around(comps[k]), args: [anchor]);
          changed = true;
        }
      }
      if (changed) continue;

      // Cells touching two numbered islands, and cells no island can reach.
      // near: the numbered island a cell is in or next to (-1 none, -2 several).
      final near = List<int>.filled(n, -1);
      for (var i = 0; i < n; i++) {
        void see(int x) {
          final k = compOf[x];
          if (k < 0 || clueOf[k] < 0 || near[i] == k) return;
          near[i] = near[i] == -1 ? k : -2;
        }

        see(i);
        for (final x in nb[i]) {
          see(x);
        }
        if (near[i] == -2 && st[i] == _unk) {
          st[i] = islandsSea;
          t?.fact(
            i,
            islandsSea,
            IslandsRule.between.index,
            premises: [
              for (final x in nb[i])
                if (compOf[x] >= 0) ...comps[compOf[x]],
            ],
          );
          changed = true;
        }
      }
      if (changed) continue;
      final reach = List<bool>.filled(n, false);
      final dist = List<int>.filled(n, -1);
      final queue = <int>[];
      for (var k = 0; k < comps.length; k++) {
        if (clueOf[k] < 0) continue;
        final left = clues[clueOf[k]]! - comps[k].length;
        queue
          ..clear()
          ..addAll(comps[k]);
        for (final i in comps[k]) {
          dist[i] = 0;
        }
        for (var q = 0; q < queue.length; q++) {
          final i = queue[q];
          reach[i] = true;
          final d = dist[i];
          if (d >= left) continue;
          for (final j in nb[i]) {
            if (dist[j] >= 0 || st[j] == islandsSea || (near[j] != -1 && near[j] != k)) continue;
            dist[j] = d + 1;
            queue.add(j);
          }
        }
        for (final i in queue) {
          dist[i] = -1;
        }
      }
      // What reaching looked at: the numbered islands and the sea.
      List<int> reachPremises() => [
        for (var i = 0; i < n; i++)
          if (st[i] == islandsSea || (compOf[i] >= 0 && clueOf[compOf[i]] >= 0)) i,
      ];
      for (var i = 0; i < n; i++) {
        if (reach[i]) continue;
        if (st[i] == islandsLand) {
          t?.fail(IslandsRule.failUnreachable.index, premises: [i, ...reachPremises()], args: [i]);
          return false;
        }
        if (st[i] == _unk) {
          st[i] = islandsSea;
          t?.fact(i, islandsSea, IslandsRule.unreachable.index, premises: reachPremises());
          changed = true;
        }
      }
      if (changed) continue;

      // The sea is one piece: a pool with a single way out takes it.
      final seas = components(nb, (i) => st[i] == islandsSea);
      if (seas.length > 1) {
        for (final s in seas) {
          final exits = <int>{
            for (final i in s)
              for (final j in nb[i])
                if (st[j] == _unk) j,
          };
          if (exits.isEmpty) {
            t?.fail(IslandsRule.failSeaShut.index, premises: around(s), args: [s.first]);
            return false;
          }
          if (exits.length == 1) {
            st[exits.first] = islandsSea;
            t?.fact(exits.first, islandsSea, IslandsRule.seaExit.index, premises: around(s), args: [s.first]);
            changed = true;
            break;
          }
        }
      }
      if (!changed) return true;
    }
  }

  bool _valid(List<int> st) => islandsConflicts(
    rows,
    cols,
    clues,
    [for (final v in st) v == islandsSea],
    complete: true,
  ).isEmpty;

  bool solved(List<int> st) => !st.contains(_unk);

  /// Fills in [st] using logic up to [tier]; true if it gets fully determined.
  bool solve(List<int> st, int tier) {
    if (!propagate(st)) return false;
    if (tier >= 2) {
      var progress = true;
      while (progress && !solved(st)) {
        progress = false;
        for (var i = 0; i < n; i++) {
          if (st[i] != _unk) continue;
          for (final v in const [islandsSea, islandsLand]) {
            final t = List.of(st);
            t[i] = v;
            if (!propagate(t)) {
              st[i] = v == islandsSea ? islandsLand : islandsSea;
              if (!propagate(st)) return false;
              progress = true;
              break;
            }
          }
        }
      }
    }
    return solved(st);
  }

  int countSolutions(List<int> st, {int limit = 2}) {
    final t = List.of(st);
    if (!propagate(t)) return 0;
    final i = t.indexOf(_unk);
    if (i < 0) return 1;
    var total = 0;
    for (final v in const [islandsSea, islandsLand]) {
      if (total >= limit) break;
      total += countSolutions(List.of(t)..[i] = v, limit: limit - total);
    }
    return total;
  }
}
