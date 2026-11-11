import '../../core/difficulty.dart';
import '../../core/grid.dart';
import '../../core/tutorial.dart';
import 'ripples_generator.dart';
import 'ripples_model.dart';
import '../../core/explain.dart';
import 'ripples_solver.dart';

/// A board from rows of region letters, the solution's digits, and the
/// shown digits ('.' for an empty cell).
RipplesPuzzle ripplesBoard(List<String> regions, List<String> solution, List<String> shown) {
  final cells = shown.join().split('');
  return RipplesPuzzle(
    rows: regions.length,
    cols: regions.first.length,
    regions: [for (final ch in regions.join().split('')) ch.codeUnitAt(0) - 'A'.codeUnitAt(0)],
    givens: [for (final ch in cells) ch == '.' ? null : int.parse(ch) - 1],
    solution: [for (final ch in solution.join().split('')) int.parse(ch) - 1],
  );
}

const _regions = ['AABBB', 'ACCBB', 'DDEFF', 'DDEFF'];
const _solution = ['21324', '32151', '41213', '23142'];

/// Strategy lessons: a medium board (tier 1 gets stuck, pointing or pairs
/// finish it) and a hard one (tier 2 gets stuck, probing finishes it).
const ripplesPointingParams = GenParams(size: GridSize.square(6), difficulty: Difficulty.medium, seed: 1);
const ripplesProbeParams = GenParams(size: GridSize.square(6), difficulty: Difficulty.hard, seed: 1);

final List<TutorialStep> ripplesTutorial = [
  TutorialStep(
    text: (l) => l.tutRipples1,
    puzzle: ripplesBoard(_regions, _solution, ['2132.', '32151', '41213', '2.142']),
    focus: {const Pos(0, 4), const Pos(3, 1)},
  ),
  TutorialStep(
    text: (l) => l.tutRipples2,
    puzzle: ripplesBoard(_regions, _solution, ['21324', '3..51', '41.13', '23.42']),
    focus: {const Pos(1, 1), const Pos(2, 2)},
  ),
  TutorialStep(
    text: (l) => l.tutRipples3,
    puzzle: ripplesBoard(_regions, _solution, ['21324', '32151', '4.213', '..142']),
    focus: {const Pos(3, 1)},
  ),
  TutorialStep.generated(
    text: (l) => l.tutRipples4,
    make: () => generateRipples(const GenParams(size: GridSize.square(5), difficulty: Difficulty.easy, seed: 2)),
  ),
];

final List<TutorialStep> ripplesStrategies = [
  TutorialStep.generated(
    text: (l) => l.tutRipplesS1,
    teaches: {RipplesRule.pointing.index, RipplesRule.pair.index},
    make: () => generateRipples(ripplesPointingParams),
  ),
  TutorialStep.generated(
    text: (l) => l.tutRipplesS2,
    teaches: {ruleRefuted},
    make: () => generateRipples(ripplesProbeParams),
  ),
];
