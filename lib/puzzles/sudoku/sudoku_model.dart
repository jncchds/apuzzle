import '../../core/grid.dart';
import '../../core/value_grid.dart';

/// Box shape for an n×n Sudoku: (box rows, box cols).
(int, int) sudokuBox(int n) => switch (n) {
      4 => (2, 2),
      6 => (2, 3),
      8 => (2, 4),
      9 => (3, 3),
      _ => throw ArgumentError('unsupported sudoku size $n'),
    };

/// Precomputed units/peers for an n×n Sudoku.
class SudokuGeometry {
  SudokuGeometry(this.n) : box = sudokuBox(n) {
    final (br, bc) = box;
    for (var r = 0; r < n; r++) {
      units.add([for (var c = 0; c < n; c++) r * n + c]);
    }
    for (var c = 0; c < n; c++) {
      units.add([for (var r = 0; r < n; r++) r * n + c]);
    }
    for (var r0 = 0; r0 < n; r0 += br) {
      for (var c0 = 0; c0 < n; c0 += bc) {
        units.add([
          for (var r = r0; r < r0 + br; r++)
            for (var c = c0; c < c0 + bc; c++) r * n + c,
        ]);
      }
    }
    unitsOf = List.generate(n * n, (_) => <int>[]);
    for (var u = 0; u < units.length; u++) {
      for (final i in units[u]) {
        unitsOf[i].add(u);
      }
    }
    peers = List.generate(n * n, (i) {
      final s = <int>{};
      for (final u in unitsOf[i]) {
        s.addAll(units[u]);
      }
      s.remove(i);
      return s.toList();
    });
  }

  final int n;
  final (int, int) box;

  /// rows (0..n-1), cols (n..2n-1), boxes (2n..3n-1)
  final List<List<int>> units = [];
  late final List<List<int>> unitsOf;
  late final List<List<int>> peers;

  int boxOf(int i) => unitsOf[i][2] - 2 * n;

  static final Map<int, SudokuGeometry> _cache = {};
  static SudokuGeometry of(int n) => _cache.putIfAbsent(n, () => SudokuGeometry(n));
}

class SudokuPuzzle implements ValueGridPuzzle {
  const SudokuPuzzle({required this.n, required this.givens, required this.solution});

  final int n;

  /// Values are 0-based (displayed as 1..n).
  final List<int?> givens;
  final List<int> solution;

  @override
  GridSize get size => GridSize.square(n);
  @override
  int? givenAt(int index) => givens[index];
  @override
  int solutionAt(int index) => solution[index];

  Map<String, dynamic> toJson() => {'n': n, 'givens': givens, 'solution': solution};

  factory SudokuPuzzle.fromJson(Map<String, dynamic> j) => SudokuPuzzle(
        n: j['n'] as int,
        givens: (j['givens'] as List).cast<int?>(),
        solution: (j['solution'] as List).cast<int>(),
      );
}

/// Cells involved in a duplicate within any unit (-1 = empty).
Set<int> sudokuConflicts(int n, List<int> g) {
  final geo = SudokuGeometry.of(n);
  final bad = <int>{};
  for (final u in geo.units) {
    final seen = <int, int>{};
    for (final i in u) {
      final v = g[i];
      if (v < 0) continue;
      final j = seen[v];
      if (j != null) {
        bad
          ..add(i)
          ..add(j);
      } else {
        seen[v] = i;
      }
    }
  }
  return bad;
}
