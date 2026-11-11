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
import 'parcels_explain.dart';
import 'parcels_generator.dart';
import 'parcels_model.dart';
import 'parcels_tutorial.dart';

/// Divide the grid into regions of k cells; numbers count their cell's
/// borders. Borders are edges of a corner lattice drawn on a [LoopBoard],
/// the outline is locked.
class ParcelsType extends PuzzleType<ParcelsPuzzle, LoopMarks> {
  const ParcelsType();

  static const lineColor = Color(0xFF4FA88F);

  @override
  String get id => 'parcels';
  @override
  String name(AppLocalizations l) => l.parcelsName;
  @override
  String tagline(AppLocalizations l) => l.parcelsTagline;
  @override
  IconData get icon => Icons.view_quilt_rounded;
  @override
  Color get accent => lineColor;

  @override
  String rulesText(AppLocalizations l) => l.parcelsRules;

  @override
  List<TutorialStep> tutorial() => parcelsTutorial;
  @override
  List<TutorialStep> strategies() => parcelsStrategies;

  @override
  List<GridSize> get sizes => const [
    GridSize.square(4),
    GridSize.square(5),
    GridSize.square(6),
    GridSize.square(8),
    GridSize.square(10),
  ];
  @override
  GridSize get defaultSize => const GridSize.square(6);
  @override
  GridSize dailySize(Difficulty difficulty) => switch (difficulty) {
    Difficulty.easy => const GridSize.square(5),
    Difficulty.medium => const GridSize.square(6),
    _ => const GridSize.square(8),
  };
  @override
  Day get dailySince => const Day(2026, 11, 13);
  @override
  double get controlsHeight => 40;

  @override
  ParcelsPuzzle generate(GenParams params) => generateParcels(params);

  @override
  LoopMarks initialState(ParcelsPuzzle puzzle) => LoopMarks(puzzle.geo.startMarks());

  @override
  bool isComplete(ParcelsPuzzle puzzle, LoopMarks state) => parcelsComplete(puzzle, state.marks);

  @override
  bool isSolved(ParcelsPuzzle puzzle, LoopMarks state) => parcelsSolved(puzzle, state.marks);

  @override
  Set<Pos> conflicts(ParcelsPuzzle puzzle, LoopMarks state) => {
    for (final i in parcelsBad(puzzle, state.marks)) puzzle.size.pos(i),
  };

  /// The next explained step: a wrong mark removed, else what logic finds first.
  @override
  HintResult<LoopMarks>? hint(ParcelsPuzzle puzzle, LoopMarks state) {
    final e = explain(puzzle, state);
    if (e == null || e.next == null) return null;
    return HintResult(e.next! as LoopMarks, e.targets);
  }

  @override
  Widget buildBoard(BuildContext context, GameController controller) {
    final p = controller.puzzle as ParcelsPuzzle;
    final s = controller.state as LoopMarks;
    final geo = p.geo;
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final dark = theme.brightness == Brightness.dark;
    final errors = controller.errorCells;
    // Regions the borders already close off at the right size.
    final (of, groups) = geo.groups((e) => s.marks[e] == 1);
    final whole = [for (final g in groups) g.length == p.k];
    return LoopBoard(
      g: geo.g,
      rows: p.rows,
      cols: p.cols,
      centered: false,
      marks: s.marks,
      locked: [for (var e = 0; e < geo.g.edgeCount; e++) geo.isOutline(e)],
      enabled: !controller.solved,
      win: controller.winAnimation,
      lineColor: lineColor,
      hintCells: controller.flashHints,
      errorCells: errors,
      explain: ExplainView.of(controller),
      onCommit: (m) => controller.apply(LoopMarks(m)),
      paintNotes: (canvas, lg) {
        final fill = Paint()..color = lineColor.withValues(alpha: dark ? 0.16 : 0.14);
        for (var i = 0; i < geo.n; i++) {
          if (!whole[of[i]]) continue;
          canvas.drawRect(lg.cellRect(i ~/ p.cols, i % p.cols), fill);
        }
      },
      paintClues: (canvas, lg) {
        for (var i = 0; i < geo.n; i++) {
          final want = p.clues[i];
          if (want == null) continue;
          final r = i ~/ p.cols, c = i % p.cols;
          final sides = geo.sides[i];
          final have = sides.where((e) => s.marks[e] == 1).length;
          // Met: dimmed once the count is right and nothing is left open.
          final met = have == want && (whole[of[i]] || sides.every((e) => s.marks[e] != 0));
          final pos = Pos(r, c);
          final tp = TextPainter(
            text: TextSpan(
              text: '$want',
              style: theme.textTheme.bodyLarge!.copyWith(
                fontSize: lg.cell * 0.5,
                height: 1,
                fontWeight: FontWeight.w700,
                color: errors.contains(pos) ? scheme.error : scheme.onSurface.withValues(alpha: met ? 0.3 : 0.85),
              ),
            ),
            textDirection: TextDirection.ltr,
          )..layout();
          tp.paint(canvas, lg.cellRect(r, c).center - Offset(tp.width / 2, tp.height / 2));
        }
      },
    );
  }

  /// The region size, under the board.
  @override
  Widget? buildControls(BuildContext context, GameController controller) {
    final p = controller.puzzle as ParcelsPuzzle;
    final scheme = Theme.of(context).colorScheme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.view_quilt_rounded, size: 20, color: lineColor),
        const SizedBox(width: 8),
        Text(
          context.l10n.parcelsRegionCells(p.k),
          style: Theme.of(context).textTheme.titleSmall!.copyWith(color: scheme.onSurfaceVariant),
        ),
      ],
    );
  }

  @override
  bool get canExplain => true;

  @override
  Explanation? explain(ParcelsPuzzle puzzle, LoopMarks state) => explainStep(const ParcelsExplainer(), puzzle, state);

  @override
  Map<String, dynamic> encodePuzzle(ParcelsPuzzle puzzle) => puzzle.toJson();
  @override
  ParcelsPuzzle decodePuzzle(Map<String, dynamic> json) => ParcelsPuzzle.fromJson(json);
  @override
  Map<String, dynamic> encodeState(LoopMarks state) => state.toJson();
  @override
  LoopMarks decodeState(Map<String, dynamic> json) => LoopMarks.fromJson(json);
}
