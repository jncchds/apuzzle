import 'dart:math';

import '../../core/grid.dart';

enum MergeDir { up, down, left, right }

/// What counts as a win.
enum MergeGoal {
  /// Build a tile of [MergePuzzle.target].
  target('target'),

  /// No target: play until the board locks up and chase a best score.
  free('free');

  const MergeGoal(this.id);
  final String id;

  static MergeGoal byId(String? id) => values.firstWhere((g) => g.id == id, orElse: () => target);
}

class MergePuzzle {
  const MergePuzzle({
    required this.rows,
    required this.cols,
    required this.goal,
    required this.target,
    required this.seed,
    required this.start,
  });

  final int rows;
  final int cols;
  final MergeGoal goal;

  /// Tile to build ([MergeGoal.target]), else 0.
  final int target;

  /// Drives the new tiles, so a share code replays the same game.
  final int seed;

  /// Tile values per cell (row-major), 0 when empty.
  final List<int> start;

  GridSize get size => GridSize(rows, cols);

  Map<String, dynamic> toJson() => {'rows': rows, 'cols': cols, 'goal': goal.id, 'target': target, 'seed': seed, 'start': start};

  factory MergePuzzle.fromJson(Map<String, dynamic> j) => MergePuzzle(
        rows: j['rows'] as int,
        cols: j['cols'] as int,
        goal: MergeGoal.byId(j['goal'] as String?),
        target: j['target'] as int,
        seed: j['seed'] as int,
        start: (j['start'] as List).cast<int>(),
      );
}

class MergeState {
  const MergeState({
    required this.cells,
    required this.ids,
    required this.score,
    required this.moves,
    required this.nextId,
    this.merged = const [],
  });

  factory MergeState.initial(MergePuzzle p) {
    var next = 0;
    return MergeState(
      cells: p.start,
      ids: [for (final v in p.start) v > 0 ? next++ : -1],
      score: 0,
      moves: 0,
      nextId: next,
    );
  }

  /// Tile values per cell, 0 when empty.
  final List<int> cells;

  /// Stable tile ids per cell (for animation), -1 when empty.
  final List<int> ids;
  final int score;
  final int moves;
  final int nextId;

  /// Tiles swallowed by the last move, as (id, cell they merged into). Only
  /// for the board's slide-in animation.
  final List<(int, int)> merged;

  int get best => cells.fold(0, max);

  Map<String, dynamic> toJson() => {'cells': cells, 'ids': ids, 'score': score, 'moves': moves, 'next': nextId};

  factory MergeState.fromJson(Map<String, dynamic> j) => MergeState(
        cells: (j['cells'] as List).cast<int>(),
        ids: (j['ids'] as List).cast<int>(),
        score: j['score'] as int,
        moves: j['moves'] as int,
        nextId: j['next'] as int,
      );
}

/// Cell indices of each line along [dir], leading edge first.
List<List<int>> mergeLines(int rows, int cols, MergeDir dir) => switch (dir) {
      MergeDir.left => [for (var r = 0; r < rows; r++) [for (var c = 0; c < cols; c++) r * cols + c]],
      MergeDir.right => [for (var r = 0; r < rows; r++) [for (var c = cols - 1; c >= 0; c--) r * cols + c]],
      MergeDir.up => [for (var c = 0; c < cols; c++) [for (var r = 0; r < rows; r++) r * cols + c]],
      MergeDir.down => [for (var c = 0; c < cols; c++) [for (var r = rows - 1; r >= 0; r--) r * cols + c]],
    };

/// Slides and merges [cells] toward [dir] without spawning. Returns the new
/// cells, the points gained and whether anything moved.
(List<int>, int, bool) mergeSlide(List<int> cells, int rows, int cols, MergeDir dir) {
  final out = List<int>.filled(cells.length, 0);
  var gained = 0;
  var moved = false;
  for (final line in mergeLines(rows, cols, dir)) {
    var k = 0;
    var open = false; // out[line[k - 1]] can still take a merge
    for (final i in line) {
      final v = cells[i];
      if (v == 0) continue;
      if (open && out[line[k - 1]] == v) {
        out[line[k - 1]] = v * 2;
        gained += v * 2;
        open = false;
        moved = true;
      } else {
        out[line[k]] = v;
        if (line[k] != i) moved = true;
        k++;
        open = true;
      }
    }
  }
  return (out, gained, moved);
}

bool mergeCanMove(List<int> cells, int rows, int cols) {
  for (var i = 0; i < cells.length; i++) {
    final v = cells[i];
    if (v == 0) return true;
    if (i % cols < cols - 1 && cells[i + 1] == v) return true;
    if (i ~/ cols < rows - 1 && cells[i + cols] == v) return true;
  }
  return false;
}

/// A new tile: 2 nine times in ten, else 4, on a random empty cell. Seeded by
/// the puzzle and the move number, so replays and share codes match.
(int, int)? mergeSpawn(List<int> cells, int seed, int move) {
  final empty = [for (var i = 0; i < cells.length; i++) if (cells[i] == 0) i];
  if (empty.isEmpty) return null;
  final rng = Random((seed * 1000003 + move * 7919) & 0x7fffffff);
  return (empty[rng.nextInt(empty.length)], rng.nextInt(10) == 0 ? 4 : 2);
}

/// Plays [dir] and spawns a new tile, or returns null when nothing moves.
MergeState? mergeMove(MergePuzzle p, MergeState s, MergeDir dir) {
  final cells = List<int>.filled(s.cells.length, 0);
  final ids = List<int>.filled(s.cells.length, -1);
  final merged = <(int, int)>[];
  var gained = 0;
  var moved = false;
  for (final line in mergeLines(p.rows, p.cols, dir)) {
    var k = 0;
    var open = false;
    for (final i in line) {
      final v = s.cells[i];
      if (v == 0) continue;
      if (open && cells[line[k - 1]] == v) {
        final at = line[k - 1];
        cells[at] = v * 2;
        gained += v * 2;
        merged.add((s.ids[i], at));
        open = false;
        moved = true;
      } else {
        cells[line[k]] = v;
        ids[line[k]] = s.ids[i];
        if (line[k] != i) moved = true;
        k++;
        open = true;
      }
    }
  }
  if (!moved) return null;
  var next = s.nextId;
  if (mergeSpawn(cells, p.seed, s.moves + 1) case (final at, final v)) {
    cells[at] = v;
    ids[at] = next++;
  }
  return MergeState(cells: cells, ids: ids, score: s.score + gained, moves: s.moves + 1, nextId: next, merged: merged);
}
