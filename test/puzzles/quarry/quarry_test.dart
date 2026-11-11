import 'package:apuzzle/core/difficulty.dart';
import 'package:apuzzle/core/grid.dart';
import 'package:apuzzle/puzzles/quarry/quarry_generator.dart';
import 'package:apuzzle/puzzles/quarry/quarry_model.dart';
import 'package:apuzzle/puzzles/quarry/quarry_solver.dart';
import 'package:apuzzle/puzzles/quarry/quarry_tutorial.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/timing.dart';

List<int> _states(QuarryPuzzle p) => [for (final x in p.shaded) x ? quarryShade : quarryKeep];

void main() {
  test('shapes: every stone of the set is distinct, any turn or mirror image matches', () {
    final keys = {for (final s in quarryShapes) quarryShapeKey(s.cells)};
    expect(keys.length, quarryShapes.length);
    for (final s in quarryShapes) {
      for (final o in quarryOrientations(s.cells)) {
        expect(quarryShapeKey(o), quarryShapeKey(s.cells));
      }
      final (h, w) = quarryExtent(quarryShown(quarryShapes.indexOf(s)));
      expect(h, lessThanOrEqualTo(w));
    }
    // The F has 8 orientations, the X one.
    expect(quarryOrientations(quarryShapes[7].cells).length, 8);
    expect(quarryOrientations(quarryShapes[16].cells).length, 1);
  });

  test('rules: the stones once, apart, circles kept, the rest joined', () {
    // A straight three on top, a corner of three below.
    final ok = quarryBoard('###.|....|##..|#...');
    expect(ok.pieces.toSet(), {0, 1});
    expect(quarryValid(ok, ok.shaded), isTrue);
    // The same stone twice.
    final twice = List.of(ok.shaded)
      ..[12] = false
      ..[10] = true;
    expect(quarryConflicts(ok, twice, complete: true), isNotEmpty);
    expect(quarryValid(ok, twice), isFalse);
    // Touching stones make one area that is no stone.
    final touch = List.of(ok.shaded)..[4] = true;
    expect(quarryConflicts(ok, touch, complete: true), contains(0));
    // The empty corner cut off.
    final apart = List.filled(16, false);
    for (final i in [0, 1, 2, 7, 10, 11]) {
      apart[i] = true;
    }
    expect(quarryConflicts(ok, apart, complete: true), contains(3));
    // A filled circle left empty.
    final circled = quarryBoard('##@.|....|##..|#...');
    expect(quarryValid(circled, circled.shaded), isTrue);
    expect(quarryValid(circled, apart), isFalse);
    // Before the board is complete only sure mistakes count.
    expect(quarryConflicts(ok, List.filled(16, false), complete: false), isEmpty);
    final big = List.filled(16, false);
    for (final i in [0, 1, 2, 5]) {
      big[i] = true;
    }
    expect(quarryConflicts(ok, big, complete: false), containsAll([0, 1, 2, 5]));
    // Closed off by dots with a shape that is no stone.
    final two = List.filled(16, false)
      ..[0] = true
      ..[1] = true;
    final dots = List.filled(16, false)
      ..[2] = true
      ..[4] = true
      ..[5] = true;
    expect(quarryConflicts(ok, two, kept: dots, complete: false), containsAll([0, 1]));
    expect(quarryConflicts(ok, two, kept: List.filled(16, false), complete: false), isEmpty);
  });

  test('a shaded area is a finished stone once no bigger stone holds it, or it is closed off', () {
    expect(quarryContains(quarryShapes[4].cells, quarryShapes[0].cells), isTrue); // T holds a straight three
    expect(quarryContains(quarryShapes[3].cells, quarryShapes[0].cells), isFalse); // a square doesn't
    final t = quarryBoard('##@o.|.....|..@@@|...#.|.....');
    expect(quarryFinished(t, [12, 13, 14], closed: false), -1);
    expect(quarryFinished(t, [12, 13, 14], closed: true), t.pieces.indexOf(0));
    expect(quarryFinished(t, [12, 13, 14, 18], closed: false), t.pieces.indexOf(4));
  });

  bool solves(QuarryPuzzle p, int tier, [Set<QuarryRule> off = const {}]) =>
      QuarrySolver(p, disabled: off).slack(tier) == 0;

  test('tutorial boards need the rule they teach', () {
    final steps = [for (final s in quarryTutorial.take(4)) s.puzzle as QuarryPuzzle];
    for (final p in steps) {
      final s = QuarrySolver(p);
      expect(s.grade(), 1);
      final st = s.start();
      expect(s.solve(st, 1), isTrue);
      expect(st, _states(p));
      expect(s.countSolutions(), 1);
    }
    expect(solves(steps[0], 1, {QuarryRule.only}), isFalse);
    expect(solves(steps[1], 1, {QuarryRule.beside, QuarryRule.onlyBeside}), isFalse);
    expect(solves(steps[2], 1, {QuarryRule.isolated}), isFalse);
    expect(solves(steps[3], 1, {QuarryRule.walled}), isFalse);
    for (final (board, rule) in [(quarryRoomBoard, QuarryRule.room), (quarryCutBoard, QuarryRule.cut)]) {
      expect(solves(board, 1), isFalse);
      expect(solves(board, 2), isTrue);
      expect(solves(board, 2, {rule}), isFalse);
      expect(QuarrySolver(board).countSolutions(), 1);
    }
    expect(QuarrySolver(generateQuarry(quarryProbeParams)).grade(), 3);
  });

  for (final n in [5, 6, 7, 8, 9, 10]) {
    for (final d in [Difficulty.easy, Difficulty.medium, Difficulty.hard]) {
      test('quarry ${n}x$n ${d.name}: valid, unique, tiered, deterministic', () {
        final info = <String>[];
        final tier = quarryTier(d);
        for (var seed = 1; seed <= 4; seed++) {
          final params = GenParams(size: GridSize.square(n), difficulty: d, seed: seed);
          final sw = Stopwatch()..start();
          final p = generateQuarry(params);
          sw.stop();
          expect(quarryValid(p, p.shaded), isTrue);
          expect(p.pieces.toSet().length, p.pieces.length);
          final s = QuarrySolver(p);
          expect(s.grade(), tier);
          final st = s.start();
          expect(s.solve(st, tier), isTrue);
          expect(st, _states(p));
          expect(s.countSolutions(budget: 100000), 1);
          if (seed == 1) expect(generateQuarry(params).toJson(), p.toJson(), reason: 'not deterministic');
          expect(QuarryPuzzle.fromJson(p.toJson()).toJson(), p.toJson());
          expect(sw.elapsedMilliseconds, lessThan(timeLimit(5000)));
          info.add('${sw.elapsedMilliseconds}ms circles ${p.clues.where((c) => c != null).length}');
        }
        // ignore: avoid_print
        print('quarry $n ${d.name}: $info');
      }, timeout: const Timeout(Duration(minutes: 3)));
    }
  }
}
