import 'dart:typed_data';

import 'blockade_model.dart';

/// Fastest safe passages by breadth-first search over (cell, turn modulo the
/// ships' common cycle): the ships are back where they were after a cycle,
/// so a state reached again later has nothing new to offer. Every turn
/// costs the same, so the first time the harbour is reached is optimal.
class BlockadeSolver {
  BlockadeSolver(this.p)
    : cycle = p.cycle,
      moves = [
        for (var i = 0; i < p.cells; i++) [i, ...p.neighbours(i)],
      ] {
    // Where every ship is at each turn of the cycle (one more for t + 1).
    for (var t = 0; t <= cycle; t++) {
      _at.add(Int32List.fromList([for (final s in p.patrols) s.at(t)]));
    }
  }

  final BlockadePuzzle p;
  final int cycle;

  /// Wait first, then the open neighbours.
  final List<List<int>> moves;
  final List<Int32List> _at = [];

  /// Whether sailing from [a] to [b] in turn [t] is safe.
  bool safe(int a, int b, int t) {
    final now = _at[t % cycle], next = _at[t % cycle + 1];
    for (var k = 0; k < now.length; k++) {
      if (next[k] == b || next[k] == a && now[k] == b) return false;
    }
    return true;
  }

  /// The fewest turns from [cell] at turn [turn] to the harbour, and the cell
  /// to sail to first (-1 when already there). Null if it can't be done in
  /// [maxMoves] turns.
  ({int moves, int first})? solve(int cell, int turn, {int maxMoves = 1 << 30}) {
    if (cell == p.goal) return (moves: 0, first: -1);
    // First move (index into moves[cell]) + 1, per state; 0 = not seen.
    final seen = Uint8List(p.cells * cycle);
    final root = cell * cycle + turn % cycle;
    seen[root] = 255;
    var level = <int>[root];
    for (var n = 1; n <= maxMoves && level.isNotEmpty; n++) {
      final t = turn + n - 1;
      final next = <int>[];
      for (final s in level) {
        final at = s ~/ cycle, from = seen[s];
        final out = moves[at];
        for (var e = 0; e < out.length; e++) {
          final v = out[e];
          final u = v * cycle + (t + 1) % cycle;
          if (seen[u] != 0 || !safe(at, v, t)) continue;
          final first = from == 255 ? e + 1 : from;
          if (v == p.goal) return (moves: n, first: moves[cell][first - 1]);
          seen[u] = first;
          next.add(u);
        }
      }
      level = next;
    }
    return null;
  }

  /// The fastest safe passage from the start (cells after every turn,
  /// starting with the start).
  List<int> plan() {
    final route = [p.start];
    while (route.last != p.goal) {
      route.add(solve(route.last, route.length - 1)!.first);
    }
    return route;
  }

  /// Turns of the fastest safe passage from the start, or null if there is none.
  int? best() => solve(p.start, 0)?.moves;

  /// Steps from every cell to the harbour, ignoring the ships (-1: no way).
  List<int> distances() {
    final d = List<int>.filled(p.cells, -1);
    d[p.goal] = 0;
    final queue = [p.goal];
    for (var q = 0; q < queue.length; q++) {
      for (final v in p.neighbours(queue[q])) {
        if (d[v] >= 0) continue;
        d[v] = d[queue[q]] + 1;
        queue.add(v);
      }
    }
    return d;
  }

  /// Turns of the shortest way, ignoring the ships.
  int plain() => distances()[p.start];

  /// Turns of the fastest passage that waits only at the start and then
  /// sails a shortest way without stopping (no ship ever enters the start,
  /// so waiting there is safe), or null if none is done within [cap] turns.
  int? waitThenGo({int cap = 200}) {
    final d = distances(), plain = d[p.start];
    for (var w = 0; w + plain <= cap; w++) {
      var now = {p.start};
      for (var t = w; t < w + plain && now.isNotEmpty; t++) {
        now = {
          for (final a in now)
            for (final v in moves[a])
              if (d[v] == d[a] - 1 && safe(a, v, t)) v,
        };
      }
      if (now.isNotEmpty) return w + plain;
    }
    return null;
  }

  /// Turns taken by the obvious play, or null if it gets caught or takes
  /// more than [cap] turns: sail a shortest way to the harbour, waiting
  /// whenever the next step isn't safe, and dodging sideways or back when
  /// staying isn't safe either.
  int? greedy({int cap = 200}) {
    final d = distances();
    var at = p.start;
    for (var t = 0; t < cap; t++) {
      int? pick;
      for (final want in [-1, 0, 1]) {
        for (final v in moves[at]) {
          if (v != at && d[v] == d[at] + want && safe(at, v, t)) {
            pick = v;
            break;
          }
        }
        if (pick != null) break;
        if (want == -1 && safe(at, at, t)) {
          pick = at;
          break;
        }
      }
      if (pick == null) return null;
      at = pick;
      if (at == p.goal) return t + 1;
    }
    return null;
  }
}
