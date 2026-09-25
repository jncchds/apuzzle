import 'package:apuzzle/core/difficulty.dart';
import 'package:apuzzle/core/grid.dart';
import 'package:apuzzle/core/grid_graph.dart';
import 'package:apuzzle/puzzles/mines/mines_generator.dart';
import 'package:apuzzle/puzzles/mines/mines_model.dart';
import 'package:apuzzle/puzzles/mines/mines_solver.dart';
import 'package:flutter_test/flutter_test.dart';

/// Plays [p] from its opened cells with [tier] logic; true if it clears the board.
bool playsThrough(MinesPuzzle p, int tier) {
  final counts = mineCounts(p);
  final kn = kingNeighbors(p.rows, p.cols);
  final s = MinesSolver(p.rows, p.cols, counts, p.mineCount);
  final open = List.of(p.opened);
  final k = s.knowledge(open);
  while (!minesCleared(p, open)) {
    expect(s.deduce(open, k, tier), isTrue);
    for (var i = 0; i < k.length; i++) {
      if (k[i] == 1) expect(p.mines[i], isTrue);
      if (k[i] == 0) expect(p.mines[i], isFalse);
    }
    final fresh = [for (var i = 0; i < k.length; i++) if (k[i] == 0 && !open[i]) i];
    if (fresh.isEmpty) return false;
    openCells(open, fresh, p.mines, counts, kn);
    for (var i = 0; i < k.length; i++) {
      if (open[i]) k[i] = 0;
    }
  }
  return true;
}

void main() {
  for (final size in [const GridSize.square(6), const GridSize.square(8), const GridSize(10, 8), const GridSize(14, 10)]) {
    for (final d in [Difficulty.easy, Difficulty.medium, Difficulty.hard]) {
      test('mines ${size.label} ${d.name}: no guessing, deterministic, fast', () {
        final info = <String>[];
        for (var seed = 1; seed <= 4; seed++) {
          final params = GenParams(size: size, difficulty: d, seed: seed);
          final sw = Stopwatch()..start();
          final p = generateMines(params);
          sw.stop();
          for (var i = 0; i < p.mines.length; i++) {
            if (p.opened[i]) expect(p.mines[i], isFalse);
          }
          expect(playsThrough(p, minesTier(d)), isTrue);
          expect(generateMines(params).toJson(), p.toJson());
          expect(sw.elapsedMilliseconds, lessThan(3000));
          info.add('${sw.elapsedMilliseconds}ms m${p.mineCount} o${p.opened.where((o) => o).length}');
        }
        // ignore: avoid_print
        print('mines ${size.label} ${d.name}: $info');
      });
    }
  }
}
