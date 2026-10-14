import 'package:flutter/material.dart';

import '../../core/day.dart';
import '../../core/difficulty.dart';
import '../../core/explain.dart';
import '../../core/game_controller.dart';
import '../../core/grid.dart';
import '../../core/lattice_loop.dart';
import '../../core/puzzle_type.dart';
import '../../core/tutorial.dart';
import '../../l10n/l10n.dart';
import '../../ui/board/explain_overlay.dart';
import '../../ui/board/loop_board.dart';
import 'domino_explain.dart';
import 'domino_generator.dart';
import 'domino_model.dart';
import 'domino_tutorial.dart';

/// A full set of dominoes with the outlines rubbed off: find every domino.
class DominoType extends PuzzleType<DominoPuzzle, LoopMarks> {
  const DominoType();

  static const tileColor = Color(0xFFD9A05B);

  @override
  String get id => 'domino';
  @override
  String name(AppLocalizations l) => l.dominoName;
  @override
  String tagline(AppLocalizations l) => l.dominoTagline;
  @override
  IconData get icon => Icons.splitscreen_rounded;
  @override
  Color get accent => tileColor;

  @override
  String rulesText(AppLocalizations l) => l.dominoRules;

  @override
  List<TutorialStep> tutorial() => dominoTutorial;
  @override
  List<TutorialStep> strategies() => dominoStrategies;

  /// A double-n set lies on n + 2 rows of n + 1 cells.
  @override
  List<GridSize> get sizes => [for (var n = 3; n <= 9; n++) GridSize(n + 2, n + 1)];
  @override
  GridSize get defaultSize => const GridSize(7, 6);
  @override
  GridSize dailySize(Difficulty difficulty) => switch (difficulty) {
    Difficulty.easy => const GridSize(6, 5),
    Difficulty.medium => const GridSize(7, 6),
    _ => const GridSize(8, 7),
  };
  @override
  Day get dailySince => const Day(2026, 10, 15);
  @override
  double get controlsHeight => 40;

  @override
  DominoPuzzle generate(GenParams params) => generateDomino(params);

  @override
  LoopMarks initialState(DominoPuzzle puzzle) => LoopMarks(List.filled(puzzle.lattice.edgeCount, 0));

  @override
  bool isComplete(DominoPuzzle puzzle, LoopMarks state) => dominoCovered(puzzle, state.marks);

  @override
  bool isSolved(DominoPuzzle puzzle, LoopMarks state) =>
      isComplete(puzzle, state) && dominoBad(puzzle, state.marks).isEmpty;

  @override
  Set<Pos> conflicts(DominoPuzzle puzzle, LoopMarks state) => {
    for (final i in dominoBad(puzzle, state.marks)) puzzle.size.pos(i),
  };

  /// The next explained step: a wrong mark removed, else the domino logic
  /// finds first.
  @override
  HintResult<LoopMarks>? hint(DominoPuzzle puzzle, LoopMarks state) {
    final e = explain(puzzle, state);
    if (e == null || e.next == null) return null;
    return HintResult(e.next! as LoopMarks, e.targets);
  }

  @override
  Widget buildBoard(BuildContext context, GameController controller) {
    final p = controller.puzzle as DominoPuzzle;
    final s = controller.state as LoopMarks;
    final scheme = Theme.of(context).colorScheme;
    final textStyle = Theme.of(context).textTheme.bodyLarge!;
    final dark = Theme.of(context).brightness == Brightness.dark;
    final errors = controller.errorCells;
    final g = p.lattice;
    return LoopBoard(
      g: g,
      rows: p.rows,
      cols: p.cols,
      centered: true,
      cellBackground: true,
      cluesOnTop: true,
      joints: false,
      lineWidth: 0.8,
      marks: s.marks,
      enabled: !controller.solved,
      win: controller.winAnimation,
      lineColor: tileColor.withValues(alpha: dark ? 0.5 : 0.45),
      hintCells: controller.flashHints,
      explain: ExplainView.of(controller),
      errorCells: errors,
      onCommit: (m) => controller.apply(LoopMarks(dominoCommit(g, s.marks, m))),
      paintClues: (canvas, geo) {
        // The line across the middle of every domino.
        final split = Paint()
          ..color = scheme.onSurface.withValues(alpha: 0.3)
          ..strokeWidth = (geo.cell * 0.03).clamp(1.0, 2.0)
          ..strokeCap = StrokeCap.round;
        for (var e = 0; e < s.marks.length; e++) {
          if (s.marks[e] != 1) continue;
          final (a, b) = g.ends(e);
          final pa = geo.point(a ~/ p.cols, a % p.cols), pb = geo.point(b ~/ p.cols, b % p.cols);
          final mid = (pa + pb) / 2;
          final across = g.isHorizontal(e) ? Offset(0, geo.cell * 0.26) : Offset(geo.cell * 0.26, 0);
          canvas.drawLine(mid - across, mid + across, split);
        }
        for (var i = 0; i < p.nums.length; i++) {
          final pos = p.size.pos(i);
          final tp = TextPainter(
            text: TextSpan(
              text: '${p.nums[i]}',
              style: textStyle.copyWith(
                fontSize: geo.cell * 0.46,
                height: 1,
                fontWeight: FontWeight.w600,
                color: errors.contains(pos) ? scheme.error : scheme.onSurface.withValues(alpha: 0.87),
              ),
            ),
            textDirection: TextDirection.ltr,
          )..layout();
          tp.paint(canvas, geo.point(pos.r, pos.c) - Offset(tp.width / 2, tp.height / 2));
        }
      },
    );
  }

  @override
  Widget buildValueChip(BuildContext context, DominoPuzzle puzzle, int value, double size) => Container(
    width: size * 0.86,
    height: size * 0.86,
    alignment: Alignment.center,
    decoration: BoxDecoration(
      color: tileColor.withValues(alpha: 0.45),
      borderRadius: BorderRadius.circular(size * 0.2),
    ),
    child: Text(
      '$value',
      style: TextStyle(fontSize: size * 0.56, height: 1, fontWeight: FontWeight.w700),
    ),
  );

  @override
  bool get canExplain => true;

  @override
  Explanation? explain(DominoPuzzle puzzle, LoopMarks state) => explainStep(const DominoExplainer(), puzzle, state);

  @override
  Map<String, dynamic> encodePuzzle(DominoPuzzle puzzle) => puzzle.toJson();
  @override
  DominoPuzzle decodePuzzle(Map<String, dynamic> json) => DominoPuzzle.fromJson(json);
  @override
  Map<String, dynamic> encodeState(LoopMarks state) => state.toJson();
  @override
  LoopMarks decodeState(Map<String, dynamic> json) => LoopMarks.fromJson(json);
}
