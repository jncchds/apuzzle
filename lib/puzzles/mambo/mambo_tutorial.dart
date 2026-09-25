import '../../core/grid.dart';
import '../../core/tutorial.dart';
import '../../l10n/l10n.dart';
import 'mambo_model.dart';

/// A board from rows of S/M (given sun/moon) and s/m (a cell to fill, with its
/// solution) and "r,c>=" / "r,c v×" style signs: `>` to the right neighbour,
/// `v` to the one below, `=` same, `x` different.
TutorialStep _step(Tr text, List<String> rows, [List<String> signs = const []]) {
  final n = rows.length;
  final cells = rows.join();
  final edges = [
    for (final s in signs)
      () {
        final r = int.parse(s[0]), c = int.parse(s[2]);
        final a = r * n + c;
        return MamboEdge(a, s[3] == '>' ? a + 1 : a + n, s[4] == '=');
      }(),
  ];
  final puzzle = MamboPuzzle(
    n: n,
    givens: [for (final ch in cells.split('')) ch == 'S' ? sun : ch == 'M' ? moon : null],
    solution: [for (final ch in cells.split('')) ch.toUpperCase() == 'S' ? sun : moon],
    edges: edges,
  );
  final open = [for (var i = 0; i < n * n; i++) if (puzzle.givens[i] == null) GridSize.square(n).pos(i)];
  // Point at the cells to fill when there are just a few.
  return TutorialStep(text: text, puzzle: puzzle, focus: open.length <= 4 ? open.toSet() : const {});
}

final List<TutorialStep> mamboTutorial = [
  _step((l) => l.tutMambo1, ['SSmM', 'MMSS', 'SMMS', 'MsSM']),
  _step((l) => l.tutMambo2, ['SmSm', 'MSMS', 'SMSm', 'MSMS']),
  _step((l) => l.tutMambo3, ['SSMM', 'MMSS', 'SmMS', 'MSsM'], ['1,1v=', '3,1>=']),
  _step((l) => l.tutMambo4, ['MSSM', 'sMMS', 'MMSs', 'SSMM'], ['0,0vx', '2,3vx']),
  _step((l) => l.tutMambo5, ['Ssmm', 'mmsS', 'Smms', 'msSM'], ['0,2>=', '1,1>x', '2,1>=', '3,1>=']),
];
