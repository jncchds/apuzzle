import 'package:flutter/material.dart';

import '../../core/difficulty.dart';
import '../../core/game_controller.dart';
import '../../core/grid.dart';
import '../../core/puzzle_type.dart';
import '../../core/tutorial.dart';
import '../../l10n/l10n.dart';
import '../../ui/board/cell_grid_board.dart';
import 'pipes_generator.dart';
import 'pipes_model.dart';
import 'pipes_tutorial.dart';

/// Rotate tiles so every pipe connects back to the source.
class PipesType extends PuzzleType<PipesPuzzle, PipesState> {
  const PipesType();

  static const water = Color(0xFF6FA8F5);

  @override
  String get id => 'pipes';
  @override
  String name(AppLocalizations l) => l.pipesName;
  @override
  String tagline(AppLocalizations l) => l.pipesTagline;
  @override
  IconData get icon => Icons.plumbing_rounded;
  @override
  Color get accent => water;

  @override
  String rulesText(AppLocalizations l) => l.pipesRules;

  @override
  List<TutorialStep> tutorial() => pipesTutorial;

  @override
  List<GridSize> get sizes => [for (var n = 4; n <= 11; n++) GridSize.square(n)];
  @override
  GridSize get defaultSize => const GridSize.square(6);
  @override
  GridSize dailySize(Difficulty difficulty) => switch (difficulty) {
        Difficulty.easy => const GridSize.square(5),
        Difficulty.medium => const GridSize.square(7),
        _ => const GridSize.square(9),
      };
  @override
  bool get showSubmit => false;
  @override
  double get controlsHeight => 40;

  @override
  PipesPuzzle generate(GenParams params) => generatePipes(params);

  @override
  PipesState initialState(PipesPuzzle puzzle) => PipesState(List.of(puzzle.start));

  @override
  bool isComplete(PipesPuzzle puzzle, PipesState state) => isSolved(puzzle, state);
  @override
  bool isSolved(PipesPuzzle puzzle, PipesState state) => pipesSolved(puzzle, currentMasks(puzzle, state));

  @override
  Set<Pos> conflicts(PipesPuzzle puzzle, PipesState state) =>
      {for (final i in looseTiles(puzzle, currentMasks(puzzle, state))) puzzle.size.pos(i)};

  @override
  HintResult<PipesState>? hint(PipesPuzzle puzzle, PipesState state) {
    final m = currentMasks(puzzle, state);
    for (var i = 0; i < m.length; i++) {
      if (puzzle.locked[i] || m[i] == puzzle.masks[i]) continue;
      final turns = List.of(state.turns);
      var k = 0;
      while (rotateMask(puzzle.masks[i], turns[i]) != puzzle.masks[i] && k++ < 4) {
        turns[i]++;
      }
      return HintResult(PipesState(turns), {puzzle.size.pos(i)});
    }
    return null;
  }

  void _rotate(GameController ctrl, Pos pos, int delta) {
    final p = ctrl.puzzle as PipesPuzzle;
    final s = ctrl.state as PipesState;
    final i = p.size.index(pos);
    if (p.locked[i]) return;
    final turns = List.of(s.turns)..[i] += delta;
    ctrl.apply(PipesState(turns));
  }

  @override
  Widget buildBoard(BuildContext context, GameController ctrl) {
    final p = ctrl.puzzle as PipesPuzzle;
    final s = ctrl.state as PipesState;
    final m = currentMasks(p, s);
    final lit = litTiles(p, m);
    final errors = ctrl.errorCells;
    final scheme = Theme.of(context).colorScheme;
    return CellGridBoard(
      rows: p.rows,
      cols: p.cols,
      gapRatio: 0.02,
      win: ctrl.winAnimation,
      onTap: ctrl.solved ? null : (pos) => _rotate(ctrl, pos, 1),
      onSecondary: ctrl.solved ? null : (pos) => _rotate(ctrl, pos, -1),
      cellBuilder: (context, pos, bm) {
        final i = p.size.index(pos);
        final isLit = lit.contains(i);
        return Container(
          decoration: BoxDecoration(
            color: p.locked[i] ? scheme.surfaceContainerHighest : scheme.surfaceContainer,
            borderRadius: BorderRadius.circular(bm.cell * 0.12),
            border: errors.contains(pos)
                ? Border.all(color: scheme.error, width: 2)
                : ctrl.flashHints.contains(pos)
                    ? Border.all(color: scheme.tertiary, width: 2)
                    : null,
          ),
          child: AnimatedRotation(
            turns: s.turns[i] / 4,
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOut,
            child: TweenAnimationBuilder<Color?>(
              tween: ColorTween(end: isLit ? water : scheme.outline.withValues(alpha: 0.55)),
              duration: const Duration(milliseconds: 260),
              builder: (context, color, _) => CustomPaint(
                painter: _PipePainter(
                  mask: p.masks[i],
                  color: color!,
                  outline: scheme.onSurface.withValues(alpha: 0.35),
                  source: i == p.source,
                  locked: p.locked[i],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Map<String, dynamic> encodePuzzle(PipesPuzzle puzzle) => puzzle.toJson();
  @override
  PipesPuzzle decodePuzzle(Map<String, dynamic> json) => PipesPuzzle.fromJson(json);
  @override
  Map<String, dynamic> encodeState(PipesState state) => state.toJson();
  @override
  PipesState decodeState(Map<String, dynamic> json) => PipesState.fromJson(json);
}

class _PipePainter extends CustomPainter {
  _PipePainter({required this.mask, required this.color, required this.outline, required this.source, required this.locked});

  final int mask;
  final Color color;
  final Color outline;
  final bool source;
  final bool locked;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final c = Offset(w / 2, w / 2);
    final thick = w * 0.26;
    final arms = [
      if (mask & dN != 0) Offset(w / 2, 0),
      if (mask & dE != 0) Offset(w, w / 2),
      if (mask & dS != 0) Offset(w / 2, w),
      if (mask & dW != 0) Offset(0, w / 2),
    ];
    final edge = Paint()
      ..color = outline
      ..strokeWidth = thick + w * 0.06
      ..strokeCap = StrokeCap.butt;
    final fill = Paint()
      ..color = color
      ..strokeWidth = thick
      ..strokeCap = StrokeCap.butt;
    for (final a in arms) {
      canvas.drawLine(c, a, edge);
    }
    final bulb = arms.length == 1 || source;
    final hubR = bulb ? w * 0.27 : thick / 2;
    canvas.drawCircle(c, hubR + w * 0.03, Paint()..color = outline);
    for (final a in arms) {
      canvas.drawLine(c, a, fill);
    }
    canvas.drawCircle(c, hubR, Paint()..color = color);
    if (source) {
      canvas.drawCircle(c, w * 0.12, Paint()..color = outline.withValues(alpha: 0.9));
      canvas.drawCircle(c, w * 0.08, Paint()..color = color);
    }
    if (locked) {
      canvas.drawCircle(Offset(w * 0.86, w * 0.14), w * 0.05, Paint()..color = outline);
    }
  }

  @override
  bool shouldRepaint(_PipePainter old) =>
      old.mask != mask || old.color != color || old.source != source || old.locked != locked || old.outline != outline;
}
