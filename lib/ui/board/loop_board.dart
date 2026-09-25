import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../core/grid.dart';
import '../../core/lattice_loop.dart';

/// Where things are on a laid-out [LoopBoard].
class LoopGeom {
  const LoopGeom({required this.cell, required this.origin, required this.centered, required this.rows, required this.cols});

  final double cell;

  /// Top-left corner of the cell grid.
  final Offset origin;

  /// Loop points at cell centres (true) or at cell corners.
  final bool centered;
  final int rows;
  final int cols;

  Offset point(int r, int c) => origin + Offset((c + (centered ? 0.5 : 0)) * cell, (r + (centered ? 0.5 : 0)) * cell);
  Rect cellRect(int r, int c) => Rect.fromLTWH(origin.dx + c * cell, origin.dy + r * cell, cell, cell);
}

/// Board for "draw one loop" puzzles on a [LatticeLoop]. Tap an edge to cycle
/// line → cross → empty (secondary: cross ↔ empty); drag from point to point
/// to draw lines, or to erase them when the drag starts on a line.
class LoopBoard extends StatefulWidget {
  const LoopBoard({
    super.key,
    required this.g,
    required this.rows,
    required this.cols,
    required this.centered,
    required this.marks,
    required this.onCommit,
    required this.paintClues,
    required this.lineColor,
    this.enabled = true,
    this.win,
    this.hintCells = const {},
    this.errorCells = const {},
    this.cellBackground = false,
    this.cluesOnTop = false,
    this.maxCell = 72,
  });

  final LatticeLoop g;
  final int rows;
  final int cols;
  final bool centered;

  /// Per edge: 0 empty, 1 line, 2 cross.
  final List<int> marks;
  final void Function(List<int> marks) onCommit;

  /// Draws the clues (numbers, pearls), under the lines unless [cluesOnTop].
  final void Function(Canvas canvas, LoopGeom geo) paintClues;
  final bool cluesOnTop;
  final Color lineColor;
  final bool enabled;
  final Animation<double>? win;
  final Set<Pos> hintCells;
  final Set<Pos> errorCells;

  /// Draw a tile for every cell (for loops through cell centres).
  final bool cellBackground;
  final double maxCell;

  @override
  State<LoopBoard> createState() => _LoopBoardState();
}

class _LoopBoardState extends State<LoopBoard> {
  List<int>? _draft;
  int? _at;
  int? _mode;

  LatticeLoop get g => widget.g;
  List<int> get _marks => _draft ?? widget.marks;

  LoopGeom _geom(Size space) {
    final margin = widget.centered ? 0.0 : 0.4;
    final cell = min(
      min(space.width / (widget.cols + 2 * margin), space.height / (widget.rows + 2 * margin)),
      widget.maxCell,
    ).floorToDouble();
    return LoopGeom(
      cell: cell,
      origin: Offset(cell * margin, cell * margin),
      centered: widget.centered,
      rows: widget.rows,
      cols: widget.cols,
    );
  }

  Offset _pointPos(LoopGeom geo, int p) => geo.point(p ~/ g.vc, p % g.vc);

  int? _nearestEdge(LoopGeom geo, Offset o) {
    var best = -1;
    var bestD = double.infinity;
    for (var e = 0; e < g.edgeCount; e++) {
      final (a, b) = g.ends(e);
      final mid = (_pointPos(geo, a) + _pointPos(geo, b)) / 2;
      final d = (mid - o).distance;
      if (d < bestD) {
        bestD = d;
        best = e;
      }
    }
    return best >= 0 && bestD < geo.cell * 0.5 ? best : null;
  }

  int? _nearestPoint(LoopGeom geo, Offset o, double radius) {
    final c = ((o.dx - geo.origin.dx) / geo.cell - (geo.centered ? 0.5 : 0)).round();
    final r = ((o.dy - geo.origin.dy) / geo.cell - (geo.centered ? 0.5 : 0)).round();
    if (r < 0 || c < 0 || r >= g.vr || c >= g.vc) return null;
    return (geo.point(r, c) - o).distance <= geo.cell * radius ? r * g.vc + c : null;
  }

  void _tap(LoopGeom geo, Offset o, {bool secondary = false}) {
    final e = _nearestEdge(geo, o);
    if (e == null) return;
    final next = List.of(widget.marks);
    next[e] = secondary ? (next[e] == 2 ? 0 : 2) : (next[e] + 1) % 3;
    widget.onCommit(next);
  }

  void _panStart(LoopGeom geo, Offset o) {
    final p = _nearestPoint(geo, o, 0.6);
    if (p == null) return;
    setState(() {
      _draft = List.of(widget.marks);
      _at = p;
      _mode = null;
    });
  }

  void _panUpdate(LoopGeom geo, Offset o) {
    final d = _draft;
    final from = _at;
    if (d == null || from == null) return;
    final p = _nearestPoint(geo, o, 0.4);
    if (p == null || p == from) return;
    final r0 = from ~/ g.vc, c0 = from % g.vc, r1 = p ~/ g.vc, c1 = p % g.vc;
    if (r0 != r1 && c0 != c1) return;
    // Walk point by point (fast drags can skip some).
    final dr = (r1 - r0).sign, dc = (c1 - c0).sign;
    var cur = from;
    setState(() {
      while (cur != p) {
        final next = cur + dr * g.vc + dc;
        final e = g.between(cur, next);
        _mode ??= d[e] == 1 ? 0 : 1;
        d[e] = _mode!;
        cur = next;
      }
      _at = p;
    });
  }

  void _panEnd() {
    final d = _draft;
    setState(() {
      _draft = null;
      _at = null;
    });
    if (d == null) return;
    for (var e = 0; e < d.length; e++) {
      if (d[e] != widget.marks[e]) {
        widget.onCommit(d);
        return;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return LayoutBuilder(builder: (context, cons) {
      final geo = _geom(cons.biggest);
      final size = Size(
        geo.cell * widget.cols + geo.origin.dx * 2,
        geo.cell * widget.rows + geo.origin.dy * 2,
      );
      final on = widget.enabled;
      Widget paint(double pulse) => CustomPaint(
            size: size,
            painter: _LoopPainter(
              g: g,
              geo: geo,
              marks: _marks,
              lineColor: widget.lineColor,
              dotColor: scheme.onSurface.withValues(alpha: 0.55),
              crossColor: scheme.onSurface.withValues(alpha: 0.4),
              tileColor: widget.cellBackground ? scheme.surfaceContainer : null,
              hintColor: scheme.tertiary.withValues(alpha: 0.3),
              errorColor: scheme.error.withValues(alpha: 0.3),
              hintCells: widget.hintCells,
              errorCells: widget.errorCells,
              paintClues: widget.paintClues,
              cluesOnTop: widget.cluesOnTop,
              pulse: pulse,
            ),
          );
      final win = widget.win;
      return Center(
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          // Start drags where the finger went down, not after the slop.
          dragStartBehavior: DragStartBehavior.down,
          onTapUp: on ? (d) => _tap(geo, d.localPosition) : null,
          onSecondaryTapUp: on ? (d) => _tap(geo, d.localPosition, secondary: true) : null,
          onLongPressStart: on ? (d) => _tap(geo, d.localPosition, secondary: true) : null,
          onPanStart: on ? (d) => _panStart(geo, d.localPosition) : null,
          onPanUpdate: on ? (d) => _panUpdate(geo, d.localPosition) : null,
          onPanEnd: on ? (_) => _panEnd() : null,
          onPanCancel: on ? _panEnd : null,
          child: win == null
              ? paint(0)
              : AnimatedBuilder(animation: win, builder: (context, _) => paint(sin(pi * win.value))),
        ),
      );
    });
  }
}

class _LoopPainter extends CustomPainter {
  _LoopPainter({
    required this.g,
    required this.geo,
    required this.marks,
    required this.lineColor,
    required this.dotColor,
    required this.crossColor,
    required this.tileColor,
    required this.hintColor,
    required this.errorColor,
    required this.hintCells,
    required this.errorCells,
    required this.paintClues,
    required this.cluesOnTop,
    required this.pulse,
  });

  final LatticeLoop g;
  final LoopGeom geo;
  final List<int> marks;
  final Color lineColor;
  final Color dotColor;
  final Color crossColor;
  final Color? tileColor;
  final Color hintColor;
  final Color errorColor;
  final Set<Pos> hintCells;
  final Set<Pos> errorCells;
  final void Function(Canvas canvas, LoopGeom geo) paintClues;
  final bool cluesOnTop;
  final double pulse;

  Offset _pos(int p) => geo.point(p ~/ g.vc, p % g.vc);

  @override
  void paint(Canvas canvas, Size size) {
    final cell = geo.cell;
    for (var r = 0; r < geo.rows; r++) {
      for (var c = 0; c < geo.cols; c++) {
        final rect = geo.cellRect(r, c).deflate(cell * 0.04);
        final rr = RRect.fromRectAndRadius(rect, Radius.circular(cell * 0.12));
        if (tileColor != null) canvas.drawRRect(rr, Paint()..color = tileColor!);
        if (hintCells.contains(Pos(r, c))) canvas.drawRRect(rr, Paint()..color = hintColor);
        if (errorCells.contains(Pos(r, c))) canvas.drawRRect(rr, Paint()..color = errorColor);
      }
    }
    if (!cluesOnTop) paintClues(canvas, geo);

    final line = Paint()
      ..color = lineColor
      ..strokeWidth = cell * (0.14 + 0.06 * pulse)
      ..strokeCap = StrokeCap.round;
    final cross = Paint()
      ..color = crossColor
      ..strokeWidth = max(1.5, cell * 0.04)
      ..strokeCap = StrokeCap.round;
    for (var e = 0; e < marks.length; e++) {
      if (marks[e] == 0) continue;
      final (a, b) = g.ends(e);
      final pa = _pos(a), pb = _pos(b);
      if (marks[e] == 1) {
        canvas.drawLine(pa, pb, line);
      } else {
        final m = (pa + pb) / 2;
        final s = cell * 0.09;
        canvas.drawLine(m + Offset(-s, -s), m + Offset(s, s), cross);
        canvas.drawLine(m + Offset(-s, s), m + Offset(s, -s), cross);
      }
    }
    // Points: dots on a corner lattice, joints on a centred one.
    for (var p = 0; p < g.vertexCount; p++) {
      final used = g.incident[p].any((e) => marks[e] == 1);
      if (geo.centered) {
        if (used) canvas.drawCircle(_pos(p), cell * (0.07 + 0.03 * pulse), Paint()..color = lineColor);
      } else {
        canvas.drawCircle(_pos(p), used ? cell * (0.07 + 0.03 * pulse) : cell * 0.05, Paint()..color = used ? lineColor : dotColor);
      }
    }
    if (cluesOnTop) paintClues(canvas, geo);
  }

  @override
  bool shouldRepaint(_LoopPainter old) => true;
}
