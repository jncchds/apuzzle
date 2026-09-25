import '../../core/difficulty.dart';
import '../../core/grid.dart';
import '../../core/tutorial.dart';
import 'atoms_generator.dart';
import 'atoms_model.dart';

/// A board from its atoms (row, column) and the bonds of the solution, as
/// (atom, atom, count) with atoms by their place in [atoms]. Numbers follow
/// from the bonds.
AtomsPuzzle _board(int rows, int cols, List<(int, int)> atoms, List<(int, int, int)> bonds) {
  final islands = [for (final (r, c) in atoms) r * cols + c];
  final edges = atomEdges(rows, cols, islands);
  final solution = [
    for (final e in edges)
      bonds.where((b) => (b.$1 == e.a && b.$2 == e.b) || (b.$1 == e.b && b.$2 == e.a)).map((b) => b.$3).firstOrNull ?? 0,
  ];
  final numbers = List<int>.filled(islands.length, 0);
  for (var e = 0; e < edges.length; e++) {
    numbers[edges[e].a] += solution[e];
    numbers[edges[e].b] += solution[e];
  }
  return AtomsPuzzle(rows: rows, cols: cols, islands: islands, numbers: numbers, edges: edges, solution: solution);
}

final List<TutorialStep> atomsTutorial = [
  TutorialStep(
    text: (l) => l.tutAtoms1,
    puzzle: _board(3, 3, [(0, 0), (0, 2), (2, 2)], [(0, 1, 2), (1, 2, 1)]),
  ),
  TutorialStep(
    text: (l) => l.tutAtoms2,
    puzzle: _board(3, 3, [(0, 0), (0, 2), (2, 0), (2, 2)], [(0, 1, 1), (1, 3, 1), (3, 2, 1)]),
    focus: {const Pos(0, 0)},
  ),
  TutorialStep.generated(
    text: (l) => l.tutAtoms3,
    make: () => generateAtoms(const GenParams(size: GridSize.square(5), difficulty: Difficulty.easy, seed: 4)),
  ),
];
