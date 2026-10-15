import 'dart:math';

import '../../core/difficulty.dart';
import '../../core/grid_graph.dart';
import 'mercury_model.dart';
import 'mercury_solver.dart';

/// The longest tube the generator lays.
const int _maxLen = 7;

/// Tubes covering the grid, each 2 to [_maxLen] cells long, straight or bent:
/// each starts at a free cell with the fewest free neighbours and walks on,
/// mostly straight. A cell left alone joins the end of a neighbouring tube,
/// or splits one where it runs past. Bulbs go at random ends.
List<List<int>> randomTubes(int rows, int cols, Random rng) {
  final n = rows * cols, on = orthNeighbors(rows, cols);
  for (var attempt = 0; ; attempt++) {
    final tubeOf = List.filled(n, -1);
    final tubes = <List<int>>[];
    int free(int i) => on[i].where((j) => tubeOf[j] < 0).length;
    while (true) {
      final open = [
        for (var i = 0; i < n; i++)
          if (tubeOf[i] < 0) i,
      ];
      if (open.isEmpty) break;
      final least = open.map(free).reduce(min);
      final starts = open.where((i) => free(i) == least).toList();
      final path = [starts[rng.nextInt(starts.length)]];
      tubeOf[path.first] = tubes.length;
      final target = 2 + rng.nextInt(min(_maxLen, max(rows, cols)) - 1);
      while (path.length < target) {
        final cur = path.last;
        final next = [
          for (final j in on[cur])
            if (tubeOf[j] < 0) j,
        ];
        if (next.isEmpty) break;
        final straight = path.length > 1 ? next.where((j) => j - cur == cur - path[path.length - 2]).firstOrNull : null;
        final j = straight != null && rng.nextDouble() < 0.6 ? straight : next[rng.nextInt(next.length)];
        tubeOf[j] = tubes.length;
        path.add(j);
      }
      tubes.add(path);
    }
    // Cells left alone join a neighbouring tube.
    var alone = false;
    for (var t = 0; t < tubes.length; t++) {
      if (tubes[t].length != 1) continue;
      final i = tubes[t].first;
      final ends = [
        for (final j in on[i])
          if (tubes[tubeOf[j]].length < _maxLen && (tubes[tubeOf[j]].first == j || tubes[tubeOf[j]].last == j)) j,
      ];
      if (ends.isNotEmpty) {
        final j = ends[rng.nextInt(ends.length)], u = tubes[tubeOf[j]];
        if (u.last == j) {
          u.add(i);
        } else {
          u.insert(0, i);
        }
        tubeOf[i] = tubeOf[j];
        tubes[t] = [];
        continue;
      }
      // Split a tube running past, if both pieces keep two cells.
      final cuts = [
        for (final j in on[i])
          if (tubes[tubeOf[j]].indexOf(j) case final k when k >= 1 && k <= tubes[tubeOf[j]].length - 3) j,
      ];
      if (cuts.isEmpty) {
        alone = true;
        continue;
      }
      final j = cuts[rng.nextInt(cuts.length)], u = tubeOf[j], k = tubes[u].indexOf(j);
      final rest = tubes[u].sublist(k + 1);
      tubes[u] = [...tubes[u].sublist(0, k + 1), i];
      tubeOf[i] = u;
      tubes[t] = rest;
      for (final c in rest) {
        tubeOf[c] = t;
      }
    }
    if (alone && attempt < 50) continue;
    return [
      for (final t in tubes)
        if (t.isNotEmpty) rng.nextBool() ? t : t.reversed.toList(),
    ];
  }
}

/// Random tubes at random levels, then a local search: where the
/// difficulty's tier (at most 2) gets stuck, a stuck cell's tube gets a new
/// level, turns round, splits or joins a neighbour, kept when the logic gets
/// no further behind. Cells still open are shown from the start. Medium and
/// hard then hide counts while their tier still solves the board, and keep it
/// only if the tier below no longer does.
MercuryPuzzle generateMercury(GenParams params) {
  final rows = params.size.rows, cols = params.size.cols, n = rows * cols;
  final rng = Random(params.seed);
  final tier = mercuryTier(params.difficulty);
  final searchTier = min(tier, 2);
  final on = orthNeighbors(rows, cols);
  MercuryPuzzle? fallback;
  var fallbackGrade = 0;

  for (var attempt = 0; attempt < (tier > 1 ? 300 : 16); attempt++) {
    final tubes = randomTubes(rows, cols, rng);
    final levels = [for (final t in tubes) rng.nextInt(t.length + 1)];
    final tubeOf = List.filled(n, 0);
    void reindex() {
      for (var t = 0; t < tubes.length; t++) {
        for (final i in tubes[t]) {
          tubeOf[i] = t;
        }
      }
    }

    reindex();
    List<int?> counts() => <int?>[...mercuryCounts(rows, cols, tubes, levels)];
    var shown = counts();
    MercuryPuzzle board([List<int> givens = const []]) => MercuryPuzzle(
      rows: rows,
      cols: cols,
      tubes: [for (final t in tubes) List.of(t)],
      levels: List.of(levels),
      rowCounts: shown.sublist(0, rows),
      colCounts: shown.sublist(rows),
      givens: givens,
    );
    List<int> stuck(int t) {
      final s = MercurySolver.of(board()), st = s.start();
      s.solve(st, t);
      return [
        for (var i = 0; i < n; i++)
          if (st[i] == -1) i,
      ];
    }

    // Changes around cell [i]; returns the undo.
    void Function() mutate(int i) {
      final oldTubes = [for (final t in tubes) List.of(t)], oldLevels = List.of(levels);
      final t = tubeOf[i], tube = tubes[t];
      int newLevel(int len, int old) {
        final l = rng.nextInt(len);
        return l >= old ? l + 1 : l;
      }

      switch (rng.nextInt(4)) {
        case 1:
          tubes[t] = tube.reversed.toList();
          levels[t] = rng.nextInt(tube.length + 1);
        case 2 when tube.length >= 4:
          final k = 2 + rng.nextInt(tube.length - 3);
          tubes[t] = tube.sublist(0, k);
          tubes.add(tube.sublist(k));
          levels[t] = rng.nextInt(k + 1);
          levels.add(rng.nextInt(tube.length - k + 1));
        case 3:
          // Join a tube whose end touches an end of this one.
          final joins = <(int, List<int>)>[];
          for (final end in {tube.first, tube.last}) {
            for (final j in on[end]) {
              final u = tubeOf[j], other = tubes[u];
              if (u == t || tube.length + other.length > _maxLen) continue;
              if (other.first != j && other.last != j) continue;
              final a = end == tube.last ? tube : tube.reversed.toList();
              final b = other.first == j ? other : other.reversed.toList();
              joins.add((u, rng.nextBool() ? [...a, ...b] : [...a, ...b].reversed.toList()));
            }
          }
          if (joins.isEmpty) {
            levels[t] = newLevel(tube.length, levels[t]);
            break;
          }
          final (u, joined) = joins[rng.nextInt(joins.length)];
          tubes[t] = joined;
          levels[t] = rng.nextInt(joined.length + 1);
          tubes.removeAt(u);
          levels.removeAt(u);
        default:
          levels[t] = newLevel(tube.length, levels[t]);
      }
      reindex();
      shown = counts();
      return () {
        tubes
          ..clear()
          ..addAll(oldTubes);
        levels
          ..clear()
          ..addAll(oldLevels);
        reindex();
        shown = counts();
      };
    }

    var open = stuck(searchTier);
    for (var step = 0; step < n * 3 && open.isNotEmpty; step++) {
      final undo = mutate(open[rng.nextInt(open.length)]);
      final next = stuck(searchTier);
      if (next.length <= open.length) {
        open = next;
      } else {
        undo();
      }
    }
    if (open.length > n ~/ 10 && attempt < 8) continue;

    bool solvable(List<int> givens) {
      final p = board(givens), s = MercurySolver.of(p), st = mercuryStart(s, p);
      return s.solve(st, tier);
    }

    final givens = <int>[];
    while (true) {
      final p = board(givens), s = MercurySolver.of(p), st = mercuryStart(s, p);
      s.solve(st, tier);
      final left = [
        for (var i = 0; i < n; i++)
          if (st[i] == -1) i,
      ];
      if (left.isEmpty) break;
      final full = left.where(p.full).toList();
      final pool = full.isNotEmpty && rng.nextBool() ? full : left;
      givens.add(pool[rng.nextInt(pool.length)]);
    }
    for (final g in List.of(givens)..shuffle(rng)) {
      givens.remove(g);
      if (!solvable(givens)) givens.add(g);
    }
    if (tier > 1) {
      final hideMax = (rows + cols) ~/ 3;
      var hidden = 0;
      for (final k in [for (var k = 0; k < rows + cols; k++) k]..shuffle(rng)) {
        if (hidden >= hideMax) break;
        final keep = shown[k];
        shown[k] = null;
        if (solvable(givens)) {
          hidden++;
        } else {
          shown[k] = keep;
        }
      }
    }
    final puzzle = board(givens..sort());
    if (tier > 1) {
      final s = MercurySolver.of(puzzle);
      final grade = s.grade(mercuryStart(s, puzzle));
      if (grade < tier) {
        if (grade > fallbackGrade) (fallback, fallbackGrade) = (puzzle, grade);
        continue;
      }
    }
    return puzzle;
  }
  return fallback ?? generateMercury(params.withSeed(params.seed + 1));
}
