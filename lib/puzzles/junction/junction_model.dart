import 'dart:math';

import '../../core/grid.dart';

/// What ends a game.
enum JunctionGoal {
  /// A fixed number of trains ([junctionTrainCount]).
  trains('trains'),

  /// A round of [junctionRoundSeconds].
  timed('timed');

  const JunctionGoal(this.id);
  final String id;

  static JunctionGoal byId(String? id) => values.firstWhere((g) => g.id == id, orElse: () => trains);
}

/// Trains of a [JunctionGoal.trains] game.
const junctionTrainCount = 20;

/// Length of a [JunctionGoal.timed] round.
const junctionRoundSeconds = 120;

/// Up, right, down, left.
const junctionDirs = [(-1, 0), (0, 1), (1, 0), (0, -1)];

/// Cells off the track have no parent; the depot's parent is [junctionDepot].
const junctionOff = -1;
const junctionDepot = -2;

/// A track network laid on the grid as a tree: trains come out of the depot
/// (a tunnel at the edge), run toward the leaves, and each switch (a cell
/// with two branches) sends them down the branch it is set to. The leaves are
/// the stations, one per symbol.
class JunctionPuzzle {
  JunctionPuzzle({
    required this.rows,
    required this.cols,
    required this.goal,
    required this.trains,
    required this.ticks,
    required this.seed,
    required this.stepMs,
    required this.gapMin,
    required this.gapMax,
    required this.parent,
    required this.stations,
    required this.start,
    this.fixed = const [],
    this.perfect = false,
  });

  final int rows;
  final int cols;
  final JunctionGoal goal;

  /// Trains of a [JunctionGoal.trains] game (else 0).
  final int trains;

  /// Steps of a [JunctionGoal.timed] round (else 0).
  final int ticks;

  /// Drives the trains' symbols and departures, so a share code replays them.
  final int seed;

  /// Milliseconds a train takes from one cell to the next.
  final int stepMs;

  /// Steps between two departures, drawn from this range.
  final int gapMin;
  final int gapMax;

  /// The cell each track cell is entered from ([junctionOff], [junctionDepot]).
  final List<int> parent;

  /// The cell of station k (symbol k).
  final List<int> stations;

  /// The first setting of every switch (index into its branches).
  final List<int> start;

  /// Symbols of the first trains (tutorials), instead of drawn ones.
  final List<int> fixed;

  /// A practice board (tutorials): one wrong station ends the game unsolved.
  final bool perfect;

  GridSize get size => GridSize(rows, cols);
  int get cells => rows * cols;
  int get colors => stations.length;

  late final int depot = parent.indexOf(junctionDepot);

  /// The branches out of each cell, in cell order.
  late final List<List<int>> children = () {
    final out = List.generate(cells, (_) => <int>[]);
    for (var i = 0; i < cells; i++) {
      if (parent[i] >= 0) out[parent[i]].add(i);
    }
    return out;
  }();

  /// Cells with two branches, in cell order.
  late final List<int> switches = [
    for (var i = 0; i < cells; i++)
      if (children[i].length > 1) i,
  ];

  /// Switch index of a cell, or -1.
  late final List<int> switchAt = () {
    final out = List.filled(cells, -1);
    for (var k = 0; k < switches.length; k++) {
      out[switches[k]] = k;
    }
    return out;
  }();

  /// Station (symbol) of a cell, or -1.
  late final List<int> stationAt = () {
    final out = List.filled(cells, -1);
    for (var k = 0; k < stations.length; k++) {
      out[stations[k]] = k;
    }
    return out;
  }();

  /// route[k][j]: the branch switch j must take toward station k, or -1 if
  /// the station is not behind it.
  late final List<List<int>> route = [
    for (final st in stations)
      () {
        final out = List.filled(switches.length, -1);
        for (var c = st; parent[c] >= 0; c = parent[c]) {
          final j = switchAt[parent[c]];
          if (j >= 0) out[j] = children[parent[c]].indexOf(c);
        }
        return out;
      }(),
  ];

  /// Where a train on [cell] goes next with switches at [settings].
  int nextCell(int cell, List<int> settings) {
    final out = children[cell];
    if (out.length == 1) return out.first;
    return out[settings[switchAt[cell]]];
  }

  /// Steps from the depot to [cell].
  int depth(int cell) {
    var d = 0;
    for (var c = cell; parent[c] >= 0; c = parent[c]) {
      d++;
    }
    return d;
  }

  Random _rng(int train) => Random((seed * 1000003 + train * 7919 + 17) & 0x7fffffff);

  /// The symbol of train [i].
  int colorOf(int i) => i < fixed.length ? fixed[i] : _rng(i).nextInt(colors);

  /// Steps between train [i]'s departure and the next one's.
  int gapAfter(int i) {
    final rng = _rng(i)..nextInt(colors);
    return gapMin + rng.nextInt(gapMax - gapMin + 1);
  }

  Map<String, dynamic> toJson() => {
    'rows': rows,
    'cols': cols,
    'goal': goal.id,
    'trains': trains,
    'ticks': ticks,
    'seed': seed,
    'ms': stepMs,
    'gap': [gapMin, gapMax],
    'parent': parent,
    'stations': stations,
    'start': start,
    if (fixed.isNotEmpty) 'fixed': fixed,
    if (perfect) 'perfect': true,
  };

  factory JunctionPuzzle.fromJson(Map<String, dynamic> j) => JunctionPuzzle(
    rows: j['rows'] as int,
    cols: j['cols'] as int,
    goal: JunctionGoal.byId(j['goal'] as String?),
    trains: j['trains'] as int,
    ticks: j['ticks'] as int,
    seed: j['seed'] as int,
    stepMs: j['ms'] as int,
    gapMin: (j['gap'] as List)[0] as int,
    gapMax: (j['gap'] as List)[1] as int,
    parent: (j['parent'] as List).cast<int>(),
    stations: (j['stations'] as List).cast<int>(),
    start: (j['start'] as List).cast<int>(),
    fixed: ((j['fixed'] as List?) ?? const []).cast<int>(),
    perfect: j['perfect'] as bool? ?? false,
  );
}

/// A train on the track.
class JunctionTrain {
  const JunctionTrain(this.id, this.color, this.cell, this.from);

  final int id;
  final int color;
  final int cell;

  /// The cell it came from in the last step (-1: it just left the depot).
  final int from;

  List<int> toJson() => [id, color, cell, from];
  factory JunctionTrain.fromJson(List<dynamic> j) => JunctionTrain(j[0] as int, j[1] as int, j[2] as int, j[3] as int);
}

/// A train that reached a station.
class JunctionArrival {
  const JunctionArrival(this.id, this.color, this.station, this.tick, this.from);

  final int id;
  final int color;

  /// The station it reached (its symbol).
  final int station;

  /// The step it arrived in.
  final int tick;

  /// The cell before the station.
  final int from;

  bool get ok => color == station;

  List<int> toJson() => [id, color, station, tick, from];
  factory JunctionArrival.fromJson(List<dynamic> j) =>
      JunctionArrival(j[0] as int, j[1] as int, j[2] as int, j[3] as int, j[4] as int);
}

class JunctionState {
  const JunctionState({
    required this.tick,
    required this.settings,
    this.trains = const [],
    this.next = 0,
    this.nextAt = 1,
    this.arrived = const [],
  });

  factory JunctionState.initial(JunctionPuzzle p) => JunctionState(tick: 0, settings: p.start);

  /// Steps played.
  final int tick;

  /// The branch every switch is set to.
  final List<int> settings;

  /// Trains on the track, oldest first.
  final List<JunctionTrain> trains;

  /// The next train to leave the depot, and the step it leaves in.
  final int next;
  final int nextAt;

  /// Trains that reached a station, in order.
  final List<JunctionArrival> arrived;

  int get score => arrived.where((a) => a.ok).length;
  int get misses => arrived.length - score;

  Map<String, dynamic> toJson() => {
    'tick': tick,
    'set': settings,
    'trains': [for (final t in trains) t.toJson()],
    'next': next,
    'at': nextAt,
    'done': [for (final a in arrived) a.toJson()],
  };

  factory JunctionState.fromJson(Map<String, dynamic> j) => JunctionState(
    tick: j['tick'] as int,
    settings: (j['set'] as List).cast<int>(),
    trains: [for (final t in j['trains'] as List) JunctionTrain.fromJson(t as List)],
    next: j['next'] as int,
    nextAt: j['at'] as int,
    arrived: [for (final a in j['done'] as List) JunctionArrival.fromJson(a as List)],
  );
}

/// The game is over: every train is in (or the time is up); on a practice
/// board also after the first wrong station.
bool junctionOver(JunctionPuzzle p, JunctionState s) =>
    (p.perfect && s.misses > 0) ||
    (p.goal == JunctionGoal.timed ? s.tick >= p.ticks : s.next >= p.trains && s.trains.isEmpty);

/// One step: every train moves one cell (through switches as they are set
/// now), trains that reach a station arrive there, and the next train leaves
/// the depot when its time has come.
JunctionState junctionStep(JunctionPuzzle p, JunctionState s) {
  if (junctionOver(p, s)) return s;
  final tick = s.tick + 1;
  final trains = <JunctionTrain>[];
  final arrived = [...s.arrived];
  for (final t in s.trains) {
    final next = p.nextCell(t.cell, s.settings);
    final station = p.stationAt[next];
    if (station >= 0) {
      arrived.add(JunctionArrival(t.id, t.color, station, tick, t.cell));
    } else {
      trains.add(JunctionTrain(t.id, t.color, next, t.cell));
    }
  }
  var next = s.next, nextAt = s.nextAt;
  final more = p.goal == JunctionGoal.timed || next < p.trains;
  if (more && tick >= nextAt) {
    trains.add(JunctionTrain(next, p.colorOf(next), p.depot, -1));
    nextAt = tick + p.gapAfter(next);
    next++;
  }
  return JunctionState(
    tick: tick,
    settings: s.settings,
    trains: trains,
    next: next,
    nextAt: nextAt,
    arrived: arrived,
  );
}

/// Switch [k] flipped to its other branch.
JunctionState junctionFlip(JunctionPuzzle p, JunctionState s, int k) {
  if (junctionOver(p, s)) return s;
  final settings = [...s.settings];
  settings[k] = 1 - settings[k];
  return JunctionState(
    tick: s.tick,
    settings: settings,
    trains: s.trains,
    next: s.next,
    nextAt: s.nextAt,
    arrived: s.arrived,
  );
}

/// The switch a train on a wrongly set switch needs flipped, or null.
int? junctionNeeded(JunctionPuzzle p, JunctionState s) {
  for (final t in s.trains) {
    final j = p.switchAt[t.cell];
    if (j < 0) continue;
    final want = p.route[t.color][j];
    if (want >= 0 && s.settings[j] != want) return j;
  }
  return null;
}

/// The perfect player's next move: flip a switch a train is about to leave
/// the wrong way, else step. Null when the game is over.
JunctionState? junctionAuto(JunctionPuzzle p, JunctionState s) {
  if (junctionOver(p, s)) return null;
  final j = junctionNeeded(p, s);
  return j != null ? junctionFlip(p, s, j) : junctionStep(p, s);
}
