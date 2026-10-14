import 'dart:collection';
import 'dart:math';

import 'channel_model.dart';

/// One tile of a route: the cell, the arm the water comes in by and the arm
/// it leaves by (0 for the source's way in and the drain's way out).
typedef RouteStep = (int cell, int inArm, int outArm);

int _armIndex(int d) => switch (d) {
  dN => 0,
  dE => 1,
  dS => 2,
  _ => 3,
};

/// Whether tile [i] can be turned so that it has every arm in [arms]
/// (a fixed tile only as it lies).
bool canHold(ChannelPuzzle p, int i, int arms) {
  final m = p.masks[i];
  if (p.locked[i] || p.isBridge(i)) return m & arms == arms;
  for (var t = 0; t < 4; t++) {
    if (rotateMask(m, t) & arms == arms) return true;
  }
  return false;
}

/// The arms water coming into tile [i] by arm [a] can leave by, in some
/// orientation of the tile.
int exitsOf(ChannelPuzzle p, int i, int a) {
  if (p.isBridge(i)) return opposite(a);
  var out = 0;
  for (final b in dirs) {
    if (b != a && canHold(p, i, a | b)) out |= b;
  }
  return out;
}

/// Route search state over (tile, arm water comes in by).
class _Best {
  _Best(this.p, this.cost);

  final ChannelPuzzle p;

  /// Cost of passing tile i from arm a to arm b.
  final int Function(int i, int a, int b) cost;

  List<RouteStep>? run() {
    final n = p.cells * 4;
    final dist = List<int>.filled(n, 1 << 30);
    final parent = List<int>.filled(n, -1); // state * 4 + exit arm index, or -1
    final q = ListQueue<int>();
    final firstArm = List<int>.filled(n, 0);
    for (final d in dirs) {
      if (p.masks[p.source] & d == 0) continue;
      final j = neighbor(p.source, d, p.rows, p.cols);
      if (j == null) continue;
      final s = j * 4 + _armIndex(opposite(d));
      dist[s] = 0;
      firstArm[s] = d;
      q.add(s);
    }
    final done = List<bool>.filled(n, false);
    while (q.isNotEmpty) {
      final s = q.removeFirst();
      if (done[s]) continue;
      done[s] = true;
      final j = s ~/ 4, a = dirs[s % 4];
      if (j == p.source) continue;
      if (j == p.target) {
        if (p.masks[j] & a == 0) continue;
        return _route(s, parent, firstArm);
      }
      if (!canHold(p, j, a)) continue;
      final exits = exitsOf(p, j, a);
      for (final b in dirs) {
        if (exits & b == 0) continue;
        final k = neighbor(j, b, p.rows, p.cols);
        if (k == null) continue;
        final t = k * 4 + _armIndex(opposite(b));
        final c = cost(j, a, b);
        final nd = dist[s] + c;
        if (nd < dist[t]) {
          dist[t] = nd;
          parent[t] = s * 4 + _armIndex(b);
          firstArm[t] = firstArm[s];
          if (c == 0) {
            q.addFirst(t);
          } else {
            q.addLast(t);
          }
        }
      }
    }
    return null;
  }

  List<RouteStep> _route(int end, List<int> parent, List<int> firstArm) {
    final steps = <RouteStep>[(end ~/ 4, dirs[end % 4], 0)];
    var s = end;
    while (parent[s] >= 0) {
      final prev = parent[s] ~/ 4, b = dirs[parent[s] % 4];
      steps.add((prev ~/ 4, dirs[prev % 4], b));
      s = prev;
    }
    steps.add((p.source, 0, firstArm[end]));
    return steps.reversed.toList();
  }
}

/// Whether one orientation per tile serves every step of [route], with each
/// bridge pipe and every other tile used once.
bool routeFits(ChannelPuzzle p, List<RouteStep> route) {
  final arms = <int, int>{};
  for (final (i, a, b) in route) {
    final both = a | b;
    if (p.isBridge(i)) {
      final axis = (a | b) & (dE | dW) != 0 ? 1 : 2;
      if ((arms[i] ?? 0) & axis != 0) return false;
      arms[i] = (arms[i] ?? 0) | axis;
    } else {
      if (arms.containsKey(i)) return false;
      if (!canHold(p, i, both)) return false;
      arms[i] = both;
    }
  }
  return true;
}

/// The fewest tiles any route from the source to the drain passes (the
/// tiles' shapes allow it, ignoring how they lie now), or null if none.
int? shortestRoute(ChannelPuzzle p) => _Best(p, (i, a, b) => 1).run()?.length;

/// A route that needs the fewest tiles turned from [current], or null.
/// Tiles that already carry the water stay as they are.
List<RouteStep>? cheapestRoute(ChannelPuzzle p, List<int> current) {
  final route = _Best(p, (i, a, b) => current[i] & (a | b) == (a | b) ? 0 : 1).run();
  return route != null && routeFits(p, route) ? route : null;
}

/// The route of the solved board (every tile as in [ChannelPuzzle.masks]).
List<RouteStep> solvedRoute(ChannelPuzzle p) => _Best(p, (i, a, b) => p.masks[i] & (a | b) == (a | b) ? 0 : 1).run()!;

/// Depth-first route search from the source, the way a player follows the
/// pipe: at each tile it tries the ways on (those the tile has now first,
/// else in [rng]'s order). [nodes] counts the tiles tried.
class RouteSearch {
  RouteSearch(this.p, {this.current, this.rng, this.cap = 20000}) : _used = List<int>.filled(p.cells, 0);

  final ChannelPuzzle p;
  final List<int>? current;
  final Random? rng;
  final int cap;
  int nodes = 0;
  final List<int> _used;
  final List<RouteStep> _route = [];

  /// The route found, or null when there is none or the cap ran out.
  List<RouteStep>? run() {
    for (final d in dirs) {
      if (p.masks[p.source] & d == 0) continue;
      final j = neighbor(p.source, d, p.rows, p.cols);
      if (j == null) continue;
      _route.add((p.source, 0, d));
      if (_go(j, opposite(d))) return List.of(_route);
      _route.removeLast();
      if (nodes > cap) return null;
    }
    return null;
  }

  bool _go(int j, int a) {
    if (++nodes > cap) return false;
    if (j == p.source) return false;
    if (j == p.target) {
      if (p.masks[j] & a == 0) return false;
      _route.add((j, a, 0));
      return true;
    }
    if (p.isBridge(j)) {
      final axis = a == dE || a == dW ? 1 : 2;
      if (_used[j] & axis != 0) return false;
      final b = opposite(a);
      final k = neighbor(j, b, p.rows, p.cols);
      if (k == null) return false;
      _used[j] |= axis;
      _route.add((j, a, b));
      if (_go(k, opposite(b))) return true;
      _route.removeLast();
      _used[j] &= ~axis;
      return false;
    }
    if (_used[j] != 0 || !canHold(p, j, a)) return false;
    final exits = exitsOf(p, j, a);
    final order = [
      for (final b in dirs)
        if (exits & b != 0 && neighbor(j, b, p.rows, p.cols) != null) b,
    ];
    if (rng != null) order.shuffle(rng);
    final cur = current;
    if (cur != null) {
      order.sort((x, y) => (cur[j] & (a | y) == (a | y) ? 1 : 0) - (cur[j] & (a | x) == (a | x) ? 1 : 0));
    }
    _used[j] = 1;
    for (final b in order) {
      _route.add((j, a, b));
      if (_go(neighbor(j, b, p.rows, p.cols)!, opposite(b))) return true;
      _route.removeLast();
      if (nodes > cap) break;
    }
    _used[j] = 0;
    return false;
  }
}

/// Quarter turns clockwise (1–3) that give tile [i], lying as [mask], the
/// arms [arms], or null.
int? turnsTo(int mask, int arms) {
  for (var t = 1; t < 4; t++) {
    if (rotateMask(mask, t) & arms == arms) return t;
  }
  return null;
}

/// The next tile to turn toward a solution, and its new turns: along a
/// route that needs the fewest tiles turned, the first tile from the source
/// that doesn't carry the water yet. Null when the drain already has water.
(int, int)? channelHintTurn(ChannelPuzzle p, PipesState s) {
  final m = channelMasks(p, s);
  if (channelSolved(p, m)) return null;
  final route = cheapestRoute(p, m) ?? RouteSearch(p, current: m, cap: 20000).run() ?? solvedRoute(p);
  for (final (i, a, b) in route) {
    if (!p.turnable(i)) continue;
    final arms = a | b;
    if (m[i] & arms == arms) continue;
    final t = turnsTo(m[i], arms);
    if (t != null) return (i, s.turns[i] + t);
  }
  // The route is laid but blocked elsewhere: turn toward the solved board.
  for (var i = 0; i < p.cells; i++) {
    if (p.turnable(i) && m[i] != p.masks[i]) {
      return (i, s.turns[i] + (turnsTo(m[i], p.masks[i]) ?? 0));
    }
  }
  return null;
}
