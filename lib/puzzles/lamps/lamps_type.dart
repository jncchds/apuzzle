import 'package:flutter/material.dart';

import '../../core/difficulty.dart';
import '../../core/grid.dart';
import '../../core/puzzle_type.dart';
import '../../core/value_grid.dart';
import '../../l10n/l10n.dart';
import '../../ui/symbols.dart';
import 'lamps_generator.dart';
import 'lamps_model.dart';

/// Light Up: place lamps until every cell is lit.
class LampsType extends ValueGridType<LampsPuzzle> {
  const LampsType();

  static const lampColor = Color(0xFFFFB300);
  static const glow = Color(0xFFFFE9A8);
  static const wallColor = Color(0xFF2E3440);

  @override
  String get id => 'lamps';
  @override
  String name(AppLocalizations l) => l.lampsName;
  @override
  String tagline(AppLocalizations l) => l.lampsTagline;
  @override
  IconData get icon => Icons.lightbulb_outline_rounded;
  @override
  Color get accent => lampColor;

  @override
  String rulesText(AppLocalizations l) => l.lampsRules;

  @override
  List<GridSize> get sizes => [for (var n = 5; n <= 10; n++) GridSize.square(n)];
  @override
  GridSize get defaultSize => const GridSize.square(7);
  @override
  GridSize dailySize(Difficulty difficulty) => switch (difficulty) {
        Difficulty.easy => const GridSize.square(6),
        Difficulty.medium => const GridSize.square(8),
        _ => const GridSize.square(9),
      };

  @override
  List<ValueSpec> get values => [
        ValueSpec.custom((context, size) => DotSymbol(size: size), label: 'dot'),
        ValueSpec.custom((context, size) => Icon(Icons.lightbulb_rounded, size: size * 0.72, color: lampColor), label: 'lamp'),
        ValueSpec.custom((context, size) => const SizedBox.shrink(), label: 'wall'),
      ];

  @override
  List<ValueSpec> valuesFor(LampsPuzzle puzzle) => values.sublist(0, 2);

  @override
  bool get showLockIcon => false;
  @override
  double get gapRatio => 0.05;

  @override
  LampsPuzzle generate(GenParams params) => generateLamps(params);

  List<bool> _lamps(ValueGrid s) => [for (final c in s.cells) c.value == lampsLamp];

  static final Map<LampsPuzzle, List<List<int>>> _sightCache = {};
  List<List<int>> _sight(LampsPuzzle p) {
    if (_sightCache.length > 4) _sightCache.clear();
    return _sightCache.putIfAbsent(p, () => lampsSight(p.rows, p.cols, p.walls));
  }

  @override
  bool isComplete(LampsPuzzle puzzle, ValueGrid state) {
    final lit = lampsLit(_sight(puzzle), _lamps(state));
    for (var i = 0; i < lit.length; i++) {
      if (!puzzle.walls[i] && !lit[i]) return false;
    }
    return true;
  }

  @override
  bool isSolved(LampsPuzzle puzzle, ValueGrid state) =>
      lampsConflicts(puzzle, _lamps(state), complete: true).isEmpty;

  @override
  Set<Pos> conflicts(LampsPuzzle puzzle, ValueGrid state) => {
        for (final i in lampsConflicts(puzzle, _lamps(state), complete: isComplete(puzzle, state))) puzzle.size.pos(i),
      };

  @override
  HintResult<ValueGrid>? hint(LampsPuzzle puzzle, ValueGrid state) {
    HintResult<ValueGrid> put(int i, int v) {
      final p = puzzle.size.pos(i);
      return HintResult(state.set(p, state.cells[i].withValue(v)), {p});
    }

    for (var i = 0; i < state.cells.length; i++) {
      final v = state.cells[i].value;
      if (!puzzle.walls[i] && v != null && v != puzzle.solutionAt(i)) return put(i, puzzle.solutionAt(i));
    }
    for (var i = 0; i < state.cells.length; i++) {
      if (puzzle.lamps[i] && state.cells[i].value != lampsLamp) return put(i, lampsLamp);
    }
    return null;
  }

  @override
  Color? cellColorIn(BuildContext context, LampsPuzzle puzzle, ValueGrid state, Pos pos, CellValue cell) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final i = puzzle.size.index(pos);
    if (puzzle.walls[i]) return dark ? const Color(0xFF12151B) : wallColor;
    final sight = _sight(puzzle);
    final lit = state.cells[i].value == lampsLamp || sight[i].any((j) => state.cells[j].value == lampsLamp);
    if (!lit) return null;
    return dark ? Color.lerp(glow, Colors.black, 0.55) : glow;
  }

  @override
  Widget buildValue(BuildContext context, LampsPuzzle puzzle, ValueGrid state, Pos pos, CellValue cell, double size) {
    final i = puzzle.size.index(pos);
    if (!puzzle.walls[i]) return super.buildValue(context, puzzle, state, pos, cell, size);
    final n = puzzle.numbers[i];
    if (n == null) return const SizedBox.shrink();
    return Text(
      '$n',
      style: TextStyle(fontSize: size * 0.52, height: 1, fontWeight: FontWeight.w700, color: Colors.white),
    );
  }

  @override
  Map<String, dynamic> encodePuzzle(LampsPuzzle puzzle) => puzzle.toJson();
  @override
  LampsPuzzle decodePuzzle(Map<String, dynamic> json) => LampsPuzzle.fromJson(json);
}
