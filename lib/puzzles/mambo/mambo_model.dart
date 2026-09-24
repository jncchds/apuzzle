import '../../core/grid.dart';
import '../../core/value_grid.dart';

const int sun = 0;
const int moon = 1;

/// Constraint between two orthogonally adjacent cells ([b] is right of or below [a]).
class MamboEdge {
  const MamboEdge(this.a, this.b, this.same);

  final int a;
  final int b;

  /// true: "=" (same symbol), false: "×" (different symbols).
  final bool same;

  List<int> toJson() => [a, b, same ? 1 : 0];
  factory MamboEdge.fromJson(List j) => MamboEdge(j[0] as int, j[1] as int, j[2] == 1);
}

class MamboPuzzle implements ValueGridPuzzle {
  const MamboPuzzle({required this.n, required this.givens, required this.solution, required this.edges});

  final int n;
  final List<int?> givens;
  final List<int> solution;
  final List<MamboEdge> edges;

  @override
  GridSize get size => GridSize.square(n);

  @override
  int? givenAt(int index) => givens[index];

  @override
  int solutionAt(int index) => solution[index];

  Map<String, dynamic> toJson() => {
        'n': n,
        'givens': givens,
        'solution': solution,
        'edges': [for (final e in edges) e.toJson()],
      };

  factory MamboPuzzle.fromJson(Map<String, dynamic> j) => MamboPuzzle(
        n: j['n'] as int,
        givens: (j['givens'] as List).cast<int?>(),
        solution: (j['solution'] as List).cast<int>(),
        edges: [for (final e in j['edges'] as List) MamboEdge.fromJson(e as List)],
      );
}

/// Rows then columns, as lists of flat indices.
List<List<int>> mamboLines(int n) => [
      for (var r = 0; r < n; r++) [for (var c = 0; c < n; c++) r * n + c],
      for (var c = 0; c < n; c++) [for (var r = 0; r < n; r++) r * n + c],
    ];

/// Cells that break a rule in a (possibly partial) grid; -1 = empty.
Set<int> mamboConflicts(int n, List<int> g, List<MamboEdge> edges) {
  final bad = <int>{};
  final half = n ~/ 2;
  for (final line in mamboLines(n)) {
    for (final v in [sun, moon]) {
      final cells = line.where((i) => g[i] == v).toList();
      if (cells.length > half) bad.addAll(cells);
    }
    for (var k = 0; k + 2 < line.length; k++) {
      final a = g[line[k]];
      if (a != -1 && a == g[line[k + 1]] && a == g[line[k + 2]]) bad.addAll(line.sublist(k, k + 3));
    }
  }
  for (final e in edges) {
    final va = g[e.a], vb = g[e.b];
    if (va != -1 && vb != -1 && (va == vb) != e.same) bad.addAll([e.a, e.b]);
  }
  return bad;
}
