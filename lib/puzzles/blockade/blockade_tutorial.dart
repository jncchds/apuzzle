import '../../core/difficulty.dart';
import '../../core/grid.dart';
import '../../core/tutorial.dart';
import 'blockade_generator.dart';
import 'blockade_model.dart';
import 'blockade_solver.dart';

/// A sea drawn as text ('#' rock, 'S' start, 'G' harbour, '.' open sea),
/// turn limit = the fastest passage + [slack].
BlockadePuzzle blockadeBoard(List<String> map, {List<Patrol> ships = const [], int slack = 0}) {
  final rows = map.length, cols = map.first.length;
  final rocks = [
    for (final line in map)
      for (final ch in line.split('')) ch == '#',
  ];
  final flat = map.join();
  final draft = BlockadePuzzle(
    rows: rows,
    cols: cols,
    rocks: rocks,
    start: flat.indexOf('S'),
    goal: flat.indexOf('G'),
    patrols: ships,
    limit: 0,
    best: 0,
  );
  final best = BlockadeSolver(draft).best()!;
  return BlockadePuzzle(
    rows: rows,
    cols: cols,
    rocks: rocks,
    start: draft.start,
    goal: draft.goal,
    patrols: ships,
    limit: best + slack,
    best: best,
  );
}

final List<TutorialStep> blockadeTutorial = [
  TutorialStep(
    text: (l) => l.tutBlockade1,
    puzzle: blockadeBoard(['...G', '.#..', 'S...'], slack: 2),
    focus: {const Pos(2, 0), const Pos(0, 3)},
  ),
  TutorialStep(
    text: (l) => l.tutBlockade2,
    puzzle: blockadeBoard(
      ['##.##', 'S...G', '##.##'],
      ships: const [
        Patrol([2, 7, 12], loop: false, phase: 1),
      ],
      slack: 2,
    ),
    focus: {const Pos(1, 2)},
  ),
  TutorialStep(
    text: (l) => l.tutBlockade3,
    puzzle: blockadeBoard(
      ['...##', '....#', '..#.G', 'S...#'],
      ships: const [
        Patrol([6, 7, 8, 13, 18, 17, 16, 11], loop: true, phase: 1),
      ],
    ),
  ),
  TutorialStep.generated(
    text: (l) => l.tutBlockade4,
    make: () => generateBlockade(const GenParams(size: GridSize.square(5), difficulty: Difficulty.easy, seed: 1)),
  ),
];

final List<TutorialStep> blockadeStrategies = [
  TutorialStep(
    text: (l) => l.tutBlockadeS1,
    puzzle: blockadeBoard(
      ['......', '#.....', 'S.....', '..##..', '.####G'],
      ships: const [
        Patrol([13, 14, 15], loop: false, phase: 1),
        Patrol([11, 17, 23], loop: false, phase: 2),
      ],
    ),
  ),
  TutorialStep.generated(
    text: (l) => l.tutBlockadeS2,
    make: () => generateBlockade(const GenParams(size: GridSize.square(7), difficulty: Difficulty.hard, seed: 1)),
  ),
];
