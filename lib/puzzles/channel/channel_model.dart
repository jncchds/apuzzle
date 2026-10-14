import 'dart:collection';

import '../../core/grid.dart';
import '../pipes/pipes_model.dart';

export '../pipes/pipes_model.dart' show dN, dE, dS, dW, dirs, opposite, rotateMask, neighbor, PipesState;

/// The tile of a crossing: two straight pipes passing over each other, so
/// water goes straight through it and never turns.
const int bridgeMask = 15;

/// One pipe from the source to the drain through a field of tiles. The
/// state is a [PipesState]: quarter turns per tile.
class ChannelPuzzle {
  const ChannelPuzzle({
    required this.rows,
    required this.cols,
    required this.source,
    required this.target,
    required this.masks,
    required this.start,
    required this.locked,
  });

  final int rows;
  final int cols;

  /// The source and the drain: dead ends, fixed in place.
  final int source;
  final int target;

  /// Connection mask per tile in the solved orientation (0 = no pipe,
  /// [bridgeMask] = a bridge). Tiles off the solution's route are random.
  final List<int> masks;

  /// Initial rotation (quarter turns clockwise applied to the solved mask).
  final List<int> start;

  /// Tiles given in the solved orientation (cannot be turned).
  final List<bool> locked;

  GridSize get size => GridSize(rows, cols);
  int get cells => rows * cols;

  bool isBridge(int i) => masks[i] == bridgeMask;

  /// Whether the player can turn tile [i].
  bool turnable(int i) => !locked[i] && !isBridge(i) && masks[i] != 0;

  Map<String, dynamic> toJson() => {
    'rows': rows,
    'cols': cols,
    'source': source,
    'target': target,
    'masks': masks,
    'start': start,
    'locked': locked,
  };
  factory ChannelPuzzle.fromJson(Map<String, dynamic> j) => ChannelPuzzle(
    rows: j['rows'] as int,
    cols: j['cols'] as int,
    source: j['source'] as int,
    target: j['target'] as int,
    masks: (j['masks'] as List).cast<int>(),
    start: (j['start'] as List).cast<int>(),
    locked: (j['locked'] as List).cast<bool>(),
  );
}

List<int> channelMasks(ChannelPuzzle p, PipesState s) => [
  for (var i = 0; i < p.cells; i++) rotateMask(p.masks[i], s.turns[i]),
];

/// Water on a tile: [flowAny] through it at all, [flowEW]/[flowNS] through
/// a bridge's east-west or north-south pipe.
const int flowAny = 1, flowEW = 2, flowNS = 4;

/// Where the water from the source gets to, per tile ([flowAny] …). Water
/// leaves a tile through every other arm, but goes straight over a bridge.
List<int> channelFlow(ChannelPuzzle p, List<int> m) {
  final flow = List<int>.filled(p.cells, 0)..[p.source] = flowAny;
  final seen = <int>{}; // cell * 16 + entry arm
  final q = Queue<(int, int)>();
  for (final d in dirs) {
    if (m[p.source] & d != 0) q.add((p.source, d));
  }
  while (q.isNotEmpty) {
    final (i, d) = q.removeFirst();
    final j = neighbor(i, d, p.rows, p.cols);
    if (j == null) continue;
    final a = opposite(d);
    if (m[j] & a == 0 || !seen.add(j * 16 + a)) continue;
    if (p.isBridge(j)) {
      flow[j] |= flowAny | (a == dE || a == dW ? flowEW : flowNS);
      q.add((j, d));
    } else {
      flow[j] |= flowAny;
      for (final e in dirs) {
        if (e != a && m[j] & e != 0) q.add((j, e));
      }
    }
  }
  return flow;
}

/// The drain gets water.
bool channelSolved(ChannelPuzzle p, List<int> m) => channelFlow(p, m)[p.target] != 0;
