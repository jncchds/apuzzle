import '../../core/difficulty.dart';
import '../../core/grid.dart';
import '../../core/tutorial.dart';
import 'poles_generator.dart';
import 'poles_model.dart';

/// A board from its dominoes (two cells with the same letter, rows split by
/// |) and values (+, −, . for blank); the counts follow from the values.
PolesPuzzle polesBoard(String tiles, String values) {
  final t = tiles.split('|'), v = values.split('|');
  final rows = t.length, cols = t.first.length;
  final letters = t.join(), cells = v.join();
  final mate = [
    for (var i = 0; i < letters.length; i++)
      [
        if (i % cols + 1 < cols) i + 1,
        if (i % cols > 0) i - 1,
        if (i + cols < letters.length) i + cols,
        if (i >= cols) i - cols,
      ].singleWhere((j) => letters[j] == letters[i]),
  ];
  final solution = [for (final ch in cells.split('')) '+-.'.indexOf(ch)];
  final (plus, minus) = polesCounts(rows, cols, solution);
  return PolesPuzzle(rows: rows, cols: cols, mate: mate, solution: solution, plus: plus, minus: minus);
}

final List<TutorialStep> polesTutorial = [
  // Counts and dominoes alone settle it.
  TutorialStep(text: (l) => l.tutPoles1, puzzle: polesBoard('abb|acc|dde|ffe', '.+-|...|..+|..-')),
  // Like ends never touch: that turns the dominoes the right way round.
  TutorialStep(text: (l) => l.tutPoles2, puzzle: polesBoard('abcc|abdd|eeff|gghh', '.-..|.+-+|+-+-|..-+')),
  // The two counts of a line together: how many of its cells are charged.
  TutorialStep(text: (l) => l.tutPoles3, puzzle: polesBoard('abcc|abdd|eeff|gghh', '-+-+|+-..|....|..-+')),
  TutorialStep.generated(
    text: (l) => l.tutPoles4,
    make: () => generatePoles(const GenParams(size: GridSize.square(6), difficulty: Difficulty.easy, seed: 1)),
  ),
];

/// The hard strategy board: some counts hidden, needs probing.
const polesStrategyParams = GenParams(size: GridSize.square(6), difficulty: Difficulty.hard, seed: 1);

final List<TutorialStep> polesStrategies = [
  // Every way to fill a line: needs tier 2.
  TutorialStep(
    text: (l) => l.tutPolesS1,
    puzzle: polesBoard('abccd|abeed|fgghi|fjjhi', '-+-+-|+-+-+|-+-.-|+-+.+'),
  ),
  TutorialStep.generated(text: (l) => l.tutPolesS2, make: () => generatePoles(polesStrategyParams)),
];
