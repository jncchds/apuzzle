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
import '../../ui/board/region_borders.dart';
import 'orbits_explain.dart';
import 'orbits_generator.dart';
import 'orbits_model.dart';
import 'orbits_tutorial.dart';

/// Tentai Show: give every star a region that looks the same after half a
/// turn around it.
class OrbitsType extends PuzzleType<OrbitsPuzzle, OrbitsState> {
  const OrbitsType();

  static const colors = [
    Color(0xFF3F8FE0), Color(0xFFF2B233), Color(0xFF4CAF50), Color(0xFFE5534B), //
    Color(0xFF9C6ADE), Color(0xFF2EB8B8), Color(0xFFF08A3C), Color(0xFFE35D9C),
    Color(0xFF9CCC3D), Color(0xFF5C6BC0), Color(0xFF8D6E63), Color(0xFFB0B0B0),
  ];

  static final _colorOf = Expando<List<int>>();

  /// A color per star, different from the stars close by. Only the stars'
  /// places decide, so the colors give nothing away.
  static List<int> colorsOf(OrbitsPuzzle p) => _colorOf[p] ??= () {
    final g = p.geo;
    final out = <int>[];
    for (var k = 0; k < g.count; k++) {
      final near = {
        for (var j = 0; j < k; j++)
          if ((g.ys[j] - g.ys[k]).abs() + (g.xs[j] - g.xs[k]).abs() <= 9) out[j],
      };
      var pick = (k * 5) % colors.length;
      for (var t = 0; t < colors.length && near.contains(pick); t++) {
        pick = (pick + 1) % colors.length;
      }
      out.add(pick);
    }
    return out;
  }();

  @override
  String get id => 'orbits';
  @override
  String name(AppLocalizations l) => l.orbitsName;
  @override
  String tagline(AppLocalizations l) => l.orbitsTagline;
  @override
  IconData get icon => Icons.auto_awesome_rounded;
  @override
  Color get accent => const Color(0xFF7C8CF0);

  @override
  String rulesText(AppLocalizations l) => l.orbitsRules;

  @override
  List<TutorialStep> tutorial() => orbitsTutorial;
  @override
  List<TutorialStep> strategies() => orbitsStrategies;

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
  Day get dailySince => const Day(2026, 10, 14);
  @override
  double get controlsHeight => 40;

  @override
  OrbitsPuzzle generate(GenParams params) => generateOrbits(params);

  @override
  OrbitsState initialState(OrbitsPuzzle puzzle) => OrbitsState(puzzle.geo.initial());

  @override
  bool isComplete(OrbitsPuzzle puzzle, OrbitsState state) => !state.owner.contains(-1);

  @override
  bool isSolved(OrbitsPuzzle puzzle, OrbitsState state) => puzzle.geo.valid(state.owner);

  @override
  Set<Pos> conflicts(OrbitsPuzzle puzzle, OrbitsState state) => {
    for (final i in puzzle.geo.bad(state.owner)) puzzle.size.pos(i),
  };

  /// Clears a wrong cell, or fills in the next unfinished region.
  @override
  HintResult<OrbitsState>? hint(OrbitsPuzzle puzzle, OrbitsState state) {
    final g = puzzle.geo, pos = puzzle.size.pos;
    for (var i = 0; i < g.n; i++) {
      final k = state.owner[i];
      if (k >= 0 && k != puzzle.solution[i]) {
        return HintResult(OrbitsState(g.paint(state.owner, i, -1)!), {pos(i), pos(g.twin(i, k))});
      }
    }
    for (var k = 0; k < g.count; k++) {
      final cells = [
        for (var i = 0; i < g.n; i++)
          if (puzzle.solution[i] == k) i,
      ];
      if (cells.every((i) => state.owner[i] == k)) continue;
      final owner = List.of(state.owner);
      for (final i in cells) {
        owner[i] = k;
      }
      return HintResult(OrbitsState(owner), cells.map(pos).toSet());
    }
    return null;
  }

  @override
  Widget buildBoard(BuildContext context, GameController controller) => _OrbitsBoard(controller: controller);

  @override
  bool get canExplain => true;

  @override
  Explanation? explain(OrbitsPuzzle puzzle, OrbitsState state) => explainStep(const OrbitsExplainer(), puzzle, state);

  @override
  Map<String, dynamic> encodePuzzle(OrbitsPuzzle puzzle) => puzzle.toJson();
  @override
  OrbitsPuzzle decodePuzzle(Map<String, dynamic> json) => OrbitsPuzzle.fromJson(json);
  @override
  Map<String, dynamic> encodeState(OrbitsState state) => state.toJson();
  @override
  OrbitsState decodeState(Map<String, dynamic> json) => OrbitsState.fromJson(json);
}

class _OrbitsBoard extends StatefulWidget {
  const _OrbitsBoard({required this.controller});
  final GameController controller;

  @override
  State<_OrbitsBoard> createState() => _OrbitsBoardState();
}

class _OrbitsBoardState extends State<_OrbitsBoard> {
  /// The star being painted, the board with the drag so far, and its last cell.
  int _active = -1;
  List<int>? _draft;
  Pos? _last;

  GameController get ctrl => widget.controller;
  OrbitsPuzzle get p => ctrl.puzzle as OrbitsPuzzle;
  List<int> get _committed => (ctrl.state as OrbitsState).owner;

  void _start(Pos pos) {
    final k = _committed[p.size.index(pos)];
    if (k < 0) return;
    setState(() {
      _active = k;
      _draft = List.of(_committed);
      _last = pos;
    });
  }

  void _extend(Pos? pos) {
    final from = _last;
    if (_draft == null || pos == null || from == null || pos == from) return;
    // Fast drags can skip cells: walk a straight line one cell at a time.
    if (pos.r == from.r || pos.c == from.c) {
      final dr = (pos.r - from.r).sign, dc = (pos.c - from.c).sign;
      for (var r = from.r + dr, c = from.c + dc; ; r += dr, c += dc) {
        _paint(Pos(r, c));
        if (r == pos.r && c == pos.c) break;
      }
    } else {
      _paint(pos);
    }
    _last = pos;
  }

  void _paint(Pos pos) {
    final next = p.geo.paint(_draft!, p.size.index(pos), _active);
    if (next != null) setState(() => _draft = next);
  }

  void _end() {
    final next = _draft;
    if (next == null) return;
    setState(() {
      _draft = null;
      _last = null;
      _active = -1;
    });
    final cur = _committed;
    for (var i = 0; i < next.length; i++) {
      if (next[i] != cur[i]) {
        ctrl.apply(OrbitsState(next));
        return;
      }
    }
  }

  /// Tap a cell to clear it and its twin.
  void _tap(Pos pos) {
    final next = p.geo.paint(_committed, p.size.index(pos), -1);
    if (next != null) ctrl.apply(OrbitsState(next));
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final owner = _draft ?? _committed;
    final colorOf = OrbitsType.colorsOf(p);
    final errors = ctrl.errorCells;
    return CellGridBoard(
      explain: ExplainView.of(ctrl),
      rows: p.rows,
      cols: p.cols,
      gapRatio: 0.04,
      maxCell: 84,
      win: ctrl.winAnimation,
      onTap: ctrl.solved ? null : _tap,
      onDragStart: ctrl.solved ? null : (pos, _) => _start(pos),
      onDragUpdate: (pos, _) => _extend(pos),
      onDragEnd: _end,
      overlayBuilder: (context, m) => [
        RegionBorders(
          metrics: m,
          split: (a, b) => owner[a] != owner[b],
          color: scheme.onSurface.withValues(alpha: 0.85),
        ),
        Positioned.fill(
          child: CustomPaint(
            painter: _StarsPainter(p.geo, m, scheme.onSurface, scheme.surface),
          ),
        ),
      ],
      cellBuilder: (context, pos, m) {
        final k = owner[p.size.index(pos)];
        final hinted = ctrl.flashHints.contains(pos);
        final wrong = errors.contains(pos);
        return AnimatedContainer(
          duration: const Duration(milliseconds: 140),
          decoration: BoxDecoration(
            color: k >= 0
                ? OrbitsType.colors[colorOf[k]].withValues(alpha: 0.38)
                : scheme.surfaceContainer.withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(m.cell * 0.12),
            border: Border.all(
              color: wrong
                  ? scheme.error
                  : hinted
                  ? scheme.tertiary
                  : scheme.outlineVariant.withValues(alpha: 0.5),
              width: wrong || hinted ? 2.5 : 1,
            ),
          ),
        );
      },
    );
  }
}

/// The stars: four-pointed, on cell centres, sides and corners.
class _StarsPainter extends CustomPainter {
  _StarsPainter(this.g, this.m, this.color, this.rim);

  final OrbitsGeometry g;
  final BoardMetrics m;
  final Color color;
  final Color rim;

  /// A lattice coordinate ([v] odd: the middle of a cell, even: a line) in pixels.
  double _at(int v, double Function(int) start) => v.isOdd ? start(v >> 1) + m.cell / 2 : start(v >> 1) - m.gap / 2;

  @override
  void paint(Canvas canvas, Size size) {
    final big = m.cell * 0.23, small = big * 0.42;
    for (var k = 0; k < g.count; k++) {
      final o = Offset(_at(g.xs[k], m.x), _at(g.ys[k], m.y));
      final star = Path();
      for (var t = 0; t < 8; t++) {
        final r = t.isEven ? big : small, a = t * pi / 4 - pi / 2;
        final q = o + Offset(cos(a), sin(a)) * r;
        t == 0 ? star.moveTo(q.dx, q.dy) : star.lineTo(q.dx, q.dy);
      }
      star.close();
      canvas.drawPath(
        star,
        Paint()
          ..color = rim
          ..style = PaintingStyle.stroke
          ..strokeWidth = m.cell * 0.09
          ..strokeJoin = StrokeJoin.round,
      );
      canvas.drawPath(star, Paint()..color = color);
    }
  }

  @override
  bool shouldRepaint(_StarsPainter old) => true;
}
