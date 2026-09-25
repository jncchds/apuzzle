import '../../core/grid.dart';
import '../../core/grid_graph.dart';
import '../../core/value_grid.dart';

const int campGrass = 0;
const int campTent = 1;
const int campTree = 2;

/// Tents: every tree gets its own tent next to it (up/down/left/right), tents
/// never touch (not even diagonally), and rows/columns hold the given counts.
class CampPuzzle implements ValueGridPuzzle {
  const CampPuzzle({
    required this.rows,
    required this.cols,
    required this.trees,
    required this.tents,
    required this.rowCounts,
    required this.colCounts,
    this.givenTents = const [],
  });

  final int rows;
  final int cols;
  final List<bool> trees;

  /// Solution.
  final List<bool> tents;

  /// Tents per row/column, null where the count is hidden.
  final List<int?> rowCounts;
  final List<int?> colCounts;

  /// Tents shown from the start (cells where the logic needed help).
  final List<int> givenTents;

  @override
  GridSize get size => GridSize(rows, cols);
  int get treeCount => trees.where((t) => t).length;

  @override
  int? givenAt(int index) => trees[index]
      ? campTree
      : givenTents.contains(index)
          ? campTent
          : null;
  @override
  int solutionAt(int index) => trees[index]
      ? campTree
      : tents[index]
          ? campTent
          : campGrass;

  Map<String, dynamic> toJson() => {
        'rows': rows,
        'cols': cols,
        'trees': [for (var i = 0; i < trees.length; i++) if (trees[i]) i],
        'tents': [for (var i = 0; i < tents.length; i++) if (tents[i]) i],
        'rc': rowCounts,
        'cc': colCounts,
        if (givenTents.isNotEmpty) 'given': givenTents,
      };

  factory CampPuzzle.fromJson(Map<String, dynamic> j) {
    final rows = j['rows'] as int, cols = j['cols'] as int;
    List<bool> mask(String k) {
      final m = List<bool>.filled(rows * cols, false);
      for (final i in (j[k] as List).cast<int>()) {
        m[i] = true;
      }
      return m;
    }

    return CampPuzzle(
      rows: rows,
      cols: cols,
      trees: mask('trees'),
      tents: mask('tents'),
      rowCounts: (j['rc'] as List).cast<int?>(),
      colCounts: (j['cc'] as List).cast<int?>(),
      givenTents: ((j['given'] as List?) ?? const []).cast<int>(),
    );
  }
}

/// Maximum bipartite matching of [left] vertices to cells, where [options]
/// lists the cells each left vertex may take. Returns the partner cell per
/// left vertex (-1 if unmatched).
List<int> maxMatching(List<List<int>> options, int cellCount) {
  final owner = List<int>.filled(cellCount, -1);
  final match = List<int>.filled(options.length, -1);
  bool augment(int u, List<bool> seen) {
    for (final v in options[u]) {
      if (seen[v]) continue;
      seen[v] = true;
      if (owner[v] < 0 || augment(owner[v], seen)) {
        owner[v] = u;
        match[u] = v;
        return true;
      }
    }
    return false;
  }

  for (var u = 0; u < options.length; u++) {
    augment(u, List<bool>.filled(cellCount, false));
  }
  return match;
}

/// Cells breaking a rule, given the tents placed so far. With [complete],
/// row/column counts and the tree pairing are checked too.
Set<int> campConflicts(CampPuzzle p, List<bool> tents, {required bool complete}) {
  final bad = <int>{};
  final kn = kingNeighbors(p.rows, p.cols);
  final on = orthNeighbors(p.rows, p.cols);
  for (var i = 0; i < tents.length; i++) {
    if (!tents[i]) continue;
    if (kn[i].any((j) => tents[j])) bad.add(i);
    if (!on[i].any((j) => p.trees[j])) bad.add(i);
  }
  void line(Iterable<int> cells, int? want) {
    if (want == null) return;
    final t = [for (final i in cells) if (tents[i]) i];
    if (t.length > want || (complete && t.length != want)) bad.addAll(t.isEmpty ? cells : t);
  }

  for (var r = 0; r < p.rows; r++) {
    line([for (var c = 0; c < p.cols; c++) r * p.cols + c], p.rowCounts[r]);
  }
  for (var c = 0; c < p.cols; c++) {
    line([for (var r = 0; r < p.rows; r++) r * p.cols + c], p.colCounts[c]);
  }
  if (complete && bad.isEmpty) {
    final treeList = [for (var i = 0; i < p.trees.length; i++) if (p.trees[i]) i];
    final m = maxMatching([for (final t in treeList) [for (final j in on[t]) if (tents[j]) j]], tents.length);
    final used = m.where((v) => v >= 0).toSet();
    for (var k = 0; k < treeList.length; k++) {
      if (m[k] < 0) bad.add(treeList[k]);
    }
    for (var i = 0; i < tents.length; i++) {
      if (tents[i] && !used.contains(i)) bad.add(i);
    }
  }
  return bad;
}
