import 'dart:math';

import 'package:flutter/material.dart';

import '../../core/day.dart';
import '../../core/difficulty.dart';
import '../../core/explain.dart';
import '../../core/game_controller.dart';
import '../../core/grid.dart';
import '../../core/puzzle_type.dart';
import '../../core/tutorial.dart';
import '../../l10n/l10n.dart';
import '../../ui/board/cell_grid_board.dart';
import '../../ui/board/explain_overlay.dart';
import 'waymarks_explain.dart';
import 'waymarks_generator.dart';
import 'waymarks_model.dart';
import 'waymarks_tutorial.dart';

/// Waymarks: link every cell to the one its arrow points at, 1 to the end.
class WaymarksType extends PuzzleType<WaymarksPuzzle, WaymarksState> {
  const WaymarksType();

  /// Colors of chains that don't reach a shown number yet (by letter).
  static const chainColors = [
    Color(0xFFE5534B), Color(0xFF3F8FE0), Color(0xFF4CAF50), Color(0xFFF2B233), //
    Color(0xFF9C6ADE), Color(0xFFF08A3C), Color(0xFF2EB8B8), Color(0xFFE35D9C),
  ];

  @override
  String get id => 'waymarks';
  @override
  String name(AppLocalizations l) => l.waymarksName;
  @override
  String tagline(AppLocalizations l) => l.waymarksTagline;
  @override
  IconData get icon => Icons.signpost_rounded;
  @override
  Color get accent => const Color(0xFF3FA796);

  @override
  String rulesText(AppLocalizations l) => l.waymarksRules;

  @override
  List<TutorialStep> tutorial() => waymarksTutorial;
  @override
  List<TutorialStep> strategies() => waymarksStrategies;

  @override
  List<GridSize> get sizes => [for (var n = 5; n <= 9; n++) GridSize.square(n)];
  @override
  GridSize get defaultSize => const GridSize.square(6);
  @override
  GridSize dailySize(Difficulty difficulty) => switch (difficulty) {
    Difficulty.easy => const GridSize.square(5),
    Difficulty.medium => const GridSize.square(6),
    _ => const GridSize.square(7),
  };
  @override
  Day get dailySince => const Day(2026, 10, 16);
  @override
  double get minCellSize => 36;
  @override
  double get controlsHeight => 40;

  @override
  WaymarksPuzzle generate(GenParams params) => generateWaymarks(params);

  @override
  WaymarksState initialState(WaymarksPuzzle puzzle) => WaymarksState(List.filled(puzzle.cells, -1));

  @override
  bool isComplete(WaymarksPuzzle puzzle, WaymarksState state) => waymarksComplete(puzzle, state);

  @override
  bool isSolved(WaymarksPuzzle puzzle, WaymarksState state) => waymarksSolved(puzzle, state);

  @override
  Set<Pos> conflicts(WaymarksPuzzle puzzle, WaymarksState state) => {
    for (final i in waymarksConflicts(puzzle, state)) puzzle.size.pos(i),
  };

  /// The explained step (it fixes a wrong link first).
  @override
  HintResult<WaymarksState>? hint(WaymarksPuzzle puzzle, WaymarksState state) {
    final e = explain(puzzle, state);
    final next = e?.next;
    if (e == null || next is! WaymarksState) return null;
    return HintResult(next, e.targets);
  }

  @override
  bool get canExplain => true;

  @override
  Explanation? explain(WaymarksPuzzle puzzle, WaymarksState state) =>
      explainStep(const WaymarksExplainer(), puzzle, state);

  @override
  Widget buildBoard(BuildContext context, GameController controller) => _WaymarksBoard(controller: controller);

  @override
  Map<String, dynamic> encodePuzzle(WaymarksPuzzle puzzle) => puzzle.toJson();
  @override
  WaymarksPuzzle decodePuzzle(Map<String, dynamic> json) => WaymarksPuzzle.fromJson(json);
  @override
  Map<String, dynamic> encodeState(WaymarksState state) => state.toJson();
  @override
  WaymarksState decodeState(Map<String, dynamic> json) => WaymarksState.fromJson(json);
}

class _WaymarksBoard extends StatefulWidget {
  const _WaymarksBoard({required this.controller});
  final GameController controller;

  @override
  State<_WaymarksBoard> createState() => _WaymarksBoardState();
}

class _WaymarksBoardState extends State<_WaymarksBoard> {
  /// The cell picked by a tap (the next tap links it), or -1.
  int _picked = -1;

  /// A drag: its first cell and where the finger is.
  int _dragFrom = -1;
  Offset? _finger;
  Pos? _fingerCell;

  GameController get ctrl => widget.controller;
  WaymarksPuzzle get p => ctrl.puzzle as WaymarksPuzzle;
  WaymarksState get s => ctrl.state as WaymarksState;

  /// Links [a] and [b] whichever way an arrow allows; false if neither does.
  bool _link(int a, int b) {
    final next = waymarksLink(p, s, a, b) ?? waymarksLink(p, s, b, a);
    if (next == null) return p.points(a, b) && s.next[a] == b || p.points(b, a) && s.next[b] == a;
    ctrl.apply(next);
    return true;
  }

  void _tap(Pos pos) {
    final i = p.size.index(pos);
    if (_picked < 0) {
      setState(() => _picked = i);
    } else if (_picked == i) {
      // A second tap cuts the link on (or, without one, the link in).
      if (s.next[i] >= 0) {
        ctrl.apply(WaymarksState(List.of(s.next)..[i] = -1));
      } else if (s.next.contains(i)) {
        ctrl.apply(waymarksCut(s, i));
      }
      setState(() => _picked = -1);
    } else {
      final linked = _link(_picked, i);
      setState(() => _picked = linked ? -1 : i);
    }
  }

  void _cut(Pos pos) {
    final i = p.size.index(pos);
    final next = waymarksCut(s, i);
    setState(() => _picked = -1);
    if (next.links != s.links) ctrl.apply(next);
  }

  void _dragStart(Pos pos, Offset local) => setState(() {
    _dragFrom = p.size.index(pos);
    _finger = local;
    _fingerCell = pos;
    _picked = -1;
  });

  void _dragUpdate(Pos? pos, Offset local) {
    if (_dragFrom < 0) return;
    setState(() {
      _finger = local;
      if (pos != null) _fingerCell = pos;
    });
  }

  void _dragEnd() {
    final a = _dragFrom, end = _fingerCell;
    setState(() {
      _dragFrom = -1;
      _finger = null;
      _fingerCell = null;
    });
    if (a < 0 || end == null) return;
    final b = p.size.index(end);
    if (b != a) _link(a, b);
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final chains = waymarksChains(p, s);
    // Per cell: its chain's color index (-1 anchored, -2 alone) and label.
    final tint = List<int>.filled(p.cells, -2);
    final label = List<String>.filled(p.cells, '');
    var letter = 0;
    for (final ch in chains) {
      final start = ch.start;
      if (start != null) {
        for (var k = 0; k < ch.cells.length; k++) {
          tint[ch.cells[k]] = ch.cells.length > 1 ? -1 : -2;
          label[ch.cells[k]] = '${start + k}';
        }
      } else if (ch.cells.length > 1) {
        final name = String.fromCharCode(0x61 + letter % 26);
        for (var k = 0; k < ch.cells.length; k++) {
          tint[ch.cells[k]] = letter;
          label[ch.cells[k]] = k == 0 ? name : '$name+$k';
        }
        letter++;
      }
    }
    final errors = ctrl.errorCells;
    final active = ctrl.solved ? -1 : (_dragFrom >= 0 ? _dragFrom : _picked);
    final aims = active >= 0 ? {...p.targets[active], ...p.sources[active]} : const <int>{};
    return CellGridBoard(
      explain: ExplainView.of(ctrl),
      rows: p.n,
      cols: p.n,
      gapRatio: 0.06,
      maxCell: 84,
      win: ctrl.winAnimation,
      onTap: ctrl.solved ? null : _tap,
      onSecondary: ctrl.solved ? null : _cut,
      onDragStart: ctrl.solved ? null : _dragStart,
      onDragUpdate: _dragUpdate,
      onDragEnd: _dragEnd,
      overlayBuilder: (context, m) => [
        Positioned.fill(
          child: CustomPaint(
            painter: _WaymarksPainter(
              p: p,
              next: s.next,
              m: m,
              tint: tint,
              label: label,
              active: active,
              aims: aims,
              from: _dragFrom,
              finger: _finger,
              scheme: scheme,
              style: Theme.of(context).textTheme.bodyMedium!,
            ),
          ),
        ),
      ],
      cellBuilder: (context, pos, m) {
        final i = p.size.index(pos);
        final hinted = ctrl.flashHints.contains(pos);
        final t = tint[i];
        final color = t >= 0
            ? WaymarksType.chainColors[t % WaymarksType.chainColors.length].withValues(alpha: 0.2)
            : t == -1
            ? scheme.primary.withValues(alpha: 0.14)
            : scheme.surfaceContainer.withValues(alpha: 0.6);
        return Container(
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(m.cell * 0.12),
            border: Border.all(
              color: errors.contains(pos)
                  ? scheme.error
                  : hinted || i == active
                  ? scheme.tertiary
                  : scheme.outlineVariant.withValues(alpha: 0.5),
              width: errors.contains(pos) || hinted || i == active ? 2.5 : 1,
            ),
          ),
        );
      },
    );
  }
}

class _WaymarksPainter extends CustomPainter {
  _WaymarksPainter({
    required this.p,
    required this.next,
    required this.m,
    required this.tint,
    required this.label,
    required this.active,
    required this.aims,
    required this.from,
    required this.finger,
    required this.scheme,
    required this.style,
  });

  final WaymarksPuzzle p;
  final List<int> next;
  final BoardMetrics m;
  final List<int> tint;
  final List<String> label;
  final int active;
  final Set<int> aims;
  final int from;
  final Offset? finger;
  final ColorScheme scheme;
  final TextStyle style;

  Offset _at(int i) => m.center(p.size.pos(i));

  Color _chainColor(int i) =>
      tint[i] >= 0 ? WaymarksType.chainColors[tint[i] % WaymarksType.chainColors.length] : scheme.primary;

  @override
  void paint(Canvas canvas, Size size) {
    final cell = m.cell;
    // Links of chains with letters: a thin line from cell to cell (numbers
    // already tell the order of the others).
    for (var i = 0; i < p.cells; i++) {
      final j = next[i];
      if (j < 0 || tint[i] < 0) continue;
      final color = _chainColor(i).withValues(alpha: 0.45);
      final a = _at(i), b = _at(j);
      final d = (b - a) / (b - a).distance;
      canvas.drawLine(
        a + d * cell * 0.3,
        b - d * cell * 0.3,
        Paint()
          ..color = color
          ..strokeWidth = max(1.5, cell * 0.05)
          ..strokeCap = StrokeCap.round,
      );
    }
    // Where the picked cell can link: dots.
    for (final j in aims) {
      canvas.drawCircle(
        m.topLeft(p.size.pos(j)) + Offset(cell * 0.5, cell * 0.86),
        cell * 0.05,
        Paint()..color = scheme.tertiary,
      );
    }
    for (var i = 0; i < p.cells; i++) {
      final c = _at(i);
      final d = p.dir[i];
      final given = p.given[i] > 0;
      if (d >= 0) {
        _arrow(canvas, c, d, next[i] >= 0 ? scheme.onSurfaceVariant.withValues(alpha: 0.35) : scheme.onSurface);
      } else {
        // The last cell: a ring round its number.
        canvas.drawCircle(
          c,
          cell * 0.3,
          Paint()
            ..color = scheme.onSurface.withValues(alpha: 0.6)
            ..style = PaintingStyle.stroke
            ..strokeWidth = max(1.2, cell * 0.035),
        );
      }
      final text = label[i];
      if (text.isEmpty) continue;
      final isNumber = !text.contains(RegExp('[a-z]'));
      final color = given ? scheme.onSurface : _chainColor(i);
      final fontSize = cell * (text.length <= 2 ? 0.34 : (text.length == 3 ? 0.25 : 0.21));
      final tp = TextPainter(
        text: TextSpan(
          text: text,
          style: style.copyWith(
            fontSize: fontSize,
            fontWeight: given ? FontWeight.w800 : (isNumber ? FontWeight.w600 : FontWeight.w500),
            fontStyle: isNumber ? FontStyle.normal : FontStyle.italic,
            color: color,
            height: 1,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, c - Offset(tp.width / 2, tp.height / 2));
    }
    final f = finger;
    if (from >= 0 && f != null) {
      canvas.drawLine(
        _at(from),
        f,
        Paint()
          ..color = scheme.tertiary.withValues(alpha: 0.7)
          ..strokeWidth = max(2, cell * 0.07)
          ..strokeCap = StrokeCap.round,
      );
    }
  }

  /// A small arrow near the edge of the cell at [c], pointing along [d].
  void _arrow(Canvas canvas, Offset c, int d, Color color) {
    final (dr, dc) = waymarksDirs[d];
    final dir = Offset(dc.toDouble(), dr.toDouble());
    final unit = dir / dir.distance;
    final side = Offset(-unit.dy, unit.dx);
    final cell = m.cell;
    // Diagonal arrows sit in the corner, straight ones at the edge middle.
    final reach = dr != 0 && dc != 0 ? 0.58 : 0.45;
    final tip = c + unit * cell * reach;
    final len = cell * 0.2, half = cell * 0.12;
    final head = Path()
      ..moveTo(tip.dx, tip.dy)
      ..lineTo((tip - unit * len + side * half).dx, (tip - unit * len + side * half).dy)
      ..lineTo((tip - unit * len - side * half).dx, (tip - unit * len - side * half).dy)
      ..close();
    canvas.drawPath(head, Paint()..color = color);
  }

  @override
  bool shouldRepaint(_WaymarksPainter old) => true;
}
