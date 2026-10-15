import 'package:apuzzle/core/difficulty.dart';
import 'package:apuzzle/core/explain.dart';
import 'package:apuzzle/core/grid.dart';
import 'package:apuzzle/puzzles/totals/totals_generator.dart';
import 'package:apuzzle/puzzles/totals/totals_model.dart';
import 'package:apuzzle/puzzles/totals/totals_solver.dart';
import 'package:apuzzle/puzzles/totals/totals_tutorial.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/timing.dart';

void main() {
  test('runs, clues and conflicts', () {
    final p = totalsBoard(['###', '#12', '#34']);
    expect(
      [for (final r in p.runs) '${r.clue} ${r.across ? 'across' : 'down'} ${r.cells} ${r.sum}'],
      ['1 down [4, 7] 4', '2 down [5, 8] 6', '3 across [4, 5] 3', '6 across [7, 8] 7'],
    );
    expect(p.acrossFrom[3], 2);
    expect(p.downFrom[1], 0);
    expect(totalsConflicts(p, [9, 9, 9, 9, 0, 1, 9, 2, 3]), isEmpty);
    // A digit twice in a run, a run past its sum, a full run that misses it.
    expect(totalsConflicts(p, [9, 9, 9, 9, 0, 0, 9, -1, -1]), {4, 5});
    expect(totalsConflicts(p, [9, 9, 9, 9, -1, 5, 9, -1, -1]), {5});
    expect(totalsConflicts(p, [9, 9, 9, 9, 0, 1, 9, 2, 2]), containsAll([7, 8]));
    // Partial runs that can still work are fine.
    expect(totalsConflicts(p, [9, 9, 9, 9, 0, -1, 9, -1, 3]), isEmpty);
    expect(TotalsPuzzle.fromJson(p.toJson()).toJson(), p.toJson());
  });

  test('digit sets', () {
    expect(totalsCombos(2, 3), [0x3]);
    expect(totalsCombos(3, 24), [0x1C0]);
    expect(totalsCombos(2, 10).length, 4);
  });

  test('solver rules: sets, a digit with one spot, every way to fill', () {
    // 3 across and 4 down share the corner: the sets {1, 2} and {1, 3}.
    final p = totalsBoard(['###', '#12', '#34']);
    final s = TotalsSolver(p);
    final c = s.start();
    expect(s.propagate(c, 1), isTrue);
    expect(s.values(c), p.digits);
  });

  for (final n in [6, 7, 8, 9, 10]) {
    for (final d in [Difficulty.easy, Difficulty.medium, Difficulty.hard]) {
      test('totals ${n}x$n ${d.name}: valid, unique, tiered, deterministic', () {
        final info = <String>[];
        final tier = totalsTier(d);
        for (var seed = 1; seed <= 4; seed++) {
          final params = GenParams(size: GridSize.square(n), difficulty: d, seed: seed);
          final sw = Stopwatch()..start();
          final p = generateTotals(params);
          sw.stop();
          final values = [for (var i = 0; i < n * n; i++) p.solutionAt(i)];
          expect(totalsConflicts(p, values), isEmpty);
          for (final run in p.runs) {
            expect(run.cells.length, inInclusiveRange(2, 9));
          }
          for (var i = 0; i < n * n; i++) {
            if (!p.isBlock(i)) expect(p.acrossOf[i] >= 0 && p.downOf[i] >= 0, isTrue, reason: 'cell $i');
          }
          final s = TotalsSolver(p);
          final grade = s.grade(s.start());
          expect(grade, tier, reason: 'seed $seed');
          final c = s.start();
          expect(s.solve(c, tier), isTrue);
          expect(s.values(c), p.digits);
          expect(s.countSolutions(s.start()), 1);
          if (seed == 1) expect(generateTotals(params).toJson(), p.toJson(), reason: 'not deterministic');
          expect(TotalsPuzzle.fromJson(p.toJson()).toJson(), p.toJson());
          expect(sw.elapsedMilliseconds, lessThan(timeLimit(4000)));
          info.add('${sw.elapsedMilliseconds}ms givens ${p.givens.length}');
        }
        // ignore: avoid_print
        print('totals $n ${d.name}: $info');
      });
    }
  }

  test('strategy boards need the tier they teach', () {
    for (var k = 0; k < totalsStrategyParams.length; k++) {
      final params = totalsStrategyParams[k];
      final p = generateTotals(params);
      final s = TotalsSolver(p);
      expect(s.grade(s.start()), totalsTier(params.difficulty), reason: 'lesson ${k + 1}');
    }
    // The first lesson places a digit with one spot in its run.
    final t = ExplainTrace();
    final p = generateTotals(totalsStrategyParams[0]);
    TotalsSolver(p).propagate(TotalsSolver(p).start(), 1, t);
    expect(t.facts.any((f) => f.rule == TotalsRule.must.index), isTrue);
  });
}
