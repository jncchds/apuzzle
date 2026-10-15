import 'package:flutter/material.dart';

import '../../core/day.dart';
import '../../core/difficulty.dart';
import '../../core/game_controller.dart';
import '../../core/grid.dart';
import '../../core/puzzle_type.dart';
import '../../core/tutorial.dart';
import '../../l10n/l10n.dart';
import '../../ui/board/cell_grid_board.dart';
import 'nightfall_generator.dart';
import 'nightfall_model.dart';
import 'nightfall_tutorial.dart';

/// Put every light out: a tap flips a cell and its side neighbours.
class NightfallType extends PuzzleType<NightfallPuzzle, NightfallState> {
  const NightfallType();

  static const glow = Color(0xFFFFC857);
  static const _glowCore = Color(0xFFFFF1B8);

  @override
  String get id => 'nightfall';
  @override
  String name(AppLocalizations l) => l.nightfallName;
  @override
  String tagline(AppLocalizations l) => l.nightfallTagline;
  @override
  IconData get icon => Icons.nights_stay_rounded;
  @override
  Color get accent => glow;

  @override
  String rulesText(AppLocalizations l) => l.nightfallRules;

  @override
  List<TutorialStep> tutorial() => nightfallTutorial;
  @override
  List<TutorialStep> strategies() => nightfallStrategies;

  @override
  List<GridSize> get sizes => [for (var n = 4; n <= 10; n++) GridSize.square(n)];
  @override
  GridSize get defaultSize => const GridSize.square(5);
  @override
  GridSize dailySize(Difficulty difficulty) => switch (difficulty) {
    Difficulty.easy => const GridSize.square(5),
    Difficulty.medium => const GridSize.square(6),
    _ => const GridSize.square(7),
  };
  @override
  Day get dailySince => const Day(2026, 10, 16);
  @override
  bool get dailyOptIn => true;
  @override
  double get controlsHeight => 56;
  @override
  bool get showSubmit => false;

  @override
  List<GameOption> optionsFor(Map<String, String> chosen) => const [
    GameOption('goal', ['moves', 'free']),
    GameOption('edges', ['flat', 'wrap']),
  ];

  @override
  String optionLabel(AppLocalizations l, String option) => option == 'edges' ? l.nightfallEdges : l.popGoal;

  @override
  String choiceLabel(AppLocalizations l, String option, String choice) => switch (choice) {
    'moves' => l.nightfallGoalMoves,
    'free' => l.nightfallGoalFree,
    'flat' => l.nightfallEdgesFlat,
    'wrap' => l.nightfallEdgesWrap,
    _ => choice,
  };

  @override
  String? choiceDescription(AppLocalizations l, String option, String choice) => switch (choice) {
    'moves' => l.nightfallGoalMovesHint,
    'free' => l.nightfallGoalFreeHint,
    'flat' => l.nightfallEdgesFlatHint,
    'wrap' => l.nightfallEdgesWrapHint,
    _ => null,
  };

  @override
  NightfallPuzzle generate(GenParams params) {
    final options = resolveOptions(params.options);
    return generateNightfall(
      rows: params.size.rows,
      cols: params.size.cols,
      difficulty: params.difficulty,
      seed: params.seed,
      wrap: options['edges'] == 'wrap',
      limited: options['goal'] == 'moves',
    );
  }

  @override
  NightfallState initialState(NightfallPuzzle puzzle) => NightfallState.initial(puzzle);
  @override
  bool isComplete(NightfallPuzzle puzzle, NightfallState state) => state.dark;
  @override
  bool isSolved(NightfallPuzzle puzzle, NightfallState state) =>
      state.dark && (puzzle.limit == null || state.moves <= puzzle.limit!);
  @override
  Set<Pos> conflicts(NightfallPuzzle puzzle, NightfallState state) => const {};

  @override
  String finishTitle(AppLocalizations l, NightfallPuzzle puzzle, NightfallState state) =>
      state.moves <= puzzle.best ? l.nightfallFewest : l.solved;

  /// A tap of a fewest-taps way out from here. When that no longer fits the
  /// moves left, first take back the taps that no best way within the limit
  /// keeps (the order of taps never matters).
  @override
  HintResult<NightfallState>? hint(NightfallPuzzle puzzle, NightfallState state) {
    if (state.dark) return null;
    final g = NightfallGeometry.of(puzzle.rows, puzzle.cols, puzzle.wrap);
    final need = g.fewest(state.on);
    if (need == null) return null;
    final left = puzzle.limit == null ? null : puzzle.limit! - state.moves;
    if (left == null || need.where((b) => b).length <= left) {
      final i = need.indexOf(true);
      return HintResult(nightfallTap(puzzle, state, i), {puzzle.size.pos(i)});
    }
    final target = g.fewest(puzzle.start, keep: state.pressed, within: puzzle.limit)!;
    final kept = [for (var i = 0; i < target.length; i++) state.pressed[i] && target[i]];
    final rewound = NightfallState(
      nightfallLights(g, puzzle.start, kept),
      kept,
      kept.where((b) => b).length,
    );
    final next = [for (var i = 0; i < target.length; i++) target[i] && !kept[i]].indexOf(true);
    return HintResult(rewound, {if (next >= 0) puzzle.size.pos(next)});
  }

  void _tap(GameController ctrl, int i) {
    final p = ctrl.puzzle as NightfallPuzzle;
    final s = ctrl.state as NightfallState;
    if (s.dark) return;
    if (p.limit != null && s.moves >= p.limit!) {
      ctrl.showToast((l) => l.outOfMoves);
      return;
    }
    final next = nightfallTap(p, s, i);
    ctrl.apply(next);
    if (!next.dark && p.limit != null && next.moves >= p.limit!) ctrl.showToast((l) => l.outOfMoves);
  }

  @override
  Widget buildBoard(BuildContext context, GameController ctrl) {
    final p = ctrl.puzzle as NightfallPuzzle;
    final s = ctrl.state as NightfallState;
    final scheme = Theme.of(context).colorScheme;
    final dark = Theme.of(context).brightness == Brightness.dark;
    final off = dark ? const Color(0xFF232838) : const Color(0xFF3A4152);
    return CellGridBoard(
      rows: p.rows,
      cols: p.cols,
      gapRatio: 0.12,
      maxCell: 80,
      win: ctrl.winAnimation,
      onTap: ctrl.solved ? null : (pos) => _tap(ctrl, p.size.index(pos)),
      cellBuilder: (context, pos, m) {
        final lit = s.on[p.size.index(pos)];
        final flagged = ctrl.flashHints.contains(pos);
        final radius = BorderRadius.circular(m.cell * 0.16);
        return AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOutCubic,
          decoration: BoxDecoration(
            borderRadius: radius,
            color: lit ? glow : off,
            gradient: lit ? const RadialGradient(colors: [_glowCore, glow], radius: 0.75) : null,
            border: Border.all(
              color: flagged ? scheme.onSurface : (lit ? glow : Colors.white.withValues(alpha: dark ? 0.06 : 0.1)),
              width: flagged ? 3 : 1,
            ),
            boxShadow: lit
                ? [
                    BoxShadow(
                      color: glow.withValues(alpha: dark ? 0.55 : 0.4),
                      blurRadius: m.cell * 0.28,
                    ),
                  ]
                : null,
          ),
          child: CustomPaint(painter: _PanesPainter(lit ? const Color(0x33B07A00) : const Color(0x14FFFFFF))),
        );
      },
    );
  }

  @override
  Widget? buildControls(BuildContext context, GameController ctrl) {
    final p = ctrl.puzzle as NightfallPuzzle;
    final s = ctrl.state as NightfallState;
    final theme = Theme.of(context);
    final over = p.limit != null && s.moves >= p.limit! && !s.dark;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: over ? theme.colorScheme.error : theme.colorScheme.outline, width: 2),
      ),
      child: Text(
        p.limit == null ? context.l10n.nightfallMoves(s.moves) : context.l10n.movesOfLimit(s.moves, p.limit!),
        style: theme.textTheme.titleMedium?.copyWith(fontFeatures: const [FontFeature.tabularFigures()]),
      ),
    );
  }

  @override
  Map<String, dynamic> encodePuzzle(NightfallPuzzle puzzle) => puzzle.toJson();
  @override
  NightfallPuzzle decodePuzzle(Map<String, dynamic> json) => NightfallPuzzle.fromJson(json);
  @override
  Map<String, dynamic> encodeState(NightfallState state) => state.toJson();
  @override
  NightfallState decodeState(Map<String, dynamic> json) => NightfallState.fromJson(json);
}

/// A window's cross bars, so the cells read as windows at night.
class _PanesPainter extends CustomPainter {
  const _PanesPainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = size.width * 0.05;
    canvas.drawLine(Offset(size.width / 2, size.height * 0.12), Offset(size.width / 2, size.height * 0.88), paint);
    canvas.drawLine(Offset(size.width * 0.12, size.height / 2), Offset(size.width * 0.88, size.height / 2), paint);
  }

  @override
  bool shouldRepaint(_PanesPainter old) => old.color != color;
}
