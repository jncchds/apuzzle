import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';

import '../../l10n/l10n.dart';
import 'snake_model.dart';

/// The snake runs on its own clock here: every [interval] ms it calls
/// [onStep] with the next queued turn. It waits for the first swipe, pauses
/// on a tap or when the app goes to the background, and glides between
/// cells. Swipe, or use the arrow keys / WASD (space pauses).
class SnakeBoard extends StatefulWidget {
  const SnakeBoard({
    super.key,
    required this.rows,
    required this.cols,
    required this.state,
    required this.interval,
    required this.onStep,
    required this.onRestart,
  });

  final int rows;
  final int cols;
  final SnakeState state;
  final int interval;

  /// Null when the game is over (won).
  final void Function(SnakeDir)? onStep;
  final VoidCallback onRestart;

  static const snakeColor = Color(0xFF3DBA6A);
  static const appleColor = Color(0xFFE5484D);

  @override
  State<SnakeBoard> createState() => _SnakeBoardState();
}

class _SnakeBoardState extends State<SnakeBoard> with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  late final Ticker _ticker = createTicker(_tick);
  final _focus = FocusNode(debugLabel: 'snake board');

  /// Progress from the previous cell to the current one, 0..1.
  final _phase = ValueNotifier<double>(1);
  Duration _last = Duration.zero;
  bool _running = false;
  final _turns = <SnakeDir>[];

  /// Where the tail was before the last step (null if the snake grew).
  int? _prevTail;
  Offset _drag = Offset.zero;

  bool get _live => widget.onStep != null && !widget.state.dead && !widget.state.full;

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
  void didUpdateWidget(SnakeBoard old) {
    super.didUpdateWidget(old);
    final a = old.state.body, b = widget.state.body;
    if (identical(a, b)) {
      if (!_live) _stop();
      return;
    }
    // One step forward glides; anything else (restart, a load) jumps.
    final step = b.length >= 2 && b[1] == a.first && widget.state.steps == old.state.steps + 1;
    _prevTail = step && b.length == a.length ? a.last : null;
    if (!step) {
      _phase.value = 1;
      _pause();
    }
    if (!_live) _stop();
  }

  void _tick(Duration now) {
    final ms = (now - _last).inMicroseconds / 1000;
    if (ms < widget.interval) {
      _phase.value = ms / widget.interval;
      return;
    }
    _last = now;
    _phase.value = 0;
    widget.onStep?.call(_turns.isEmpty ? widget.state.dir : _turns.removeAt(0));
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
    _turns.clear();
    _ticker.stop();
    _phase.value = 1;
    if (mounted) setState(() => _running = false);
  }

  void _stop() {
    _turns.clear();
    if (_ticker.isActive) _ticker.stop();
    _phase.value = 1;
    _running = false;
  }

  void _turn(SnakeDir d) {
    if (!_live) return;
    final last = _turns.isNotEmpty ? _turns.last : widget.state.dir;
    if (d != last && !d.isOpposite(last) && _turns.length < 2) _turns.add(d);
    _start();
  }

  void _tap() {
    _focus.requestFocus();
    if (widget.state.dead) {
      widget.onRestart();
    } else if (_running) {
      _pause();
    } else {
      _start();
    }
  }

  KeyEventResult _key(FocusNode _, KeyEvent e) {
    if (e is! KeyDownEvent) return KeyEventResult.ignored;
    final key = e.logicalKey;
    if (key == LogicalKeyboardKey.space || key == LogicalKeyboardKey.keyP) {
      _tap();
      return KeyEventResult.handled;
    }
    final dir = switch (key) {
      LogicalKeyboardKey.arrowUp || LogicalKeyboardKey.keyW => SnakeDir.up,
      LogicalKeyboardKey.arrowDown || LogicalKeyboardKey.keyS => SnakeDir.down,
      LogicalKeyboardKey.arrowLeft || LogicalKeyboardKey.keyA => SnakeDir.left,
      LogicalKeyboardKey.arrowRight || LogicalKeyboardKey.keyD => SnakeDir.right,
      _ => null,
    };
    if (dir == null || !_live) return KeyEventResult.ignored;
    _turn(dir);
    return KeyEventResult.handled;
  }

  @override
  Widget build(BuildContext context) {
    final w = widget;
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final l = context.l10n;
    final message = w.state.dead && w.onStep != null
        ? l.snakeCrashed
        : !_running && _live
        ? (w.state.steps == 0 ? l.snakeStart : l.snakePaused)
        : null;
    return LayoutBuilder(
      builder: (context, cons) {
        final cell = min(min(cons.maxWidth / w.cols, cons.maxHeight / w.rows), 64.0).floorToDouble();
        final size = Size(cell * w.cols, cell * w.rows);
        return Center(
          child: Focus(
            focusNode: _focus,
            autofocus: true,
            onKeyEvent: _key,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: _tap,
              onPanStart: (_) => _drag = Offset.zero,
              onPanUpdate: (d) {
                _drag += d.delta;
                if (_drag.distance < max(16.0, cell * 0.5)) return;
                _turn(
                  _drag.dx.abs() > _drag.dy.abs()
                      ? (_drag.dx > 0 ? SnakeDir.right : SnakeDir.left)
                      : (_drag.dy > 0 ? SnakeDir.down : SnakeDir.up),
                );
                _drag = Offset.zero;
              },
              child: Stack(
                alignment: Alignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(cell * 0.3),
                    child: CustomPaint(
                      size: size,
                      painter: _SnakePainter(
                        rows: w.rows,
                        cols: w.cols,
                        state: w.state,
                        prevTail: _prevTail,
                        phase: _phase,
                        board: scheme.surfaceContainerHighest,
                        checker: scheme.onSurface.withValues(alpha: 0.035),
                      ),
                    ),
                  ),
                  if (message != null)
                    IgnorePointer(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        decoration: BoxDecoration(
                          color: scheme.inverseSurface.withValues(alpha: 0.85),
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Text(
                          message,
                          style: theme.textTheme.titleSmall?.copyWith(color: scheme.onInverseSurface),
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

class _SnakePainter extends CustomPainter {
  _SnakePainter({
    required this.rows,
    required this.cols,
    required this.state,
    required this.prevTail,
    required this.phase,
    required this.board,
    required this.checker,
  }) : super(repaint: phase);

  final int rows;
  final int cols;
  final SnakeState state;
  final int? prevTail;
  final ValueNotifier<double> phase;
  final Color board;
  final Color checker;

  @override
  void paint(Canvas canvas, Size size) {
    final cell = size.width / cols;
    Offset center(int i) => Offset((i % cols + 0.5) * cell, (i ~/ cols + 0.5) * cell);

    canvas.drawRect(Offset.zero & size, Paint()..color = board);
    final dark = Paint()..color = checker;
    for (var r = 0; r < rows; r++) {
      for (var c = (r & 1); c < cols; c += 2) {
        canvas.drawRect(Rect.fromLTWH(c * cell, r * cell, cell, cell), dark);
      }
    }

    if (state.food >= 0) {
      final o = center(state.food);
      canvas.drawCircle(o + Offset(0, cell * 0.04), cell * 0.32, Paint()..color = SnakeBoard.appleColor);
      canvas.drawCircle(
        o + Offset(-cell * 0.1, -cell * 0.04),
        cell * 0.08,
        Paint()..color = Colors.white.withValues(alpha: 0.45),
      );
      final leaf = Path()
        ..moveTo(o.dx, o.dy - cell * 0.24)
        ..quadraticBezierTo(o.dx + cell * 0.08, o.dy - cell * 0.46, o.dx + cell * 0.26, o.dy - cell * 0.4)
        ..quadraticBezierTo(o.dx + cell * 0.14, o.dy - cell * 0.24, o.dx, o.dy - cell * 0.24);
      canvas.drawPath(leaf, Paint()..color = SnakeBoard.snakeColor);
    }

    // Head glides from the second cell, the tail from where it was.
    final t = phase.value;
    final body = state.body;
    final pts = [
      body.length > 1 ? Offset.lerp(center(body[1]), center(body.first), t)! : center(body.first),
      for (final i in body.skip(1)) center(i),
      if (prevTail != null) Offset.lerp(center(body.last), center(prevTail!), 1 - t)!,
    ];
    final alpha = state.dead ? 0.55 : 1.0;
    final head = Color.lerp(SnakeBoard.snakeColor, Colors.black, 0.15)!.withValues(alpha: alpha);
    final tail = Color.lerp(SnakeBoard.snakeColor, Colors.white, 0.35)!.withValues(alpha: alpha);
    final width = cell * 0.7;
    for (var k = pts.length - 2; k >= 0; k--) {
      canvas.drawLine(
        pts[k],
        pts[k + 1],
        Paint()
          ..color = Color.lerp(head, tail, k / max(1, pts.length - 2))!
          ..strokeWidth = width
          ..strokeCap = StrokeCap.round,
      );
    }
    final h = pts.first;
    canvas.drawCircle(h, cell * 0.4, Paint()..color = head);

    // Eyes look ahead, crossed out after a crash.
    final f = Offset(state.dir.dc.toDouble(), state.dir.dr.toDouble());
    final side = Offset(-f.dy, f.dx);
    for (final s in [-1.0, 1.0]) {
      final eye = h + f * (cell * 0.12) + side * (s * cell * 0.17);
      if (state.dead) {
        final e = cell * 0.08;
        final pen = Paint()
          ..color = Colors.white
          ..strokeWidth = cell * 0.05
          ..strokeCap = StrokeCap.round;
        canvas.drawLine(eye + Offset(-e, -e), eye + Offset(e, e), pen);
        canvas.drawLine(eye + Offset(-e, e), eye + Offset(e, -e), pen);
      } else {
        canvas.drawCircle(eye, cell * 0.1, Paint()..color = Colors.white);
        canvas.drawCircle(eye + f * (cell * 0.035), cell * 0.05, Paint()..color = const Color(0xFF1B2230));
      }
    }
  }

  @override
  bool shouldRepaint(_SnakePainter old) =>
      !identical(old.state, state) || old.prevTail != prevTail || old.board != board || old.checker != checker;
}
