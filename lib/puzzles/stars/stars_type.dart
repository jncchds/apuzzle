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
import '../../ui/board/cell_grid_board.dart';
import '../../ui/board/region_borders.dart';
import '../../ui/symbols.dart';
import 'stars_explain.dart';
import 'stars_generator.dart';
import 'stars_model.dart';
import 'stars_tutorial.dart';

/// Stars: two per row, column and region, never touching.
class StarsType extends ValueGridType<StarsPuzzle> {
  const StarsType();

  @override
  String get id => 'stars';
  @override
  String name(AppLocalizations l) => l.starsName;
  @override
  String tagline(AppLocalizations l) => l.starsTagline;
  @override
  IconData get icon => Icons.star_border_rounded;
  @override
  Color get accent => const Color(0xFFFFD54F);

  @override
  String rulesText(AppLocalizations l) => l.starsRules;

  @override
  List<TutorialStep> tutorial() => starsTutorial;
  @override
  List<TutorialStep> strategies() => starsStrategies;

  @override
  // Two stars per line need 9×9 at least: 8×8 has only two star layouts.
  @override
  List<GridSize> get sizes => const [GridSize.square(9), GridSize.square(10)];
  @override
  GridSize get defaultSize => const GridSize.square(9);
  @override
  GridSize dailySize(Difficulty difficulty) => const GridSize.square(9);
  @override
  Day get dailySince => const Day(2026, 11, 13);

  @override
  List<ValueSpec> get values => [
    ValueSpec.custom(
      (context, size) => DotSymbol(size: size, color: Colors.black54),
      label: 'dot',
    ),
    ValueSpec.custom(
      (context, size) => StarSymbol(size: size * 0.9, color: Colors.black87),
      label: 'star',
    ),
  ];

  @override
  double get gapRatio => 0.06;

  @override
  StarsPuzzle generate(GenParams params) => generateStars(params);

  List<int> _stars(ValueGrid s) => [
    for (var i = 0; i < s.cells.length; i++)
      if (s.cells[i].value == sStar) i,
  ];

  @override
  bool isComplete(StarsPuzzle puzzle, ValueGrid state) => _stars(state).length == puzzle.k * puzzle.n;

  @override
  bool isSolved(StarsPuzzle puzzle, ValueGrid state) {
    final s = _stars(state);
    return s.length == puzzle.k * puzzle.n && starsConflicts(puzzle.n, puzzle.k, puzzle.regions, s).isEmpty;
  }

  @override
  Set<Pos> conflicts(StarsPuzzle puzzle, ValueGrid state) => {
    for (final i in starsConflicts(puzzle.n, puzzle.k, puzzle.regions, _stars(state))) puzzle.size.pos(i),
  };

  @override
  HintResult<ValueGrid>? hint(StarsPuzzle puzzle, ValueGrid state) {
    // Remove a wrong star first, otherwise reveal a missing one.
    for (var i = 0; i < state.cells.length; i++) {
      if (state.cells[i].value == sStar && puzzle.solutionAt(i) != sStar) {
        final p = puzzle.size.pos(i);
        return HintResult(state.set(p, state.cells[i].withValue(sDot)), {p});
      }
    }
    for (final i in puzzle.solution) {
      if (state.cells[i].value != sStar) {
        final p = puzzle.size.pos(i);
        return HintResult(state.set(p, state.cells[i].withValue(sStar)), {p});
      }
    }
    return null;
  }

  /// A star rules out the cells around it, and a row, column or region with
  /// all its stars rules out the rest of it.
  @override
  ValueGrid markForbidden(StarsPuzzle puzzle, ValueGrid state) {
    final n = puzzle.n, stars = _stars(state), around = kingNeighbors(n, n);
    final rows = List<int>.filled(n, 0), cols = List<int>.filled(n, 0), regs = List<int>.filled(n, 0);
    for (final s in stars) {
      rows[s ~/ n]++;
      cols[s % n]++;
      regs[puzzle.regions[s]]++;
    }
    final k = puzzle.k;
    return dotted(state, [
      for (var i = 0; i < n * n; i++)
        if (rows[i ~/ n] >= k ||
            cols[i % n] >= k ||
            regs[puzzle.regions[i]] >= k ||
            stars.any((s) => around[s].contains(i)))
          i,
    ], sDot);
  }

  @override
  Color? cellColor(BuildContext context, StarsPuzzle puzzle, Pos pos, CellValue cell) {
    final base = regionColors[puzzle.regions[puzzle.size.index(pos)] % regionColors.length];
    return Theme.of(context).brightness == Brightness.dark ? Color.lerp(base, Colors.black, 0.12) : base;
  }

  @override
  List<Widget> buildOverlay(BuildContext context, StarsPuzzle puzzle, BoardMetrics m) => [
    RegionBorders(metrics: m, regionOf: (i) => puzzle.regions[i], color: Theme.of(context).colorScheme.onSurface),
  ];

  @override
  bool get canExplain => true;

  @override
  Explanation? explain(StarsPuzzle puzzle, ValueGrid state) => explainStep(const StarsExplainer(), puzzle, state);

  @override
  Map<String, dynamic> encodePuzzle(StarsPuzzle puzzle) => puzzle.toJson();
  @override
  StarsPuzzle decodePuzzle(Map<String, dynamic> json) => StarsPuzzle.fromJson(json);
}
