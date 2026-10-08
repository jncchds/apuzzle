import 'package:apuzzle/core/difficulty.dart';
import 'package:apuzzle/core/grid.dart';
import 'package:apuzzle/core/puzzle_code.dart';
import 'package:apuzzle/core/registry.dart';
import 'package:apuzzle/puzzles/snake/snake_generator.dart';
import 'package:apuzzle/puzzles/snake/snake_model.dart';
import 'package:apuzzle/puzzles/snake/snake_type.dart';
import 'package:flutter_test/flutter_test.dart';

SnakePuzzle _puzzle(List<int> body, SnakeDir dir, int food, {int rows = 4, int cols = 4, int target = 0}) =>
    SnakePuzzle(
      rows: rows,
      cols: cols,
      goal: target > 0 ? SnakeGoal.target : SnakeGoal.free,
      target: target,
      seed: 1,
      stepMs: 200,
      start: body,
      dir: dir,
      food: food,
    );

void main() {
  const type = SnakeType();

  test('a step moves the head and drops the tail', () {
    final p = _puzzle([5, 4], SnakeDir.right, 15);
    final s = snakeStep(p, SnakeState.initial(p), SnakeDir.down);
    expect(s.body, [9, 5]);
    expect(s.dir, SnakeDir.down);
    expect(s.steps, 1);
    expect(s.dead, isFalse);
  });

  test('a U-turn keeps going straight', () {
    final p = _puzzle([5, 4], SnakeDir.right, 15);
    final s = snakeStep(p, SnakeState.initial(p), SnakeDir.left);
    expect(s.body, [6, 5]);
    expect(s.dir, SnakeDir.right);
  });

  test('an apple grows the snake and a new one appears on a free cell', () {
    final p = _puzzle([5, 4], SnakeDir.right, 6);
    final s = snakeStep(p, SnakeState.initial(p), SnakeDir.right);
    expect(s.body, [6, 5, 4]);
    expect(s.eaten, 1);
    expect(s.food, isNot(anyOf(6, 5, 4)));
    expect(s.food, inInclusiveRange(0, 15));
  });

  test('walls and the body kill, the moving tail does not', () {
    final p = _puzzle([3, 2], SnakeDir.right, 15);
    expect(snakeStep(p, SnakeState.initial(p), SnakeDir.right).dead, isTrue);
    expect(snakeStep(p, SnakeState.initial(p), SnakeDir.up).dead, isTrue);
    // A square loop of four: the head may move into the cell the tail leaves.
    final loop = _puzzle([0, 4, 5, 1], SnakeDir.up, 15);
    expect(snakeStep(loop, SnakeState.initial(loop), SnakeDir.right).dead, isFalse);
    final bite = _puzzle([0, 4, 5, 1, 2], SnakeDir.up, 15);
    expect(snakeStep(bite, SnakeState.initial(bite), SnakeDir.right).dead, isTrue);
  });

  test('free play ends as a finish on a crash, a target fails', () {
    final free = _puzzle([3, 2], SnakeDir.right, 15);
    final crashed = snakeStep(free, SnakeState.initial(free), SnakeDir.right);
    expect(type.isComplete(free, crashed) && type.isSolved(free, crashed), isTrue);
    final goal = _puzzle([3, 2], SnakeDir.right, 15, target: 2);
    final failed = snakeStep(goal, SnakeState.initial(goal), SnakeDir.right);
    expect(type.isComplete(goal, failed), isTrue);
    expect(type.isSolved(goal, failed), isFalse);
  });

  test('speeds up with apples, down to 60%', () {
    final p = _puzzle([5, 4], SnakeDir.right, 6);
    const s = SnakeState(body: [5, 4], dir: SnakeDir.right, food: 6, eaten: 10, steps: 0);
    expect(snakeInterval(p, s), 180);
    const late = SnakeState(body: [5, 4], dir: SnakeDir.right, food: 6, eaten: 500, steps: 0);
    expect(snakeInterval(p, late), 120);
  });

  for (final size in type.sizes) {
    test('${size.label}: deterministic, same apples on replay', () {
      for (var seed = 1; seed <= 4; seed++) {
        final params = GenParams(size: size, difficulty: Difficulty.medium, seed: seed);
        final p = type.generate(params);
        expect(type.generate(params).toJson(), p.toJson());
        expect(p.start.toSet().length, 3);
        expect(p.start, isNot(contains(p.food)));
        SnakeState play() {
          var s = type.initialState(p);
          for (var k = 0; k < 200; k++) {
            final h = type.hint(p, s);
            if (h == null) break;
            s = h.state;
          }
          return s;
        }

        expect(play().toJson(), play().toJson());
      }
    });
  }

  test('the steering hint eats a good share of a 10×10 board', () {
    final p = type.generate(const GenParams(size: GridSize.square(10), difficulty: Difficulty.easy, seed: 5));
    var s = type.initialState(p);
    for (var k = 0; k < 4000 && !type.isComplete(p, s); k++) {
      s = type.hint(p, s)!.state;
    }
    expect(s.eaten, greaterThanOrEqualTo(30));
  });

  test('targets scale with size and difficulty', () {
    expect(snakeTarget(10, 10, Difficulty.easy), 8);
    expect(snakeTarget(10, 10, Difficulty.hard), 25);
    expect(snakeTarget(8, 8, Difficulty.easy), 5);
    expect(snakeSpeed(Difficulty.hard), lessThan(snakeSpeed(Difficulty.easy)));
  });

  test('state survives a save round trip', () {
    final p = type.generate(const GenParams(size: GridSize.square(12), difficulty: Difficulty.hard, seed: 9));
    var s = type.initialState(p);
    for (var k = 0; k < 30; k++) {
      s = type.hint(p, s)!.state;
    }
    expect(type.decodeState(type.encodeState(s)).toJson(), s.toJson());
    expect(type.decodePuzzle(type.encodePuzzle(p)).toJson(), p.toJson());
  });

  test('share codes carry the goal', () {
    const params = GenParams(
      size: GridSize.square(10),
      difficulty: Difficulty.easy,
      seed: 77,
      options: {'goal': 'target'},
    );
    final code = PuzzleCode.format(type, params);
    expect(PuzzleCode.parse(code, puzzleTypes).params.options, {'goal': 'target'});
  });
}
