import 'dart:math';

import '../../core/difficulty.dart';
import '../../core/grid_graph.dart';
import 'chambers_model.dart';
import 'chambers_solver.dart';

int chambersTier(Difficulty d) => switch (d) {
  Difficulty.easy => 1,
  Difficulty.medium => 2,
  _ => 3,
};

/// Rooms are a random cut of the grid into rectangles (few single cells);
/// the shading first breaks every run across two borders, then adds random
/// cells (never touching, the rest in one piece). Every room shows its
/// count while a local search shades, clears, splits or joins around cells
/// the difficulty's tier can't settle, kept when the logic gets no further
/// behind (searching with tier 2 on hard boards). Then numbers are taken
/// away in random order while the tier still solves the board, and cells
/// still open are shown from the start. Medium and hard keep the best of
/// several boards by how far the tier below gets.
ChambersPuzzle generateChambers(GenParams params) {
  final n = params.size.rows, cells = n * n;
  final rng = Random(params.seed);
  final tier = chambersTier(params.difficulty);
  final nb = orthNeighbors(n, n);
  final maxSide = n <= 5 ? 3 : 4;
  final tries = switch (params.difficulty) {
    Difficulty.easy => 1,
    Difficulty.medium => 6,
    _ => 8,
  };
  ChambersPuzzle? best;
  var bestScore = -1 << 30;
  var failedLayouts = 0;

  for (var attempt = 0, made = 0; made < tries && attempt < 60 + failedLayouts && failedLayouts < 1000; attempt++) {
    final rooms = _rooms(n, rng, maxSide);
    final shaded = List<bool>.filled(cells, false);
    if (!_shade(n, rooms, shaded, nb, rng)) {
      failedLayouts++;
      continue;
    }

    List<int?> counts() => [for (final r in rooms) r.cells(n).where((i) => shaded[i]).length];
    ChambersPuzzle board(List<int?> clues, [List<int> givens = const []]) =>
        ChambersPuzzle(n: n, rooms: List.of(rooms), clues: clues, shaded: List.of(shaded), givens: givens);
    List<int> stuck(int t, ChambersPuzzle p) {
      final s = ChambersSolver(p);
      final st = s.start(givens: p.givens);
      if (!s.solve(st, t)) return [for (var i = 0; i < cells; i++) i];
      return [
        for (var i = 0; i < cells; i++)
          if (st[i] == -1) i,
      ];
    }

    // Settle the board with every number shown.
    final searchTier = min(tier, 2);
    var open = stuck(searchTier, board(counts()));
    for (var step = 0; step < cells * 3 && open.isNotEmpty; step++) {
      final r0 = List.of(rooms), s0 = List.of(shaded);
      _mutate(n, rooms, shaded, nb, rng, open[rng.nextInt(open.length)], maxSide);
      final next = _valid(n, rooms, shaded, nb) ? stuck(searchTier, board(counts())) : null;
      if (next != null && next.length <= open.length) {
        open = next;
      } else {
        rooms
          ..clear()
          ..addAll(r0);
        shaded.setAll(0, s0);
      }
    }
    if (tier == 3) open = stuck(3, board(counts()));
    if (open.isNotEmpty && attempt - failedLayouts < 30) continue;
    made++;

    // Take numbers away while the tier still solves it.
    final clues = counts();
    for (final k in [for (var k = 0; k < rooms.length; k++) k]..shuffle(rng)) {
      final keep = clues[k];
      clues[k] = null;
      if (stuck(tier, board(clues)).isNotEmpty) clues[k] = keep;
    }
    final givens = <int>[];
    while (true) {
      final left = stuck(tier, board(clues, givens));
      if (left.isEmpty) break;
      givens.add(left[rng.nextInt(left.length)]);
    }
    final puzzle = board(clues, givens..sort());
    if (tier == 1) return puzzle;
    // Score: the tier below should get stuck, givens are a last resort.
    final below = stuck(tier - 1, puzzle).length;
    final score = (below > 0 ? 1000 : 0) + min(below, cells ~/ 4) * 4 - givens.length * 20;
    if (score > bestScore) (best, bestScore) = (puzzle, score);
  }
  return best ?? generateChambers(params.withSeed(params.seed + 1));
}

/// A random cut of the grid into rectangles of at most [maxSide] a side.
List<ChambersRoom> _rooms(int n, Random rng, int maxSide) {
  final taken = List<bool>.filled(n * n, false);
  final rooms = <ChambersRoom>[];
  for (var r = 0; r < n; r++) {
    for (var c = 0; c < n; c++) {
      if (taken[r * n + c]) continue;
      var maxW = 0;
      while (maxW < maxSide && c + maxW < n && !taken[r * n + c + maxW]) {
        maxW++;
      }
      int w = 1, h = 1;
      for (var pick = 0; pick < 4; pick++) {
        w = 1 + rng.nextInt(maxW);
        if (w == 1 && maxW > 1 && rng.nextBool()) w = 2 + rng.nextInt(maxW - 1);
        var maxH = 0;
        while (maxH < maxSide &&
            r + maxH < n &&
            [for (var x = c; x < c + w; x++) !taken[(r + maxH) * n + x]].every((f) => f)) {
          maxH++;
        }
        h = 1 + rng.nextInt(maxH);
        if (h == 1 && maxH > 1 && rng.nextBool()) h = 2 + rng.nextInt(maxH - 1);
        if (w * h > 1 || (maxW == 1 && maxH == 1)) break;
      }
      final room = ChambersRoom(r, c, h, w);
      for (final i in room.cells(n)) {
        taken[i] = true;
      }
      rooms.add(room);
    }
  }
  return rooms;
}

bool _connected(List<List<int>> nb, List<bool> shaded) => components(nb, (i) => !shaded[i]).length == 1;

bool _canShade(List<List<int>> nb, List<bool> shaded, int i) {
  if (shaded[i] || nb[i].any((j) => shaded[j])) return false;
  shaded[i] = true;
  final ok = _connected(nb, shaded);
  shaded[i] = false;
  return ok;
}

/// Breaks every run across two borders, then shades random cells up to
/// about a quarter of the board; false if a run can't be broken.
bool _shade(int n, List<ChambersRoom> rooms, List<bool> shaded, List<List<int>> nb, Random rng) {
  if (!_breakRuns(n, rooms, shaded, nb, rng)) return false;
  final target = (n * n * (0.2 + rng.nextDouble() * 0.08)).round();
  var count = shaded.where((s) => s).length;
  for (final i in [for (var i = 0; i < n * n; i++) i]..shuffle(rng)) {
    if (count >= target) break;
    if (_canShade(nb, shaded, i)) {
      shaded[i] = true;
      count++;
    }
  }
  return true;
}

bool _breakRuns(int n, List<ChambersRoom> rooms, List<bool> shaded, List<List<int>> nb, Random rng) {
  final spans = chambersSpans(n, chambersRoomOf(n, rooms))..shuffle(rng);
  for (final span in spans) {
    if (span.any((i) => shaded[i])) continue;
    final options = [
      for (final i in span)
        if (_canShade(nb, shaded, i)) i,
    ];
    if (options.isEmpty) return false;
    shaded[options[rng.nextInt(options.length)]] = true;
  }
  return true;
}

/// No touching, one area, every run broken.
bool _valid(int n, List<ChambersRoom> rooms, List<bool> shaded, List<List<int>> nb) {
  for (var i = 0; i < n * n; i++) {
    if (shaded[i] && nb[i].any((j) => shaded[j])) return false;
  }
  if (!_connected(nb, shaded)) return false;
  return chambersSpans(n, chambersRoomOf(n, rooms)).every((s) => s.any((i) => shaded[i]));
}

/// Changes the board around cell [i]: shades or clears it (or a
/// neighbour), splits its room in two, or joins it with a neighbouring
/// room into a rectangle; runs a split leaves open are broken again.
void _mutate(int n, List<ChambersRoom> rooms, List<bool> shaded, List<List<int>> nb, Random rng, int i, int maxSide) {
  final k = chambersRoomOf(n, rooms)[i];
  final room = rooms[k];
  switch (rng.nextInt(4)) {
    case 0:
      if (shaded[i]) {
        shaded[i] = false;
      } else if (_canShade(nb, shaded, i)) {
        shaded[i] = true;
      } else {
        for (final j in nb[i]) {
          shaded[j] = false;
        }
        if (_canShade(nb, shaded, i)) shaded[i] = true;
      }
    case 1:
      final j = nb[i][rng.nextInt(nb[i].length)];
      if (shaded[j]) {
        shaded[j] = false;
      } else if (_canShade(nb, shaded, j)) {
        shaded[j] = true;
      }
    case 2:
      if (room.area < 2) return;
      final ChambersRoom a, b;
      if (room.w > 1 && (room.h == 1 || rng.nextBool())) {
        final cut = 1 + rng.nextInt(room.w - 1);
        a = ChambersRoom(room.r, room.c, room.h, cut);
        b = ChambersRoom(room.r, room.c + cut, room.h, room.w - cut);
      } else {
        final cut = 1 + rng.nextInt(room.h - 1);
        a = ChambersRoom(room.r, room.c, cut, room.w);
        b = ChambersRoom(room.r + cut, room.c, room.h - cut, room.w);
      }
      rooms
        ..[k] = a
        ..add(b);
    default:
      final mates = <int>[];
      for (var m = 0; m < rooms.length; m++) {
        final o = rooms[m];
        if (m == k) continue;
        final side = o.r == room.r && o.h == room.h && (o.c + o.w == room.c || room.c + room.w == o.c);
        final stack = o.c == room.c && o.w == room.w && (o.r + o.h == room.r || room.r + room.h == o.r);
        if ((side && room.w + o.w <= maxSide) || (stack && room.h + o.h <= maxSide)) mates.add(m);
      }
      if (mates.isEmpty) return;
      final m = mates[rng.nextInt(mates.length)];
      final o = rooms[m];
      rooms[k] = ChambersRoom(
        min(room.r, o.r),
        min(room.c, o.c),
        o.c == room.c ? room.h + o.h : room.h,
        o.r == room.r && o.h == room.h && o.c != room.c ? room.w + o.w : room.w,
      );
      rooms.removeAt(m);
  }
  _breakRuns(n, rooms, shaded, nb, rng);
}
