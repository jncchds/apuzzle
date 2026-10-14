import 'dart:math';

import 'package:flutter/material.dart';

import '../../core/day.dart';
import '../../core/difficulty.dart';
import '../../core/grid.dart';
import '../../core/recall.dart';
import '../../core/tutorial.dart';
import '../../l10n/l10n.dart';
import 'glimpse_tutorial.dart';

/// Glimpse: some cells light up for a moment; tap them all from memory.
/// A round is the list of lit cells; its level is how many.
class GlimpseType extends RecallType {
  const GlimpseType();

  @override
  String get id => 'glimpse';
  @override
  String name(AppLocalizations l) => l.glimpseName;
  @override
  String tagline(AppLocalizations l) => l.glimpseTagline;
  @override
  String rulesText(AppLocalizations l) => l.glimpseRules;
  @override
  IconData get icon => Icons.grid_view_rounded;
  @override
  Color get accent => const Color(0xFF4FB3F0);

  @override
  List<TutorialStep> tutorial() => glimpseTutorial;

  @override
  List<GridSize> get sizes => const [
    GridSize.square(4),
    GridSize.square(5),
    GridSize.square(6),
    GridSize.square(7),
    GridSize.square(8),
  ];
  @override
  GridSize get defaultSize => const GridSize.square(5);
  @override
  GridSize dailySize(Difficulty difficulty) =>
      difficulty == Difficulty.hard ? const GridSize.square(6) : const GridSize.square(5);
  @override
  Day get dailySince => const Day(2026, 10, 15);

  /// From 2 cells up to nearly half the board.
  @override
  (int, int) levels(GridSize size) => (2, max(3, size.rows * size.cols * 9 ~/ 20));

  @override
  int startLevel(Difficulty difficulty) => switch (difficulty) {
    Difficulty.easy => 3,
    Difficulty.medium => 4,
    _ => 5,
  };

  @override
  List<int> makeRound(RecallPuzzle p, int level, Random rng) => recallCells(p, level, rng)..sort();

  @override
  int? showMs(RecallPuzzle p, List<int> round) => p.paced(900 + 200 * round.length);

  @override
  bool accepts(RecallPuzzle p, List<int> round, List<int> taps, int target) => !taps.contains(target);

  @override
  RecallVerdict verdict(RecallPuzzle p, List<int> round, List<int> taps) {
    if (!round.contains(taps.last)) return RecallVerdict.failed;
    return round.every(taps.contains) ? RecallVerdict.passed : RecallVerdict.going;
  }

  @override
  int nextTap(RecallPuzzle p, List<int> round, List<int> taps) => round.firstWhere((c) => !taps.contains(c));

  @override
  String prompt(AppLocalizations l, RecallPuzzle p) => l.glimpsePrompt;

  @override
  void paint(Canvas canvas, RecallView v) {
    final lit = v.round.toSet();
    final taps = v.state.taps.toSet();
    final fade = (v.ms / 160).clamp(0.0, 1.0);
    for (var i = 0; i < v.puzzle.cells; i++) {
      var color = v.tile;
      var wrong = false;
      switch (v.phase) {
        case RecallPhase.show when !v.waiting && lit.contains(i):
          color = Color.lerp(v.tile, v.accent, fade)!;
        case RecallPhase.answer when taps.contains(i):
          color = v.accent;
        case RecallPhase.result:
          if (lit.contains(i)) {
            color = v.state.passed
                ? v.good
                : taps.contains(i)
                ? v.accent
                : Color.lerp(v.tile, v.accent, 0.4)!;
          } else if (taps.contains(i)) {
            color = v.bad;
            wrong = true;
          }
        default:
      }
      canvas.drawRRect(v.tileOf(i), Paint()..color = color);
      if (wrong) v.paintCross(canvas, v.rectOf(i), v.scheme.onError);
    }
  }
}
