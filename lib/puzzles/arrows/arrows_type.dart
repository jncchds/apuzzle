import 'package:flutter/material.dart';

import '../../core/day.dart';
import '../../core/difficulty.dart';
import '../../core/game_controller.dart';
import '../../core/grid.dart';
import '../../core/puzzle_type.dart';
import '../../core/tutorial.dart';
import '../../l10n/l10n.dart';
import '../../ui/board/loop_board.dart';
import 'arrows_generator.dart';
import 'arrows_model.dart';
import 'arrows_tutorial.dart';

/// Yajilin: shade cells the arrows count, loop through all the others.
class ArrowsType extends PuzzleType<ArrowsPuzzle, ArrowsState> {
  const ArrowsType();

  static const lineColor = Color(0xFFD9825B);

  @override
  String get id => 'arrows';
  @override
  String name(AppLocalizations l) => l.arrowsName;
  @override
  String tagline(AppLocalizations l) => l.arrowsTagline;
  @override
  IconData get icon => Icons.north_east_rounded;
  @override
  Color get accent => lineColor;

  @override
  String rulesText(AppLocalizations l) => l.arrowsRules;

  @override
  List<TutorialStep> tutorial() => arrowsTutorial;
  @override
  List<TutorialStep> strategies() => arrowsStrategies;

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
  Day get dailySince => const Day(2026, 9, 28);
  @override
  double get controlsHeight => 40;

  @override
  ArrowsPuzzle generate(GenParams params) => generateArrows(params);

  /// Edges touching a clue cell (no line may go there).
  static List<bool> locked(ArrowsPuzzle p) {
    final g = p.lattice;
    return [
      for (var e = 0; e < g.edgeCount; e++)
        if (g.ends(e) case (final a, final b)) p.isClue(a) || p.isClue(b),
    ];
  }

  @override
  ArrowsState initialState(ArrowsPuzzle puzzle) =>
      ArrowsState(List.filled(puzzle.lattice.edgeCount, 0), List.filled(puzzle.rows * puzzle.cols, arrowsEmpty));

  @override
  bool isComplete(ArrowsPuzzle puzzle, ArrowsState state) => puzzle.lattice.isSingleLoop(state.lines);

  @override
  bool isSolved(ArrowsPuzzle puzzle, ArrowsState state) => arrowsValid(puzzle, state.lines);

  @override
  Set<Pos> conflicts(ArrowsPuzzle puzzle, ArrowsState state) {
    final g = puzzle.lattice;
    final lines = state.lines;
    final complete = isComplete(puzzle, state);
    final bad = {
      ...arrowsBad(puzzle, lines, complete: complete),
      for (final p in g.badPoints(lines))
        if (complete || g.incident[p].where((e) => lines[e]).length > 2) p,
    };
    // The player's own shading: side by side, or with a line through it.
    for (var i = 0; i < state.cells.length; i++) {
      if (state.cells[i] != arrowsShade) continue;
      final r = i ~/ puzzle.cols, c = i % puzzle.cols;
      if (c + 1 < puzzle.cols && state.cells[i + 1] == arrowsShade) bad.addAll([i, i + 1]);
      if (r + 1 < puzzle.rows && state.cells[i + puzzle.cols] == arrowsShade) bad.addAll([i, i + puzzle.cols]);
      if (g.incident[i].any((e) => lines[e])) bad.add(i);
    }
    return {for (final i in bad) puzzle.size.pos(i)};
  }

  @override
  HintResult<ArrowsState>? hint(ArrowsPuzzle puzzle, ArrowsState state) {
    final g = puzzle.lattice;
    HintResult<ArrowsState> edge(int e, int v) {
      final (a, b) = g.ends(e);
      return HintResult(ArrowsState(List.of(state.marks)..[e] = v, state.cells), {
        puzzle.size.pos(a),
        puzzle.size.pos(b),
      });
    }

    HintResult<ArrowsState> cell(int i, int v) =>
        HintResult(ArrowsState(state.marks, List.of(state.cells)..[i] = v), {puzzle.size.pos(i)});

    for (var e = 0; e < g.edgeCount; e++) {
      if (state.marks[e] == 1 && !puzzle.lines[e]) return edge(e, 2);
    }
    for (var i = 0; i < state.cells.length; i++) {
      if (state.cells[i] == arrowsShade && !puzzle.shaded[i]) return cell(i, arrowsEmpty);
    }
    for (var i = 0; i < state.cells.length; i++) {
      if (puzzle.shaded[i] && state.cells[i] != arrowsShade) return cell(i, arrowsShade);
    }
    for (var e = 0; e < g.edgeCount; e++) {
      if (puzzle.lines[e] && state.marks[e] != 1) return edge(e, 1);
    }
    return null;
  }

  @override
  Widget buildBoard(BuildContext context, GameController controller) {
    final p = controller.puzzle as ArrowsPuzzle;
    final s = controller.state as ArrowsState;
    final g = p.lattice;
    final scheme = Theme.of(context).colorScheme;
    final dark = Theme.of(context).brightness == Brightness.dark;
    // Shading stays a dark fill in both themes; clues sit in the page colour with a rim, so neither looks like a loop cell.
    final shade = dark ? const Color(0xFF55607A) : const Color(0xFF2B2F3A);
    final clueFill = scheme.surface;
    final clueRim = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..color = scheme.onSurface.withValues(alpha: 0.35);
    final ink = scheme.onSurface;
    final textStyle = Theme.of(context).textTheme.bodyMedium!;

    void tapCell(Pos pos, bool secondary) {
      final i = p.size.index(pos);
      if (p.isClue(i)) return;
      final cur = s.cells[i];
      final next = secondary
          ? (cur == arrowsDot ? arrowsEmpty : arrowsDot)
          : switch (cur) {
              arrowsEmpty => arrowsShade,
              arrowsShade => arrowsDot,
              _ => arrowsEmpty,
            };
      final marks = List.of(s.marks);
      // A shaded cell takes no lines.
      if (next == arrowsShade) {
        for (final e in g.incident[i]) {
          if (marks[e] == 1) marks[e] = 0;
        }
      }
      controller.apply(ArrowsState(marks, List.of(s.cells)..[i] = next));
    }

    return LoopBoard(
      g: g,
      rows: p.rows,
      cols: p.cols,
      centered: true,
      cellBackground: true,
      marks: s.marks,
      locked: locked(p),
      enabled: !controller.solved,
      win: controller.winAnimation,
      lineColor: lineColor,
      hintCells: controller.flashHints,
      errorCells: controller.errorCells,
      onCellTap: tapCell,
      onCommit: (m) {
        // Lines through a cell clear its shading.
        final cells = List.of(s.cells);
        for (var i = 0; i < cells.length; i++) {
          if (cells[i] == arrowsShade && g.incident[i].any((e) => m[e] == 1)) cells[i] = arrowsEmpty;
        }
        controller.apply(ArrowsState(m, cells));
      },
      paintClues: (canvas, geo) {
        final cell = geo.cell;
        for (var i = 0; i < p.rows * p.cols; i++) {
          // Inset, so hint and error highlights show around the fill.
          final rect = geo.cellRect(i ~/ p.cols, i % p.cols).deflate(cell * 0.1);
          final rr = RRect.fromRectAndRadius(rect, Radius.circular(cell * 0.1));
          if (p.isClue(i)) {
            canvas.drawRRect(rr, Paint()..color = clueFill);
            canvas.drawRRect(rr, clueRim);
            _paintClue(canvas, rect, p.arrows[i], p.counts[i], textStyle.copyWith(color: ink));
          } else if (s.cells[i] == arrowsShade) {
            canvas.drawRRect(rr, Paint()..color = shade);
          } else if (s.cells[i] == arrowsDot) {
            canvas.drawCircle(rect.center, cell * 0.07, Paint()..color = ink.withValues(alpha: 0.5));
          }
        }
      },
    );
  }

  /// The count, shifted away from a small triangle pointing its way.
  static void _paintClue(Canvas canvas, Rect rect, int dir, int count, TextStyle style) {
    final ink = style.color!;
    final s = rect.width;
    final (dr, dc) = arrowDirs[dir];
    final text = TextPainter(
      text: TextSpan(
        text: '$count',
        style: style.copyWith(fontSize: s * 0.44, fontWeight: FontWeight.w700, height: 1),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    final c = rect.center;
    text.paint(canvas, c - Offset(dc * s * 0.12, dr * s * 0.12) - Offset(text.width / 2, text.height / 2));
    final tip = c + Offset(dc * s * 0.44, dr * s * 0.44);
    final base = c + Offset(dc * s * 0.26, dr * s * 0.26);
    final side = Offset(-dr.toDouble(), dc.toDouble()) * (s * 0.1);
    canvas.drawPath(
      Path()
        ..moveTo(tip.dx, tip.dy)
        ..lineTo((base + side).dx, (base + side).dy)
        ..lineTo((base - side).dx, (base - side).dy)
        ..close(),
      Paint()..color = ink,
    );
  }

  @override
  Map<String, dynamic> encodePuzzle(ArrowsPuzzle puzzle) => puzzle.toJson();
  @override
  ArrowsPuzzle decodePuzzle(Map<String, dynamic> json) => ArrowsPuzzle.fromJson(json);
  @override
  Map<String, dynamic> encodeState(ArrowsState state) => state.toJson();
  @override
  ArrowsState decodeState(Map<String, dynamic> json) => ArrowsState.fromJson(json);
}
