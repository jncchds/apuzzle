import '../../core/grid.dart';

/// A potential bond between two islands that see each other.
class AtomEdge {
  const AtomEdge(this.a, this.b, this.horizontal);

  /// Island indices (into [AtomsPuzzle.islands]); a is left/top of b.
  final int a;
  final int b;
  final bool horizontal;

  List<int> toJson() => [a, b, horizontal ? 1 : 0];
  factory AtomEdge.fromJson(List j) => AtomEdge(j[0] as int, j[1] as int, j[2] == 1);
}

class AtomsPuzzle {
  const AtomsPuzzle({
    required this.rows,
    required this.cols,
    required this.islands,
    required this.numbers,
    required this.edges,
    required this.solution,
  });

  final int rows;
  final int cols;

  /// Cell index of each island.
  final List<int> islands;
  final List<int> numbers;
  final List<AtomEdge> edges;

  /// Bond count per edge in the solution.
  final List<int> solution;

  GridSize get size => GridSize(rows, cols);

  Map<String, dynamic> toJson() => {
        'rows': rows,
        'cols': cols,
        'islands': islands,
        'numbers': numbers,
        'edges': [for (final e in edges) e.toJson()],
        'solution': solution,
      };
  factory AtomsPuzzle.fromJson(Map<String, dynamic> j) => AtomsPuzzle(
        rows: j['rows'] as int,
        cols: j['cols'] as int,
        islands: (j['islands'] as List).cast<int>(),
        numbers: (j['numbers'] as List).cast<int>(),
        edges: [for (final e in j['edges'] as List) AtomEdge.fromJson(e as List)],
        solution: (j['solution'] as List).cast<int>(),
      );
}

class AtomsState {
  const AtomsState(this.bonds);
  final List<int> bonds;

  Map<String, dynamic> toJson() => {'bonds': bonds};
  factory AtomsState.fromJson(Map<String, dynamic> j) => AtomsState((j['bonds'] as List).cast<int>());
}

/// All island pairs that see each other along a row/column.
List<AtomEdge> atomEdges(int rows, int cols, List<int> islands) {
  final at = <int, int>{for (var k = 0; k < islands.length; k++) islands[k]: k};
  final edges = <AtomEdge>[];
  for (var k = 0; k < islands.length; k++) {
    final i = islands[k], r = i ~/ cols, c = i % cols;
    for (var cc = c + 1; cc < cols; cc++) {
      final j = at[r * cols + cc];
      if (j != null) {
        edges.add(AtomEdge(k, j, true));
        break;
      }
    }
    for (var rr = r + 1; rr < rows; rr++) {
      final j = at[rr * cols + c];
      if (j != null) {
        edges.add(AtomEdge(k, j, false));
        break;
      }
    }
  }
  return edges;
}

/// Pairs of edge indices whose bridges would cross.
List<List<int>> atomCrossings(int cols, List<int> islands, List<AtomEdge> edges) {
  final out = List.generate(edges.length, (_) => <int>[]);
  for (var x = 0; x < edges.length; x++) {
    final h = edges[x];
    if (!h.horizontal) continue;
    final hr = islands[h.a] ~/ cols, hc0 = islands[h.a] % cols, hc1 = islands[h.b] % cols;
    for (var y = 0; y < edges.length; y++) {
      final v = edges[y];
      if (v.horizontal) continue;
      final vc = islands[v.a] % cols, vr0 = islands[v.a] ~/ cols, vr1 = islands[v.b] ~/ cols;
      if (vc > hc0 && vc < hc1 && hr > vr0 && hr < vr1) {
        out[x].add(y);
        out[y].add(x);
      }
    }
  }
  return out;
}

/// Island indices breaking a rule in a (partial) state.
Set<int> atomsConflicts(AtomsPuzzle p, List<int> bonds) {
  final bad = <int>{};
  final sums = List<int>.filled(p.islands.length, 0);
  for (var e = 0; e < p.edges.length; e++) {
    sums[p.edges[e].a] += bonds[e];
    sums[p.edges[e].b] += bonds[e];
  }
  for (var k = 0; k < sums.length; k++) {
    if (sums[k] > p.numbers[k]) bad.add(k);
  }
  final cross = atomCrossings(p.cols, p.islands, p.edges);
  for (var e = 0; e < p.edges.length; e++) {
    if (bonds[e] == 0) continue;
    for (final f in cross[e]) {
      if (bonds[f] > 0) bad.addAll([p.edges[e].a, p.edges[e].b, p.edges[f].a, p.edges[f].b]);
    }
  }
  return bad;
}

bool atomsConnected(AtomsPuzzle p, List<int> bonds) {
  final adj = List.generate(p.islands.length, (_) => <int>[]);
  for (var e = 0; e < p.edges.length; e++) {
    if (bonds[e] > 0) {
      adj[p.edges[e].a].add(p.edges[e].b);
      adj[p.edges[e].b].add(p.edges[e].a);
    }
  }
  final seen = {0};
  final stack = [0];
  while (stack.isNotEmpty) {
    for (final j in adj[stack.removeLast()]) {
      if (seen.add(j)) stack.add(j);
    }
  }
  return seen.length == p.islands.length;
}

bool atomsSolved(AtomsPuzzle p, List<int> bonds) {
  final sums = List<int>.filled(p.islands.length, 0);
  for (var e = 0; e < p.edges.length; e++) {
    sums[p.edges[e].a] += bonds[e];
    sums[p.edges[e].b] += bonds[e];
  }
  for (var k = 0; k < sums.length; k++) {
    if (sums[k] != p.numbers[k]) return false;
  }
  return atomsConflicts(p, bonds).isEmpty && atomsConnected(p, bonds);
}
