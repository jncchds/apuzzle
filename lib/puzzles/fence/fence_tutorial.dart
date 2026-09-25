import '../../core/difficulty.dart';
import '../../core/grid.dart';
import '../../core/lattice_loop.dart';
import '../../core/tutorial.dart';
import 'fence_generator.dart';
import 'fence_model.dart';

/// A board whose loop is the outline of the cells marked # or X; X and o
/// (outside) cells show their number, . and # don't.
FencePuzzle _board(List<String> rows) {
  final r = rows.length, c = rows.first.length;
  final cells = rows.join().split('');
  bool inside(int y, int x) => y >= 0 && x >= 0 && y < r && x < c && 'X#'.contains(cells[y * c + x]);
  final g = LatticeLoop(r + 1, c + 1);
  final lines = List<bool>.filled(g.edgeCount, false);
  for (var y = 0; y <= r; y++) {
    for (var x = 0; x <= c; x++) {
      if (x < c && inside(y - 1, x) != inside(y, x)) lines[g.h(y, x)] = true;
      if (y < r && inside(y, x - 1) != inside(y, x)) lines[g.v(y, x)] = true;
    }
  }
  return FencePuzzle(
    rows: r,
    cols: c,
    numbers: [
      for (var i = 0; i < cells.length; i++)
        'Xo'.contains(cells[i]) ? fenceSides(g, i ~/ c, i % c).where((e) => lines[e]).length : null,
    ],
    lines: lines,
  );
}

final List<TutorialStep> fenceTutorial = [
  TutorialStep(text: (l) => l.tutFence1, puzzle: _board(['X.', '..'])),
  TutorialStep(text: (l) => l.tutFence2, puzzle: _board(['X.o', 'Xo.'])),
  TutorialStep(text: (l) => l.tutFence3, puzzle: _board(['o#o', 'X#X', 'o.o'])),
  TutorialStep.generated(
    text: (l) => l.tutFence4,
    make: () => generateFence(const GenParams(size: GridSize.square(5), difficulty: Difficulty.easy, seed: 3)),
  ),
];
