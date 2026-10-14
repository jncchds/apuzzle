import 'package:apuzzle/core/difficulty.dart';
import 'package:apuzzle/core/grid.dart';
import 'package:apuzzle/puzzles/inlay/inlay_generator.dart';
import 'package:apuzzle/puzzles/inlay/inlay_model.dart';
import 'package:apuzzle/puzzles/inlay/inlay_solver.dart';
import 'package:apuzzle/puzzles/inlay/inlay_tutorial.dart';
import 'package:apuzzle/puzzles/inlay/inlay_type.dart';
import 'package:flutter_test/flutter_test.dart';

InlayState _solutionState(InlayPuzzle p) =>
    InlayState([for (final (o, _) in p.solution) o], [for (final (_, at) in p.solution) at]);

InlayState _playHints(InlayType type, InlayPuzzle p, InlayState s) {
  for (var k = 0; k < 200 && !type.isSolved(p, s); k++) {
    s = type.hint(p, s)!.state;
  }
  return s;
}

void main() {
  const type = InlayType();

  test('turning four times or flipping twice gives the piece back', () {
    const l = [(0, 0), (1, 0), (2, 0), (2, 1)];
    for (var o = 0; o < 8; o++) {
      var t = o;
      for (var k = 0; k < 4; k++) {
        t = turnOrientation(t);
      }
      expect(t, o);
      expect(flipOrientation(flipOrientation(o)), o);
      // A turn shows the cells turned a quarter clockwise.
      expect(cellsKey(orientCells(l, turnOrientation(o))), cellsKey(orientCells(orientCells(l, o), 1)));
      // A flip shows them mirrored left to right.
      expect(cellsKey(orientCells(l, flipOrientation(o))), cellsKey(orientCells(orientCells(l, o), 4)));
    }
    expect(cellsKey(orientCells(l, 1)), cellsKey([(0, 0), (0, 1), (0, 2), (1, 0)]));
  });

  test('covers are counted once for equal pieces swapping places', () {
    // Two dominoes on a 2 × 2 square: both across or both down.
    final p = inlayBoard(['AB', 'AB']);
    expect(InlaySolver(p).count(limit: 10), 2);
    // An L and a bar: the L lies in one of 2 ways, and the bar fills the rest.
    final q = inlayBoard(['AAB', 'ACB', 'CCB']);
    expect(InlaySolver(q).count(limit: 100), greaterThanOrEqualTo(1));
  });

  for (final size in type.sizes) {
    for (final d in type.difficulties) {
      test('inlay ${size.label} ${d.name}: pieces cover the shape, solvable, deterministic, fast', () {
        final shape = inlayShape(size.rows, size.cols, d);
        final lo = shape.weights.indexWhere((w) => w > 0) + 2, hi = shape.weights.length + 1;
        for (var seed = 1; seed <= 4; seed++) {
          final params = GenParams(size: size, difficulty: d, seed: seed);
          final sw = Stopwatch()..start();
          final p = type.generate(params);
          expect(sw.elapsedMilliseconds, lessThan(1500));
          expect(p.rows, size.rows);
          expect(p.cols, size.cols);
          expect(p.flip, d == Difficulty.hard);
          // The pieces add up to the shape, which reaches every side.
          expect(p.pieces.fold(0, (a, piece) => a + piece.length), p.area);
          for (final piece in p.pieces) {
            expect(piece.length, inInclusiveRange(lo, hi));
          }
          for (var r = 0; r < p.rows; r++) {
            expect(List.generate(p.cols, (c) => p.shape[r * p.cols + c]), contains(true));
          }
          for (var c = 0; c < p.cols; c++) {
            expect(List.generate(p.rows, (r) => p.shape[r * p.cols + c]), contains(true));
          }
          expect(type.isSolved(p, _solutionState(p)), isTrue);
          if (d == Difficulty.easy) expect(p.solution.every((s) => s.$1 == 0), isTrue);
          // The solver finds a cover on its own.
          final cover = InlaySolver(p).complete(List.filled(p.pieces.length, null));
          expect(cover, isNotNull);
          final s = InlayState([for (final (o, _) in cover!) o], [for (final (_, at) in cover) at]);
          expect(type.isSolved(p, s), isTrue);
          expect(type.isSolved(p, type.initialState(p)), isFalse);
          expect(type.generate(params).toJson(), p.toJson());
          expect(type.decodePuzzle(type.encodePuzzle(p)).toJson(), p.toJson());
          final st = type.decodeState(type.encodeState(s));
          expect(st.orient, s.orient);
          expect(st.at, s.at);
        }
      });
    }
  }

  test('medium and hard boards mostly have one cover', () {
    for (final d in [Difficulty.medium, Difficulty.hard]) {
      var one = 0;
      for (var seed = 1; seed <= 8; seed++) {
        final p = type.generate(GenParams(size: const GridSize.square(6), difficulty: d, seed: seed));
        if (InlaySolver(p).count(limit: 2, cap: 2000000) == 1) one++;
      }
      expect(one, greaterThanOrEqualTo(d == Difficulty.hard ? 6 : 2), reason: d.name);
    }
  });

  test('hints finish the board from the start and from pieces laid wrong', () {
    for (final d in Difficulty.values.take(3)) {
      final p = type.generate(GenParams(size: const GridSize.square(7), difficulty: d, seed: 5));
      expect(type.isSolved(p, _playHints(type, p, type.initialState(p))), isTrue);

      // Every piece laid somewhere it fits, scanning in reading order.
      var s = type.initialState(p);
      for (var k = 0; k < p.pieces.length; k++) {
        for (var i = p.cells - 1; i >= 0; i--) {
          if (inlayFits(p, s, k, 0, i ~/ p.cols, i % p.cols)) {
            s = s.withPiece(k, at: i);
            break;
          }
        }
      }
      expect(type.isSolved(p, _playHints(type, p, s)), isTrue, reason: d.name);
    }
  });

  test('a hint first takes back a piece that leaves no room', () {
    final step = inlayTutorial[2];
    final p = step.puzzle as InlayPuzzle;
    final s = step.state! as InlayState;
    expect(InlaySolver(p).complete([(0, 8), null, null]), isNull);
    final h = type.hint(p, s)!;
    expect(h.state.placed(0), isFalse);
    expect(type.isSolved(p, _playHints(type, p, s)), isTrue);
  });

  test('tutorial boards need what they teach', () {
    // Step 2: the pieces don't fit as they are shown.
    final turn = inlayTutorial[1].puzzle as InlayPuzzle;
    expect([for (final (o, _) in turn.solution) o].any((o) => o != 0), isTrue);
    // Step 4: without flipping there is no cover.
    final flip = inlayTutorial[3].puzzle as InlayPuzzle;
    final noFlip = InlayPuzzle(
      rows: flip.rows,
      cols: flip.cols,
      shape: flip.shape,
      pieces: flip.pieces,
      flip: false,
      solution: flip.solution,
    );
    expect(InlaySolver(flip).count(), greaterThanOrEqualTo(1));
    expect(InlaySolver(noFlip).count(), 0);
    // Strategy 1: one cover, and the arm's tip takes one piece.
    final arm = inlayStrategies[0].puzzle as InlayPuzzle;
    expect(InlaySolver(arm).count(limit: 5), 1);
  });
}
