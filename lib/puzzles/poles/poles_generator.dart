import 'dart:math';

import '../../core/difficulty.dart';
import '../domino/domino_generator.dart';
import 'poles_model.dart';
import 'poles_solver.dart';

/// Whether domino ([a], [b]) may hold [va] and [vb] next to the values
/// already placed (-1 none): like ends never touch side by side.
bool _fits(int rows, int cols, List<int> values, int a, int va, int b, int vb) {
  bool ok(int i, int v) {
    if (v == poleBlank) return true;
    final r = i ~/ cols, c = i % cols;
    for (final j in [if (r > 0) i - cols, if (c + 1 < cols) i + 1, if (r + 1 < rows) i + cols, if (c > 0) i - 1]) {
      if (j != a && j != b && values[j] == v) return false;
    }
    return true;
  }

  return ok(a, va) && ok(b, vb);
}

/// Gives domino ([a], [b]) a random state that fits its neighbours: blank
/// with chance [blank], else charged one way or the other where that fits.
void _charge(int rows, int cols, List<int> values, int a, int b, double blank, Random rng) {
  values[a] = values[b] = -1;
  if (rng.nextDouble() >= blank) {
    final ways = [(polePlus, poleMinus), (poleMinus, polePlus)]..shuffle(rng);
    for (final (va, vb) in ways) {
      if (_fits(rows, cols, values, a, va, b, vb)) {
        values[a] = va;
        values[b] = vb;
        return;
      }
    }
  }
  values[a] = values[b] = poleBlank;
}

/// A random tiling with random charges, then a local search: where the
/// difficulty's tier gets stuck, a domino there gets another charge or turns
/// with a parallel neighbour, kept when the logic gets no further behind.
/// Medium and hard then push the tier below to stall the same way, and hard
/// hides some counts. Cells still open at the end are shown from the start.
PolesPuzzle generatePoles(GenParams params) {
  final rows = params.size.rows, cols = params.size.cols, n = rows * cols;
  final rng = Random(params.seed);
  final tier = polesTier(params.difficulty);
  PolesPuzzle? fallback;
  var fallbackGrade = 0;

  for (var attempt = 0; attempt < 24; attempt++) {
    final mate = randomTiling(rows, cols, rng);
    final values = List.filled(n, -1);
    final blank = 0.25 + rng.nextDouble() * 0.15;
    for (var i = 0; i < n; i++) {
      if (mate[i] > i) _charge(rows, cols, values, i, mate[i], blank, rng);
    }
    final hidden = <int>{}; // line * 2 + sign
    final givens = <int>[];

    PolesPuzzle board() {
      final (p, m) = polesCounts(rows, cols, values);
      return PolesPuzzle(
        rows: rows,
        cols: cols,
        mate: List.of(mate),
        solution: List.of(values),
        plus: [for (var li = 0; li < p.length; li++) hidden.contains(li * 2) ? null : p[li]],
        minus: [for (var li = 0; li < m.length; li++) hidden.contains(li * 2 + 1) ? null : m[li]],
        givens: List.of(givens)..sort(),
      );
    }

    List<int> stuck(int t) {
      final p = board(), s = PolesSolver.of(p), st = polesStart(s, p);
      s.solve(st, t);
      final v = polesValues(st);
      return [
        for (var i = 0; i < n; i++)
          if (v[i] < 0) i,
      ];
    }

    // Changes the domino of cell [i]; returns the undo.
    void Function() mutate(int i) {
      final keepMate = List.of(mate), keepValues = List.of(values);
      void undo() {
        mate.setAll(0, keepMate);
        values.setAll(0, keepValues);
      }

      final j = mate[i];
      // A parallel neighbour forming a 2×2 square: turn the pair.
      if (rng.nextInt(3) == 0) {
        final across = (j - i).abs() == 1;
        final step = across ? cols : 1;
        final options = [
          for (final d in [step, -step])
            if (_inside(rows, cols, i, d) && _inside(rows, cols, j, d) && mate[i + d] == j + d) d,
        ];
        if (options.isNotEmpty) {
          final d = options[rng.nextInt(options.length)];
          final a = i, b = j, c = i + d, e = j + d;
          for (final x in [a, b, c, e]) {
            values[x] = -1;
          }
          mate[a] = c;
          mate[c] = a;
          mate[b] = e;
          mate[e] = b;
          _charge(rows, cols, values, a, c, 0.3, rng);
          _charge(rows, cols, values, b, e, 0.3, rng);
          return undo;
        }
      }
      final before = (values[i], values[j]);
      for (var k = 0; k < 4 && (values[i], values[j]) == before; k++) {
        _charge(rows, cols, values, i, j, 0.34, rng);
      }
      return undo;
    }

    // Hard boards get their probing from hidden counts: search for tier 2.
    final search = min(tier, 2);
    var open = stuck(search);
    for (var step = 0; step < n * 3 && open.isNotEmpty; step++) {
      final undo = mutate(open[rng.nextInt(open.length)]);
      final next = stuck(search);
      if (next.length <= open.length) {
        open = next;
      } else {
        undo();
      }
    }
    if (open.length > n ~/ 8 && attempt < 6) continue;

    // Medium: make the tier below get stuck, keeping the tier itself happy.
    if (tier == 2 && open.isEmpty) {
      var below = stuck(tier - 1).length;
      for (var step = 0; step < n * 2 && below < max(4, n ~/ 5); step++) {
        final undo = mutate(rng.nextInt(n));
        final b = stuck(tier - 1).length;
        if (b >= below && stuck(tier).isEmpty) {
          below = b;
        } else {
          undo();
        }
      }
    }

    while (true) {
      final left = stuck(tier);
      if (left.isEmpty) break;
      givens.add(left[rng.nextInt(left.length)]);
    }
    for (final g in List.of(givens)..shuffle(rng)) {
      givens.remove(g);
      if (stuck(tier).isNotEmpty) givens.add(g);
    }
    if (params.difficulty == Difficulty.hard) {
      final hideMax = (rows + cols) ~/ 2;
      for (final k in [for (var k = 0; k < (rows + cols) * 2; k++) k]..shuffle(rng)) {
        if (hidden.length >= hideMax) break;
        hidden.add(k);
        if (stuck(tier).isNotEmpty) hidden.remove(k);
      }
    }
    final puzzle = board();
    if (tier > 1) {
      final s = PolesSolver.of(puzzle);
      final grade = s.grade(polesStart(s, puzzle));
      if (grade < tier) {
        if (grade > fallbackGrade || fallback == null) (fallback, fallbackGrade) = (puzzle, grade);
        continue;
      }
    }
    return puzzle;
  }
  return fallback ?? generatePoles(params.withSeed(params.seed + 1));
}

bool _inside(int rows, int cols, int i, int d) {
  final j = i + d;
  if (j < 0 || j >= rows * cols) return false;
  return d.abs() == cols || j ~/ cols == i ~/ cols;
}
