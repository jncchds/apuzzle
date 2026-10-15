import 'dart:math';

import 'package:flutter/material.dart';

import '../../core/day.dart';
import '../../core/difficulty.dart';
import '../../core/explain.dart';
import '../../core/grid.dart';
import '../../core/puzzle_type.dart';
import '../../core/tutorial.dart';
import '../../core/value_grid.dart';
import '../../l10n/l10n.dart';
import '../../ui/board/cell_grid_board.dart';
import '../../ui/symbols.dart';
import 'poles_explain.dart';
import 'poles_generator.dart';
import 'poles_model.dart';
import 'poles_tutorial.dart';

/// Poles: charge the dominoes so the + and − counts at the edges come out.
class PolesType extends ValueGridType<PolesPuzzle> {
  const PolesType();

  static const plusLight = Color(0xFFD2453F);
  static const plusDark = Color(0xFFFF8A80);
  static const minusLight = Color(0xFF2F6FC4);
  static const minusDark = Color(0xFF8AB8F8);

  static bool _dark(BuildContext context) => Theme.of(context).brightness == Brightness.dark;
  static Color plusColor(BuildContext context) => _dark(context) ? plusDark : plusLight;
  static Color minusColor(BuildContext context) => _dark(context) ? minusDark : minusLight;

  @override
  String get id => 'poles';
  @override
  String name(AppLocalizations l) => l.polesName;
  @override
  String tagline(AppLocalizations l) => l.polesTagline;
  @override
  IconData get icon => Icons.battery_charging_full_rounded;
  @override
  Color get accent => const Color(0xFFE0645C);

  @override
  String rulesText(AppLocalizations l) => l.polesRules;

  @override
  List<TutorialStep> tutorial() => polesTutorial;
  @override
  List<TutorialStep> strategies() => polesStrategies;

  @override
  List<GridSize> get sizes => const [
    GridSize.square(6),
    GridSize(7, 6),
    GridSize.square(8),
    GridSize(9, 8),
    GridSize.square(10),
  ];
  @override
  GridSize get defaultSize => const GridSize.square(8);
  @override
  GridSize dailySize(Difficulty difficulty) => switch (difficulty) {
    Difficulty.easy => const GridSize.square(6),
    Difficulty.medium => const GridSize.square(8),
    _ => const GridSize(9, 8),
  };
  @override
  Day get dailySince => const Day(2026, 10, 16);
  @override
  double get minCellSize => 32;

  static Widget _pole(BuildContext context, double size, int v) {
    final color = v == polePlus ? plusColor(context) : minusColor(context);
    return Icon(v == polePlus ? Icons.add_rounded : Icons.remove_rounded, size: size * 0.78, color: color);
  }

  @override
  List<ValueSpec> get values => [
    ValueSpec.custom((context, size) => _pole(context, size, polePlus), label: 'plus'),
    ValueSpec.custom((context, size) => _pole(context, size, poleMinus), label: 'minus'),
    ValueSpec.custom((context, size) => DotSymbol(size: size), label: 'blank'),
  ];

  @override
  bool get showLockIcon => false;
  @override
  double get gapRatio => 0.16;

  @override
  PolesPuzzle generate(GenParams params) => generatePoles(params);

  @override
  Color? cellColor(BuildContext context, PolesPuzzle puzzle, Pos pos, CellValue cell) {
    if (cell.value == null || cell.value == poleBlank) return null;
    final surface = Theme.of(context).colorScheme.surfaceContainerHighest;
    final tint = cell.value == polePlus ? plusColor(context) : minusColor(context);
    return Color.lerp(surface, tint, _dark(context) ? 0.22 : 0.16);
  }

  List<int> _values(ValueGrid s) => [for (final c in s.cells) c.value ?? -1];

  @override
  bool isComplete(PolesPuzzle puzzle, ValueGrid state) {
    var plus = 0, minus = 0, wantPlus = 0, wantMinus = 0;
    for (var i = 0; i < state.cells.length; i++) {
      final v = state.cells[i].value;
      if (v == polePlus) plus++;
      if (v == poleMinus) minus++;
      if (puzzle.solution[i] == polePlus) wantPlus++;
      if (puzzle.solution[i] == poleMinus) wantMinus++;
    }
    return plus == wantPlus && minus == wantMinus;
  }

  @override
  bool isSolved(PolesPuzzle puzzle, ValueGrid state) =>
      isComplete(puzzle, state) && polesConflicts(puzzle, _values(state), complete: true).isEmpty;

  @override
  Set<Pos> conflicts(PolesPuzzle puzzle, ValueGrid state) => {
    for (final i in polesConflicts(puzzle, _values(state), complete: isComplete(puzzle, state))) puzzle.size.pos(i),
  };

  /// Fixes a wrong entry, else puts a missing + or −: blanks are optional.
  @override
  HintResult<ValueGrid>? hint(PolesPuzzle puzzle, ValueGrid state) {
    final wrong = <int>[], missing = <int>[];
    for (var i = 0; i < state.cells.length; i++) {
      final v = state.cells[i].value;
      if (v != null && v != puzzle.solution[i]) wrong.add(i);
      if (v == null && puzzle.solution[i] != poleBlank) missing.add(i);
    }
    final pool = wrong.isNotEmpty ? wrong : missing;
    if (pool.isEmpty) return null;
    final i = pool[Random().nextInt(pool.length)];
    final pos = puzzle.size.pos(i);
    return HintResult(state.set(pos, state.cells[i].withValue(puzzle.solution[i])), {pos});
  }

  /// The other ends of placed dominoes (− across from +, blank across from
  /// blank), and blanks in lines that have all their + and − cells.
  @override
  ValueGrid markForbidden(PolesPuzzle puzzle, ValueGrid state) {
    var s = state;
    for (var i = 0; i < s.cells.length; i++) {
      final v = state.cells[i].value, j = puzzle.mate[i];
      if (v == null || s.cells[j].value != null || s.cells[j].given) continue;
      s = s.set(puzzle.size.pos(j), s.cells[j].withValue(poleOpposite(v)));
    }
    final values = _values(s);
    final lines = polesLines(puzzle.rows, puzzle.cols);
    final blank = <int>[];
    for (var li = 0; li < lines.length; li++) {
      final a = puzzle.plus[li], b = puzzle.minus[li];
      if (a == null || b == null) continue;
      final cells = lines[li];
      if (cells.where((i) => values[i] == polePlus).length == a &&
          cells.where((i) => values[i] == poleMinus).length == b) {
        blank.addAll(cells);
      }
    }
    return dotted(s, blank, poleBlank);
  }

  /// Each domino sits on a tray that joins its two cells.
  @override
  List<Widget> buildUnderlay(BuildContext context, PolesPuzzle puzzle, BoardMetrics m) {
    final color = Theme.of(context).colorScheme.onSurface.withValues(alpha: _dark(context) ? 0.2 : 0.14);
    final size = puzzle.size;
    return [
      for (var i = 0; i < puzzle.mate.length; i++)
        if (puzzle.mate[i] > i)
          Positioned.fromRect(
            rect: m.rectOf(size.pos(i)).expandToInclude(m.rectOf(size.pos(puzzle.mate[i]))).inflate(m.gap * 0.32),
            child: DecoratedBox(
              decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(m.cell * 0.24)),
            ),
          ),
    ];
  }

  @override
  (double, double) header(PolesPuzzle puzzle) => (0.72, 0.72);
  @override
  (double, double) footer(PolesPuzzle puzzle) => (0.72, 0.72);

  @override
  List<Widget> buildOverlayIn(BuildContext context, PolesPuzzle puzzle, ValueGrid state, BoardMetrics m) {
    final theme = Theme.of(context);
    final values = _values(state);
    final lines = polesLines(puzzle.rows, puzzle.cols);
    Widget label(Rect r, int? want, int sign, int line) {
      final have = lines[line].where((i) => values[i] == sign).length;
      final done = want != null && have == want;
      final color = sign == polePlus ? plusColor(context) : minusColor(context);
      return Positioned.fromRect(
        rect: r,
        child: Center(
          child: AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 200),
            style: theme.textTheme.bodyLarge!.copyWith(
              fontSize: m.cell * 0.4,
              fontWeight: FontWeight.w700,
              color: color.withValues(alpha: done ? 0.3 : 0.95),
            ),
            child: Text(want == null ? '' : '$want'),
          ),
        ),
      );
    }

    final rows = puzzle.rows, cols = puzzle.cols;
    final right = m.width + m.gap, below = m.height + m.gap;
    Widget corner(Rect r, int sign) => Positioned.fromRect(
      rect: r,
      child: Center(child: _pole(context, r.shortestSide, sign)),
    );
    return [
      for (var r = 0; r < rows; r++) ...[
        label(Rect.fromLTWH(0, m.y(r), m.ox - m.gap, m.cell), puzzle.plus[r], polePlus, r),
        label(Rect.fromLTWH(right, m.y(r), m.ex - m.gap, m.cell), puzzle.minus[r], poleMinus, r),
      ],
      for (var c = 0; c < cols; c++) ...[
        label(Rect.fromLTWH(m.x(c), 0, m.cell, m.oy - m.gap), puzzle.plus[rows + c], polePlus, rows + c),
        label(Rect.fromLTWH(m.x(c), below, m.cell, m.ey - m.gap), puzzle.minus[rows + c], poleMinus, rows + c),
      ],
      corner(Rect.fromLTWH(0, 0, m.ox - m.gap, m.oy - m.gap), polePlus),
      corner(Rect.fromLTWH(right, below, m.ex - m.gap, m.ey - m.gap), poleMinus),
    ];
  }

  @override
  bool get canExplain => true;

  @override
  Explanation? explain(PolesPuzzle puzzle, ValueGrid state) => explainStep(const PolesExplainer(), puzzle, state);

  @override
  Map<String, dynamic> encodePuzzle(PolesPuzzle puzzle) => puzzle.toJson();
  @override
  PolesPuzzle decodePuzzle(Map<String, dynamic> json) => PolesPuzzle.fromJson(json);
}
