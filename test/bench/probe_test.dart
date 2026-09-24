@Tags(['bench'])
library;

import 'dart:io';

import 'package:apuzzle/core/difficulty.dart';
import 'package:apuzzle/core/grid.dart';
import 'package:apuzzle/puzzles/atoms/atoms_generator.dart';
import 'package:apuzzle/puzzles/atoms/atoms_solver.dart';
import 'package:apuzzle/puzzles/kings/kings_generator.dart';
import 'package:apuzzle/puzzles/kings/kings_solver.dart';
import 'package:apuzzle/puzzles/lits/lits_generator.dart';
import 'package:apuzzle/puzzles/lits/lits_solver.dart';
import 'package:apuzzle/puzzles/shikaku/shikaku_generator.dart';
import 'package:apuzzle/puzzles/shikaku/shikaku_solver.dart';
import 'package:apuzzle/puzzles/trail/trail_generator.dart';
import 'package:apuzzle/puzzles/trail/trail_logic.dart';
import 'package:apuzzle/puzzles/trail/trail_model.dart';
import 'package:apuzzle/puzzles/trail/trail_solver.dart';
import 'package:flutter_test/flutter_test.dart';

/// Per-generator probes: time, achieved logic tier and shape stats.
/// Pick one with PROBE=atoms/shikaku/trail/kings/lits, plus PROBE_SIZES=5,6,7 PROBE_SEEDS=5:
///   flutter test test/bench/probe_test.dart --run-skipped --tags bench
void main() {
  final probe = Platform.environment['PROBE'] ?? 'lits';
  final sizes = (Platform.environment['PROBE_SIZES'] ?? '5,6,7,8').split(',').map(int.parse).toList();
  final seeds = int.tryParse(Platform.environment['PROBE_SEEDS'] ?? '') ?? 5;

  void run(String name, String Function(GenParams p) one) {
    test('probe $name', () {
      for (final n in sizes) {
        for (final d in [Difficulty.easy, Difficulty.medium, Difficulty.hard]) {
          final ms = <int>[];
          final info = <String>[];
          for (var seed = 1; seed <= seeds; seed++) {
            final sw = Stopwatch()..start();
            info.add(one(GenParams(size: GridSize.square(n), difficulty: d, seed: seed)));
            ms.add(sw.elapsedMilliseconds);
          }
          // ignore: avoid_print
          print('$name $n ${d.name.padRight(6)}: ms $ms  $info');
        }
      }
    }, timeout: const Timeout(Duration(minutes: 30)));
  }

  if (probe == 'atoms') {
    run(probe, (params) {
      final p = generateAtoms(params);
      final s = AtomsSolver(p);
      return 'g${s.grade()} i${p.islands.length}';
    });
  }
  if (probe == 'shikaku') {
    run(probe, (params) {
      final p = generateShikaku(params);
      final s = ShikakuSolver(p.rows, p.cols, p.clues);
      final t = s.solveLogic(1) != null ? 1 : (s.solveLogic(2) != null ? 2 : 3);
      return 't$t r${p.solution.length}';
    });
  }
  if (probe == 'trail') {
    run(probe, (params) {
      final p = generateTrail(params);
      final n = p.rows;
      assert(trailValid(p, p.solution));
      final lg = TrailLogic(n, n, p.numbers);
      final t = lg.solve(1) != null ? 1 : (lg.solve(2) != null ? 2 : 3);
      final u = n <= 6 ? TrailSolver(n, n, p.numbers).solutions().length : -1;
      return 'k${p.lastNumber} t$t u$u';
    });
  }
  if (probe == 'kings') {
    run(probe, (params) {
      final p = generateKings(params);
      final s = KingsSolver(p.n, p.regions);
      final sizes = List<int>.filled(p.n, 0);
      for (final r in p.regions) {
        sizes[r]++;
      }
      sizes.sort();
      return 'g${s.grade()} u${s.solutions().length} sz${sizes.first}-${sizes.last}';
    });
  }
  if (probe == 'lits') {
    run(probe, (params) {
      final p = generateLits(params);
      final n = p.n;
      final s = LitsSolver(n, p.regions);
      final t = s.solveLogic(1) != null ? 1 : (s.solveLogic(2) != null ? 2 : 3);
      final u = s.solutions(budget: 3000000).length;
      return 't$t u$u r${p.regionCount}';
    });
  }
}
