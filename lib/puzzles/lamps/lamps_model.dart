import '../../core/grid.dart';
import '../../core/grid_graph.dart';
import '../../core/value_grid.dart';

const int lampsDot = 0;
const int lampsLamp = 1;
const int lampsWall = 2;

/// Light Up: lamps light their row and column up to the walls. Light every
/// cell, no lamp may shine on another, and numbered walls count the lamps
/// next to them.
class LampsPuzzle implements ValueGridPuzzle {
  const LampsPuzzle({
    required this.rows,
    required this.cols,
    required this.walls,
    required this.numbers,
    required this.lamps,
  });

  final int rows;
  final int cols;
  final List<bool> walls;

  /// Lamps around a wall, or null for a plain wall (and for open cells).
  final List<int?> numbers;

  /// Solution.
  final List<bool> lamps;

  @override
  GridSize get size => GridSize(rows, cols);
  @override
  int? givenAt(int index) => walls[index] ? lampsWall : null;
  @override
  int solutionAt(int index) => walls[index]
      ? lampsWall
      : lamps[index]
          ? lampsLamp
          : lampsDot;

  Map<String, dynamic> toJson() => {
        'rows': rows,
        'cols': cols,
        'walls': [for (var i = 0; i < walls.length; i++) if (walls[i]) i],
        'numbers': numbers,
        'lamps': [for (var i = 0; i < lamps.length; i++) if (lamps[i]) i],
      };

  factory LampsPuzzle.fromJson(Map<String, dynamic> j) {
    final rows = j['rows'] as int, cols = j['cols'] as int;
    List<bool> mask(String k) {
      final m = List<bool>.filled(rows * cols, false);
      for (final i in (j[k] as List).cast<int>()) {
        m[i] = true;
      }
      return m;
    }

    return LampsPuzzle(
      rows: rows,
      cols: cols,
      walls: mask('walls'),
      numbers: (j['numbers'] as List).cast<int?>(),
      lamps: mask('lamps'),
    );
  }
}

/// Open cells each open cell sees along its row and column (up to walls).
List<List<int>> lampsSight(int rows, int cols, List<bool> walls) => List.generate(rows * cols, (i) {
      if (walls[i]) return const <int>[];
      final out = <int>[];
      final r = i ~/ cols, c = i % cols;
      for (final (dr, dc) in const [(-1, 0), (1, 0), (0, -1), (0, 1)]) {
        var rr = r + dr, cc = c + dc;
        while (rr >= 0 && rr < rows && cc >= 0 && cc < cols && !walls[rr * cols + cc]) {
          out.add(rr * cols + cc);
          rr += dr;
          cc += dc;
        }
      }
      return out;
    });

/// Which cells the [lamps] light.
List<bool> lampsLit(List<List<int>> sight, List<bool> lamps) {
  final lit = List<bool>.filled(lamps.length, false);
  for (var i = 0; i < lamps.length; i++) {
    if (!lamps[i]) continue;
    lit[i] = true;
    for (final j in sight[i]) {
      lit[j] = true;
    }
  }
  return lit;
}

/// Cells breaking a rule. With [complete], unlit cells and walls short of
/// lamps count too.
Set<int> lampsConflicts(LampsPuzzle p, List<bool> lamps, {required bool complete}) {
  final sight = lampsSight(p.rows, p.cols, p.walls);
  final nb = orthNeighbors(p.rows, p.cols);
  final bad = <int>{};
  for (var i = 0; i < lamps.length; i++) {
    if (lamps[i] && sight[i].any((j) => lamps[j])) bad.add(i);
    final want = p.numbers[i];
    if (want != null) {
      final have = nb[i].where((j) => lamps[j]).length;
      if (have > want || (complete && have != want)) bad.add(i);
    }
  }
  if (complete) {
    final lit = lampsLit(sight, lamps);
    for (var i = 0; i < lamps.length; i++) {
      if (!p.walls[i] && !lit[i]) bad.add(i);
    }
  }
  return bad;
}
