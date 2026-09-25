import 'package:apuzzle/core/difficulty.dart';
import 'package:apuzzle/core/grid.dart';
import 'package:apuzzle/core/puzzle_code.dart';
import 'package:apuzzle/core/registry.dart';
import 'package:apuzzle/puzzles/pop/pop_model.dart';
import 'package:apuzzle/puzzles/pop/pop_type.dart';
import 'package:flutter_test/flutter_test.dart';

PopPuzzle _puzzle(List<int> start, int rows, int cols, PopMode mode, {List<List<int>> reserve = const []}) => PopPuzzle(
    rows: rows,
    cols: cols,
    colors: 4,
    mode: mode,
    goal: PopGoal.free,
    start: start,
    reserve: reserve,
    target: 0,
    plan: const []);

/// Replays the puzzle's plan from the start.
PopState _replay(PopPuzzle p) {
  var s = PopState.initial(p);
  for (final id in p.plan) {
    s = popAt(p, s, s.ids.indexOf(id))!;
  }
  return s;
}

void main() {
  const type = PopType();

  test('standard: bubbles fall and empty columns close up to the right', () {
    // 1 0 2
    // 1 0 3
    final p = _puzzle([1, 0, 2, 1, 0, 3], 2, 3, PopMode.standard);
    final s = popAt(p, PopState.initial(p), 1)!;
    expect(s.cells, [-1, 1, 2, -1, 1, 3]);
    expect(s.score, 2);
    expect(s.ids, [-1, 0, 2, -1, 3, 5]);
    expect(popAt(p, s, 5), isNull, reason: 'a single bubble does not pop');
  });

  test('shifter: rows slide right to close gaps', () {
    // 2 3 0
    // 1 0 0   → pop the 0s; after falling the bottom row is [1, 3], the top [2]
    final p = _puzzle([2, 3, 0, 1, 0, 0], 2, 3, PopMode.shifter);
    final s = popAt(p, PopState.initial(p), 2)!;
    expect(s.cells, [-1, -1, 2, -1, 1, 3]);
  });

  test('continuous: reserve columns roll in from the left', () {
    // 0 1
    // 0 1   → pop the 0s; the 1s close right, reserve column [2, 3] fills the left
    final p = _puzzle([0, 1, 0, 1], 2, 2, PopMode.continuous, reserve: [
      [2, 3],
      [2],
    ]);
    final s = popAt(p, PopState.initial(p), 0)!;
    expect(s.cells, [3, 1, 2, 1]);
    expect(s.used, 1);
    expect(s.ids[2], p.reserveId(0, 0));
  });

  for (final size in type.sizes) {
    for (final d in type.difficulties) {
      test('clear ${size.label} ${d.name}: the plan clears the board, deterministic, fast', () {
        for (var seed = 1; seed <= 3; seed++) {
          final params = GenParams(size: size, difficulty: d, seed: seed, options: const {'mode': 'std', 'goal': 'clear'});
          final sw = Stopwatch()..start();
          final p = type.generate(params);
          sw.stop();
          expect(p.start.every((c) => c >= 0 && c < p.colors), isTrue);
          final end = _replay(p);
          expect(end.left, 0);
          expect(type.isComplete(p, end) && type.isSolved(p, end), isTrue);
          expect(type.generate(params).toJson(), p.toJson());
          expect(sw.elapsedMilliseconds, lessThan(2000), reason: '${sw.elapsedMilliseconds}ms');
        }
      });
    }
  }

  for (final mode in PopMode.values) {
    for (final size in [const GridSize.square(6), const GridSize(15, 12)]) {
      test('target ${mode.id} ${size.label}: the plan reaches the target, deterministic, fast', () {
        for (final d in type.difficulties) {
          final params = GenParams(size: size, difficulty: d, seed: 7, options: {'mode': mode.id, 'goal': 'target'});
          final sw = Stopwatch()..start();
          final p = type.generate(params);
          sw.stop();
          expect(p.mode, mode);
          expect(p.target, greaterThan(0));
          final end = _replay(p);
          expect(type.isComplete(p, end), isTrue);
          expect(end.score, greaterThanOrEqualTo(p.target));
          expect(type.generate(params).toJson(), p.toJson());
          expect(sw.elapsedMilliseconds, lessThan(3000), reason: '${sw.elapsedMilliseconds}ms');
        }
      });
    }
  }

  test('goal choices depend on the mode', () {
    expect(type.resolveOptions(const {}), {'mode': 'std', 'goal': 'clear'});
    expect(type.resolveOptions(const {'mode': 'shift', 'goal': 'clear'}), {'mode': 'shift', 'goal': 'target'});
    expect(type.resolveOptions(const {'mode': 'mega', 'goal': 'free'}), {'mode': 'mega', 'goal': 'free'});
  });

  test('free play wins whenever the game ends', () {
    final p = type.generate(const GenParams(
        size: GridSize.square(8), difficulty: Difficulty.hard, seed: 3, options: {'mode': 'cont', 'goal': 'free'}));
    var s = type.initialState(p);
    var guard = 0;
    while (!type.isComplete(p, s) && guard++ < 500) {
      final g = type.hint(p, s)!;
      final i = p.size.index(g.cells.first);
      s = popAt(p, s, i)!;
    }
    expect(type.isComplete(p, s) && type.isSolved(p, s), isTrue);
    expect(s.used, greaterThan(0));
  });

  test('hints follow the plan, then still point at a real group', () {
    final p = type.generate(const GenParams(
        size: GridSize.square(8), difficulty: Difficulty.medium, seed: 5, options: {'mode': 'std', 'goal': 'clear'}));
    var s = type.initialState(p);
    final first = type.hint(p, s)!;
    expect(identical(first.state, s), isTrue, reason: 'hints only point');
    expect(first.cells.map(p.size.index), contains(s.ids.indexOf(p.plan.first)));
    // Step off the plan: pop some other group.
    final other = popGroups(s.cells, p.rows, p.cols).firstWhere((g) => !g.contains(s.ids.indexOf(p.plan.first)));
    s = popAt(p, s, other.first)!;
    final h = type.hint(p, s)!;
    expect(h.cells.length, greaterThan(1));
  });

  test('codes carry the mode and goal', () {
    final params = GenParams(
        size: const GridSize(15, 12), difficulty: Difficulty.hard, seed: 99, options: const {'mode': 'shift', 'goal': 'free'});
    final code = PuzzleCode.format(type, params);
    expect(code, 'pop-12x15-hard.shift.free-2R-v1');
    final back = PuzzleCode.parse(code, puzzleTypes).params;
    expect(back.options, params.options);
    expect(back.variant, 'hard.shift.free');
    // Missing options fall back to defaults; unknown or mismatched ones fail.
    expect(PuzzleCode.parse('pop-12x15-hard-2R', puzzleTypes).params.options, {'mode': 'std', 'goal': 'clear'});
    for (final bad in ['pop-12x15-hard.nope-2R', 'pop-12x15-hard.shift.clear-2R', 'pop-12x15-hard.std.free.x-2R']) {
      expect(() => PuzzleCode.parse(bad, puzzleTypes), throwsFormatException, reason: bad);
    }
    expect(PuzzleCode.find('Beat me: https://x/?p=$code'), code);
  });
}
