import '../../core/explain.dart';
import '../../core/lattice_loop.dart';
import 'domino_model.dart';

/// Deductions of [DominoSolver], recorded in explain traces.
enum DominoRule {
  /// The pair fits in one spot only (args: a, b).
  onlySpot,

  /// The cell has one neighbour left to pair with (args: cell).
  onlyWay,

  /// The cell is in a domino already (args: cell).
  covered,

  /// The pair is placed already (args: a, b, its edge).
  used,

  /// Every spot left for the pair covers the cell (args: a, b, cell).
  pairAtCell,

  /// Every domino the cell can be in is the same pair (args: a, b, cell).
  cellOnePair,

  /// No domino can cover the cell (args: cell).
  failCell,

  /// The pair has no spot left (args: a, b).
  failPair,

  /// The cell would be in two dominoes (args: cell).
  failCellTwice,

  /// The pair would be placed twice (args: a, b).
  failPairTwice,

  /// A piece of open cells has an odd size (args: a cell of it, its size).
  failOdd,
}

/// Knowledge per edge: -1 open, 0 not a domino, 1 a domino. Tiers:
/// 1 = a pair with one spot, a cell with one neighbour, placed pairs and
/// covered cells rule out the rest; 2 = + a pair whose spots all cover one
/// cell, a cell whose dominoes are all one pair, and pieces of an odd size
/// fail; 3 = + probing (assume an edge, refute it with tier 2).
class DominoSolver {
  DominoSolver(this.rows, this.cols, this.nums) : g = LatticeLoop(rows, cols) {
    var top = 0;
    for (final x in nums) {
      if (x > top) top = x;
    }
    pairs = dominoCount(top);
    pairOf = [
      for (var e = 0; e < g.edgeCount; e++) dominoIndex(nums[g.ends(e).$1], nums[g.ends(e).$2]),
    ];
    spots = List.generate(pairs, (_) => <int>[]);
    for (var e = 0; e < g.edgeCount; e++) {
      spots[pairOf[e]].add(e);
    }
    numbers = List.filled(pairs, (0, 0));
    for (var b = 0; b <= top; b++) {
      for (var a = 0; a <= b; a++) {
        numbers[dominoIndex(a, b)] = (a, b);
      }
    }
  }

  DominoSolver.of(DominoPuzzle p) : this(p.rows, p.cols, p.nums);

  final int rows;
  final int cols;
  final List<int> nums;
  final LatticeLoop g;
  late final int pairs;

  /// The pair every edge would make.
  late final List<int> pairOf;

  /// Edges of every pair.
  late final List<List<int>> spots;

  /// The numbers of every pair, smaller first.
  late final List<(int, int)> numbers;

  int get cells => rows * cols;

  List<int> start() => List.filled(g.edgeCount, -1);

  int other(int e, int cell) {
    final (a, b) = g.ends(e);
    return a == cell ? b : a;
  }

  /// The cell's domino edge, or -1.
  int lineAt(List<int> st, int cell) {
    for (final e in g.incident[cell]) {
      if (st[e] == 1) return e;
    }
    return -1;
  }

  /// The pair's placed edge, or -1.
  int placedAt(List<int> st, int pair) {
    for (final e in spots[pair]) {
      if (st[e] == 1) return e;
    }
    return -1;
  }

  /// Makes edge [e] a domino and rules out what that covers; false if a
  /// cell or the pair is taken already.
  bool line(
    List<int> st,
    int e,
    ExplainTrace? t, {
    int rule = -1,
    List<int> premises = const [],
    List<int> args = const [],
  }) {
    final (a, b) = g.ends(e);
    for (final cell in [a, b]) {
      if (lineAt(st, cell) >= 0) {
        t?.fail(DominoRule.failCellTwice.index, premises: [...premises, e, lineAt(st, cell)], args: [cell]);
        return false;
      }
    }
    final pair = pairOf[e];
    final at = placedAt(st, pair);
    if (at >= 0) {
      final (x, y) = numbers[pair];
      t?.fail(DominoRule.failPairTwice.index, premises: [...premises, e, at], args: [x, y]);
      return false;
    }
    st[e] = 1;
    if (rule >= 0) t?.fact(e, 1, rule, premises: premises, args: args);
    for (final cell in [a, b]) {
      for (final f in g.incident[cell]) {
        if (st[f] == -1) {
          st[f] = 0;
          t?.fact(f, 0, DominoRule.covered.index, premises: [e], args: [cell]);
        }
      }
    }
    final (x, y) = numbers[pair];
    for (final f in spots[pair]) {
      if (st[f] == -1) {
        st[f] = 0;
        t?.fact(f, 0, DominoRule.used.index, premises: [e], args: [x, y, e]);
      }
    }
    return true;
  }

  /// Applies the rules of [tier] (1 or 2) until nothing changes; false on a
  /// contradiction.
  bool propagate(List<int> st, int tier, [ExplainTrace? t]) {
    while (true) {
      var changed = false;
      // Cells.
      for (var i = 0; i < cells; i++) {
        if (lineAt(st, i) >= 0) continue;
        var open = -1, count = 0;
        for (final e in g.incident[i]) {
          if (st[e] == -1) {
            open = e;
            count++;
          }
        }
        if (count == 0) {
          t?.fail(DominoRule.failCell.index, premises: g.incident[i], args: [i]);
          return false;
        }
        if (count == 1) {
          final premises = [
            for (final e in g.incident[i])
              if (e != open) e,
          ];
          if (!line(st, open, t, rule: DominoRule.onlyWay.index, premises: premises, args: [i])) return false;
          changed = true;
        }
      }
      // Pairs.
      for (var k = 0; k < pairs; k++) {
        if (placedAt(st, k) >= 0) continue;
        var open = -1, count = 0;
        for (final e in spots[k]) {
          if (st[e] == -1) {
            open = e;
            count++;
          }
        }
        final (x, y) = numbers[k];
        if (count == 0) {
          t?.fail(DominoRule.failPair.index, premises: spots[k], args: [x, y]);
          return false;
        }
        if (count == 1) {
          final premises = [
            for (final e in spots[k])
              if (e != open) e,
          ];
          if (!line(st, open, t, rule: DominoRule.onlySpot.index, premises: premises, args: [x, y])) return false;
          changed = true;
        }
      }
      if (changed) continue;
      if (tier < 2) return true;

      // A pair whose spots all cover one cell takes that cell.
      for (var k = 0; k < pairs; k++) {
        if (placedAt(st, k) >= 0) continue;
        final open = [
          for (final e in spots[k])
            if (st[e] == -1) e,
        ];
        if (open.length < 2) continue;
        final (a0, b0) = g.ends(open.first);
        for (final cell in [a0, b0]) {
          if (!open.every((e) => g.ends(e).$1 == cell || g.ends(e).$2 == cell)) continue;
          final (x, y) = numbers[k];
          for (final f in g.incident[cell]) {
            if (st[f] != -1 || pairOf[f] == k) continue;
            st[f] = 0;
            t?.fact(f, 0, DominoRule.pairAtCell.index, premises: spots[k], args: [x, y, cell]);
            changed = true;
          }
        }
      }
      // A cell whose dominoes are all one pair holds that pair.
      for (var i = 0; i < cells; i++) {
        if (lineAt(st, i) >= 0) continue;
        final open = [
          for (final e in g.incident[i])
            if (st[e] == -1) e,
        ];
        if (open.length < 2) continue;
        final k = pairOf[open.first];
        if (open.any((e) => pairOf[e] != k)) continue;
        final (x, y) = numbers[k];
        for (final f in spots[k]) {
          if (st[f] != -1 || open.contains(f)) continue;
          st[f] = 0;
          t?.fact(f, 0, DominoRule.cellOnePair.index, premises: g.incident[i], args: [x, y, i]);
          changed = true;
        }
      }
      if (changed) continue;
      return _evenPieces(st, t);
    }
  }

  /// Whether every piece of open cells (joined by open edges) has an even size.
  bool _evenPieces(List<int> st, ExplainTrace? t) {
    final seen = List<bool>.filled(cells, false);
    for (var i = 0; i < cells; i++) {
      if (seen[i] || lineAt(st, i) >= 0) continue;
      final piece = [i];
      seen[i] = true;
      for (var k = 0; k < piece.length; k++) {
        for (final e in g.incident[piece[k]]) {
          if (st[e] != -1) continue;
          final j = other(e, piece[k]);
          if (!seen[j]) {
            seen[j] = true;
            piece.add(j);
          }
        }
      }
      if (piece.length.isOdd) {
        t?.fail(
          DominoRule.failOdd.index,
          premises: {
            for (final c in piece)
              for (final e in g.incident[c])
                if (st[e] == 0) e,
          }.toList(),
          args: [piece.reduce((a, b) => a < b ? a : b), piece.length],
        );
        return false;
      }
    }
    return true;
  }

  /// Puts an assumption (or a refutation) into [st]: edge [e] is a domino
  /// ([v] 1) or not (0). False if that clashes at once.
  bool set(List<int> st, int e, int v, [ExplainTrace? t, int rule = -1, List<int> premises = const []]) {
    if (v == 1) return line(st, e, t, rule: rule, premises: premises);
    st[e] = 0;
    if (rule >= 0) t?.fact(e, 0, rule, premises: premises);
    return true;
  }

  bool solved(List<int> st) {
    for (var i = 0; i < cells; i++) {
      if (lineAt(st, i) < 0) return false;
    }
    return true;
  }

  /// Solves [st] as far as [tier] goes (3 probes); false on a contradiction.
  bool solve(List<int> st, int tier) {
    if (!propagate(st, tier < 2 ? tier : 2)) return false;
    if (tier < 3) return true;
    var progress = true;
    while (progress && !solved(st)) {
      progress = false;
      for (var e = 0; e < st.length; e++) {
        if (st[e] != -1) continue;
        for (final v in const [1, 0]) {
          final copy = List.of(st);
          if (set(copy, e, v) && propagate(copy, 2)) continue;
          if (!set(st, e, 1 - v) || !propagate(st, 2)) return false;
          progress = true;
          break;
        }
      }
    }
    return true;
  }

  /// The lowest tier that solves [st] (4 if none does).
  int grade(List<int> st) {
    for (var tier = 1; tier <= 3; tier++) {
      final s = List.of(st);
      if (solve(s, tier) && solved(s)) return tier;
    }
    return 4;
  }

  /// Number of ways to finish [st], up to [limit].
  int countSolutions(List<int> st, {int limit = 2}) {
    final s = List.of(st);
    if (!propagate(s, 2)) return 0;
    var best = -1, bestCount = 5;
    for (var i = 0; i < cells; i++) {
      if (lineAt(s, i) >= 0) continue;
      final count = g.incident[i].where((e) => s[e] == -1).length;
      if (count < bestCount) {
        best = i;
        bestCount = count;
      }
    }
    if (best < 0) return 1;
    var found = 0;
    for (final e in g.incident[best]) {
      if (s[e] != -1) continue;
      final next = List.of(s);
      if (line(next, e, null)) found += countSolutions(next, limit: limit - found);
      if (found >= limit) break;
    }
    return found;
  }
}
