import 'dart:math';

import 'package:flutter/material.dart';

import '../../core/day.dart';
import '../../core/difficulty.dart';
import '../../core/game_controller.dart';
import '../../core/grid.dart';
import '../../core/puzzle_type.dart';
import '../../core/tutorial.dart';
import '../../l10n/l10n.dart';
import '../../ui/board/cell_grid_board.dart';
import 'homeward_generator.dart';
import 'homeward_model.dart';
import 'homeward_solver.dart';
import 'homeward_tutorial.dart';

/// Drive the car along the roads: pick up every pet and bring it home
/// before the fuel runs out.
class HomewardType extends PuzzleType<HomewardPuzzle, HomewardState> {
  const HomewardType();

  static const carColor = Color(0xFFEF8F4F);

  /// One symbol and one color per pet (its home has the same).
  static const petIcons = [
    Icons.pets,
    Icons.cruelty_free,
    Icons.pest_control_rodent,
    Icons.emoji_nature,
    Icons.set_meal,
    Icons.bug_report,
  ];
  static const petColors = [
    Color(0xFFE0605A),
    Color(0xFF6FE8C4),
    Color(0xFF5B8DEF),
    Color(0xFFFFC15E),
    Color(0xFFB57EDC),
    Color(0xFFF28DB2),
  ];

  @override
  String get id => 'homeward';
  @override
  String name(AppLocalizations l) => l.homewardName;
  @override
  String tagline(AppLocalizations l) => l.homewardTagline;
  @override
  IconData get icon => Icons.directions_car_rounded;
  @override
  Color get accent => carColor;

  @override
  String rulesText(AppLocalizations l) => l.homewardRules;

  @override
  List<TutorialStep> tutorial() => homewardTutorial;
  @override
  List<TutorialStep> strategies() => homewardStrategies;

  @override
  List<GridSize> get sizes => [
    for (final n in [5, 6, 7, 8, 9, 10]) GridSize.square(n),
  ];
  @override
  GridSize get defaultSize => const GridSize.square(7);
  @override
  GridSize dailySize(Difficulty difficulty) => switch (difficulty) {
    Difficulty.easy => const GridSize.square(6),
    Difficulty.medium => const GridSize.square(7),
    _ => const GridSize.square(8),
  };
  @override
  Day get dailySince => const Day(2026, 10, 15);
  @override
  double get minCellSize => 36;
  @override
  double get controlsHeight => 110;
  @override
  bool get showSubmit => false;

  @override
  HomewardPuzzle generate(GenParams params) => generateHomeward(params);
  @override
  HomewardState initialState(HomewardPuzzle puzzle) => HomewardState([puzzle.start]);

  @override
  bool isComplete(HomewardPuzzle puzzle, HomewardState state) =>
      HomewardTrip.of(puzzle, state.route).allHome(puzzle.petCount);
  @override
  bool isSolved(HomewardPuzzle puzzle, HomewardState state) => homewardSolved(puzzle, state.route);
  @override
  Set<Pos> conflicts(HomewardPuzzle puzzle, HomewardState state) => const {};

  /// The next road of a shortest plan. If the fuel left can't bring every pet
  /// home any more, the car first goes back to the last point of its drive
  /// from where it still can.
  @override
  HintResult<HomewardState>? hint(HomewardPuzzle puzzle, HomewardState state) {
    final solver = HomewardSolver(puzzle);
    final route = state.route;
    if (HomewardTrip.of(puzzle, route).allHome(puzzle.petCount)) return null;
    ({int moves, int first})? from(int k) {
      final trip = HomewardTrip.of(puzzle, route.sublist(0, k));
      return solver.solve(route[k - 1], trip.aboard, trip.home, maxMoves: puzzle.limit - (k - 1));
    }

    var k = route.length;
    var next = from(k);
    if (next == null) {
      // Feasible prefixes come first: the longest one by bisection.
      var lo = 1, hi = route.length - 1;
      while (lo < hi) {
        final mid = (lo + hi + 1) ~/ 2;
        if (from(mid) != null) {
          lo = mid;
        } else {
          hi = mid - 1;
        }
      }
      k = lo;
      next = from(k);
      if (next == null) return null;
    }
    final out = HomewardState([...route.sublist(0, k), next.first]);
    return HintResult(out, {puzzle.size.pos(next.first)});
  }

  @override
  Widget buildBoard(BuildContext context, GameController controller) => _HomewardBoard(controller: controller);

  @override
  Widget? buildControls(BuildContext context, GameController ctrl) {
    final p = ctrl.puzzle as HomewardPuzzle;
    final s = ctrl.state as HomewardState;
    final trip = HomewardTrip.of(p, s.route);
    final theme = Theme.of(context);
    final left = p.limit - s.used;
    final empty = left <= 0 && !trip.allHome(p.petCount);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: empty ? theme.colorScheme.error : theme.colorScheme.outline, width: 2),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.local_gas_station_rounded, size: 20, color: empty ? theme.colorScheme.error : null),
              const SizedBox(width: 6),
              Text(
                context.l10n.homewardFuel(left, p.limit),
                style: theme.textTheme.titleMedium?.copyWith(fontFeatures: const [FontFeature.tabularFigures()]),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.directions_car_rounded, color: carColor, size: 28),
            const SizedBox(width: 8),
            for (var seat = 0; seat < p.seats; seat++)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: _Seat(pet: seat < trip.seated.length ? trip.seated[seat] : null),
              ),
          ],
        ),
      ],
    );
  }

  @override
  Map<String, dynamic> encodePuzzle(HomewardPuzzle puzzle) => puzzle.toJson();
  @override
  HomewardPuzzle decodePuzzle(Map<String, dynamic> json) => HomewardPuzzle.fromJson(json);
  @override
  Map<String, dynamic> encodeState(HomewardState state) => state.toJson();
  @override
  HomewardState decodeState(Map<String, dynamic> json) => HomewardState.fromJson(json);
}

/// One seat of the car, empty or holding [pet].
class _Seat extends StatelessWidget {
  const _Seat({required this.pet});
  final int? pet;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final k = pet;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 160),
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: k == null ? Colors.transparent : HomewardType.petColors[k],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: k == null ? scheme.outlineVariant : HomewardType.petColors[k], width: 2),
      ),
      child: k == null ? null : Icon(HomewardType.petIcons[k], color: Colors.black87, size: 26),
    );
  }
}

/// Crossings from [from] to [to] along a straight run of roads (not
/// including [from]), or null if they are not in one row or column or a
/// road is missing on the way.
List<int>? _straight(HomewardPuzzle p, int from, int to) {
  if (from == to) return null;
  final fr = from ~/ p.cols, fc = from % p.cols, tr = to ~/ p.cols, tc = to % p.cols;
  if (fr != tr && fc != tc) return null;
  final step = fr == tr ? (tc > fc ? 1 : -1) : (tr > fr ? p.cols : -p.cols);
  final out = <int>[];
  for (var i = from; i != to; i += step) {
    if (!p.joined(i, i + step)) return null;
    out.add(i + step);
  }
  return out;
}

class _HomewardBoard extends StatefulWidget {
  const _HomewardBoard({required this.controller});
  final GameController controller;

  @override
  State<_HomewardBoard> createState() => _HomewardBoardState();
}

class _HomewardBoardState extends State<_HomewardBoard> {
  /// A drag is under way: its later moves join its first undo step.
  bool _dragging = false;
  bool _dragMoved = false;

  GameController get ctrl => widget.controller;
  HomewardPuzzle get p => ctrl.puzzle as HomewardPuzzle;
  HomewardState get s => ctrl.state as HomewardState;

  /// Drives to [pos] along a straight road; false if it can't go there.
  bool _drive(Pos pos, {bool merge = false, bool quiet = false}) {
    if (ctrl.solved) return false;
    final run = _straight(p, s.car, p.size.index(pos));
    if (run == null) return false;
    final left = p.limit - s.used;
    if (left <= 0) {
      if (!quiet) ctrl.showToast((l) => l.homewardOutOfFuel);
      return false;
    }
    final route = [...s.route, ...run.take(left)];
    ctrl.apply(HomewardState(route), merge: merge);
    final after = ctrl.state as HomewardState;
    if (!ctrl.solved && after.used >= p.limit) ctrl.showToast((l) => l.homewardOutOfFuel);
    return true;
  }

  void _dragStart(Pos pos) {
    _dragging = true;
    _dragMoved = pos != p.size.pos(s.car) && _drive(pos);
  }

  void _dragUpdate(Pos? pos) {
    if (!_dragging || pos == null || pos == p.size.pos(s.car)) return;
    if (_drive(pos, merge: _dragMoved, quiet: true)) _dragMoved = true;
  }

  void _dragEnd() {
    _dragging = false;
    _dragMoved = false;
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final trip = HomewardTrip.of(p, s.route);
    final petAt = spotsOf(p.rows * p.cols, p.pets), homeAt = spotsOf(p.rows * p.cols, p.homes);
    return CellGridBoard(
      rows: p.rows,
      cols: p.cols,
      gapRatio: 0,
      maxCell: 72,
      win: ctrl.winAnimation,
      onTap: ctrl.solved ? null : (pos) => _drive(pos),
      onDragStart: ctrl.solved ? null : (pos, _) => _dragStart(pos),
      onDragUpdate: (pos, _) => _dragUpdate(pos),
      onDragEnd: _dragEnd,
      underlayBuilder: (context, m) => [
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: scheme.surfaceContainer,
              borderRadius: BorderRadius.circular(m.cell * 0.12),
            ),
          ),
        ),
        Positioned.fill(
          child: CustomPaint(
            painter: _RoadPainter(
              puzzle: p,
              route: s.route,
              m: m,
              road: scheme.outlineVariant,
              trail: HomewardType.carColor,
            ),
          ),
        ),
      ],
      overlayBuilder: (context, m) {
        final c = m.topLeft(p.size.pos(s.car));
        final size = m.cell * 0.62;
        return [
          AnimatedPositioned(
            duration: const Duration(milliseconds: 140),
            curve: Curves.easeOut,
            left: c.dx + (m.cell - size) / 2,
            top: c.dy + (m.cell - size) / 2,
            width: size,
            height: size,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: HomewardType.carColor,
                shape: BoxShape.circle,
                border: Border.all(color: scheme.surface, width: max(1.5, m.cell * 0.04)),
                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.3), blurRadius: m.cell * 0.08)],
              ),
              child: Icon(Icons.directions_car_rounded, size: size * 0.66, color: Colors.black87),
            ),
          ),
        ];
      },
      cellBuilder: (context, pos, m) {
        final i = p.size.index(pos);
        final hinted = ctrl.flashHints.contains(pos);
        final pet = petAt[i], home = homeAt[i];
        Widget? child;
        if (pet >= 0 && trip.status(pet) == PetStatus.waiting) {
          child = _PetMark(pet: pet, size: m.cell * 0.74);
        } else if (home >= 0) {
          child = _HomeMark(pet: home, size: m.cell * 0.8, done: trip.status(home) == PetStatus.home);
        }
        return Container(
          decoration: BoxDecoration(
            color: hinted ? scheme.tertiary.withValues(alpha: 0.3) : Colors.transparent,
            borderRadius: BorderRadius.circular(m.cell * 0.2),
          ),
          alignment: Alignment.center,
          child: child,
        );
      },
    );
  }
}

/// A waiting pet: its symbol on a disc of its color.
class _PetMark extends StatelessWidget {
  const _PetMark({required this.pet, required this.size});
  final int pet;
  final double size;

  @override
  Widget build(BuildContext context) => Container(
    width: size,
    height: size,
    decoration: BoxDecoration(color: HomewardType.petColors[pet], shape: BoxShape.circle),
    child: Icon(HomewardType.petIcons[pet], size: size * 0.62, color: Colors.black87),
  );
}

/// A pet's home: a house outline holding its symbol, filled in once the pet
/// is back.
class _HomeMark extends StatelessWidget {
  const _HomeMark({required this.pet, required this.size, required this.done});
  final int pet;
  final double size;
  final bool done;

  @override
  Widget build(BuildContext context) {
    final color = HomewardType.petColors[pet];
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _HousePainter(color: color, filled: done, stroke: max(2.0, size * 0.07)),
        child: Padding(
          padding: EdgeInsets.only(top: size * 0.36),
          child: Icon(
            HomewardType.petIcons[pet],
            size: size * 0.4,
            color: done ? Colors.black87 : color,
          ),
        ),
      ),
    );
  }
}

class _HousePainter extends CustomPainter {
  _HousePainter({required this.color, required this.filled, required this.stroke});
  final Color color;
  final bool filled;
  final double stroke;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width, h = size.height, s = stroke / 2;
    final house = Path()
      ..moveTo(w / 2, s)
      ..lineTo(w - s, h * 0.4)
      ..lineTo(w * 0.88, h * 0.4)
      ..lineTo(w * 0.88, h - s)
      ..lineTo(w * 0.12, h - s)
      ..lineTo(w * 0.12, h * 0.4)
      ..lineTo(s, h * 0.4)
      ..close();
    if (filled) canvas.drawPath(house, Paint()..color = color);
    canvas.drawPath(
      house,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = stroke
        ..strokeJoin = StrokeJoin.round,
    );
  }

  @override
  bool shouldRepaint(_HousePainter old) => old.color != color || old.filled != filled || old.stroke != stroke;
}

/// Roads between crossings, and the route driven so far on top.
class _RoadPainter extends CustomPainter {
  _RoadPainter({
    required this.puzzle,
    required this.route,
    required this.m,
    required this.road,
    required this.trail,
  });

  final HomewardPuzzle puzzle;
  final List<int> route;
  final BoardMetrics m;
  final Color road;
  final Color trail;

  Offset _at(int i) => m.center(Pos(i ~/ puzzle.cols, i % puzzle.cols));

  @override
  void paint(Canvas canvas, Size size) {
    final p = puzzle;
    final roads = Path();
    for (var i = 0; i < p.rows * p.cols; i++) {
      for (final d in [rE, rS]) {
        if (p.roads[i] & d == 0) continue;
        roads
          ..moveTo(_at(i).dx, _at(i).dy)
          ..lineTo(_at(roadStep(i, d, p.rows, p.cols)!).dx, _at(roadStep(i, d, p.rows, p.cols)!).dy);
      }
    }
    Paint line(Color c, double w) => Paint()
      ..color = c
      ..style = PaintingStyle.stroke
      ..strokeWidth = w
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    canvas.drawPath(roads, line(road, m.cell * 0.3));
    if (route.length > 1) {
      final driven = Path()..moveTo(_at(route.first).dx, _at(route.first).dy);
      for (final i in route.skip(1)) {
        driven.lineTo(_at(i).dx, _at(i).dy);
      }
      canvas.drawPath(driven, line(trail.withValues(alpha: 0.8), m.cell * 0.09));
    }
  }

  @override
  bool shouldRepaint(_RoadPainter old) =>
      old.route != route || old.m.cell != m.cell || old.road != road || old.puzzle != puzzle;
}
