import 'dart:math';

import 'package:flutter/material.dart';

import '../../core/day.dart';
import '../../core/difficulty.dart';
import '../../core/explain.dart';
import '../../core/grid.dart';
import '../../core/puzzle_type.dart';
import '../../core/tutorial.dart';
import '../../core/value_grid.dart';
import '../../l10n/l10n.dart';
import '../../ui/symbols.dart';
import 'rampart_explain.dart';
import 'rampart_generator.dart';
import 'rampart_model.dart';
import 'rampart_tutorial.dart';

/// Rampart: shade one connected wall that fits the clues around it.
class RampartType extends ValueGridType<RampartPuzzle> {
  const RampartType();

  static const shadeLight = Color(0xFF5A4636);
  static const shadeDark = Color(0xFF9A7F66);

  static Color shadeColor(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? shadeDark : shadeLight;

  @override
  String get id => 'rampart';
  @override
  String name(AppLocalizations l) => l.rampartName;
  @override
  String tagline(AppLocalizations l) => l.rampartTagline;
  @override
  IconData get icon => Icons.fort_rounded;
  @override
  Color get accent => const Color(0xFFC79A6B);

  @override
  String rulesText(AppLocalizations l) => l.rampartRules;

  @override
  List<TutorialStep> tutorial() => rampartTutorial;
  @override
  List<TutorialStep> strategies() => rampartStrategies;

  @override
  List<GridSize> get sizes => [for (var n = 5; n <= 10; n++) GridSize.square(n)];
  @override
  GridSize get defaultSize => const GridSize.square(7);
  @override
  GridSize dailySize(Difficulty difficulty) => switch (difficulty) {
    Difficulty.easy => const GridSize.square(6),
    Difficulty.medium => const GridSize.square(8),
    _ => const GridSize.square(9),
  };
  @override
  Day get dailySince => const Day(2026, 10, 16);
  @override
  double get minCellSize => 32;

  @override
  List<ValueSpec> get values => [
    ValueSpec.custom(
      (context, size) => Container(
        width: size * 0.7,
        height: size * 0.7,
        decoration: BoxDecoration(color: shadeColor(context), borderRadius: BorderRadius.circular(size * 0.12)),
      ),
      label: 'shade',
    ),
    ValueSpec.custom((context, size) => DotSymbol(size: size), label: 'keep'),
  ];

  @override
  bool get showLockIcon => false;
  @override
  double get gapRatio => 0.05;

  @override
  RampartPuzzle generate(GenParams params) => generateRampart(params);

  List<bool> _shaded(ValueGrid s) => [for (final c in s.cells) c.value == rampartShade];

  /// A clue is met once the shaded cells round it make it; with none of
  /// them shaded (a 0), only once every cell round it is filled.
  bool _met(RampartPuzzle p, ValueGrid s, int i) {
    final shaded = _shaded(s);
    final mask = rampartRingMask(p.n, i, (j) => shaded[j]);
    if (rampartRuns(mask).join(' ') != p.clues[i]!.join(' ')) return false;
    return mask != 0 || rampartRingOf(p.n)[i].every((j) => j < 0 || s.cells[j].value != null);
  }

  @override
  Widget buildValue(BuildContext context, RampartPuzzle puzzle, ValueGrid state, Pos pos, CellValue cell, double size) {
    final i = puzzle.size.index(pos);
    final clue = puzzle.clues[i];
    if (clue == null) {
      if (cell.value == rampartShade) return const SizedBox.shrink();
      return super.buildValue(context, puzzle, state, pos, cell, size);
    }
    final style = Theme.of(context).textTheme.bodyMedium!.copyWith(
      fontSize: size * (clue.length == 1 ? 0.52 : 0.36),
      height: 1,
      fontWeight: FontWeight.w700,
      color: Theme.of(context).colorScheme.onSurface,
    );
    // One number in the middle, two on a diagonal, three in a triangle, four in the corners.
    final spots = switch (clue.length) {
      1 => const [Alignment.center],
      2 => const [Alignment(-0.55, -0.55), Alignment(0.55, 0.55)],
      3 => const [Alignment(-0.6, -0.6), Alignment(0.6, -0.6), Alignment(0, 0.65)],
      _ => const [Alignment(-0.6, -0.6), Alignment(0.6, -0.6), Alignment(-0.6, 0.65), Alignment(0.6, 0.65)],
    };
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 200),
      opacity: _met(puzzle, state, i) ? 0.35 : 1,
      child: SizedBox.square(
        dimension: size * 0.86,
        child: Stack(
          children: [
            for (var k = 0; k < clue.length; k++)
              Align(
                alignment: spots[k],
                child: Text('${clue[k]}', style: style),
              ),
          ],
        ),
      ),
    );
  }

  @override
  Color? cellColor(BuildContext context, RampartPuzzle puzzle, Pos pos, CellValue cell) =>
      cell.value == rampartShade ? shadeColor(context) : null;

  /// The wall is built bit by bit, so it is only complete once joined:
  /// otherwise every clue met early would read as a wrong answer.
  @override
  bool isComplete(RampartPuzzle puzzle, ValueGrid state) =>
      rampartConflicts(puzzle, _shaded(state), complete: true).isEmpty;

  @override
  bool isSolved(RampartPuzzle puzzle, ValueGrid state) =>
      rampartConflicts(puzzle, _shaded(state), complete: true).isEmpty;

  /// Until every cell is filled and the board complete, only dotted cells
  /// count as staying (an empty cell may still join the wall).
  @override
  Set<Pos> conflicts(RampartPuzzle puzzle, ValueGrid state) => {
    for (final i in rampartConflicts(
      puzzle,
      _shaded(state),
      kept: state.cells.every((c) => c.value != null) && isComplete(puzzle, state)
          ? null
          : [for (final c in state.cells) c.value == rampartKeep],
      complete: true,
    ))
      puzzle.size.pos(i),
  };

  /// Fixes a wrong entry, else shades a missing cell: dots are optional.
  @override
  HintResult<ValueGrid>? hint(RampartPuzzle puzzle, ValueGrid state) {
    final wrong = <int>[], missing = <int>[];
    for (var i = 0; i < state.cells.length; i++) {
      final v = state.cells[i].value;
      if (v != null && v != puzzle.solutionAt(i)) wrong.add(i);
      if (v == null && puzzle.shaded[i]) missing.add(i);
    }
    final pool = wrong.isNotEmpty ? wrong : missing;
    if (pool.isEmpty) return null;
    final i = pool[Random().nextInt(pool.length)];
    final pos = puzzle.size.pos(i);
    return HintResult(state.set(pos, state.cells[i].withValue(puzzle.solutionAt(i))), {pos});
  }

  /// Dots the last cell of a 2×2 block with three shaded, and the cells
  /// round a clue the shaded cells already make.
  @override
  ValueGrid markForbidden(RampartPuzzle puzzle, ValueGrid state) {
    final n = puzzle.n;
    final shaded = _shaded(state);
    final dots = <int>{};
    for (final b in rampartBlocks(n)) {
      final open = [b, b + 1, b + n, b + n + 1].where((j) => !shaded[j]).toList();
      if (open.length == 1) dots.add(open.first);
    }
    for (var i = 0; i < n * n; i++) {
      final clue = puzzle.clues[i];
      if (clue == null || rampartRuns(rampartRingMask(n, i, (j) => shaded[j])).join(' ') != clue.join(' ')) continue;
      dots.addAll(rampartRingOf(n)[i].where((j) => j >= 0));
    }
    return dotted(state, dots.where((i) => !shaded[i] && puzzle.clues[i] == null).toSet(), rampartKeep);
  }

  @override
  bool get canExplain => true;

  @override
  Explanation? explain(RampartPuzzle puzzle, ValueGrid state) => explainStep(const RampartExplainer(), puzzle, state);

  @override
  Map<String, dynamic> encodePuzzle(RampartPuzzle puzzle) => puzzle.toJson();
  @override
  RampartPuzzle decodePuzzle(Map<String, dynamic> json) => RampartPuzzle.fromJson(json);
}
