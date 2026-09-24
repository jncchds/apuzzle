/// Counts Hamiltonian paths through numbered waypoints in order, with
/// dead-end and connectivity pruning.
class TrailSolver {
  TrailSolver(this.rows, this.cols, this.numbers)
      : n = rows * cols,
        nb = List.generate(rows * cols, (i) {
          final r = i ~/ cols, c = i % cols;
          return [if (r > 0) i - cols, if (r < rows - 1) i + cols, if (c > 0) i - 1, if (c < cols - 1) i + 1];
        }) {
    for (var i = 0; i < n; i++) {
      final v = numbers[i];
      if (v != null) {
        if (v > last) last = v;
        cellOf[v] = i;
      }
    }
  }

  final int rows;
  final int cols;
  final List<int?> numbers;
  final int n;
  final List<List<int>> nb;
  final Map<int, int> cellOf = {};
  int last = 0;

  /// Up to [limit] solutions. [budget] caps visited nodes (returns what was
  /// found so far when exceeded; callers treat that as "not unique").
  List<List<int>> solutions({int limit = 2, int budget = 4000000}) {
    final out = <List<int>>[];
    final visited = List<bool>.filled(n, false);
    final path = <int>[];
    var nodes = 0;
    var aborted = false;
    final endCell = cellOf[last]!;

    bool connectedOk(int head) {
      // All unvisited cells must be reachable from head through unvisited cells.
      final seen = List<bool>.filled(n, false);
      final stack = [head];
      seen[head] = true;
      var count = 0;
      while (stack.isNotEmpty) {
        final i = stack.removeLast();
        for (final j in nb[i]) {
          if (!visited[j] && !seen[j]) {
            seen[j] = true;
            count++;
            stack.add(j);
          }
        }
      }
      return count == n - path.length;
    }

    bool deadEnds(int head) {
      // An unvisited cell with fewer than 2 free neighbours must be the end.
      for (final i in nb[head]) {
        if (visited[i]) continue;
        var free = 0;
        for (final j in nb[i]) {
          if (!visited[j] || j == head) free++;
        }
        if (free < 2 && i != endCell && path.length < n - 1) return true;
        if (free == 0) return true;
      }
      return false;
    }

    void rec(int head, int next) {
      if (out.length >= limit || aborted) return;
      if (++nodes > budget) {
        aborted = true;
        return;
      }
      if (path.length == n) {
        if (head == endCell) out.add(List.of(path));
        return;
      }
      if (head == endCell) return; // reached the end too early
      if (deadEnds(head) || !connectedOk(head)) return;
      for (final j in nb[head]) {
        if (visited[j]) continue;
        final v = numbers[j];
        if (v != null && v != next) continue;
        visited[j] = true;
        path.add(j);
        rec(j, v != null ? next + 1 : next);
        path.removeLast();
        visited[j] = false;
        if (out.length >= limit || aborted) return;
      }
    }

    final start = cellOf[1]!;
    visited[start] = true;
    path.add(start);
    rec(start, 2);
    if (aborted && out.length < limit) {
      // Unknown: report as ambiguous by duplicating (forces more clues).
      if (out.isNotEmpty) out.add(out.first);
    }
    return out;
  }
}
