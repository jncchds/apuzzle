import '../../core/difficulty.dart';
import '../../core/grid.dart';
import '../../core/tutorial.dart';
import 'orbits_generator.dart';
import 'orbits_model.dart';

/// A board from its regions, one letter each.
OrbitsPuzzle _board(List<String> rows) =>
    orbitsFromRegions(rows.length, rows.first.length, [for (final ch in rows.join().split('')) ch.codeUnitAt(0)]);

final List<TutorialStep> orbitsTutorial = [
  TutorialStep(text: (l) => l.tutOrbits1, puzzle: _board(['aab', 'aab', 'ccb']), focus: {const Pos(0, 2)}),
  // A star in a cell, on a line and on a corner.
  TutorialStep(text: (l) => l.tutOrbits2, puzzle: _board(['aaab', 'cddb', 'cddb', 'ceeb'])),
  // An S-shaped region.
  TutorialStep(text: (l) => l.tutOrbits3, puzzle: _board(['aac', 'baa', 'bdd'])),
  TutorialStep.generated(
    text: (l) => l.tutOrbits4,
    make: () => generateOrbits(const GenParams(size: GridSize.square(5), difficulty: Difficulty.easy, seed: 3)),
  ),
];

final List<TutorialStep> orbitsStrategies = [
  // Pinned boards (checked in the tests): the first needs the "one piece"
  // rule, the second probing.
  TutorialStep.generated(
    text: (l) => l.tutOrbitsS1,
    make: () => generateOrbits(const GenParams(size: GridSize.square(6), difficulty: Difficulty.medium, seed: 1)),
  ),
  TutorialStep.generated(
    text: (l) => l.tutOrbitsS2,
    make: () => generateOrbits(const GenParams(size: GridSize.square(6), difficulty: Difficulty.hard, seed: 6)),
  ),
];
