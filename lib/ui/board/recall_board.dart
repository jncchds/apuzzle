import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/game_controller.dart';
import '../../core/recall.dart';
import '../../l10n/l10n.dart';

/// The board of a memory game ([RecallType]). It times the phases: a round
/// is shown for [RecallType.showMs] and then hidden, a result stays for a
/// moment and then the next round starts. A new game waits for a first tap,
/// and so does a round that was on show when the app went to the background.
/// Whether the board of a game waits for its first tap (the controls hide
/// the Ready button meanwhile).
final _waits = Expando<ValueNotifier<bool>>();

/// A new game waits.
ValueNotifier<bool> _waitingOf(GameController c) => _waits[c] ??= ValueNotifier(_fresh(c.state as RecallState));

bool _fresh(RecallState s) => s.phase == RecallPhase.show && s.round == 0 && s.correct + s.misses == 0;

class RecallBoard extends StatefulWidget {
  const RecallBoard({super.key, required this.type, required this.controller});

  final RecallType type;
  final GameController controller;

  @override
  State<RecallBoard> createState() => _RecallBoardState();
}

class _RecallBoardState extends State<RecallBoard> with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  late final AnimationController _clock = AnimationController(vsync: this)..addStatusListener(_onClock);

  /// The phase the clock is timing (round, phase and results so far).
  String? _timing;

  bool get _waiting => _waitingOf(_ctrl).value;
  set _waiting(bool on) => _waitingOf(_ctrl).value = on;

  GameController get _ctrl => widget.controller;
  RecallPuzzle get _puzzle => _ctrl.puzzle as RecallPuzzle;
  RecallState get _state => _ctrl.state as RecallState;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _ctrl.addListener(_onChange);
    _sync();
  }

  @override
  void didUpdateWidget(RecallBoard old) {
    super.didUpdateWidget(old);
    if (old.controller != widget.controller) {
      old.controller.removeListener(_onChange);
      widget.controller.addListener(_onChange);
      _timing = null;
    }
    _sync();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _ctrl.removeListener(_onChange);
    _clock.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed || _state.phase != RecallPhase.show || !_clock.isAnimating) return;
    // Don't let a round run out unseen: show it again from the start later.
    _clock.stop();
    _clock.value = 0;
    _timing = null;
    if (mounted) setState(() => _waiting = true);
  }

  void _onChange() {
    if (!mounted) return;
    _sync();
    setState(() {});
  }

  /// Starts the clock when a new phase begins.
  void _sync() {
    final s = _state;
    if (s.phase != RecallPhase.show && _waiting) _waiting = false;
    final key = '${s.round}.${s.phase.name}.${s.correct}.${s.misses}';
    if (key == _timing) return;
    _timing = key;
    _clock.stop();
    _clock.value = 0;
    if (_ctrl.solved || _waiting) return;
    final ms = switch (s.phase) {
      RecallPhase.show => widget.type.showMs(_puzzle, widget.type.roundOf(_puzzle, s)),
      RecallPhase.result => s.passed ? 900 : 1800,
      _ => null,
    };
    if (ms == null) return;
    _clock.duration = Duration(milliseconds: ms);
    _clock.forward(from: 0);
  }

  void _onClock(AnimationStatus status) {
    if (status != AnimationStatus.completed || !mounted || _ctrl.solved) return;
    final s = _state;
    if (s.phase == RecallPhase.show) {
      _ctrl.advance(recallHide(s));
    } else if (s.phase == RecallPhase.result) {
      _ctrl.advance(recallNext(_puzzle, s));
    }
  }

  void _tap(int? target) {
    if (_ctrl.solved) return;
    if (_waiting) {
      setState(() => _waiting = false);
      _timing = null;
      _sync();
      return;
    }
    final s = _state;
    if (s.phase == RecallPhase.result) {
      _ctrl.advance(recallNext(_puzzle, s));
      return;
    }
    if (target == null) return;
    final next = recallTap(widget.type, _puzzle, s, target);
    if (identical(next, s)) return;
    if (_ctrl.settings.haptics) {
      next.phase == RecallPhase.result && !next.passed ? HapticFeedback.heavyImpact() : HapticFeedback.selectionClick();
    }
    _ctrl.advance(next);
  }

  @override
  Widget build(BuildContext context) {
    final type = widget.type;
    final p = _puzzle;
    final s = _state;
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final round = s.phase == RecallPhase.done ? const <int>[] : type.roundOf(p, s);
    final message = _waiting ? context.l10n.recallStart : null;
    return LayoutBuilder(
      builder: (context, cons) {
        final f = type.frame;
        final cell = min(
          min(cons.maxWidth / (p.cols + 2 * f), cons.maxHeight / (p.rows + 2 * f)),
          80.0,
        ).floorToDouble();
        final size = Size(cell * (p.cols + 2 * f), cell * (p.rows + 2 * f));
        final origin = Offset(cell * f, cell * f);
        return Center(
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTapUp: (d) {
              final at = d.localPosition - origin;
              final r = (at.dy / cell).floor(), c = (at.dx / cell).floor();
              _tap(type.targetAt(p, r, c));
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                CustomPaint(
                  size: size,
                  painter: _RecallPainter(
                    type: type,
                    clock: _clock,
                    view: (ms, t) => RecallView(
                      puzzle: p,
                      state: s,
                      round: round,
                      cell: cell,
                      origin: origin,
                      ms: ms,
                      t: t,
                      waiting: _waiting,
                      scheme: scheme,
                      accent: type.accent,
                      fontFamily: theme.textTheme.bodyMedium?.fontFamily,
                    ),
                    key: '${s.toJson()}.$_waiting.${scheme.brightness}.$cell',
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
                      child: Text(message, style: theme.textTheme.titleSmall?.copyWith(color: scheme.onInverseSurface)),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _RecallPainter extends CustomPainter {
  _RecallPainter({required this.type, required this.clock, required this.view, required this.key})
    : super(repaint: clock);

  final RecallType type;
  final AnimationController clock;
  final RecallView Function(double ms, double t) view;

  /// Changes whenever anything but the clock does.
  final String key;

  @override
  void paint(Canvas canvas, Size size) {
    final d = clock.duration;
    final ms = d == null ? 0.0 : clock.value * d.inMilliseconds;
    type.paint(canvas, view(ms, clock.value));
  }

  @override
  bool shouldRepaint(_RecallPainter old) => old.key != key || old.type != type;
}

/// Under the board: round (or lives) and score, then what to do now, with a
/// Ready button while a round is on show.
class RecallControls extends StatelessWidget {
  const RecallControls({super.key, required this.type, required this.controller});

  final RecallType type;
  final GameController controller;

  @override
  Widget build(BuildContext context) {
    final waiting = _waitingOf(controller);
    return ListenableBuilder(
      listenable: Listenable.merge([controller, waiting]),
      builder: (context, _) {
        final p = controller.puzzle as RecallPuzzle;
        final s = controller.state as RecallState;
        final l = context.l10n;
        final status = switch (s.phase) {
          _ when waiting.value => '',
          RecallPhase.show => type.watchText(l, p),
          RecallPhase.answer => type.prompt(l, p),
          RecallPhase.result => s.passed ? l.recallRight(s.level) : l.recallMissed,
          RecallPhase.done => '',
        };
        return _build(context, p, s, status, type.hasReady && s.phase == RecallPhase.show && !waiting.value);
      },
    );
  }

  Widget _build(BuildContext context, RecallPuzzle p, RecallState s, String status, bool ready) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final l = context.l10n;
    final numbers = theme.textTheme.titleMedium?.copyWith(fontFeatures: const [FontFeature.tabularFigures()]);
    Widget pill(Widget child) => Container(
      height: 36,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: scheme.outline, width: 2),
      ),
      child: Center(widthFactor: 1, child: child),
    );
    final lives = p.goal == RecallGoal.lives && !p.retry;
    final shown = min(s.round + 1, p.rounds);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Wrap(
          spacing: 10,
          runSpacing: 8,
          alignment: WrapAlignment.center,
          children: [
            if (lives)
              pill(
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    for (var k = 0; k < p.lives; k++)
                      Icon(
                        k < p.lives - s.misses ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                        size: 20,
                        color: k < p.lives - s.misses ? scheme.error : scheme.outline,
                      ),
                  ],
                ),
              )
            else if (p.retry)
              pill(Text('${s.correct} / ${p.rounds}', style: numbers))
            else
              pill(Text(l.recallRound(shown, p.rounds), style: numbers)),
            pill(Text(l.scoreValue(s.score), style: numbers)),
          ],
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 44,
          child: Center(
            child: ready
                ? FilledButton.icon(
                    onPressed: () => controller.advance(recallHide(controller.state as RecallState)),
                    icon: const Icon(Icons.visibility_off_rounded),
                    label: Text(l.recallReady),
                  )
                : Text(
                    status,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: s.phase == RecallPhase.result
                          ? (s.passed ? const Color(0xFF3DBA6A) : scheme.error)
                          : scheme.onSurfaceVariant,
                    ),
                  ),
          ),
        ),
      ],
    );
  }
}
