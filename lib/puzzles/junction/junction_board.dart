import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';

import '../../l10n/l10n.dart';
import 'junction_model.dart';

/// The trains run on their own clock here: every [JunctionPuzzle.stepMs] ms
/// the board calls [JunctionBoard.onStep]. It waits for the first tap,
/// flips a switch on a tap near it, pauses on a tap anywhere else (or space)
/// and when the app goes to the background, and glides the trains between
/// cells.
class JunctionBoard extends StatefulWidget {
  const JunctionBoard({
    super.key,
    required this.puzzle,
    required this.state,
    required this.onStep,
    required this.onFlip,
    required this.onRestart,
  });

  final JunctionPuzzle puzzle;
  final JunctionState state;

  /// Null when the game is over (won).
  final VoidCallback? onStep;
  final void Function(int)? onFlip;
  final VoidCallback onRestart;

  static const trackColor = Color(0xFF8A6A4F);

  /// Station and train colors, one per symbol. Each symbol also has its own
  /// shape ([paintJunctionSymbol]), so colors never have to be told apart.
  static const colors = [
    Color(0xFFE5484D),
    Color(0xFF3E8BFF),
    Color(0xFFF5B700),
    Color(0xFF3DBA6A),
    Color(0xFFA77BFF),
    Color(0xFFFF8A3D),
    Color(0xFF17B8C4),
    Color(0xFFFF6FB5),
  ];

  @override
  State<JunctionBoard> createState() => _JunctionBoardState();
}

class _JunctionBoardState extends State<JunctionBoard> with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  late final Ticker _ticker = createTicker(_tick);
  final _focus = FocusNode(debugLabel: 'junction board');

  /// Progress of the last step, 0..1.
  final _phase = ValueNotifier<double>(1);
  Duration _last = Duration.zero;
  bool _running = false;

  JunctionPuzzle get _p => widget.puzzle;
  bool get _over => junctionOver(_p, widget.state);
  bool get _live => widget.onStep != null && !_over;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _ticker.dispose();
    _focus.dispose();
    _phase.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state != AppLifecycleState.resumed) _pause();
  }

  @override
  void didUpdateWidget(JunctionBoard old) {
    super.didUpdateWidget(old);
    final a = old.state, b = widget.state;
    // One step forward (or a flip) goes on; anything else (restart, a load) stops.
    if (b.tick != a.tick && b.tick != a.tick + 1) {
      _phase.value = 1;
      _pause();
    }
    if (!_live) _stop();
  }

  void _tick(Duration now) {
    final ms = (now - _last).inMicroseconds / 1000;
    if (ms < _p.stepMs) {
      _phase.value = ms / _p.stepMs;
      return;
    }
    _last = now;
    _phase.value = 0;
    widget.onStep?.call();
  }

  void _start() {
    if (_running || !_live) return;
    _focus.requestFocus();
    setState(() => _running = true);
    _last = Duration.zero;
    _ticker.start();
  }

  void _pause() {
    if (!_running) return;
    _ticker.stop();
    if (mounted) setState(() => _running = false);
  }

  void _stop() {
    if (_ticker.isActive) _ticker.stop();
    _running = false;
  }

  /// The switch nearest to [at] within a cell, or -1.
  int _switchAt(Offset at, double cell) {
    var best = -1;
    var bestDist = cell * 1.0;
    for (var k = 0; k < _p.switches.length; k++) {
      final i = _p.switches[k];
      final o = Offset((i % _p.cols + 0.5) * cell, (i ~/ _p.cols + 0.5) * cell);
      final d = (o - at).distance;
      if (d < bestDist) {
        bestDist = d;
        best = k;
      }
    }
    return best;
  }

  void _tap(Offset at, double cell) {
    _focus.requestFocus();
    if (_over && widget.onStep != null) {
      widget.onRestart();
      return;
    }
    if (!_running) {
      _start();
      return;
    }
    final k = _switchAt(at, cell);
    if (k >= 0) {
      widget.onFlip?.call(k);
    } else {
      _pause();
    }
  }

  KeyEventResult _key(FocusNode _, KeyEvent e) {
    if (e is! KeyDownEvent) return KeyEventResult.ignored;
    final key = e.logicalKey;
    if (key == LogicalKeyboardKey.space || key == LogicalKeyboardKey.keyP) {
      if (_running) {
        _pause();
      } else if (_over && widget.onStep != null) {
        widget.onRestart();
      } else {
        _start();
      }
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) {
    final w = widget;
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final l = context.l10n;
    final message = _over && w.onStep != null && _p.perfect && w.state.misses > 0
        ? l.junctionWrong
        : !_running && _live
        ? (w.state.tick == 0 ? l.junctionStart : l.junctionPaused)
        : null;
    return LayoutBuilder(
      builder: (context, cons) {
        final cell = min(min(cons.maxWidth / _p.cols, cons.maxHeight / _p.rows), 64.0).floorToDouble();
        final size = Size(cell * _p.cols, cell * _p.rows);
        return Center(
          child: Focus(
            focusNode: _focus,
            autofocus: true,
            onKeyEvent: _key,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTapDown: (d) => _tap(d.localPosition, cell),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(cell * 0.3),
                    child: CustomPaint(
                      size: size,
                      painter: JunctionPainter(
                        puzzle: _p,
                        state: w.state,
                        phase: _phase,
                        board: scheme.surfaceContainerHighest,
                        checker: scheme.onSurface.withValues(alpha: 0.03),
                        lever: scheme.primary,
                        rail: Color.lerp(JunctionBoard.trackColor, scheme.onSurface, 0.25)!,
                        bed: Color.alphaBlend(
                          JunctionBoard.trackColor.withValues(alpha: 0.18),
                          scheme.surfaceContainerHighest,
                        ),
                        ok: scheme.primary,
                        miss: scheme.error,
                        ink: scheme.surface,
                        symbol: const Color(0xFF1B2230),
                      ),
                    ),
                  ),
                  if (message != null)
                    Positioned(
                      bottom: cell * 0.3,
                      child: IgnorePointer(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          decoration: BoxDecoration(
                            color: scheme.inverseSurface.withValues(alpha: 0.85),
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: Text(
                            message,
                            textAlign: TextAlign.center,
                            style: theme.textTheme.titleSmall?.copyWith(color: scheme.onInverseSurface),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Draws symbol [k] (circle, square, triangle, diamond, star, cross,
/// hexagon, ring) of radius [r] around [o].
void paintJunctionSymbol(Canvas canvas, Offset o, double r, int k, Paint paint) {
  Path polygon(int corners, double radius, double turn, {double inner = 0}) {
    final path = Path();
    final points = inner > 0 ? corners * 2 : corners;
    for (var i = 0; i < points; i++) {
      final a = turn + 2 * pi * i / points;
      final rr = inner > 0 && i.isOdd ? inner : radius;
      final p = o + Offset(cos(a), sin(a)) * rr;
      i == 0 ? path.moveTo(p.dx, p.dy) : path.lineTo(p.dx, p.dy);
    }
    return path..close();
  }

  switch (k % 8) {
    case 0:
      canvas.drawCircle(o, r * 0.85, paint);
    case 1:
      canvas.drawRRect(
        RRect.fromRectAndRadius(Rect.fromCircle(center: o, radius: r * 0.75), Radius.circular(r * 0.15)),
        paint,
      );
    case 2:
      canvas.drawPath(polygon(3, r, -pi / 2).shift(Offset(0, r * 0.12)), paint);
    case 3:
      canvas.drawPath(polygon(4, r, -pi / 2), paint);
    case 4:
      canvas.drawPath(polygon(5, r * 1.05, -pi / 2, inner: r * 0.45), paint);
    case 5:
      final t = r * 0.32;
      canvas.drawRect(Rect.fromCenter(center: o, width: 2 * r * 0.9, height: t * 2), paint);
      canvas.drawRect(Rect.fromCenter(center: o, width: t * 2, height: 2 * r * 0.9), paint);
    case 6:
      canvas.drawPath(polygon(6, r * 0.9, 0), paint);
    default:
      canvas.drawCircle(
        o,
        r * 0.65,
        Paint()
          ..color = paint.color
          ..style = PaintingStyle.stroke
          ..strokeWidth = r * 0.38,
      );
  }
}

class JunctionPainter extends CustomPainter {
  JunctionPainter({
    required this.puzzle,
    required this.state,
    required this.phase,
    required this.board,
    required this.checker,
    required this.lever,
    required this.rail,
    required this.bed,
    required this.ok,
    required this.miss,
    required this.ink,
    required this.symbol,
  }) : super(repaint: phase);

  final JunctionPuzzle puzzle;
  final JunctionState state;
  final ValueNotifier<double> phase;
  final Color board;
  final Color checker;
  final Color lever;
  final Color rail;
  final Color bed;
  final Color ok;
  final Color miss;
  final Color ink;

  /// Symbols on stations and trains (dark on every color, in both themes).
  final Color symbol;

  @override
  void paint(Canvas canvas, Size size) {
    final p = puzzle;
    final cols = p.cols;
    final cell = size.width / cols;
    Offset center(int i) => Offset((i % cols + 0.5) * cell, (i ~/ cols + 0.5) * cell);

    canvas.drawRect(Offset.zero & size, Paint()..color = board);
    final dark = Paint()..color = checker;
    for (var r = 0; r < p.rows; r++) {
      for (var c = (r & 1); c < cols; c += 2) {
        canvas.drawRect(Rect.fromLTWH(c * cell, r * cell, cell, cell), dark);
      }
    }

    // Where trains come from: just outside the board, behind the depot.
    final depot = center(p.depot);
    final inward = center(p.children[p.depot].first) - depot;
    final portal = depot - inward;

    // The track: a bed, two rails (a wide stroke with the bed over its middle)
    // and sleepers.
    final path = Path()
      ..moveTo(portal.dx, portal.dy)
      ..lineTo(depot.dx, depot.dy);
    for (var i = 0; i < p.cells; i++) {
      if (p.parent[i] < 0) continue;
      final a = center(p.parent[i]), b = center(i);
      path
        ..moveTo(a.dx, a.dy)
        ..lineTo(b.dx, b.dy);
    }
    Paint stroke(Color color, double width) => Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = width
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    canvas.drawPath(path, stroke(bed, cell * 0.56));
    final sleeper = stroke(rail.withValues(alpha: 0.35), cell * 0.07)..strokeCap = StrokeCap.butt;
    for (var i = 0; i < p.cells; i++) {
      if (p.parent[i] < 0) continue;
      final a = center(p.parent[i]), b = center(i);
      final dir = (b - a) / cell;
      final side = Offset(-dir.dy, dir.dx) * (cell * 0.22);
      for (final t in [0.25, 0.75]) {
        final m = Offset.lerp(a, b, t)!;
        canvas.drawLine(m - side, m + side, sleeper);
      }
    }
    canvas.drawPath(path, stroke(rail, cell * 0.32));
    canvas.drawPath(path, stroke(bed, cell * 0.2));

    // Switches: the branch it is set to is drawn bold, with a lever pointing at it.
    for (var k = 0; k < p.switches.length; k++) {
      final i = p.switches[k];
      final o = center(i);
      final to = center(p.children[i][state.settings[k]]);
      final dir = (to - o) / cell;
      // A gap in the rails of the branch it is not set to.
      final off = center(p.children[i][1 - state.settings[k]]);
      final odir = (off - o) / cell;
      canvas.drawLine(
        o + odir * (cell * 0.3),
        o + odir * (cell * 0.5),
        stroke(bed, cell * 0.36)..strokeCap = StrokeCap.butt,
      );
      canvas.drawCircle(o, cell * 0.36, Paint()..color = lever.withValues(alpha: 0.18));
      canvas.drawLine(o, o + dir * (cell * 0.5), stroke(lever, cell * 0.2));
      canvas.drawCircle(o, cell * 0.17, Paint()..color = lever);
      canvas.drawCircle(o, cell * 0.07, Paint()..color = ink);
    }

    // Stations: a tile with the symbol.
    for (var k = 0; k < p.stations.length; k++) {
      final o = center(p.stations[k]);
      final color = JunctionPainter.color(k);
      canvas.drawRRect(
        RRect.fromRectAndRadius(Rect.fromCircle(center: o, radius: cell * 0.42), Radius.circular(cell * 0.14)),
        Paint()..color = color,
      );
      paintJunctionSymbol(canvas, o, cell * 0.24, k, Paint()..color = symbol.withValues(alpha: 0.85));
    }

    // Trains glide from their last cell; arrivals of this step into their station.
    final t = phase.value;
    void train(int color, Offset from, Offset to, double alpha) {
      final o = Offset.lerp(from, to, t)!;
      canvas.drawCircle(
        o,
        cell * 0.34,
        Paint()..color = Color.lerp(JunctionPainter.color(color), Colors.black, 0.18)!.withValues(alpha: alpha),
      );
      canvas.drawCircle(o, cell * 0.28, Paint()..color = JunctionPainter.color(color).withValues(alpha: alpha));
      paintJunctionSymbol(canvas, o, cell * 0.17, color, Paint()..color = symbol.withValues(alpha: 0.85 * alpha));
    }

    for (final a in state.arrived) {
      if (a.tick == state.tick && t < 1) train(a.color, center(a.from), center(p.stations[a.station]), 1 - t * 0.6);
    }
    for (final tr in state.trains) {
      train(tr.color, tr.from < 0 ? portal : center(tr.from), center(tr.cell), 1);
    }

    // The tunnel mouth at the edge, over the trains coming out of it.
    final edge = depot - inward * 0.5;
    final upright = inward.dx.abs() > 0;
    final mouth = Rect.fromCenter(
      center: edge,
      width: upright ? cell * 0.7 : cell * 0.9,
      height: upright ? cell * 0.9 : cell * 0.7,
    );
    canvas.drawRRect(RRect.fromRectAndRadius(mouth, Radius.circular(cell * 0.14)), Paint()..color = rail);
    canvas.drawRRect(
      RRect.fromRectAndRadius(mouth.deflate(cell * 0.1), Radius.circular(cell * 0.08)),
      Paint()..color = Colors.black.withValues(alpha: 0.55),
    );

    // A tick or a cross on stations that just took a train.
    for (final a in state.arrived) {
      if (state.tick - a.tick > 3 || (a.tick == state.tick && t < 0.7)) continue;
      final o = center(p.stations[a.station]) + Offset(cell * 0.3, -cell * 0.3);
      canvas.drawCircle(o, cell * 0.2, Paint()..color = a.ok ? ok : miss);
      final pen = stroke(ink, cell * 0.06);
      final e = cell * 0.08;
      if (a.ok) {
        canvas.drawPath(
          Path()
            ..moveTo(o.dx - e, o.dy)
            ..lineTo(o.dx - e * 0.2, o.dy + e * 0.8)
            ..lineTo(o.dx + e * 1.1, o.dy - e * 0.7),
          pen,
        );
      } else {
        canvas.drawLine(o + Offset(-e, -e), o + Offset(e, e), pen);
        canvas.drawLine(o + Offset(-e, e), o + Offset(e, -e), pen);
      }
    }
  }

  static Color color(int k) => JunctionBoard.colors[k % JunctionBoard.colors.length];

  @override
  bool shouldRepaint(JunctionPainter old) =>
      !identical(old.state, state) || !identical(old.puzzle, puzzle) || old.board != board || old.lever != lever;
}
