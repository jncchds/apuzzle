import 'hues_model.dart';

/// Domain-bitmask solver. Tier 1: per-clue counting; tier 2: + probing.
class HuesSolver {
  HuesSolver({required this.rows, required this.cols, required this.colors, required this.clueNum, required this.clueColor})
      : nb = huesNeighbors(rows, cols),
        full = (1 << colors) - 1 {
    for (var i = 0; i < rows * cols; i++) {
      if (clueNum[i] != null) {
        clueCells.add(i);
        clueNb[i] = [for (final j in nb[i]) if (clueNum[j] == null) j];
      }
    }
  }

  final int rows;
  final int cols;
  final int colors;
  final List<int?> clueNum;
  final List<int> clueColor; // valid where clueNum != null
  final List<List<int>> nb;
  final int full;
  final List<int> clueCells = [];
  final Map<int, List<int>> clueNb = {};

  static bool _single(int m) => m != 0 && m & (m - 1) == 0;

  /// Domains: bitmask per empty cell (clue cells are ignored).
  List<int> initialDomains() => [for (var i = 0; i < rows * cols; i++) clueNum[i] == null ? full : 0];

  bool propagate(List<int> dom) {
    var changed = true;
    while (changed) {
      changed = false;
      for (final c in clueCells) {
        final m = clueNum[c]!;
        final bit = 1 << clueColor[c];
        var a = 0;
        final open = <int>[];
        for (final j in clueNb[c]!) {
          final d = dom[j];
          if (d == 0) return false;
          if (d == bit) {
            a++;
          } else if (d & bit != 0) {
            open.add(j);
          }
        }
        if (a > m || a + open.length < m) return false;
        if (open.isEmpty) continue;
        if (a == m) {
          for (final j in open) {
            dom[j] &= ~bit;
            if (dom[j] == 0) return false;
          }
          changed = true;
        } else if (a + open.length == m) {
          for (final j in open) {
            dom[j] = bit;
          }
          changed = true;
        }
      }
    }
    return true;
  }

  bool solved(List<int> dom) {
    for (var i = 0; i < dom.length; i++) {
      if (clueNum[i] == null && !_single(dom[i])) return false;
    }
    return true;
  }

  /// True if fully determined using logic up to [tier].
  bool solveLogic(List<int> dom, int tier) {
    if (!propagate(dom)) return false;
    if (tier >= 2) {
      var progress = true;
      while (progress && !solved(dom)) {
        progress = false;
        for (var i = 0; i < dom.length && !progress; i++) {
          if (clueNum[i] != null || _single(dom[i])) continue;
          for (var col = 0; col < colors; col++) {
            final bit = 1 << col;
            if (dom[i] & bit == 0) continue;
            final t = List.of(dom);
            t[i] = bit;
            if (!propagate(t)) {
              dom[i] &= ~bit;
              if (!propagate(dom)) return false;
              progress = true;
              break;
            }
          }
        }
      }
    }
    return solved(dom);
  }

  int countSolutions(List<int> dom, {int limit = 2}) {
    final t = List.of(dom);
    if (!propagate(t)) return 0;
    var best = -1;
    for (var i = 0; i < t.length; i++) {
      if (clueNum[i] == null && !_single(t[i])) {
        best = i;
        break;
      }
    }
    if (best < 0) return 1;
    var total = 0;
    for (var col = 0; col < colors && total < limit; col++) {
      final bit = 1 << col;
      if (t[best] & bit == 0) continue;
      final u = List.of(t);
      u[best] = bit;
      total += countSolutions(u, limit: limit - total);
    }
    return total;
  }
}
