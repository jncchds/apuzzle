import 'dart:math';

import 'package:apuzzle/puzzles/nonogram/nonogram_solver.dart';
import 'package:flutter_test/flutter_test.dart';

/// Every line of [n] cells over [colors] colours.
Iterable<List<int>> _allLines(int n, int colors) sync* {
  final total = pow(colors + 1, n).toInt();
  for (var k = 0; k < total; k++) {
    var x = k;
    yield [
      for (var i = 0; i < n; i++)
        () {
          final v = x % (colors + 1);
          x ~/= colors + 1;
          return v;
        }(),
    ];
  }
}

void main() {
  test('line logic matches brute force (mono and colour)', () {
    final rnd = Random(7);
    for (final colors in [1, 2, 3]) {
      final n = colors == 1 ? 9 : 6;
      final lines = _allLines(n, colors).toList();
      for (var t = 0; t < 300; t++) {
        final truth = lines[rnd.nextInt(lines.length)];
        final clue = lineClue(truth);
        // Random partial knowledge consistent with the truth.
        final cells = [
          for (final v in truth) rnd.nextInt(3) == 0 ? 1 << v : ((1 << (colors + 1)) - 1) & (rnd.nextInt(1 << (colors + 1)) | (1 << v)),
        ];
        final expected = List<int>.filled(n, 0);
        for (final l in lines) {
          var ok = true;
          for (var i = 0; i < n && ok; i++) {
            ok = (cells[i] >> l[i]) & 1 != 0;
          }
          if (!ok || !_sameClue(lineClue(l), clue)) continue;
          for (var i = 0; i < n; i++) {
            expected[i] |= 1 << l[i];
          }
        }
        expect(solveLine(clue, cells), expected, reason: 'clue $clue cells $cells');
      }
    }
  });

  test('a solved picture is the picture, and unique', () {
    final rnd = Random(3);
    var solved = 0;
    for (var t = 0; t < 60; t++) {
      final colors = 1 + t % 3;
      const w = 8, h = 9;
      final pic = [for (var i = 0; i < w * h; i++) rnd.nextInt(3) == 0 ? 0 : 1 + rnd.nextInt(colors)];
      final s = NonogramSolver.forPicture(w, h, colors, pic);
      final res = s.solve();
      if (!res.solved) continue;
      solved++;
      expect(NonogramSolver.valuesOf(res.cells), pic);
      expect(s.countSolutions(), 1);
    }
    expect(solved, greaterThan(10));
  });

  test('ambiguous picture is not solved and has two solutions', () {
    // A 2×2 checkerboard: the classic ambiguity.
    final s = NonogramSolver.forPicture(2, 2, 1, [1, 0, 0, 1]);
    expect(s.solve().solved, isFalse);
    expect(s.countSolutions(), 2);
  });
}

bool _sameClue(List<NonoBlock> a, List<NonoBlock> b) => a.length == b.length && [for (var i = 0; i < a.length; i++) a[i] == b[i]].every((x) => x);
