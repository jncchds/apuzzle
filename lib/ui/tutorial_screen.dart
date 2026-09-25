import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../core/difficulty.dart';
import '../core/game_controller.dart';
import '../core/persistence.dart';
import '../core/puzzle_type.dart';
import '../core/settings.dart';
import '../core/tutorial.dart';
import '../l10n/l10n.dart';
import 'app_router.dart';

/// Before a first game of [type], offers its tutorial. [play] starts the
/// game: right away, after "No, thanks", or from the tutorial's last page.
/// Players who already know the game go straight to [play].
Future<void> offerTutorial(BuildContext context, PuzzleType type, {required VoidCallback play}) async {
  final store = context.read<GameStore>();
  if (store.knowsGame(type.id) || type.tutorial().isEmpty) {
    play();
    return;
  }
  final router = AppRouterDelegate.of(context);
  final learn = await showDialog<bool>(
    context: context,
    builder: (context) {
      final l = context.l10n;
      return AlertDialog(
        icon: Icon(type.icon, color: type.accent),
        title: Text(l.tutorialOfferTitle(type.name(l))),
        content: Text(l.tutorialOfferBody),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: Text(l.tutorialOfferNo)),
          FilledButton(onPressed: () => Navigator.pop(context, true), child: Text(l.tutorialOfferYes)),
        ],
      );
    },
  );
  switch (learn) {
    case true:
      router.openTutorial(type, play: play);
    case false:
      await store.setTutorial(type.id, done: false);
      play();
    case null: // dismissed: nothing starts
  }
}

/// A type's interactive tutorial: its [PuzzleType.tutorial] steps, each a
/// tiny practice board with a short text. A step is done when its board is
/// solved (or its own goal is met); then Next opens.
class TutorialScreen extends StatefulWidget {
  const TutorialScreen({super.key, required this.type, this.onPlay, this.firstStep = 0});

  final PuzzleType type;

  /// What "Play now" on the last page starts (none: no such button).
  final VoidCallback? onPlay;

  /// Opens at this step (snapshots).
  @visibleForTesting
  final int firstStep;

  @override
  State<TutorialScreen> createState() => _TutorialScreenState();
}

class _TutorialScreenState extends State<TutorialScreen> with TickerProviderStateMixin {
  late final List<TutorialStep> _steps = widget.type.tutorial();
  late final GameStore _store;
  int _index = 0;
  GameController? _ctrl;

  /// The open step's goal is met.
  bool _done = false;

  /// Past the last step.
  bool _finished = false;

  Object? _lastState;
  Timer? _flashTimer;
  int _seenFlash = 0;
  int _seenShake = 0;
  int _seenToast = 0;

  late final AnimationController _win = AnimationController(vsync: this, duration: const Duration(milliseconds: 1600));
  late final AnimationController _shake = AnimationController(vsync: this, duration: const Duration(milliseconds: 420));

  PuzzleType get type => widget.type;
  TutorialStep get _step => _steps[_index];

  @override
  void initState() {
    super.initState();
    _store = context.read<GameStore>();
    if (_steps.isNotEmpty) _open(widget.firstStep);
  }

  @override
  void dispose() {
    // Leaving halfway still counts as "offered".
    if (!_finished) _store.setTutorial(type.id, done: false);
    _flashTimer?.cancel();
    _ctrl?.removeListener(_onCtrl);
    _ctrl?.dispose();
    _win.dispose();
    _shake.dispose();
    super.dispose();
  }

  void _open(int k) {
    _flashTimer?.cancel();
    _ctrl?.removeListener(_onCtrl);
    _ctrl?.dispose();
    final step = _steps[k];
    final c = GameController(
      type: type,
      params: GenParams(size: type.defaultSize, difficulty: Difficulty.easy, seed: 0),
      puzzle: step.puzzle,
      state: step.state ?? type.initialState(step.puzzle) as Object,
      settings: context.read<Settings>(),
      store: _store,
      practice: true,
    )
      ..winAnimation = _win
      ..flashHints = step.focus;
    c.addListener(_onCtrl);
    _win.value = 0;
    _lastState = c.state;
    _seenFlash = c.flashTick;
    _seenShake = c.shakeTick;
    _seenToast = c.toastTick;
    setState(() {
      _index = k;
      _ctrl = c;
      _done = step.look;
      _finished = false;
    });
  }

  void _onCtrl() {
    final c = _ctrl!;
    if (c.toastTick != _seenToast) {
      _seenToast = c.toastTick;
      if (c.toast case final msg?) _snack(msg(context.l10n));
    }
    if (c.shakeTick != _seenShake) {
      _seenShake = c.shakeTick;
      _shake.forward(from: 0);
    }
    if (c.flashTick != _seenFlash) {
      _seenFlash = c.flashTick;
      _flashTimer?.cancel();
      _flashTimer = Timer(const Duration(milliseconds: 1600), () {
        final c = _ctrl;
        if (c == null) return;
        c.clearFlash();
        if (!_done) c.pointAt(_step.focus);
      });
    }
    if (!identical(c.state, _lastState)) {
      _lastState = c.state;
      _checkStep(c);
    }
    setState(() {});
  }

  void _checkStep(GameController c) {
    if (_done) return;
    final step = _step;
    if (step.done?.call(c.state) ?? c.solved) {
      _done = true;
      _flashTimer?.cancel();
      c.pointAt(const {});
      _win.forward(from: 0);
      if (c.settings.haptics) HapticFeedback.mediumImpact();
    } else if (step.done == null && type.isComplete(c.puzzle, c.state)) {
      // Finished but wrong: point at the mistakes, like Submit does.
      scheduleMicrotask(() {
        if (!mounted || _ctrl != c) return;
        final l = context.l10n;
        switch (c.submit()) {
          case SubmitOutcome.conflicts:
            _snack(l.submitConflicts);
          case SubmitOutcome.wrong:
            _snack(l.submitWrong);
          case _:
        }
      });
    }
  }

  void _snack(String text) => ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(text), duration: const Duration(seconds: 2)));

  void _showMe() {
    final c = _ctrl!;
    if (_step.answer case final answer?) {
      c.apply(answer);
    } else {
      c.hint();
    }
  }

  void _next() {
    if (_index + 1 < _steps.length) {
      _open(_index + 1);
      return;
    }
    _store.setTutorial(type.id, done: true);
    setState(() => _finished = true);
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l.tutorialTitle(type.name(l)))),
      body: SafeArea(
        child: _steps.isEmpty
            ? const SizedBox.shrink()
            : _finished
                ? _finishView(context)
                : _stepView(context, _ctrl!),
      ),
    );
  }

  Widget _stepView(BuildContext context, GameController c) {
    final theme = Theme.of(context);
    final l = context.l10n;
    final step = _step;
    final playing = !step.look && !_done;
    final controls = playing ? type.buildControls(context, c) : null;
    final last = _index == _steps.length - 1;
    return Column(children: [
      LinearProgressIndicator(value: (_index + (_done ? 1 : 0)) / _steps.length, minHeight: 3),
      Padding(
        padding: const EdgeInsets.fromLTRB(4, 4, 16, 0),
        child: Row(children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_rounded),
            visualDensity: VisualDensity.compact,
            tooltip: l.tutorialPrevious,
            onPressed: _index > 0 ? () => _open(_index - 1) : null,
          ),
          Text(l.tutorialStep(_index + 1, _steps.length), style: theme.textTheme.labelLarge),
          const Spacer(),
          if (type.supportsModeSwitch && playing)
            SegmentedButton<InputMode>(
              style: const ButtonStyle(visualDensity: VisualDensity.compact),
              segments: [
                ButtonSegment(value: InputMode.cycle, icon: const Icon(Icons.touch_app_outlined), tooltip: l.tapToCycle),
                ButtonSegment(value: InputMode.palette, icon: const Icon(Icons.palette_outlined), tooltip: l.palette),
              ],
              selected: {c.inputMode},
              showSelectedIcon: false,
              onSelectionChanged: (s) => c.setInputMode(s.first),
            ),
        ]),
      ),
      Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          child: Container(
            key: ValueKey(_index),
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHigh,
              borderRadius: BorderRadius.circular(16),
              border: Border(left: BorderSide(color: type.accent, width: 4)),
            ),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(step.text(l), style: theme.textTheme.bodyLarge),
              AnimatedSize(
                duration: const Duration(milliseconds: 200),
                child: _done && !step.look
                    ? Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Row(children: [
                          Icon(Icons.check_circle_rounded, color: theme.colorScheme.primary, size: 20),
                          const SizedBox(width: 6),
                          Text(l.tutorialNice,
                              style: theme.textTheme.titleSmall?.copyWith(color: theme.colorScheme.primary)),
                        ]),
                      )
                    : const SizedBox(width: double.infinity),
              ),
            ]),
          ),
        ),
      ),
      Expanded(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
          child: AnimatedBuilder(
            animation: _shake,
            builder: (context, child) => Transform.translate(
              offset: Offset(sin(_shake.value * pi * 6) * 10 * (1 - _shake.value), 0),
              child: child,
            ),
            child: IgnorePointer(
              ignoring: !playing,
              child: KeyedSubtree(key: ValueKey(_index), child: type.buildBoard(context, c)),
            ),
          ),
        ),
      ),
      if (controls != null) Padding(padding: const EdgeInsets.fromLTRB(16, 0, 16, 8), child: controls),
      Padding(
        padding: const EdgeInsets.fromLTRB(8, 0, 12, 12),
        child: Row(children: [
          if (!step.look) ...[
            IconButton(icon: const Icon(Icons.undo_rounded), tooltip: l.undo, onPressed: c.canUndo ? c.undo : null),
            IconButton(icon: const Icon(Icons.restart_alt_rounded), tooltip: l.tutorialReset, onPressed: () => _open(_index)),
          ],
          // "Show me" takes the free space and shortens its label if it must.
          Expanded(
            child: Align(
              alignment: Alignment.centerLeft,
              child: playing
                  ? TextButton(
                      onPressed: _showMe,
                      child: Row(mainAxisSize: MainAxisSize.min, children: [
                        const Icon(Icons.lightbulb_outline_rounded, size: 18),
                        const SizedBox(width: 6),
                        Flexible(child: Text(l.tutorialShowMe, maxLines: 1, overflow: TextOverflow.ellipsis)),
                      ]),
                    )
                  : null,
            ),
          ),
          const SizedBox(width: 8),
          FilledButton.icon(
            onPressed: _done ? _next : null,
            icon: Icon(last ? Icons.check_rounded : Icons.arrow_forward_rounded),
            label: Text(last ? l.tutorialFinish : l.tutorialNext),
          ),
        ]),
      ),
    ]);
  }

  Widget _finishView(BuildContext context) {
    final theme = Theme.of(context);
    final l = context.l10n;
    final play = widget.onPlay;
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(color: type.accent.withValues(alpha: 0.18), shape: BoxShape.circle),
            child: Icon(type.icon, color: type.accent, size: 48),
          ),
          const SizedBox(height: 20),
          Text(l.tutorialFinishedTitle, style: theme.textTheme.headlineSmall, textAlign: TextAlign.center),
          const SizedBox(height: 8),
          Text(l.tutorialFinishedBody(type.name(l)), style: theme.textTheme.bodyLarge, textAlign: TextAlign.center),
          const SizedBox(height: 28),
          if (play != null) ...[
            FilledButton.icon(onPressed: play, icon: const Icon(Icons.play_arrow_rounded), label: Text(l.tutorialPlay)),
            const SizedBox(height: 8),
          ],
          OutlinedButton.icon(
            onPressed: () => _open(0),
            icon: const Icon(Icons.replay_rounded),
            label: Text(l.tutorialAgain),
          ),
          const SizedBox(height: 8),
          TextButton(onPressed: () => Navigator.of(context).maybePop(), child: Text(l.tutorialClose)),
        ]),
      ),
    );
  }
}
