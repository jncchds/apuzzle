import 'package:apuzzle/core/difficulty.dart';
import 'package:apuzzle/core/grid.dart';
import 'package:apuzzle/puzzles/basins/basins_generator.dart';
import 'package:apuzzle/puzzles/basins/basins_model.dart';
import 'package:apuzzle/puzzles/basins/basins_solver.dart';
import 'package:apuzzle/puzzles/basins/basins_tutorial.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/timing.dart';

void main() {
  // c D a
  // C b a
  // B B A
  final p = basinsBoard('cDa|Cba|BBA');

  test('the board parser takes basins and counts from the letters', () {
    expect(p.regions, [0, 1, 2, 0, 3, 2, 3, 3, 2]);
    expect(p.rowCounts, [1, 1, 3]);
    expect(p.colCounts, [2, 2, 1]);
  });

  test('conflicts: water above dry cells of its basin, and counts', () {
    List<int> board(String s) => [
      for (final ch in s.replaceAll('|', '').split('')) ch == 'W' ? basinsWater : (ch == '.' ? basinsDry : -1),
    ];
    expect(basinsConflicts(p, board('.W.|W..|WWW'), complete: true), isEmpty);
    // Water above a dry cell of the same basin.
    expect(basinsConflicts(p, board('W--|.--|---'), complete: false), {0, 3});
    // Water beside a dry cell of the same basin in one row.
    expect(basinsConflicts(p, board('---|---|W.-'), complete: false), {6, 7});
    // Too much water in column C, too many dry cells in row 3.
    expect(basinsConflicts(p, board('---|--W|-..'), complete: false), containsAll([7, 8]));
    // Not complete: missing water isn't flagged until then.
    expect(basinsConflicts(p, board('---|---|W--'), complete: false), isEmpty);
    // Complete: empty cells count as dry.
    expect(basinsConflicts(p, board('-W-|W--|WWW'), complete: true), isEmpty);
  });

  test('tier 1 solves the tutorial boards, the row-pieces lesson needs tier 2', () {
    for (final b in ['abC|AbC|AbC', 'aaa|bbC|BBC', 'cDa|Cba|BBA']) {
      final q = basinsBoard(b), s = BasinsSolver.of(q);
      expect(s.grade(s.start()), 1, reason: b);
      expect(s.countSolutions(s.start()), 1, reason: b);
    }
    final q = basinsBoard('bbbaa|bgbAA|GGBBd|CFFed|CCCED'), s = BasinsSolver.of(q);
    expect(s.grade(s.start()), 2);
  });

  test('strategy boards need their technique', () {
    for (final params in basinsStrategyParams) {
      final q = generateBasins(params);
      final s = BasinsSolver.of(q);
      expect(s.grade(basinsStart(s, q)), basinsTier(params.difficulty));
    }
  });

  for (final n in [6, 7, 8, 9, 10]) {
    for (final d in [Difficulty.easy, Difficulty.medium, Difficulty.hard]) {
      test('basins ${n}x$n ${d.name}: valid, unique, tiered, deterministic', () {
        final info = <String>[];
        final tier = basinsTier(d);
        for (var seed = 1; seed <= 4; seed++) {
          final params = GenParams(size: GridSize.square(n), difficulty: d, seed: seed);
          final sw = Stopwatch()..start();
          final p = generateBasins(params);
          sw.stop();
          final v = [for (final w in p.water) w ? basinsWater : basinsDry];
          expect(basinsConflicts(p, v, complete: true), isEmpty);
          final s = BasinsSolver.of(p);
          final grade = s.grade(basinsStart(s, p));
          expect(grade, lessThanOrEqualTo(tier));
          final st = basinsStart(s, p);
          expect(s.solve(st, tier), isTrue);
          expect([for (final x in st) x == basinsWater], p.water);
          expect(s.countSolutions(basinsStart(s, p)), 1);
          if (seed == 1) expect(generateBasins(params).toJson(), p.toJson(), reason: 'not deterministic');
          expect(BasinsPuzzle.fromJson(p.toJson()).toJson(), p.toJson());
          // Small boards rarely need the whole tier, so medium and hard 6×6 try longer.
          expect(sw.elapsedMilliseconds, lessThan(timeLimit(n == 6 && tier > 1 ? 6000 : 3000)));
          info.add(
            '${sw.elapsedMilliseconds}ms grade $grade basins ${p.regionCount} givens ${p.givens.length} hidden ${[...p.rowCounts, ...p.colCounts].where((c) => c == null).length}',
          );
        }
        // ignore: avoid_print
        print('basins $n ${d.name}: $info');
      });
    }
  }
}
