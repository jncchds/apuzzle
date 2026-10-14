import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../core/game_controller.dart';
import '../../core/grid.dart';
import '../../l10n/l10n.dart';
import 'inlay_model.dart';

/// Piece colors, readable on both themes.
const inlayColors = [
  Color(0xFFE8925A),
  Color(0xFF5EB8E8),
  Color(0xFF9CCC65),
  Color(0xFFB57EDC),
  Color(0xFFF2C14E),
  Color(0xFFE86A7E),
  Color(0xFF4DB6AC),
  Color(0xFF7E8CE0),
  Color(0xFFD4A373),
  Color(0xFFF28DB2),
  Color(0xFF6CC48B),
  Color(0xFFE0605A),
  Color(0xFF8FB3D9),
  Color(0xFFC9B458),
];

Color inlayColor(int piece) => inlayColors[piece % inlayColors.length];

/// Where the board, the tray slots and the flip button go in the room given.
class InlayLayout {
  InlayLayout({required this.board, required this.cell, required this.tray, required this.slots, this.flip});

  /// The grid's top-left corner and cell size.
  final Offset board;
  final double cell;

  /// Size of a cell of a piece waiting in the tray.
  final double tray;

  /// One square per piece: it waits in the middle of it, in any turn.
  final List<Rect> slots;

  /// The flip button, when the puzzle allows mirroring.
  final Rect? flip;

  Rect boardRect(InlayPuzzle p) => board & Size(p.cols * cell, p.rows * cell);

  /// Lays out [p] in [space]: the tray under the board or beside it,
  /// whichever leaves the board bigger.
  static InlayLayout of(InlayPuzzle p, Size space) {
    const sep = 14.0, button = 48.0;
    final sides = [
      for (final piece in p.pieces) max(piece.map((c) => c.$1).reduce(max), piece.map((c) => c.$2).reduce(max)) + 1,
    ];

    /// The slots packed in rows into [width] × [height] with tray cell [t].
    List<Rect>? pack(double width, double height, double t) {
      final gap = t * 0.7;
      final sizes = [for (final s in sides) s * t + gap, if (p.flip) button];
      final rows = <List<double>>[[]];
      var x = 0.0;
      for (final s in sizes) {
        if (s > width) return null;
        if (x + s > width) {
          rows.add([]);
          x = 0;
        }
        rows.last.add(s);
        x += s;
      }
      final heights = [for (final r in rows) r.reduce(max)];
      final total = heights.fold(0.0, (a, b) => a + b);
      if (total > height) return null;
      final out = <Rect>[];
      var y = (height - total) / 2;
      for (var k = 0; k < rows.length; k++) {
        var x = (width - rows[k].fold(0.0, (a, b) => a + b)) / 2;
        for (final s in rows[k]) {
          out.add(Rect.fromLTWH(x, y + (heights[k] - s) / 2, s, s));
          x += s;
        }
        y += heights[k];
      }
      return out;
    }

    InlayLayout? best;
    for (final beside in [false, true]) {
      final top = min(min(space.width / p.cols, space.height / p.rows), 64.0).floorToDouble();
      for (var b = top; b >= 10; b--) {
        final bw = p.cols * b, bh = p.rows * b;
        final (tw, th) = beside ? (space.width - bw - sep, space.height) : (space.width, space.height - bh - sep);
        if (tw <= 0 || th <= 0) continue;
        var t = b * 0.42;
        var slots = pack(tw, th, t);
        if (slots == null) continue;
        // A roomier tray when there is space for it.
        while (t + 0.5 <= b * 0.8) {
          final more = pack(tw, th, t + 0.5);
          if (more == null) break;
          t += 0.5;
          slots = more;
        }
        if (best != null && (b < best.cell || b == best.cell && t <= best.tray)) break;
        // Board and tray together, centred in the room.
        final usedW = beside ? bw + sep + _span(slots!, true) : max(bw, _span(slots!, true));
        final usedH = beside ? max(bh, _span(slots, false)) : bh + sep + _span(slots, false);
        final o = Offset((space.width - usedW) / 2, (space.height - usedH) / 2);
        final board = beside ? o + Offset(0, (usedH - bh) / 2) : o + Offset((usedW - bw) / 2, 0);
        final trayO = beside ? Offset(o.dx + bw + sep, 0) : Offset(0, o.dy + bh + sep);
        final trayBox = _box(slots);
        final shift = beside
            ? trayO + Offset(-trayBox.left, (space.height - trayBox.height) / 2 - trayBox.top)
            : trayO + Offset((space.width - trayBox.width) / 2 - trayBox.left, -trayBox.top);
        final placed = [for (final r in slots) r.shift(shift)];
        best = InlayLayout(
          board: board,
          cell: b,
          tray: t,
          slots: placed.sublist(0, p.pieces.length),
          flip: p.flip ? placed.last : null,
        );
        break;
      }
    }
    return best ??
        InlayLayout(
          board: Offset.zero,
          cell: 10,
          tray: 5,
          slots: [for (var k = 0; k < p.pieces.length; k++) Rect.zero],
        );
  }

  static Rect _box(List<Rect> rs) => rs.reduce((a, b) => a.expandToInclude(b));
  static double _span(List<Rect> rs, bool wide) => wide ? _box(rs).width : _box(rs).height;
}

/// The shape, the pieces laid on it and the tray of pieces left. Drag a
/// piece onto the shape (it snaps to the cells) or off it to take it back,
/// tap a piece to turn it, flip it with the button or a right click.
class InlayBoard extends StatefulWidget {
  const InlayBoard({super.key, required this.controller});
  final GameController controller;

  @override
  State<InlayBoard> createState() => _InlayBoardState();
}

class _Drag {
  _Drag(this.piece, this.orient, this.grab, this.at);
  final int piece;
  final int orient;

  /// Where the finger holds the piece, in cells from its top-left corner.
  final Offset grab;
  Offset at;
}

class _InlayBoardState extends State<InlayBoard> {
  _Drag? _drag;
  int? _selected;

  GameController get ctrl => widget.controller;
  InlayPuzzle get p => ctrl.puzzle as InlayPuzzle;
  InlayState get s => ctrl.state as InlayState;

  /// The top-left corner of [piece] waiting in its tray slot.
  Offset _trayOrigin(InlayLayout l, int piece) {
    final (h, w) = p.extent(piece, s.orient[piece]);
    return l.slots[piece].center - Offset(w * l.tray / 2, h * l.tray / 2);
  }

  /// The piece under [o], on the board or in the tray, or null.
  int? _pieceAt(InlayLayout l, Offset o) {
    final b = l.boardRect(p);
    if (b.contains(o)) {
      final r = ((o.dy - b.top) / l.cell).floor(), c = ((o.dx - b.left) / l.cell).floor();
      final k = inlayOwners(p, s)[r * p.cols + c];
      if (k >= 0) return k;
    }
    for (var k = 0; k < p.pieces.length; k++) {
      if (!s.placed(k) && l.slots[k].contains(o)) return k;
    }
    return null;
  }

  /// Where [piece] in orientation [o] would snap with its top-left corner at
  /// [corner], or null if it doesn't fit there.
  (int, int)? _snap(InlayLayout l, int piece, int o, Offset corner) {
    final (h, w) = p.extent(piece, o);
    final r = ((corner.dy - l.board.dy) / l.cell).round().clamp(0, max(0, p.rows - h)).toInt();
    final c = ((corner.dx - l.board.dx) / l.cell).round().clamp(0, max(0, p.cols - w)).toInt();
    final owners = inlayOwners(p, s);
    return inlayFits(p, s, piece, o, r, c, owners: owners) ? (r, c) : null;
  }

  /// Turns (or with [flip], mirrors) [piece]. One on the board turns round
  /// the cell [pivot]; if it has no room there it stays as it is.
  void _turn(int piece, {bool flip = false, int? pivot}) {
    if (ctrl.solved) return;
    if (flip && !p.flip) return;
    setState(() => _selected = piece);
    final o = s.orient[piece];
    final next = flip ? flipOrientation(o) : turnOrientation(o);
    if (!s.placed(piece)) {
      ctrl.apply(s.withPiece(piece, orient: next));
      return;
    }
    final cells = pieceCells(p, s, piece);
    final k = pivot == null ? 0 : max(0, cells.indexOf(pivot));
    final (pr, pc) = (cells[k] ~/ p.cols, cells[k] % p.cols);
    final turned = p.cellsOf(piece, next);
    final (ir, ic) = (pr - turned[k].$1, pc - turned[k].$2);
    final owners = inlayOwners(p, s);
    // The turned piece still covers the cell tapped, as near as it fits to
    // turning round it.
    (int, int)? best;
    var bestDist = 1 << 20;
    for (final (dr, dc) in turned) {
      final r = pr - dr, c = pc - dc;
      final dist = (r - ir) * (r - ir) + (c - ic) * (c - ic);
      if (dist < bestDist && inlayFits(p, s, piece, next, r, c, owners: owners)) {
        best = (r, c);
        bestDist = dist;
      }
    }
    if (best case (final r, final c)) {
      ctrl.apply(s.withPiece(piece, orient: next, at: r * p.cols + c));
    } else {
      ctrl.showToast((l) => l.inlayNoRoom);
    }
  }

  void _tap(InlayLayout l, Offset o, {bool flip = false}) {
    if (ctrl.solved) return;
    final k = _pieceAt(l, o);
    if (k == null) return;
    final b = l.boardRect(p);
    final pivot = s.placed(k) && b.contains(o)
        ? ((o.dy - b.top) / l.cell).floor() * p.cols + ((o.dx - b.left) / l.cell).floor()
        : null;
    _turn(k, flip: flip, pivot: pivot);
  }

  void _start(InlayLayout l, Offset o) {
    if (ctrl.solved) return;
    final k = _pieceAt(l, o);
    if (k == null) return;
    final orient = s.orient[k];
    final (h, w) = p.extent(k, orient);
    Offset grab;
    if (s.placed(k)) {
      final corner = l.board + Offset((s.at[k] % p.cols) * l.cell, (s.at[k] ~/ p.cols) * l.cell);
      grab = (o - corner) / l.cell;
    } else {
      grab = (o - _trayOrigin(l, k)) / l.tray;
    }
    grab = Offset(grab.dx.clamp(0, w.toDouble()), grab.dy.clamp(0, h.toDouble()));
    setState(() {
      _selected = k;
      _drag = _Drag(k, orient, grab, o);
    });
  }

  void _end(InlayLayout l) {
    final d = _drag;
    if (d == null) return;
    setState(() => _drag = null);
    if (ctrl.solved) return;
    final b = l.boardRect(p).inflate(l.cell / 2);
    if (b.contains(d.at)) {
      final spot = _snap(l, d.piece, d.orient, d.at - d.grab * l.cell);
      if (spot != null) {
        final at = spot.$1 * p.cols + spot.$2;
        if (at != s.at[d.piece]) ctrl.apply(s.withPiece(d.piece, at: at));
      }
      // No room there: it goes back where it was.
    } else if (s.placed(d.piece)) {
      ctrl.apply(s.withPiece(d.piece, at: -1));
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return LayoutBuilder(
      builder: (context, cons) {
        final l = InlayLayout.of(p, cons.biggest);
        final d = _drag;
        final ghost = d == null ? null : _snap(l, d.piece, d.orient, d.at - d.grab * l.cell);
        final onBoard = d != null && l.boardRect(p).inflate(l.cell / 2).contains(d.at);
        final painter = _InlayPainter(
          puzzle: p,
          state: s,
          layout: l,
          drag: d,
          ghost: onBoard ? ghost : null,
          selected: ctrl.solved ? null : _selected,
          hints: ctrl.flashHints,
          slot: scheme.surfaceContainerHighest,
          line: scheme.onSurface,
          hint: scheme.tertiary,
        );
        Widget board = CustomPaint(size: cons.biggest, painter: painter);
        if (ctrl.winAnimation case final win?) {
          board = AnimatedBuilder(
            animation: win,
            child: board,
            builder: (context, child) {
              final t = win.value;
              final bump = t == 0 || t == 1 ? 1.0 : 1 + 0.05 * sin(pi * t);
              return Transform.scale(
                scale: bump,
                origin: l.boardRect(p).center - cons.biggest.center(Offset.zero),
                child: child,
              );
            },
          );
        }
        return Stack(
          children: [
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              dragStartBehavior: DragStartBehavior.down,
              onTapUp: (e) => _tap(l, e.localPosition),
              onSecondaryTapUp: (e) => _tap(l, e.localPosition, flip: true),
              onPanStart: (e) => _start(l, e.localPosition),
              onPanUpdate: (e) {
                if (_drag != null) setState(() => _drag!.at = e.localPosition);
              },
              onPanEnd: (_) => _end(l),
              onPanCancel: () => setState(() => _drag = null),
              child: board,
            ),
            if (l.flip case final f?)
              Positioned.fromRect(
                rect: f,
                child: Center(
                  child: IconButton.filledTonal(
                    tooltip: context.l10n.inlayFlip,
                    onPressed: ctrl.solved || _selected == null ? null : () => _turn(_selected!, flip: true),
                    icon: const Icon(Icons.flip_rounded),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

class _InlayPainter extends CustomPainter {
  _InlayPainter({
    required this.puzzle,
    required this.state,
    required this.layout,
    required this.drag,
    required this.ghost,
    required this.selected,
    required this.hints,
    required this.slot,
    required this.line,
    required this.hint,
  });

  final InlayPuzzle puzzle;
  final InlayState state;
  final InlayLayout layout;
  final _Drag? drag;
  final (int, int)? ghost;
  final int? selected;
  final Set<Pos> hints;
  final Color slot;
  final Color line;
  final Color hint;

  /// [cells] of one piece with their top-left corner at [o], cell size
  /// [cell]: rounded squares joined where they touch.
  void _piece(Canvas canvas, List<Cell> cells, Offset o, double cell, Paint paint, {Paint? outline}) {
    final inset = cell * 0.06;
    final set = {for (final c in cells) c};
    final path = Path();
    for (final (r, c) in cells) {
      final rect = Rect.fromLTWH(o.dx + c * cell + inset, o.dy + r * cell + inset, cell - 2 * inset, cell - 2 * inset);
      path.addRRect(RRect.fromRectAndRadius(rect, Radius.circular(cell * 0.18)));
      if (set.contains((r, c + 1))) {
        path.addRect(
          Rect.fromLTRB(rect.right - cell * 0.2, rect.top, rect.right + 2 * inset + cell * 0.2, rect.bottom),
        );
      }
      if (set.contains((r + 1, c))) {
        path.addRect(
          Rect.fromLTRB(rect.left, rect.bottom - cell * 0.2, rect.right, rect.bottom + 2 * inset + cell * 0.2),
        );
      }
      if (set.contains((r, c + 1)) && set.contains((r + 1, c)) && set.contains((r + 1, c + 1))) {
        path.addRect(
          Rect.fromLTRB(rect.right - 1, rect.bottom - 1, rect.right + 2 * inset + 1, rect.bottom + 2 * inset + 1),
        );
      }
    }
    final merged = Path.combine(PathOperation.union, Path(), path);
    canvas.drawPath(merged, paint);
    if (outline != null) canvas.drawPath(merged, outline);
  }

  @override
  void paint(Canvas canvas, Size size) {
    final p = puzzle, l = layout, cell = l.cell;
    // The shape: one slot per cell.
    final slotPaint = Paint()..color = slot;
    for (var i = 0; i < p.cells; i++) {
      if (!p.shape[i]) continue;
      final r = i ~/ p.cols, c = i % p.cols;
      final rect = Rect.fromLTWH(l.board.dx + c * cell, l.board.dy + r * cell, cell, cell).deflate(cell * 0.06);
      canvas.drawRRect(RRect.fromRectAndRadius(rect, Radius.circular(cell * 0.18)), slotPaint);
    }
    final hintPaint = Paint()..color = hint.withValues(alpha: 0.45);
    Paint outline(double w) => Paint()
      ..color = line
      ..style = PaintingStyle.stroke
      ..strokeWidth = w;

    for (var k = 0; k < p.pieces.length; k++) {
      final dragged = drag?.piece == k;
      final o = state.orient[k];
      final cells = p.cellsOf(k, o);
      final fill = Paint()..color = inlayColor(k).withValues(alpha: dragged ? 0.25 : 1);
      final ring = k == selected && !dragged ? outline(max(1.5, cell * 0.05)) : null;
      if (state.placed(k)) {
        final at = state.at[k];
        final corner = l.board + Offset((at % p.cols) * cell, (at ~/ p.cols) * cell);
        _piece(canvas, cells, corner, cell, fill, outline: ring);
      } else {
        final (h, w) = p.extent(k, o);
        final corner = l.slots[k].center - Offset(w * l.tray / 2, h * l.tray / 2);
        _piece(canvas, cells, corner, l.tray, fill, outline: ring == null ? null : outline(max(1.5, l.tray * 0.08)));
      }
    }
    for (final pos in hints) {
      final rect = Rect.fromLTWH(l.board.dx + pos.c * cell, l.board.dy + pos.r * cell, cell, cell).deflate(cell * 0.2);
      canvas.drawRRect(RRect.fromRectAndRadius(rect, Radius.circular(cell * 0.2)), hintPaint);
    }

    final d = drag;
    if (d == null) return;
    final cells = p.cellsOf(d.piece, d.orient);
    if (ghost case (final r, final c)) {
      _piece(
        canvas,
        cells,
        l.board + Offset(c * cell, r * cell),
        cell,
        Paint()..color = inlayColor(d.piece).withValues(alpha: 0.35),
        outline: outline(max(1.0, cell * 0.03)),
      );
    }
    final corner = d.at - d.grab * cell;
    _piece(
      canvas,
      cells,
      corner,
      cell,
      Paint()..color = inlayColor(d.piece).withValues(alpha: 0.9),
      outline: outline(max(1.5, cell * 0.04)),
    );
  }

  @override
  bool shouldRepaint(_InlayPainter old) => true;
}
