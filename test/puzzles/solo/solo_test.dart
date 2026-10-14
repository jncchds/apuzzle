import 'package:apuzzle/core/difficulty.dart';
import 'package:apuzzle/core/grid.dart';
import 'package:apuzzle/puzzles/solo/solo_generator.dart';
import 'package:apuzzle/puzzles/solo/solo_model.dart';
import 'package:apuzzle/puzzles/solo/solo_solver.dart';
import 'package:apuzzle/puzzles/solo/solo_tutorial.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('conflicts: repeats, touching, lonely shades and cut-off cells', () {
    // 1 2 1
    // 2 1 2
    // 3 3 1
    final digits = [1, 2, 1, 2, 1, 2, 3, 3, 1];
    expect(soloConflicts(3, digits, List.filled(9, false), complete: false), containsAll([0, 2, 6, 7]));
    final ok = [true, false, false, false, false, true, false, true, false];
    // Column 3 keeps two 1s, and the bottom-right 1 is walled in.
    expect(soloConflicts(3, digits, ok, complete: true), {2, 8});
    // Both 3s shaded: they touch, and their number shows nowhere else.
    final both = [false, false, false, false, false, false, true, true, false];
    expect(soloConflicts(3, digits, both, complete: false), containsAll([6, 7]));
  });

  test('solver rules: between and pair', () {
    // Row 0: 1 2 1 → the 2 stays; row 1: 3 3 ... 3 → the far 3 is shaded.
    final s = SoloSolver(4, [1, 2, 1, 4, 3, 3, 4, 3, 2, 4, 3, 1, 4, 1, 2, 3]);
    final st = s.start();
    expect(s.propagate(st, 1), isTrue);
    expect(st[1], soloKeep);
    expect(st[7], soloShade);
  });

  for (final n in [5, 6, 7, 8, 9]) {
    for (final d in [Difficulty.easy, Difficulty.medium, Difficulty.hard]) {
      test('solo ${n}x$n ${d.name}: valid, unique, tiered, deterministic', () {
        final info = <String>[];
        final tier = soloTier(d);
        for (var seed = 1; seed <= 4; seed++) {
          final params = GenParams(size: GridSize.square(n), difficulty: d, seed: seed);
          final sw = Stopwatch()..start();
          final p = generateSolo(params);
          sw.stop();
          expect(soloConflicts(n, p.digits, p.shaded, complete: true), isEmpty);
          final s = SoloSolver.of(p);
          final st = s.start(givens: p.givens, shaded: p.shaded);
          final grade = s.grade(st);
          expect(grade, lessThanOrEqualTo(tier));
          expect(s.solve(st, tier), isTrue);
          expect([for (final x in st) x == soloShade], p.shaded);
          expect(
            s.countSolutions(
              from: s.start(givens: p.givens, shaded: p.shaded),
            ),
            1,
          );
          expect(generateSolo(params).toJson(), p.toJson(), reason: 'not deterministic');
          expect(SoloPuzzle.fromJson(p.toJson()).toJson(), p.toJson());
          expect(sw.elapsedMilliseconds, lessThan(3000));
          info.add(
            '${sw.elapsedMilliseconds}ms grade $grade givens ${p.givens.length} shaded ${p.shaded.where((x) => x).length}',
          );
        }
        // ignore: avoid_print
        print('solo $n ${d.name}: $info');
      });
    }
  }

  test('strategy boards need their technique', () {
    for (final params in soloStrategyParams) {
      final p = generateSolo(params);
      final s = SoloSolver.of(p);
      expect(s.grade(s.start(givens: p.givens, shaded: p.shaded)), soloTier(params.difficulty));
    }
  });
}
