import '../../core/grid.dart';

/// A patrol ship's beat: it sails [route] (cells, each next to the one
/// before) one cell per turn, round and round if [loop] (the last cell is
/// next to the first), else back and forth. At turn t it is where turn
/// t + [phase] of that beat puts it.
class Patrol {
  const Patrol(this.route, {required this.loop, this.phase = 0});

  final List<int> route;
  final bool loop;
  final int phase;

  /// Turns until the ship is back where it was, heading the same way.
  int get period => loop ? route.length : 2 * (route.length - 1);

  /// The ship's cell at turn [t].
  int at(int t) {
    final k = (t + phase) % period;
    return loop || k < route.length ? route[k] : route[period - k];
  }

  Map<String, dynamic> toJson() => {'route': route, 'loop': loop, 'phase': phase};
  factory Patrol.fromJson(Map<String, dynamic> j) =>
      Patrol((j['route'] as List).cast<int>(), loop: j['loop'] as bool, phase: j['phase'] as int);
}

int _gcd(int a, int b) => b == 0 ? a : _gcd(b, a % b);

/// Turns after which every ship of [patrols] is back where it started.
int patrolCycle(List<Patrol> patrols) {
  var l = 1;
  for (final s in patrols) {
    l = l ~/ _gcd(l, s.period) * s.period;
  }
  return l;
}

/// A sea of [rows] × [cols] cells with [rocks]. The boat starts at [start]
/// and must reach the harbour at [goal] within [limit] turns, never caught by
/// a ship of [patrols]. No ship's beat passes the start or the harbour.
class BlockadePuzzle {
  const BlockadePuzzle({
    required this.rows,
    required this.cols,
    required this.rocks,
    required this.start,
    required this.goal,
    required this.patrols,
    required this.limit,
    required this.best,
  });

  final int rows;
  final int cols;
  final List<bool> rocks;
  final int start;
  final int goal;
  final List<Patrol> patrols;

  /// The most turns the player may take.
  final int limit;

  /// Turns of the fastest safe passage (at most [limit]).
  final int best;

  GridSize get size => GridSize(rows, cols);
  int get cells => rows * cols;

  /// Turns after which all ships are back where they started.
  int get cycle => patrolCycle(patrols);

  /// Open sea next to [i] (up, right, down, left).
  Iterable<int> neighbours(int i) sync* {
    final r = i ~/ cols, c = i % cols;
    if (r > 0 && !rocks[i - cols]) yield i - cols;
    if (c < cols - 1 && !rocks[i + 1]) yield i + 1;
    if (r < rows - 1 && !rocks[i + cols]) yield i + cols;
    if (c > 0 && !rocks[i - 1]) yield i - 1;
  }

  /// Whether the boat may sail from [a] to [b] in one turn (or wait there).
  bool canSail(int a, int b) {
    if (b < 0 || b >= cells || rocks[b]) return false;
    if (a == b) return true;
    final d = (a - b).abs();
    return d == cols || d == 1 && a ~/ cols == b ~/ cols;
  }

  Map<String, dynamic> toJson() => {
    'rows': rows,
    'cols': cols,
    'rocks': [
      for (var i = 0; i < rocks.length; i++)
        if (rocks[i]) i,
    ],
    'start': start,
    'goal': goal,
    'patrols': [for (final s in patrols) s.toJson()],
    'limit': limit,
    'best': best,
  };
  factory BlockadePuzzle.fromJson(Map<String, dynamic> j) {
    final rows = j['rows'] as int, cols = j['cols'] as int;
    final rocks = List<bool>.filled(rows * cols, false);
    for (final i in (j['rocks'] as List).cast<int>()) {
      rocks[i] = true;
    }
    return BlockadePuzzle(
      rows: rows,
      cols: cols,
      rocks: rocks,
      start: j['start'] as int,
      goal: j['goal'] as int,
      patrols: [for (final s in j['patrols'] as List) Patrol.fromJson((s as Map).cast<String, dynamic>())],
      limit: j['limit'] as int,
      best: j['best'] as int,
    );
  }
}

/// The boat's cell after every turn so far (a wait repeats the cell), from
/// the start.
class BlockadeState {
  const BlockadeState(this.route);
  final List<int> route;

  int get boat => route.last;
  int get turn => route.length - 1;

  Map<String, dynamic> toJson() => {'route': route};
  factory BlockadeState.fromJson(Map<String, dynamic> j) => BlockadeState((j['route'] as List).cast<int>());
}

/// Whether the boat is caught when it sails from [a] to [b] in turn [t] (the
/// ships moving from where they are at turn t to turn t + 1): a ship ends on
/// its cell, or a ship and the boat swap cells.
bool blockadeCaught(List<Patrol> patrols, int a, int b, int t) {
  for (final s in patrols) {
    final to = s.at(t + 1);
    if (to == b || to == a && s.at(t) == b) return true;
  }
  return false;
}

/// The turn of [route] in which the boat was caught, or -1.
int caughtTurn(BlockadePuzzle p, List<int> route) {
  for (var t = 1; t < route.length; t++) {
    if (blockadeCaught(p.patrols, route[t - 1], route[t], t - 1)) return t;
  }
  return -1;
}

/// A passage from the start to the harbour within the turn limit, every turn
/// a step to open sea or a wait, never caught.
bool blockadeSolved(BlockadePuzzle p, List<int> route) {
  if (route.isEmpty || route.first != p.start || route.last != p.goal || route.length - 1 > p.limit) return false;
  for (var t = 1; t < route.length; t++) {
    if (!p.canSail(route[t - 1], route[t])) return false;
  }
  return caughtTurn(p, route) < 0;
}
