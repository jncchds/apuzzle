import 'dart:math';

import 'package:flutter/material.dart';

import '../../core/day.dart';
import '../../core/difficulty.dart';
import '../../core/grid.dart';
import '../../core/recall.dart';
import '../../core/tutorial.dart';
import '../../l10n/l10n.dart';
import 'rebound_tutorial.dart';

/// Where a ball goes: the slot it leaves by, the cells it crosses (from the
/// entry slot to the exit slot, as (row, column), rows and columns -1 or
/// rows/cols being the edge slots) and how many bumpers turned it.
typedef ReboundRun = ({int exit, List<(int, int)> path, int hits});

/// Rebound: bumpers sit on the grid, a ball waits at an edge; the bumpers
/// hide, and the player taps the edge slot where the ball will leave.
///
/// Edge slots are numbered clockwise from the top: top columns 0..cols-1,
/// right rows, bottom columns, left rows. A round is `[entry slot, bumpers]`,
/// each bumper `cell * 2 + kind` (0 = `/`, 1 = `\`); its level is the number
/// of bumpers.
class ReboundType extends RecallType {
  const ReboundType();

  @override
  String get id => 'rebound';
  @override
  String name(AppLocalizations l) => l.reboundName;
  @override
  String tagline(AppLocalizations l) => l.reboundTagline;
  @override
  String rulesText(AppLocalizations l) => l.reboundRules;
  @override
  IconData get icon => Icons.call_split_rounded;
  @override
  Color get accent => const Color(0xFFB57BE0);

  @override
  List<TutorialStep> tutorial() => reboundTutorial;

  @override
  List<GridSize> get sizes => const [
    GridSize.square(4),
    GridSize.square(5),
    GridSize.square(6),
    GridSize.square(7),
    GridSize.square(8),
  ];
  @override
  GridSize get defaultSize => const GridSize.square(6);
  @override
  GridSize dailySize(Difficulty difficulty) => switch (difficulty) {
    Difficulty.easy => const GridSize.square(5),
    Difficulty.medium => const GridSize.square(6),
    _ => const GridSize.square(7),
  };
  @override
  Day get dailySince => const Day(2026, 10, 15);

  /// The edge slots take room around the grid.
  @override
  double get frame => 0.8;
  @override
  double get minCellSize => 42;

  /// From 1 bumper up to a third of the board (at most 14).
  @override
  (int, int) levels(GridSize size) => (1, min(14, size.rows * size.cols ~/ 3));

  @override
  int startLevel(Difficulty difficulty) => switch (difficulty) {
    Difficulty.easy => 2,
    Difficulty.medium => 3,
    _ => 4,
  };

  /// Random bumpers and entry, kept when the ball meets enough of them
  /// (about two thirds); else the try where it met the most.
  @override
  List<int> makeRound(RecallPuzzle p, int level, Random rng) {
    final need = min(level, max(1, (level * 2 + 2) ~/ 3));
    List<int>? best;
    var bestHits = -1;
    for (var attempt = 0; attempt < 400; attempt++) {
      final entry = rng.nextInt(2 * (p.rows + p.cols));
      final cells = recallCells(p, level, rng)..sort();
      final round = [entry, for (final c in cells) c * 2 + rng.nextInt(2)];
      final hits = reboundRun(p, round).hits;
      if (hits > bestHits) {
        best = round;
        bestHits = hits;
        if (hits >= need) break;
      }
    }
    return best!;
  }

  @override
  int? showMs(RecallPuzzle p, List<int> round) => p.paced(1400 + 450 * (round.length - 1));

  @override
  int? targetAt(RecallPuzzle p, int r, int c) => reboundSlot(p, r, c);

  @override
  bool accepts(RecallPuzzle p, List<int> round, List<int> taps, int target) => true;

  @override
  RecallVerdict verdict(RecallPuzzle p, List<int> round, List<int> taps) =>
      taps.last == reboundRun(p, round).exit ? RecallVerdict.passed : RecallVerdict.failed;

  @override
  int nextTap(RecallPuzzle p, List<int> round, List<int> taps) => reboundRun(p, round).exit;

  @override
  String prompt(AppLocalizations l, RecallPuzzle p) => l.reboundPrompt;

  @override
  void paint(Canvas canvas, RecallView v) {
    final p = v.puzzle;
    final round = v.round;
    v.paintTiles(canvas);
    final f = frame * v.cell;

    /// The centre of (r, c), slots half a band out.
    Offset point(int r, int c) {
      final x = c < 0
          ? v.origin.dx - f / 2
          : c >= p.cols
          ? v.origin.dx + p.cols * v.cell + f / 2
          : v.origin.dx + (c + 0.5) * v.cell;
      final y = r < 0
          ? v.origin.dy - f / 2
          : r >= p.rows
          ? v.origin.dy + p.rows * v.cell + f / 2
          : v.origin.dy + (r + 0.5) * v.cell;
      return Offset(x, y);
    }

    final run = v.phase == RecallPhase.done ? null : reboundRun(p, round);
    final slots = 2 * (p.rows + p.cols);
    final tapped = v.state.taps.isEmpty ? null : v.state.taps.last;
    for (var s = 0; s < slots; s++) {
      final (r, c) = reboundSlotCell(p, s);
      final horizontal = r < 0 || r >= p.rows;
      final at = point(r, c);
      final rect = Rect.fromCenter(
        center: at,
        width: horizontal ? v.cell * 0.8 : f * 0.75,
        height: horizontal ? f * 0.75 : v.cell * 0.8,
      );
      var color = Color.lerp(v.tile, v.scheme.onSurface, 0.06)!;
      if (v.phase == RecallPhase.result && run != null) {
        if (s == run.exit) color = v.good;
        if (s == tapped && !v.state.passed) color = v.bad;
      }
      canvas.drawRRect(RRect.fromRectAndRadius(rect, Radius.circular(f * 0.3)), Paint()..color = color);
      if (s == tapped && !v.state.passed && v.phase == RecallPhase.result) {
        v.paintCross(canvas, rect, v.scheme.onError);
      }
    }
    if (v.waiting || run == null) return;

    // The ball waits at its entry, an arrow pointing in.
    final (er, ec) = reboundSlotCell(p, round.first);
    final entry = point(er, ec);
    final inward = run.path.length > 1
        ? (point(run.path[1].$1, run.path[1].$2) - entry) / (point(run.path[1].$1, run.path[1].$2) - entry).distance
        : const Offset(0, 1);

    final showBumpers = v.phase == RecallPhase.show || v.phase == RecallPhase.result;
    if (showBumpers) {
      final pen = Paint()
        ..color = v.scheme.onSurface
        ..strokeWidth = v.cell * 0.11
        ..strokeCap = StrokeCap.round;
      for (final b in round.skip(1)) {
        final rect = v.rectOf(b >> 1).deflate(v.cell * 0.2);
        if (b & 1 == 0) {
          canvas.drawLine(rect.bottomLeft, rect.topRight, pen);
        } else {
          canvas.drawLine(rect.topLeft, rect.bottomRight, pen);
        }
      }
    }

    final ball = Paint()..color = v.accent;
    if (v.phase == RecallPhase.result) {
      // The way the ball went, and the ball rolling along it.
      final pts = [for (final (r, c) in run.path) point(r, c)];
      final trail = Path()..moveTo(pts.first.dx, pts.first.dy);
      for (final q in pts.skip(1)) {
        trail.lineTo(q.dx, q.dy);
      }
      canvas.drawPath(
        trail,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = v.cell * 0.08
          ..strokeJoin = StrokeJoin.round
          ..color = v.accent.withValues(alpha: 0.7),
      );
      final pos = (v.t * 1.6).clamp(0.0, 1.0) * (pts.length - 1);
      final k = min(pts.length - 2, pos.floor());
      canvas.drawCircle(Offset.lerp(pts[k], pts[k + 1], pos - k)!, v.cell * 0.17, ball);
    } else {
      canvas.drawCircle(entry, v.cell * 0.17, ball);
      final tip = entry + inward * (f * 0.5 + v.cell * 0.1);
      final side = Offset(-inward.dy, inward.dx) * (v.cell * 0.12);
      final back = tip - inward * (v.cell * 0.16);
      canvas.drawPath(
        Path()
          ..moveTo(tip.dx, tip.dy)
          ..lineTo((back + side).dx, (back + side).dy)
          ..lineTo((back - side).dx, (back - side).dy)
          ..close(),
        ball,
      );
    }
  }
}

/// The edge slot at (r, c) just outside the grid, or null.
int? reboundSlot(RecallPuzzle p, int r, int c) {
  final inRows = r >= 0 && r < p.rows, inCols = c >= 0 && c < p.cols;
  if (r == -1 && inCols) return c;
  if (c == p.cols && inRows) return p.cols + r;
  if (r == p.rows && inCols) return p.cols + p.rows + c;
  if (c == -1 && inRows) return 2 * p.cols + p.rows + r;
  return null;
}

/// Where edge slot [s] lies, as (row, column) just outside the grid.
(int, int) reboundSlotCell(RecallPuzzle p, int s) {
  if (s < p.cols) return (-1, s);
  if (s < p.cols + p.rows) return (s - p.cols, p.cols);
  if (s < 2 * p.cols + p.rows) return (p.rows, s - p.cols - p.rows);
  return (s - 2 * p.cols - p.rows, -1);
}

/// The ball's run in [round]: it enters at the entry slot heading into the
/// grid, and every bumper turns it a quarter turn (`/` sends a ball moving
/// right upward, `\` sends it downward) until it leaves the grid.
ReboundRun reboundRun(RecallPuzzle p, List<int> round) {
  final kinds = {for (final b in round.skip(1)) b >> 1: b & 1};
  var (r, c) = reboundSlotCell(p, round.first);
  var (dr, dc) = r < 0
      ? (1, 0)
      : c >= p.cols
      ? (0, -1)
      : r >= p.rows
      ? (-1, 0)
      : (0, 1);
  final path = [(r, c)];
  var hits = 0;
  // Fixed mirrors can't trap the ball: every run ends at an edge, after
  // crossing each cell at most once each way.
  for (var step = 0; step <= 4 * p.cells + 2; step++) {
    r += dr;
    c += dc;
    path.add((r, c));
    final exit = reboundSlot(p, r, c);
    if (exit != null) return (exit: exit, path: path, hits: hits);
    final kind = kinds[r * p.cols + c];
    if (kind == null) continue;
    hits++;
    (dr, dc) = kind == 0 ? (-dc, -dr) : (dc, dr);
  }
  throw StateError('the ball never left');
}
