import 'package:flutter/material.dart';

import '../../core/difficulty.dart';
import '../../core/game_controller.dart';
import '../../core/grid.dart';
import '../../core/lattice_loop.dart';
import '../../core/puzzle_type.dart';
import '../../core/tutorial.dart';
import '../../l10n/l10n.dart';
import '../../ui/board/loop_board.dart';
import 'fence_generator.dart';
import 'fence_model.dart';
import 'fence_tutorial.dart';

/// Slitherlink: one loop along the grid lines around the numbers.
class FenceType extends PuzzleType<FencePuzzle, LoopMarks> {
  const FenceType();

  static const lineColor = Color(0xFF7E8CE0);

  @override
  String get id => 'fence';
  @override
  String name(AppLocalizations l) => l.fenceName;
  @override
  String tagline(AppLocalizations l) => l.fenceTagline;
  @override
  IconData get icon => Icons.fence_rounded;
  @override
  Color get accent => lineColor;

  @override
  String rulesText(AppLocalizations l) => l.fenceRules;

  @override
  List<TutorialStep> tutorial() => fenceTutorial;

  @override
  List<GridSize> get sizes => [for (var n = 5; n <= 10; n++) GridSize.square(n)];
  @override
  GridSize get defaultSize => const GridSize.square(6);
  @override
  GridSize dailySize(Difficulty difficulty) => switch (difficulty) {
        Difficulty.easy => const GridSize.square(5),
        Difficulty.medium => const GridSize.square(7),
        _ => const GridSize.square(8),
      };
  @override
  double get controlsHeight => 40;

  @override
  FencePuzzle generate(GenParams params) => generateFence(params);

  @override
  LoopMarks initialState(FencePuzzle puzzle) => LoopMarks(List.filled(puzzle.lattice.edgeCount, 0));

  @override
  bool isComplete(FencePuzzle puzzle, LoopMarks state) => puzzle.lattice.isSingleLoop(state.lines);

  @override
  bool isSolved(FencePuzzle puzzle, LoopMarks state) =>
      isComplete(puzzle, state) && fenceBadCells(puzzle, puzzle.lattice, state.lines, complete: true).isEmpty;

  @override
  Set<Pos> conflicts(FencePuzzle puzzle, LoopMarks state) {
    final g = puzzle.lattice;
    final lines = state.lines;
    final bad = {
      for (final i in fenceBadCells(puzzle, g, lines, complete: isComplete(puzzle, state))) puzzle.size.pos(i),
    };
    // Branching points: the cells around them.
    for (final p in g.badPoints(lines)) {
      if (g.incident[p].where((e) => lines[e]).length < 3) continue;
      final r = p ~/ g.vc, c = p % g.vc;
      for (final (dr, dc) in const [(-1, -1), (-1, 0), (0, -1), (0, 0)]) {
        final q = Pos(r + dr, c + dc);
        if (puzzle.size.contains(q)) bad.add(q);
      }
    }
    return bad;
  }

  @override
  HintResult<LoopMarks>? hint(FencePuzzle puzzle, LoopMarks state) {
    final g = puzzle.lattice;
    HintResult<LoopMarks> fix(int e, int v) => HintResult(LoopMarks(List.of(state.marks)..[e] = v), _cellsBy(puzzle, g, e));
    for (var e = 0; e < g.edgeCount; e++) {
      if (state.marks[e] == 1 && !puzzle.lines[e]) return fix(e, 2);
    }
    for (var e = 0; e < g.edgeCount; e++) {
      if (puzzle.lines[e] && state.marks[e] != 1) return fix(e, 1);
    }
    return null;
  }

  /// Cells on either side of edge [e].
  Set<Pos> _cellsBy(FencePuzzle p, LatticeLoop g, int e) {
    final (a, _) = g.ends(e);
    final r = a ~/ g.vc, c = a % g.vc;
    final sides = g.isHorizontal(e) ? [Pos(r - 1, c), Pos(r, c)] : [Pos(r, c - 1), Pos(r, c)];
    return {for (final q in sides) if (p.size.contains(q)) q};
  }

  @override
  Widget buildBoard(BuildContext context, GameController controller) {
    final p = controller.puzzle as FencePuzzle;
    final s = controller.state as LoopMarks;
    final g = p.lattice;
    final theme = Theme.of(context);
    final on = theme.colorScheme.onSurface;
    final lines = s.lines;
    return LoopBoard(
      g: g,
      rows: p.rows,
      cols: p.cols,
      centered: false,
      marks: s.marks,
      enabled: !controller.solved,
      win: controller.winAnimation,
      lineColor: lineColor,
      hintCells: controller.flashHints,
      errorCells: controller.errorCells,
      onCommit: (m) => controller.apply(LoopMarks(m)),
      paintClues: (canvas, geo) {
        for (var i = 0; i < p.numbers.length; i++) {
          final want = p.numbers[i];
          if (want == null) continue;
          final r = i ~/ p.cols, c = i % p.cols;
          final sides = fenceSides(g, r, c);
          final have = sides.where((e) => lines[e]).length;
          // Met: dimmed (a 0 only once all its sides are crossed).
          final met = have == want && (want > 0 || sides.every((e) => s.marks[e] == 2));
          final tp = TextPainter(
            text: TextSpan(
              text: '$want',
              style: theme.textTheme.bodyLarge!.copyWith(
                fontSize: geo.cell * 0.5,
                height: 1,
                fontWeight: FontWeight.w700,
                color: on.withValues(alpha: met ? 0.3 : 0.85),
              ),
            ),
            textDirection: TextDirection.ltr,
          )..layout();
          tp.paint(canvas, geo.cellRect(r, c).center - Offset(tp.width / 2, tp.height / 2));
        }
      },
    );
  }

  @override
  Map<String, dynamic> encodePuzzle(FencePuzzle puzzle) => puzzle.toJson();
  @override
  FencePuzzle decodePuzzle(Map<String, dynamic> json) => FencePuzzle.fromJson(json);
  @override
  Map<String, dynamic> encodeState(LoopMarks state) => state.toJson();
  @override
  LoopMarks decodeState(Map<String, dynamic> json) => LoopMarks.fromJson(json);
}
