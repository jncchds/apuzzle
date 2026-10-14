import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/day.dart';
import '../../core/difficulty.dart';
import '../../core/game_controller.dart';
import '../../core/grid.dart';
import '../../core/puzzle_type.dart';
import '../../core/tutorial.dart';
import '../../l10n/l10n.dart';
import '../../ui/board/cell_grid_board.dart';
import 'blockade_generator.dart';
import 'blockade_model.dart';
import 'blockade_solver.dart';
import 'blockade_tutorial.dart';

/// Sail the boat to the harbour, one cell or one wait per turn, without
/// ever being caught by the patrol ships sailing their beats.
class BlockadeType extends PuzzleType<BlockadePuzzle, BlockadeState> {
  const BlockadeType();

  static const boatColor = Color(0xFF5EC4E8);

  /// One color per patrol ship (its beat is drawn in it too).
  static const shipColors = [
    Color(0xFFE0605A),
    Color(0xFFB57EDC),
    Color(0xFFFFA24C),
    Color(0xFFF28DB2),
    Color(0xFFE8C547),
    Color(0xFF9CCC65),
  ];

  @override
  String get id => 'blockade';
  @override
  String name(AppLocalizations l) => l.blockadeName;
  @override
  String tagline(AppLocalizations l) => l.blockadeTagline;
  @override
  IconData get icon => Icons.sailing_rounded;
  @override
  Color get accent => boatColor;

  @override
  String rulesText(AppLocalizations l) => l.blockadeRules;

  @override
  List<TutorialStep> tutorial() => blockadeTutorial;
  @override
  List<TutorialStep> strategies() => blockadeStrategies;

  @override
  List<GridSize> get sizes => [
    for (final n in [5, 6, 7, 8, 9, 10]) GridSize.square(n),
  ];
  @override
  GridSize get defaultSize => const GridSize.square(7);
  @override
  GridSize dailySize(Difficulty difficulty) => switch (difficulty) {
    Difficulty.easy => const GridSize.square(6),
    Difficulty.medium => const GridSize.square(7),
    _ => const GridSize.square(8),
  };
  @override
  Day get dailySince => const Day(2026, 10, 15);
  @override
  double get minCellSize => 36;
  @override
  double get controlsHeight => 64;
  @override
  bool get showSubmit => false;

  @override
  BlockadePuzzle generate(GenParams params) => generateBlockade(params);
  @override
  BlockadeState initialState(BlockadePuzzle puzzle) => BlockadeState([puzzle.start]);

  @override
  bool isComplete(BlockadePuzzle puzzle, BlockadeState state) => state.boat == puzzle.goal;
  @override
  bool isSolved(BlockadePuzzle puzzle, BlockadeState state) => blockadeSolved(puzzle, state.route);
  @override
  Set<Pos> conflicts(BlockadePuzzle puzzle, BlockadeState state) => const {};

  /// The next turn of a fastest passage. If the boat was caught, or the turns
  /// left can't reach the harbour any more, it first goes back to the last
  /// point of its passage from where it still can.
  @override
  HintResult<BlockadeState>? hint(BlockadePuzzle puzzle, BlockadeState state) {
    final route = state.route;
    if (blockadeSolved(puzzle, route)) return null;
    final solver = BlockadeSolver(puzzle);
    final caught = caughtTurn(puzzle, route);
    ({int moves, int first})? from(int k) {
      if (caught >= 0 && caught < k) return null;
      return solver.solve(route[k - 1], k - 1, maxMoves: puzzle.limit - (k - 1));
    }

    // Feasible prefixes come first: the longest one by bisection.
    var lo = 1, hi = route.length;
    while (lo < hi) {
      final mid = (lo + hi + 1) ~/ 2;
      if (from(mid) != null) {
        lo = mid;
      } else {
        hi = mid - 1;
      }
    }
    final next = from(lo);
    if (next == null || next.first < 0) return null;
    return HintResult(BlockadeState([...route.sublist(0, lo), next.first]), {puzzle.size.pos(next.first)});
  }

  @override
  Widget buildBoard(BuildContext context, GameController controller) => _BlockadeBoard(controller: controller);

  @override
  Widget? buildControls(BuildContext context, GameController ctrl) {
    final p = ctrl.puzzle as BlockadePuzzle;
    final s = ctrl.state as BlockadeState;
    final theme = Theme.of(context);
    final stuck = !ctrl.solved && (caughtTurn(p, s.route) >= 0 || s.turn >= p.limit);
    final color = stuck ? theme.colorScheme.error : null;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: color ?? theme.colorScheme.outline, width: 2),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.schedule_rounded, size: 20, color: color),
              const SizedBox(width: 6),
              Text(
                context.l10n.blockadeTurn(s.turn, p.limit),
                style: theme.textTheme.titleMedium?.copyWith(fontFeatures: const [FontFeature.tabularFigures()]),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        FilledButton.tonalIcon(
          onPressed: ctrl.solved ? null : () => blockadeSail(ctrl, s.boat),
          icon: const Icon(Icons.hourglass_bottom_rounded),
          label: Text(context.l10n.blockadeWait),
        ),
      ],
    );
  }

  @override
  Map<String, dynamic> encodePuzzle(BlockadePuzzle puzzle) => puzzle.toJson();
  @override
  BlockadePuzzle decodePuzzle(Map<String, dynamic> json) => BlockadePuzzle.fromJson(json);
  @override
  Map<String, dynamic> encodeState(BlockadeState state) => state.toJson();
  @override
  BlockadeState decodeState(Map<String, dynamic> json) => BlockadeState.fromJson(json);
}

/// Plays one turn: the boat sails to [to] (its own cell: waits). False if it
/// can't: not a move to open sea next to it, or the boat was caught or is
/// out of turns (a toast says so unless [quiet]).
bool blockadeSail(GameController ctrl, int to, {bool quiet = false}) {
  if (ctrl.solved) return false;
  final p = ctrl.puzzle as BlockadePuzzle;
  final s = ctrl.state as BlockadeState;
  if (!p.canSail(s.boat, to)) return false;
  if (caughtTurn(p, s.route) >= 0) {
    if (!quiet) ctrl.showToast((l) => l.blockadeCaught);
    return false;
  }
  if (s.turn >= p.limit) {
    if (!quiet) ctrl.showToast((l) => l.blockadeOutOfTurns);
    return false;
  }
  final route = [...s.route, to];
  ctrl.apply(BlockadeState(route));
  if (ctrl.solved) return true;
  if (blockadeCaught(p.patrols, s.boat, to, s.turn)) {
    ctrl.showToast((l) => l.blockadeCaught);
  } else if (route.length - 1 >= p.limit) {
    ctrl.showToast((l) => l.blockadeOutOfTurns);
  }
  return true;
}

class _BlockadeBoard extends StatefulWidget {
  const _BlockadeBoard({required this.controller});
  final GameController controller;

  @override
  State<_BlockadeBoard> createState() => _BlockadeBoardState();
}

class _BlockadeBoardState extends State<_BlockadeBoard> {
  final _focus = FocusNode();

  GameController get ctrl => widget.controller;
  BlockadePuzzle get p => ctrl.puzzle as BlockadePuzzle;
  BlockadeState get s => ctrl.state as BlockadeState;

  @override
  void dispose() {
    _focus.dispose();
    super.dispose();
  }

  void _tap(Pos pos) {
    _focus.requestFocus();
    blockadeSail(ctrl, p.size.index(pos));
  }

  /// A drag sails into each cell next to the boat it reaches.
  void _drag(Pos? pos) {
    if (pos == null) return;
    final i = p.size.index(pos);
    if (i != s.boat) blockadeSail(ctrl, i, quiet: true);
  }

  KeyEventResult _key(FocusNode _, KeyEvent e) {
    if (e is! KeyDownEvent && e is! KeyRepeatEvent) return KeyEventResult.ignored;
    final r = s.boat ~/ p.cols, c = s.boat % p.cols;
    final to = switch (e.logicalKey) {
      LogicalKeyboardKey.arrowUp || LogicalKeyboardKey.keyW => r > 0 ? s.boat - p.cols : null,
      LogicalKeyboardKey.arrowDown || LogicalKeyboardKey.keyS => r < p.rows - 1 ? s.boat + p.cols : null,
      LogicalKeyboardKey.arrowLeft || LogicalKeyboardKey.keyA => c > 0 ? s.boat - 1 : null,
      LogicalKeyboardKey.arrowRight || LogicalKeyboardKey.keyD => c < p.cols - 1 ? s.boat + 1 : null,
      LogicalKeyboardKey.space || LogicalKeyboardKey.period => s.boat,
      _ => -1,
    };
    if (to == -1) return KeyEventResult.ignored;
    if (to != null) blockadeSail(ctrl, to);
    return KeyEventResult.handled;
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final turn = s.turn;
    final caught = caughtTurn(p, s.route) >= 0;
    return Focus(
      focusNode: _focus,
      autofocus: true,
      onKeyEvent: _key,
      child: CellGridBoard(
        rows: p.rows,
        cols: p.cols,
        gapRatio: 0,
        maxCell: 72,
        win: ctrl.winAnimation,
        onTap: ctrl.solved ? null : _tap,
        onDragStart: ctrl.solved ? null : (pos, _) => _focus.requestFocus(),
        onDragUpdate: (pos, _) => _drag(pos),
        underlayBuilder: (context, m) => [
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Color.alphaBlend(const Color(0xFF3D8BD9).withValues(alpha: 0.16), scheme.surfaceContainer),
                borderRadius: BorderRadius.circular(m.cell * 0.12),
              ),
            ),
          ),
          Positioned.fill(
            child: CustomPaint(
              painter: _SeaPainter(
                puzzle: p,
                route: s.route,
                turn: turn,
                m: m,
                rock: Color.alphaBlend(const Color(0xFFB09468).withValues(alpha: 0.75), scheme.surface),
                trail: BlockadeType.boatColor,
              ),
            ),
          ),
        ],
        overlayBuilder: (context, m) {
          Widget token(int cell, double scale, Color color, IconData icon, Color border, {Key? key}) {
            final c = m.topLeft(p.size.pos(cell));
            final size = m.cell * scale;
            return AnimatedPositioned(
              key: key,
              duration: const Duration(milliseconds: 160),
              curve: Curves.easeOut,
              left: c.dx + (m.cell - size) / 2,
              top: c.dy + (m.cell - size) / 2,
              width: size,
              height: size,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                  border: Border.all(color: border, width: max(1.5, m.cell * 0.045)),
                  boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.3), blurRadius: m.cell * 0.08)],
                ),
                child: Icon(icon, size: size * 0.64, color: Colors.black87),
              ),
            );
          }

          return [
            token(
              s.boat,
              0.64,
              BlockadeType.boatColor,
              Icons.sailing_rounded,
              caught ? scheme.error : scheme.surface,
              key: const ValueKey('boat'),
            ),
            for (var k = 0; k < p.patrols.length; k++)
              token(
                p.patrols[k].at(turn),
                0.6,
                BlockadeType.shipColors[k % BlockadeType.shipColors.length],
                Icons.directions_boat_filled_rounded,
                scheme.surface,
                key: ValueKey('ship$k'),
              ),
          ];
        },
        cellBuilder: (context, pos, m) {
          final i = p.size.index(pos);
          final hinted = ctrl.flashHints.contains(pos);
          return Container(
            decoration: BoxDecoration(
              color: hinted ? scheme.tertiary.withValues(alpha: 0.35) : Colors.transparent,
              borderRadius: BorderRadius.circular(m.cell * 0.2),
            ),
            alignment: Alignment.center,
            child: i == p.goal ? _Harbour(size: m.cell * 0.78, color: scheme.onSurface) : null,
          );
        },
      ),
    );
  }
}

/// The harbour: an anchor in a ring.
class _Harbour extends StatelessWidget {
  const _Harbour({required this.size, required this.color});
  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) => Container(
    width: size,
    height: size,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      border: Border.all(color: color.withValues(alpha: 0.7), width: max(2, size * 0.07)),
    ),
    child: Icon(Icons.anchor_rounded, size: size * 0.6, color: color.withValues(alpha: 0.85)),
  );
}

/// Rocks, the ships' beats (a dot on every cell of the beat, and a ring
/// where each ship sails next), and the boat's passage so far.
class _SeaPainter extends CustomPainter {
  _SeaPainter({
    required this.puzzle,
    required this.route,
    required this.turn,
    required this.m,
    required this.rock,
    required this.trail,
  });

  final BlockadePuzzle puzzle;
  final List<int> route;
  final int turn;
  final BoardMetrics m;
  final Color rock;
  final Color trail;

  Offset _at(int i) => m.center(Pos(i ~/ puzzle.cols, i % puzzle.cols));

  @override
  void paint(Canvas canvas, Size size) {
    final p = puzzle, cell = m.cell;
    // Rocks: rounded squares, joined to rocks next to them.
    final rocks = Paint()..color = rock;
    final inset = cell * 0.06, half = cell / 2 - inset;
    for (var i = 0; i < p.cells; i++) {
      if (!p.rocks[i]) continue;
      final c = _at(i);
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(center: c, width: 2 * half, height: 2 * half),
          Radius.circular(cell * 0.22),
        ),
        rocks,
      );
      final r = i ~/ p.cols, col = i % p.cols;
      if (col < p.cols - 1 && p.rocks[i + 1]) {
        canvas.drawRect(Rect.fromLTRB(c.dx, c.dy - half, c.dx + cell, c.dy + half), rocks);
      }
      if (r < p.rows - 1 && p.rocks[i + p.cols]) {
        canvas.drawRect(Rect.fromLTRB(c.dx - half, c.dy, c.dx + half, c.dy + cell), rocks);
      }
    }

    Paint line(Color c, double w) => Paint()
      ..color = c
      ..style = PaintingStyle.stroke
      ..strokeWidth = w
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    for (var k = 0; k < p.patrols.length; k++) {
      final s = p.patrols[k];
      final color = BlockadeType.shipColors[k % BlockadeType.shipColors.length];
      final beat = Path()..moveTo(_at(s.route.first).dx, _at(s.route.first).dy);
      for (final i in s.route.skip(1)) {
        beat.lineTo(_at(i).dx, _at(i).dy);
      }
      if (s.loop) beat.close();
      canvas.drawPath(beat, line(color.withValues(alpha: 0.45), cell * 0.08));
      final dot = Paint()..color = color.withValues(alpha: 0.8);
      for (final i in s.route) {
        canvas.drawCircle(_at(i), cell * 0.07, dot);
      }
      // Where the ship will be after the next turn.
      canvas.drawCircle(_at(s.at(turn + 1)), cell * 0.3, line(color.withValues(alpha: 0.9), cell * 0.05));
    }

    if (route.length > 1) {
      final sailed = Path()..moveTo(_at(route.first).dx, _at(route.first).dy);
      for (final i in route.skip(1)) {
        sailed.lineTo(_at(i).dx, _at(i).dy);
      }
      canvas.drawPath(sailed, line(trail.withValues(alpha: 0.8), cell * 0.07));
    }
  }

  @override
  bool shouldRepaint(_SeaPainter old) =>
      old.route != route || old.turn != turn || old.m.cell != m.cell || old.rock != rock || old.puzzle != puzzle;
}
