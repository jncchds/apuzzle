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
import '../sudoku/sudoku_model.dart';
import 'pockets_explain.dart';
import 'pockets_generator.dart';
import 'pockets_model.dart';
import 'pockets_tutorial.dart';

/// A Sudoku cut into dashed pockets; each pocket's digits add up to its sum
/// and never repeat.
class PocketsType extends ValueGridType<PocketsPuzzle> {
  const PocketsType();

  /// Room at the top of a cell for the pocket's sum, as a share of the cell.
  static const _clueBand = 0.34;

  /// How far the dashed outline sits inside the cells, as a share of a cell.
  static const _inset = 0.08;

  @override
  String get id => 'pockets';
  @override
  String name(AppLocalizations l) => l.pocketsName;
  @override
  String tagline(AppLocalizations l) => l.pocketsTagline;
  @override
  IconData get icon => Icons.dashboard_customize_rounded;
  @override
  Color get accent => const Color(0xFF4FA3D9);

  @override
  String rulesText(AppLocalizations l) => l.pocketsRules;

  @override
  List<TutorialStep> tutorial() => pocketsTutorial;
  @override
  List<TutorialStep> strategies() => pocketsStrategies;

  @override
  List<GridSize> get sizes => const [GridSize.square(4), GridSize.square(6), GridSize.square(9)];
  @override
  GridSize get defaultSize => const GridSize.square(9);
  @override
  GridSize dailySize(Difficulty difficulty) =>
      difficulty == Difficulty.easy ? const GridSize.square(6) : const GridSize.square(9);
  @override
  Day get dailySince => const Day(2026, 10, 16);

  @override
  InputMode get defaultInputMode => InputMode.palette;
  @override
  bool get supportsModeSwitch => false;
  @override
  bool get supportsPencil => true;
  @override
  bool get highlightSameValue => true;
  @override
  bool get highlightPeers => true;
  @override
  bool get showLockIcon => false;
  @override
  double get gapRatio => 0.04;

  static final _all = [for (var d = 1; d <= 9; d++) ValueSpec.text('$d')];

  @override
  List<ValueSpec> get values => _all;

  @override
  List<ValueSpec> valuesFor(PocketsPuzzle puzzle) => _all.sublist(0, puzzle.n);

  @override
  (int, int) sections(PocketsPuzzle puzzle) => sudokuBox(puzzle.n);

  @override
  Iterable<Pos> markPeers(PocketsPuzzle puzzle, Pos pos) {
    final i = puzzle.size.index(pos);
    return {
      ...SudokuGeometry.of(puzzle.n).peers[i],
      for (final j in puzzle.pockets[puzzle.pocketOf[i]].cells)
        if (j != i) j,
    }.map(puzzle.size.pos);
  }

  @override
  Widget buildValue(BuildContext context, PocketsPuzzle puzzle, ValueGrid state, Pos pos, CellValue cell, double size) {
    final scheme = Theme.of(context).colorScheme;
    final dark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: EdgeInsets.only(top: size * 0.18),
      child: Text(
        '${cell.value! + 1}',
        style: TextStyle(
          fontSize: size * 0.46,
          height: 1,
          fontWeight: cell.given ? FontWeight.w800 : FontWeight.w500,
          color: cell.given ? scheme.onSurface : (dark ? const Color(0xFF7CB6FF) : const Color(0xFF1F63D6)),
        ),
      ),
    );
  }

  /// Notes in three columns below the sum band.
  @override
  Widget buildMarks(BuildContext context, Set<int> marks, double size) {
    final top = size * (_clueBand + 0.02);
    final side = size * _inset;
    final w = (size - 2 * side) / 3, h = (size - top - side) / 3;
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        children: [
          for (final m in marks)
            Positioned(
              left: side + (m % 3) * w,
              top: top + (m ~/ 3) * h,
              width: w,
              height: h,
              child: Center(
                child: FittedBox(child: Opacity(opacity: 0.85, child: values[m].build(context, h * 1.3))),
              ),
            ),
        ],
      ),
    );
  }

  @override
  PocketsPuzzle generate(GenParams params) => generatePockets(params);

  @override
  bool isSolved(PocketsPuzzle puzzle, ValueGrid state) =>
      state.isFull && pocketsConflicts(puzzle, state.toFlat()).isEmpty;

  @override
  Set<Pos> conflicts(PocketsPuzzle puzzle, ValueGrid state) => {
    for (final i in pocketsConflicts(puzzle, state.toFlat())) puzzle.size.pos(i),
  };

  @override
  List<Widget> buildOverlayIn(BuildContext context, PocketsPuzzle puzzle, ValueGrid state, BoardMetrics m) {
    final theme = Theme.of(context);
    final on = theme.colorScheme.onSurface;
    final g = state.toFlat();
    final font = m.cell * 0.3;
    Widget label(Pocket pocket) {
      final done = pocketDone(pocket, g);
      final at = puzzle.size.pos(pocket.cells.first);
      return Positioned(
        left: m.x(at.c) + m.cell * 0.04,
        top: m.y(at.r) + m.cell * 0.02,
        width: m.cell * 0.6,
        height: font * 1.1,
        child: IgnorePointer(
          child: Align(
            alignment: Alignment.topLeft,
            child: FittedBox(
              child: AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 200),
                style: theme.textTheme.bodySmall!.copyWith(
                  fontSize: font,
                  height: 1,
                  fontWeight: FontWeight.w700,
                  color: on.withValues(alpha: done ? 0.35 : 0.9),
                ),
                child: Text('${pocket.sum}'),
              ),
            ),
          ),
        ),
      );
    }

    return [
      Positioned.fill(
        child: IgnorePointer(
          child: CustomPaint(painter: _PocketsPainter(m, puzzle, on.withValues(alpha: 0.55), _inset, font)),
        ),
      ),
      for (final pocket in puzzle.pockets) label(pocket),
    ];
  }

  @override
  bool get canExplain => true;

  @override
  Explanation? explain(PocketsPuzzle puzzle, ValueGrid state) => explainStep(const PocketsExplainer(), puzzle, state);

  @override
  Map<String, dynamic> encodePuzzle(PocketsPuzzle puzzle) => puzzle.toJson();
  @override
  PocketsPuzzle decodePuzzle(Map<String, dynamic> json) => PocketsPuzzle.fromJson(json);
}

/// Dashed outlines just inside every pocket, broken where the sum sits.
class _PocketsPainter extends CustomPainter {
  _PocketsPainter(this.m, this.p, this.color, this.inset, this.font);

  final BoardMetrics m;
  final PocketsPuzzle p;
  final Color color;
  final double inset;
  final double font;

  @override
  void paint(Canvas canvas, Size size) {
    final n = p.n;
    final d = m.cell * inset;
    final paint = Paint()
      ..color = color
      ..strokeWidth = (m.cell * 0.03).clamp(1.0, 2.0)
      ..style = PaintingStyle.stroke;
    final dash = m.cell * 0.09, space = m.cell * 0.07;
    bool same(int r, int c, int x) => r >= 0 && r < n && c >= 0 && c < n && p.pocketOf[r * n + c] == x;

    void line(Offset a, Offset b) {
      final length = (b - a).distance;
      if (length <= 0) return;
      final dir = (b - a) / length;
      for (var s = 0.0; s < length; s += dash + space) {
        canvas.drawLine(a + dir * s, a + dir * (s + dash).clamp(0, length), paint);
      }
    }

    // Where a side line ends toward column/row k + step: at the inset corner
    // if the pocket turns there, in the middle of the gap if it goes straight
    // on, or past the gap by the inset round an inner corner.
    double endX(int r, int c, int step, int x, int dr) {
      if (!same(r, c + step, x)) return step > 0 ? m.x(c) + m.cell - d : m.x(c) + d;
      if (same(r + dr, c + step, x)) return step > 0 ? m.x(c + 1) + d : m.x(c - 1) + m.cell - d;
      return step > 0 ? (m.x(c) + m.cell + m.x(c + 1)) / 2 : (m.x(c - 1) + m.cell + m.x(c)) / 2;
    }

    double endY(int r, int c, int step, int x, int dc) {
      if (!same(r + step, c, x)) return step > 0 ? m.y(r) + m.cell - d : m.y(r) + d;
      if (same(r + step, c + dc, x)) return step > 0 ? m.y(r + 1) + d : m.y(r - 1) + m.cell - d;
      return step > 0 ? (m.y(r) + m.cell + m.y(r + 1)) / 2 : (m.y(r - 1) + m.cell + m.y(r)) / 2;
    }

    for (var x = 0; x < p.pockets.length; x++) {
      final first = p.pockets[x].cells.first;
      // Room for the sum in the first cell's top-left corner.
      final digits = '${p.pockets[x].sum}'.length;
      final labelW = m.cell * 0.06 + font * 0.6 * digits, labelH = m.cell * 0.04 + font * 1.05;
      for (final i in p.pockets[x].cells) {
        final r = i ~/ n, c = i % n;
        final top = m.y(r) + d, bottom = m.y(r) + m.cell - d;
        final left = m.x(c) + d, right = m.x(c) + m.cell - d;
        if (!same(r - 1, c, x)) {
          final from = i == first ? m.x(c) + labelW : endX(r, c, -1, x, -1);
          line(Offset(from, top), Offset(endX(r, c, 1, x, -1), top));
        }
        if (!same(r + 1, c, x)) line(Offset(endX(r, c, -1, x, 1), bottom), Offset(endX(r, c, 1, x, 1), bottom));
        if (!same(r, c - 1, x)) {
          final from = i == first ? m.y(r) + labelH : endY(r, c, -1, x, -1);
          line(Offset(left, from), Offset(left, endY(r, c, 1, x, -1)));
        }
        if (!same(r, c + 1, x)) line(Offset(right, endY(r, c, -1, x, 1)), Offset(right, endY(r, c, 1, x, 1)));
      }
    }
  }

  @override
  bool shouldRepaint(_PocketsPainter old) => old.m != m || old.p != p || old.color != color;
}
