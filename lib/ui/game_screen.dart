import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/daily.dart';
import '../core/day.dart';
import '../core/difficulty.dart';
import '../core/game_controller.dart';
import '../core/generator_runner.dart';
import '../core/persistence.dart';
import '../core/puzzle_code.dart';
import '../core/puzzle_type.dart';
import '../core/settings.dart';
import '../l10n/l10n.dart';
import 'app_router.dart';
import 'new_game_sheet.dart' show formatDuration;
import 'puzzle_code_ui.dart';
import 'win_overlay.dart';

/// Plays one puzzle. With [params] == null it resumes the saved game.
class GameScreen extends StatefulWidget {
  const GameScreen({
    super.key,
    required this.type,
    this.params,
    this.daily,
    this.onPuzzleChanged,
    this.presetPuzzle,
    this.presetState,
  });

  final PuzzleType type;
  final GenParams? params;

  /// Set when [params] is this day's challenge: it gets its own save slot,
  /// counts toward the day and offers the day's next puzzle when solved.
  final Day? daily;

  /// Called when a puzzle starts, so the address can follow "new puzzle".
  final ValueChanged<GenParams>? onPuzzleChanged;

  /// Skips generation (snapshots/tests). Requires [params].
  @visibleForTesting
  final Object? presetPuzzle;
  @visibleForTesting
  final Object? presetState;

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> with WidgetsBindingObserver, TickerProviderStateMixin {
  GameController? _ctrl;
  Object? _error;
  Timer? _ticker;
  Timer? _flashTimer;
  int _seenFlash = 0;
  int _seenShake = 0;
  int _seenToast = 0;
  bool _winShown = false;

  late final AnimationController _win = AnimationController(vsync: this, duration: const Duration(milliseconds: 1600));
  late final AnimationController _shake = AnimationController(vsync: this, duration: const Duration(milliseconds: 420));

  PuzzleType get type => widget.type;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted && _ctrl != null && !_ctrl!.solved) setState(() {});
    });
    if (widget.presetPuzzle != null) {
      _attach(GameController(
        type: type,
        params: widget.params!,
        puzzle: widget.presetPuzzle!,
        state: widget.presetState ?? type.initialState(widget.presetPuzzle) as Object,
        settings: context.read<Settings>(),
        store: context.read<GameStore>(),
        daily: widget.daily,
      ));
      return;
    }
    final save = _resumable(context.read<GameStore>().readSave(_slot));
    if (save != null) {
      try {
        _attach(GameController.fromSave(
          type: type,
          json: save,
          settings: context.read<Settings>(),
          store: context.read<GameStore>(),
        ));
        return;
      } catch (e) {
        debugPrint('Could not restore save: $e');
      }
    }
    _newGame(widget.params ?? GenParams(size: type.defaultSize, difficulty: type.difficulties.first, seed: _seed()));
  }

  int _seed() => Random().nextInt(1 << 31);

  String get _slot => switch ((widget.daily, widget.params)) {
        (_?, final params?) => GameStore.dailySlot(PuzzleCode.format(type, params)),
        _ => type.id,
      };

  /// The saved game, if there's nothing new to start or the requested puzzle
  /// is the one saved (a share link opened twice, a web page reload).
  Map<String, dynamic>? _resumable(Map<String, dynamic>? save) {
    final params = widget.params;
    if (save == null || params == null) return save;
    return jsonEncode(save['params']) == jsonEncode(params.toJson()) ? save : null;
  }

  Future<void> _newGame(GenParams params) async {
    params = GenParams(
      size: params.size,
      difficulty: params.difficulty,
      seed: params.seed,
      options: type.resolveOptions(params.options),
    );
    widget.onPuzzleChanged?.call(params);
    final settings = context.read<Settings>();
    final store = context.read<GameStore>();
    setState(() {
      _ctrl?.removeListener(_onCtrl);
      _ctrl = null;
      _error = null;
    });
    try {
      final puzzle = await generatePuzzle(type, params);
      if (!mounted) return;
      _attach(GameController(
        type: type,
        params: params,
        puzzle: puzzle,
        state: type.initialState(puzzle) as Object,
        settings: settings,
        store: store,
        daily: widget.daily,
      ));
    } catch (e, st) {
      debugPrint('Generation failed: $e\n$st');
      if (mounted) setState(() => _error = e);
    }
  }

  void _attach(GameController c) {
    c.winAnimation = _win;
    c.addListener(_onCtrl);
    c.resume();
    c.save();
    _winShown = false;
    _seenFlash = c.flashTick;
    _seenShake = c.shakeTick;
    _seenToast = c.toastTick;
    _win.value = 0;
    setState(() => _ctrl = c);
  }

  void _onCtrl() {
    final c = _ctrl!;
    if (c.solved && !_winShown) {
      _winShown = true;
      _win.forward(from: 0);
    }
    if (c.shakeTick != _seenShake) {
      _seenShake = c.shakeTick;
      _shake.forward(from: 0);
    }
    if (c.toastTick != _seenToast) {
      _seenToast = c.toastTick;
      final msg = c.toast;
      if (msg != null) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(msg(context.l10n)), duration: const Duration(seconds: 2)));
      }
    }
    if (c.flashTick != _seenFlash) {
      _seenFlash = c.flashTick;
      _flashTimer?.cancel();
      _flashTimer = Timer(const Duration(milliseconds: 1600), () => _ctrl?.clearFlash());
    }
    setState(() {});
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final c = _ctrl;
    if (c == null) return;
    if (state == AppLifecycleState.resumed) {
      c.resume();
    } else {
      c.pause();
      c.save();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _ticker?.cancel();
    _flashTimer?.cancel();
    final c = _ctrl;
    if (c != null) {
      c.pause();
      c.save();
      c.removeListener(_onCtrl);
      c.dispose();
    }
    _win.dispose();
    _shake.dispose();
    super.dispose();
  }

  void _submit() {
    final r = _ctrl!.submit();
    final l = context.l10n;
    final msg = switch (r) {
      SubmitOutcome.solved => null,
      SubmitOutcome.conflicts => l.submitConflicts,
      SubmitOutcome.incomplete => l.submitIncomplete,
      SubmitOutcome.wrong => l.submitWrong,
    };
    if (msg != null) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(msg), duration: const Duration(seconds: 2)));
    }
  }

  Future<void> _confirmRestart() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.l10n.restartTitle),
        content: Text(context.l10n.restartBody),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: Text(context.l10n.cancel)),
          FilledButton(onPressed: () => Navigator.pop(context, true), child: Text(context.l10n.restart)),
        ],
      ),
    );
    if (ok == true) _ctrl?.restart();
  }

  void _showRules() => showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(type.name(context.l10n)),
          content: SingleChildScrollView(child: Text(type.rulesText(context.l10n))),
          actions: [TextButton(onPressed: () => Navigator.pop(context), child: Text(context.l10n.gotIt))],
        ),
      );

  @override
  Widget build(BuildContext context) {
    final c = _ctrl;
    final l = context.l10n;
    return Scaffold(
      appBar: AppBar(
        title: Text(type.name(l)),
        actions: [
          if (c != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Center(
                child: Text(formatDuration(c.elapsed), style: const TextStyle(fontFeatures: [FontFeature.tabularFigures()])),
              ),
            ),
          IconButton(icon: const Icon(Icons.help_outline), tooltip: l.rules, onPressed: _showRules),
          PopupMenuButton<String>(
            onSelected: (v) {
              switch (v) {
                case 'new' when c != null:
                  _newGame(c.params.withSeed(_seed()));
                case 'copy' when c != null:
                  copyWithToast(context, c.link, l.shareLinkCopied);
                case 'code':
                  showEnterCodeDialog(context);
              }
            },
            itemBuilder: (_) => [
              if (widget.daily == null) PopupMenuItem(value: 'new', child: Text(l.newPuzzle)),
              if (c != null) PopupMenuItem(value: 'copy', child: Text(l.copyShareLink)),
              PopupMenuItem(value: 'code', child: Text(l.playCodeMenu)),
            ],
          ),
        ],
      ),
      body: c == null ? _loading(l) : _game(context, c),
    );
  }

  Widget _loading(AppLocalizations l) => Center(
        child: _error != null
            ? Column(mainAxisSize: MainAxisSize.min, children: [
                Text(l.couldNotGenerate),
                const SizedBox(height: 12),
                FilledButton(
                  onPressed: () => _newGame(widget.params ?? GenParams(size: type.defaultSize, difficulty: Difficulty.easy, seed: _seed())),
                  child: Text(l.tryAgain),
                ),
              ])
            : Column(mainAxisSize: MainAxisSize.min, children: [
                const CircularProgressIndicator(),
                const SizedBox(height: 16),
                Text(l.generating),
              ]),
      );

  Widget _game(BuildContext context, GameController c) {
    final theme = Theme.of(context);
    final l = context.l10n;
    final controls = type.buildControls(context, c);
    return Stack(children: [
      SafeArea(
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
            child: Row(children: [
              Flexible(
                flex: 8,
                child: Text(
                  [c.params.size.label, c.params.difficulty.label(l), if (type.optionsLabel(l, c.params) case final o when o.isNotEmpty) o]
                      .join(' · '),
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.labelLarge,
                ),
              ),
              const SizedBox(width: 4),
              Flexible(
                child: Tooltip(
                  message: l.copyShareLink,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(6),
                    onTap: () => copyWithToast(context, c.link, l.shareLinkCopied),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
                      child: Text(
                        '#${c.params.seed.toRadixString(36).toUpperCase()}',
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.labelLarge?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                      ),
                    ),
                  ),
                ),
              ),
              const Spacer(),
              if (type.supportsModeSwitch && !c.solved)
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
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: AnimatedBuilder(
                animation: _shake,
                builder: (context, child) => Transform.translate(
                  offset: Offset(sin(_shake.value * pi * 6) * 10 * (1 - _shake.value), 0),
                  child: child,
                ),
                child: type.buildBoard(context, c),
              ),
            ),
          ),
          if (!c.solved) ...[
            _Toolbar(controller: c, onRestart: _confirmRestart, onSubmit: type.showSubmit ? _submit : null),
            if (controls != null) Padding(padding: const EdgeInsets.fromLTRB(16, 4, 16, 12), child: controls),
            if (controls == null) const SizedBox(height: 8),
          ],
        ]),
      ),
      if (c.solved) Positioned.fill(child: c.daily != null ? _dailyWin(c, c.daily!) : _freeWin(c)),
    ]);
  }

  Widget _freeWin(GameController c) => WinOverlay(
        animation: _win,
        controller: c,
        backLabel: context.l10n.home,
        onBack: () => Navigator.of(context).pop(),
        nextLabel: context.l10n.newPuzzle,
        onNext: () => _newGame(c.params.withSeed(_seed())),
      );

  /// Back leads to the calendar; next is the day's next unsolved puzzle.
  Widget _dailyWin(GameController c, Day day) {
    final l = context.l10n;
    final puzzles = dailyPuzzles(day);
    final results = context.read<GameStore>().dailyResults(day);
    bool solved(DailyPuzzle p) => results.containsKey(GameStore.dailyEntry(p.type.id, p.difficulty));
    final done = puzzles.where(solved).length;
    final here = puzzles.indexWhere((p) => p.type == type && p.difficulty == c.params.difficulty);
    final next = [...puzzles.skip(here + 1), ...puzzles.take(here + 1)].where((p) => !solved(p)).firstOrNull;
    return WinOverlay(
      animation: _win,
      controller: c,
      note: done == puzzles.length ? l.dailyDayComplete : l.dailyProgress(done, puzzles.length),
      backLabel: l.dailyCalendar,
      onBack: () => Navigator.of(context).pop(),
      nextLabel: l.dailyNext,
      onNext: next == null ? null : () => AppRouterDelegate.of(context).openDailyGame(day, next.type, next.difficulty),
    );
  }
}

class _Toolbar extends StatelessWidget {
  const _Toolbar({required this.controller, required this.onRestart, required this.onSubmit});

  final GameController controller;
  final VoidCallback onRestart;
  final VoidCallback? onSubmit;

  @override
  Widget build(BuildContext context) {
    final c = controller;
    final l = context.l10n;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(icon: const Icon(Icons.undo_rounded), tooltip: l.undo, onPressed: c.canUndo ? c.undo : null),
          IconButton(icon: const Icon(Icons.redo_rounded), tooltip: l.redo, onPressed: c.canRedo ? c.redo : null),
          IconButton(icon: const Icon(Icons.restart_alt_rounded), tooltip: l.restart, onPressed: onRestart),
          IconButton(icon: const Icon(Icons.lightbulb_outline_rounded), tooltip: l.hint, onPressed: c.hint),
          if (onSubmit != null)
            FilledButton.icon(onPressed: onSubmit, icon: const Icon(Icons.check_rounded), label: Text(l.submit)),
        ],
      ),
    );
  }
}
