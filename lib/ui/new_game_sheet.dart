import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/difficulty.dart';
import '../core/grid.dart';
import '../core/persistence.dart';
import '../core/puzzle_type.dart';
import '../l10n/l10n.dart';
import 'app_router.dart';
import 'tutorial_screen.dart';

/// Sizes of [type] whose board fits [screen] without zoom.
List<GridSize> fittingSizes(PuzzleType type, Size screen) {
  const gapFactor = 1.06;
  final cell = type.minCellSize * gapFactor;
  final maxCols = ((screen.width - 24) / cell).floor();
  final maxRows = ((screen.height - 160 - type.controlsHeight) / cell).floor();
  final fit = type.sizes.where((s) => s.cols <= maxCols && s.rows <= maxRows).toList();
  return fit.isEmpty ? [type.sizes.first] : fit;
}

/// A new game with the last choices for [type] (or its defaults), without
/// asking: the size that fits [screen], a fresh seed.
GenParams quickParams(PuzzleType type, GameStore store, Size screen) {
  final last = store.lastChoice(type.id);
  final sizes = fittingSizes(type, screen);
  var size = last?['size'] != null ? GridSize.fromJson(last!['size'] as Map<String, dynamic>) : type.defaultSize;
  if (!sizes.contains(size)) size = sizes.contains(type.defaultSize) ? type.defaultSize : sizes.last;
  return GenParams(
    size: size,
    difficulty: Difficulty.values.asNameMap()[last?['difficulty']] ?? type.difficulties.first,
    seed: Random().nextInt(1 << 31),
    options: type.resolveOptions((last?['options'] as Map<String, dynamic>?)?.cast<String, String>() ?? const {}),
  );
}

Future<void> showNewGameSheet(BuildContext context, PuzzleType type) => showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (_) => _NewGameSheet(type: type, rootContext: context),
    );

class _NewGameSheet extends StatefulWidget {
  const _NewGameSheet({required this.type, required this.rootContext});

  final PuzzleType type;
  final BuildContext rootContext;

  @override
  State<_NewGameSheet> createState() => _NewGameSheetState();
}

class _NewGameSheetState extends State<_NewGameSheet> {
  late GridSize _size;
  late Difficulty _difficulty;

  @override
  void initState() {
    super.initState();
    final last = context.read<GameStore>().lastChoice(widget.type.id);
    _size = last?['size'] != null ? GridSize.fromJson(last!['size'] as Map<String, dynamic>) : widget.type.defaultSize;
    _difficulty = Difficulty.values.asNameMap()[last?['difficulty']] ?? widget.type.difficulties.first;
    _options = widget.type.resolveOptions((last?['options'] as Map<String, dynamic>?)?.cast<String, String>() ?? const {});
  }

  late Map<String, String> _options;

  GenParams _params(int seed) => GenParams(size: _size, difficulty: _difficulty, seed: seed, options: _options);

  void _go({required bool resume}) {
    final store = context.read<GameStore>();
    final router = AppRouterDelegate.of(widget.rootContext);
    Navigator.of(context).pop();
    GenParams? params;
    if (resume) {
      // The address names the saved puzzle; GameScreen resumes it.
      try {
        params = GenParams.fromJson(store.readSave(widget.type.id)!['params'] as Map<String, dynamic>);
      } catch (e) {
        debugPrint('Could not read the saved puzzle: $e');
      }
      router.openGame(widget.type, params ?? _params(Random().nextInt(1 << 31)));
      return;
    }
    store.setLastChoice(widget.type.id, {'size': _size.toJson(), 'difficulty': _difficulty.name, 'options': _options});
    final chosen = _params(Random().nextInt(1 << 31));
    offerTutorial(widget.rootContext, widget.type, play: () => router.openGame(widget.type, chosen));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l = context.l10n;
    final type = widget.type;
    final store = context.read<GameStore>();
    final sizes = fittingSizes(type, MediaQuery.sizeOf(context));
    if (!sizes.contains(_size)) _size = sizes.contains(type.defaultSize) ? type.defaultSize : sizes.last;
    final hasSave = store.hasSave(type.id);
    final stats = store.stats(type.id, _params(0).variant);

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(children: [
              Icon(type.icon, color: type.accent),
              const SizedBox(width: 10),
              Text(type.name(l), style: theme.textTheme.titleLarge),
            ]),
            const SizedBox(height: 16),
            Text(l.size, style: theme.textTheme.labelLarge),
            const SizedBox(height: 8),
            Wrap(spacing: 8, runSpacing: 8, children: [
              for (final s in sizes)
                ChoiceChip(label: Text(s.label), selected: s == _size, onSelected: (_) => setState(() => _size = s)),
            ]),
            const SizedBox(height: 16),
            Text(l.difficulty, style: theme.textTheme.labelLarge),
            const SizedBox(height: 8),
            SegmentedButton<Difficulty>(
              segments: [
                for (final d in type.difficulties) ButtonSegment(value: d, label: Text(d.label(l))),
              ],
              selected: {_difficulty},
              showSelectedIcon: false,
              onSelectionChanged: (s) => setState(() => _difficulty = s.first),
            ),
            for (final o in type.optionsFor(_options)) ...[
              const SizedBox(height: 16),
              Text(type.optionLabel(l, o.id), style: theme.textTheme.labelLarge),
              const SizedBox(height: 8),
              Wrap(spacing: 8, runSpacing: 8, children: [
                for (final c in o.choices)
                  ChoiceChip(
                    label: Text(type.choiceLabel(l, o.id, c)),
                    selected: _options[o.id] == c,
                    onSelected: (_) => setState(() => _options = type.resolveOptions({..._options, o.id: c})),
                  ),
              ]),
              if (type.choiceDescription(l, o.id, _options[o.id]!) case final d?) ...[
                const SizedBox(height: 6),
                Text(d, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
              ],
            ],
            const SizedBox(height: 12),
            Text(
              stats.solved == 0
                  ? l.notSolvedYet(_difficulty.label(l))
                  : stats.bestScore != null
                      ? l.statsScore(stats.solved, stats.bestScore!, formatDuration(stats.best!))
                      : l.statsTime(stats.solved, formatDuration(stats.best!), formatDuration(stats.average!)),
              style: theme.textTheme.bodySmall,
            ),
            const SizedBox(height: 20),
            if (hasSave) ...[
              OutlinedButton.icon(
                onPressed: () => _go(resume: true),
                icon: const Icon(Icons.play_arrow_rounded),
                label: Text(l.continueGame),
              ),
              const SizedBox(height: 8),
            ],
            FilledButton.icon(
              onPressed: () => _go(resume: false),
              icon: const Icon(Icons.auto_awesome_rounded),
              label: Text(l.newPuzzle),
            ),
          ],
        ),
      ),
    );
  }
}

String formatDuration(Duration d) {
  final m = d.inMinutes;
  final s = d.inSeconds % 60;
  return d.inHours > 0
      ? '${d.inHours}:${(m % 60).toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}'
      : '$m:${s.toString().padLeft(2, '0')}';
}
