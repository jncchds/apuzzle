import 'dart:typed_data';

import 'homeward_model.dart';

/// Shortest plans by breadth-first search over (crossing, pets aboard, pets
/// home). Every road costs the same, so the first finished state found is
/// optimal. A state is `node << 2P | aboard << P | home`.
class HomewardSolver {
  HomewardSolver(this.p)
    : nodes = p.rows * p.cols,
      petAt = spotsOf(p.rows * p.cols, p.pets),
      homeAt = spotsOf(p.rows * p.cols, p.homes),
      adj = [for (var i = 0; i < p.rows * p.cols; i++) p.neighbours(i).toList()];

  final HomewardPuzzle p;
  final int nodes;
  final List<int> petAt;
  final List<int> homeAt;
  final List<List<int>> adj;

  int get _pets => p.petCount;
  int get _all => (1 << _pets) - 1;

  /// The fewest roads that bring every pet home from [node] with [aboard] and
  /// [home], and the first crossing to drive to (-1 when already done). Null
  /// if it takes more than [maxMoves].
  ({int moves, int first})? solve(int node, int aboard, int home, {int maxMoves = 1 << 30}) {
    if (home == _all) return (moves: 0, first: -1);
    final shift = 2 * _pets, mask = (1 << shift) - 1, pm = _all;
    // First move taken to reach each state (index into adj of the root) + 1.
    final seen = Uint8List(nodes << shift);
    final root = node << shift | aboard << _pets | home;
    seen[root] = 255;
    var level = <int>[root];
    for (var moves = 1; moves <= maxMoves && level.isNotEmpty; moves++) {
      final next = <int>[];
      for (final s in level) {
        final at = s >> shift, a0 = (s & mask) >> _pets, h0 = s & pm;
        final from = seen[s];
        final out = adj[at];
        for (var e = 0; e < out.length; e++) {
          final v = out[e];
          final (a, h) = arrive(a0, h0, v, petAt, homeAt, p.seats);
          final t = v << shift | a << _pets | h;
          if (seen[t] != 0) continue;
          final first = from == 255 ? e + 1 : from;
          if (h == pm) return (moves: moves, first: adj[node][first - 1]);
          seen[t] = first;
          next.add(t);
        }
      }
      level = next;
    }
    return null;
  }

  /// The shortest plan from the start: crossings after the start.
  List<int> plan() {
    final route = [p.start];
    var aboard = 0, home = 0;
    while (home != _all) {
      final r = solve(route.last, aboard, home)!;
      route.add(r.first);
      (aboard, home) = arrive(aboard, home, r.first, petAt, homeAt, p.seats);
    }
    return route;
  }

  /// Length of the shortest plan from the start.
  int best() => solve(p.start, 0, 0)!.moves;

  /// Roads driven by the obvious plan: always head for the nearest place
  /// where something happens (a waiting pet with a seat free, or the home of
  /// a pet aboard), by a shortest way.
  int greedy() {
    var at = p.start, aboard = 0, home = 0, moves = 0;
    final parent = List<int>.filled(nodes, -1);
    while (home != _all) {
      final free = _count(aboard) < p.seats;
      bool target(int v) {
        final k = petAt[v], h = homeAt[v];
        if (k >= 0 && free && (aboard | home) & (1 << k) == 0) return true;
        return h >= 0 && aboard & (1 << h) != 0;
      }

      parent.fillRange(0, nodes, -1);
      parent[at] = at;
      final queue = [at];
      var goal = -1;
      for (var q = 0; q < queue.length && goal < 0; q++) {
        for (final v in adj[queue[q]]) {
          if (parent[v] >= 0) continue;
          parent[v] = queue[q];
          if (target(v)) {
            goal = v;
            break;
          }
          queue.add(v);
        }
      }
      final way = <int>[];
      for (var v = goal; v != at; v = parent[v]) {
        way.add(v);
      }
      for (final v in way.reversed) {
        (aboard, home) = arrive(aboard, home, v, petAt, homeAt, p.seats);
        moves++;
      }
      at = goal;
    }
    return moves;
  }
}

int _count(int x) {
  var n = 0;
  for (; x != 0; x &= x - 1) {
    n++;
  }
  return n;
}
