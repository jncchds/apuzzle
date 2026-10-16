import 'package:apuzzle/core/puzzle_code.dart';
import 'package:apuzzle/core/registry.dart';
import 'package:apuzzle/puzzles/rampart/rampart_generator.dart';
import 'package:apuzzle/puzzles/rampart/rampart_model.dart';
import 'package:apuzzle/puzzles/rampart/rampart_solver.dart';
import 'package:flutter_test/flutter_test.dart';

// No dart:io here, so this also runs on the web, where these codes once
// failed to generate (`flutter test --platform chrome <this file>`).
void main() {
  for (final code in ['rampart-7x7-medium-7F0Z5B-v1', 'rampart-7x7-medium-ME44M7-v1']) {
    test('$code generates a valid, unique board at its tier', () {
      final params = PuzzleCode.parse(code, puzzleTypes).params;
      final p = generateRampart(params);
      expect(rampartConflicts(p, p.shaded, complete: true), isEmpty);
      final s = RampartSolver(p);
      expect(s.grade(), rampartTier(params.difficulty));
      expect(s.countSolutions(), 1);
    });
  }
}
