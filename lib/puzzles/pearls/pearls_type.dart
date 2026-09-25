import 'package:flutter/material.dart';

import '../../core/difficulty.dart';
import '../../core/game_controller.dart';
import '../../core/grid.dart';
import '../../core/lattice_loop.dart';
import '../../core/puzzle_type.dart';
import '../../l10n/l10n.dart';
import '../../ui/board/loop_board.dart';
import 'pearls_generator.dart';
import 'pearls_model.dart';

/// Masyu: one loop through the pearls.
class PearlsType extends PuzzleType<PearlsPuzzle, LoopMarks> {
  const PearlsType();

  static const lineColor = Color(0xFF4FB3A9);

  @override
  String get id => 'pearls';
  @override
  String name(AppLocalizations l) => l.pearlsName;
  @override
  String tagline(AppLocalizations l) => l.pearlsTagline;
  @override
  IconData get icon => Icons.radio_button_checked_rounded;
  @override
  Color get accent => lineColor;

  @override
  String rulesText(AppLocalizations l) => l.pearlsRules;

  @override
  List<GridSize> get sizes => [for (var n = 5; n <= 10; n++) GridSize.square(n)];
  @override
  GridSize get defaultSize => const GridSize.square(7);
  @override
  double get controlsHeight => 40;

  @override
  PearlsPuzzle generate(GenParams params) => generatePearls(params);

  @override
  LoopMarks initialState(PearlsPuzzle puzzle) => LoopMarks(List.filled(puzzle.lattice.edgeCount, 0));

  @override
  bool isComplete(PearlsPuzzle puzzle, LoopMarks state) => puzzle.lattice.isSingleLoop(state.lines);

  @override
  bool isSolved(PearlsPuzzle puzzle, LoopMarks state) =>
      isComplete(puzzle, state) && pearlsBad(puzzle, puzzle.lattice, state.lines, complete: true).isEmpty;

  @override
  Set<Pos> conflicts(PearlsPuzzle puzzle, LoopMarks state) {
    final g = puzzle.lattice;
    final lines = state.lines;
    final complete = isComplete(puzzle, state);
    return {
      for (final i in pearlsBad(puzzle, g, lines, complete: complete)) puzzle.size.pos(i),
      for (final p in g.badPoints(lines))
        if (complete || g.incident[p].where((e) => lines[e]).length > 2) puzzle.size.pos(p),
    };
  }

  @override
  HintResult<LoopMarks>? hint(PearlsPuzzle puzzle, LoopMarks state) {
    final g = puzzle.lattice;
    HintResult<LoopMarks> fix(int e, int v) {
      final (a, b) = g.ends(e);
      return HintResult(LoopMarks(List.of(state.marks)..[e] = v), {puzzle.size.pos(a), puzzle.size.pos(b)});
    }

    for (var e = 0; e < g.edgeCount; e++) {
      if (state.marks[e] == 1 && !puzzle.lines[e]) return fix(e, 2);
    }
    // Missing lines, starting at pearls.
    for (final pearlFirst in const [true, false]) {
      for (var e = 0; e < g.edgeCount; e++) {
        if (!puzzle.lines[e] || state.marks[e] == 1) continue;
        final (a, b) = g.ends(e);
        if (pearlFirst && puzzle.pearls[a] == pearlNone && puzzle.pearls[b] == pearlNone) continue;
        return fix(e, 1);
      }
    }
    return null;
  }

  @override
  Widget buildBoard(BuildContext context, GameController controller) {
    final p = controller.puzzle as PearlsPuzzle;
    final s = controller.state as LoopMarks;
    final dark = Theme.of(context).brightness == Brightness.dark;
    final ink = dark ? const Color(0xFF0E1116) : const Color(0xFF2B2F3A);
    final rim = dark ? const Color(0xFFB8BECB) : const Color(0xFF2B2F3A);
    return LoopBoard(
      g: p.lattice,
      rows: p.rows,
      cols: p.cols,
      centered: true,
      cellBackground: true,
      cluesOnTop: true,
      marks: s.marks,
      enabled: !controller.solved,
      win: controller.winAnimation,
      lineColor: lineColor,
      hintCells: controller.flashHints,
      errorCells: controller.errorCells,
      onCommit: (m) => controller.apply(LoopMarks(m)),
      paintClues: (canvas, geo) {
        for (var i = 0; i < p.pearls.length; i++) {
          final kind = p.pearls[i];
          if (kind == pearlNone) continue;
          final c = geo.point(i ~/ p.cols, i % p.cols);
          final r = geo.cell * 0.28;
          if (kind == pearlBlack) {
            canvas.drawCircle(c, r, Paint()..color = ink);
            canvas.drawCircle(c, r, Paint()
              ..color = rim
              ..style = PaintingStyle.stroke
              ..strokeWidth = geo.cell * 0.04);
          } else {
            canvas.drawCircle(c, r, Paint()..color = Colors.white);
            canvas.drawCircle(c, r, Paint()
              ..color = ink
              ..style = PaintingStyle.stroke
              ..strokeWidth = geo.cell * 0.06);
          }
        }
      },
    );
  }

  @override
  Map<String, dynamic> encodePuzzle(PearlsPuzzle puzzle) => puzzle.toJson();
  @override
  PearlsPuzzle decodePuzzle(Map<String, dynamic> json) => PearlsPuzzle.fromJson(json);
  @override
  Map<String, dynamic> encodeState(LoopMarks state) => state.toJson();
  @override
  LoopMarks decodeState(Map<String, dynamic> json) => LoopMarks.fromJson(json);
}
