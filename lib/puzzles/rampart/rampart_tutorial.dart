import '../../core/difficulty.dart';
import '../../core/grid.dart';
import '../../core/tutorial.dart';
import 'rampart_generator.dart';
import 'rampart_model.dart';

/// A board from rows separated by |: `#` is shaded, `.` any other cell that
/// stays, a digit a clue of one number and `(31)` a clue of several.
RampartPuzzle rampartBoard(String board) {
  final rows = board.split('|');
  final clues = <List<int>?>[], shaded = <bool>[];
  for (final row in rows) {
    for (final m in RegExp(r'\(\d+\)|.').allMatches(row)) {
      final s = m[0]!;
      shaded.add(s == '#');
      clues.add(
        s == '#' || s == '.' ? null : [for (final d in s.replaceAll(RegExp(r'[()]'), '').split('')) int.parse(d)],
      );
    }
  }
  return RampartPuzzle(n: rows.length, clues: clues, shaded: shaded);
}

final List<TutorialStep> rampartTutorial = [
  // The 0 keeps its neighbours, so the 3 can only be the right column.
  TutorialStep(
    text: (l) => l.tutRampart1,
    puzzle: rampartBoard('.2#|.3#|0.#'),
    focus: {const Pos(2, 0), const Pos(1, 1)},
  ),
  // Once the clues are shaded, the top-left cell would fill a 2×2 block.
  TutorialStep(
    text: (l) => l.tutRampart2,
    puzzle: rampartBoard('.#.|##2|#3.'),
    focus: {const Pos(0, 0), const Pos(0, 1), const Pos(1, 0), const Pos(1, 1)},
  ),
  // Two runs of two round the 2 2, joined round the left side.
  TutorialStep(
    text: (l) => l.tutRampart3,
    puzzle: rampartBoard('###|#.(22)|###'),
    focus: {const Pos(1, 2), const Pos(0, 0), const Pos(1, 0), const Pos(2, 0)},
  ),
  TutorialStep.generated(
    text: (l) => l.tutRampart4,
    make: () => generateRampart(const GenParams(size: GridSize.square(5), difficulty: Difficulty.easy, seed: 1)),
  ),
];

/// Generated strategy boards: medium needs clues weighed against 2×2
/// blocks and shut-in walls, or cuts; hard needs probing.
const rampartStrategyParams = [
  GenParams(size: GridSize.square(6), difficulty: Difficulty.medium, seed: 1),
  GenParams(size: GridSize.square(7), difficulty: Difficulty.hard, seed: 1),
];

final List<TutorialStep> rampartStrategies = [
  // A top corner shaded alone would be shut in, so the 1 1 takes the cells beside the middle.
  TutorialStep(
    text: (l) => l.tutRampartS1,
    puzzle: rampartBoard('.(11).|#.#|###'),
    focus: {const Pos(0, 1), const Pos(0, 0), const Pos(0, 2), const Pos(1, 0), const Pos(1, 2)},
  ),
  TutorialStep.generated(text: (l) => l.tutRampartS2, make: () => generateRampart(rampartStrategyParams[0])),
  TutorialStep.generated(text: (l) => l.tutRampartS3, make: () => generateRampart(rampartStrategyParams[1])),
];
