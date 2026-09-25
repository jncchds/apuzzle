import 'package:apuzzle/core/puzzle_type.dart';
import 'package:apuzzle/core/registry.dart';
import 'package:apuzzle/core/tutorial.dart';
import 'package:apuzzle/core/value_grid.dart';
import 'package:apuzzle/l10n/l10n.dart';
import 'package:apuzzle/puzzles/pop/pop_model.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

/// Plays [type]'s hints from [state] until the board is solved (or stuck).
Object playHints(PuzzleType type, Object puzzle, Object state) {
  for (var k = 0; k < 400; k++) {
    if (type.isComplete(puzzle, state) && type.isSolved(puzzle, state)) return state;
    final h = type.hint(puzzle, state);
    if (h == null) return state;
    var next = h.state as Object;
    // Pointer-only hints (Pop): play the pointed-at group.
    if (puzzle is PopPuzzle) next = popAt(puzzle, state as PopState, puzzle.size.index(h.cells.first))!;
    state = next;
  }
  return state;
}

/// Solutions of a value-grid step: ways to fill its empty cells that solve
/// the board, found by backtracking (a partial grid with rule conflicts is a
/// dead end). Stops at [limit]; null when the search is too big to finish.
int? countFillings(ValueGridType type, ValueGridPuzzle puzzle, ValueGrid start, {int limit = 2}) {
  final empty = [for (var i = 0; i < start.cells.length; i++) if (start.cells[i].value == null) i];
  final n = type.valuesFor(puzzle).length;
  final cells = List.of(start.cells);
  var found = 0, nodes = 0;
  bool search(int k) {
    if (++nodes > 300000) return false;
    final s = ValueGrid(start.size, List.of(cells));
    if (type.conflicts(puzzle, s).isNotEmpty) return true;
    if (k == empty.length) {
      if (type.isComplete(puzzle, s) && type.isSolved(puzzle, s)) found++;
      return true;
    }
    for (var v = 0; v < n && found < limit; v++) {
      cells[empty[k]] = CellValue(value: v);
      if (!search(k + 1)) return false;
    }
    cells[empty[k]] = const CellValue();
    return true;
  }

  return search(0) ? found : null;
}

void main() {
  late final Map<String, AppLocalizations> langs;

  setUpAll(() async {
    langs = {for (final code in appLanguages.keys) code: await AppLocalizations.delegate.load(Locale(code))};
  });

  test('every puzzle type has a tutorial', () {
    for (final t in puzzleTypes) {
      expect(t.tutorial(), isNotEmpty, reason: t.id);
    }
  });

  for (final type in puzzleTypes) {
    group('${type.id} tutorial', () {
      final steps = type.tutorial();
      for (var k = 0; k < steps.length; k++) {
        final TutorialStep step = steps[k];
        test('step ${k + 1}', () {
          for (final l in langs.values) {
            expect(step.text(l), isNotEmpty);
          }
          final puzzle = step.puzzle;
          // Boards survive (de)serialization like real ones.
          final json = type.encodePuzzle(puzzle);
          expect(type.encodePuzzle(type.decodePuzzle(json)), json);
          final start = step.state ?? type.initialState(puzzle) as Object;
          type.encodeState(start);

          if (step.look) return;
          if (step.done case final done?) {
            expect(done(start), isFalse, reason: 'already done at the start');
            expect(done(step.answer!), isTrue, reason: 'the answer does not meet the goal');
            return;
          }
          expect(type.isComplete(puzzle, start) && type.isSolved(puzzle, start), isFalse, reason: 'solved at the start');
          final end = playHints(type, puzzle, start);
          expect(type.isComplete(puzzle, end) && type.isSolved(puzzle, end), isTrue, reason: '"Show me" does not solve it');
          if (type is ValueGridType && !step.openEnded) {
            // Big generated boards are unique by construction (their own tests).
            final count = countFillings(type, puzzle as ValueGridPuzzle, start as ValueGrid);
            if (count != null) expect(count, 1, reason: 'not exactly one solution');
          }
        });
      }
    });
  }
}
