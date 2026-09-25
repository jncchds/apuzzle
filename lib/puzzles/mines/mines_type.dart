import 'dart:math';

import 'package:flutter/material.dart';

import '../../core/difficulty.dart';
import '../../core/game_controller.dart';
import '../../core/grid.dart';
import '../../core/grid_graph.dart';
import '../../core/puzzle_type.dart';
import '../../l10n/l10n.dart';
import '../../ui/board/cell_grid_board.dart';
import '../../ui/symbols.dart';
import 'mines_generator.dart';
import 'mines_model.dart';
import 'mines_solver.dart';

/// Minesweeper where logic always suffices.
class MinesType extends PuzzleType<MinesPuzzle, MinesState> {
  const MinesType();

  /// [GameController.tool] value of the flag tool (null = dig).
  static const flagTool = 1;

  static const _numberColors = [
    Color(0xFF2F6FD6), Color(0xFF2E8B57), Color(0xFFD64545), Color(0xFF5B3FB0),
    Color(0xFF9C3D12), Color(0xFF138086), Color(0xFF333333), Color(0xFF777777),
  ];

  @override
  String get id => 'mines';
  @override
  String name(AppLocalizations l) => l.minesName;
  @override
  String tagline(AppLocalizations l) => l.minesTagline;
  @override
  IconData get icon => Icons.flag_outlined;
  @override
  Color get accent => const Color(0xFFE06C5A);

  @override
  String rulesText(AppLocalizations l) => l.minesRules;

  @override
  List<GridSize> get sizes => const [
        GridSize.square(6),
        GridSize.square(8),
        GridSize(10, 8),
        GridSize(12, 9),
        GridSize(14, 10),
        GridSize(16, 10),
      ];
  @override
  GridSize get defaultSize => const GridSize(10, 8);
  @override
  GridSize dailySize(Difficulty difficulty) => switch (difficulty) {
        Difficulty.easy => const GridSize.square(6),
        Difficulty.medium => const GridSize.square(8),
        _ => const GridSize(10, 8),
      };
  @override
  double get minCellSize => 32;
  @override
  double get controlsHeight => 64;
  @override
  bool get showSubmit => false;

  @override
  MinesPuzzle generate(GenParams params) => generateMines(params);

  @override
  MinesState initialState(MinesPuzzle puzzle) =>
      MinesState(open: List.of(puzzle.opened), flags: List.filled(puzzle.mines.length, false));

  @override
  bool isComplete(MinesPuzzle puzzle, MinesState state) => minesCleared(puzzle, state.open);
  @override
  bool isSolved(MinesPuzzle puzzle, MinesState state) => minesCleared(puzzle, state.open);

  @override
  Set<Pos> conflicts(MinesPuzzle puzzle, MinesState state) => {
        for (var i = 0; i < state.flags.length; i++)
          if (state.flags[i] && !puzzle.mines[i]) puzzle.size.pos(i),
      };

  @override
  HintResult<MinesState>? hint(MinesPuzzle puzzle, MinesState state) {
    final n = puzzle.mines.length;
    for (var i = 0; i < n; i++) {
      if (state.flags[i] && !puzzle.mines[i]) {
        return HintResult(_copy(state, flags: List.of(state.flags)..[i] = false), {puzzle.size.pos(i)});
      }
    }
    final counts = mineCounts(puzzle);
    final s = MinesSolver(puzzle.rows, puzzle.cols, counts, puzzle.mineCount);
    final k = s.knowledge(state.open, state.flags);
    s.deduce(state.open, k, 3);
    for (var i = 0; i < n; i++) {
      if (k[i] == 0 && !state.open[i]) return HintResult(_dig(puzzle, state, [i]), {puzzle.size.pos(i)});
    }
    for (var i = 0; i < n; i++) {
      if (k[i] == 1 && !state.flags[i]) {
        return HintResult(_copy(state, flags: List.of(state.flags)..[i] = true), {puzzle.size.pos(i)});
      }
    }
    final kn = kingNeighbors(puzzle.rows, puzzle.cols);
    final safe = [for (var i = 0; i < n; i++) if (!state.open[i] && !puzzle.mines[i]) i];
    if (safe.isEmpty) return null;
    final edge = [for (final i in safe) if (kn[i].any((j) => state.open[j])) i];
    final pick = (edge.isEmpty ? safe : edge)[Random().nextInt(edge.isEmpty ? safe.length : edge.length)];
    return HintResult(_dig(puzzle, state, [pick]), {puzzle.size.pos(pick)});
  }

  MinesState _copy(MinesState s, {List<bool>? open, List<bool>? flags, List<int>? booms}) =>
      MinesState(open: open ?? s.open, flags: flags ?? s.flags, booms: booms ?? s.booms);

  /// Digs [cells]: safe ones open (spreading from blanks), mines go off and
  /// get flagged.
  MinesState _dig(MinesPuzzle p, MinesState s, List<int> cells) {
    final open = List.of(s.open);
    final flags = List.of(s.flags);
    final booms = [...s.booms];
    final safe = <int>[];
    for (final i in cells) {
      if (p.mines[i]) {
        flags[i] = true;
        if (!booms.contains(i)) booms.add(i);
      } else {
        safe.add(i);
      }
    }
    openCells(open, safe, p.mines, mineCounts(p), kingNeighbors(p.rows, p.cols));
    for (var i = 0; i < open.length; i++) {
      if (open[i]) flags[i] = false;
    }
    return MinesState(open: open, flags: flags, booms: booms);
  }

  void _tap(GameController ctrl, Pos pos) {
    final p = ctrl.puzzle as MinesPuzzle;
    final s = ctrl.state as MinesState;
    final i = p.size.index(pos);
    if (s.open[i]) {
      // Chord: a number with all its flags placed digs the rest around it.
      final kn = kingNeighbors(p.rows, p.cols)[i];
      final flagged = kn.where((j) => s.flags[j]).length;
      if (flagged == 0 || flagged != mineCounts(p)[i]) return;
      final rest = [for (final j in kn) if (!s.open[j] && !s.flags[j]) j];
      if (rest.isEmpty) return;
      _apply(ctrl, s, _dig(p, s, rest));
      return;
    }
    if (ctrl.tool == flagTool) {
      _flag(ctrl, pos);
      return;
    }
    if (s.flags[i]) return;
    _apply(ctrl, s, _dig(p, s, [i]));
  }

  void _apply(GameController ctrl, MinesState before, MinesState after) {
    if (after.booms.length > before.booms.length) ctrl.showToast((l) => l.minesBoom);
    ctrl.apply(after);
  }

  void _flag(GameController ctrl, Pos pos) {
    final p = ctrl.puzzle as MinesPuzzle;
    final s = ctrl.state as MinesState;
    final i = p.size.index(pos);
    if (s.open[i]) return;
    ctrl.apply(_copy(s, flags: List.of(s.flags)..[i] = !s.flags[i]));
  }

  @override
  Widget buildBoard(BuildContext context, GameController ctrl) {
    final p = ctrl.puzzle as MinesPuzzle;
    final s = ctrl.state as MinesState;
    final counts = mineCounts(p);
    final errors = ctrl.errorCells;
    final scheme = Theme.of(context).colorScheme;
    final dark = Theme.of(context).brightness == Brightness.dark;
    return CellGridBoard(
      rows: p.rows,
      cols: p.cols,
      gapRatio: 0.06,
      maxCell: 64,
      win: ctrl.winAnimation,
      onTap: ctrl.solved ? null : (pos) => _tap(ctrl, pos),
      onSecondary: ctrl.solved ? null : (pos) => _flag(ctrl, pos),
      cellBuilder: (context, pos, m) {
        final i = p.size.index(pos);
        final open = s.open[i];
        final boom = s.booms.contains(i);
        final flagged = s.flags[i] || (ctrl.solved && p.mines[i]);
        final Widget content;
        if (boom) {
          content = MineSymbol(key: const ValueKey('boom'), size: m.cell * 0.66, color: scheme.onErrorContainer);
        } else if (flagged) {
          content = Icon(Icons.flag_rounded, key: const ValueKey('flag'), size: m.cell * 0.6, color: const Color(0xFFE0503C));
        } else if (open && counts[i] > 0) {
          final c = _numberColors[counts[i] - 1];
          content = Text(
            '${counts[i]}',
            key: ValueKey('n${counts[i]}'),
            style: TextStyle(
              fontSize: m.cell * 0.56,
              height: 1,
              fontWeight: FontWeight.w800,
              color: dark ? Color.lerp(c, Colors.white, 0.45) : c,
            ),
          );
        } else {
          content = const SizedBox.shrink(key: ValueKey('empty'));
        }
        final bg = boom
            ? scheme.errorContainer
            : open
                ? (dark ? scheme.surfaceContainerLowest : scheme.surfaceContainerLow)
                : Color.alphaBlend(scheme.primary.withValues(alpha: dark ? 0.2 : 0.14), scheme.surfaceContainerHighest);
        final ring = errors.contains(pos)
            ? scheme.error
            : ctrl.flashHints.contains(pos)
                ? scheme.tertiary
                : null;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(m.cell * (open ? 0.1 : 0.18)),
            border: ring != null
                ? Border.all(color: ring, width: m.cell * 0.07)
                : Border.all(color: scheme.outlineVariant.withValues(alpha: open ? 0.25 : 0.5)),
            boxShadow: open
                ? null
                : [BoxShadow(color: Colors.black.withValues(alpha: 0.12), blurRadius: 2, offset: const Offset(0, 1))],
          ),
          alignment: Alignment.center,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            transitionBuilder: (child, anim) => ScaleTransition(scale: anim, child: FadeTransition(opacity: anim, child: child)),
            child: content,
          ),
        );
      },
    );
  }

  @override
  Widget? buildControls(BuildContext context, GameController controller) {
    final l = context.l10n;
    final p = controller.puzzle as MinesPuzzle;
    final s = controller.state as MinesState;
    final left = p.mineCount - s.flags.where((f) => f).length;
    final scheme = Theme.of(context).colorScheme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SegmentedButton<bool>(
          segments: [
            ButtonSegment(value: false, icon: const Icon(Icons.touch_app_outlined), label: Text(l.minesDig)),
            ButtonSegment(value: true, icon: const Icon(Icons.flag_outlined), label: Text(l.minesFlag)),
          ],
          selected: {controller.tool == flagTool},
          onSelectionChanged: (v) => controller.setTool(v.first ? flagTool : null),
        ),
        const SizedBox(width: 16),
        // Mines left to flag.
        MineSymbol(size: 22, color: scheme.onSurfaceVariant),
        const SizedBox(width: 6),
        Text('$left', style: Theme.of(context).textTheme.titleMedium),
      ],
    );
  }

  @override
  Map<String, dynamic> encodePuzzle(MinesPuzzle puzzle) => puzzle.toJson();
  @override
  MinesPuzzle decodePuzzle(Map<String, dynamic> json) => MinesPuzzle.fromJson(json);
  @override
  Map<String, dynamic> encodeState(MinesState state) => state.toJson();
  @override
  MinesState decodeState(Map<String, dynamic> json) => MinesState.fromJson(json);
}
