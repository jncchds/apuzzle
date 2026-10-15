import 'dart:math';

import '../../core/difficulty.dart';
import '../../core/grid_graph.dart';
import 'totals_model.dart';
import 'totals_solver.dart';

/// Logic tier of a difficulty: digit sets, + every way to fill a run, +
/// probing.
int totalsTier(Difficulty d) => switch (d) {
  Difficulty.easy => 1,
  Difficulty.medium => 2,
  _ => 3,
};

/// The longest run a difficulty allows.
int _maxRun(Difficulty d) => switch (d) {
  Difficulty.easy => 4,
  Difficulty.medium => 5,
  _ => 6,
};

/// A random layout of clue cells on an n×n board, symmetric under a half
/// turn of the part right of and below the top row and left column (which
/// are all clue cells): clue cells go in one pair at a time, kept while
/// every run stays at least 2 cells long and the white cells stay joined,
/// until no run is longer than [maxRun] and enough are in. Null if this try
/// got stuck.
List<bool>? _layout(int n, int maxRun, Random rng) {
  final block = List.generate(n * n, (i) => i < n || i % n == 0);
  final nb = orthNeighbors(n, n);
  int twin(int i) => (n - i ~/ n) * n + (n - i % n);

  // The length of the run through white cell [i] along [step] (1 across, n down).
  int length(int i, int step) {
    var k = 1;
    for (var j = i - step; !block[j]; j -= step) {
      k++;
    }
    for (var j = i + step; j < n * n && !block[j] && (step == n || j % n != 0); j += step) {
      k++;
    }
    return k;
  }

  bool valid() {
    for (var i = 0; i < n * n; i++) {
      if (!block[i] && (length(i, 1) == 1 || length(i, n) == 1)) return false;
    }
    return components(nb, (i) => !block[i]).length == 1;
  }

  final inner = (n - 1) * (n - 1);
  final target = (inner * (0.18 + rng.nextDouble() * 0.08)).round();
  var blocks = 0;
  for (var tries = 0; tries < inner * 30; tries++) {
    final long = [
      for (var i = 0; i < n * n; i++)
        if (!block[i] && (length(i, 1) > maxRun || length(i, n) > maxRun)) i,
    ];
    if (long.isEmpty && blocks >= target) return block;
    final i = long.isNotEmpty && rng.nextInt(4) > 0
        ? long[rng.nextInt(long.length)]
        : (1 + rng.nextInt(n - 1)) * n + 1 + rng.nextInt(n - 1);
    if (block[i]) continue;
    block[i] = block[twin(i)] = true;
    if (valid()) {
      blocks += i == twin(i) ? 1 : 2;
    } else {
      block[i] = block[twin(i)] = false;
    }
  }
  return null;
}

/// Random digits for the white cells, no digit twice in a run.
List<int>? _fill(TotalsPuzzle shape, Random rng) {
  final digits = List.of(shape.digits);
  final white = [
    for (var i = 0; i < digits.length; i++)
      if (digits[i] >= 0) i,
  ];
  var steps = 0;
  bool go(int k) {
    if (k == white.length) return true;
    if (++steps > 20000) return false;
    final i = white[k];
    var used = 0;
    for (final x in [shape.acrossOf[i], shape.downOf[i]]) {
      for (final j in shape.runs[x].cells) {
        if (j != i && digits[j] >= 0 && digits[j] < 9) used |= 1 << digits[j];
      }
    }
    for (final d in [for (var d = 0; d < 9; d++) d]..shuffle(rng)) {
      if (used & (1 << d) != 0) continue;
      digits[i] = d;
      if (go(k + 1)) return true;
    }
    digits[i] = 9;
    return false;
  }

  for (final i in white) {
    digits[i] = 9;
  }
  return go(0) ? digits : null;
}

/// A random layout and digits, then a local search: where the tier gets
/// stuck, a stuck cell gets another digit (one its runs don't hold yet),
/// kept when the logic gets no further behind. Medium and hard then push
/// the tier below to stall the same way. Cells still open at the end are
/// shown from the start.
TotalsPuzzle generateTotals(GenParams params) {
  final n = params.size.rows;
  final rng = Random(params.seed);
  final tier = totalsTier(params.difficulty);
  final maxRun = min(_maxRun(params.difficulty), n - 2);
  TotalsPuzzle? fallback;
  var fallbackGrade = 0;

  for (var attempt = 0, tries = 0; attempt < 40 && tries < 400; tries++) {
    final layout = _layout(n, maxRun, rng);
    if (layout == null) continue;
    final shape = TotalsPuzzle(rows: n, cols: n, digits: [for (final b in layout) b ? -1 : 9]);
    final filled = _fill(shape, rng);
    if (filled == null) continue;
    attempt++;
    final digits = filled;
    TotalsPuzzle board() => TotalsPuzzle(rows: n, cols: n, digits: List.of(digits));
    List<int> stuck(int t) {
      final s = TotalsSolver(board());
      final c = s.start();
      s.solve(c, t);
      return [
        for (var i = 0; i < c.length; i++)
          if (!shape.isBlock(i) && c[i] & (c[i] - 1) != 0) i,
      ];
    }

    // Gives cell [i] another digit its runs don't hold; returns the undo.
    void Function()? mutate(int i) {
      var used = 0;
      for (final x in [shape.acrossOf[i], shape.downOf[i]]) {
        for (final j in shape.runs[x].cells) {
          used |= 1 << digits[j];
        }
      }
      final free = totalsDigits(totalsFull & ~used);
      if (free.isEmpty) return null;
      final d = digits[i];
      digits[i] = free[rng.nextInt(free.length)];
      return () => digits[i] = d;
    }

    final white = [
      for (var i = 0; i < n * n; i++)
        if (!shape.isBlock(i)) i,
    ];
    // Probing is slow: hard boards first get as far as they can without.
    var open = <int>[];
    for (final t in {min(tier, 2), tier}) {
      if (t == 3 && open.length > white.length ~/ 5) break;
      open = stuck(t);
      for (var step = 0; step < white.length * 4 && open.isNotEmpty; step++) {
        // A stuck cell, or another cell of one of its runs.
        var i = open[rng.nextInt(open.length)];
        if (rng.nextBool()) {
          final run = shape.runs[rng.nextBool() ? shape.acrossOf[i] : shape.downOf[i]].cells;
          i = run[rng.nextInt(run.length)];
        }
        final undo = mutate(i);
        if (undo == null) continue;
        final next = stuck(t);
        if (next.length <= open.length) {
          open = next;
        } else {
          undo();
        }
      }
    }
    if (open.isNotEmpty && attempt <= 20) continue;

    if (tier > 1 && open.isEmpty) {
      var below = stuck(tier - 1).length;
      for (var step = 0; step < white.length * 2 && below < max(3, white.length ~/ 6); step++) {
        final undo = mutate(white[rng.nextInt(white.length)]);
        if (undo == null) continue;
        final b = stuck(tier - 1).length;
        if (b >= below && stuck(tier).isEmpty) {
          below = b;
        } else {
          undo();
        }
      }
    }

    final givens = <int>[];
    while (true) {
      final s = TotalsSolver(board());
      final c = s.start(givens);
      s.solve(c, tier);
      final left = [
        for (final i in white)
          if (c[i] & (c[i] - 1) != 0) i,
      ];
      if (left.isEmpty) break;
      givens.add(left[rng.nextInt(left.length)]);
    }
    final puzzle = TotalsPuzzle(rows: n, cols: n, digits: digits, givens: givens..sort());
    if (tier > 1) {
      final s = TotalsSolver(puzzle);
      final grade = s.grade(s.start());
      if (grade < tier) {
        if (grade > fallbackGrade) (fallback, fallbackGrade) = (puzzle, grade);
        continue;
      }
    }
    return puzzle;
  }
  return fallback ?? generateTotals(params.withSeed(params.seed + 1));
}
