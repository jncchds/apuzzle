import 'dart:math';

import 'package:flutter/material.dart';

import '../../core/day.dart';
import '../../core/difficulty.dart';
import '../../core/grid.dart';
import '../../core/puzzle_type.dart';
import '../../core/recall.dart';
import '../../core/tutorial.dart';
import '../../l10n/l10n.dart';
import 'hopper_tutorial.dart';

/// Hopper: a frog hops from pad to pad, one jump at a time; then tap the
/// pads it landed on, in order (or backwards, an option). A round is the
/// pads in jump order (never the same pad twice in a row); its level is the
/// number of jumps.
class HopperType extends RecallType {
  const HopperType();

  @override
  String get id => 'hopper';
  @override
  String name(AppLocalizations l) => l.hopperName;
  @override
  String tagline(AppLocalizations l) => l.hopperTagline;
  @override
  String rulesText(AppLocalizations l) => l.hopperRules;
  @override
  IconData get icon => Icons.timeline_rounded;
  @override
  Color get accent => const Color(0xFF52B86A);

  @override
  List<TutorialStep> tutorial() => hopperTutorial;

  @override
  List<GridSize> get sizes => const [GridSize.square(3), GridSize.square(4), GridSize.square(5), GridSize.square(6)];
  @override
  GridSize get defaultSize => const GridSize.square(4);
  @override
  GridSize dailySize(Difficulty difficulty) =>
      difficulty == Difficulty.hard ? const GridSize.square(5) : const GridSize.square(4);
  @override
  Day get dailySince => const Day(2026, 10, 15);

  @override
  List<GameOption> get extraOptions => const [
    GameOption('order', ['fwd', 'rev']),
  ];

  @override
  String optionLabel(AppLocalizations l, String option) =>
      option == 'order' ? l.hopperOrder : super.optionLabel(l, option);

  @override
  String choiceLabel(AppLocalizations l, String option, String choice) => switch (choice) {
    'fwd' => l.hopperForward,
    'rev' => l.hopperReverse,
    _ => super.choiceLabel(l, option, choice),
  };

  @override
  String? choiceDescription(AppLocalizations l, String option, String choice) => switch (choice) {
    'fwd' => l.hopperForwardHint,
    'rev' => l.hopperReverseHint,
    _ => super.choiceDescription(l, option, choice),
  };

  /// From 2 jumps up to 16 (fewer on a small board).
  @override
  (int, int) levels(GridSize size) => (2, min(16, size.rows * size.cols + 3));

  @override
  int startLevel(Difficulty difficulty) => switch (difficulty) {
    Difficulty.easy => 3,
    Difficulty.medium => 4,
    _ => 5,
  };

  @override
  List<int> makeRound(RecallPuzzle p, int level, Random rng) {
    final out = <int>[];
    while (out.length < level) {
      final c = rng.nextInt(p.cells);
      if (out.isEmpty || out.last != c) out.add(c);
    }
    return out;
  }

  /// Milliseconds per jump.
  static int jumpMs(RecallPuzzle p) => p.paced(650);

  @override
  int? showMs(RecallPuzzle p, List<int> round) => jumpMs(p) * round.length + 400;
  @override
  bool get hasReady => false;

  /// Backwards play reverses the order.
  static bool reversed(RecallPuzzle p) => p.variant.split('.').contains('rev');

  /// The pads to tap, in order.
  static List<int> expected(RecallPuzzle p, List<int> round) => reversed(p) ? round.reversed.toList() : round;

  @override
  bool accepts(RecallPuzzle p, List<int> round, List<int> taps, int target) => true;

  @override
  RecallVerdict verdict(RecallPuzzle p, List<int> round, List<int> taps) {
    final want = expected(p, round);
    if (taps.last != want[taps.length - 1]) return RecallVerdict.failed;
    return taps.length == want.length ? RecallVerdict.passed : RecallVerdict.going;
  }

  @override
  int nextTap(RecallPuzzle p, List<int> round, List<int> taps) => expected(p, round)[taps.length];

  @override
  String watchText(AppLocalizations l, RecallPuzzle p) => l.hopperWatch;
  @override
  String prompt(AppLocalizations l, RecallPuzzle p) => reversed(p) ? l.hopperPromptReverse : l.hopperPrompt;

  @override
  void paint(Canvas canvas, RecallView v) {
    final p = v.puzzle;
    final round = v.round;
    final taps = v.state.taps;
    final pad = Color.lerp(v.tile, v.accent, 0.12)!;
    final glow = Color.lerp(v.tile, v.accent, 0.7)!;
    final colors = List<Color>.filled(p.cells, pad);
    final marks = <int, List<String>>{};
    int? cross, ring;
    Offset? frog;
    var lift = 0.0;

    switch (v.phase) {
      case RecallPhase.show when !v.waiting:
        final step = jumpMs(p).toDouble();
        final k = min(round.length - 1, v.ms ~/ step);
        final f = ((v.ms - k * step) / (step * 0.4)).clamp(0.0, 1.0);
        final curve = Curves.easeInOut.transform(f);
        if (k == 0) {
          frog = v.centerOf(round[0]);
          lift = 1 - f;
        } else {
          frog = Offset.lerp(v.centerOf(round[k - 1]), v.centerOf(round[k]), curve);
          lift = sin(pi * f);
        }
        if (f >= 1) colors[round[k]] = glow;
      case RecallPhase.answer when taps.isNotEmpty:
        colors[taps.last] = glow;
        frog = v.centerOf(taps.last);
      case RecallPhase.result:
        final want = expected(p, round);
        for (var k = 0; k < want.length; k++) {
          (marks[want[k]] ??= []).add('${k + 1}');
        }
        for (var k = 0; k < taps.length; k++) {
          colors[taps[k]] = v.state.passed || k < taps.length - 1 ? v.good : v.bad;
        }
        if (!v.state.passed) {
          cross = taps.last;
          ring = want[taps.length - 1];
        }
      default:
    }

    for (var i = 0; i < p.cells; i++) {
      final c = v.centerOf(i);
      canvas.drawCircle(c, v.cell * 0.42, Paint()..color = colors[i]);
      // A notch, so the pads read as lily pads.
      final notch = Path()
        ..moveTo(c.dx, c.dy)
        ..lineTo(c.dx + v.cell * 0.44, c.dy - v.cell * 0.07)
        ..lineTo(c.dx + v.cell * 0.44, c.dy + v.cell * 0.02)
        ..close();
      canvas.drawPath(notch, Paint()..color = v.scheme.surface);
    }
    for (final e in marks.entries) {
      v.paintText(
        canvas,
        e.value.join(' '),
        v.rectOf(e.key),
        v.scheme.onSurface,
        size: e.value.length > 1 ? 0.28 : 0.4,
      );
    }
    if (ring != null) {
      canvas.drawCircle(
        v.centerOf(ring),
        v.cell * 0.44,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = v.cell * 0.06
          ..color = v.good,
      );
    }
    if (cross != null) v.paintCross(canvas, v.rectOf(cross).deflate(v.cell * 0.2), v.scheme.onError);
    if (frog != null) _paintFrog(canvas, v, frog, 1 + 0.25 * lift);
  }

  void _paintFrog(Canvas canvas, RecallView v, Offset at, double scale) {
    final r = v.cell * 0.24 * scale;
    final body = Color.lerp(v.accent, Colors.black, 0.15)!;
    canvas.drawCircle(at + Offset(0, r * 0.15), r, Paint()..color = body);
    for (final s in [-1.0, 1.0]) {
      final eye = at + Offset(s * r * 0.55, -r * 0.6);
      canvas.drawCircle(eye, r * 0.36, Paint()..color = body);
      canvas.drawCircle(eye, r * 0.24, Paint()..color = Colors.white);
      canvas.drawCircle(eye + Offset(0, r * 0.05), r * 0.12, Paint()..color = const Color(0xFF1B2230));
    }
  }
}
