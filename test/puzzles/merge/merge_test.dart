import 'package:apuzzle/core/difficulty.dart';
import 'package:apuzzle/core/grid.dart';
import 'package:apuzzle/core/puzzle_code.dart';
import 'package:apuzzle/core/registry.dart';
import 'package:apuzzle/puzzles/merge/merge_generator.dart';
import 'package:apuzzle/puzzles/merge/merge_model.dart';
import 'package:apuzzle/puzzles/merge/merge_type.dart';
import 'package:flutter_test/flutter_test.dart';

MergePuzzle _puzzle(List<int> start, int rows, int cols, {int target = 2048}) =>
    MergePuzzle(rows: rows, cols: cols, goal: MergeGoal.target, target: target, seed: 1, start: start);

void main() {
  const type = MergeType();

  test('slide merges each pair once, leading edge first', () {
    final (row, gained, moved) = mergeSlide([2, 2, 2, 2, 4, 0, 4, 8, 2, 2, 4, 0, 0, 0, 0, 2], 4, 4, MergeDir.left);
    expect(row, [4, 4, 0, 0, 8, 8, 0, 0, 4, 4, 0, 0, 2, 0, 0, 0]);
    expect(gained, 4 + 4 + 8 + 4);
    expect(moved, isTrue);
    expect(mergeSlide([2, 4, 8, 2], 1, 4, MergeDir.left).$3, isFalse);
    expect(mergeSlide([2, 2, 2, 0], 1, 4, MergeDir.right).$1, [0, 0, 2, 4]);
    expect(mergeSlide([2, 0, 2, 0], 4, 1, MergeDir.up).$1, [4, 0, 0, 0]);
  });

  test('a move keeps ids, records the swallowed tile and spawns one tile', () {
    final p = _puzzle([2, 2, 0, 0], 2, 2);
    final s0 = MergeState.initial(p);
    final s = mergeMove(p, s0, MergeDir.left)!;
    expect(s.cells[0], 4);
    expect(s.ids[0], 0);
    expect(s.merged, [(1, 0)]);
    expect(s.score, 4);
    expect(s.cells.where((v) => v > 0).length, 2, reason: 'the merged tile plus a new one');
    expect(s.ids.where((id) => id == 2).length, 1);
  });

  test('stuck and won detection', () {
    final locked = _puzzle([2, 4, 4, 2], 2, 2);
    expect(mergeCanMove(locked.start, 2, 2), isFalse);
    expect(type.isComplete(locked, MergeState.initial(locked)), isTrue);
    expect(type.isSolved(locked, MergeState.initial(locked)), isFalse);
    final won = _puzzle([64, 0, 0, 0], 2, 2, target: 64);
    expect(type.isComplete(won, MergeState.initial(won)) && type.isSolved(won, MergeState.initial(won)), isTrue);
  });

  test('targets scale with size and difficulty', () {
    expect(mergeTarget(4, 4, Difficulty.hard), 2048);
    expect(mergeTarget(4, 4, Difficulty.easy), 512);
    expect(mergeTarget(3, 3, Difficulty.hard), 256);
    expect(mergeTarget(6, 6, Difficulty.medium), 4096);
  });

  for (final size in type.sizes) {
    test('${size.label}: two starting tiles, deterministic, same game on replay', () {
      for (var seed = 1; seed <= 5; seed++) {
        final params = GenParams(size: size, difficulty: Difficulty.medium, seed: seed);
        final p = type.generate(params);
        expect(p.start.where((v) => v > 0).length, 2);
        expect(type.generate(params).toJson(), p.toJson());
        MergeState play() {
          var s = type.initialState(p);
          for (var k = 0; k < 30; k++) {
            final h = type.hint(p, s);
            if (h == null) break;
            s = h.state;
          }
          return s;
        }

        expect(play().cells, play().cells);
      }
    });
  }

  test('the hint plays well: 4×4 easy reaches 512', () {
    var wins = 0;
    for (var seed = 1; seed <= 3; seed++) {
      final p = type.generate(GenParams(size: const GridSize.square(4), difficulty: Difficulty.easy, seed: seed));
      var s = type.initialState(p);
      while (!type.isComplete(p, s)) {
        s = type.hint(p, s)!.state;
      }
      if (type.isSolved(p, s)) wins++;
    }
    expect(wins, greaterThanOrEqualTo(2));
  });

  test('a hint is quick even on 6×6', () {
    final p = type.generate(const GenParams(size: GridSize.square(6), difficulty: Difficulty.easy, seed: 3));
    var s = type.initialState(p);
    var slowest = 0;
    for (var k = 0; k < 60; k++) {
      final sw = Stopwatch()..start();
      s = type.hint(p, s)!.state;
      if (sw.elapsedMilliseconds > slowest) slowest = sw.elapsedMilliseconds;
    }
    expect(slowest, lessThan(150), reason: '${slowest}ms');
  });

  test('state survives a save round trip', () {
    final p = type.generate(const GenParams(size: GridSize.square(5), difficulty: Difficulty.hard, seed: 9));
    var s = type.initialState(p);
    for (var k = 0; k < 10; k++) {
      s = type.hint(p, s)!.state;
    }
    final back = type.decodeState(type.encodeState(s));
    expect(back.toJson(), s.toJson());
    expect(type.decodePuzzle(type.encodePuzzle(p)).toJson(), p.toJson());
  });

  test('share codes carry the goal', () {
    const params = GenParams(size: GridSize.square(5), difficulty: Difficulty.hard, seed: 77, options: {'goal': 'free'});
    final code = PuzzleCode.format(type, params);
    expect(code, 'merge-5x5-hard.free-25-v1');
    expect(PuzzleCode.parse(code, puzzleTypes).params.options, {'goal': 'free'});
  });
}
