import 'dart:math';

import 'package:flutter/material.dart';

import '../../core/day.dart';
import '../../core/difficulty.dart';
import '../../core/explain.dart';
import '../../core/grid.dart';
import '../../core/grid_graph.dart';
import '../../core/puzzle_type.dart';
import '../../core/tutorial.dart';
import '../../core/value_grid.dart';
import '../../l10n/l10n.dart';
import '../../ui/symbols.dart';
import 'slabs_explain.dart';
import 'slabs_generator.dart';
import 'slabs_model.dart';
import 'slabs_tutorial.dart';

/// Slabs: shade cells so shaded areas are rectangles and unshaded ones aren't.
class SlabsType extends ValueGridType<SlabsPuzzle> {
  const SlabsType();

  static const shadeLight = Color(0xFF6B4A2E);
  static const shadeDark = Color(0xFFA9794F);

  static Color shadeColor(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? shadeDark : shadeLight;

  @override
  String get id => 'slabs';
  @override
  String name(AppLocalizations l) => l.slabsName;
  @override
  String tagline(AppLocalizations l) => l.slabsTagline;
  @override
  IconData get icon => Icons.dashboard_rounded;
  @override
  Color get accent => const Color(0xFFD9A066);

  @override
  String rulesText(AppLocalizations l) => l.slabsRules;

  @override
  List<TutorialStep> tutorial() => slabsTutorial;
  @override
  List<TutorialStep> strategies() => slabsStrategies;

  @override
  List<GridSize> get sizes => [for (var n = 5; n <= 10; n++) GridSize.square(n)];
  @override
  GridSize get defaultSize => const GridSize.square(7);
  @override
  GridSize dailySize(Difficulty difficulty) => switch (difficulty) {
    Difficulty.easy => const GridSize.square(6),
    Difficulty.medium => const GridSize.square(7),
    _ => const GridSize.square(8),
  };
  @override
  Day get dailySince => const Day(2026, 11, 12);
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
  SlabsPuzzle generate(GenParams params) => generateSlabs(params);

  List<bool> _shaded(ValueGrid s) => [for (final c in s.cells) c.value == slabsShade];

  /// A number is met once the area holding it (shaded, or the rest) has
  /// that many cells.
  bool _met(SlabsPuzzle p, ValueGrid s, int i) {
    final shaded = _shaded(s);
    final nb = orthNeighbors(p.n, p.n);
    final seen = {i};
    final queue = [i];
    for (var k = 0; k < queue.length; k++) {
      for (final j in nb[queue[k]]) {
        if (shaded[j] == shaded[i] && seen.add(j)) queue.add(j);
      }
    }
    return queue.length == p.clues[i];
  }

  Widget _number(
    BuildContext context,
    SlabsPuzzle puzzle,
    int clue,
    double size, {
    required bool onShade,
    bool met = false,
  }) => AnimatedOpacity(
    duration: const Duration(milliseconds: 200),
    opacity: met ? 0.4 : 1,
    child: Text(
      '$clue',
      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
        fontSize: size * (clue >= 10 ? 0.44 : 0.52),
        height: 1,
        fontWeight: FontWeight.w700,
        color: onShade ? Colors.white : Theme.of(context).colorScheme.onSurface,
      ),
    ),
  );

  @override
  Widget buildValue(BuildContext context, SlabsPuzzle puzzle, ValueGrid state, Pos pos, CellValue cell, double size) {
    final i = puzzle.size.index(pos);
    final clue = puzzle.clues[i];
    final shade = cell.value == slabsShade;
    if (clue == null) {
      if (shade) return const SizedBox.shrink();
      return super.buildValue(context, puzzle, state, pos, cell, size);
    }
    final number = _number(context, puzzle, clue, size, onShade: shade, met: _met(puzzle, state, i));
    if (shade) return number;
    // A dotted number: the dot sits below it.
    return Stack(
      alignment: Alignment.center,
      children: [
        number,
        Positioned(
          bottom: size * 0.04,
          child: DotSymbol(size: size * 0.45),
        ),
      ],
    );
  }

  @override
  Widget? buildEmpty(BuildContext context, SlabsPuzzle puzzle, Pos pos, double size) {
    final clue = puzzle.clues[puzzle.size.index(pos)];
    return clue == null ? null : _number(context, puzzle, clue, size, onShade: false);
  }

  @override
  Color? cellColor(BuildContext context, SlabsPuzzle puzzle, Pos pos, CellValue cell) =>
      cell.value == slabsShade ? shadeColor(context) : null;

  /// As many shaded cells as the solution, or every cell filled.
  @override
  bool isComplete(SlabsPuzzle puzzle, ValueGrid state) =>
      state.isFull || state.cells.where((c) => c.value == slabsShade).length == puzzle.shadedCount;

  @override
  bool isSolved(SlabsPuzzle puzzle, ValueGrid state) => slabsValid(puzzle, _shaded(state));

  /// Before the board is complete only what more cells can't mend.
  @override
  Set<Pos> conflicts(SlabsPuzzle puzzle, ValueGrid state) {
    final complete = isComplete(puzzle, state);
    return {
      for (final i in slabsConflicts(
        puzzle,
        _shaded(state),
        kept: complete ? null : [for (final c in state.cells) c.value == slabsKeep],
        complete: complete,
      ))
        puzzle.size.pos(i),
    };
  }

  /// Fixes a wrong entry, else shades a missing cell: dots are optional.
  @override
  HintResult<ValueGrid>? hint(SlabsPuzzle puzzle, ValueGrid state) {
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

  /// Dots the cells beside every shaded rectangle that has its number of cells.
  @override
  ValueGrid markForbidden(SlabsPuzzle puzzle, ValueGrid state) {
    final n = puzzle.n;
    final nb = orthNeighbors(n, n);
    final shaded = _shaded(state);
    final dots = <int>{};
    for (final area in components(nb, (i) => shaded[i])) {
      final nums = {
        for (final i in area)
          if (puzzle.clues[i] != null) puzzle.clues[i]!,
      };
      if (nums.length == 1 && nums.first == area.length && slabsIsRect(n, area)) {
        for (final i in area) {
          dots.addAll(nb[i].where((j) => !shaded[j]));
        }
      }
    }
    return dotted(state, dots, slabsKeep);
  }

  @override
  bool get canExplain => true;

  @override
  Explanation? explain(SlabsPuzzle puzzle, ValueGrid state, {Set<int> prefer = const {}}) =>
      explainStep(const SlabsExplainer(), puzzle, state, prefer: prefer);

  @override
  Map<String, dynamic> encodePuzzle(SlabsPuzzle puzzle) => puzzle.toJson();
  @override
  SlabsPuzzle decodePuzzle(Map<String, dynamic> json) => SlabsPuzzle.fromJson(json);
}
