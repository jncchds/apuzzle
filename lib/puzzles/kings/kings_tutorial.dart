import '../../core/grid.dart';
import '../../core/tutorial.dart';
import '../../core/value_grid.dart';
import 'kings_model.dart';

/// A board from rows of region letters and the crown's column in each row.
KingsPuzzle _board(List<String> rows, List<int> crowns) => KingsPuzzle(
      n: rows.length,
      regions: [for (final ch in rows.join().split('')) ch.codeUnitAt(0) - 'A'.codeUnitAt(0)],
      solution: crowns,
    );

/// A state with given crowns (C) and dots (.) where the rows say, the rest empty.
ValueGrid _state(KingsPuzzle p, List<String> rows) {
  final marks = rows.join();
  return ValueGrid(p.size, [
    for (final ch in marks.split(''))
      switch (ch) {
        'C' => const CellValue(value: kKing, given: true),
        '.' => const CellValue(value: kDot),
        _ => const CellValue(),
      },
  ]);
}

// Crowns at (0,1) (1,3) (2,0) (3,2).
final _four = _board(['AABB', 'ACBB', 'CCDB', 'CDDD'], [1, 3, 0, 2]);

// Crowns at (0,0) (1,2) (2,4) (3,1) (4,3).
final _five = _board(['AABBB', 'DBBCC', 'DDDCC', 'DDEEC', 'DEEEE'], [0, 2, 4, 1, 3]);

final List<TutorialStep> kingsTutorial = [
  TutorialStep(
    text: (l) => l.tutKings1,
    puzzle: _four,
    state: _state(_four, ['-C--', '---C', 'C---', '----']),
    focus: {const Pos(3, 2)},
  ),
  () {
    // Dot every cell around the crown at (1,2).
    const crown = Pos(1, 2);
    final around = [
      for (var dr = -1; dr <= 1; dr++)
        for (var dc = -1; dc <= 1; dc++)
          if (dr != 0 || dc != 0) Pos(crown.r + dr, crown.c + dc),
    ];
    final start = _state(_five, ['-----', '--C--', '-----', '-----', '-----']);
    var answer = start;
    for (final p in around) {
      answer = answer.set(p, const CellValue(value: kDot));
    }
    return TutorialStep(
      text: (l) => l.tutKings2,
      puzzle: _five,
      state: start,
      focus: around.toSet(),
      done: (s) => around.every((p) => (s as ValueGrid).valueAt(p) == kDot),
      answer: answer,
    );
  }(),
  () {
    // Region C is (1,3) (1,4) (2,3) (2,4) (3,4). The crowns' rows and the
    // touching rule dot all of it but (2,4).
    final start = _state(_five, ['C----', '--C..', '---.-', '-C--.', '-----']);
    return TutorialStep(
      text: (l) => l.tutKings3,
      puzzle: _five,
      state: start,
      focus: {const Pos(1, 3), const Pos(1, 4), const Pos(2, 3), const Pos(2, 4), const Pos(3, 4)},
      done: (s) => (s as ValueGrid).valueAt(const Pos(2, 4)) == kKing,
      answer: start.set(const Pos(2, 4), const CellValue(value: kKing)),
    );
  }(),
  TutorialStep(text: (l) => l.tutKings4, puzzle: _five),
];
