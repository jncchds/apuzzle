import 'package:apuzzle/core/difficulty.dart';
import 'package:apuzzle/core/explain.dart';
import 'package:apuzzle/core/grid.dart';
import 'package:apuzzle/core/registry.dart';
import 'package:apuzzle/core/value_grid.dart';
import 'package:apuzzle/core/lattice_loop.dart';
import 'package:apuzzle/l10n/l10n.dart';
import 'package:apuzzle/puzzles/arrows/arrows_model.dart';
import 'package:apuzzle/puzzles/atoms/atoms_model.dart';
import 'package:apuzzle/puzzles/links/links_model.dart';
import 'package:apuzzle/puzzles/mines/mines_model.dart';
import 'package:apuzzle/puzzles/shikaku/shikaku_model.dart';
import 'package:apuzzle/puzzles/trail/trail_model.dart';
import 'package:apuzzle/puzzles/rails/rails_model.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

/// Every text of [e] in [l], to check the templates.
Iterable<String> texts(Explanation e, AppLocalizations l) => [
  e.headline.text(l),
  for (final x in e.why) x.text(l),
  ?e.suppose?.text(l),
  for (final x in e.probe) x.text(l),
];

List<int> marksOf(Object s) => switch (s) {
  LoopMarks() => s.marks,
  RailsState() => s.marks,
  ArrowsState() => s.marks,
  _ => throw ArgumentError(s),
};

Object withMark(Object s, int e, int m) => switch (s) {
  LoopMarks() => LoopMarks(List.of(s.marks)..[e] = m),
  RailsState() => RailsState(List.of(s.marks)..[e] = m, s.cells),
  ArrowsState() => ArrowsState(List.of(s.marks)..[e] = m, s.cells),
  _ => throw ArgumentError(s),
};

/// A board with one wrong entry, for the types that aren't value grids or
/// loops of edge marks.
Object? wrongOther(Object puzzle, Object start) {
  switch ((puzzle, start)) {
    case (final MinesPuzzle p, final MinesState s):
      final i = [
        for (var i = 0; i < p.mines.length; i++)
          if (!p.mines[i] && !s.open[i]) i,
      ].first;
      return MinesState(open: s.open, flags: List.of(s.flags)..[i] = true);
    case (final ShikakuPuzzle p, final ShikakuState s):
      const r = CellRect(0, 0, 0, 0);
      return p.solution.contains(r) ? null : ShikakuState([...s.rects, r]);
    case (final AtomsPuzzle p, final AtomsState s):
      final e = p.solution.indexWhere((b) => b < 2);
      return AtomsState(List.of(s.bonds)..[e] = p.solution[e] + 1);
    case (final TrailPuzzle p, TrailState _):
      final start = p.startCell, cols = p.cols;
      final next = [start + 1, start - 1, start + cols, start - cols].firstWhere(
        (j) => j >= 0 && j < p.rows * cols && trailAdjacent(start, j, cols) && j != p.solution[1],
      );
      return TrailState([start, next]);
    case (final LinksPuzzle p, final LinksState s):
      final path = p.paths.first;
      final g = LatticeLoop(p.rows, p.cols);
      final wrong = [
        for (final e in g.incident[path.first]) ...[g.ends(e).$1, g.ends(e).$2],
      ].firstWhere((j) => j != path.first && j != path[1]);
      return LinksState([
        [path.first, wrong],
        ...s.paths.skip(1),
      ]);
  }
  return null;
}

void checkText(String text) {
  expect(text.trim(), isNotEmpty);
  expect(text.contains('{') || text.contains('}'), isFalse, reason: text);
  final stripped = text.replaceAll(RegExp(r'⟦[a-z]:[-0-9:]*⟧'), '');
  expect(stripped.contains('⟦') || stripped.contains('⟧'), isFalse, reason: text);
}

void main() {
  late final Map<String, AppLocalizations> langs;

  setUpAll(() async {
    langs = {for (final code in appLanguages.keys) code: await AppLocalizations.delegate.load(Locale(code))};
  });

  final types = [
    for (final t in puzzleTypes)
      if (t.canExplain) t,
  ];

  for (final type in types) {
    group(type.id, () {
      for (final size in type.sizes) {
        for (final d in type.difficulties) {
          test('${size.rows}x${size.cols} ${d.name}: explained steps solve the board', () {
            for (var seed = 1; seed <= 4; seed++) {
              final puzzle = type.generate(GenParams(size: size, difficulty: d, seed: seed)) as Object;
              var state = type.initialState(puzzle) as Object;
              var steps = 0, probes = 0;
              while (!(type.isComplete(puzzle, state) && type.isSolved(puzzle, state))) {
                final e = type.explain(puzzle, state);
                expect(e, isNotNull, reason: 'stuck at step $steps (seed $seed)');
                expect(e!.fallback, isFalse, reason: 'no logic at step $steps (seed $seed)');
                expect(e.fix, isFalse);
                expect(e.next, isNotNull);
                expect(e.targets, isNotEmpty);
                if (e.suppose != null) {
                  probes++;
                  expect(e.probe, isNotEmpty, reason: 'a probe ends in a contradiction');
                }
                if (steps < 6 || e.suppose != null && probes < 3) {
                  for (final l in langs.values) {
                    texts(e, l).forEach(checkText);
                  }
                }
                state = e.next!;
                expect(++steps, lessThan(2000));
              }
              expect(type.explain(puzzle, state), isNull);
            }
          });
        }
      }

      test('a wrong entry is fixed first', () {
        final puzzle = type.generate(GenParams(size: type.defaultSize, difficulty: Difficulty.easy, seed: 7)) as Object;
        final start = type.initialState(puzzle) as Object;
        final e = type.explain(puzzle, start)!;
        if (e.edges.isNotEmpty) {
          // Loops: flip the first step's edge the wrong way.
          final edge = e.edges.first;
          final want = marksOf(e.next!)[edge];
          final bad = withMark(start, edge, want == 1 ? 2 : 1);
          final fix = type.explain(puzzle, bad)!;
          expect(fix.fix, isTrue);
          expect(marksOf(fix.next!)[edge], 0);
          return;
        }
        if (wrongOther(puzzle, start) case final bad?) {
          final fix = type.explain(puzzle, bad)!;
          expect(fix.fix, isTrue, reason: 'the wrong entry is fixed first');
          expect(type.explain(puzzle, fix.next!)!.fix, isFalse);
          return;
        }
        if (start is! ValueGrid || puzzle is! ValueGridPuzzle) return;
        // Put a wrong value where the first step would go.
        final i = start.size.index(e.targets.first);
        final wrongValue = (puzzle.solutionAt(i) + 1) % (type as ValueGridType).valuesFor(puzzle).length;
        final bad = start.set(e.targets.first, start.cells[i].withValue(wrongValue));
        final fix = type.explain(puzzle, bad)!;
        expect(fix.fix, isTrue);
        expect(fix.targets, {e.targets.first});
        expect((fix.next! as ValueGrid).cells[i].value, isNull);
      });
    });
  }

  // Tutorial and strategy boards are hand-made or pinned. Value-grid ones
  // have one answer (tutorial_test), so logic carries them to the end; other
  // small boards may have more answers, or teach a move rather than a
  // deduction, so there a step may come from the solution.
  for (final type in types) {
    test('${type.id}: tutorial and strategy boards are explained to the end', () {
      for (final step in [...type.tutorial(), ...type.strategies()]) {
        if (step.openEnded) continue;
        final puzzle = step.puzzle;
        var state = step.state ?? type.initialState(puzzle) as Object;
        for (var k = 0; k < 500 && !(type.isComplete(puzzle, state) && type.isSolved(puzzle, state)); k++) {
          final e = type.explain(puzzle, state);
          if (e == null) break;
          if (type is ValueGridType) {
            expect(e.fallback, isFalse, reason: 'no logic at step $k of ${step.text(langs['en']!)}');
          }
          state = e.next!;
        }
        expect(type.isComplete(puzzle, state) && type.isSolved(puzzle, state), isTrue);
      }
    });
  }

  test('tokens parse into chips', () {
    final parts = parseExplainText('${cellTok(const Pos(3, 4))} and row ${rowTok(1)}, ${valTok(2)}.');
    expect(parts.whereType<ExplainChip>().map((c) => c.label), ['E4', '2', '']);
    expect(parts.whereType<ExplainWords>().map((w) => w.text), [' and row ', ', ', '.']);
  });
}
