import '../../core/difficulty.dart';
import '../../core/grid.dart';
import '../../core/tutorial.dart';
import '../../core/value_grid.dart';
import 'stars_generator.dart';
import 'stars_model.dart';
import '../../core/explain.dart';
import 'stars_solver.dart';

/// A board from rows of region letters and rows marking the stars with `*`.
StarsPuzzle _board(List<String> rows, List<String> stars) {
  final marks = stars.join();
  return StarsPuzzle(
    n: rows.length,
    regions: [for (final ch in rows.join().split('')) ch.codeUnitAt(0) - 'A'.codeUnitAt(0)],
    solution: [
      for (var i = 0; i < marks.length; i++)
        if (marks[i] == '*') i,
    ],
  );
}

/// A state with given stars (S) and dots (.) where the rows say, the rest
/// empty.
ValueGrid _state(StarsPuzzle p, List<String> rows) {
  final marks = rows.join();
  return ValueGrid(p.size, [
    for (final ch in marks.split(''))
      switch (ch) {
        'S' => const CellValue(value: sStar, given: true),
        '.' => const CellValue(value: sDot),
        _ => const CellValue(),
      },
  ]);
}

final _nine = _board(
  [
    'ABBBBBBBC',
    'AABBBBBCC',
    'FADDFBBCE',
    'FADDFEBCE',
    'FFDFFEEEE',
    'FFFFEEEHH',
    'FGFFGEIIH',
    'FGFGGEIIH',
    'GGGGEEIII',
  ],
  [
    '*--*-----',
    '-----*-*-',
    '-*-*-----',
    '-----*-*-',
    '*-*------',
    '----*---*',
    '--*---*--',
    '----*---*',
    '-*----*--',
  ],
);

Set<Pos> _row(int r) => {for (var c = 0; c < 9; c++) Pos(r, c)};

final List<TutorialStep> starsTutorial = [
  // Every star but row 4's is given; full columns and the stars of rows 3
  // and 5 leave it two cells.
  TutorialStep(
    text: (l) => l.tutStars1,
    puzzle: _nine,
    state: _state(_nine, [
      'S--S-----',
      '-----S-S-',
      '-S-S-----',
      '---------',
      'S-S------',
      '----S---S',
      '--S---S--',
      '----S---S',
      '-S----S--',
    ]),
    focus: _row(3),
  ),
  () {
    // Dot every cell around the star at (6,2).
    const star = Pos(6, 2);
    final around = [
      for (var dr = -1; dr <= 1; dr++)
        for (var dc = -1; dc <= 1; dc++)
          if (dr != 0 || dc != 0) Pos(star.r + dr, star.c + dc),
    ];
    final start = _state(_nine, ['', '', '', '', '', '', '--S------', '', ''].map((r) => r.padRight(9, '-')).toList());
    var answer = start;
    for (final p in around) {
      answer = answer.set(p, const CellValue(value: sDot));
    }
    return TutorialStep(
      text: (l) => l.tutStars2,
      puzzle: _nine,
      state: start,
      focus: around.toSet(),
      done: (s) => around.every((p) => (s as ValueGrid).valueAt(p) == sDot),
      answer: answer,
      how: (l) => l.tutStars2How,
    );
  }(),
  () {
    // Row 5 keeps three free cells side by side: its stars go at both ends.
    final start = _state(_nine, ['', '', '', '', '---......', '', '', '', ''].map((r) => r.padRight(9, '-')).toList());
    const ends = [Pos(4, 0), Pos(4, 2)];
    var answer = start;
    for (final p in ends) {
      answer = answer.set(p, const CellValue(value: sStar));
    }
    return TutorialStep(
      text: (l) => l.tutStars3,
      puzzle: _nine,
      state: start,
      focus: {const Pos(4, 0), const Pos(4, 1), const Pos(4, 2)},
      done: (s) => ends.every((p) => (s as ValueGrid).valueAt(p) == sStar),
      answer: answer,
      how: (l) => l.tutStars3How,
    );
  }(),
  TutorialStep.generated(
    text: (l) => l.tutStars4,
    make: () => generateStars(const GenParams(size: GridSize.square(9), difficulty: Difficulty.easy, seed: 2)),
  ),
];

/// Pinned seeds of the strategy boards (checked in the tests): a 9×9 medium
/// board that needs band counting, one that needs a star that would leave a
/// unit too few places, and a 9×9 hard board that needs probing.
const starsBandSeed = 5, starsAttackSeed = 1, starsProbeSeed = 1;

final List<TutorialStep> starsStrategies = [
  TutorialStep.generated(
    text: (l) => l.tutStarsS1,
    teaches: {StarsRule.bandIn.index, StarsRule.bandOut.index},
    make: () => generateStars(
      const GenParams(size: GridSize.square(9), difficulty: Difficulty.medium, seed: starsBandSeed),
    ),
  ),
  TutorialStep.generated(
    text: (l) => l.tutStarsS2,
    teaches: {StarsRule.attack.index},
    make: () => generateStars(
      const GenParams(size: GridSize.square(9), difficulty: Difficulty.medium, seed: starsAttackSeed),
    ),
  ),
  TutorialStep.generated(
    text: (l) => l.tutStarsS3,
    teaches: {ruleRefuted},
    make: () => generateStars(
      const GenParams(size: GridSize.square(9), difficulty: Difficulty.hard, seed: starsProbeSeed),
    ),
  ),
];
