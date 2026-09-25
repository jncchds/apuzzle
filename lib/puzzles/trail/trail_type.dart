import 'package:flutter/material.dart';

import '../../core/difficulty.dart';
import '../../core/game_controller.dart';
import '../../core/grid.dart';
import '../../core/puzzle_type.dart';
import '../../l10n/l10n.dart';
import '../../ui/board/cell_grid_board.dart';
import 'trail_generator.dart';
import 'trail_model.dart';

/// Draw one path through every cell, passing the numbers in order.
class TrailType extends PuzzleType<TrailPuzzle, TrailState> {
  const TrailType();

  static const trailColor = Color(0xFFC89BC0);

  @override
  String get id => 'trail';
  @override
  String name(AppLocalizations l) => l.trailName;
  @override
  String tagline(AppLocalizations l) => l.trailTagline;
  @override
  IconData get icon => Icons.route_rounded;
  @override
  Color get accent => trailColor;

  @override
  String rulesText(AppLocalizations l) => l.trailRules;

  @override
  List<GridSize> get sizes => [for (var n = 4; n <= 10; n++) GridSize.square(n)];
  @override
  GridSize get defaultSize => const GridSize.square(6);
  @override
  double get controlsHeight => 40;

  @override
  TrailPuzzle generate(GenParams params) => generateTrail(params);
  @override
  TrailState initialState(TrailPuzzle puzzle) => TrailState([puzzle.startCell]);

  @override
  bool isComplete(TrailPuzzle puzzle, TrailState state) => state.path.length == puzzle.rows * puzzle.cols;
  @override
  bool isSolved(TrailPuzzle puzzle, TrailState state) => trailValid(puzzle, state.path);
  @override
  Set<Pos> conflicts(TrailPuzzle puzzle, TrailState state) {
    if (!isComplete(puzzle, state) || isSolved(puzzle, state)) return const {};
    return {puzzle.size.pos(state.path.last)};
  }

  @override
  HintResult<TrailState>? hint(TrailPuzzle puzzle, TrailState state) {
    var k = 0;
    while (k < state.path.length && state.path[k] == puzzle.solution[k]) {
      k++;
    }
    if (k >= puzzle.solution.length) return null;
    final next = [...puzzle.solution.sublist(0, k + 1)];
    return HintResult(TrailState(next), {puzzle.size.pos(puzzle.solution[k])});
  }

  @override
  Widget buildBoard(BuildContext context, GameController controller) => _TrailBoard(controller: controller);

  @override
  Map<String, dynamic> encodePuzzle(TrailPuzzle puzzle) => puzzle.toJson();
  @override
  TrailPuzzle decodePuzzle(Map<String, dynamic> json) => TrailPuzzle.fromJson(json);
  @override
  Map<String, dynamic> encodeState(TrailState state) => state.toJson();
  @override
  TrailState decodeState(Map<String, dynamic> json) => TrailState.fromJson(json);
}

class _TrailBoard extends StatefulWidget {
  const _TrailBoard({required this.controller});
  final GameController controller;

  @override
  State<_TrailBoard> createState() => _TrailBoardState();
}

class _TrailBoardState extends State<_TrailBoard> {
  /// Path being edited during a drag (committed to the controller on release).
  List<int>? _draft;

  GameController get ctrl => widget.controller;
  TrailPuzzle get p => ctrl.puzzle as TrailPuzzle;

  List<int> get _path => _draft ?? (ctrl.state as TrailState).path;

  void _start(Pos pos) {
    final i = p.size.index(pos);
    final path = (ctrl.state as TrailState).path;
    final at = path.indexOf(i);
    if (at >= 0) {
      setState(() => _draft = path.sublist(0, at + 1));
    } else if (path.isNotEmpty && trailAdjacent(path.last, i, p.cols)) {
      setState(() => _draft = List.of(path));
      _extend(pos);
    }
  }

  void _extend(Pos? pos) {
    final d = _draft;
    if (d == null || pos == null) return;
    final i = p.size.index(pos);
    if (d.isEmpty || i == d.last) return;
    if (d.length >= 2 && i == d[d.length - 2]) {
      setState(() => d.removeLast());
      return;
    }
    if (d.contains(i) || !trailAdjacent(d.last, i, p.cols)) return;
    final v = p.numbers[i];
    if (v != null && v != trailNextNumber(p, d)) return; // numbers in order only
    final lastCell = p.numbers.indexOf(p.lastNumber);
    if (d.last == lastCell) return; // path already ended
    setState(() => d.add(i));
  }

  void _end() {
    final d = _draft;
    if (d == null) return;
    setState(() => _draft = null);
    final cur = (ctrl.state as TrailState).path;
    if (d.length == cur.length && d.every((x) => cur.contains(x))) return;
    ctrl.apply(TrailState(d.isEmpty ? [p.startCell] : List.of(d)));
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final path = _path;
    final onPath = path.toSet();
    final errors = ctrl.errorCells;
    return CellGridBoard(
      rows: p.rows,
      cols: p.cols,
      gapRatio: 0.03,
      maxCell: 84,
      win: ctrl.winAnimation,
      onTap: ctrl.solved
          ? null
          : (pos) {
              final i = p.size.index(pos);
              final cur = (ctrl.state as TrailState).path;
              final at = cur.indexOf(i);
              if (at >= 0 && at < cur.length - 1) ctrl.apply(TrailState(cur.sublist(0, at + 1)));
            },
      onDragStart: ctrl.solved ? null : (pos, _) => _start(pos),
      onDragUpdate: (pos, _) => _extend(pos),
      onDragEnd: _end,
      underlayBuilder: (context, m) => [
        Positioned.fill(
          child: CustomPaint(painter: _PathPainter(path: path, m: m, color: TrailType.trailColor)),
        ),
      ],
      cellBuilder: (context, pos, m) {
        final i = p.size.index(pos);
        final v = p.numbers[i];
        final hinted = ctrl.flashHints.contains(pos);
        return Container(
          decoration: BoxDecoration(
            color: onPath.contains(i) ? Colors.transparent : scheme.surfaceContainer.withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(m.cell * 0.12),
            border: Border.all(
              color: errors.contains(pos)
                  ? scheme.error
                  : hinted
                      ? scheme.tertiary
                      : scheme.outlineVariant.withValues(alpha: 0.5),
              width: errors.contains(pos) || hinted ? 2.5 : 1,
            ),
          ),
          alignment: Alignment.center,
          child: v == null
              ? null
              : AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: m.cell * 0.62,
                  height: m.cell * 0.62,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: onPath.contains(i) ? Colors.white : const Color(0xFFEFF2FA),
                    border: Border.all(color: onPath.contains(i) ? TrailType.trailColor : Colors.black26, width: 2),
                  ),
                  alignment: Alignment.center,
                  child: Text('$v',
                      style: TextStyle(fontSize: m.cell * 0.3, fontWeight: FontWeight.w700, color: Colors.black87)),
                ),
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
    if (path.isEmpty) return;
    final pts = [for (final i in path) m.center(Pos(i ~/ m.cols, i % m.cols))];
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = m.cell * 0.62
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    if (pts.length == 1) {
      canvas.drawCircle(pts.first, m.cell * 0.31, Paint()..color = color);
      return;
    }
    final pathObj = Path()..moveTo(pts.first.dx, pts.first.dy);
    for (final o in pts.skip(1)) {
      pathObj.lineTo(o.dx, o.dy);
    }
    canvas.drawPath(pathObj, paint);
    // Head marker.
    canvas.drawCircle(pts.last, m.cell * 0.14, Paint()..color = Colors.white.withValues(alpha: 0.85));
  }

  @override
  bool shouldRepaint(_PathPainter old) => true;
}
