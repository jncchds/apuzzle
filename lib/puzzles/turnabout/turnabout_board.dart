import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';

import '../../l10n/l10n.dart';
import '../labyrinth/labyrinth_model.dart';
import 'turnabout_model.dart';

/// What a move request did: moved, must wait (the runner is between moves or
/// the maze is turning), or ran into a wall.
enum TurnaboutMoveResult { moved, wait, blocked }

/// The race runs on its own clock here: every [turnaboutTickMs] ms the board
/// calls [TurnaboutBoard.onStep]. A round waits for the first swipe (or
/// arrow key / WASD); a swipe that goes on keeps moving, one cell per
/// stretch, and a held key repeats. Moves wait in a short queue while the
/// runner is between cells or the maze turns. A tap (or space) pauses, and
/// so does leaving the app. The maze is drawn turned, and turns smoothly.
class TurnaboutBoard extends StatefulWidget {
  const TurnaboutBoard({
    super.key,
    required this.puzzle,
    required this.state,
    required this.onStep,
    required this.onMove,
    required this.onNext,
    required this.onRestart,
  });

  final TurnaboutPuzzle puzzle;
  final TurnaboutState state;

  /// Null when the game is over (won).
  final VoidCallback? onStep;
  final TurnaboutMoveResult Function(int screenDir)? onMove;
  final VoidCallback? onNext;
  final VoidCallback onRestart;

  static const runnerColor = Color(0xFF3E8BFF);
  static const rivalColor = Color(0xFFE5484D);
  static const starColor = Color(0xFFF5B700);

  @override
  State<TurnaboutBoard> createState() => _TurnaboutBoardState();
}

/// Animation inputs the painter reads at paint time.
class _Motion {
  /// Ticker time, and when the last step of the clock was.
  Duration now = Duration.zero;
  Duration lastTick = Duration.zero;
  bool running = false;

  /// Glides: from which cell, since when.
  int playerFrom = -1;
  Duration playerAt = Duration.zero;
  int rivalFrom = -1;
  Duration rivalAt = Duration.zero;
  int rivalMs = 500;

  double get tickPhase =>
      running ? ((now - lastTick).inMicroseconds / 1000 / turnaboutTickMs).clamp(0.0, 1.0).toDouble() : 1;

  double glide(int from, Duration at, int ms) =>
      from < 0 || !running ? 1 : ((now - at).inMicroseconds / 1000 / ms).clamp(0.0, 1.0).toDouble();
}

class _TurnaboutBoardState extends State<TurnaboutBoard> with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  late final Ticker _ticker = createTicker(_tick);
  final _focus = FocusNode(debugLabel: 'turnabout board');
  final _repaint = ValueNotifier<int>(0);
  final _motion = _Motion();
  final _queue = <int>[];
  Offset _drag = Offset.zero;

  /// No move of this drag yet (the touch slop is already behind it, so the
  /// first move needs only a short stretch more).
  bool _dragFirst = true;

  /// The drag began while this round was on (so it can't spill into the next one).
  bool _dragLive = false;

  TurnaboutPuzzle get _p => widget.puzzle;
  TurnaboutState get _s => widget.state;
  bool get _over => turnaboutOver(_p, _s);
  bool get _live => widget.onStep != null && _s.result == TurnaboutResult.running;

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
    _repaint.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state != AppLifecycleState.resumed) _pause();
  }

  @override
  void didUpdateWidget(TurnaboutBoard old) {
    super.didUpdateWidget(old);
    final a = old.state, b = widget.state;
    final m = _motion;
    if (b.round != a.round || b.tick < a.tick || !identical(old.puzzle, widget.puzzle)) {
      // A new round, a restart or a load: nothing glides, and it waits.
      m.playerFrom = m.rivalFrom = -1;
      _pause();
    } else {
      if (b.player != a.player) {
        m.playerFrom = a.player;
        m.playerAt = m.now;
      }
      if (b.rival != a.rival) {
        m.rivalFrom = turnaboutRivalCell(_p, a);
        m.rivalAt = m.now;
        m.rivalMs = (_p.rivalPace(b.wins) * turnaboutTickMs * 0.9).round();
      }
    }
    if (!_live) _stop();
  }

  void _tick(Duration now) {
    final m = _motion..now = now;
    for (var k = 0; k < 3 && now - m.lastTick >= const Duration(milliseconds: turnaboutTickMs); k++) {
      m.lastTick += const Duration(milliseconds: turnaboutTickMs);
      if (!_live) break;
      widget.onStep?.call();
    }
    if (now - m.lastTick >= const Duration(milliseconds: turnaboutTickMs)) m.lastTick = now;
    _drain();
    _repaint.value++;
  }

  /// Plays queued moves while the runner may move.
  void _drain() {
    while (_queue.isNotEmpty && _live) {
      final r = widget.onMove?.call(_queue.first) ?? TurnaboutMoveResult.blocked;
      if (r == TurnaboutMoveResult.wait) return;
      _queue.removeAt(0);
      if (r == TurnaboutMoveResult.moved) return;
    }
  }

  void _start() {
    if (_motion.running || !_live) return;
    _focus.requestFocus();
    setState(() => _motion.running = true);
    _motion
      ..now = Duration.zero
      ..lastTick = Duration.zero;
    _ticker.start();
  }

  void _pause() {
    _queue.clear();
    if (!_motion.running) return;
    _ticker.stop();
    _motion.running = false;
    if (mounted) setState(() {});
  }

  void _stop() {
    _queue.clear();
    if (_ticker.isActive) _ticker.stop();
    _motion.running = false;
  }

  /// After a round: the next one, or a fresh try of a failed practice board.
  bool _between() {
    if (widget.onStep == null || _s.result == TurnaboutResult.running) return false;
    if (_over) {
      if (_p.practice && _s.losses > 0) widget.onRestart();
    } else {
      widget.onNext?.call();
    }
    return true;
  }

  void _move(int dir) {
    if (!_live) return;
    if (_queue.length < 2) _queue.add(dir);
    _start();
    _drain();
  }

  void _tap() {
    _focus.requestFocus();
    if (_between()) return;
    if (_motion.running) {
      _pause();
    } else {
      _start();
    }
  }

  KeyEventResult _key(FocusNode _, KeyEvent e) {
    if (e is! KeyDownEvent && e is! KeyRepeatEvent) return KeyEventResult.ignored;
    final key = e.logicalKey;
    if (key == LogicalKeyboardKey.space || key == LogicalKeyboardKey.keyP) {
      if (e is KeyDownEvent) _tap();
      return KeyEventResult.handled;
    }
    final dir = switch (key) {
      LogicalKeyboardKey.arrowUp || LogicalKeyboardKey.keyW => 0,
      LogicalKeyboardKey.arrowRight || LogicalKeyboardKey.keyD => 1,
      LogicalKeyboardKey.arrowDown || LogicalKeyboardKey.keyS => 2,
      LogicalKeyboardKey.arrowLeft || LogicalKeyboardKey.keyA => 3,
      _ => null,
    };
    if (dir == null) return KeyEventResult.ignored;
    if (_s.result != TurnaboutResult.running) {
      if (e is KeyDownEvent) _between();
    } else if (e is KeyDownEvent || _queue.isEmpty) {
      _move(dir);
    }
    return KeyEventResult.handled;
  }

  @override
  Widget build(BuildContext context) {
    final w = widget;
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final l = context.l10n;
    final s = w.state;
    final message = w.onStep == null
        ? null
        : switch (s.result) {
            TurnaboutResult.won => _over ? null : l.turnaboutWon,
            TurnaboutResult.lost => _over ? (_p.practice ? l.turnaboutLostPractice : null) : l.turnaboutLost,
            _ => _motion.running ? null : (s.fresh ? l.turnaboutStart : l.turnaboutPaused),
          };
    return LayoutBuilder(
      builder: (context, cons) {
        final n = _p.n;
        final cell = min(min(cons.maxWidth, cons.maxHeight) / n, 64.0).floorToDouble();
        final size = Size.square(cell * n);
        // The message keeps off the star: at the top when the star shows in the lower half.
        final prize = _p.round(s.round).prize;
        final (pr, pc) = (prize ~/ n, prize % n);
        final starRow = switch (s.orient) {
          0 => pr,
          1 => pc,
          2 => n - 1 - pr,
          _ => n - 1 - pc,
        };
        final top = starRow >= n / 2;
        return Center(
          child: Focus(
            focusNode: _focus,
            autofocus: true,
            onKeyEvent: _key,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: _tap,
              onPanStart: (_) {
                _drag = Offset.zero;
                _dragFirst = true;
                _dragLive = _s.result == TurnaboutResult.running;
                if (!_dragLive) _between();
              },
              onPanUpdate: (d) {
                if (!_dragLive) return;
                _drag += d.delta;
                if (_drag.distance < (_dragFirst ? 4.0 : max(16.0, cell * 0.6))) return;
                _move(
                  _drag.dx.abs() > _drag.dy.abs() ? (_drag.dx > 0 ? 1 : 3) : (_drag.dy > 0 ? 2 : 0),
                );
                _drag = Offset.zero;
                _dragFirst = false;
              },
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CustomPaint(
                    size: size,
                    painter: _TurnaboutPainter(
                      puzzle: _p,
                      state: s,
                      motion: _motion,
                      repaint: _repaint,
                      board: scheme.surfaceContainer,
                      wall: scheme.onSurfaceVariant,
                      warn: scheme.primary,
                    ),
                  ),
                  if (message != null)
                    Positioned(
                      top: top ? cell * 0.3 : null,
                      bottom: top ? null : cell * 0.3,
                      left: 8,
                      right: 8,
                      child: IgnorePointer(
                        child: Center(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                            decoration: BoxDecoration(
                              color: scheme.inverseSurface.withValues(alpha: 0.88),
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

/// Draws a five-pointed star of radius [r] around [o].
void paintTurnaboutStar(Canvas canvas, Offset o, double r, Paint paint) {
  final path = Path();
  for (var i = 0; i < 10; i++) {
    final a = -pi / 2 + pi * i / 5;
    final rr = i.isEven ? r : r * 0.45;
    final p = o + Offset(cos(a), sin(a)) * rr;
    i == 0 ? path.moveTo(p.dx, p.dy) : path.lineTo(p.dx, p.dy);
  }
  canvas.drawPath(path..close(), paint);
}

class _TurnaboutPainter extends CustomPainter {
  _TurnaboutPainter({
    required this.puzzle,
    required this.state,
    required this.motion,
    required Listenable repaint,
    required this.board,
    required this.wall,
    required this.warn,
  }) : super(repaint: repaint);

  final TurnaboutPuzzle puzzle;
  final TurnaboutState state;
  final _Motion motion;
  final Color board;
  final Color wall;
  final Color warn;

  /// The maze's angle on screen, in quarter turns clockwise.
  double get _quarters {
    final s = state;
    if (!turnaboutTurning(s)) return s.orient.toDouble();
    final by = s.turnBy == 3 ? -1 : s.turnBy;
    final t = ((s.tick - s.turnAt + motion.tickPhase) / turnaboutTurnTicks(s.turnBy)).clamp(0.0, 1.0);
    final eased = Curves.easeInOut.transform(t);
    return s.orient - by * (1 - eased);
  }

  @override
  void paint(Canvas canvas, Size size) {
    final s = state;
    final round = puzzle.round(s.round);
    final n = round.n;
    final cell = size.width / n;
    final mid = size.center(Offset.zero);
    Offset center(int i) => Offset((i % n + 0.5) * cell, (i ~/ n + 0.5) * cell);

    // Turned (and shrunk while between quarter turns, so it stays inside).
    final angle = _quarters * pi / 2;
    final scale = 1 / (cos(angle).abs() + sin(angle).abs());
    canvas.save();
    canvas.translate(mid.dx, mid.dy);
    canvas.rotate(angle);
    canvas.scale(scale);
    canvas.translate(-mid.dx, -mid.dy);

    canvas.drawRRect(
      RRect.fromRectAndRadius(Offset.zero & size, Radius.circular(cell * 0.2)),
      Paint()..color = board,
    );

    // The star, then the rival and the runner gliding between cells.
    final star = center(round.prize);
    canvas.drawCircle(star, cell * 0.42, Paint()..color = TurnaboutBoard.starColor.withValues(alpha: 0.22));
    paintTurnaboutStar(canvas, star, cell * 0.36, Paint()..color = TurnaboutBoard.starColor);

    final m = motion;
    if (round.rival >= 0) {
      final to = center(round.rivalPath[s.rival]);
      final from = m.rivalFrom >= 0 ? center(m.rivalFrom) : to;
      final o = Offset.lerp(from, to, m.glide(m.rivalFrom, m.rivalAt, m.rivalMs))!;
      final r = cell * 0.34;
      final diamond = Path()
        ..moveTo(o.dx, o.dy - r)
        ..lineTo(o.dx + r, o.dy)
        ..lineTo(o.dx, o.dy + r)
        ..lineTo(o.dx - r, o.dy)
        ..close();
      canvas.drawPath(diamond, Paint()..color = TurnaboutBoard.rivalColor);
      canvas.drawCircle(o, cell * 0.08, Paint()..color = Colors.white.withValues(alpha: 0.9));
    }
    final to = center(s.player);
    final from = m.playerFrom >= 0 ? center(m.playerFrom) : to;
    final o = Offset.lerp(from, to, m.glide(m.playerFrom, m.playerAt, 90))!;
    canvas.drawCircle(o, cell * 0.32, Paint()..color = TurnaboutBoard.runnerColor);
    canvas.drawCircle(o, cell * 0.12, Paint()..color = Colors.white.withValues(alpha: 0.9));

    // Walls, the outline included.
    final pen = Paint()
      ..color = wall
      ..strokeWidth = max(2.0, cell * 0.12)
      ..strokeCap = StrokeCap.round;
    for (var r = 0; r < n; r++) {
      for (var c = 0; c < n; c++) {
        final i = r * n + c;
        final x0 = c * cell, y0 = r * cell, x1 = x0 + cell, y1 = y0 + cell;
        if (r == 0 || round.open[i] & dN == 0) canvas.drawLine(Offset(x0, y0), Offset(x1, y0), pen);
        if (c == 0) canvas.drawLine(Offset(x0, y0), Offset(x0, y1), pen);
        if (round.open[i] & dE == 0) canvas.drawLine(Offset(x1, y0), Offset(x1, y1), pen);
        if (r == n - 1) canvas.drawLine(Offset(x0, y1), Offset(x1, y1), pen);
      }
    }
    canvas.restore();

    // A turn is coming: a pulsing arrow around the middle, the way it turns.
    if (turnaboutWarning(puzzle, s) case (final at, final by)) {
      final left = (at - s.tick - m.tickPhase) / turnaboutWarnTicks;
      final pulse = 0.5 + 0.5 * cos(left * turnaboutWarnTicks * pi / 3.5);
      final color = warn.withValues(alpha: 0.25 + 0.35 * pulse);
      final r = size.width * 0.22;
      final arrow = Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = max(4.0, size.width * 0.03)
        ..strokeCap = StrokeCap.round;
      final dir = by == 3 ? -1.0 : 1.0;
      final arcs = by == 2 ? 2 : 1;
      final sweep = (by == 2 ? 0.7 : 1.5) * pi * dir;
      for (var k = 0; k < arcs; k++) {
        final start = -pi / 2 + k * pi - sweep / 2;
        canvas.drawArc(Rect.fromCircle(center: mid, radius: r), start, sweep, false, arrow);
        // The arrowhead at the end of the arc, pointing along it.
        final end = start + sweep;
        final tip = mid + Offset(cos(end), sin(end)) * r;
        final along = Offset(-sin(end), cos(end)) * dir;
        final out = Offset(cos(end), sin(end));
        final h = arrow.strokeWidth * 2.2;
        canvas.drawPath(
          Path()
            ..moveTo(tip.dx + along.dx * h, tip.dy + along.dy * h)
            ..lineTo(tip.dx - along.dx * h * 0.4 + out.dx * h, tip.dy - along.dy * h * 0.4 + out.dy * h)
            ..lineTo(tip.dx - along.dx * h * 0.4 - out.dx * h, tip.dy - along.dy * h * 0.4 - out.dy * h)
            ..close(),
          Paint()..color = color,
        );
      }
    }
  }

  @override
  bool shouldRepaint(_TurnaboutPainter old) => true;
}
