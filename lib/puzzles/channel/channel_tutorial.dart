import '../../core/difficulty.dart';
import '../../core/grid.dart';
import '../../core/tutorial.dart';
import 'channel_generator.dart';
import 'channel_model.dart';

/// A hand-made board: the source and the drain fixed, every other tile free.
ChannelPuzzle _board(int rows, int cols, int source, int target, List<int> masks, List<int> start) => ChannelPuzzle(
  rows: rows,
  cols: cols,
  source: source,
  target: target,
  masks: masks,
  start: start,
  locked: [for (var i = 0; i < rows * cols; i++) i == source || i == target],
);

final List<TutorialStep> channelTutorial = [
  TutorialStep(
    text: (l) => l.tutChannel1,
    puzzle: _board(3, 3, 0, 8, [dE, dE | dW, dW | dS, 0, 0, dN | dS, 0, 0, dN], [0, 1, 2, 0, 0, 1, 0, 0, 0]),
    focus: {const Pos(0, 0), const Pos(2, 2)},
  ),
  TutorialStep(
    text: (l) => l.tutChannel2,
    puzzle: _board(
      3,
      4,
      4,
      3,
      [dE | dS, dE | dW, dS | dE, dW, dE, dW | dE | dS, dW | dN, dW, dE | dW, dN | dE, dN | dE | dW, 0],
      [1, 1, 3, 0, 0, 2, 1, 2, 0, 2, 1, 0],
    ),
    focus: {const Pos(1, 1)},
  ),
  TutorialStep(
    text: (l) => l.tutChannel3,
    puzzle: _board(
      4,
      4,
      13,
      8,
      [
        dE | dS, dE | dW, dS, 0, //
        dN | dS, dS | dE, dW | dS, dW | dS,
        dE, bridgeMask, dN | dW, dN | dS,
        0, dN, dW | dE, dN | dW,
      ],
      [1, 1, 1, 0, 1, 1, 2, 2, 0, 0, 3, 1, 0, 0, 1, 2],
    ),
    focus: {const Pos(2, 1)},
  ),
  TutorialStep.generated(
    text: (l) => l.tutChannel4,
    make: () => generateChannel(const GenParams(size: GridSize.square(5), difficulty: Difficulty.easy, seed: 1)),
  ),
];

final List<TutorialStep> channelStrategies = [
  TutorialStep.generated(
    text: (l) => l.tutChannelS1,
    make: () => generateChannel(const GenParams(size: GridSize.square(6), difficulty: Difficulty.medium, seed: 1)),
  ),
  TutorialStep.generated(
    text: (l) => l.tutChannelS2,
    make: () => generateChannel(const GenParams(size: GridSize.square(7), difficulty: Difficulty.hard, seed: 1)),
  ),
];
