import 'package:flutter/material.dart';

import '../../core/explain.dart';
import '../../core/game_controller.dart';
import '../../core/grid.dart';
import 'cell_grid_board.dart';

/// What explain mode marks on a board.
class ExplainView {
  const ExplainView({this.targets = const {}, this.involved = const {}, this.focus = const {}});

  /// The explain-mode marks of [c], or null when the mode is off.
  static ExplainView? of(GameController c) {
    if (!c.explaining) return null;
    final e = c.explanation;
    return ExplainView(targets: e?.targets ?? const {}, involved: e?.involved ?? const {}, focus: c.explainFocus);
  }

  /// Cells the step changes.
  final Set<Pos> targets;

  /// Cells its reason looks at.
  final Set<Pos> involved;

  /// Cells of the line or chip the player tapped.
  final Set<Pos> focus;
}

/// Tints and outlines for [view], to put in a board's stack above the cells.
List<Widget> explainHighlights(BuildContext context, BoardMetrics m, ExplainView view) {
  final color = Theme.of(context).colorScheme.tertiary;
  Widget box(Pos p, {double tint = 0, double border = 0}) {
    final r = m.rectOf(p);
    return Positioned.fromRect(
      rect: r,
      child: IgnorePointer(
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: color.withValues(alpha: tint),
            borderRadius: BorderRadius.circular(m.cell * 0.18),
            border: border > 0 ? Border.all(color: color, width: border) : null,
          ),
        ),
      ),
    );
  }

  return [
    for (final p in view.involved.difference(view.focus)) box(p, tint: 0.3),
    for (final p in view.focus) box(p, tint: 0.5),
    for (final p in view.targets) box(p, tint: 0.1, border: (m.cell * 0.08).clamp(2.0, 4.0)),
  ];
}

/// Column letters above and row numbers left of a board, in a band of
/// [band] px: [child] is laid out at ([band], [band]).
class CoordinateLabels extends StatelessWidget {
  const CoordinateLabels({super.key, required this.m, required this.band, required this.child});

  final BoardMetrics m;
  final double band;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.labelSmall?.copyWith(
      color: Theme.of(context).colorScheme.onSurfaceVariant,
      fontSize: (band * 0.62).clamp(9.0, 13.0),
      height: 1,
    );
    return SizedBox(
      width: m.width + band,
      height: m.height + band,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(left: band, top: band, width: m.width, height: m.height, child: child),
          for (var c = 0; c < m.cols; c++)
            Positioned(
              left: band + m.x(c),
              top: 0,
              width: m.cell,
              height: band,
              child: Center(child: Text(colName(c), style: style)),
            ),
          for (var r = 0; r < m.rows; r++)
            Positioned(
              left: 0,
              top: band + m.y(r),
              width: band,
              height: m.cell,
              child: Center(child: Text('${r + 1}', style: style)),
            ),
        ],
      ),
    );
  }

  /// Band size for a board of [rows] × [cols] in [space].
  static double bandFor(Size space, int rows, int cols) =>
      (space.shortestSide / (rows > cols ? rows : cols) * 0.42).clamp(12.0, 20.0).floorToDouble();
}
