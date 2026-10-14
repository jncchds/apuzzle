import '../../core/difficulty.dart';
import '../../core/grid.dart';
import '../../core/tutorial.dart';
import '../../l10n/l10n.dart';
import 'cages_generator.dart';
import 'cages_model.dart';

/// A 4×4 board from rows of numbers (given) and letters a–d (a cell to fill
/// with 1–4), and [layout] rows naming each cell's cage, whose operation is
/// in [ops].
CagesPuzzle _board(List<String> rows, List<String> layout, Map<String, CageOp> ops) {
  final cells = rows.join().split('');
  int value(String ch) => '1234'.contains(ch) ? int.parse(ch) - 1 : 'abcd'.indexOf(ch);
  final solution = [for (final ch in cells) value(ch)];
  final names = layout.join().split('');
  final cages = [
    for (final name in {...names})
      () {
        final at = [
          for (var i = 0; i < 16; i++)
            if (names[i] == name) i,
        ];
        final op = ops[name] ?? CageOp.none;
        return Cage(at, op, cageTarget(op, [for (final i in at) solution[i] + 1])!);
      }(),
  ];
  return CagesPuzzle(
    n: 4,
    cages: cages,
    givens: [for (final ch in cells) '1234'.contains(ch) ? value(ch) : null],
    solution: solution,
  );
}

Set<Pos> _open(CagesPuzzle p) => {
  for (var i = 0; i < 16; i++)
    if (p.givens[i] == null) p.size.pos(i),
};

TutorialStep _step(Tr text, List<String> rows, List<String> layout, Map<String, CageOp> ops) {
  final p = _board(rows, layout, ops);
  return TutorialStep(text: text, puzzle: p, focus: _open(p));
}

// Solution of the small steps:
// 1 2 3 4
// 3 4 1 2
// 4 3 2 1
// 2 1 4 3
final List<TutorialStep> cagesTutorial = [
  _step(
    (l) => l.tutCages1,
    ['ab34', '3d12', '4c21', '2143'],
    ['aabc', 'debc', 'deff', 'ggfh'],
    {for (final k in 'abcdefg'.split('')) k: CageOp.add},
  ),
  // Each column leaves two numbers for its top cells; the 4÷ picks the order.
  _step(
    (l) => l.tutCages2,
    ['abcd', 'cdab', '4321', '2143'],
    ['abbc', 'addc', 'fghh', 'fgii'],
    {
      'a': CageOp.sub,
      'b': CageOp.sub,
      'c': CageOp.div,
      'd': CageOp.div,
      'f': CageOp.div,
      'g': CageOp.div,
      'h': CageOp.sub,
      'i': CageOp.sub,
    },
  ),
  // Rows and columns allow two ways for the bottom-right square; the 2× allows one.
  _step(
    (l) => l.tutCages3,
    ['12cd', '3dab', '4cba', '2143'],
    ['aabb', 'acxb', 'ecxx', 'effg'],
    {'a': CageOp.mul, 'b': CageOp.mul, 'c': CageOp.mul, 'x': CageOp.mul, 'e': CageOp.mul, 'f': CageOp.mul},
  ),
  TutorialStep.generated(
    text: (l) => l.tutCages4,
    make: () => generateCages(const GenParams(size: GridSize.square(4), difficulty: Difficulty.medium, seed: 2)),
  ),
];

final List<TutorialStep> cagesStrategies = [
  TutorialStep.generated(text: (l) => l.tutCagesS1, make: () => generateCages(cagesStrategyParams[0])),
  TutorialStep.generated(text: (l) => l.tutCagesS2, make: () => generateCages(cagesStrategyParams[1])),
  TutorialStep.generated(text: (l) => l.tutCagesS3, make: () => generateCages(cagesStrategyParams[2])),
];

/// The strategy boards: each needs the tier it teaches (checked in tests).
const cagesStrategyParams = [
  GenParams(size: GridSize.square(5), difficulty: Difficulty.easy, seed: 1),
  GenParams(size: GridSize.square(6), difficulty: Difficulty.medium, seed: 1),
  GenParams(size: GridSize.square(6), difficulty: Difficulty.hard, seed: 1),
];
