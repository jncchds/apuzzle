import '../../core/grid_graph.dart';

/// Deductions from the open cells' numbers. Knowledge per cell: -1 unknown,
/// 0 safe, 1 mine.
/// Tier 1: single numbers (all mines found → rest safe, and the reverse).
/// Tier 2: + pairs of overlapping numbers.
/// Tier 3: + the total mine count and probing (assume, refute).
class MinesSolver {
  MinesSolver(this.rows, this.cols, this.counts, this.mineCount) : kn = kingNeighbors(rows, cols);

  final int rows;
  final int cols;

  /// Mines around each cell (only read for open cells).
  final List<int> counts;
  final int mineCount;
  final List<List<int>> kn;

  /// Knowledge for the given open cells and flagged-as-known mines.
  List<int> knowledge(List<bool> open, [List<bool>? mines]) => [
        for (var i = 0; i < open.length; i++)
          open[i]
              ? 0
              : mines != null && mines[i]
                  ? 1
                  : -1,
      ];

  /// Extends [k] with everything [tier] logic proves; false on a contradiction.
  bool deduce(List<bool> open, List<int> k, int tier) {
    if (!_propagate(open, k, pairs: tier >= 2, global: tier >= 3)) return false;
    if (tier < 3) return true;
    var progress = true;
    while (progress) {
      progress = false;
      for (var i = 0; i < k.length; i++) {
        if (k[i] != -1 || !kn[i].any((j) => open[j])) continue;
        for (final v in const [1, 0]) {
          final t = List.of(k)..[i] = v;
          if (!_propagate(open, t, pairs: true, global: true)) {
            k[i] = 1 - v;
            if (!_propagate(open, k, pairs: true, global: true)) return false;
            progress = true;
            break;
          }
        }
      }
    }
    return true;
  }

  bool _set(List<int> k, Iterable<int> cells, int v) {
    var changed = false;
    for (final c in cells) {
      if (k[c] == -1) {
        k[c] = v;
        changed = true;
      }
    }
    return changed;
  }

  bool _propagate(List<bool> open, List<int> k, {required bool pairs, required bool global}) {
    var changed = true;
    while (changed) {
      changed = false;
      // Constraints: unknown cells around an open number and the mines left there.
      final cells = <List<int>>[];
      final need = <int>[];
      for (var i = 0; i < k.length; i++) {
        if (!open[i]) continue;
        final u = <int>[];
        var m = 0;
        for (final j in kn[i]) {
          if (k[j] == -1) u.add(j);
          if (k[j] == 1) m++;
        }
        final left = counts[i] - m;
        if (left < 0 || left > u.length) return false;
        if (u.isEmpty) continue;
        if (left == 0 || left == u.length) {
          changed |= _set(k, u, left == 0 ? 0 : 1);
          continue;
        }
        cells.add(u);
        need.add(left);
      }
      if (changed) continue;
      if (global) {
        var mines = 0, unknown = 0;
        for (final v in k) {
          if (v == 1) mines++;
          if (v == -1) unknown++;
        }
        final left = mineCount - mines;
        if (left < 0 || left > unknown) return false;
        if (unknown > 0 && (left == 0 || left == unknown)) {
          _set(k, [for (var i = 0; i < k.length; i++) if (k[i] == -1) i], left == 0 ? 0 : 1);
          changed = true;
          continue;
        }
      }
      if (!pairs) break;
      final byCell = <int, List<int>>{};
      for (var a = 0; a < cells.length; a++) {
        for (final c in cells[a]) {
          (byCell[c] ??= []).add(a);
        }
      }
      for (var a = 0; a < cells.length && !changed; a++) {
        final others = <int>{for (final c in cells[a]) ...byCell[c]!}..remove(a);
        for (final b in others) {
          final setA = cells[a].toSet();
          final both = [for (final c in cells[b]) if (setA.contains(c)) c];
          final onlyA = [for (final c in cells[a]) if (!both.contains(c)) c];
          final onlyB = [for (final c in cells[b]) if (!setA.contains(c)) c];
          final lo = [0, need[a] - onlyA.length, need[b] - onlyB.length].reduce((x, y) => x > y ? x : y);
          final hi = [both.length, need[a], need[b]].reduce((x, y) => x < y ? x : y);
          if (lo > hi) return false;
          if (onlyB.isNotEmpty && need[b] - hi == onlyB.length) changed |= _set(k, onlyB, 1);
          if (onlyB.isNotEmpty && need[b] - lo == 0) changed |= _set(k, onlyB, 0);
          if (onlyA.isNotEmpty && need[a] - hi == onlyA.length) changed |= _set(k, onlyA, 1);
          if (onlyA.isNotEmpty && need[a] - lo == 0) changed |= _set(k, onlyA, 0);
          if (changed) break;
        }
      }
    }
    return true;
  }
}
