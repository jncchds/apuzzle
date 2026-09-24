/// Sound edge logic for Trail (a Hamiltonian path through ordered waypoints).
///
/// Every pair of neighbouring cells is an edge that is on, off or unknown.
///  Tier 1: degrees (2 per cell, 1 at the first and last number), no cycles,
///          the two path ends may only meet once every cell is covered, the
///          numbers along a joined stretch must run consecutively, and the
///          usable edges must keep the board connected.
///  Tier 2: + probing single edges with tier 1.
/// Every rule holds in every solution, so a full solve proves uniqueness.
class TrailLogic {
  TrailLogic(this.rows, this.cols, List<int?> numbers)
      : n = rows * cols,
        num = [for (final v in numbers) v ?? 0] {
    for (var i = 0; i < n; i++) {
      final r = i ~/ cols, c = i % cols;
      if (c + 1 < cols) _addEdge(i, i + 1);
      if (r + 1 < rows) _addEdge(i, i + cols);
    }
    for (var i = 0; i < n; i++) {
      if (num[i] > last) last = num[i];
    }
    target = [for (var i = 0; i < n; i++) num[i] == 1 || (num[i] == last && last > 1) ? 1 : 2];
  }

  final int rows;
  final int cols;
  final int n;
  final List<int> num;
  int last = 0;
  late final List<int> target;
  final List<int> ea = [];
  final List<int> eb = [];
  late final List<List<int>> edgesOf = List.generate(n, (_) => <int>[]);

  void _addEdge(int a, int b) {
    edgesOf[a].add(ea.length);
    edgesOf[b].add(ea.length);
    ea.add(a);
    eb.add(b);
  }

  int get edgeCount => ea.length;

  /// Edge states after logic up to [tier] (1 on, -1 off, 0 unknown), or null
  /// on a contradiction.
  List<int>? run(int tier) {
    final e = List<int>.filled(edgeCount, 0);
    if (!_propagate(e)) return null;
    if (tier >= 2) {
      var progress = true;
      while (progress && e.contains(0)) {
        progress = false;
        for (var k = 0; k < edgeCount; k++) {
          if (e[k] != 0) continue;
          for (final v in const [1, -1]) {
            final trial = List.of(e)..[k] = v;
            if (!_propagate(trial)) {
              e[k] = -v;
              if (!_propagate(e)) return null;
              progress = true;
              break;
            }
          }
        }
      }
    }
    return e;
  }

  /// The path if logic up to [tier] determines it, else null.
  List<int>? solve(int tier) {
    final e = run(tier);
    if (e == null || e.contains(0)) return null;
    final start = num.indexOf(1);
    final path = [start];
    var prev = -1, cur = start;
    while (true) {
      var next = -1;
      for (final k in edgesOf[cur]) {
        if (e[k] != 1) continue;
        final o = ea[k] == cur ? eb[k] : ea[k];
        if (o != prev) next = o;
      }
      if (next < 0) break;
      path.add(next);
      prev = cur;
      cur = next;
    }
    return path.length == n ? path : null;
  }

  /// Cells whose edges logic up to [tier] leaves open.
  List<int> openCells(int tier) {
    final e = run(tier);
    if (e == null) return const [];
    return [
      for (var i = 0; i < n; i++)
        if (edgesOf[i].any((k) => e[k] == 0)) i,
    ];
  }

  bool _propagate(List<int> e) {
    final comp = List<int>.filled(n, -1);
    final endA = <int>[], endB = <int>[];
    final nums = <List<int>>[];
    final size = <int>[];
    while (true) {
      var changed = false;

      // Degrees.
      for (var i = 0; i < n; i++) {
        var on = 0, open = 0;
        for (final k in edgesOf[i]) {
          if (e[k] == 1) on++;
          if (e[k] == 0) open++;
        }
        final t = target[i];
        if (on > t || on + open < t) return false;
        if (open == 0) continue;
        if (on == t) {
          for (final k in edgesOf[i]) {
            if (e[k] == 0) e[k] = -1;
          }
          changed = true;
        } else if (on + open == t) {
          for (final k in edgesOf[i]) {
            if (e[k] == 0) e[k] = 1;
          }
          changed = true;
        }
      }
      if (changed) continue;

      // Chains of on-edges: ends and the numbers along them.
      comp.fillRange(0, n, -1);
      endA.clear();
      endB.clear();
      nums.clear();
      size.clear();
      for (var s = 0; s < n; s++) {
        if (comp[s] >= 0 || _onDegree(e, s) == 2) continue;
        // s is a chain end (or a lone cell): walk to the other end.
        final id = endA.length;
        final seq = <int>[];
        var prev = -1, cur = s, len = 0;
        while (true) {
          comp[cur] = id;
          len++;
          if (num[cur] > 0) seq.add(num[cur]);
          var next = -1;
          for (final k in edgesOf[cur]) {
            if (e[k] != 1) continue;
            final o = ea[k] == cur ? eb[k] : ea[k];
            if (o != prev) next = o;
          }
          if (next < 0) break;
          prev = cur;
          cur = next;
        }
        endA.add(s);
        endB.add(cur);
        nums.add(seq);
        size.add(len);
        if (!_consecutive(seq)) return false;
      }
      // Cells left without a component lie on a closed loop.
      if (comp.contains(-1)) return false;

      for (var k = 0; k < edgeCount; k++) {
        if (e[k] != 0) continue;
        final a = ea[k], b = eb[k], ca = comp[a], cb = comp[b];
        var bad = ca == cb;
        if (!bad) {
          final sa = a == endB[ca] ? nums[ca] : nums[ca].reversed.toList();
          final sb = b == endA[cb] ? nums[cb] : nums[cb].reversed.toList();
          final joined = [...sa, ...sb];
          bad = !_consecutive(joined) ||
              (size[ca] + size[cb] < n && joined.contains(1) && joined.contains(last) && last > 1);
        }
        if (bad) {
          e[k] = -1;
          changed = true;
        }
      }
      if (changed) continue;

      return _connected(e);
    }
  }

  int _onDegree(List<int> e, int i) {
    var d = 0;
    for (final k in edgesOf[i]) {
      if (e[k] == 1) d++;
    }
    return d;
  }

  static bool _consecutive(List<int> seq) {
    if (seq.length < 2) return true;
    final dir = seq[1] - seq[0];
    if (dir != 1 && dir != -1) return false;
    for (var k = 2; k < seq.length; k++) {
      if (seq[k] - seq[k - 1] != dir) return false;
    }
    return true;
  }

  bool _connected(List<int> e) {
    final seen = List<bool>.filled(n, false)..[0] = true;
    final stack = [0];
    var count = 1;
    while (stack.isNotEmpty) {
      final i = stack.removeLast();
      for (final k in edgesOf[i]) {
        if (e[k] == -1) continue;
        final o = ea[k] == i ? eb[k] : ea[k];
        if (!seen[o]) {
          seen[o] = true;
          count++;
          stack.add(o);
        }
      }
    }
    return count == n;
  }
}
