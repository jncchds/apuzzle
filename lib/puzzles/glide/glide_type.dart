import 'package:flutter/material.dart';

import '../../core/day.dart';
import '../../core/difficulty.dart';
import '../../core/game_controller.dart';
import '../../core/grid.dart';
import '../../core/puzzle_type.dart';
import '../../core/tutorial.dart';
import '../../l10n/l10n.dart';
import 'glide_board.dart';
import 'glide_generator.dart';
import 'glide_model.dart';
import 'glide_solver.dart';
import 'glide_tutorial.dart';

/// Slide the numbered tiles back into order through the one gap.
class GlideType extends PuzzleType<GlidePuzzle, GlideState> {
  const GlideType();

  @override
  String get id => 'glide';
  @override
  String name(AppLocalizations l) => l.glideName;
  @override
  String tagline(AppLocalizations l) => l.glideTagline;
  @override
  IconData get icon => Icons.view_comfy_alt_rounded;
  @override
  Color get accent => GlideBoard.tile;

  @override
  String rulesText(AppLocalizations l) => l.glideRules;

  @override
  List<TutorialStep> tutorial() => glideTutorial;
  @override
  List<TutorialStep> strategies() => glideStrategies;

  @override
  List<GridSize> get sizes => const [
    GridSize.square(3),
    GridSize(4, 3),
    GridSize.square(4),
    GridSize(5, 4),
    GridSize.square(5),
    GridSize(6, 5),
    GridSize.square(6),
  ];
  @override
  GridSize get defaultSize => const GridSize.square(4);
  @override
  GridSize dailySize(Difficulty difficulty) => switch (difficulty) {
    Difficulty.easy => const GridSize(4, 3),
    Difficulty.medium => const GridSize.square(4),
    _ => const GridSize.square(4),
  };
  @override
  Day get dailySince => const Day(2026, 10, 16);
  @override
  bool get dailyOptIn => true;
  @override
  double get minCellSize => 40;
  @override
  double get controlsHeight => 56;
  @override
  bool get showSubmit => false;

  @override
  List<GameOption> optionsFor(Map<String, String> chosen) => const [
    GameOption('goal', ['free', 'moves']),
    GameOption('face', ['num', 'hue']),
  ];

  @override
  String optionLabel(AppLocalizations l, String option) => option == 'face' ? l.glideFace : l.popGoal;

  @override
  String choiceLabel(AppLocalizations l, String option, String choice) => switch (choice) {
    'moves' => l.glideGoalMoves,
    'free' => l.glideGoalFree,
    'num' => l.glideFaceNumbers,
    'hue' => l.glideFaceColors,
    _ => choice,
  };

  @override
  String? choiceDescription(AppLocalizations l, String option, String choice) => switch (choice) {
    'moves' => l.glideGoalMovesHint,
    'free' => l.glideGoalFreeHint,
    'num' => l.glideFaceNumbersHint,
    'hue' => l.glideFaceColorsHint,
    _ => null,
  };

  @override
  GlidePuzzle generate(GenParams params) {
    final options = resolveOptions(params.options);
    return generateGlide(
      rows: params.size.rows,
      cols: params.size.cols,
      difficulty: params.difficulty,
      seed: params.seed,
      limited: options['goal'] == 'moves',
      colors: options['face'] == 'hue',
    );
  }

  @override
  GlideState initialState(GlidePuzzle puzzle) => GlideState.initial(puzzle);
  @override
  bool isComplete(GlidePuzzle puzzle, GlideState state) => state.sorted;
  @override
  bool isSolved(GlidePuzzle puzzle, GlideState state) =>
      state.sorted && (puzzle.limit == null || state.moves <= puzzle.limit!);
  @override
  Set<Pos> conflicts(GlidePuzzle puzzle, GlideState state) => const {};

  @override
  String finishTitle(AppLocalizations l, GlidePuzzle puzzle, GlideState state) =>
      puzzle.optimal && state.moves <= puzzle.best ? l.glideFewest : l.solved;

  /// The next move of the plan while the moves so far follow it, else of a
  /// way out from here. When that no longer fits the moves left, first take
  /// back moves: to the latest point of the path from which the way out
  /// fits, and at least to where the path left the plan.
  @override
  HintResult<GlideState>? hint(GlidePuzzle puzzle, GlideState state) {
    if (state.sorted) return null;
    final solver = GlideSolver.of(puzzle.rows, puzzle.cols);
    HintResult<GlideState> play(GlideState s, String d) {
      final next = glideMove(puzzle, s, d);
      return HintResult(next, {puzzle.size.pos(s.gap)});
    }

    if (puzzle.plan.startsWith(state.path)) return play(state, puzzle.plan[state.moves]);
    final way = solver.solve(state.tiles);
    final limit = puzzle.limit;
    if (limit == null || state.moves + way.length <= limit) return play(state, way[0]);

    var common = 0;
    while (common < state.moves && common < puzzle.plan.length && state.path[common] == puzzle.plan[common]) {
      common++;
    }
    GlideState at(int k) {
      final path = state.path.substring(0, k);
      return GlideState(glideApply(puzzle.rows, puzzle.cols, puzzle.start, path), path);
    }

    bool fits(int k) => k + solver.solve(at(k).tiles).length <= limit;
    var lo = common, hi = state.moves - 1;
    while (lo < hi) {
      final mid = (lo + hi + 1) ~/ 2;
      if (fits(mid)) {
        lo = mid;
      } else {
        hi = mid - 1;
      }
    }
    final back = at(lo);
    final d = lo > common || !puzzle.plan.startsWith(back.path) ? solver.solve(back.tiles)[0] : puzzle.plan[lo];
    final tile = glideStep(puzzle.rows, puzzle.cols, back.gap, d);
    return HintResult(back, {puzzle.size.pos(tile)});
  }

  void _play(GameController ctrl, String? moves) {
    if (moves == null || moves.isEmpty) return;
    final p = ctrl.puzzle as GlidePuzzle;
    final s = ctrl.state as GlideState;
    if (s.sorted) return;
    if (p.limit != null && s.moves + moves.length > p.limit!) {
      ctrl.showToast((l) => l.outOfMoves);
      return;
    }
    final next = GlideState(glideApply(p.rows, p.cols, s.tiles, moves), s.path + moves);
    ctrl.apply(next);
    if (!next.sorted && p.limit != null && next.moves >= p.limit!) ctrl.showToast((l) => l.outOfMoves);
  }

  /// A swipe in [dir] (the way tiles move): from a tile in the gap's line
  /// toward the gap slides that line, any other swipe slides the one tile
  /// that can go that way.
  void _swipe(GameController ctrl, int? cell, String dir) {
    final p = ctrl.puzzle as GlidePuzzle;
    final s = ctrl.state as GlideState;
    final line = cell == null ? null : glideLine(p, s.tiles, cell);
    if (line != null && glideOpposite(line[0]) == dir) {
      _play(ctrl, line);
      return;
    }
    final d = glideOpposite(dir);
    if (glideStep(p.rows, p.cols, s.gap, d) >= 0) _play(ctrl, d);
  }

  @override
  Widget buildBoard(BuildContext context, GameController ctrl) {
    final p = ctrl.puzzle as GlidePuzzle;
    final s = ctrl.state as GlideState;
    final live = !ctrl.solved;
    return GlideBoard(
      rows: p.rows,
      cols: p.cols,
      tiles: s.tiles,
      colors: p.colors,
      hinted: {for (final pos in ctrl.flashHints) p.size.index(pos)},
      win: ctrl.winAnimation,
      onTap: live ? (cell) => _play(ctrl, glideLine(p, s.tiles, cell)) : null,
      onSwipe: live ? (cell, dir) => _swipe(ctrl, cell, dir) : null,
    );
  }

  @override
  Widget? buildControls(BuildContext context, GameController ctrl) {
    final p = ctrl.puzzle as GlidePuzzle;
    final s = ctrl.state as GlideState;
    final theme = Theme.of(context);
    final over = p.limit != null && s.moves >= p.limit! && !s.sorted;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: over ? theme.colorScheme.error : theme.colorScheme.outline, width: 2),
      ),
      child: Text(
        p.limit == null ? context.l10n.glideMoves(s.moves) : context.l10n.movesOfLimit(s.moves, p.limit!),
        style: theme.textTheme.titleMedium?.copyWith(fontFeatures: const [FontFeature.tabularFigures()]),
      ),
    );
  }

  @override
  Map<String, dynamic> encodePuzzle(GlidePuzzle puzzle) => puzzle.toJson();
  @override
  GlidePuzzle decodePuzzle(Map<String, dynamic> json) => GlidePuzzle.fromJson(json);
  @override
  Map<String, dynamic> encodeState(GlideState state) => state.toJson();
  @override
  GlideState decodeState(Map<String, dynamic> json) => GlideState.fromJson(json);
}
