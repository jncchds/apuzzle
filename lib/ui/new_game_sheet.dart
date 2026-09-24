import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/difficulty.dart';
import '../core/grid.dart';
import '../core/persistence.dart';
import '../core/puzzle_type.dart';
import 'game_screen.dart';

/// Sizes of [type] whose board fits [screen] without zoom.
List<GridSize> fittingSizes(PuzzleType type, Size screen) {
  const gapFactor = 1.06;
  final cell = type.minCellSize * gapFactor;
  final maxCols = ((screen.width - 24) / cell).floor();
  final maxRows = ((screen.height - 160 - type.controlsHeight) / cell).floor();
  final fit = type.sizes.where((s) => s.cols <= maxCols && s.rows <= maxRows).toList();
  return fit.isEmpty ? [type.sizes.first] : fit;
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
  }

  void _go({required bool resume}) {
    final store = context.read<GameStore>();
    final nav = Navigator.of(widget.rootContext);
    Navigator.of(context).pop();
    GenParams? params;
    if (!resume) {
      store.setLastChoice(widget.type.id, {'size': _size.toJson(), 'difficulty': _difficulty.name});
      params = GenParams(size: _size, difficulty: _difficulty, seed: Random().nextInt(1 << 31));
    }
    nav.push(MaterialPageRoute(builder: (_) => GameScreen(type: widget.type, params: params)));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final store = context.read<GameStore>();
    final sizes = fittingSizes(widget.type, MediaQuery.sizeOf(context));
    if (!sizes.contains(_size)) _size = sizes.contains(widget.type.defaultSize) ? widget.type.defaultSize : sizes.last;
    final hasSave = store.hasSave(widget.type.id);
    final stats = store.stats(widget.type.id, _difficulty);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(children: [
              Icon(widget.type.icon, color: widget.type.accent),
              const SizedBox(width: 10),
              Text(widget.type.name, style: theme.textTheme.titleLarge),
            ]),
            const SizedBox(height: 16),
            Text('Size', style: theme.textTheme.labelLarge),
            const SizedBox(height: 8),
            Wrap(spacing: 8, runSpacing: 8, children: [
              for (final s in sizes)
                ChoiceChip(label: Text(s.label), selected: s == _size, onSelected: (_) => setState(() => _size = s)),
            ]),
            const SizedBox(height: 16),
            Text('Difficulty', style: theme.textTheme.labelLarge),
            const SizedBox(height: 8),
            SegmentedButton<Difficulty>(
              segments: [
                for (final d in widget.type.difficulties) ButtonSegment(value: d, label: Text(d.label)),
              ],
              selected: {_difficulty},
              showSelectedIcon: false,
              onSelectionChanged: (s) => setState(() => _difficulty = s.first),
            ),
            const SizedBox(height: 12),
            Text(
              stats.solved == 0
                  ? 'Not solved yet on ${_difficulty.label}'
                  : 'Solved ${stats.solved}× · best ${formatDuration(stats.best!)} · avg ${formatDuration(stats.average!)}',
              style: theme.textTheme.bodySmall,
            ),
            const SizedBox(height: 20),
            if (hasSave) ...[
              OutlinedButton.icon(
                onPressed: () => _go(resume: true),
                icon: const Icon(Icons.play_arrow_rounded),
                label: const Text('Continue'),
              ),
              const SizedBox(height: 8),
            ],
            FilledButton.icon(
              onPressed: () => _go(resume: false),
              icon: const Icon(Icons.auto_awesome_rounded),
              label: const Text('New puzzle'),
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
