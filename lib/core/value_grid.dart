import 'dart:math';

import 'package:flutter/material.dart';

import '../ui/board/cell_grid_board.dart';
import '../ui/board/cell_tile.dart';
import '../ui/input_palette.dart';
import 'game_controller.dart';
import 'grid.dart';
import 'puzzle_type.dart';

/// One cell of a value grid: a value index (or null), pencil marks, given flag.
@immutable
class CellValue {
  const CellValue({this.value, this.marks = const {}, this.given = false});

  final int? value;
  final Set<int> marks;
  final bool given;

  CellValue withValue(int? v) => CellValue(value: v, given: given);

  CellValue toggleMark(int m) {
    final next = {...marks};
    if (!next.remove(m)) next.add(m);
    return CellValue(marks: next, given: given);
  }

  CellValue cleared() => CellValue(given: given);

  Map<String, dynamic> toJson() => {
        if (value != null) 'v': value,
        if (marks.isNotEmpty) 'm': marks.toList()..sort(),
        if (given) 'g': true,
      };

  factory CellValue.fromJson(Map<String, dynamic> j) => CellValue(
        value: j['v'] as int?,
        marks: {...((j['m'] as List?) ?? const []).cast<int>()},
        given: j['g'] as bool? ?? false,
      );
}

/// Immutable player state for grids where each cell holds one value.
@immutable
class ValueGrid {
  const ValueGrid(this.size, this.cells);

  factory ValueGrid.fromGivens(GridSize size, int? Function(int index) givenAt) => ValueGrid(
        size,
        List.generate(size.cellCount, (i) {
          final g = givenAt(i);
          return g == null ? const CellValue() : CellValue(value: g, given: true);
        }, growable: false),
      );

  final GridSize size;
  final List<CellValue> cells;

  CellValue at(Pos p) => cells[size.index(p)];
  int? valueAt(Pos p) => at(p).value;

  ValueGrid set(Pos p, CellValue v) {
    final next = List.of(cells, growable: false);
    next[size.index(p)] = v;
    return ValueGrid(size, next);
  }

  bool get isFull => cells.every((c) => c.value != null);

  /// Values as a flat list with -1 for empty (handy for solvers/rules).
  List<int> toFlat() => [for (final c in cells) c.value ?? -1];

  Map<String, dynamic> toJson() => {'size': size.toJson(), 'cells': [for (final c in cells) c.toJson()]};

  factory ValueGrid.fromJson(Map<String, dynamic> j) => ValueGrid(
        GridSize.fromJson(j['size'] as Map<String, dynamic>),
        [for (final c in j['cells'] as List) CellValue.fromJson(c as Map<String, dynamic>)],
      );
}

/// How a value is displayed (in cells, pencil marks and the palette).
class ValueSpec {
  const ValueSpec.text(this.label, {this.color})
      : icon = null,
        fill = null,
        builder = null;
  const ValueSpec.icon(this.icon, {required this.color, required this.label})
      : fill = null,
        builder = null;
  const ValueSpec.fill(this.fill, {required this.label})
      : icon = null,
        color = null,
        builder = null;
  const ValueSpec.custom(this.builder, {required this.label})
      : icon = null,
        color = null,
        fill = null;

  final String label;
  final IconData? icon;
  final Color? color;
  final Color? fill;
  final Widget Function(BuildContext context, double size)? builder;

  Widget build(BuildContext context, double size) {
    if (builder != null) return builder!(context, size);
    if (fill != null) {
      return Container(
        width: size * 0.78,
        height: size * 0.78,
        decoration: BoxDecoration(color: fill, borderRadius: BorderRadius.circular(size * 0.16)),
      );
    }
    if (icon != null) return Icon(icon, size: size * 0.7, color: color);
    return Text(
      label,
      style: TextStyle(
        fontSize: size * 0.58,
        height: 1,
        fontWeight: FontWeight.w600,
        color: color ?? Theme.of(context).colorScheme.onSurface,
      ),
    );
  }
}

/// Puzzle definitions used with [ValueGridType].
abstract class ValueGridPuzzle {
  GridSize get size;
  int? givenAt(int index);
  int solutionAt(int index);
}

/// Base for every "put a value in each cell" puzzle. Provides the board,
/// cycle/palette input, pencil marks, palette, hints and (de)serialization of
/// the state. Subclasses supply rules, generation and visuals.
abstract class ValueGridType<P extends ValueGridPuzzle> extends PuzzleType<P, ValueGrid> {
  const ValueGridType();

  List<ValueSpec> get values;

  /// Values available for a given puzzle (e.g. 1..4 for a 4×4 Sudoku).
  List<ValueSpec> valuesFor(P puzzle) => values;

  /// Order used by tap-to-cycle mode.
  List<int?> cycleOrder(P puzzle) => [null, for (var i = 0; i < valuesFor(puzzle).length; i++) i];

  bool get showLockIcon => true;

  bool get supportsPencil => false;

  @override
  bool get supportsModeSwitch => true;

  @override
  ValueGrid initialState(P puzzle) => ValueGrid.fromGivens(puzzle.size, puzzle.givenAt);

  @override
  bool isComplete(P puzzle, ValueGrid state) => state.isFull;

  @override
  HintResult<ValueGrid>? hint(P puzzle, ValueGrid state) {
    final wrong = <int>[];
    final empty = <int>[];
    for (var i = 0; i < state.cells.length; i++) {
      final v = state.cells[i].value;
      if (v == null) {
        empty.add(i);
      } else if (v != puzzle.solutionAt(i)) {
        wrong.add(i);
      }
    }
    final pool = wrong.isNotEmpty ? wrong : empty;
    if (pool.isEmpty) return null;
    final i = pool[Random().nextInt(pool.length)];
    final pos = puzzle.size.pos(i);
    return HintResult(state.set(pos, state.cells[i].withValue(puzzle.solutionAt(i))), {pos});
  }

  @override
  Map<String, dynamic> encodeState(ValueGrid state) => state.toJson();

  @override
  ValueGrid decodeState(Map<String, dynamic> json) => ValueGrid.fromJson(json);

  // ---- visuals / layout (override to customize) ----

  /// Content of a cell holding a value.
  Widget buildValue(BuildContext context, P puzzle, ValueGrid state, Pos pos, CellValue cell, double size) =>
      values[cell.value!].build(context, size);

  Color? cellColor(BuildContext context, P puzzle, Pos pos, CellValue cell) => null;

  /// Decorations drawn above the cells (edge clues, region borders...).
  List<Widget> buildOverlay(BuildContext context, P puzzle, BoardMetrics m) => const [];

  /// Decorations drawn below the cells.
  List<Widget> buildUnderlay(BuildContext context, P puzzle, BoardMetrics m) => const [];

  double get gapRatio => 0.08;

  /// Section size (e.g. Sudoku boxes) as (rows, cols); (0, 0) for none.
  (int, int) sections(P puzzle) => (0, 0);

  /// Cells whose pencil mark for a value is removed when that value is placed.
  Iterable<Pos> markPeers(P puzzle, Pos pos) => const [];

  /// Emphasize cells holding the selected cell's / latched tool's value.
  bool get highlightSameValue => false;

  /// Faintly tint [markPeers] of the selected cell (row/column/box).
  bool get highlightPeers => false;

  Widget buildMarks(BuildContext context, Set<int> marks, double size) {
    final n = values.length;
    final per = n <= 4 ? 2 : 3;
    final s = size / per;
    return SizedBox(
      width: size,
      height: size,
      child: Stack(children: [
        for (final m in marks)
          Positioned(
            left: (m % per) * s,
            top: (m ~/ per) * s,
            width: s,
            height: s,
            child: Center(child: FittedBox(child: Opacity(opacity: 0.85, child: values[m].build(context, s * 1.3)))),
          ),
      ]),
    );
  }

  @override
  Widget buildBoard(BuildContext context, GameController controller) {
    final ctrl = controller;
    final p = ctrl.puzzle as P;
    final s = ctrl.state as ValueGrid;
    final errors = ctrl.errorCells;
    final (secR, secC) = sections(p);
    int? focus;
    if (highlightSameValue && !ctrl.solved) {
      if (ctrl.tool != null && ctrl.tool! >= 0) {
        focus = ctrl.tool;
      } else if (ctrl.selectedCell != null) {
        focus = s.valueAt(ctrl.selectedCell!);
      }
    }
    final peers = highlightPeers && ctrl.selectedCell != null && !ctrl.solved
        ? markPeers(p, ctrl.selectedCell!).toSet()
        : const <Pos>{};
    return CellGridBoard(
      rows: p.size.rows,
      cols: p.size.cols,
      gapRatio: gapRatio,
      sectionRows: secR,
      sectionCols: secC,
      win: ctrl.winAnimation,
      onTap: ctrl.solved ? null : (pos) => onCellTap(ctrl, pos),
      onSecondary: ctrl.solved ? null : (pos) => onCellSecondary(ctrl, pos),
      overlayBuilder: (context, m) => buildOverlay(context, p, m),
      underlayBuilder: (context, m) => buildUnderlay(context, p, m),
      cellBuilder: (context, pos, m) {
        final cell = s.at(pos);
        final Widget content;
        if (cell.value != null) {
          content = KeyedSubtree(key: ValueKey('v${cell.value}'), child: buildValue(context, p, s, pos, cell, m.cell));
        } else if (cell.marks.isNotEmpty) {
          content = KeyedSubtree(key: const ValueKey('marks'), child: buildMarks(context, cell.marks, m.cell * 0.92));
        } else {
          content = const SizedBox.shrink(key: ValueKey('empty'));
        }
        return CellTile(
          size: m.cell,
          content: content,
          color: cellColor(context, p, pos, cell),
          given: cell.given,
          showLock: showLockIcon,
          selected: ctrl.selectedCell == pos,
          emphasis: focus != null && (cell.value == focus || (cell.value == null && cell.marks.contains(focus))),
          peer: peers.contains(pos),
          error: errors.contains(pos),
          hinted: ctrl.flashHints.contains(pos),
        );
      },
    );
  }


  @override
  Widget? buildControls(BuildContext context, GameController controller) {
    if (controller.inputMode != InputMode.palette) return null;
    return InputPalette(
      values: valuesFor(controller.puzzle as P),
      supportsPencil: supportsPencil,
      controller: controller,
      onTool: (t) => onPaletteTap(controller, t),
    );
  }

  // ---- input ----

  void onCellTap(GameController ctrl, Pos pos) {
    final s = ctrl.state as ValueGrid;
    final cell = s.at(pos);
    if (cell.given) {
      ctrl.select(ctrl.inputMode == InputMode.palette && ctrl.selectedCell != pos ? pos : null);
      return;
    }
    if (ctrl.inputMode == InputMode.cycle) {
      final order = cycleOrder(ctrl.puzzle as P);
      final i = order.indexOf(cell.value);
      ctrl.apply(s.set(pos, cell.withValue(order[(i + 1) % order.length])));
      return;
    }
    final tool = ctrl.tool;
    if (tool == null) {
      ctrl.select(ctrl.selectedCell == pos ? null : pos);
      return;
    }
    applyTool(ctrl, pos, tool);
  }

  void onCellSecondary(GameController ctrl, Pos pos) {
    final s = ctrl.state as ValueGrid;
    final cell = s.at(pos);
    if (cell.given) return;
    if (ctrl.inputMode == InputMode.cycle) {
      final order = cycleOrder(ctrl.puzzle as P);
      final i = order.indexOf(cell.value);
      ctrl.apply(s.set(pos, cell.withValue(order[(i - 1 + order.length) % order.length])));
    } else {
      ctrl.apply(s.set(pos, cell.cleared()));
    }
  }

  /// Cell-first flow: a selected cell and no latched tool → apply once.
  /// Otherwise latch/unlatch the tool for stamping.
  void onPaletteTap(GameController ctrl, int tool) {
    final sel = ctrl.selectedCell;
    if (sel != null && ctrl.tool == null) {
      applyTool(ctrl, sel, tool);
      return;
    }
    ctrl.setTool(ctrl.tool == tool ? null : tool);
  }

  void applyTool(GameController ctrl, Pos pos, int tool) {
    var s = ctrl.state as ValueGrid;
    final cell = s.at(pos);
    if (cell.given) return;
    if (tool == GameController.eraser) {
      s = s.set(pos, cell.cleared());
    } else if (ctrl.pencil && supportsPencil) {
      s = s.set(pos, (cell.value == null ? cell : cell.cleared()).toggleMark(tool));
    } else if (cell.value == tool) {
      s = s.set(pos, cell.cleared());
    } else {
      s = s.set(pos, cell.withValue(tool));
      final p = ctrl.puzzle as P;
      for (final q in ctrl.settings.autoClearMarks ? markPeers(p, pos) : const <Pos>[]) {
        final c = s.at(q);
        if (c.value == null && c.marks.contains(tool)) s = s.set(q, c.toggleMark(tool));
      }
    }
    ctrl.apply(s);
  }
}
