import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/difficulty.dart';
import '../core/game_controller.dart';
import '../core/generator_runner.dart';
import '../core/persistence.dart';
import '../core/puzzle_type.dart';
import '../core/settings.dart';
import 'new_game_sheet.dart' show formatDuration;
import 'puzzle_code_ui.dart';
import 'win_overlay.dart';

/// Plays one puzzle. With [params] == null it resumes the saved game.
class GameScreen extends StatefulWidget {
  const GameScreen({super.key, required this.type, this.params, this.presetPuzzle, this.presetState});

  final PuzzleType type;
  final GenParams? params;

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
      ));
      return;
    }
    final save = _resumable(context.read<GameStore>().readSave(type.id));
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

  /// The saved game, if there's nothing new to start or the requested puzzle
  /// is the one saved (a share link opened twice, a web page reload).
  Map<String, dynamic>? _resumable(Map<String, dynamic>? save) {
    final params = widget.params;
    if (save == null || params == null) return save;
    return jsonEncode(save['params']) == jsonEncode(params.toJson()) ? save : null;
  }

  Future<void> _newGame(GenParams params) async {
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
          ..showSnackBar(SnackBar(content: Text(msg), duration: const Duration(seconds: 2)));
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
    final msg = switch (r) {
      SubmitOutcome.solved => null,
      SubmitOutcome.conflicts => 'Some cells break the rules',
      SubmitOutcome.incomplete => 'Not finished yet',
      SubmitOutcome.wrong => 'Not quite right',
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
        title: const Text('Restart puzzle?'),
        content: const Text('All your entries will be cleared. You can still undo.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('Restart')),
        ],
      ),
    );
    if (ok == true) _ctrl?.restart();
  }

  void _showRules() => showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(type.name),
          content: SingleChildScrollView(child: Text(type.rulesText)),
          actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Got it'))],
        ),
      );

  @override
  Widget build(BuildContext context) {
    final c = _ctrl;
    return Scaffold(
      appBar: AppBar(
        title: Text(type.name),
        actions: [
          if (c != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Center(
                child: Text(formatDuration(c.elapsed), style: const TextStyle(fontFeatures: [FontFeature.tabularFigures()])),
              ),
            ),
          IconButton(icon: const Icon(Icons.help_outline), tooltip: 'Rules', onPressed: _showRules),
          PopupMenuButton<String>(
            onSelected: (v) {
              switch (v) {
                case 'new' when c != null:
                  _newGame(c.params.withSeed(_seed()));
                case 'copy' when c != null:
                  copyWithToast(context, c.link, 'Share link copied');
                case 'code':
                  showEnterCodeDialog(context, replace: true);
              }
            },
            itemBuilder: (_) => [
              const PopupMenuItem(value: 'new', child: Text('New puzzle')),
              if (c != null) const PopupMenuItem(value: 'copy', child: Text('Copy share link')),
              const PopupMenuItem(value: 'code', child: Text('Play a puzzle code…')),
            ],
          ),
        ],
      ),
      body: c == null ? _loading() : _game(context, c),
    );
  }

  Widget _loading() => Center(
        child: _error != null
            ? Column(mainAxisSize: MainAxisSize.min, children: [
                const Text('Could not generate a puzzle'),
                const SizedBox(height: 12),
                FilledButton(
                  onPressed: () => _newGame(widget.params ?? GenParams(size: type.defaultSize, difficulty: Difficulty.easy, seed: _seed())),
                  child: const Text('Try again'),
                ),
              ])
            : const Column(mainAxisSize: MainAxisSize.min, children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Generating puzzle…'),
              ]),
      );

  Widget _game(BuildContext context, GameController c) {
    final theme = Theme.of(context);
    final controls = type.buildControls(context, c);
    return Stack(children: [
      SafeArea(
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
            child: Row(children: [
              Text('${c.params.size.label} · ${c.params.difficulty.label}', style: theme.textTheme.labelLarge),
              const SizedBox(width: 4),
              Flexible(
                child: Tooltip(
                  message: 'Copy share link',
                  child: InkWell(
                    borderRadius: BorderRadius.circular(6),
                    onTap: () => copyWithToast(context, c.link, 'Share link copied'),
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
                  segments: const [
                    ButtonSegment(value: InputMode.cycle, icon: Icon(Icons.touch_app_outlined), tooltip: 'Tap to cycle'),
                    ButtonSegment(value: InputMode.palette, icon: Icon(Icons.palette_outlined), tooltip: 'Palette'),
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
      if (c.solved)
        Positioned.fill(
          child: WinOverlay(
            animation: _win,
            controller: c,
            onHome: () => Navigator.of(context).pop(),
            onNew: () => _newGame(c.params.withSeed(_seed())),
          ),
        ),
    ]);
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(icon: const Icon(Icons.undo_rounded), tooltip: 'Undo', onPressed: c.canUndo ? c.undo : null),
          IconButton(icon: const Icon(Icons.redo_rounded), tooltip: 'Redo', onPressed: c.canRedo ? c.redo : null),
          IconButton(icon: const Icon(Icons.restart_alt_rounded), tooltip: 'Restart', onPressed: onRestart),
          IconButton(icon: const Icon(Icons.lightbulb_outline_rounded), tooltip: 'Hint', onPressed: c.hint),
          if (onSubmit != null)
            FilledButton.icon(onPressed: onSubmit, icon: const Icon(Icons.check_rounded), label: const Text('Submit')),
        ],
      ),
    );
  }
}
