import '../../core/difficulty.dart';
import '../../core/grid.dart';
import '../../core/tutorial.dart';
import 'formula_generator.dart';
import 'formula_model.dart';

FormulaPuzzle _board(String answer, {int level = 0}) => FormulaPuzzle(rows: 6, answer: answer, level: level);

/// A board with [guesses] entered already.
FormulaState _after(FormulaPuzzle p, List<String> guesses) => guesses.fold(
  FormulaState.initial(p),
  (s, g) => FormulaState(guesses: s.guesses, row: g, cursor: g.length).enter(),
);

final _first = _board('2+3=5');
final _marks = _board('9-4=5');
final _twice = _board('2+7=9');
final _opening = _board('12/4+5=8', level: 1);
final _powers = _board('3²-2=7', level: 2);

final List<TutorialStep> formulaTutorial = [
  TutorialStep(
    text: (l) => l.tutFormula1,
    puzzle: _first,
    done: (s) => (s as FormulaState).guesses.isNotEmpty,
    answer: _after(_first, ['1+4=5']),
  ),
  // "=" in place, 4, 5 and 9 elsewhere, no "+".
  TutorialStep(text: (l) => l.tutFormula2, puzzle: _marks, state: _after(_marks, ['4+5=9'])),
  // The first 2 is in place; the second is faded, the equation has one 2.
  TutorialStep(text: (l) => l.tutFormula3, puzzle: _twice, state: _after(_twice, ['2+2=4'])),
  TutorialStep.generated(
    text: (l) => l.tutFormula4,
    make: () => generateFormula(const GenParams(size: GridSize(6, 6), difficulty: Difficulty.easy, seed: 3)),
  ),
];

final List<TutorialStep> formulaStrategies = [
  // An opening guess that tests many symbols at once.
  TutorialStep(
    text: (l) => l.tutFormulaS1,
    puzzle: _opening,
    done: (s) => (s as FormulaState).guesses.any((g) => formulaVariety(g) >= 7),
    answer: _after(_opening, ['9*8-7=65']),
  ),
  TutorialStep(text: (l) => l.tutFormulaS2, puzzle: _powers, state: _after(_powers, ['2³-1=7'])),
  TutorialStep.generated(
    text: (l) => l.tutFormulaS3,
    make: () => generateFormula(const GenParams(size: GridSize(6, 10), difficulty: Difficulty.hard, seed: 5)),
  ),
];
