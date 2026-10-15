import 'package:flutter/material.dart';

import '../../core/day.dart';
import '../../core/difficulty.dart';
import '../../core/explain.dart';
import '../../core/grid.dart';
import '../../core/tutorial.dart';
import '../../core/value_grid.dart';
import '../../l10n/l10n.dart';
import '../../ui/board/cell_grid_board.dart';
import 'pebbles_explain.dart';
import 'pebbles_generator.dart';
import 'pebbles_model.dart';
import 'pebbles_tutorial.dart';

/// Fill the grid with filled and hollow stones, each kind in one group.
class PebblesType extends ValueGridType<PebblesPuzzle> {
  const PebblesType();

  @override
  String get id => 'pebbles';
  @override
  String name(AppLocalizations l) => l.pebblesName;
  @override
  String tagline(AppLocalizations l) => l.pebblesTagline;
  @override
  IconData get icon => Icons.contrast_rounded;
  @override
  Color get accent => const Color(0xFF9AA8C2);

  @override
  String rulesText(AppLocalizations l) => l.pebblesRules;

  @override
  List<TutorialStep> tutorial() => pebblesTutorial;
  @override
  List<TutorialStep> strategies() => pebblesStrategies;

  @override
  List<GridSize> get sizes => [for (var n = 5; n <= 10; n++) GridSize.square(n)];
  @override
  GridSize get defaultSize => const GridSize.square(6);
  @override
  GridSize dailySize(Difficulty difficulty) => switch (difficulty) {
    Difficulty.easy => const GridSize.square(6),
    Difficulty.medium => const GridSize.square(7),
    _ => const GridSize.square(8),
  };
  @override
  Day get dailySince => const Day(2026, 10, 16);

  @override
  List<ValueSpec> get values => [
    ValueSpec.custom((context, size) => PebbleStone(filled: true, size: size), label: 'filled'),
    ValueSpec.custom((context, size) => PebbleStone(filled: false, size: size), label: 'hollow'),
  ];

  @override
  bool get showLockIcon => false;

  @override
  PebblesPuzzle generate(GenParams params) => generatePebbles(params);

  @override
  bool isSolved(PebblesPuzzle puzzle, ValueGrid state) =>
      state.isFull && pebblesConflicts(puzzle.n, state.toFlat()).isEmpty;

  @override
  Set<Pos> conflicts(PebblesPuzzle puzzle, ValueGrid state) => {
    for (final i in pebblesConflicts(puzzle.n, state.toFlat())) puzzle.size.pos(i),
  };

  @override
  List<Widget> buildOverlayIn(BuildContext context, PebblesPuzzle puzzle, ValueGrid state, BoardMetrics m) => [
    Positioned.fill(
      child: IgnorePointer(
        child: CustomPaint(
          painter: _LinksPainter(
            n: puzzle.n,
            values: state.toFlat(),
            metrics: m,
            color: pebbleInk(context),
          ),
        ),
      ),
    ),
  ];

  @override
  bool get canExplain => true;

  @override
  Explanation? explain(PebblesPuzzle puzzle, ValueGrid state) => explainStep(const PebblesExplainer(), puzzle, state);

  @override
  Map<String, dynamic> encodePuzzle(PebblesPuzzle puzzle) => puzzle.toJson();
  @override
  PebblesPuzzle decodePuzzle(Map<String, dynamic> json) => PebblesPuzzle.fromJson(json);
}

/// The stones' ink: opaque, so links overlapping a stone don't show.
Color pebbleInk(BuildContext context) {
  final scheme = Theme.of(context).colorScheme;
  return Color.alphaBlend(scheme.onSurface.withValues(alpha: 0.85), scheme.surface);
}

const double _radius = 0.36, _stroke = 0.075, _link = 0.1;

/// A filled disc or a ring.
class PebbleStone extends StatelessWidget {
  const PebbleStone({super.key, required this.filled, required this.size});

  final bool filled;
  final double size;

  @override
  Widget build(BuildContext context) {
    final ink = pebbleInk(context);
    return Container(
      width: size * _radius * 2,
      height: size * _radius * 2,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: filled ? ink : null,
        border: filled ? null : Border.all(color: ink, width: size * _stroke),
      ),
    );
  }
}

/// Joins side-by-side stones of a kind: a bar between filled ones, a tube
/// between hollow ones, so the groups show.
class _LinksPainter extends CustomPainter {
  _LinksPainter({required this.n, required this.values, required this.metrics, required this.color});

  final int n;
  final List<int> values;
  final BoardMetrics metrics;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final cell = metrics.cell;
    final fill = Paint()..color = color;
    final line = Paint()
      ..color = color
      ..strokeWidth = cell * _stroke * 0.8;
    final w = cell * _link, edge = cell * (_radius - _stroke * 0.5);
    for (var i = 0; i < n * n; i++) {
      final v = values[i];
      if (v < 0) continue;
      final a = metrics.center(Pos(i ~/ n, i % n));
      for (final j in [if (i % n + 1 < n) i + 1, if (i + n < n * n) i + n]) {
        if (values[j] != v) continue;
        final b = metrics.center(Pos(j ~/ n, j % n));
        final across = j == i + 1;
        if (v == pebbleFilled) {
          canvas.drawRect(Rect.fromPoints(a + _off(across, 0, -w), b + _off(across, 0, w)), fill);
        } else {
          for (final s in [-w, w]) {
            canvas.drawLine(a + _off(across, edge, s), b + _off(across, -edge, s), line);
          }
        }
      }
    }
  }

  /// [along] the link and [side] across it.
  Offset _off(bool across, double along, double side) => across ? Offset(along, side) : Offset(side, along);

  @override
  bool shouldRepaint(_LinksPainter old) => old.metrics != metrics || old.color != color || !_same(old.values, values);

  static bool _same(List<int> a, List<int> b) {
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return a.length == b.length;
  }
}
