import 'dart:math';

import '../../core/tutorial.dart';
import '../labyrinth/labyrinth_generator.dart';
import 'turnabout_model.dart';

/// A practice board of one round on n×n: a maze from [seed], the runner in
/// the top-left corner and the star in the bottom-right one (no rival), or a
/// race against a slow rival ([rivalTicks]) as a real round has it. The maze
/// turns at the given (step, quarter turns) [turns].
TurnaboutPuzzle turnaboutPractice(
  int n,
  int seed, {
  List<(int, int)> turns = const [],
  int rivalTicks = 0,
}) {
  final rng = Random(seed);
  final TurnaboutRound round;
  if (rivalTicks > 0) {
    final made = turnaboutMakeRound(n, 0, rng, (first: (1, 1), gap: (1, 1), half: false));
    round = TurnaboutRound(
      n: n,
      open: made.open,
      player: made.player,
      rival: made.rival,
      prize: made.prize,
      turns: turns,
    );
  } else {
    final maze = carveLabyrinth(n, n, 0, rng);
    round = TurnaboutRound(n: n, open: maze.open, player: 0, rival: -1, prize: n * n - 1, turns: turns);
  }
  return TurnaboutPuzzle(
    n: n,
    seed: seed,
    goal: TurnaboutGoal.rounds,
    newest: 0,
    rivalTicks: max(1, rivalTicks),
    firstTurn: (1, 1),
    turnGap: (1, 1),
    half: false,
    fixed: [round],
  );
}

final List<TutorialStep> turnaboutTutorial = [
  TutorialStep(text: (l) => l.tutTurnabout1, puzzle: turnaboutPractice(4, 1)),
  TutorialStep(
    text: (l) => l.tutTurnabout2,
    puzzle: turnaboutPractice(5, 2, turns: const [(20, 1), (50, 3), (80, 1), (110, 3), (140, 1)]),
  ),
  TutorialStep(
    text: (l) => l.tutTurnabout3,
    puzzle: turnaboutPractice(6, 3, rivalTicks: 8, turns: const [(25, 1), (60, 3), (95, 1), (130, 3)]),
  ),
];
