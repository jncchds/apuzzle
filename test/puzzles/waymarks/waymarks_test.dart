import 'package:apuzzle/core/difficulty.dart';
import 'package:apuzzle/core/grid.dart';
import 'package:apuzzle/puzzles/waymarks/waymarks_explain.dart';
import 'package:apuzzle/puzzles/waymarks/waymarks_generator.dart';
import 'package:apuzzle/puzzles/waymarks/waymarks_model.dart';
import 'package:apuzzle/puzzles/waymarks/waymarks_solver.dart';
import 'package:apuzzle/puzzles/waymarks/waymarks_tutorial.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/timing.dart';

/// The solution's links.
WaymarksState solved(WaymarksPuzzle p) => WaymarksState(WaymarksExplainer.solutionNext(p));

void main() {
  // 1 at A2, then C2, B1, A1, C1, C3, A3, B3 and 9 at B2.
  final small = waymarksBoard(3, [3, 5, 1, 0, 2, 8, 6, 7, 4], const []);

  test('arrows and rays', () {
    expect(waymarksDirOf(3, 3, 5), 2); // right
    expect(waymarksDirOf(3, 2, 6), 5); // down-left
    expect(waymarksDirOf(3, 0, 5), -1); // a knight's move
    expect(waymarksRay(3, 0, 3), [4, 8]);
    expect(small.dir[small.path.last], -1);
    expect(small.targets[3], [4, 5]);
    expect(small.sources[4], containsAll([3, 7]));
    expect(WaymarksPuzzle.fromJson(small.toJson()).toJson(), small.toJson());
  });

  test('links, chains and labels', () {
    var s = WaymarksState(List.filled(9, -1));
    // 2 → 3 → 4 is a chain of letters until it joins 1.
    s = waymarksLink(small, s, 5, 1)!;
    s = waymarksLink(small, s, 1, 0)!;
    final loose = waymarksChains(small, s).firstWhere((c) => c.cells.length == 3);
    expect(loose.cells, [5, 1, 0]);
    expect(loose.start, isNull);
    s = waymarksLink(small, s, 3, 5)!;
    expect(waymarksChains(small, s).firstWhere((c) => c.cells.length == 4).start, 1);
    // Not along the arrow, or closing a loop.
    expect(waymarksLink(small, s, 3, 0), isNull);
    // A new link into a cell replaces the old one.
    final again = waymarksLink(small, s, 7, 4);
    expect(again, isNotNull);
    // Cutting a cell drops its links both ways.
    final cut = waymarksCut(s, 1);
    expect(cut.next[5], -1);
    expect(cut.next[1], -1);
  });

  test('complete, solved and conflicts', () {
    final s = solved(small);
    expect(waymarksComplete(small, s), isTrue);
    expect(waymarksSolved(small, s), isTrue);
    expect(waymarksConflicts(small, s), isEmpty);
    // A shown number off its place in the chain is flagged.
    final p = waymarksBoard(3, small.path, const [4]);
    final wrong = WaymarksState(List.of(s.next)..[3] = -1);
    expect(waymarksConflicts(p, wrong), isEmpty);
    expect(waymarksComplete(p, wrong), isFalse);
  });

  test('solver: tutorial boards need their rule', () {
    for (final (board, rule) in [
      (waymarksBoard(4, [11, 3, 15, 7, 13, 14, 2, 1, 0, 10, 8, 12, 6, 4, 9, 5], const []), WaymarksRule.onlyIn),
      (
        waymarksBoard(4, [11, 1, 3, 0, 15, 12, 8, 2, 14, 13, 9, 10, 5, 7, 6, 4], const [12, 13]),
        WaymarksRule.consecutive,
      ),
      (waymarksBoard(4, [6, 3, 11, 7, 15, 14, 12, 4, 9, 1, 13, 10, 8, 0, 5, 2], const []), WaymarksRule.loop),
    ]) {
      expect(WaymarksSolver(board).slack(1), 0, reason: rule.name);
      expect(WaymarksSolver(board, disabled: {rule}).slack(1), greaterThan(0), reason: rule.name);
      expect(WaymarksSolver(board).countSolutions(), 1, reason: rule.name);
    }
    // The strategy boards: tier 2 with number reasoning, and one link whose
    // numbers can't be one apart.
    final numbers = waymarksBoard(4, [11, 7, 3, 15, 12, 0, 1, 13, 8, 4, 14, 2, 10, 6, 5, 9], const [13]);
    expect(WaymarksSolver(numbers).grade(), 2);
    expect(WaymarksSolver(numbers, disabled: {WaymarksRule.after}).slack(2), greaterThan(0));
    final fit = waymarksBoard(4, [10, 2, 14, 11, 7, 6, 1, 3, 15, 0, 12, 13, 5, 9, 4, 8], const [4]);
    expect(WaymarksSolver(fit).grade(), 2);
    expect(WaymarksSolver(fit, disabled: {WaymarksRule.noFit}).slack(2), greaterThan(0));
  });

  test('ranges in texts', () {
    expect(waymarksRanges([2, 3, 4, 5, 9]), '2–5, 9');
    expect(waymarksRanges([2, 3, 7]), '2, 3, 7');
    expect(waymarksRanges([4]), '4');
  });

  for (final n in [5, 6, 7, 8, 9]) {
    for (final d in [Difficulty.easy, Difficulty.medium, Difficulty.hard]) {
      test('waymarks ${n}x$n ${d.name}: valid, unique, tiered, deterministic', () {
        final info = <String>[];
        final tier = waymarksTier(d);
        for (var seed = 1; seed <= 3; seed++) {
          final params = GenParams(size: GridSize.square(n), difficulty: d, seed: seed);
          final sw = Stopwatch()..start();
          final p = generateWaymarks(params);
          sw.stop();
          expect(p.path.toSet().length, n * n);
          expect(waymarksSolved(p, solved(p)), isTrue);
          final s = WaymarksSolver(p);
          expect(s.grade(), tier);
          final k = s.start();
          expect(s.solve(k, tier), isTrue);
          expect(s.nextOf(k), WaymarksExplainer.solutionNext(p));
          expect(s.countSolutions(), 1);
          if (seed == 1) expect(generateWaymarks(params).toJson(), p.toJson(), reason: 'not deterministic');
          expect(sw.elapsedMilliseconds, lessThan(timeLimit(5000)));
          info.add('${sw.elapsedMilliseconds}ms shown ${p.shown.where((x) => x).length}');
        }
        // ignore: avoid_print
        print('waymarks $n ${d.name}: $info');
      });
    }
  }

  test('strategy boards need their technique', () {
    for (final params in waymarksStrategyParams) {
      final p = generateWaymarks(params);
      expect(WaymarksSolver(p).grade(), waymarksTier(params.difficulty));
    }
  });
}
