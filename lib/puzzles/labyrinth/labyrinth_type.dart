import 'dart:math';

import 'package:flutter/material.dart';

import '../../core/difficulty.dart';
import '../../core/game_controller.dart';
import '../../core/grid.dart';
import '../../core/puzzle_type.dart';
import '../../l10n/l10n.dart';
import '../../ui/board/cell_grid_board.dart';
import 'labyrinth_generator.dart';
import 'labyrinth_model.dart';

/// Walk through the maze from the top-left corner to the bottom-right one.
class LabyrinthType extends PuzzleType<LabyrinthPuzzle, LabyrinthState> {
  const LabyrinthType();

  static const pathColor = Color(0xFF7FC98E);

  @override
  String get id => 'labyrinth';
  @override
  String name(AppLocalizations l) => l.labyrinthName;
  @override
  String tagline(AppLocalizations l) => l.labyrinthTagline;
  @override
  IconData get icon => Icons.explore_rounded;
  @override
  Color get accent => pathColor;

  @override
  String rulesText(AppLocalizations l) => l.labyrinthRules;

  @override
  List<GridSize> get sizes => const [
        GridSize.square(6),
        GridSize.square(8),
        GridSize.square(10),
        GridSize.square(12),
        GridSize(16, 12),
        GridSize(20, 14),
        GridSize(24, 16),
      ];
  @override
  GridSize get defaultSize => const GridSize.square(10);
  @override
  GridSize dailySize(Difficulty difficulty) => switch (difficulty) {
        Difficulty.easy => const GridSize.square(6),
        Difficulty.medium => const GridSize.square(8),
        _ => const GridSize.square(10),
      };
  @override
  double get minCellSize => 24;
  @override
  double get controlsHeight => 40;
  @override
  bool get showSubmit => false;

  @override
  LabyrinthPuzzle generate(GenParams params) => generateLabyrinth(params);
  @override
  LabyrinthState initialState(LabyrinthPuzzle puzzle) => LabyrinthState([puzzle.start]);

  @override
  bool isComplete(LabyrinthPuzzle puzzle, LabyrinthState state) => state.path.last == puzzle.exit;
  @override
  bool isSolved(LabyrinthPuzzle puzzle, LabyrinthState state) => labyrinthSolved(puzzle, state.path);
  @override
  Set<Pos> conflicts(LabyrinthPuzzle puzzle, LabyrinthState state) => const {};

  /// Steps back to where the path left the way out, then walks on to the next
  /// junction (or the exit).
  @override
  HintResult<LabyrinthState>? hint(LabyrinthPuzzle puzzle, LabyrinthState state) {
    final sol = puzzle.solution;
    var k = 0;
    while (k < state.path.length && k < sol.length && state.path[k] == sol[k]) {
      k++;
    }
    if (k >= sol.length) return null;
    final added = <int>[];
    for (var j = k; j < sol.length; j++) {
      added.add(sol[j]);
      if (exits(puzzle, sol[j]) > 2) break;
    }
    final next = [...sol.sublist(0, k), ...added];
    return HintResult(LabyrinthState(next), {for (final i in added) puzzle.size.pos(i)});
  }

  @override
  Widget buildBoard(BuildContext context, GameController controller) => _LabyrinthBoard(controller: controller);

  @override
  Map<String, dynamic> encodePuzzle(LabyrinthPuzzle puzzle) => puzzle.toJson();
  @override
  LabyrinthPuzzle decodePuzzle(Map<String, dynamic> json) => LabyrinthPuzzle.fromJson(json);
  @override
  Map<String, dynamic> encodeState(LabyrinthState state) => state.toJson();
  @override
  LabyrinthState decodeState(Map<String, dynamic> json) => LabyrinthState.fromJson(json);
}

/// [path] moved towards cell [i]: back to it if it is on the path, or on along
/// a straight open corridor (so fast drags that skip cells still count).
/// Null if [i] can't be reached that way.
List<int>? _moveTo(LabyrinthPuzzle p, List<int> path, int i) {
  final at = path.indexOf(i);
  final run = corridor(p, path.last, i);
  if (run == null) return null;
  if (at >= 0) return path.sublist(0, at + 1);
  if (path.last == p.exit || run.any(path.contains)) return null;
  final out = [...path];
  for (final j in run) {
    out.add(j);
    if (j == p.exit) break;
  }
  return out;
}

class _LabyrinthBoard extends StatefulWidget {
  const _LabyrinthBoard({required this.controller});
  final GameController controller;

  @override
  State<_LabyrinthBoard> createState() => _LabyrinthBoardState();
}

class _LabyrinthBoardState extends State<_LabyrinthBoard> {
  /// Path being edited during a drag (committed to the controller on release).
  List<int>? _draft;

  GameController get ctrl => widget.controller;
  LabyrinthPuzzle get p => ctrl.puzzle as LabyrinthPuzzle;
  List<int> get _committed => (ctrl.state as LabyrinthState).path;
  List<int> get _path => _draft ?? _committed;

  void _start(Pos pos) {
    final i = p.size.index(pos);
    final at = _committed.indexOf(i);
    // Grab the path anywhere to cut it there, or carry on from its end.
    setState(() => _draft = at >= 0 ? _committed.sublist(0, at + 1) : List.of(_committed));
    if (at < 0) _extend(pos);
  }

  void _extend(Pos? pos) {
    final d = _draft;
    if (d == null || pos == null) return;
    final next = _moveTo(p, d, p.size.index(pos));
    if (next != null) setState(() => _draft = next);
  }

  void _end() {
    final d = _draft;
    if (d == null) return;
    setState(() => _draft = null);
    _commit(d);
  }

  void _commit(List<int> path) {
    final cur = _committed;
    if (path.length == cur.length && path.last == cur.last) return;
    ctrl.apply(LabyrinthState(List.of(path)));
  }

  void _tap(Pos pos) {
    final i = p.size.index(pos);
    final at = _committed.indexOf(i);
    final next = at >= 0 ? _committed.sublist(0, at + 1) : _moveTo(p, _committed, i);
    if (next != null) _commit(next);
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final path = _path;
    return CellGridBoard(
      rows: p.rows,
      cols: p.cols,
      gapRatio: 0,
      maxCell: 64,
      win: ctrl.winAnimation,
      onTap: ctrl.solved ? null : _tap,
      onDragStart: ctrl.solved ? null : (pos, _) => _start(pos),
      onDragUpdate: (pos, _) => _extend(pos),
      onDragEnd: _end,
      underlayBuilder: (context, m) => [
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: scheme.surfaceContainer,
              borderRadius: BorderRadius.circular(m.cell * 0.1),
            ),
          ),
        ),
        Positioned.fill(
          child: CustomPaint(painter: _PathPainter(path: path, m: m, color: LabyrinthType.pathColor)),
        ),
      ],
      overlayBuilder: (context, m) => [
        Positioned.fill(
          child: CustomPaint(painter: _WallPainter(puzzle: p, m: m, color: scheme.onSurfaceVariant)),
        ),
      ],
      cellBuilder: (context, pos, m) {
        final i = p.size.index(pos);
        final hinted = ctrl.flashHints.contains(pos);
        return Container(
          color: hinted ? scheme.tertiary.withValues(alpha: 0.28) : Colors.transparent,
          alignment: Alignment.center,
          child: i == p.exit && path.last != p.exit
              ? Icon(Icons.flag_rounded, size: m.cell * 0.62, color: scheme.primary)
              : null,
        );
      },
    );
  }
}

class _PathPainter extends CustomPainter {
  _PathPainter({required this.path, required this.m, required this.color});

  final List<int> path;
  final BoardMetrics m;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final pts = [for (final i in path) m.center(Pos(i ~/ m.cols, i % m.cols))];
    if (pts.length > 1) {
      final line = Path()..moveTo(pts.first.dx, pts.first.dy);
      for (final o in pts.skip(1)) {
        line.lineTo(o.dx, o.dy);
      }
      canvas.drawPath(
        line,
        Paint()
          ..color = color.withValues(alpha: 0.75)
          ..style = PaintingStyle.stroke
          ..strokeWidth = m.cell * 0.34
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round,
      );
    }
    // The walker.
    canvas.drawCircle(pts.last, m.cell * 0.3, Paint()..color = color);
    canvas.drawCircle(pts.last, m.cell * 0.12, Paint()..color = Colors.white.withValues(alpha: 0.9));
  }

  @override
  bool shouldRepaint(_PathPainter old) => true;
}

/// Maze walls, with a gap in the outer wall at the entrance and at the exit.
class _WallPainter extends CustomPainter {
  _WallPainter({required this.puzzle, required this.m, required this.color});

  final LabyrinthPuzzle puzzle;
  final BoardMetrics m;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = max(2.0, m.cell * 0.12)
      ..strokeCap = StrokeCap.round;
    final p = puzzle;
    for (var r = 0; r < p.rows; r++) {
      for (var c = 0; c < p.cols; c++) {
        final i = r * p.cols + c;
        final x0 = m.x(c), y0 = m.y(r), x1 = x0 + m.cell, y1 = y0 + m.cell;
        if (r == 0 || p.open[i] & dN == 0) canvas.drawLine(Offset(x0, y0), Offset(x1, y0), paint);
        if (c == 0 && i != p.start) canvas.drawLine(Offset(x0, y0), Offset(x0, y1), paint);
        if (p.open[i] & dE == 0 && i != p.exit) canvas.drawLine(Offset(x1, y0), Offset(x1, y1), paint);
        if (p.open[i] & dS == 0) canvas.drawLine(Offset(x0, y1), Offset(x1, y1), paint);
      }
    }
  }

  @override
  bool shouldRepaint(_WallPainter old) => old.puzzle != puzzle || old.m.cell != m.cell || old.color != color;
}
