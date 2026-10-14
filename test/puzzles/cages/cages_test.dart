import 'package:apuzzle/core/difficulty.dart';
import 'package:apuzzle/core/grid.dart';
import 'package:apuzzle/core/latin_square.dart';
import 'package:apuzzle/puzzles/cages/cages_generator.dart';
import 'package:apuzzle/puzzles/cages/cages_model.dart';
import 'package:apuzzle/puzzles/cages/cages_solver.dart';
import 'package:apuzzle/puzzles/cages/cages_tutorial.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('cage operations', () {
    expect(cageHolds(CageOp.add, 7, [1, 2, 4]), isTrue);
    expect(cageHolds(CageOp.mul, 12, [3, 4]), isTrue);
    expect(cageHolds(CageOp.sub, 2, [1, 3]), isTrue);
    expect(cageHolds(CageOp.sub, 2, [3, 1]), isTrue);
    expect(cageHolds(CageOp.div, 3, [6, 2]), isTrue);
    expect(cageHolds(CageOp.div, 3, [2, 6]), isTrue);
    expect(cageHolds(CageOp.div, 2, [2, 5]), isFalse);
    expect(cageTarget(CageOp.div, [2, 5]), isNull);
    expect(const Cage([0, 1], CageOp.mul, 12).clue, '12×');
  });

  for (final n in [4, 5, 6, 7, 8, 9]) {
    for (final d in [Difficulty.easy, Difficulty.medium, Difficulty.hard]) {
      test('cages ${n}x$n ${d.name}: valid, unique, tiered, deterministic', () {
        final info = <String>[];
        for (var seed = 1; seed <= 4; seed++) {
          final params = GenParams(size: GridSize.square(n), difficulty: d, seed: seed);
          final sw = Stopwatch()..start();
          final p = generateCages(params);
          sw.stop();
          expect(cagesConflicts(p, p.solution), isEmpty);
          final covered = [for (final c in p.cages) ...c.cells]..sort();
          expect(covered, [for (var i = 0; i < n * n; i++) i]);
          for (final cage in p.cages) {
            expect(cage.cells.length, lessThanOrEqualTo(d == Difficulty.easy ? 3 : 5));
            if (cage.op == CageOp.sub || cage.op == CageOp.div) expect(cage.cells.length, 2);
            if (d == Difficulty.easy) expect(cage.op, isNot(anyOf(CageOp.mul, CageOp.div)));
          }
          final s = CagesSolver(n, p.cages);
          expect(s.countSolutions(s.start(p.givens)), 1, reason: 'not unique');
          final tier = cagesTier(d);
          final c = s.start(p.givens);
          expect(s.solve(c, tier), isTrue, reason: 'not solvable at tier $tier');
          expect(LatinSquare.of(n).values(c), p.solution);
          final below = tier > 1 && s.solve(s.start(p.givens), tier - 1);
          expect(generateCages(params).toJson(), p.toJson(), reason: 'not deterministic');
          expect(sw.elapsedMilliseconds, lessThan(4000), reason: 'too slow');
          final lone = p.cages.where((c) => c.cells.length == 1).length;
          info.add('${sw.elapsedMilliseconds}ms k${p.cages.length} l$lone${below ? ' easier' : ''}');
        }
        // ignore: avoid_print
        print('cages $n ${d.name}: $info');
      });
    }
  }

  test('strategy boards need the tier they teach', () {
    for (var k = 0; k < cagesStrategyParams.length; k++) {
      final params = cagesStrategyParams[k];
      final p = generateCages(params);
      final s = CagesSolver(p.n, p.cages);
      final tier = cagesTier(params.difficulty);
      expect(s.solve(s.start(p.givens), tier), isTrue, reason: 'lesson ${k + 1}');
      if (tier > 1) expect(s.solve(s.start(p.givens), tier - 1), isFalse, reason: 'lesson ${k + 1}');
    }
  });
}
