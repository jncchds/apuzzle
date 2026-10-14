import '../../core/difficulty.dart';
import 'turnabout_model.dart';

/// Steps (of [turnaboutTickMs]) the rival needs per cell.
int turnaboutRivalTicks(Difficulty d) => switch (d) {
  Difficulty.easy => 7,
  Difficulty.medium => 5,
  _ => 4,
};

/// Maze style (percent): easy mazes are Prim-like with short dead ends,
/// harder ones wind more.
int turnaboutNewest(Difficulty d) => switch (d) {
  Difficulty.easy => 0,
  Difficulty.medium => 40,
  _ => 75,
};

/// Steps to the first turn and between turns; hard also turns by half.
TurnaboutTurnPlan turnaboutTurns(Difficulty d) => switch (d) {
  Difficulty.easy => (first: (30, 45), gap: (60, 90), half: false),
  Difficulty.medium => (first: (25, 40), gap: (45, 65), half: false),
  _ => (first: (20, 30), gap: (30, 50), half: true),
};

TurnaboutPuzzle generateTurnabout(GenParams params, TurnaboutGoal goal) {
  final d = params.difficulty;
  final plan = turnaboutTurns(d);
  final p = TurnaboutPuzzle(
    n: params.size.rows,
    seed: params.seed,
    goal: goal,
    newest: turnaboutNewest(d),
    rivalTicks: turnaboutRivalTicks(d),
    firstTurn: plan.first,
    turnGap: plan.gap,
    half: plan.half,
  );
  p.round(0);
  return p;
}
