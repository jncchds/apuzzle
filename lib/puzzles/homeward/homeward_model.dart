import '../../core/grid.dart';

/// Road bits of a crossing: N=1, E=2, S=4, W=8.
const int rN = 1, rE = 2, rS = 4, rW = 8;
const roadDirs = [rN, rE, rS, rW];

int roadOpposite(int d) => switch (d) {
  rN => rS,
  rE => rW,
  rS => rN,
  _ => rE,
};

/// The crossing next to [i] towards [d], or null at the edge.
int? roadStep(int i, int d, int rows, int cols) {
  final r = i ~/ cols, c = i % cols;
  return switch (d) {
    rN => r > 0 ? i - cols : null,
    rS => r < rows - 1 ? i + cols : null,
    rW => c > 0 ? i - 1 : null,
    _ => c < cols - 1 ? i + 1 : null,
  };
}

/// What becomes of a pet: it waits at its spot, rides in the car, or is home.
enum PetStatus { waiting, aboard, home }

/// A town of crossings ([rows] × [cols], one per cell) joined by roads. The
/// car starts at [start]; pet k waits at [pets][k] and lives at [homes][k].
/// Driving one road costs one unit of fuel, and [limit] is all there is.
class HomewardPuzzle {
  const HomewardPuzzle({
    required this.rows,
    required this.cols,
    required this.roads,
    required this.start,
    required this.pets,
    required this.homes,
    required this.seats,
    required this.limit,
    required this.best,
  });

  final int rows;
  final int cols;

  /// Roads leaving each crossing (direction bits). The network is connected.
  final List<int> roads;
  final int start;
  final List<int> pets;
  final List<int> homes;

  /// Pets the car holds at once.
  final int seats;

  /// Fuel: the most roads the player may drive.
  final int limit;

  /// Length of the shortest plan (at most [limit]).
  final int best;

  GridSize get size => GridSize(rows, cols);
  int get petCount => pets.length;

  /// Whether a road joins neighbouring crossings [a] and [b].
  bool joined(int a, int b) {
    for (final d in roadDirs) {
      if (roadStep(a, d, rows, cols) == b) return roads[a] & d != 0;
    }
    return false;
  }

  /// Crossings one road away from [i].
  Iterable<int> neighbours(int i) sync* {
    for (final d in roadDirs) {
      if (roads[i] & d != 0) yield roadStep(i, d, rows, cols)!;
    }
  }

  Map<String, dynamic> toJson() => {
    'rows': rows,
    'cols': cols,
    'roads': roads,
    'start': start,
    'pets': pets,
    'homes': homes,
    'seats': seats,
    'limit': limit,
    'best': best,
  };
  factory HomewardPuzzle.fromJson(Map<String, dynamic> j) => HomewardPuzzle(
    rows: j['rows'] as int,
    cols: j['cols'] as int,
    roads: (j['roads'] as List).cast<int>(),
    start: j['start'] as int,
    pets: (j['pets'] as List).cast<int>(),
    homes: (j['homes'] as List).cast<int>(),
    seats: j['seats'] as int,
    limit: j['limit'] as int,
    best: j['best'] as int,
  );
}

/// The crossings driven through, from the start to where the car is now.
class HomewardState {
  const HomewardState(this.route);
  final List<int> route;

  int get car => route.last;
  int get used => route.length - 1;

  Map<String, dynamic> toJson() => {'route': route};
  factory HomewardState.fromJson(Map<String, dynamic> j) => HomewardState((j['route'] as List).cast<int>());
}

/// Seats after arriving at [node]: a pet whose home this is gets off, then a
/// pet waiting here gets on if a seat is free. Pets are bits of [aboard] and
/// [home]; [petAt] and [homeAt] give the pet at a crossing or -1.
(int aboard, int home) arrive(int aboard, int home, int node, List<int> petAt, List<int> homeAt, int seats) {
  final h = homeAt[node];
  if (h >= 0 && aboard & (1 << h) != 0) {
    aboard &= ~(1 << h);
    home |= 1 << h;
  }
  final k = petAt[node];
  if (k >= 0 && (aboard | home) & (1 << k) == 0 && _bits(aboard) < seats) aboard |= 1 << k;
  return (aboard, home);
}

int _bits(int x) {
  var n = 0;
  for (; x != 0; x &= x - 1) {
    n++;
  }
  return n;
}

/// Pet (or -1) at every crossing, from a list of their crossings.
List<int> spotsOf(int nodes, List<int> at) {
  final out = List<int>.filled(nodes, -1);
  for (var k = 0; k < at.length; k++) {
    out[at[k]] = k;
  }
  return out;
}

/// Where things stand after driving [route].
class HomewardTrip {
  HomewardTrip._(this.aboard, this.home, this.seated);

  factory HomewardTrip.of(HomewardPuzzle p, List<int> route) {
    final petAt = spotsOf(p.rows * p.cols, p.pets), homeAt = spotsOf(p.rows * p.cols, p.homes);
    var aboard = 0, home = 0;
    final seated = <int>[];
    for (final node in route.skip(1)) {
      final (a, h) = arrive(aboard, home, node, petAt, homeAt, p.seats);
      seated.removeWhere((k) => a & (1 << k) == 0);
      for (var k = 0; k < p.petCount; k++) {
        if (a & (1 << k) != 0 && aboard & (1 << k) == 0) seated.add(k);
      }
      aboard = a;
      home = h;
    }
    return HomewardTrip._(aboard, home, seated);
  }

  /// Pet bits.
  final int aboard;
  final int home;

  /// Pets in the car, in the order they got in.
  final List<int> seated;

  PetStatus status(int k) => home & (1 << k) != 0
      ? PetStatus.home
      : aboard & (1 << k) != 0
      ? PetStatus.aboard
      : PetStatus.waiting;

  bool allHome(int petCount) => home == (1 << petCount) - 1;
}

/// A drive along roads from the start that brings every pet home within the fuel.
bool homewardSolved(HomewardPuzzle p, List<int> route) {
  if (route.isEmpty || route.first != p.start || route.length - 1 > p.limit) return false;
  for (var k = 1; k < route.length; k++) {
    if (!p.joined(route[k - 1], route[k])) return false;
  }
  return HomewardTrip.of(p, route).allHome(p.petCount);
}
