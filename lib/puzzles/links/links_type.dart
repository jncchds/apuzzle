import 'package:flutter/material.dart';

import '../../core/day.dart';
import '../../core/difficulty.dart';
import '../../core/game_controller.dart';
import '../../core/grid.dart';
import '../../core/puzzle_type.dart';
import '../../core/tutorial.dart';
import '../../l10n/l10n.dart';
import '../../ui/board/cell_grid_board.dart';
import 'links_generator.dart';
import 'links_model.dart';
import 'links_tutorial.dart';

/// Numberlink: join the pairs of dots with paths that fill the grid.
class LinksType extends PuzzleType<LinksPuzzle, LinksState> {
  const LinksType();

  static const colors = [
    Color(0xFFE5534B), Color(0xFF3F8FE0), Color(0xFF4CAF50), Color(0xFFF2B233), //
    Color(0xFF9C6ADE), Color(0xFFF08A3C), Color(0xFF2EB8B8), Color(0xFFE35D9C),
    Color(0xFF8D6E63), Color(0xFF9CCC3D), Color(0xFF5C6BC0), Color(0xFFB0B0B0),
    Color(0xFFC2185B), Color(0xFF00897B), Color(0xFFD4A017), Color(0xFF6D4C9F),
  ];

  static Color colorOf(int pair) => colors[pair % colors.length];

  @override
  String get id => 'links';
  @override
  String name(AppLocalizations l) => l.linksName;
  @override
  String tagline(AppLocalizations l) => l.linksTagline;
  @override
  IconData get icon => Icons.cable_rounded;
  @override
  Color get accent => const Color(0xFFE5534B);

  @override
  String rulesText(AppLocalizations l) => l.linksRules;

  @override
  List<TutorialStep> tutorial() => linksTutorial;
  @override
  List<TutorialStep> strategies() => linksStrategies;

  @override
  List<GridSize> get sizes => [for (var n = 5; n <= 10; n++) GridSize.square(n)];
  @override
  GridSize get defaultSize => const GridSize.square(7);
  @override
  GridSize dailySize(Difficulty difficulty) => switch (difficulty) {
        Difficulty.easy => const GridSize.square(6),
        Difficulty.medium => const GridSize.square(7),
        _ => const GridSize.square(8),
      };
  @override
  Day get dailySince => const Day(2026, 9, 28);
  @override
  double get controlsHeight => 40;

  @override
  LinksPuzzle generate(GenParams params) => generateLinks(params);

  @override
  LinksState initialState(LinksPuzzle puzzle) => LinksState([for (var k = 0; k < puzzle.pairs; k++) const <int>[]]);

  @override
  bool isComplete(LinksPuzzle puzzle, LinksState state) {
    for (var k = 0; k < puzzle.pairs; k++) {
      if (!linksJoined(puzzle, state.paths[k], k)) return false;
    }
    return true;
  }

  @override
  bool isSolved(LinksPuzzle puzzle, LinksState state) => linksValid(puzzle, state.paths);

  /// Once every pair is joined: the cells no path fills.
  @override
  Set<Pos> conflicts(LinksPuzzle puzzle, LinksState state) {
    if (!isComplete(puzzle, state)) return const {};
    final used = {for (final p in state.paths) ...p};
    return {for (var i = 0; i < puzzle.rows * puzzle.cols; i++) if (!used.contains(i)) puzzle.size.pos(i)};
  }

  @override
  HintResult<LinksState>? hint(LinksPuzzle puzzle, LinksState state) {
    bool same(List<int> a, List<int> b) =>
        a.length == b.length && (_eq(a, b) || _eq(a, b.reversed.toList()));
    for (var k = 0; k < puzzle.pairs; k++) {
      final want = puzzle.paths[k];
      if (same(state.paths[k], want)) continue;
      final cells = want.toSet();
      final next = [
        for (var j = 0; j < puzzle.pairs; j++) j == k ? List.of(want) : _cut(state.paths[j], cells),
      ];
      return HintResult(LinksState(next), {for (final i in want) puzzle.size.pos(i)});
    }
    return null;
  }

  static bool _eq(List<int> a, List<int> b) {
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  /// [path] up to (not including) its first cell in [taken].
  static List<int> _cut(List<int> path, Set<int> taken) {
    final at = path.indexWhere(taken.contains);
    return at < 0 ? path : path.sublist(0, at);
  }

  @override
  Widget buildBoard(BuildContext context, GameController controller) => _LinksBoard(controller: controller);

  @override
  Map<String, dynamic> encodePuzzle(LinksPuzzle puzzle) => puzzle.toJson();
  @override
  LinksPuzzle decodePuzzle(Map<String, dynamic> json) => LinksPuzzle.fromJson(json);
  @override
  Map<String, dynamic> encodeState(LinksState state) => state.toJson();
  @override
  LinksState decodeState(Map<String, dynamic> json) => LinksState.fromJson(json);
}

class _LinksBoard extends StatefulWidget {
  const _LinksBoard({required this.controller});
  final GameController controller;

  @override
  State<_LinksBoard> createState() => _LinksBoardState();
}

class _LinksBoardState extends State<_LinksBoard> {
  /// Paths when the drag started, the pair being drawn, and its path so far.
  List<List<int>>? _base;
  int _active = -1;
  List<int>? _draft;

  GameController get ctrl => widget.controller;
  LinksPuzzle get p => ctrl.puzzle as LinksPuzzle;
  List<List<int>> get _committed => (ctrl.state as LinksState).paths;

  /// What to show: the draft, with other paths cut where it crosses them.
  List<List<int>> get _paths {
    final d = _draft, base = _base;
    if (d == null || base == null) return _committed;
    final taken = d.toSet();
    return [for (var k = 0; k < base.length; k++) k == _active ? d : LinksType._cut(base[k], taken)];
  }

  void _start(Pos pos) {
    final i = p.size.index(pos);
    final paths = _committed;
    if (p.dots[i] >= 0) {
      _begin(p.dots[i], [i]);
      return;
    }
    for (var k = 0; k < paths.length; k++) {
      final at = paths[k].indexOf(i);
      if (at >= 0) {
        _begin(k, paths[k].sublist(0, at + 1));
        return;
      }
    }
  }

  void _begin(int k, List<int> draft) => setState(() {
        _base = [for (final path in _committed) List.of(path)];
        _active = k;
        _draft = draft;
      });

  void _extend(Pos? pos) {
    final d = _draft;
    if (d == null || pos == null) return;
    final i = p.size.index(pos);
    final r0 = d.last ~/ p.cols, c0 = d.last % p.cols;
    if (pos.r != r0 && pos.c != c0) {
      _step(d, i);
      return;
    }
    // Fast drags can skip cells: walk the straight line one cell at a time.
    final dr = (pos.r - r0).sign, dc = (pos.c - c0).sign;
    var r = r0, c = c0;
    while (r != pos.r || c != pos.c) {
      r += dr;
      c += dc;
      if (!_step(d, r * p.cols + c)) break;
    }
  }

  /// Moves the draft's end to cell [i]: back over its last cell, back to a
  /// cell it passed, or on to a free neighbour. False if it can't.
  bool _step(List<int> d, int i) {
    if (i == d.last) return true;
    if (d.length >= 2 && i == d[d.length - 2]) {
      setState(d.removeLast);
      return true;
    }
    final at = d.indexOf(i);
    if (at >= 0) {
      setState(() => d.removeRange(at + 1, d.length));
      return true;
    }
    if (!linksAdjacent(d.last, i, p.cols)) return false;
    if (linksJoined(p, d, _active)) return false; // already joined
    final dot = p.dots[i];
    if (dot >= 0 && dot != _active) return false;
    setState(() => d.add(i));
    return true;
  }

  void _end() {
    if (_draft == null) return;
    final next = _paths;
    setState(() {
      _draft = null;
      _base = null;
      _active = -1;
    });
    final cur = _committed;
    for (var k = 0; k < next.length; k++) {
      if (next[k].length != cur[k].length || !LinksType._eq(next[k], cur[k])) {
        ctrl.apply(LinksState(next));
        return;
      }
    }
  }

  /// Tap a dot to clear its path, or a path cell to cut the path there.
  void _tap(Pos pos) {
    final i = p.size.index(pos);
    final paths = _committed;
    for (var k = 0; k < paths.length; k++) {
      final at = paths[k].indexOf(i);
      if (at < 0) continue;
      final keep = p.dots[i] >= 0 ? const <int>[] : paths[k].sublist(0, at + 1);
      if (keep.length == paths[k].length) return;
      ctrl.apply(LinksState([for (var j = 0; j < paths.length; j++) j == k ? keep : paths[j]]));
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final paths = _paths;
    final owner = List<int>.filled(p.rows * p.cols, -1);
    for (var k = 0; k < paths.length; k++) {
      for (final i in paths[k]) {
        owner[i] = k;
      }
    }
    final errors = ctrl.errorCells;
    return CellGridBoard(
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
        Positioned.fill(child: CustomPaint(
            painter: _LinksPainter(paths: paths, m: m, dots: p.dots, style: Theme.of(context).textTheme.bodyMedium!),
          )),
      ],
      cellBuilder: (context, pos, m) {
        final i = p.size.index(pos);
        final k = owner[i];
        final hinted = ctrl.flashHints.contains(pos);
        return Container(
          decoration: BoxDecoration(
            color: k >= 0
                ? LinksType.colorOf(k).withValues(alpha: 0.22)
                : scheme.surfaceContainer.withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(m.cell * 0.12),
            border: Border.all(
              color: errors.contains(pos)
                  ? scheme.error
                  : hinted
                      ? scheme.tertiary
                      : scheme.outlineVariant.withValues(alpha: 0.5),
              width: errors.contains(pos) || hinted ? 2.5 : 1,
            ),
          ),
        );
      },
    );
  }
}

class _LinksPainter extends CustomPainter {
  _LinksPainter({required this.paths, required this.m, required this.dots, required this.style});

  final List<List<int>> paths;
  final BoardMetrics m;
  final List<int> dots;
  final TextStyle style;

  Offset _at(int i) => m.center(Pos(i ~/ m.cols, i % m.cols));

  @override
  void paint(Canvas canvas, Size size) {
    for (var k = 0; k < paths.length; k++) {
      final path = paths[k];
      if (path.length < 2) continue;
      final line = Path()..moveTo(_at(path.first).dx, _at(path.first).dy);
      for (final i in path.skip(1)) {
        line.lineTo(_at(i).dx, _at(i).dy);
      }
      canvas.drawPath(
        line,
        Paint()
          ..color = LinksType.colorOf(k)
          ..style = PaintingStyle.stroke
          ..strokeWidth = m.cell * 0.3
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round,
      );
    }
    for (var i = 0; i < dots.length; i++) {
      final k = dots[i];
      if (k < 0) continue;
      final c = _at(i);
      canvas.drawCircle(c, m.cell * 0.36, Paint()..color = LinksType.colorOf(k));
      final text = TextPainter(
        text: TextSpan(
          text: '${k + 1}',
          style: style.copyWith(fontSize: m.cell * 0.36, fontWeight: FontWeight.w800, color: Colors.white, height: 1),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      text.paint(canvas, c - Offset(text.width / 2, text.height / 2));
    }
  }

  @override
  bool shouldRepaint(_LinksPainter old) => true;
}
